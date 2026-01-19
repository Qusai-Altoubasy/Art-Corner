package com.artcorner.erp.repositories.product;

import com.artcorner.erp.entities.product.Product;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    Optional<Product> findByName(String name);

    List<Product> findAllByOrderByQuantityAsc();

    @Transactional
    int deleteByName(String name);
    
}