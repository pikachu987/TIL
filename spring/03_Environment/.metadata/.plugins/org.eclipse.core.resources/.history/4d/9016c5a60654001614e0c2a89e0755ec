package com.company;

import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;
import org.springframework.core.env.ConfigurableEnvironment;

public class Ex_1_Environment {
	public static void main(String[] args) {
		ConfigurableApplicationContext context = new GenericXmlApplicationContext();
		ConfigurableEnvironment env = context.getEnvironment();
		String javaVersion = env.getProperty("java.version");
		System.out.printf("Java version is %s", javaVersion);
	}
}
