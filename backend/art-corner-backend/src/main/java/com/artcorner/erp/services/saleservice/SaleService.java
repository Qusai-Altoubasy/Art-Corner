package com.artcorner.erp.services.saleservice;

import com.artcorner.erp.dto.sales.*;
import com.artcorner.erp.entities.customer.Customer;
import com.artcorner.erp.entities.product.Product;
import com.artcorner.erp.entities.sales.Sale;
import com.artcorner.erp.entities.sales.SaleItem;
import com.artcorner.erp.entities.sales.SaleStatus;
import com.artcorner.erp.exceptions.CustomerNotFoundException;
import com.artcorner.erp.repositories.customer.CustomerRepository;
import com.artcorner.erp.repositories.sales.SaleItemRepository;
import com.artcorner.erp.repositories.sales.SaleRepository;
import com.artcorner.erp.services.pricing.PriceCalculator;
import com.artcorner.erp.services.productservice.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class SaleService {

    private final SaleRepository saleRepository;
    private final ProductService productService;
    private final PriceCalculator priceCalculator;
    private final CustomerRepository customerRepository;
    private final SaleItemRepository saleItemRepository;

    @Transactional
    public SaleSummaryDTO processSale(SaleRequest request) {
        log.info("Processing new sale for customer: {}",
                request.getCustomerId() != null ? "ID " + request.getCustomerId() : request.getCustomerPhone());

        Sale sale = new Sale();
        sale.setDate(LocalDateTime.now());
        sale.setCustomerPhone(request.getCustomerPhone());
        sale.setDeliveryTarget(request.getDeliveryTarget());
        sale.setGomla(request.isGomla());
        sale.setDelivery(request.isDelivery());
        sale.setTotalDiscount(request.getDiscount());
        sale.setDeposit(request.getDeposit());

        if (request.getCustomerId() != null) {
            Customer customer = customerRepository.findById(request.getCustomerId())
                    .orElseThrow(CustomerNotFoundException::new);
            sale.setCustomer(customer);
        }

        List<SaleItem> saleItems = new ArrayList<>();
        double totalInvoiceAmount = 0;
        double totalDesignFees = 0;

        for (SaleRequest.ItemRequest itemDto : request.getItems()) {

            Product prod = productService.getById(itemDto.getProductId());
            //... فحص المخزن ...
            if (prod.getQuantity() < itemDto.getQuantity()) {
                log.error("Stock Failure: Product {} only has {} units, requested {}",
                        prod.getName(), prod.getQuantity(), itemDto.getQuantity());
                throw new RuntimeException("الكمية غير كافية للمنتج: " + prod.getName());
            }
            // ... حساب السعر ...
            double itemTotalPrice;

            if (itemDto.getManualPrice() > 0) {
                itemTotalPrice = (itemDto.getManualPrice() * (itemDto.getQuantity() / 100.0));
            }
            else {
                itemTotalPrice = priceCalculator.calculatePrice(
                        prod,
                        itemDto.getQuantity(),
                        request.isGomla(),
                        itemDto.getGroomName() != null && !itemDto.getGroomName().isEmpty()
                );
            }
            if (request.isGomla() &&
                    itemDto.getGroomName() != null && !itemDto.getGroomName().isEmpty() &&
                    !itemDto.isDesignReady()) {

                totalDesignFees += 1.0;
            }

            totalInvoiceAmount += itemTotalPrice;

            SaleItem item = new SaleItem();
            item.setProduct(prod);
            item.setQuantity(itemDto.getQuantity());
            item.setPrice(itemTotalPrice);
            item.setPurchasePrice(prod.getPurchasePrice() * itemDto.getQuantity() / 100.0);
            item.setGroomName(itemDto.getGroomName());
            item.setSale(sale);

            // ... فحص الحالة ...
            if (item.getGroomName() != null && !item.getGroomName().trim().isEmpty()) {
                if(itemDto.isDesignReady()){
                    item.setStatus(SaleStatus.PRINTING);
                }else{
                    item.setStatus(SaleStatus.DESIGN);
                }
            } else {
                item.setStatus(SaleStatus.READY);
            }

            saleItems.add(item);

            log.info("Updating Stock: Product {} ({} -> {})",
                    prod.getName(), prod.getQuantity(), prod.getQuantity() - itemDto.getQuantity());
            productService.updateProductDetails(
                    prod.getId(),
                    null,
                    prod.getQuantity() - itemDto.getQuantity(),
                    null
            );
        }

        // 3. الحسابات المالية النهائية
        double finalTotal = totalInvoiceAmount + totalDesignFees - request.getDiscount();
        if (request.isDelivery() && !request.isGomla()){
            finalTotal+=3;
            sale.setDeliveryFee(3);
        }
        else {
            sale.setDeliveryFee(0);
        }
        sale.setDesignFee(totalDesignFees);
        sale.setItems(saleItems);
        sale.setTotalAmount(finalTotal);
        sale.setRemainingAmount(finalTotal - request.getDeposit());

        // 4. تحديث رصيد ديون الزبون (إذا كان تاجر جملة)
        if (sale.getCustomer() != null) {
            Customer c = sale.getCustomer();
            log.info("Updating Customer Balance: {} (Old: {}, New: {})",
                    c.getName(), c.getCurrentBalance(), c.getCurrentBalance() + sale.getRemainingAmount());
            c.setCurrentBalance(c.getCurrentBalance() + sale.getRemainingAmount());
            customerRepository.save(c);
        }

        saleRepository.save(sale);
        log.info("Sale Successfully Created! ID: {}, Total: {}, Remaining: {}",
                sale.getId(), sale.getTotalAmount(), sale.getRemainingAmount());

        return new SaleSummaryDTO(
                sale.getId(),
                sale.getDate(),
                sale.getCustomer() != null ? sale.getCustomer().getName() : sale.getCustomerPhone(),
                sale.getTotalAmount(),
                sale.isGomla()
        );
    }

    @Transactional
    public void deleteItem(Long itemId){
        log.warn("CRITICAL: Attempting to delete item ID: {}", itemId);
        SaleItem item = saleItemRepository.findById(itemId)
                .orElseThrow(()->new RuntimeException("الفاتورة غير موجودة"));

        double price = item.getPrice();
        Sale sale = item.getSale();
        if (sale.getCustomer() != null) {
            Customer c = sale.getCustomer();
            log.info("Reversing debt for customer: {}.  Reducing balance by {}",
                    sale.getCustomer().getName(), price);
            c.setCurrentBalance(c.getCurrentBalance() - price);
            customerRepository.save(c);
        }

        sale.setRemainingAmount(sale.getRemainingAmount() - price);
        sale.setTotalAmount(sale.getTotalAmount() - price);

        Product product = item.getProduct();
        productService.updateProductDetails(
                product.getId(),
                null,
                item.getQuantity(),
                null
        );

        saleItemRepository.delete(item);
        log.warn("item ID: {} has been deleted from the system.", itemId);
    }

    @Transactional
    public void deleteSale(Long saleId) {
        log.warn("CRITICAL: Attempting to delete Sale ID: {}", saleId);
        Sale sale = saleRepository.findById(saleId)
                .orElseThrow(() -> new RuntimeException("الفاتورة غير موجودة"));

        if (sale.getCustomer() != null) {
            Customer c = sale.getCustomer();
            log.info("Reversing debt for customer: {}. Reducing balance by {}",
                    sale.getCustomer().getName(), sale.getRemainingAmount());
            c.setCurrentBalance(c.getCurrentBalance() - sale.getRemainingAmount());
            customerRepository.save(c);
        }

        for (SaleItem item : sale.getItems()) {
            log.info("Restoring stock for product {}: +{}", item.getProduct().getName(), item.getQuantity());
            Product prod = item.getProduct();
            productService.updateProductDetails(
                    prod.getId(),
                    null,
                    prod.getQuantity() + item.getQuantity(),
                    null
            );
        }
        saleRepository.delete(sale);
        log.warn("Sale ID: {} has been deleted from the system.", saleId);
    }

    public List<SaleSummaryDTO> getSalesSummaryByDate(LocalDateTime start, LocalDateTime end) {

        if (start == null) {
            start = LocalDate.now().minusDays(6).atStartOfDay();
        }
        if (end == null) {
            end = LocalDateTime.now();
        }
        return saleRepository.findByDateBetweenOrderByDateDesc(start, end)
                .stream()
                .map(sale -> new SaleSummaryDTO(
                        sale.getId(),
                        sale.getDate(),
                        sale.getCustomer() != null ? sale.getCustomer().getName() : sale.getCustomerPhone(),
                        sale.getTotalAmount(),
                        sale.isGomla()
                ))
                .toList();
    }

    public SaleResponseDTO getSaleResponseById(Long id) {
        Sale sale = saleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("الفاتورة غير موجودة"));

        return mapToResponseDTO(sale);
    }

    private SaleResponseDTO mapToResponseDTO(Sale sale) {
        SaleResponseDTO dto = new SaleResponseDTO();
        dto.setId(sale.getId());
        dto.setDate(sale.getDate());
        dto.setCustomerName(sale.getCustomer() != null ? sale.getCustomer().getName() : sale.getCustomerPhone());
        dto.setCustomerPhone(sale.getCustomerPhone());
        dto.setGomla(sale.isGomla());
        dto.setTotalAmount(sale.getTotalAmount());
        dto.setRemainingAmount(sale.getRemainingAmount());
        dto.setDeposit(sale.getDeposit());
        dto.setDiscount(sale.getTotalDiscount());
        dto.setDeliveryFee(sale.getDeliveryFee());
        dto.setDesignFee(sale.getDesignFee());
        dto.setDeliveryTarget(sale.getDeliveryTarget());

        List<SaleResponseDTO.ItemResponseDTO> itemDTOs = sale.getItems().stream().map(item -> {
            SaleResponseDTO.ItemResponseDTO itemDto = new SaleResponseDTO.ItemResponseDTO();
            itemDto.setProductName(item.getProduct().getName());
            itemDto.setGroomName(item.getGroomName());
            itemDto.setQuantity(item.getQuantity());
            itemDto.setPrice(item.getPrice());
            itemDto.setStatus(item.getStatus().name());
            return itemDto;
        }).toList();

        dto.setItems(itemDTOs);
        return dto;
    }

    @Transactional
    public SaleItem updateItemStatus(Long itemId, SaleStatus newStatus) {
        SaleItem item = saleItemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("الصنف غير موجود"));

        item.setStatus(newStatus);
        return saleItemRepository.save(item);
    }

    @Transactional
    public Sale updateAllItemsStatusInSale(Long saleId, SaleStatus newStatus) {
        Sale sale = saleRepository.findById(saleId)
                .orElseThrow(() -> new RuntimeException("الفاتورة غير موجودة"));

        sale.getItems().forEach(item -> item.setStatus(newStatus));

        return saleRepository.save(sale);
    }

    public List<SaleStatusDTO> getItemsByStatus(SaleStatus status) {
        return saleItemRepository.findByStatusOrderBySaleDateDesc(status).stream()
                .map(item -> {
                    String customerName;
                    String phone;
                    String groomName;
                    Sale sale = item.getSale();

                    if (sale.getCustomer() != null) {
                        customerName = sale.getCustomer().getName();
                        phone = sale.getCustomer().getPhoneNumber();
                    }
                    else  {
                        customerName = null;
                        phone= sale.getCustomerPhone();
                    }

                    groomName = item.getGroomName();

                    return new SaleStatusDTO(
                            item.getId(),
                            sale.getDate(),
                            customerName,
                            groomName,
                            phone,
                            sale.getDeliveryTarget(),
                            item.getStatus(),
                            item.getProduct().getName(),
                            item.getQuantity(),
                            sale.getRemainingAmount()
                    );
                })
                .toList();
    }

    public List<SaleItemSummaryDTO> getSalesItem(Long productId){
        return saleItemRepository.findByProductIdOrderBySaleDateDesc(productId).stream()
                .map(saleItem ->
                     new SaleItemSummaryDTO(
                            saleItem.getSale().getDate(),
                            saleItem.getProduct().getName(),
                            saleItem.getQuantity()
                    )
        ).toList();
    }
}