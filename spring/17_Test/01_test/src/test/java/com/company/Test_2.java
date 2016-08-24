package com.company;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;


@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
public class Test_2 {
	@Autowired
	private Calculator calculator;
	
	@Test
	public void sum(){
		assertThat(calculator.sum(1,2), equalTo(3L));
	}
}
