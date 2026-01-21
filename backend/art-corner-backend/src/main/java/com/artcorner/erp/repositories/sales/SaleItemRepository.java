package com.artcorner.erp.repositories.sales;

import com.artcorner.erp.entities.sales.SaleItem;
import com.artcorner.erp.entities.sales.SaleStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SaleItemRepository extends JpaRepository<SaleItem, Long> {

    @Query("SELECT i FROM SaleItem i WHERE i.status = :status ORDER BY i.sale.date DESC")
    List<SaleItem> findByStatusOrderBySaleDateDesc(@Param("status") SaleStatus status);

    @Query("SELECT si FROM SaleItem si JOIN FETCH si.sale JOIN FETCH si.product WHERE si.product.id = :productId ORDER BY si.sale.date DESC")
    List<SaleItem> findByProductIdOrderBySaleDateDesc(Long productId);

}