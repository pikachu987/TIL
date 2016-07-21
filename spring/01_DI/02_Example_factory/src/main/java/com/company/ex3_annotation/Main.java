package com.company.ex3_annotation;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;

public class Main {

	public static void main(String[] args) {
		useXmlWithScan();
		useJavaWithScan();
	}

	private static void useXmlWithScan() {
		GenericXmlApplicationContext ctx =
				new GenericXmlApplicationContext("classpath:config-ex3_annotation.xml");
		useContext(ctx);
		ctx.close();
	}

	private static void useJavaWithScan() {
		AnnotationConfigApplicationContext ctx =
				new AnnotationConfigApplicationContext(ConfigScan.class);
		useContext(ctx);
		ctx.close();

	}

	private static void useContext(ApplicationContext ctx) {
		ProductService productService = ctx.getBean("productService", ProductService.class);
		productService.createProduct(new ProductInfo());

		OrderService orderService = ctx.getBean("orderSvc", OrderService.class);
		orderService.order(new OrderInfo());
	}

}
