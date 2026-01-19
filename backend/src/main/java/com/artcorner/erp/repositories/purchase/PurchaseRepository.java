package com.artcorner.erp.repositories.purchase;


import com.artcorner.erp.entities.purchase.Purchase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface PurchaseRepository extends JpaRepository<Purchase, Long> {
    List<Purchase> findByDateBetweenOrderByDateDesc(LocalDateTime start, LocalDateTime end);
}
