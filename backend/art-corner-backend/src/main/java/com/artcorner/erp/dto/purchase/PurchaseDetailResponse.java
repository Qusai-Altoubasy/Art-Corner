package com.artcorner.erp.dto.purchase;

import java.time.LocalDateTime;
import java.util.List;

public record PurchaseDetailResponse(
        Long purchaseId,
        LocalDateTime date,
        Double totalCost,
        List<ItemDetail> items
) {
    public PurchaseDetailResponse(Long purchaseId, LocalDateTime date, Double totalCost) {
        this(purchaseId, date, totalCost, List.of());
    }

    public record ItemDetail(
            String productName,
            Integer quantity,
            Double cost
    ) {}
}