package com.kchen.k8sclient.example.api;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;

/**
 * @author chenkunyun
 * @date 2019/10/23
 */
@SpringBootApplication
public class K8sExampleApplication {

    public static void main(String[] args) {

        new SpringApplicationBuilder(K8sExampleApplication.class)
                .web(true)
                .run(args);
    }
}
