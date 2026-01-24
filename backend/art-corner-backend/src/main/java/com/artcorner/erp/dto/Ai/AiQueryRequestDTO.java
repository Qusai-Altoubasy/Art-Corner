package com.artcorner.erp.dto.Ai;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class AiQueryRequestDTO {

    private String question;
    private LocalDateTime sentAt;
}
