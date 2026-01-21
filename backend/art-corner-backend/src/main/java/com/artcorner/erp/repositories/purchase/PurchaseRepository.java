package com.artcorner.erp.repositories.purchase;


import com.artcorner.erp.dto.purchase.PurchaseDetailResponse;
import com.artcorner.erp.entities.purchase.Purchase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface PurchaseRepository extends JpaRepository<Purchase, Long> {

    @Query("SELECT p.id as id, p.date as date, p.totalCost as totalCost FROM Purchase p ORDER BY p.date DESC")
    List<PurchaseDetailResponse> findByDateBetweenOrderByDateDesc(LocalDateTime start, LocalDateTime end);

    @Query("SELECT p FROM Purchase p JOIN FETCH p.items i JOIN FETCH i.product WHERE p.id = :id")
    Optional<Purchase> findByIdWithDetails(@Param("id") Long id);
}
