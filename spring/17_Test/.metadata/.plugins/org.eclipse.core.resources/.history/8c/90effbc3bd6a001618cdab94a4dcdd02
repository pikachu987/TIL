package com.company;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import config.MvcConfig;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes=MvcConfig.class)
//웹 어플리케이션을 위한 스프링 컨텍스트를 사용하도록 설정
@WebAppConfiguration
public class Test1 {
	//MockMvc를 생성할 때 사용할 스프링 컨텍스트를 자동 주입 받는다.
	@Autowired
	private WebApplicationContext ctx;
	private MockMvc mockMvc;
	
	@Before
	public void setup(){
		//스프링 컨텍스트를 이용해서 MockMvc를 생성한다.
		mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	@Test
	public void sum() throws Exception{
		//Spring MVC에 get방식 요청. 이때 name으로 pikachu987 전송
		mockMvc.perform(get("/hello").param("name","pikachu987"))
		//응답결과 200인지 검사
		.andExpect(status().isOk())
		//응답 결과 모델에 이름이 hihihi인 값이 있는지 검사
		.andExpect(model().attributeExists("hihihi"));
	}
}
