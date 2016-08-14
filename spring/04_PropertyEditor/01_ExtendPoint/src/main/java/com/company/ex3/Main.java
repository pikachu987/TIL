package com.company.ex3;

import java.util.Date;

import org.springframework.context.support.GenericXmlApplicationContext;

import com.company.ex2.StockReader;

public class Main {
	public static void main(String[] args) {
		GenericXmlApplicationContext ctx = new GenericXmlApplicationContext("classpath:ex3_applicationContext.xml");
		StockReader stockReader = ctx.getBean("stockReader", StockReader.class);
		System.out.println("stockReader = "+stockReader.getClass().getName());
		Date date = new Date();
		int value1 = stockReader.getClosePrice(date, "0000");
		
		
		ctx.close();
	}
}
