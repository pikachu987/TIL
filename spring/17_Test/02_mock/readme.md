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

####  응답 검증

perform() 메서드를이용해서 요청을 전송하면, 그 결과로 org.springframework.test.web.servlet.ResultActions을 리턴한다. ResultActions은 결과를 검증할 수 있는 andExpect(Result Matcher matcher) 메서드를 제공하고 있다. andExpect()가 요구하는 ResultMatcher는 MockMvcResultMatchers에 정의된 정적 메서드를 이용해서 생성할 수 있다.

~~~~
package com.company;

import static org.hamcrest.Matchers.equalTo;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

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
				.andExpect(model().attributeExists("hello"));
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

~~~~



##### 상태 코드 검증

응답 결과를 검증하기 위해 사용되는 정적 메서드는 status()이다. status()메서드는 StatusResultMatchers 객체를 리턴하며, 이 클래스의 정의된 메서드를 이용해서 응답 상태 코드를 검사할 수 있다.

~~~~
mockMvc.perform(get("/hello").param("name", "pikachu987"))
		.andExpect(status().isOk())
~~~~

isOk() 외에 응답 상태 코드 확인을 위해 StatusResultMatchers 클래스가 제공하는 메서드는 다음과 같다.
| 메서드 | 설명 |
|---|---|
|isOk(), isCreated(), isAccepted()|각각 차례대로 200, 201, 202 응답상태인지 확인|
|isMovedPermanently(), isFound(), isNotModified()|각각 차례대로 301, 302, 304 응답 상태코드인지 확인|
|isBadRequest(), isUnauthorized(), isForbidden(), isNotFound(), isMethodNotAllowed(), isNotAcceptable(), isUnsupportedMediaType()| 각각 차례대로 400, 401, 403, 404, 405, 406, 415 응답 상태코드인지 확인|
| isInternalServerError()|500응답상태코드인지확인|
|is2xxSuccessful(), is3xxRedirection(), is4xxClientError(), is5xxServerError()| 각각 응답코드가 2xx범위 3xx범위 4xx범위 5xx범위인지 확인|
|is(int status) | 응답 상태코드가 status인지 확인|

##### 뷰/리다이렉트 이름 검증

뷰 이름을 검증할 때는 MockMvcresultMatchers.view() 메서드 이용

~~~~
@Test
	public void testHello() throws Exception {
		mockMvc.perform(get("/hello").param("name", "pikapika"))
		.andExpect(status().isOk())
		.andExpect(view().name("aaaabbbb"))
		.andExpect(model().attributeExists("hello"));
	}
~~~~

name() 메서드는 컨트롤러 결과를 보여줄 뷰 이름이 파라미터로 지정한 이름과 같은지 검사한다. 요청 처리 결과가 리다이렉트 응답이라면 redirectedUrl() 메서드를 이용해서 검사할수 있다.

~~~~
@Test
	public void testHelloR() throws Exception {
		mockMvc.perform(get("/helloR").param("name", "pikapika"))
		.andExpect(redirectedUrl("/hello"));
	}
~~~~

redirectedUrlPattern() 메서드를 이용하면 Ant 경로 패턴을 이용해서 리다이렉트 경로를 검사할 수 있다.

##### 모델 확인

컨트롤러에서 생성한 모델을 검사하고 싶다면, MockMvcresultMatchers.model() 메서드를 이용한다.


~~~~
.andExpect(model().attributeExists("hello"));
~~~~

model() 메서드는 ModelResultMatchers 객체를 리턴하는데 이 클래스는 모델 값을 검증하기위해 다음과 같은 메서드를 제공한다.

