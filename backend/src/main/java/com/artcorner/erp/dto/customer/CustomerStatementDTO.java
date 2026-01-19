package com.artcorner.erp.dto.customer;

import lombok.AllArgsConstructor;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
public class CustomerStatementDTO {
    private String customerName;
    private double currentBalance;
    private List<TransactionDTO> transactions;

    @Data
    @AllArgsConstructor
    public static class TransactionDTO {
        private LocalDateTime date;
        private String type;
        private double amount;
        private Long referenceId;
        private String status;
        private List<String> items;
    }
}