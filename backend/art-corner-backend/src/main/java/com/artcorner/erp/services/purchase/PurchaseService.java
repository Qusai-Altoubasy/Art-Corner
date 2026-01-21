package com.artcorner.erp.services.purchase;

import com.artcorner.erp.dto.purchase.PurchaseDetailResponse;
import com.artcorner.erp.dto.purchase.PurchaseRequest;
import com.artcorner.erp.entities.product.Product;
import com.artcorner.erp.entities.purchase.Purchase;
import com.artcorner.erp.entities.purchase.PurchaseItem;
import com.artcorner.erp.repositories.purchase.PurchaseRepository;
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
public class PurchaseService {

    private final PurchaseRepository purchaseRepository;
    private final ProductService productService;

    @Transactional
    public void processPurchase(PurchaseRequest request) {
        log.info("Starting new purchase receipt processing...");

        Purchase purchase = new Purchase();
        purchase.setDate(LocalDateTime.now());

        List<PurchaseItem> purchaseItems = new ArrayList<>();
        double totalInvoiceCost = 0;

        for (PurchaseRequest.ItemRequest itemDto : request.items()) {
            Product prod = productService.getById(itemDto.productId());

            productService.updateProductDetails(
                    prod.getId(),
                    null,
                    prod.getQuantity() + itemDto.quantity(),
                    null
            );

            // 3. إنشاء تفاصيل الفاتورة
            PurchaseItem item = new PurchaseItem();
            item.setProduct(prod);
            item.setQuantity(itemDto.quantity());
            item.setPurchase(purchase);
            item.setCost(prod.getPurchasePrice() * itemDto.quantity() / 100.0);

            purchaseItems.add(item);

            totalInvoiceCost += (prod.getPurchasePrice() * itemDto.quantity() / 100.0);

        }

        purchase.setItems(purchaseItems);
        purchase.setTotalCost(totalInvoiceCost);

        purchaseRepository.save(purchase);
        log.info("Purchase invoice saved. ID: {}, Total Cost: {}", purchase.getId(), totalInvoiceCost);
    }

    public List<PurchaseDetailResponse> getPurchasesByDate(LocalDateTime start, LocalDateTime end) {
        if (start == null) {
            start = LocalDate.now().minusDays(7).atStartOfDay();
        }
        if (end == null) {
            end = LocalDateTime.now();
        }
        log.info("Fetching purchases from {} to {}", start, end);
        return purchaseRepository.findByDateBetweenOrderByDateDesc(start, end);
    }

    public PurchaseDetailResponse getPurchaseDetails(Long id){
        log.info("Fetching full details for Purchase ID: {}", id);
        Purchase purchase = purchaseRepository.findByIdWithDetails(id)
                .orElseThrow(()-> new RuntimeException("الفاتورة غير موجودة"));

        List<PurchaseDetailResponse.ItemDetail> items = purchase.getItems().stream()
                .map(item -> new PurchaseDetailResponse.ItemDetail(
                        item.getProduct().getName(),
                        item.getQuantity(),
                        item.getCost()
                )).toList();

        log.info("Retrieved {} items for Purchase ID: {}", items.size(), id);
        return new PurchaseDetailResponse(
                purchase.getId(),
                purchase.getDate(),
                purchase.getTotalCost(),
                items
        );
    }

    @Transactional
    public void deletePurchase(Long id){
        log.warn("Attempting to delete Purchase ID: {}. This will reverse all stock increments.", id);
        Purchase purchase = purchaseRepository.findById(id)
                .orElseThrow(()->new RuntimeException("الفاتورة غير موجودة"));

        for (PurchaseItem item: purchase.getItems()){
            Product product = item.getProduct();
            int newQty = product.getQuantity()- item.getQuantity();
            log.info("Product '{}'. Current: {}, Subtracting: {}, Target: {}",
                    product.getName(), product.getQuantity(), item.getQuantity(), newQty);
            if (newQty<0) throw  new RuntimeException("لا يمكن حذف العملية لأن الكمية الحالية أقل من كمية الشراء");
            productService.updateProductDetails(
              product.getId(),
              null,
                    newQty,
                    null
            );
        }
        purchaseRepository.deleteById(id);
        log.debug("Purchase ID: {} deleted. Stock levels reverted successfully.", id);
    }

}