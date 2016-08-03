package com.company.main;

import org.springframework.context.support.GenericXmlApplicationContext;

import com.company.AuthException;
import com.company.AuthenticationService;
import com.company.PasswordChangeService;
import com.company.main3And4ExFile.Sensor;

public class Main3_ {
	public static void main(String[] args) {
		GenericXmlApplicationContext ctx = new GenericXmlApplicationContext("classpath:config_main3.xml");
		AuthenticationService authSvc = ctx.getBean("authService", AuthenticationService.class);
		runAuthAndCatchAuthEx(authSvc, "user1", "1234");
		runAuthAndCatchAuthEx(authSvc, "user1", "12345");
		runAuthAndCatchAuthEx(authSvc, "user1", "12346");
		System.out.println("change");
		PasswordChangeService pwChange = ctx.getBean(PasswordChangeService.class);
		pwChange.changePassword("user1", "1234", "12345");
		runAuthAndCatchAuthEx(authSvc, "user1", "1234");
		runAuthAndCatchAuthEx(authSvc, "user1", "12345");
		
		Sensor sensor1 = ctx.getBean("sensor1", Sensor.class);
		System.out.println(sensor1.toString());
		
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