#### 스프링 MVC 설정

#### WebMvcConfigurer를 이용한 커스텀 설정

MVC 네임스페이스를 사용할 때와 달리 @EnableWebMvc 애노테이션을 이용하는 경우에는 다음의 인터페이스를 상속받은 @Configuration 클래스를 구현해야 할 때가 있다.

* org.springframework.web.servlet.config.annotation.WebMvcConfigurer 인터페이스

이 인터페이스는 MVC 네임스페이스를 이용한 설정과 동일한 설정을 하는 데 필요한 메서드를 정의하고 있다. 

WebMvcConfigurer 인터페이스는 10개가 넘는 메서드를 정의하고 있는데 이들 메서드를 모두 구현하는 경우는 드물다. 대신 WebMvcConfigurer 인터페이스를 구현하고 있는 org.springframework.web.servlert.config.annotation.WebMvcConfigurerAdapter 클래스를 상속받아 필요한 메서드만 구현하는 것이 일반적이다.

~~~~
@Configuration
@EnableWebMvc
public class MvcConfiguration extends WebMvcConfigurerAdapter{
	@Override
	public void addViewControllers(ViewControllerRegistry registry){
		registry.addViewController("/index").setViewName("index");
	}
}

~~~~

위 코드처럼 @EnableWebMvc 애노테이션을 적용한 클래스가 WebMvcConfigurerAdapter 클래스를 상속받도록 구현하면 MVC 관련 설정이 한 클래스에 모이므로, 이 방법이 코드 관리 측면에서 좋다고 본다.

다음 코드처럼 @EnableWebMvc 클래스와 WebMvcConfigurer 구현 클래스가 서로 다를 수 있다.

~~~~
@Configuration
@EnableWebMvc
@Import(MvcConfiguration.calss)
public class Config{
	....
}

@Configuration
public class MvcConfiguration extnds WebMvcConfigurerAdapter{
	....
}
~~~~

##### 뷰 컨트롤러 설정하기

~~~~
@Configuration
@EnableWebMvc
public class Config extends WebMvcConfigurerAdapter{
	@Override
	public void addViewControllers(ViewControllerRegistry registry){
		registry.addViewController("/index").setViewName("index");
	}
}

~~~~

##### 디폴트 서블릿 설정과 동작 방식

web.xml 파일에서 DispatcherServlet에 대한 경로 매핑을 '/'로 했다고 했다.

이경우, CSS나 JS, HTML, JSP 등에 대한 요청이 DispatcherServlet으로 전달된다. 하지만, 이들 자원 경로에 매핑된 컨트롤러가 존재하지 않는 이상 DispatcherServlet은 404응답 에러를 발생시킨다. 실제로 css, js, html, jsp 등의 요청은 WAS가 기본으로 제공하는 디폴드 서블릿이 처리하게 되어 있기 때문에, 이들 자원에 대한 요청이 들어오면 디폴트 서블릿이 처리하도록 해야 한다.

MVC 네임스페이스나 @EnableWebMvc 애노테이션을 이용한 쉬운 설정을 사용할 때 DispatcherServlet에 대한 매핑 경로로 '/' 를 주는 경우는 매우 흔하기 때문에, 스프링 MVC는 디폴트 서블릿 핸들러라는 특별한 핸들러 구현을 제공하고 있다. 이 디폴트 서블릿 핸들러는 css, js, jsp등에 대한 요청이 들어오면 그 요청을 디폴트 서블릿에 다시 전달하는 핸들러이다. 따라서, 디폴트 서블릿 핸들러를 사용하면 DispatcherServlet 의 매핑 경로를로 "/"를 지정하면서 CSS, JS, JSP 등의 처리는 디폴트 서블릿이 처리하도록 할 수 있다.

~~~~
-- XML 설정
<beans ..>
	<mvc:annotation-driven />
	<mvc:default-servlet-handler />
</beans>


--자바 코드 설정
@Configuration
@EnableWebMvc
public class Config extends WebMvcConfigurerAdapter{
	@Override
	public void configureDefaultServletHandling(DefalutServletHandlerConfigurer configurer){

		configurer.enable();
	}
}
~~~~


디플트 서블릿 핸들러를 등록하면, DispatcherServlet은 요청이 들어올 때 다음의 과정을 거쳐서 요청을 처리하게 된다.

