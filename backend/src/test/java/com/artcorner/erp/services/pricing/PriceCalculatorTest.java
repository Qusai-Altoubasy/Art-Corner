package com.artcorner.erp.services.pricing; // تأكد من الاسم الجديد هنا

import com.artcorner.erp.entities.product.Product;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class PriceCalculatorTest {

    private PriceCalculator priceCalculator;
    private Product testProduct;

    @BeforeEach
    void setUp() {
        priceCalculator = new PriceCalculator();

        testProduct = new Product();
        testProduct.setName("كرت عرس");
        testProduct.setPrice(10.0);
    }

    @Test
    @DisplayName("فحص شراء 100 حبة - المتوقع 10 دنانير")
    void calculate_100Items_ShouldReturnBasicPrice() {
        double result = priceCalculator.calculatePrice(testProduct, 100, false, false);

        assertEquals(10.0, result, "سعر الـ 100 حبة يجب أن يكون نفس سعر المنتج");
    }

    @Test
    @DisplayName("فحص شراء 200 حبة - المتوقع 20 دينار")
    void calculate_200Items_ShouldReturnDoublePrice() {
        // Act
        double result = priceCalculator.calculatePrice(testProduct, 200, false, false);

        // Assert
        assertEquals(20.0, result, "سعر الـ 200 حبة يجب أن يكون ضعف سعر الـ 100");
    }

    @Test
    @DisplayName("فحص شراء 50 حبة - المتوقع 5 دنانير")
    void calculate_50Items_ShouldReturnHalfPrice() {
        // Act
        double result = priceCalculator.calculatePrice(testProduct, 50, false, false);

        // Assert
        assertEquals(5.0, result, "سعر الـ 50 حبة يجب أن يكون نصف السعر الأساسي");
    }
}