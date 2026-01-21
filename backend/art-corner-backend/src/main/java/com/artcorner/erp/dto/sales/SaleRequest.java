package com.artcorner.erp.dto.sales;

import lombok.Data;
import java.util.List;

@Data
public class SaleRequest {

    private List<ItemRequest> items;
    private double discount;//
    private String customerPhone; //
    private String deliveryTarget; //
    private Long customerId; //
    private boolean Gomla; //
    private boolean delivery; //
    private double deposit; //

    @Data
    public static class ItemRequest {
        private Long productId;
        private String groomName;
        private boolean designReady;
        private int quantity;
        private double manualPrice;
    }
}