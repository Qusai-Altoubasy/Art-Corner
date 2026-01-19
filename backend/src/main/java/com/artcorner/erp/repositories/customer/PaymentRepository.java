package com.artcorner.erp.repositories.customer;

import com.artcorner.erp.entities.customer.Customer;
import com.artcorner.erp.entities.customer.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PaymentRepository extends JpaRepository<Payment, Long> {

    List<Payment> findByCustomerOrderByPaymentDateDesc(Customer customer);
}
