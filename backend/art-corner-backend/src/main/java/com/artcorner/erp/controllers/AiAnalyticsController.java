package com.artcorner.erp.controllers;

import com.artcorner.erp.dto.Ai.AiQueryRequestDTO;
import com.artcorner.erp.services.Ai.AiAnalyticsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ai/analytics")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor

public class AiAnalyticsController {

    private final AiAnalyticsService aiService;

    @PostMapping("/query")
    public ResponseEntity<String> query(@RequestBody AiQueryRequestDTO request) {
        return ResponseEntity.ok(aiService.interpretQuestion(request));
    }
}
