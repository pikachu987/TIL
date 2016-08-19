### XML/JSON 변환처리

서비스나 데이터를 HTTP 기반 API 형태로 제공하는 곳이 많다. 

#### @RequestBody/@ResponseBody 와 HttpMessageConverter

요청 몸체에는 웹 브라우저에 전송할 데이터가 담기는데, 이 데이터의 형식은 Content-Type 헤더 값으로 지정한다.

스프링이 제공하는 @RequestBody 애노테이션과 @ResponseBody 애노테이션은 각각 요청 몸체와 응답 몸체와 관련되어 있다. 먼저 @ResponseBody 애노테이션은 요청 몸체를 자바객체로 변환할 때 사용된다. 예를 들어, 요청 파라미터 문자열을 String 자바 객체로 변환하거나, JSON 형식의 요청 몸체를 자바 객체로 변환할 때 @RequestBody 애노테이션을 사용한다. 비슷하게 @ResponseBody 애노테이션은 자바 객체를 응답몸체로 변환하기 위해 사용된다. 보통 자바 객체를 JSON 형식이나 XML 형식의 문자열로 변환할때 @ResponseBody를 사용한다.


~~~~
@Controller
public class ViewController {
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public String view() {
		return "index";
	}
	
	@RequestMapping(method=RequestMethod.POST)
	@ResponseBody
	public String simple(@RequestBody String body){
		return body;
	}
}
~~~~

@RequestBody 애노테이션은 String 타입의 body 파라미터에 적용되어 있는데, 이 경우 스프링 MVC 는 POST 방식으로 전송된 HTTP 요청 데이터를 String타입의 body 파라미터로 전달한다. 그리고 메서드에 @RequestBody 애노테이션이 붙으면, 스프링 MVC는 메서드의 리턴 값을 HTTP 응답 데이터로 사용한다.

* @RequestBody 애노테이션을 이용해서 HTTP 요청 몸체 데이터를 body 파라미터로 전달 받으며, 그 데이터를 그대로 결과 값으로 리턴한다.
* 해당 메서드에는 @ResponseBody 애노테이션이 적용되어 있기 때문에, 결과적으로 HTTP 요청 몸체 데이터가  HTTP 응답 데이터로 그대로 전송된다.

~~~~
name=guanho&age=26
~~~~


#### HttpMessageConvert를 이용한 변환 처리

스프링 MVC는 @RequestBody 애노테이션이나 @ResponseBody 애노테이션이 있으면, HttpMessageConverter을 이용해서 자바 객체와 HTTP 요청/응답 몸체 사이의 변환을 처리한다. 스프링은 다양한 타입을 위한 HttpMessageConverter 구현체를 제공하고 있다. 예를 들어, 아래 코드에서 요청 몸체를 @RequestBody 가 적용된 body로 변환할 때에는 HttpMessageConverter 인터페이스를 구현한 클래스인 StringHttpMessageConverter를 이용한다. 동일하게 String 타입인 리턴 객체를 응답 몸체로 변환할 때에도 StringHttpMessageConverter를 사용한다.

<mvc:annotation-driven/> 태그나 @EnableWebMvc 애노테이션을 사용하면, StringHttpMessageConverter를 포함해 다수의 HttpMessageConvert 구현클래스를 등록한다.


