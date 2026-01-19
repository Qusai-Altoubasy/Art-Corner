package com.artcorner.erp.controllers;

import com.artcorner.erp.dto.purchase.PurchaseRequest;
import com.artcorner.erp.dto.purchase.PurchaseResponse;
import com.artcorner.erp.services.purchase.PurchaseService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/purchases")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PurchaseController {

    private final PurchaseService purchaseService;

    @PostMapping
    public ResponseEntity<String> createPurchase(@RequestBody PurchaseRequest request) {
        purchaseService.processPurchase(request);
        return ResponseEntity.ok("تم تسجيل المشتريات وتحديث المخزن بنجاح");
    }

    @GetMapping("/history")
    public List<PurchaseResponse> getHistory(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end
    ) {
        return purchaseService.getPurchasesByDate(start, end);
    }

}