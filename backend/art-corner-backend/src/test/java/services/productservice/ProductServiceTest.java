package services.productservice;

import com.artcorner.erp.entities.product.Product;
import com.artcorner.erp.repositories.product.ProductRepository;
import com.artcorner.erp.services.pricing.PriceCalculator;
import com.artcorner.erp.services.productservice.ProductService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ProductServiceTest {

    @Mock
    private ProductRepository productRepository;

    @Mock
    private PriceCalculator priceCalculator;

    @InjectMocks
    private ProductService productService;

    private Product testProduct;

    @BeforeEach
    void setUp() {
        testProduct = new Product();
        testProduct.setName("كرت عرس");
        testProduct.setPrice(10.0);
    }

    @Test
    void whenCalculatePrice_shouldReturnCorrectValue() {
        String productName = "كرت عرس";
        int qty = 100;
        when(productRepository.findByName(productName)).thenReturn(Optional.of(testProduct));
        when(priceCalculator.calculatePrice(testProduct, qty, false, false)).thenReturn(10.0);

        double result = productService.calculateProductPrice(productName, qty, false, false);

        assertEquals(10.0, result);
        verify(productRepository, times(1)).findByName(productName);
        verify(priceCalculator, times(1)).calculatePrice(testProduct, qty, false, false);
    }

    @Test
    void whenProductNotFound_shouldThrowException() {
        when(productRepository.findByName("غير موجود")).thenReturn(Optional.empty());

        assertThrows(RuntimeException.class, () -> {
            productService.calculateProductPrice("غير موجود", 100, false, false);
        });
    }
}