| 메서드 | 설명 |
|---|---|
|attribute(String name, Object value)|모델name속성의 값이 value인지 검사|
|attribute(String name, Matcher&lt;T&gt; matcher)|모델 name 속성의 값이 Hamcrest의 Matcher 에 매칭 되는지 검사|
|attributeExists(String... names)| 지정한 이름의 모델 속성이 존재하는지 검사|
|attributeDoesNotExist(String... names) |지정한 이름의 모델 송성이 존재하지 않는지 검사|
|attributeErrorCount(String name, int expectedCount) | 지정한 속성에 대해 에러 개수가 지정한 숫자와 같은지 검사|
|attributeHasErrors(final String... names)| 지정한 속성이 에러를 가졌는지 검사|
|attributeHasNoErrors(String... names)|지정한 속성이 에러가 없는지 검사|
|attributeHasFieldErrors(String name, String... fieldNames)|지정한 속성의 특정 필드가 에러를 가졌는지 검사|
|errorCount(int expectedCount)|전체 에러 개수가 지정한 숫자와 같은지 검사|
|hasErrors()|에러를 가졌는지 검사|
|hasNoErrors()|에러가 없는지 검사|

여러 메서드를 사용해야 한다면 다음과 같이 andExpect() 메서드를 여러번 호출한다.
~~~~
.andExpect(model().attributeExists("hello"))
		.andExpect(model().hasNoErrors());
~~~~

##### 헤더 검증

응답 헤더를 검사하고 싶다면, MockMvcresultMatchers.header() 메서드를 사용

~~~~
.andExpect(header().doesNotExist("UAC"));

~~~~
header() 메서드는 HeaderResultMatchres 객체를 리턴하며, 이 클래스는 헤더 검사를 위해 다음의 메서드를 제공한다.

| 메서드 | 설명 |
|---|---|
|doesNotExist(String name) | 지정한 이름을 가진 헤더가 없는지 검사한다.|
|string(String name, String value) | 지정한 이름을 가진 헤더의 값이 value인지 검사한다.|
|string(String name, Matcher&lt;? super String&gt; matcher) | 지정한 이름을 가진 헤더의 값이 Hamcrest Matcher에 매칭되는지 확인한다.|
|longValue(String name, long value) | 지정한 이름을 가진 헤더의 값이 long 타입의 value인지 검사한다.|


##### 쿠키 검증
응답 결과로 생성되는 쿠키를 확인하고 싶다면 MockMvcresultMatchers.cookie() 메서드를 사용한다.
~~~~
.andExcept(cookie().doesNotExist("UAC"));
~~~~
cookie() 메서드는 CookieResultMatchers 객체를 리턴하며, 이 클래스는 쿠키 관련 검사를 위한 메서드를 제공한다.

