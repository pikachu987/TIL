package com.company;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration
public class Test_3 {
	@Autowired
	private Calculator calculator;
	
	@Test
	public void sum(){
		assertThat(calculator.sum(1,2), equalTo(3L));
	}
	
	@Configuration
	public static class Config{
		@Bean
		public Calculator calculator3(){
			return new Calculator();
		}
	}
}