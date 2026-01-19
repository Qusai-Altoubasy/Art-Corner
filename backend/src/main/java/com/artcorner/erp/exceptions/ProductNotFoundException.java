package com.artcorner.erp.exceptions;

public class ProductNotFoundException extends RuntimeException {
    public ProductNotFoundException(String name) {
        super("المنتج غير موجود: " + name);
    }
}