1. 요청 경로와 일치하는 컨틀롤러를 찾는다.
2. 컨트롤러가 존재하지 않으면, 디폴트 서블릿 핸들러에 전달한다.
3. 디폴트 서블릿 핸들러는 WAS의 디폴트 서블릿에 처리를 위임한다.
4. 디폴트 서블릿의 처리 결과를 응답으로 전송한다.

디폴트 서블릿의 이름은 WAS 마다 다른데, 디폴트 서블릿 핸들러 설정에서 디폴트 서블릿의 이름은 지정하고 싶다면 다음과 같은 코드를 사용하면 된다.

~~~~
<!-- XML -->
<mvc:default-servlet-handler default-servlet-name="default" />

//자바 설정
@Configuration
@EnableWebMvc
public class Config extends WebMvcConfigurerAdapter{
	@Override
	public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer){
		configurer.enable("default");
	}
}
~~~~

디폴트 서블릿 이름을 지정하지 않으면, 각 WAS 별로 다음과 같은 디폴터 서블릿 이름을 사용한다.

* 톰캣, Jetty, JBoss : default
* 웹로직 : FileServlet
* 구글 앱엔젠 : _ah_default
* 웹스피어 :  SimpleFileServlet

##### 정적 자원 설정하기

CSS, JS, 이미지 등의 자원은 거의 변하지 않기 때문에, 웹 브라우저에 캐시를 하면 네트워크 사용량, 서버 사용량, 웹 브라우저의 반응 속도 등을 개선할 수 있다. 이런 정적 자원은 보통 별도 웹 서버에서 제공하기 때문에 웹 서버의 캐시 옵션 설정을 통해 웹 브라우저 캐시를 활성화시킬 수 있다. 하지만, 스프링 MVC를 이용하는 웹 어플리케이션에 정적 자원 파일이 함께 포함되어 있다면 웹 서버 설정을 사용하지 않고 &lt;mvc:resources&gt; 설정을 이용해서 웹 브라우저 캐시를 사용하도록 지정할 수 있다.

~~~~
<mvc:resources mapping="/images/**" location="/img/,/WEB-INF/resources/" cache-period="60" />
~~~~


* mapping : 요청 경로 패턴을 설정한다. 컨텍스트 경로를 제외한 나머지 부분의 경로와 매핑된다.
* location : 웹 어플리케이션 내에서 요청 경로 패턴에 해당하는 자원의 위치를 지정한다. 위치가 여러 곳일 경우 각 위치를 콤마로 구분한다.
* cache-period : 웹 브라우저에 캐시 시간 관련 응답 헤더를 전송한다. 초 단위로 캐시 시간을 지정하며, 이 값이 0일 경우 웹 브라우저가 캐시하지 않도록 한다. 이 값을 설정하지 않으면 캐시 관련된 응답 헤더를 전송하지 않는다.

~~~~
@Configuration
@EnableWebMvc
public class Config extends WebMvcConfigurereAdapter{
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry){
		registry.addResourceHandler("/images/**")
		.addResourceLocations("/img/", "/WEB-INF/resources/")
		.setCachePeriod(60);
	}


}
~~~~


##### HandlerInterceptor 를 이용한 인터셉터 구현

요청 경로마다 접근 제어를 다르게 해야 한다거나 사용자가 특정 URL을 요청할 때마다 접근 내역을 기록하고 싶다면 어떻게 해야 할까? 이런 기능은 특정 컨트롤러에 종속되기 보다는 여러 컨트롤러에 공통으로 적용되는 기능들이다. 이런 기능을 각 컨트롤러에서 개별적으로 구현하면 중복코드가 발생하므로, 코드 중복없이 컨트롤러에 적용하는 방법이 필요하다.

스프링은 이미 AOP를 제공하고 있지만 AOP는 너무 범용적인 방법이다.

###### HandlerInterceptor 인터페이스 구현하기
org.springframework.web.servlet.HandlerIntercptor 인터페이스를 사용하면, 다음의 세가지 시점에 대한 공통 기능을 넣을 수 있다.

* 컨트롤러(핸들러) 실행 전
* 컨트롤러(핸들러) 실행 후, 아직 뷰를 실행하기 전
* 뷰를 실행한 이후

