### 스프링 MVC


~~~~
<!-- 서블릿, JSP, JSTL을 위한 의존 설정 -->
<dependency>
	<groupId>javax.servlet.jsp</groupId>
	<artifactId>jsp-api</artifactId>
	<version>2.2</version>
	<scope>provided</scope>
</dependency>

<dependency>
	<groupId>javax.servlet</groupId>
	<artifactId>javax.servlet-api</artifactId>
	<version>3.0.1</version>
	<scope>provided</scope>
</dependency>

<dependency>
	<groupId>javax.servlet</groupId>
	<artifactId>jstl</artifactId>
	<version>1.2</version>
	<scope>runtime</scope>
</dependency>



<!-- 스프링 MVC를 위한 의존 설정 -->
<dependency>
	<groupId>org.springframework</groupId>
	<artifactId>spring-webmvc</artifactId>
	<version>4.0.4.RELEASE</version>
</dependency>

~~~~


~~~~
<!-- DispatcherServlet을 등록한다. DispatcherServlet은 내부적으로 스프링 컨테이너를 생성하는데, contextConfigLoaction 초기화 파라미터를 이용해서 컨테이너를 사용할 설정 파일을 지정 -->
<servlet>
	<servlet-name>dispatcher</servlet-name>
	<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
	<init-param>
		<param-name>contextConfigLocation</param-name>
		<param-value>
		/WEB-INF/mvc-quick-start.xml
		</param-value>
	</init-param>
	<load-on-startup>1</load-on-startup>
</servlet>


<!-- 요청 파라미터를 UTF-8로 처리하기 위한 필터를 지정한다. -->
<filter>
	<filter-name>encodingFilter</filter-name>
	<filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
	<init-param>
		<param-name>encoding</param-name>
		<param-value>UTF-8</param-value>
	</init-param>
</filter>
<filter-mapping>
	<filter-name>encodingFilter</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>
~~~~



~~~~
<!-- 클래스가 스프링 MVC컨트롤러임을 지정 -->
@Controller
public class HelloController{
	@RequestMapping("/hello")
	public String hello(Model model){
		model.addAttribute("hello","안녕");
		return "hello";
	}
}
~~~~


#### 기본 흐름과 주요 컴포넌트

스프링 MVC는 여러 구성 요소가 맞물려 동작하기 때문에, 스프링 MVC를 이용해서 웹 어플리케이션을 개발하려면 적어도 스프링 MVC가 어떤 식으로 동작하는지 이해하고 있어야 한다.

<table>
<tr><th>구성요소</th><th>설명</th></tr>
<tr>
<td>DispatcherServlet</td>
<td>클라이언트의 요청을 전달받는다. 컨트롤러에게 클라이언트의 요청을 전달하고, 컨트롤러가 리턴한 결과값을 View에 전달하여 알맞은 응답을 생성하도록 한다.</td>
</tr>
<tr>
<td>HandlerMapping</td>
<td>클라이언트의 요청 URL을 어떤 컨트롤러가 처리할지를 결정한다.</td>
</tr>
<tr>
<td>HandlerAdapter</td>
<td>DispatcherServlet의 처리 요청을 변환해서 컨트롤러에게 전달하고, 컨트롤러의 응답 결과를 DispatcherServlet이 요구하는 형식으로 변환한다. 웹 브라우저 캐시 등의 설정도 담당한다.</td>
</tr>
<tr>
<td>컨트롤러(Controller)</td>
<td>클라이언트의 요청을 처리한 뒤, 결과를 리턴한다. 응답 결과에서 보여줄 데이터를 모델에 담아 전달한다.</td>
</tr>
<tr>
<td>ModelAndView</td>
<td>컨트롤러가 처리한 결과 정보 및 뷰 선택에 필요한 정보를 담는다.</td>
</tr>
<tr>
<td>ViewResolver</td>
<td>컨트롤러의 처리 결과를 보여줄 뷰를 결정한다.</td>
</tr>
<tr>
<td>뷰(view)</td>
<td>컨트롤러의 처리 결과 화면을 생성한다. JSP나 Velocity 템플릿 파일 등을 이용해서 클라이언트에 응답 결과를 전송한다.</td>
</tr>
</table>

#### 스프링 MVC 설정 기초

* web.xml 에 DispatcherServlet 설정
* web.xml에 캐릭터 인코딩 처리 위한 필터 설정
* 스프링 MVC 설정 - HandlerMapping, HandlerAdapter, ViewResolver 설정

##### DispatcherServlet 서블릿 설정

mvc:annotation-driven 태그는 다음의 두 클래스를 빈으로 등록해준다.
* RequestMappingHandlerMapping
* RequestMappingHandlerAdapter

이 두 클래스는 @Controller 애노테이션이 적용된 클래스를 컨트롤러로 사용할 수 있도록 해준다. 이 두 객체 외에 mvc:annotation-driven 태그는 JSON이나 XML 등 요청/응답 처리를 위해 필요한 모듈이나 데이터 바인딩 처리를 위한 ConversionService 등을 빈으로 등록해준다.

