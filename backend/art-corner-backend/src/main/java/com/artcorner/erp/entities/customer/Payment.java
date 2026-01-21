package com.artcorner.erp.entities.customer;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "payment")
@Data
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private double amount;
    private LocalDateTime paymentDate;

    @ManyToOne
    @JoinColumn(name = "customer_id")
    private Customer customer;
}