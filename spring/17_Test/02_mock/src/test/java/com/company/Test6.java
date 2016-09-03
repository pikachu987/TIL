package com.company;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.*;

import org.junit.Before;
import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.servlet.view.InternalResourceViewResolver;


public class Test6 {
	private MockMvc mockMvc;

	@Before
	public void setUp() {
		InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
		viewResolver.setPrefix("/WEB-INF/view/");
		viewResolver.setSuffix(".jsp");

		mockMvc = MockMvcBuilders.standaloneSetup(new HelloController())
				.setViewResolvers(viewResolver)
				.build();
	}

	@Test
	public void testHello() throws Exception {
		mockMvc.perform(get("/hello").param("name", "pikapika"))
		.andExpect(status().isOk())
		.andDo(print())
		.andExpect(view().name("aaaabbbb"))
		.andExpect(model().attributeExists("hello"))
		.andExpect(model().hasNoErrors())
		.andExpect(header().doesNotExist("UAC"));
	}
	
	@Test
	public void testHelloR() throws Exception {
		mockMvc.perform(get("/helloR").param("name", "pikapika"))
		.andExpect(redirectedUrl("/hello"));
	}

	@Test
	public void testHelloJson() throws Exception {
		mockMvc.perform(post("/hello.json")
				.contentType(MediaType.APPLICATION_JSON)
				.content("{\"name\": \"가나다\"}")
				)
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.greeting", equalTo("안녕하세요, 가나다")));
	}
}