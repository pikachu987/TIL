package com.company;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
public class Test_7 extends Test_6Abstract {
	@Autowired
	private Calculator calculator;
	
	@Test
	public void sum(){
		assertThat(calculator.sum(1,2), equalTo(3L));
	}
	
	@Test
	public void sum2(){
		assertThat(calculator.sum(2,2), equalTo(4L));
	}
	
	@Test
	public void sum3(){
		assertThat(calculator.sum(4,2), equalTo(6L));
	}
}
