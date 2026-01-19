package com.artcorner.erp.services.pricing;

import com.artcorner.erp.entities.product.Product;
import org.springframework.stereotype.Component;

@Component
public class PriceCalculator {

    public double calculatePrice(Product product, int qty, boolean isGomla, boolean isGomlaWithPrint) {
        double p;
        double qtyFactor = qty / 100.0;

        if (isGomla&&!isGomlaWithPrint) {
            p = ((product.getPrice() / 2) * qtyFactor);
        } else if (isGomlaWithPrint&&isGomla) {
            p = (((product.getPrice() / 2) * qtyFactor) + Math.ceil(qtyFactor));
        } else {
            p = (product.getPrice() * qtyFactor);
        }
        return p;
    }
}