package com.artcorner.erp.repositories.sales;

import com.artcorner.erp.entities.customer.Customer;
import com.artcorner.erp.entities.sales.Sale;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface SaleRepository extends JpaRepository<Sale, Long> {
    List<Sale> findByDateBetweenOrderByDateDesc(LocalDateTime start, LocalDateTime end);

    List<Sale> findByCustomerOrderByDateDesc(Customer customer);

}