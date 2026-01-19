package com.artcorner.erp.dto.sales;

import com.artcorner.erp.entities.sales.SaleStatus;

import java.time.LocalDateTime;

public record SaleStatusDTO(
        Long saleItemId,
        LocalDateTime date,
        String costumerName,
        String groomName,
        String costumerPhone,
        String deliveryTarget,
        SaleStatus status,
        String productName,
        int qty,
        double price
) {}