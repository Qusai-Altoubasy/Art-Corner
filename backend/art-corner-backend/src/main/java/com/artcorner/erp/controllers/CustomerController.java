package com.artcorner.erp.controllers;

import com.artcorner.erp.dto.customer.CustomerLookupDTO;
import com.artcorner.erp.dto.customer.CustomerStatementDTO;
import com.artcorner.erp.entities.customer.Customer;
import com.artcorner.erp.services.customer.CustomerService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/customers")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class CustomerController {

    private final CustomerService customerService;

    @GetMapping("/lookup")
    public List<CustomerLookupDTO> getLookup() {
        return customerService.getCustomersLookup();
    }

    @GetMapping
    public List<Customer> getAll() {
        return customerService.getAllCustomers();
    }

    @PostMapping
    public ResponseEntity<Customer> addCustomer(@RequestBody Customer customer) {
        return new ResponseEntity<>(customerService.saveCustomer(customer), HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Customer> getById(@PathVariable Long id) {
        return ResponseEntity.ok(customerService.getCustomerById(id));
    }

    @PostMapping("/{id}/pay")
    public ResponseEntity<Customer> pay(@PathVariable Long id, @RequestParam double amount) {
        return ResponseEntity.ok(customerService.payBalance(id, amount));
    }

    @GetMapping("/{id}/transactions")
    public ResponseEntity<CustomerStatementDTO> getTransactions(@PathVariable Long id) {
        return ResponseEntity.ok(customerService.getCustomerStatement(id));
    }

    @GetMapping("/area")
    public List<Customer> getByArea(@RequestParam String area) {
        return customerService.getCustomersByArea(area);
    }

}