package com.company.ex1_static;

import org.springframework.context.support.GenericXmlApplicationContext;

public class Main {

	public static void main(String[] args) {
		GenericXmlApplicationContext ctx = 
				new GenericXmlApplicationContext("classpath:config-ex1_erp.xml");
		ErpClientFactory factory = ctx.getBean("factory", ErpClientFactory.class);
		ErpClient client = factory.create();
		client.connect();
		client.sendPurchaseInfo(new ErpOrderData());
		client.close();
		ctx.close();
	}

}