세 시점을 처리하기 위해 HandlerInterceptor 인터페이스는 다음과 같이 세 개의 메서드를 정의하고 있다.

~~~~
package org.springframework.web.servlet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.method.HandlerMethod;

public interface HandlerInterceptor{
	boolean preHandler(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception;
	void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception;
	void afterCompletion(HttpServletRequest request, HttpServletReponse reponse, Object handler, Exception ex) throws Exception;

}

~~~~

preHandler() 메서드를 컨트롤러/핸들러 객체를 실행하기 전에 필요한 기능을 구현할 때 사용된다. handler 파라미터는 웹 요청을 처리할 컨트롤러/핸들러 객체이다. 이 메서드를 사용하면 접근 권한이 없이 없는 경우 컨트롤러를 실행하지 않는다거나, 컨트롤러를 실행하기 전에 컨트롤러에서 필요로 하는 정보를 생성하는 등의 작업이 가능하다. preHandle() 메서드의 리턴 타입은 boolean인데 preHandle() 메서드가 false 리턴하면 컨트롤러(또는 다음 HandlerInterceptor)를 실행하지 않는다.

postHandle() 메서드는 컨트롤러/핸들러가 정상적으로 실행된 이후에 추가 기능을 구현 할 때 상요한다. 만약 컨트롤러가 익셉션을 발생하면 postHandle() 메서드는 실행되지 않는다. afterCompletion() 메서드는 클라이언트에 뷰를 전송한 뒤에 실행된다. 만약 컨트롤러를 실행하는 과정에서 익셉션이 발생하면, 이 메서드의 네 번째 파라미터로 전달된다. 익셉션이 발생하지 않았다면 네 번째 파라미터는 null이 된다. 따라서 컨트롤러 실행 이후에 예기치 않게 발생한 익셉션을 로그로 남긴다거나 실행 시간을 기록하는 등의 후처리를 하기에 적합한 메서드이다.

org.springframework.web.servlet.handler.HandlerInterceptorAdapter 클래스는 HandlerInterceptor 인터페이스를 구현하고 있는데 각 메서드는 아무 기능도 수행하지 않는다. 따라, HandlerInterceptor 인터페이스의 메서드를 모두 구현할 필요가 없다면, HandlerInterceptorAdapter 클래스를 상속받은 뒤 필요한 메서드만 재정의 하면 된다.


#####  HandlerInterceptor 설정하기

 HandlerInterceptor를 구현했다면, 다음으로 할 작업은 HandlerInterceptor이다.
 
 ~~~~
 <mvc:interceptors>
 	<bean id="measuringInterceoptor" class="com.company.MeasuringInterceptor" /> 
 </mvc:interceptors>
 ~~~~
 
&lt;mvc:interceptors&gt; 태그는 HandlerInterceptor 설정과 경로설정을 함께 설정할 때 사용된다. 위 설정의 경우  &lt;mvc:interceptors&gt; 태그 내부에 정의한 빈 객체를 핸들러 인터셉터로 사용하고, DispatcherServlet이 처리하는 요청에 대해 핸들러 인터셉터를 적용하게 된다.


자바기반은
~~~~
@Configuration
@EnableWebMvc
public class Config extends WebMvcConfigurerAdapter{
	@Override
	public void addInterceptors(InterceptorRegistry registry){
		registry.addInterceptor(measuringInterceptor());
	}
    
