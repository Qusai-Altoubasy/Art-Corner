package com.artcorner.erp.controllers;

import com.artcorner.erp.dto.product.ProductLookupDTO;
import com.artcorner.erp.entities.product.Product;
import com.artcorner.erp.services.productservice.ProductService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @GetMapping("/lookup")
    public List<ProductLookupDTO> getLookup() {
        return productService.getProductsLookup();
    }

    @GetMapping
    public List<Product> getAll() {
        return productService.getAllProducts();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getById(@PathVariable Long id) {
        return ResponseEntity.ok(productService.getById(id));
    }

    @PostMapping
    public Product add(@Valid @RequestBody Product product) {
        return productService.saveProduct(product);
    }

    @GetMapping("/calculate")
    public ResponseEntity<Double> getPrice(@RequestParam Long id,
                           @RequestParam int qty,
                           @RequestParam boolean Gomla,
                           @RequestParam boolean GomlaWithPrint) {

        return ResponseEntity.ok(productService.calculateProductPrice(id, qty, Gomla, GomlaWithPrint));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id){
        productService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}")
    public ResponseEntity<Product> updateProduct(
            @PathVariable Long id,
            @RequestParam(required = false) Double price,
            @RequestParam(required = false) Integer qty,
            @RequestParam(required = false) Double purchasePrice) {

        return ResponseEntity.ok(productService.updateProductDetails(id, price, qty, purchasePrice));
    }
}