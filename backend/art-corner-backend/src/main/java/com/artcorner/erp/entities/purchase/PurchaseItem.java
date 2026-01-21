package com.artcorner.erp.entities.purchase;

import com.artcorner.erp.entities.product.Product;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "purchase_item")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PurchaseItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;

    private int quantity;
    private double cost;

    @ManyToOne
    @JoinColumn(name = "purchase_id")
    @JsonIgnore
    private Purchase purchase;
}