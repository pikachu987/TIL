package com.company.config;

import java.util.Arrays;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.company.AuthFailLogger;
import com.company.AuthenticationService;
import com.company.PasswordChangeService;
import com.company.User;
import com.company.UserRepository;

@Configuration
public class Config_main2 {
	
	@Bean
	public User user1(){
		return new User("user1", "1234");
	}
	
	@Bean(name="user2")
	public User user2(){
		return new User("user2", "12345");
	}
	
	@Bean
	public UserRepository userRepository(){
		UserRepository userRepo = new UserRepository();
		userRepo.setUsers(Arrays.asList(user1(), user2()));
		return userRepo;
	}
	
	@Bean
	public PasswordChangeService pwChange(){
		return new PasswordChangeService(userRepository());
	}
	
	@Bean
	public AuthFailLogger authFailLogger(){
		AuthFailLogger logger = new AuthFailLogger();
		logger.setThreshold(2);
		return logger;
	}
	
	@Bean
	public AuthenticationService authenticationService(){
		AuthenticationService authSvc = new AuthenticationService();
		authSvc.setFailLogger(authFailLogger());
		authSvc.setUserRepository(userRepository());
		return authSvc;
	}
}
