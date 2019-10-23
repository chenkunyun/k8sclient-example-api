package com.kchen.k8sclient.example.api.controller;

import io.fabric8.kubernetes.api.model.Pod;
import io.fabric8.kubernetes.api.model.PodList;
import io.fabric8.kubernetes.client.Config;
import io.fabric8.kubernetes.client.ConfigBuilder;
import io.fabric8.kubernetes.client.DefaultKubernetesClient;
import io.fabric8.kubernetes.client.KubernetesClient;
import io.fabric8.kubernetes.client.KubernetesClientException;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * @author chenkunyun
 * @date 2019/10/23
 */
@RestController
@RequestMapping("/")
public class HomeController {

    /**
     * https://github.com/fabric8io/kubernetes-client/blob/master/kubernetes-examples/src/main/java/io/fabric8/kubernetes/examples/ListExamples.java
     *
     * @return
     */
    @RequestMapping("")
    public Map<String, Object> home(@RequestParam("master") String master) {

        // 在这个data中放入你想返回的对象
        Map<String, Object> data = new LinkedHashMap<>();

        Config config = new ConfigBuilder().withMasterUrl(master).build();
        try (final KubernetesClient client = new DefaultKubernetesClient(config)) {

            /*System.out.println(
                    client.namespaces().list()
            );*/
            data.put("list", client.namespaces().list());

            /*System.out.println(
                    client.namespaces().withLabel("this", "works").list()
            );*/
            data.put("this_works", client.namespaces().withLabel("this", "works").list());

            System.out.println(
                    client.pods().withLabel("this", "works").list()
            );

            System.out.println(
                    client.pods().inNamespace("test").withLabel("this", "works").list()
            );

            System.out.println(
                    client.pods().inNamespace("test").withName("testing").get()
            );

            /*
             * 	The continue option should be set when retrieving more results from the server.
             * 	Since this value is server defined, clients may only use the continue value from
             * 	a previous query result with identical query parameters (except for the value of
             * 	continue) and the server may reject a continue value it does not recognize.
             */
            PodList podList = client.pods().inNamespace("myproject").list(5, null);
            podList.getItems().forEach((obj) -> { System.out.println(obj.getMetadata().getName()); });

            podList = client.pods().inNamespace("myproject").list(5, podList.getMetadata().getContinue());
            podList.getItems().forEach((obj) -> { System.out.println(obj.getMetadata().getName()); });

            Integer services = client.services().inNamespace("myproject").list(1, null).getItems().size();
            System.out.println(services);
        } catch (KubernetesClientException e) {
            data.put("exception", ExceptionUtils.getStackTrace(e));
        }

        return data;
    }
}
