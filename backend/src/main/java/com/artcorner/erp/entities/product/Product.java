package com.artcorner.erp.entities.product;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Entity
@Table(name = "products")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    @NotBlank(message = "اسم المنتج لا يمكن أن يكون فارغاً")
    private String name;

    @Min(value = 0, message = "السعر لا يمكن أن يكون أقل من صفر")
    private double price;

    @Min(value = 0, message = "سعر الشراء لا يمكن أن تكون أقل من صفر")
    private double purchasePrice;

    @Min(value = 0, message = "الكمية لا يمكن أن تكون أقل من صفر")
    private int quantity;
}