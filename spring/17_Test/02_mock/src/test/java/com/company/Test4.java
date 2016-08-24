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
import org.springframework.web.filter.DelegatingFilterProxy;

import config.MvcConfig;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes=MvcConfig.class)
@WebAppConfiguration
public class Test4 {
	@Autowired
	private WebApplicationContext ctx;
	private MockMvc mockMvc;
	
	@Before
	public void setup(){
		DelegatingFilterProxy securityFilter = new DelegatingFilterProxy();
		securityFilter.setBeanName("springSecurityFilterChain");
		securityFilter.setServletContext(ctx.getServletContext());
		
		
		mockMvc = MockMvcBuilders.webAppContextSetup(ctx).addFilter(securityFilter, "/*").build();
	}
	
	@Test
	public void test1() throws Exception{
		mockMvc.perform(get("/hello").param("name","pikachu987"))
		.andExpect(status().isOk())
		.andExpect(model().attributeExists("hihihi"));
	}
}
