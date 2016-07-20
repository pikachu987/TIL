package com.company.main;

import org.springframework.context.support.GenericXmlApplicationContext;

import com.company.AuthException;
import com.company.AuthenticationService;
import com.company.PasswordChangeService;

public class Main1_xml {
	public static void main(String[] args) {
		GenericXmlApplicationContext ctx = new GenericXmlApplicationContext("classpath:config_main1.xml");
		AuthenticationService authSvc = ctx.getBean("authService", AuthenticationService.class);
		runAuthAndCatchAuthEx(authSvc, "user1", "1234");
		runAuthAndCatchAuthEx(authSvc, "user1", "12345");
		runAuthAndCatchAuthEx(authSvc, "user1", "12346");
		System.out.println("change");
		PasswordChangeService pwChange = ctx.getBean(PasswordChangeService.class);
		pwChange.changePassword("user1", "1234", "12345");
		runAuthAndCatchAuthEx(authSvc, "user1", "1234");
		runAuthAndCatchAuthEx(authSvc, "user1", "12345");
		
		ctx.close();
	}
	
	private static void runAuthAndCatchAuthEx(AuthenticationService authSvc, String userId, String pwd){
		try{
			authSvc.authenticate(userId, pwd);
			System.out.printf("Success : userId: %s, pwd: %s \n", userId, pwd);
		}catch(AuthException e){
			
		}
	}
}
