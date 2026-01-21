package com.artcorner.erp.dto.sales;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SaleItemSummaryDTO {
    private LocalDateTime date;
    private String productName;
    private int qty;
}
