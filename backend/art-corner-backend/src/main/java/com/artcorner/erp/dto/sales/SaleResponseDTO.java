package com.artcorner.erp.dto.sales;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class SaleResponseDTO {
    private Long id;
    private LocalDateTime date;
    private String customerName;
    private String customerPhone;
    private String deliveryTarget;
    private boolean gomla;
    private double totalAmount;
    private double remainingAmount;
    private double deposit;
    private double discount;
    private double deliveryFee;
    private double designFee;
    private List<ItemResponseDTO> items;

    @Data
    public static class ItemResponseDTO {
        private String productName;
        private String groomName;
        private int quantity;
        private double price;
        private String status;
    }
}