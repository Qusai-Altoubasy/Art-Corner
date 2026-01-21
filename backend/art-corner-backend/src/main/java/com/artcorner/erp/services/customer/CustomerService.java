package com.artcorner.erp.services.customer;

import com.artcorner.erp.dto.customer.CustomerLookupDTO;
import com.artcorner.erp.dto.customer.CustomerStatementDTO;
import com.artcorner.erp.entities.customer.Customer;
import com.artcorner.erp.entities.customer.Payment;
import com.artcorner.erp.entities.sales.Sale;
import com.artcorner.erp.exceptions.CustomerNotFoundException;
import com.artcorner.erp.repositories.customer.CustomerRepository;
import com.artcorner.erp.repositories.customer.PaymentRepository;
import com.artcorner.erp.repositories.sales.SaleRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class CustomerService {

    private final CustomerRepository customerRepository;
    private final SaleRepository saleRepository;
    private final PaymentRepository paymentRepository;

    public List<CustomerLookupDTO> getCustomersLookup() {
        log.info("Fetching lightweight customer lookup list");
        return customerRepository.findAll()
                .stream()
                .map(c -> new CustomerLookupDTO(c.getId(), c.getName()))
                .toList();
    }

    public Customer saveCustomer(Customer customer) {
        log.info("Adding new customer to the system: {}", customer.getName());
        return customerRepository.save(customer);
    }

    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }

    public Customer getCustomerById(Long id) {
        return customerRepository.findById(id)
                .orElseThrow(CustomerNotFoundException::new);
    }

    @Transactional
    public Customer payBalance(Long customerId, double amount) {
        log.info("Processing payment for customer ID: {}, Amount: {}", customerId, amount);
        Customer customer = getCustomerById(customerId);

        double oldBalance = customer.getCurrentBalance();
        double newBalance = oldBalance - amount;
        customer.setCurrentBalance(newBalance);

        Payment payment = new Payment();
        payment.setAmount(amount);
        payment.setPaymentDate(LocalDateTime.now());
        payment.setCustomer(customer);
        paymentRepository.save(payment);

        log.info("Payment successful. Customer: {}, Old Balance: {}, New Balance: {}",
                customer.getName(), oldBalance, newBalance);

        return customerRepository.save(customer);
    }

    public CustomerStatementDTO getCustomerStatement(Long customerId) {
        log.info("Generating financial statement for customer ID: {}", customerId);
        Customer customer = getCustomerById(customerId);

        List<Sale> sales = saleRepository.findByCustomerOrderByDateDesc(customer);
        List<Payment> payments = paymentRepository.findByCustomerOrderByPaymentDateDesc(customer);

        List<CustomerStatementDTO.TransactionDTO> transactions = new ArrayList<>();

        sales.forEach(sale -> {

            List<String> itemDetails = sale.getItems().stream().map(item -> {
                StringBuilder sb = new StringBuilder();
                sb.append(item.getProduct().getName());
                sb.append(", عدد: ").append(item.getQuantity());

                if (item.getGroomName() != null && !item.getGroomName().trim().isEmpty()) {
                    sb.append(item.getGroomName());
                }
                sb.append(", السعر: ").append(item.getPrice());

                return sb.toString();
            }).collect(Collectors.toList());

            if (sale.getDesignFee() > 0) itemDetails.add("أجور تصميم: " + sale.getDesignFee());
            if (sale.getDeliveryFee() > 0) itemDetails.add("أجور توصيل: " + sale.getDeliveryFee());
            if (sale.getTotalDiscount() > 0) itemDetails.add("خصم: " + sale.getTotalDiscount());

            transactions.add(new CustomerStatementDTO.TransactionDTO(
                    sale.getDate(),
                    "SALE",
                    sale.getTotalAmount(),
                    sale.getId(),
                    "مشتريات",
                    itemDetails
            ));
        });
        payments.forEach(payment -> transactions.add(new CustomerStatementDTO.TransactionDTO(
                payment.getPaymentDate(),
                "PAYMENT",
                payment.getAmount(),
                payment.getId(),
                "دفعة ",
                null
        )));

        transactions.sort(Comparator.comparing(CustomerStatementDTO.TransactionDTO::getDate));

        return new CustomerStatementDTO(
                customer.getName(),
                customer.getCurrentBalance(),
                transactions
        );
    }

    public List<Customer> getCustomersByArea(String area) {
        return customerRepository.findByAddressContaining(area);
    }
}