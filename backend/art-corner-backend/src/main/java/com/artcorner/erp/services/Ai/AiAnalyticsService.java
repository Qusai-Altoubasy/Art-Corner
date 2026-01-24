package com.artcorner.erp.services.Ai;

import com.artcorner.erp.dto.Ai.AiQueryRequestDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;

@Slf4j
@Service
@RequiredArgsConstructor
public class AiAnalyticsService {

    @Value("${FASTAPI_URL}")
    private String fastApiUrl;

    public String interpretQuestion(AiQueryRequestDTO request) {
        request.setSentAt(LocalDateTime.now());
        log.info("Sending question to FastAPI at {}: {}", request.getSentAt(), request.getQuestion());

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<AiQueryRequestDTO> entity = new HttpEntity<>(request, headers);

        RestTemplate restTemplate = new RestTemplate();

        try {
            ResponseEntity<String> response = restTemplate.postForEntity(fastApiUrl, entity, String.class);
            log.info("Received response at {}: {}", LocalDateTime.now(), response.getBody());
            return response.getBody();
        } catch (RestClientException e) {
            log.error("Error calling FastAPI: {}", e.getMessage());
            throw new RuntimeException( "Error: Unable to reach AI service at the moment.");
        }
    }
}