<table>
<tr><th>클래스</th><th>설명</th></tr>
<tr>
<td>StringHttpMessageConverter</td>
<td>요청 몸체를 문자열로 변환하거나 문자열을 응답 몸체로 변환한다.</td>
</tr>
<tr>
<td>Jaxb2RootElementHttpMessageConverter</td>
<td>XML 요청 몸체를 자바 객체로 변환하거나 자바 객체를 XML 응답 몸체로 변환한다. JAXB2가 존재하는 경우에 사용된다. <br> 요청 컨텐트 타입으로 text/xml , application/xml, appplication/*+xml  을 지원한다. 생성하는 응답 컨텐트 타입은 application/xml이다.</td>
</tr>
<tr>
<td>MappingJackson2HttpMessageConverter</td>
<td>JSON 요청 몸체를 자바 객체로 변환하거나 자바 객체를 JSON응답 몸체로 변환한다.Jackson2가 존재할떄 사용 application/json , application/*+json 을 지원한다.</td>
</tr>
<tr>
<td>MappingJacksonHttpMessageConverter</td>
<td>JSON요청 몸체를 자바객체로 변환하거나 자바객체를 JSON 응답 몸체로 변호나한다. Jackson이 존재하는 경우에 사용 지원하는 요청 컨텐트 타입과 응답 컨텐트타입은 Jackson2를 사용하는 경우와 동일</td>
</tr>
<tr>
<td>ByteArrayHttpMessageConverter</td>
<td>요청 몸체를 byte 배열로 변환하거나 byte 벼열을 응답 몸체로 변환</td>
</tr>
<tr>
<td>ResourceHttpMessageConverter</td>
<td>요청 몸체를 스프링의 Resource 로 변환하거나 Resource를 응답 몸체로 변환</td>
</tr>
<tr>
<td>SourceHttpMessageConverter</td>
<td>XML 요청 몸체를 XML Source로 변환하거나 XML Source를 XML 응답으로 변환</td>
</tr>
<tr>
<td>AllEncompassingFormHttpMessageConverter</td>
<td>폼 전송 형식의 요청 몸체를 MultiValueMap으로 변환하거나, MulitiValueMap을 응답 몸체로 변환할때 사용된다. 지원되는 컨텐트타입은 application/x-www-form-urlencoded, multipart/form-data 이다. multipart/form-data 형식의 요청 몸체의 각 부분을 변환할 때에는 이 표의 나머지 HttpMessageConverter를 사용한다.</td>
</tr>
</table>

##### JAXB2를 이용한 XML 처리

JAXB2 API는 자바 객체와 XML사이의 변환을 처리해주는 API이다. Jaxb2RootElementHttpMessageConverter는 JAXB2 API 를 이용해서 자바 객체를 XML 응답으로 변환하거나 XML 요청 몸체를 자바 객체로 변환한다.

JAXB2 API는 자바 6이후 버전에 기본으로 포함되어 있다.

Jaxb2RootElementHttpMessageConverter는 다음의 변환 처리를 지원한다.

* XML -> @XmlRootElement 객체 또는 @XmlType 객체로 읽기
* @XmlRootElement 적용 객체 -> XML로 쓰기

따라서 XML 요청 몸체를 @RequestBody 애노테이션을 이용해서 JAXB2 기반의 자바 객체로 변환하거나  JAXB2기반 객체를 @ResponseBody 애노테이션을 이용해서 XML응답으로 변환하려면, Jaxb2RootElementHttpMessageConverter를 사용하면 된다. 앞서 MVC 설정을 사용하면 Jaxb2RootElementHttpMessageConverter는 기본으로 등록되므로, 추가로 설정할 필요는 없다.

코드 참조

GuestMessageList 클래스는 값이 "message-list"인 @XmlRootElement 애노테이션이 적용되어 있다. 따라서 , JAXB2를 이용해서 GuestMessageList 객체를 XML로 변환하면 루트 태그가 &lt;message-list&gt; 인 XML 이 생성된다. 컨트롤러 메서드는 다음과 같이 함으로써 GuestMessageList객체를 XML 응답으로 변환할 수 있다.

* 메서드에 @ResponseBody 애노테이션을 적용한다.
* GuestMessageList 객체를 리턴한다.

코드참조

스프링은 @ResponseBody 애노테이션이 적용된 메서드의 리턴 타입을 확인한다. 리턴타입이 JAXB2가 적용된 클래스이므로, 등록된 HttpMessageConverter중에서 JAXB2를 이용해서 자바 객체를 XML로 변환해주는 Jaxb2RootElementHttpMessageConverter를 사용한다.



XML로 전송된 요청 몸체 데이터를 JAXB2가 적용된 자바 객체로 변환하고 싶다면 다음과 같이 컨트롤러 메서드의 파라미터에 @RequestBody 애노테이션을 적용하면 된다.

~~~~
<script>
		function postXml() {
			var xmlBody = 
				'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+
				'<message-list>'+
				'<message><id>1</id><message>메시지</message><creationTime>2014-03-16T13:22:16.767+09:00</creationTime></message><message><id>2</id><message>메시지2</message><creationTime>2014-03-16T13:22:16.767+09:00</creationTime></message>'+
				'</message-list>';
			$.ajax({
				type: "post",
				url: "guestmessage/post.xml",
				contentType: "text/xml",
				data: xmlBody,
				processData: false,
				success: function( response ){
					alert(response);
				},
				error: function(){
					alert( "ERROR", arguments );
				}
			});
		}
	</script>

~~~~
스크립트 예제이다.

XML을 서버에 전송하면, JAXB2를 이용해서 XML을 자바 객체로 변환한 뒤에 그 객체를 @RequestBody 애노테이션이 적용된 파라미터로 전달받게 된다.

> 웹 브라우저별로 XML이나 JSON형식의 데이터를 서버에 전송하기 위한 플러그인이 존재한다. 크롬의 경우 Advanced Rest Client 확장 프로그램을 사용하면 자바스크립트 코드를 작성할 필요 없이 서버에 XML이나 JSON형식의 데이터를 전송할 수 있다.


#### Jackson2를 이용한 JSON 처리

Jackson2는 자바 객체를 JSON으로 변환하거나 JSON을 자바 객체로 변환할 때 주로 사용하는 라이브러리로, 스프링 MVC의 MappingJackson2HttpMessageConverter는 Jackson2를 이용해서 자바 객체와 JSON간의 변환을 처리한다.

~~~~
<dependency>
	<groupId>com.fasterxml.jackson.core</groupId>
	<artifactId>jackson-databind</artifactId>
	<version>2.3.3</version>
</dependency>
~~~~

Jackson2 의존을 추가하면 필요한 설정은 끝이다. 자바 객체를 JSON 응답으로 변환하는 것은 매우 간단하다.
컨트롤러 메서드의 리턴 타입으로 자바 객체를 리턴해주기만 하면 된다.

~~~~
@RseponseBody
public GuestMessageList2 listJson(){
	return getMessageList2();
}
~~~~

MappingJackson2HttpMessageConverter는 임의의 객체를 JSON으로 변환해준다.


> 커스텀 HttpMessageConverter 등록하기
> 스프링은 이미 널리 사용되는 요청/응답 형식을 위한 HttpMessageConverter 를 제공하고 있기 때문에, 직접 HttpMessageConverter 를 구현해야 하는 경우는 드물다. 만약 직접 구현한 HttpMessageConverter 빈을 등록해주면 된다.
> ~~~~
> <mvc:annotation-driven>
> <mvc:message-converters>
> <bean class="x.y.CustomMessageConverter"/>
> </mvc:message-converters>
> </mvc:annotation-driven>
> ~~~~
> 위 설정을 사용하면 스프링 MVC는 CustomMessageConverter를 등록하고 기본으로 사용하는 HttpMessageConverter를 등록한다.
> 만약 기본으로 추가되는 HttpMessageConverter를 등록하고 싶지 않다면, 다음과 같이 register-defaults 속성 값을 false로 지정하면 된다.
> ~~~~
> <mvc:annotation-driven>
> <mvc:message-converters register-defaults="false">
> <bean class="x.y.CustomMessageConverter"/>
> </mvc:message-converters>
> </mvc:annotation-driven>
> ~~~~
> @EnableWebMvc 애노테이션을 이용하는 경우, 다음과 같이 WebMvcConfigurerAdapter 클래스를 상속받아 configureMessageConverters() 메서드를 재정의 하면 된다.
> ~~~~
> @Configuration
> @EnableWebMvc
> public class Config extends WebMvcConfigurerAdapter{
> 	@Override
> 	public void configureMessageConverters(List<HttpMessageConverter<?>> converters){
> 		converters.add(new CustomMessageConverter());
> 	}
> }
> ~~~~
> 위와 같이 커스텀 HttpMessageConverter를 등록할 때 주의할 점은, &lt;mvc:annotation-driven&gt;태그를 사용할 때와 달리 위와 같이 커스텀 HttpMessageConverter를 등록하면 기본으로 등록했던 HttpMessageConverter를 등록하고, 더불어 XML이나 JSON변환 처리를 하고 싶다면 다음과 같이 나머지 HttpMessageConverter도 함께 등록해주어야 한다.
> ~~~~
> @Configuration
> @EnableWebMvc
> public class Config extends WebMvcConfigureAdapter{
> 	@Override
> 	public void configureMessageConverters(List<HttpMessageConverter<?>> converters){
> 		converters.add(new StringHttpMessageConverter());
> 		converters.add(new Jaxb2RootElementHttpMessageConverter());
> 		converters.add(new MappingJackson2HttpMessageConverter());
> 	}
> }
> ~~~~