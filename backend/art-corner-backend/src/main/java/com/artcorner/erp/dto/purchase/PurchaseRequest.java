package com.artcorner.erp.dto.purchase;

import java.util.List;

public record PurchaseRequest(
        List<ItemRequest> items
) {
    public record ItemRequest(
            Long productId,
            int quantity
    ) {}
}