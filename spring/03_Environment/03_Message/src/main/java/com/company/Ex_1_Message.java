package com.company;

import java.io.IOException;
import java.util.Locale;

import org.springframework.context.support.GenericXmlApplicationContext;

public class Ex_1_Message {
	public static void main(String[] args) throws IOException {
		GenericXmlApplicationContext ctx = new GenericXmlApplicationContext("classpath:message-config.xml");

		System.out.println(ctx.getMessage("hello", null, Locale.getDefault()));
		System.out.println(ctx.getMessage("welcome", new String[] { "김관호" }, Locale.getDefault()));

		System.out.println(ctx.getMessage("hello", null, Locale.ENGLISH));
		System.out.println(ctx.getMessage("welcome", new String[] { "pikachu987" }, Locale.ENGLISH));
		
		ctx.close();
	}
}
