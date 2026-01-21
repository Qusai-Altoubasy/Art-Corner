package com.artcorner.erp.controllers;

import com.artcorner.erp.dto.purchase.PurchaseDetailResponse;
import com.artcorner.erp.dto.purchase.PurchaseRequest;
import com.artcorner.erp.services.purchase.PurchaseService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

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
    public List<PurchaseDetailResponse> getHistory(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end
    ) {
        return purchaseService.getPurchasesByDate(start, end);
    }

    @GetMapping("/{id}/details")
    public ResponseEntity<PurchaseDetailResponse> getPurchaseDetails(@PathVariable Long id) {
        return ResponseEntity.ok(purchaseService.getPurchaseDetails(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> deletePurchase(@PathVariable Long id){
        purchaseService.deletePurchase(id);
        return ResponseEntity.ok(Map.of("message", "تم حذف الفاتورة وتحديث الكميات بنجاح"));
    }

}