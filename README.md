## 使用说明

#### 1. 修改点
- 直接修改这个类
```java
com.kchen.k8sclient.example.api.controller.HomeController
```

- 在data对象中放入你感兴趣的对象(因为这个map的value类型是Object, 所以可以保存任意类型), 比如:
```java
/*
System.out.println(
    client.namespaces().list()
);*/
data.put("list", client.namespaces().list());
```
其中，注释的部分来自于
https://github.com/fabric8io/kubernetes-client/blob/master/kubernetes-examples/src/main/java/io/fabric8/kubernetes/examples/ListExamples.java

#### 2. 运行
- 本地运行
    - 打开 K8sExampleApplication.java, 会发现在main方法旁边有个"可运行"的箭头，直接点击然后
    - 浏览器运行(注意这里的1.1.1.1改成你自己的master) http://localhost:8080/?master=1.1.1.1
    
- 打包运行
    - 打包
    mvn package
    - 把生成的tar放到别的机器
    - cd到bin目录
    - ./start.sh
    - curl命令(注意这里的1.1.1.1改成你自己的master) 
    curl http://localhost:8080/?master=1.1.1.1