### MockMvc 사용

~~~~

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

~~~~

~~~~

@RequestMapping(value="/hello", method=RequestMethod.GET)
public String view2(@RequestParam("name") String name, Model model) {
	if(name.equals("pikachu987")){
		model.addAttribute("hihihi", "aaa");
	}
	return "index";
}

~~~~




#### MockMvc 생성 방법

스프링 MVC를 테스트하려면 가장 먼저 해야 할 작업이 org.springframework.test.web.servlet.MockMvc 객체를 생성하는 것이다.
* WebApplicationContext를 이용해서 생성
* 테스트 하려는 컨트롤러를 이용해서 생성

~~~~

	@Before
	public void setup(){
		//스프링 컨텍스트를 이용해서 MockMvc를 생성한다.
		mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}

~~~~
WebApplicationContext로 생성하는 방법이다. MockMvcBuilders.webAppContextSetup() 메서드는 전달받은 WebApplicationContext를 이용해서 MockMvc를 생성하는데, 이 경우 완전한 스프링 MVC환경을 이용해서 테스트를 실행할 수 있다. ViewResolver를 비롯해 스프링 MVC 환경에 필요한 설정은 @ContextConfiguration 애노테이션으로 지정한 설정에 포함된다.

MockMvc를 생성하는 두 번째 방법은 컨트롤러를 이용해서 생성한다.

~~~~

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
		mockMvc.perform(get("/hello").param("name","pikachu987"))
		//응답결과 200인지 검사
		.andExpect(status().isOk())
		//응답 결과 모델에 이름이 hihihi인 값이 있는지 검사
		.andExpect(model().attributeExists("hihihi"));
	}
}

~~~~

MockMvcBuilders.standaloneSetup() 메서드는 컨트롤러 객체를 전달받아 MockMvc 객체를 생성하며, 테스트 메서드는 전달받은 컨트롤러 객체만을 테스트 대상으로 사용할 수 있다.

##### 필터 설정
스프링 시큐리티 처럼 DispatcherServlet 을 실행하기 전에 특정 필터를 적용해야 한다면 MockMvcBuilders의 addFilter() 메서드를 사용하면 된다.

~~~~

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
public class Test3 {
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
	public void sum() throws Exception{
		mockMvc.perform(get("/hello").param("name","pikachu987"))
		.andExpect(status().isOk())
		.andExpect(model().attributeExists("hihihi"));
	}
}

~~~~


#### 요청 구성

MockMvc 객체를 생성했다면 그 다음은 perform() 메서드를 이용해서 요청을 DispatcherServlet에 전송하는 것이다. perform() 메서드는 RequestBuilder 타입의 인자를 받는데, 이 객체를 직접 생성하기 보다는 스프링 테스트가 제공하는 메서드를 이용해서 RequestBuilder 객체를 생성한다.

org.springframework.test.web.servlet.request.MockMvcRequestBuilders 클래스는 RequestBuilder 를 생성하는데 필요한 다양한 정적 메서드를 제공하고 있다. 이 클래스의 주요 정적 메서드는 GET, POST, PUT, DELETE 요청방식에 해당한다.(options(), patch()메서드도 제공된다.)

* MockHttpServletRequestBuilder get(String urlTemplate, Object... urlVariables)
* MockHttpServletRequestBuilder get(URL uri)
* MockHttpServletRequestBuilder post(String urlTemplate, Object... urlVariables)
* MockHttpServletRequestBuilder post(URL uri)
* MockHttpServletRequestBuilder put(String urlTemplate, Object... urlVariables)
* MockHttpServletRequestBuilder put(URL uri)
* MockHttpServletRequestBuilder delete(String urlTemplate, Object... urlVariables)
* MockHttpServletRequestBuilder delete(URL uri)

위 정적 메서드를 사용할 때는 정적 임포트를 사용해서 코드 가독성을 높인다.

~~~~
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
~~~~

get(), post() 등의 메서드는 MockHttpServletRequestBuilder 객체를 리턴하는데, 이 객체는 요청 파라미터 구성, 헤더 설정, 쿠키 설정 등을 할 수 있는 메서드를 제공하고 있다.

| 메서드 | 설명 |
|---|---|
|param(String name, String... values)|파라미터 이름이 name이고 값이 values인 요청 파라미터를 추가한다.|
|cookie(Cookie... cookies)|요청으로 보낼 쿠키를 지정한다.|
|contentType(MediaType mediaType)|요청 컨텐트 타입을 지정한다.|
|accept(MediaType... mediaTypes)|Accept 헤더의 값을 지정한다.|
|accept(String... mediaTypes)|Accept 헤더의 값을 지정한다.|
|locale(Locale locale)|요청 로케일을 지정한다.|
|header(String anme, Object... values)|이름이 name이고 값이 values인 요청 헤더를 추가한다.|
|headers(HttpHeaders httpHeaders)|HttpHeaders를 이용해서 요청 헤더를 추가한다.|
|content(byte[] content)|몸체 내용을 지정한다.|
|content(String contetn)|몸체 내용을 지정한다. UTF-8을 이용해서 byte배열로 변환한다.|
|contextPath(String contextPath)|컨텍스트 경로를 지정한다.|
|sessionAttr(String name, Object value)| 세션의 속성과 값을 설정한다.|

여기의 모든 메서든느 MockHttpServletRequestBuilder를 다시 리턴한다.

~~~~
	@Test
	public void test1() throws Exception{
		mockMvc.perform(get("/hello.json").contextPath("/spring4").contentType(MediaType.APPLICATION_JSON).content("{\"name\":\"aaa\"}"))
		.andExpect(status().isOk())
		.andExpect(jsonPath("$.code", equalTo("hihi")));
	}
~~~~


contentType() 메서드나 accept() 메서드에 파라미터로 사용되는 org.springframework.http.MediaType클래스는 컨텐트 타입을 위한 몇 가지 상수를 정의하고 있다.

* APPLICATION_FORM_URLENCODED(application/x-www-form-urlencoded)
* MULTIPART_FORM_DATA(multipart/form-data)
* APPLICATION_OCTET_STREAM(application/octet-stream)
* APPLICATION_JSON(application/json)
* APPLICATION_XML(application/xml)
* TEXT_XML(text/xml)
* TEXT_HTML(text/html)
* TEXT_PLAIN(text/plain)

각 상수 뒤에 '_VALUE' 가 붙은 상수는 괄호안에 표기한 String타입의 컨텐트 타입값을 같는다.