| 메서드 | 설명 |
|---|---|
|doesNotExist(String name)| 해당 이름을 갖는 쿠키가 응답에 포함되어 있지 않은지 검사한다.|
|exists(String name)|해당 이름을 갖는 쿠키가 응답에 포함되어 있는지 검사한다.|
|value(String name, String expectedValue), value(String name, Matcher&lt;? super String&gt; matcher| 이름이 name인 쿠키의 값이 지정한 값과 일치하는지 검사한다|
| maxAge(String name, int maxAge), maxAge(String name, Matcher&lt;? super Integer&gt; matcher) | 이름이 name인 쿠키의 유효 시간이 지정한 값과 일치하는지 검사한다.|
|path(String name, String path), path(String name, Matcher&lt;? super String&gt; matcher| 이름이 name인 쿠키의 경로 값이 지정한 값과 일치하는지 검사한다.|
|domain(String name, String domain), domain(String name,Matcher&lt;? super String&gt; matcher)| 이름이 name인 쿠키의 도메인 값이 지정한 값과 일치하는지 검사한다.|
|secure(String name, boolean secure)| 이름이 name인 쿠키가 보안 프로토콜로 전송되는지 여부를 검사한다.|


##### JSON 응답 검증

컨트롤러가 JSON응답을 리턴한다면, MockMvcresultMatchers.jsonPath() 메서드를 사용한다. 이 메서드를 사용하려면 먼저 JSON응답에서 경로값을 추출할 때 사용하는 json-path 모듈을 의존에 추가해야 한다.

~~~~
<dependency>
			<groupId>com.jayway.jsonpath</groupId>
			<artifactId>json-path</artifactId>
			<version>0.9.0</version>
			<scope>test</scope>
		</dependency>
~~~~

MockMvcresultMatchers.jsonPath() 메서드를 사용해서 JSON 응답을 검사하는 코드의 예는 다음과 같다.

~~~~
@Test
	public void test1() throws Exception {
		mockMvc.perform(get("/h/hello.json"))
		.andExpect(jsonPath("$.list[1].name", equalTo("aaa1")));
	}
~~~~

jsonPath() 메서드의 두 번째 인자는 JSON 경로에 해당하는 값을 비교할 때 사용할 Matcher를 지정한다. org.hamcrest.Matchers.equalTo() 메서드처럼 Hamcrest가 제공하는 Matcher를 사용해서 값을 비교할 수 있다.

jsonPath()의 JSON 경로를 자바 문자열 포맷을 이용해서 설정할 수도 있다.

~~~~
@Test
	public void test2() throws Exception {
		mockMvc.perform(get("/h/hello.json"))
		.andExpect(jsonPath("$.list").value(hasSize(4)))
		.andExpect(jsonPath("$.list[0].name").value("aaa"))
		.andExpect(jsonPath("$.list[%d].name", 1).value("aaa1"));
	}
~~~~

JsonPathResultMatchers 클래스의 메서드는 다음과 같다.

| 메서드 | 설명 |
|---|---|
|value(final Matcher&lt;T&gt; matcher), value(final Object expectedValue)| JSON 경로가 지정한 값과 일치하는지 검사한다.|
|exists() | JSON 경로가 존재하는지 검사한다.|
|doesNotExist()|JSON 경로가 존재하지 않는지 검사한다.|
|isArray()|JSON경로가 배열인지 검사한다.|

> JSON 경로 표현식
> jsonPath() 메서드가 사용하는 JSON 경로 표현식은 http://goessner.net/articles/JsonPath/ 에 정의되어 있는 표현식을 따른다.

##### XML 응답 검증

MockMvcresultMatchers.xpath() 메서드를 이용하면 XPath경로를 이용해서 XML 응답을 검사할 수 있다.

~~~~
@Test
	public void test1() throws Exception {
		mockMvc.perform(get("/h/hello.xml"))
		.andExpect(xpath("/element-list/element[0]/name").string("가나1"));
	}
~~~~

xpath() 메서드는 XpathResultMatchers객체를 리턴하며, 이 클래스는 값 검증을 위해 다음과 같은 메서드를 쓰고 있다.

| 메서드 | 설명 |
|---|---|
|exists() | XPath에 해당하는 값이 존재하는지 검사한다.|
|doesNotExist()| XPath에 해당하는 값이 존재하지 않는지 검사|
|nodeCount(int expectedCount), nodeCount(Matcher&lt;Integer&gt; matcher)|XPath에 해당하는 노드 개수가 일치하는지 검사|
|string(String expectedValue, String(Matcher&lt;String&gt; matcher)|XPath에 해당하는 값이 지정한 값과 일치하는지 검사|
|number(Double expectedValue), number(Matcher&lt;Double&gt; matcher)| XPath에 해당하는 수샂 값이 지정한 값과 일치하는지 검사|
|booleanValue(Boolean value)|XPath에 해당하는 boolean 값이 지정한 값과 일치하는지 검사|
|node(Matcher&lt;? super Node&gt; matcher)|XPath 에 해당하는 노드 값이 지정한 Matcher와 일치하는지 검사.|




##### 요청 / 응답 내용 출력

MockMvc를 이용해서 테스트를 진행하다 보면 실제로 생성된 요청과 응답이 어떻게 구성됐는지 궁금할 때가 있다. 이런 경우는

~~~~
mockMvc.perform(get("/hello").param("name", "pikapika"))
		.andExpect(status().isOk())
		.andDo(print())
~~~~

를 쓰면 된다.

perform() 메서드가 리턴하는 ResultActions 클래스는 andDo(ResultHandlerhandler) 메서드르 제공하고 있는데, MockMvcResultHandlers.print() 메서드는 이 ResultHandler의 구현 클래스인 ConsolePrintingResultHandler 객체를 리턴한다.