	@Bean
	public MeasuringInterceptor measuringInterceptor(){
		return new MeasuringInterceptor();
	}
}
~~~~

앞서 설정은 DispatcherServlet이 처리하는 모든 요청에 대해 핸들러 인터셉터를 적용하는데, 만약 특정 요청 경로에 대해서만 핸들러 인터셉터를 적용하고 싶다면 중첩 태그를 사용
~~~~
<mvc:interceptors>
	<mvc:interceptor>
		<mvc:mapping path="/event/**"/>
		<mvc:mapping path="/folders/**"/>
		<bean class="com.company.MeasuringInterceptor" />
	</mvc:interceptor>
</mvc:interceptors>
~~~~

위 설정에서  &lt;mvc:mapping&gt;은 핸들러 인터셉터를 적용할 요청 경로 패턴을 지정한다.( 이 경로는 컨텍스트 경로를 제외한 나머지 경로와 매핑된다.)  &lt;mvc:mapping&gt; 태그로 지정한 경로 패턴에 적용될 핸들러 인터셉터는 <bean>태그를 이용해서 지정한다.

자바 설정을 이용한다면  addPathPatterns() 메서드를 이용해서 경로 패턴 목록을 지정해주면 된다.

~~~~
@Configuration
@EnableWebMvc
public class Config extends WebMvcConfigurerAdapter{
	@Override
	public void addInterceptors(InterceptorRegistry registry){
		registry.addInterceptor(measuringInterceptor())
			.addPathPatterns("/event/**", "/folders/**);
	}
}

~~~~

##### HandlerInterceptor의 실행순서

한 요청 경로에 대해 두 개 이상의 핸들러 인터셉터를 적용할 수 도 있다. 

특정 경로 패턴에 대해 핸들러 인터셉터를 적용하고 싶지 않다면  &lt;mvc:exclude-mapping path="" /&gt; 태그 또는 excludePathPatterns() 메서드를 이용해서 제외할 경로 패턴을 지정한다.

~~~~
-XML 설정
<mvc:interceptors>
	<mvc:interceptor>
		<mvc:mapping path="/acl/**"/>
		<mvc:exclude-mappgin path="/alc/modify" />
		<bean class="com.company.CommonMOdelInterceptor" />
	</mvc:interceptor>
</mvc:interceptors>

- JAVA 설정
@Override
public void addInterceptors(InterceptorRegistry registry){
	registry.addInterceptor(commonModelInterceptor())
	.addPathPatterns("/acl/**", "/header/**", "/newevent/**")
	.excludePathPatterns("/acl/modify");
}
~~~~



#### WebApplicationContext 계층

~~~~
<context-param>
	<param-name>contextConfiguration</param-name>
	<param-value>/WEB-INF/service.xml, /WEB-INF/persistene.xml</param-value>
</context-param>

<listener>
	<listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>

<servlet>
	<servlet-name>front</servlet-name>
	<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
</servlet>

<servlet>
	<servlet-name>rest</servlet-name>
	<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
</servlet>

~~~~


실제로 ContextLoaderListener와 DispatcherServlet은 각각 WebApplicationContext 객체를 생성한다.
ContextLoaderListener 가 생성하는 WebApplicationContext는 웹 어플리케이션에서 루트 컨텍스트가 되며, DispatcherServlet 이 생성하는 WebApplicationContext는 루트 컨텍스트를 부모로 사용하는 자식 컨텍스트가 된다. 이때 자식은 root가 제공하는 빈을 사용할 수 있기 때문에 DispatcherServlet이 공통으로 필요로 하는 빈을 ContextLoaderListener 를 이용하여 설정하는 것이다.

ContextLoaderListener는 contextConfigLocation 컨텍스트 파라미터를 명시하지 않으면 /WEB-INF/applicationContext.xml을 설정파일로 사용한다. 또한, 클래스패스에 위치한 파일로부터 설정 정보를 읽어오고 싶다면 다음과 같이 'classpath:'접두어를 사용하면 된다.

~~~~
<context-param>
	<param-name>contextConfiguration</param-name>
	<param-value>classpath:config/service.xml, classpath:config/persistene.xml</param-value>
</context-param>

<listener>
	<listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>
~~~~

@Configuration 설정 클래스를 사용한다면, 다음과 같이 contextClass 컨텍스트 파라미터를 이용해서 WebApplicationContext 구현체로 AnnotationConfigWebApplicationContext를 지정해주고, contextConfigLocation 컨텍스트 파라미터의 값으로 사용할 자바 설정 클래스를 지정해주면 된다.

~~~~
<context-param>
	<param-name>contextClass</param-name>
	<param-value>org.springframework.web.context.support.AnnotationConfigWebApplicationContext</param-value>
</context-param>

~~~~


#### DelegatingFilterProxy를 이용한 서블릿 필터 등록

~~~~
<filter>
	<filter-name>profileFilter</filter-name>
	<filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
	<init-param>
		<param-name>targetBeanName</param-name>
		<param-value>webProgileBean</param-value>
	</init-param>
	<init-param>
		<param-name>contextAttribute</param-name>
		<param-value>org.springframework.web.servlet.FrameworkServlet.CONTEXT.dispatcher</param-value>
	</init-param>
</filter>


<servlet>
	<servlet-name>dispatcher</servlet-name>
	<servlet-class>org.sprinframework.web.servlet.DispatcherServlet</servlet-class>
	....
</servlet>

~~~~

위 코드의 경우 profileFilter는 그 요청을 targetBeanName 초기화 파라미터로 지정한 빈에 위임한다.

DelegatingFilterProxy가 사용할 빈 객체는 다음의 두 가지 중 한 군데에 등록될 것이다.

* DispatcherServlet이 생성한 WebApplicationContext
* ContextLoaderListener가 생성한 루트 WebApplicationContext

이 중, DispatcherServlet이 생성한 스프링 컨테이너에 필터로 사용할 빈 객체가 존재한다면, contextAttribute 초기화 파라미터를 이용해서 DispatcherServlet이 컨테이너를 보관할 때 사용하는 속성 이름을 지정해야 한다. 속성 이름은 "org.springframework.web.servlet.FrameworkServlet.CONTEXT.[서블릿이름]" 의 형식을 갖는다.


##### 핸들러, HandlerMapping, HandlerAdapter

DispatcherServlet은 웹 요청을 실제로 처리하는 개체의 타입을 @Controller 애노테이션을 구현한 클래스로 제한하지 않는다. 실제로 거의 모든 종류의 객체로 웹 요청을 처리할 수 있다. 그래서 웹 요청을 처리하는 객체를 좀 더 범용적은 의미로 핸들러(Handler) 라고 부른다.

MVC 설정을 이용하면 최소 두 개 이상의 HandlerMapping이 등록된다. 각 HandlerMapping은 우선순위를 갖고 있으며, 요청이 들어왔을때 DispatcherServlet은 우선순위에 따라 HandlerMapping에 요청을 처리할 핸들러 객체를 의뢰한다.

&lt;mvc:annotation-driven&gt; 설정의나 @EnableWebMvc 애노테이션을 사용하면 다음과 같은 HandlerMapping과 HandlerAdapter를 등록한다.

<table>
<tr><th>빈 클래스</th><th>설명</th></tr>
<tr>
<td>RequestMappingHandlerMapping</td>
<td>@Controller 적용 빈 객체를 핸들러로 사용하는 HandlerMapping 구현. 적용 우선순위 높음</td>
</tr>
<tr>
<td>SimpleUrlHandlerMapping</td>
<td><mvc:defalut-servlet-handler />, <mvc:view-controller /> 또는 <mvc:resources /> 태그를 사용할 때 등록되는 HandlerMapping구현, URL과 핸들러 객체를 매핑함. 적용 우선순위 낮음</td>
</tr>
<tr>
<td>RequestMappingHandlerAdapter</td>
<td>@Controller 적용 빈 객체에 대한 어댑터</td>
</tr>
<tr>
<td>HttpRequestHandlerAdapter</td>
<td>HttpRequestHandler 타입의 객체에 대한 어댑태</td>
</tr>
<tr>
<td>SimpleControllerHandlerAdapter</td>
<td>Controller 인터페이스를 구현한 객체에 대한 어댑터.</td>
</tr>
</table>

@Controller 애노테이션 기반의 컨트롤러는 주로 개발자가 구현할 코드이다.

HttpRequestHandler 인터페이스는 주로 스프링이 기본으로 제공하는 핸들러 클래스가 구현하고 있다. 예를 들어, 디폴트 서블릿 핸들러 설정을 위해 다음의 태그를 사용했다.

~~~~
<mvc:default-servlet-handler />
~~~~
위 설정을 하면, 아래 설정과 같이 HttpRequestHandler 인터페이스를 구현한 DefaultServletHttpRequestHandler 클래스와 SimpleUrlHandlerMapping 클래스를 빈으로 등록한다.

<mvc:annotation-driven /> 태그가 등록하는 RequestMappingHandlerMapping의 우선순위가 <mvc:default-servlet-handler /> 태그가 등록하는 SimpleUrlHandlerMapping 의 우선순위보다 높다. 따라서, 특정 요청이 들어올 경우 RequestMappingHandlerMapping을 먼저 확인하고 SimpleUrlHandlerMpaaing 을 확인한다.

