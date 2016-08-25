package com.company;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import org.junit.Before;
import org.junit.Test;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.servlet.view.InternalResourceViewResolver;


@WebAppConfiguration
public class Test2 {
	private MockMvc mockMvc;
	
	@Before
	public void setup(){
		InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
		viewResolver.setPrefix("/WEB-INF/view/");
		viewResolver.setSuffix(".jsp");
		
		mockMvc = MockMvcBuilders.standaloneSetup(new ViewController())
				.setViewResolvers(viewResolver)
				.build();
	}
	
	@Test
	public void sum() throws Exception{
		//Spring MVC에 get방식 요청. 이때 name으로 pikachu987 전송
		mockMvc.perform(get("/v/hello").param("name","pikachu987"))
		//응답결과 200인지 검사
		.andExpect(status().isOk())
		//응답 결과 모델에 이름이 hihihi인 값이 있는지 검사
		.andExpect(model().attributeExists("hihihi"));
	}
}
