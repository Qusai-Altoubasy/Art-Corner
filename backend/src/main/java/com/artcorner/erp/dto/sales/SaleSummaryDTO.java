package com.artcorner.erp.dto.sales;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SaleSummaryDTO {
    private Long id;
    private LocalDateTime date;
    private String customerName;
    private double totalAmount;
    private boolean Gomla;

}