InternalResourceViewResolver는 JSP를 이용해서 뷰를 생성할 때 사용되는 ViewResolver 구현체이다. ViewResolver 를 지정할 때 주의할 점은 ViewResolver의 이름이 "viewResolver" 여야 한다는 점이다.

@Configuration 자바 설정을 사용한다면, @EnableWebMvc 애노테이션을 사용하면 된다. @EnableWebMvc 애노테이션을 사용하면 <mvc:annotation-driven> 과 동일하게 스프링 MVC를 설정하는데 필요한 빈을 자동으로 등록해준다.

~~~~
@Configuration
@EnableWebMvc
public class WebConfig extends WebMvcConfigurerAdapter{

	@Override
	public void configureDefaultServletHandling(DefaultServletHandlerCOnfigurere configurer){
		configurer.enable();
	}

}

~~~~



* Model addAttribute(String attrName, Object attrValue)
* > 이름이 attrName 이고 값이 attrValue인 모델 속성을 추가한다.
* Model addAllAttributes(Map<String, ?> attributes)
* > 맵의 <키, 값> 쌍들을 모델 속성 이름과 값으로 추가한다.
* boolean containsAttribute(String attrName)
* > 이름이 attrName인 모델 속성을 포함할 경우 true를 리턴한다.



* Model을 사용하는 경우 뷰 이름을 리턴하는데, ModelAndView 를 사용하는 경우는 setViewName()을 이용해서 뷰 이름을 지정한다.
* Model은 addAttribute() 메서드를 사용하는데, ModelAndView를 사용하는 경우는 addObject() 메서드를 사용한다.

> 스프링 MVC에서 @Controller 애노테이션 기반의 컨트롤러를 지원하기 시작한 이후로 ModelAndView를 잘 사용하지 않는다. 위 내용은 컨트롤러 코드에서 ModelAndView를 사용하다는 것을 언급하기 위해 추가했다. ModelAndView 외에 java.util.Map을 Model 대신 사용할 수도 있는데, Map보다는 Model타입을 사용하는 것이 보다 명시적이기 때문에 Model을 사용할 것을 권한다.


org.springframework.web.bing.annotation.RequestMethod는 열거 타입으로 다음의 값을 정의하고 있다.
* GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS, TRACE
* > 웹 브라우저는 GET, POST 방식만 지원하기 때문에, 웹브라우저에서 실행하는 자바 스크립트에서 웹 서버에  PUT이나 DELETE 방식의 요청을  보낼 수 없다. REST API 를 만들때 PUT, DELETE 전송 방식을 이요해서 구현해야 하는 경우 웹 브라우저의 전송 방식 제한은 문제가 된다. 이런 문제를 해소하기 위해 스프링은 HiddenHttpMethodFilter 를 제공하고 있는데, 이 필터를 사용하면 컨트롤러 메서드가 PUT, DELETE 등의 전송방식을 처리하도록 구현하면서, 동시에 같은 메서드를 이용해서 Ajax 요청을 처리할 수 있게 된다.


##### Ant 패턴을 이용한 경로 매핑
* &ensp;* - 0개 또는 그 이상의 글자
* ? - 1개 글자
* ** - 0개 또는 그 이상의 디렉토리 경로

ex)
* @RequestMapping("/member/?*.info")
* @RequestMapping("/faq/f?00.fq")
* @RequestMapping("/folders/**/files")


###### 처리 가능한 요청 컨텐트 타입/응답 가능한 컨텐트 타입 한정
서비스 또는 클라이언트/서버 간 통신 방식으로 REST API가 자리 잡으면서 HTTP의 데이터로 JSON이나 XML을 전송하는 경우가 증가 했다. 예를 들어, 웹 브라우저에서 폼을 전송할 때 사용하는 application/x-www-form-urlencoded 컨텐트 타입이 아니라 application/json이나 application/xml 과 같은 컨텐트 타입을 이용해서 서버와 데이터를 주고 받는 경우가 증가하고 있다.


요청 컨텐트 타입을 제한하고 싶다면, comsumes속성을 사용하면 된다. 예를 들어, Content-Type 요청 헤더가 "application/json" 인 경우만 처리하고 싶다면 다음과 같이 하면 된다.

~~~~
@RequestMapping(value="/member", method=RequestMethod.POST, consumers="application/json")
~~~~

반대로 응답 결과로 JSON을 요구하는 요청을 처리하고 싶다면

~~~~
@RequestMapping(value="/member", method=RequestMethod.POST, produces="application/json")
~~~~
라고 하면 된다.

##### @CookieValue와 @RequestHeader를 이용한 쿠키 및 요청 헤더 구하기

~~~~

@RequestMapping("..")
public String simple(@RequesHeader(value="Accept",defalutValue="text/html") String acceptType, @CookieValue("auto") Cookie cookie){}
~~~~

##### 리다이렉트 처리

~~~~
public ....(){
	return "redirect:/main";
}
~~~~

