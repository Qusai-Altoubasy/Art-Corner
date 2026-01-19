package com.artcorner.erp.entities.sales;

import com.artcorner.erp.entities.customer.Customer;
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Entity
@Table(name = "sales")
public class Sale {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDateTime date;
    private String customerPhone;
    private String deliveryTarget;

    @ManyToOne
    @JoinColumn(name = "customer_id")
    private Customer customer;

    private boolean isGomla;
    private boolean delivery;

    private double totalAmount;
    private double totalDiscount;
    private double deposit;
    private double remainingAmount;

    private double deliveryFee;
    private double designFee;

    @OneToMany(mappedBy = "sale", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<SaleItem> items;
}