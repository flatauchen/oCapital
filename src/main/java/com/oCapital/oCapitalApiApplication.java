package com.ocapital;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@SpringBootApplication
@RestController
public class oCapitalApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(oCapitalApiApplication.class, args);
    }

    @GetMapping("/")
    public Map<String, String> healthCheck() {
        return Map.of(
            "status", "UP",
            "app", "oCapital API",
            "versao", "1.0.0"
        );
    }
}