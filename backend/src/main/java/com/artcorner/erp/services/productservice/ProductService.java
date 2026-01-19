package com.artcorner.erp.services.productservice;

import com.artcorner.erp.dto.product.ProductLookupDTO;
import com.artcorner.erp.entities.product.Product;
import com.artcorner.erp.exceptions.ProductNotFoundException;
import com.artcorner.erp.repositories.product.ProductRepository;
import com.artcorner.erp.services.pricing.PriceCalculator;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import java.util.List;


@Slf4j
@Service
@RequiredArgsConstructor
public class ProductService {

    private final ProductRepository productRepository;
    private final PriceCalculator priceCalculator;

    public List<ProductLookupDTO> getProductsLookup() {
        log.info("Fetching lightweight product lookup list");
        return productRepository.findAll()
                .stream()
                .map(p -> new ProductLookupDTO(p.getId(), p.getName()))
                .toList();
    }

    public List<Product> getAllProducts() {
        log.info("Fetching all products ordered by quantity ascending");
        return productRepository.findAllByOrderByQuantityAsc();
    }

    public Product getById(Long id) {
        log.debug("Searching for product by ID: {}", id);
        return productRepository.findById(id)
                .orElseThrow(()-> new ProductNotFoundException(id.toString()));
    }

    @Transactional
    public Product saveProduct(Product product) {
        log.info("Saving new product: {}", product.getName());
        return productRepository.save(product);
    }

    @Transactional
    public void  deleteById(Long id){
        log.warn("Attempting to delete product with ID: {}", id);

        if (!productRepository.existsById(id)) {
            throw new ProductNotFoundException(id.toString());
        }

        productRepository.deleteById(id);
        log.info("Product with ID {} deleted successfully", id);
    }

    @Transactional
    public Product updateProductDetails(Long id, Double price, Integer quantity, Double purchasePrice) {
        log.info("Updating product details for: {}", id);
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new ProductNotFoundException(id.toString()));

        if (price != null) {
            log.debug("Updating price for {}: {} -> {}", id, product.getPrice(), price);
            product.setPrice(price);
        }
        if (quantity != null) {
            log.debug("Updating quantity for {}: {} -> {}", id, product.getQuantity(), quantity);
            product.setQuantity(quantity);
        }
        if (purchasePrice != null) {
            log.debug("Updating purchase price for {}: {} -> {}", id, product.getPurchasePrice(), purchasePrice);
            product.setPurchasePrice(purchasePrice);
        }

        return productRepository.save(product);
    }

    @Transactional
    public double calculateProductPrice(Long id, int qty, boolean isGomla, boolean isGomlaWithPrint) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new ProductNotFoundException(id.toString()));

        log.info("Calculating price for product: {} with qty: {}", id, qty);
        return priceCalculator.calculatePrice(product, qty, isGomla, isGomlaWithPrint);
    }

}