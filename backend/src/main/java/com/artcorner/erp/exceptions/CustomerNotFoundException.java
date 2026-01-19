package com.artcorner.erp.exceptions;

public class CustomerNotFoundException extends RuntimeException{
    public CustomerNotFoundException(){
        super("الزبون غير موجود");
    }
}
