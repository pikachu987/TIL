package com.company.main;

import org.springframework.context.support.GenericXmlApplicationContext;

import com.company.application.SelectEmployeeService;

public class MainSelect {
	public static void main(String[] args) {
		GenericXmlApplicationContext ctx = new GenericXmlApplicationContext("classpath:/springconf.xml");
		
		SelectEmployeeService selectService = ctx.getBean(SelectEmployeeService.class);
		selectService.getEmployee(1L);
		
		ctx.close();
		
	}
}
