package com.artcorner.erp.dto.purchase;

import java.time.LocalDateTime;
import java.util.List;

public record PurchaseResponse(
        Long id,
        LocalDateTime date,
        double totalCost,
        List<ItemResponse> items)
{
    public record ItemResponse(
            Long productId,
            String productName,
            int quantity,
            double costAtTime
    ) {}
}
