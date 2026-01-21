    package com.artcorner.erp.controllers;

    import com.artcorner.erp.dto.sales.*;
    import com.artcorner.erp.entities.sales.Sale;
    import com.artcorner.erp.entities.sales.SaleItem;
    import com.artcorner.erp.entities.sales.SaleStatus;
    import com.artcorner.erp.services.saleservice.SaleService;
    import lombok.RequiredArgsConstructor;
    import org.springframework.format.annotation.DateTimeFormat;
    import org.springframework.http.HttpStatus;
    import org.springframework.http.ResponseEntity;
    import org.springframework.web.bind.annotation.*;

    import java.time.LocalDateTime;
    import java.util.List;
    import java.util.Map;

    @RestController
    @RequestMapping("/api/sales")
    @CrossOrigin(origins = "*")
    @RequiredArgsConstructor
    public class SaleController {

        private final SaleService saleService;

        @PostMapping("/create")
        public ResponseEntity<SaleSummaryDTO> createSale(@RequestBody SaleRequest request) {
            return new ResponseEntity<>(saleService.processSale(request), HttpStatus.CREATED);
        }

        @GetMapping("/summary")
        public List<SaleSummaryDTO> getAllSummary(
                @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
                @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end
        ) {
            return saleService.getSalesSummaryByDate(start, end);
        }

        @GetMapping("/{id}")
        public ResponseEntity<SaleResponseDTO> getSaleById(@PathVariable Long id) {
            return ResponseEntity.ok(saleService.getSaleResponseById(id));
        }

        @DeleteMapping("/{id}")
        public ResponseEntity<Map<String, String>> deleteSale(@PathVariable Long id) {
            saleService.deleteSale(id);
            return ResponseEntity.ok(Map.of("message", "تم حذف الفاتورة وإرجاع الكميات بنجاح"));
        }

        @DeleteMapping("/items/{id}")
        public ResponseEntity<Map<String, String>> deleteSaleItem(@PathVariable Long id) {
            saleService.deleteItem(id);
            return ResponseEntity.ok(Map.of("message", "تم حذف المنتج وإرجاع الكميات بنجاح"));
        }

        @PatchMapping("/{id}/status")
        public ResponseEntity<Sale> updateAllItemsStatus(
                @PathVariable Long id,
                @RequestParam SaleStatus status) {
            return ResponseEntity.ok(saleService.updateAllItemsStatusInSale(id, status));
        }

        @PatchMapping("/items/{itemId}/status")
        public ResponseEntity<SaleItem> updateSingleItemStatus(
                @PathVariable Long itemId,
                @RequestParam SaleStatus status) {
            return ResponseEntity.ok(saleService.updateItemStatus(itemId, status));
        }

        @GetMapping("/items/by-status/{status}")
        public ResponseEntity<List<SaleStatusDTO>> getItemsByStatus(@PathVariable SaleStatus status) {
            return ResponseEntity.ok(saleService.getItemsByStatus(status));
        }

        @GetMapping("/sales-item/{productId}")
        public ResponseEntity<List<SaleItemSummaryDTO>> getSalesItem(@PathVariable long productId) {
            return ResponseEntity.ok(saleService.getSalesItem(productId));
        }


    }