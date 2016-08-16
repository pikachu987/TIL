#### 요청 파라미터의 값 변환 처리

예약 시스템을 만들 때, 예약 날짜를 '2014-01-01' 과 같은 형식으로 입력받고 싶을 때가 있을 것이다. 그리고, 커맨드 객체의 필드 타입은 java.util.Date나 자바 8의 java.time.LocaleDate 등 날짜/시간 관련 타입을 사용하고 있다고 하자. 이런 경우에 스프링이 알아서 '2014-01-01'값을 갖는 요청 파라미터를 커맨드 객체의 Date 타입 프로퍼티로 변환해주면 편리할 것이다. 스프링은 이미 문자열을 Date, LocalDate 등의 타입으로 변환해주는 기능을 제공하고 있다.

##### WebDataBinder / @InitBinder와 PropertyEditor를 이용한 타입 변환

앞서 커맨드 객체를 검증할 때 WebDataBinder를 이용해서 Validator를 등록하는 방법을 설명했는데, WebDataBinder는 커맨드 객체의 값 검증 뿐만 아니라 웹 요청 파라미터로부터 커맨드 객체를 생성할 때에도 사용된다. WebDataBinder는 커맨드 객체를 생성하는 과정에서 String 타입의 요청 파라미터를 커맨드 객체 프로퍼티의 타입으로 변환한다. 이때 WebDataBinder는 앞에서 설명한 PropertyEditor와 ConversionService를 사용한다.

같은 타입이라고 하더라도 컨트롤러 클래스마다 다른 변환 규칙을 사용해야 할 때가 있는데, 이런 경우에는 컨트롤러마다 개별적으로 PropertyEditor를 등록하는 방법을 사용하면 된다. WebDataBinder는 PropertyEditor를 등록할 수 있는 registerCustomEditor() 메서드를 제공하고 있으며, @InitBinder 메서드에서 이 메서드를 이용해서 필요한 PropertyEditor를 등록하면 된다.

예를 들어, 스프링은 문자열을 java.util.Date타입으로 변환해주는 CustomDateEditor를 제공하고 있는데, CustomDateEditor를 사용하면 특정 형식을 갖는 요청 파라미터를 Date타입으로 변환할 수 있다.

~~~~
import java.text.SimpleDateFormat;
import org.springframework.beans.propertyeditors.CustomDateEditor;

@Controller
@RequestMapping("/event"
public class EventController{

	@InitBinder
	protected void initBinder(WebDateBinder binder){
		//커맨드 객체의 Date타입 프로퍼티에 파라미터 값을 할당할 때 사용
		CustomDateEditor dateEditor = new CustomDateEditor(new SimpleDateFormat("yyyyMMdd"), true);
		binder.registerCustomEditor(Date.class, dateEditor);
	}

	//option 커맨드 객체의 from 프로퍼티가 Date 타입인 경우
	//"yyyyMMdd" 형식의 값을 갖는 from 요청 파라미터를 Date로 변환 처리
	@RequestMapping("/list")
	public String list(SearchOption option, Model model){
		....
	}

}
~~~~

CustomDateEditor는 문자열을 Date로 변환할 때 사용할 SimpleDateFormat 객체의 생성자를 통해서 전달받는다. CustomDateEditor 객체를 생성했다면 WebDateBinder 의 registerCustomEditor() 메서드를 이용해서 에디터를 등록하면 된다. 위 코드에서 이 메서드를 호출할 때 첫 번째 파라미터로 Date.class를 주었는데, 이는 Date타입의 프로퍼티를 값으로 변환할 때 dateEditor를 사용한다는 것을 의미한다.

만약 프로퍼티마다 다른 커스텀 에디터를 사용하고 싶다면 프로퍼티 이름을 지정해주면 된다.

~~~~

@InitBinder
protected void initBinder(WebDateBinder binder){
	CustomDateEditor dateEditor1 = new CustomDateFormat(new SimpleDateFormat("yyyyMMdd"),true);
	binder.registerCustomEditor(Date.class, "from", dateEditor1);

	CustomDateEditor dateEditor2 = new CustomDateFormat(new SimpleDateFormat("HH:mm"),true);
	binder.registerCustomEditor(Date.class, "reserveTime", dateEditor2);
}
~~~~


위 코드를 보면 CustomDateEditor 생성자의 두번째 파라미터로 true를 전달했다. 이 값이 true면 요청 파라미터 값이 null 이거나 빈 문자열("") 일 때 변환 처리를 하지 않고 null을 값으로 할당한다. 이 값이 false면 타입 변환 과정에서 에러가 발생하고, 에러코드로 "typeMismatch"가 추가된다.



##### WebDateBinder와 ConversionService

<mvc:annotation-driven> 태그는 많은 설정을 해준다.
아래 코드는 일부이다.
~~~~
<!-- 이름이 conversionService가 아니므로 설정 정보를 변환할 때는 사용되지 않음 -->
<bean id="formattingConversionService" calss="생략.format.support.FormattingConversionServiceFactorBean" />

<bean id="configurableWebBindingInitializer" class="생략.web.bind.support.ConfigurableWebBindingInitalizer">
	<property name="conversionService" ref="formattingConversionService" />
</bean>

<bean id="requestMappingHandlerAdapter" class="생략.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter">
	...
	<property name="webBindingInitializer" ref="configurableWebbindingInitializer" />
</bean>

~~~~


위 코드에서 ConfigurableWebBindingInitializer는 WebDateBinder를 초기화 해주는 기능을 제공한다. 클라이언트의 요청을 컨트롤러 객체에 전달해주는 RequestMappingHandlerAdapter는 이 WebBindingInitializer를 이요해서 컨트롤러에 전달할 WebDataBinder 객체를 생성하고 초기화한다.

그런데, 위 설정을 보면 ConfigurableWebbindingInitializer를 설정할 때 FormattingConversionServiceFactoryBean이 생성한 ConversionService를 설정하고 있는 것을 알 수 있다. ConfigurableWebBindingInitializer는 WebDataBinder를 생성할 때 이 ConversionService 객체를 전달한다. 즉, WebDataBinder는 PropertyEditor 뿐만 아니라 ConversionService를 이용해서 요청 파라미터를 알맞은 타입으로 변환한다.

<mvc:annotation-driven> 태그(또는 @EnableWebMvc)를 사용하면 DefaultFormattingConversionService가 WebDataBinder의 ConversionService로 사용되는데, 이는 @DateTimeFormat 애노테이션과 @NumberFormat 애노테이션을 이용해서 요청 파라미터를 날짜/시간 타입이나 숫자 타입으로 변환할 수 있다는 것을 의미한다.

###### @DateTimeFormat 애노테이션을 이용한 날짜/시간 변환

@DateTimeFormat 애노테이션은 특정 형식을 갖는 요청 파라미터를 java.util.Date 타입이나 java.time.LocalDate 타입과 같이 날짜/시간 타입으로 변환할 때 사용된다. 예를 들어, 생일을 입력받기 위해 다음과 같은 <input> 태그를 사용했다고 하자.

~~~~
<input type="text" name="birthday" />
<form:errors path="memberInfo.birthday" />
~~~~

생일을 20140101과 같은 형식으로 입력하도록 했다. 이 값을 전달받을 커맨드 객체의 필드는 다음과 같이 Date 타입을 사용했다.

~~~~
public class MemberRegistRequest{
	...
	private Date birthday;

	public Date getBirthday(){
		return birthday;
	}

	public void setBirthday(Date birthday){
		this.birthday = birthday;
	}
}

~~~~

아래와 같이 폼 값을 전달받기 위해 MemberRegistRequest를 커맨드 객체로 사용한다고 가정해보자.

~~~~
@RequestMapping(method=RequestMethod.POST)
public String regist(@ModelAttribute("memberInfo") MemberRegistRequest memberRegReq, BindingResult bindingResult){
	new MemberRegistValidator().validate(memberRegReq, bindingResult);

}
~~~~


여기서 문제는 "20140101" 형식으로 전송되는 요청 파라미터를 Date 타입으로 변환해주어야 한다는 점이다. 앞서 살펴본 CustomDateEditor를 사용해도 되지만, @DateTimeFormat 애노테이션을 사용하면 좀 더 간단하게 처리할 수 있다. 다음과 같이 날짜/시간 타입 필드에 @DateTimeFormat 애노테이션을 사용해주면 끝난다.

~~~~
import org.springframework.format.annotation.DateTimeFormat;
public class MemberRegistRequest{
	...
	@DateTimeFormat(pattern="yyyyMMdd")
	private Date birthday;
}

~~~~

스프링은 요청 파라미터의 값을 커맨드 객체의 프로퍼티로 복사하는 과정에서 시간 타입을 갖는 프로퍼티에 @DateTimeFormat 애노테이션이 붙어 있으면, 애노테이션에 설정한 형식을이용해서 요청 파라미터 값을 변환한다. 위 코드의 경우 @DateTimeFormat 의 pattern 값으로 "yyyyMMdd"를 사용했으므로 요청 파라미터가 "20160815"일 경우, 2015년 8월 15일에 해당하는 Date 객체가 birth 필드에 할당한다.

@DateTimeFormat에서 사용할 패턴을 "yyyyMMdd"로 지정했는데, 요청한 파라미터 값이 다른 형식인 경우 해당 필드의 에러코드로 "typeMismatch"가 추가된다. 따라서, 잘못된 형식일 때 알맞은 메시지를 출력하고 싶다면, 메시지 프로퍼티 파일에 "typeMismatch" 메시지를 추가해주면 된다.

~~~~
#메시지 파일
typeMismatch.birthday=날짜 형식이 올바르지 않습니다.
~~~~

만약 Errors는 BindingResult 타입의 파라미터가 없다면, 스프링은 타입 변환 실패시 400 응답 에러를 발생시킨다. 예를 들어, 아래 코드처럼 커맨드 객체 다음에 Error 타입의 파라미터가 없다고 해보자.

~~~~
//Errors/BindingResult 타입 파라미터가 없을 경우, 잘못된 형식의 요청 파라미터가 전송되면 400 응답 에러를 발생시킨다.
@RequestMappgin(method=RequestMethod.POST)
public String regist(@ModelAttribute("memberInfo") MemberRegistRequest regReq){
	...
}
~~~~

이 상태에서 @DateTimeFormat(pattern="yyyyMMdd") 가 붙은 필드에 해당하는 요청 파라미터의 값으로 "1234-5-6"과 같이 잘못된 형식의 값이 오면, regist() 메서드를 실행하지 않고 400 에러 코드를 웹 브라우저에 응답한다.

###### @DateTimeFormat 애노테이션의 속성과 설정 방법

@DateTimeFormat 애노테이션은 날짜/시간 형식을 지정하기 위해 세 개의 속성을 사용한다.

<table>
<tr><th>속성</th><th>값</th></tr>
<tr>
<td>style</td>
<td>S, M, L, F 를 이용해서 날짜/시간을 표현한다. 날짜와 시간이 각각 한 글자를 사용하며, 날짜나 시간을 생략할 경우 '-' 를 사용한다. "SS", "S-", "-F"과 같은 값을 같는다.<br>* S:짧은표현<br>* M:중간 표현<br>* L: 긴 표현<br>* F: 완전한 표현</td>
</tr>
<tr>
<td>iso</td>
<td>@DateTimeFormat의 중첩 타입인 ISO 열거 타입에 정의된 값을 사용한다. <br>* ISO.DATE : yyyy-MM-dd 형식<br>* ISO:TIME : HH:mm:ss.SSSZ 형식(13:40:50.113+08:30)<br>* ISO.DATE_TIME : yyyy-MM-dd'T'HH:mm:ss.SSSZ 형식</td>
</tr>
<tr>
<td>pattern</td>
<td>java.text.DateFormat에 정의된 패턴을 사용한다.</td>
</tr>
</table>

##### @NumberFormat 애노테이션을 이용한 숫자 변환

@NumberFormat 애노테이션은 특정 형식을 갖는 문자열을 숫자 타입으로 변환할 때 사용된다. (org.springframework.format.annotation 패키지에 속해 있다.) 사용 방법은 @DateTimeFormat 애노테이션과 비슷하며, @NumberFormat 애노테이션의 속성은 다음과 같다.

<table>
<tr><th>속성</th><th>값</th></tr>
<tr>
<td>pattern</td>
<td>java.text.NumberFormat에 따른 숫자 형식을 입력한다.</td>
</tr>
<tr>
<td>style</td>
<td>@NumberFormat 의 중첩 타입인 Style열거 타입에 정의된 값을 사용한다.
<br>*  Style.NUMBER : 현재 로케일을 위한 숫자 형식<br>* Style.CURRENCY : 현재 로케일을 위한 통화 형식<br>* Style.PERPECT : 현재로케일을 위한 백분율 형</td>
</tr>
</table>

##### 글로벌 변환기 등록하기

WebDataBinder / @InitBinder 를 이용하는 방법은 단일 컨트롤러에만 적용된다. 경우에 따라 전체 컨트롤러에 동일한 변환 방식을 적용하고 싶을 때가 있는데, 이 때에는 ConversionService를 직접 생성해서 등록하는 방법을 사용한다. ConversionService를 설정할 떄에는 스프링 MVC가 기본으로 사용하는 FormattingConversionServiceFactoryBean를 사용하면 된다.

~~~~
<mvc:annotation-driven conversion-service="formattingConversionServie" />

<bean id="formattingConversionService" class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
	<property name="formatters">
		<set>
			<bean class="com.company.MoneyFormatter" />
		</set>
	</property>
</bean>
~~~~

@EnableWebMvc 애노테이션을 사용한다면, 다음과 같이 WebMvcConfigurerAdapter 클래스의 addFormatters() 메서드를 재정의해서 registry에 Formatter를 등록하면 된다.

~~~~
import org.springframework.format.FormatterRegistry;

@Configuration
@EnableWebMvc
public class Config extends WebMvcConfigurerAdapter{

	@Override
	public void addFormatters(FormatterRegistry registry){
		registry.addFormatter(new MoneyFormatter());
	}
}
~~~~

#### HTTP 세션 사용

트래픽이 작거나 단일 서버에서 동작하는 웹 어플리케이션의 경우 서블릿의 HttpSession을 이용해서 사용자 로그인 상태를 유지하는 경우가 많다. 스프링은 컨트롤러에 HttpSession을 처리하기 위한 기능이 있다.

여러 화면에 걸처서 진행되는 작업을 처리하면, 화면과 화면 사이에 데이터를 공유해야 할 일이 생긴다.

이런 상황에스 스프링은 @SessionAttributes 애노테이션을 지원한다.

* 클래스에 @SessionAttributes를 적용하고, 세션으로 공유할 객체의 모델 이름을 지정한다.
* 컨트롤러 메서드에서 객체를 모델에 추가한다.
* 공유한 모델의 사용이 끝나면 SessionStatus를 사용해서 세션에서 객체를 제거한다.

~~~~
import org.springframework.web.bind.annotation.SessionAttributes;

@Controller
@SessionAttributes("tempForm");
public class Controller{

	@RequestMapping("temp")
	public String tmpe1(Model model){
		model.addAttribute("tempForm", new TempForm());
		return "..";
	}

	@RequestMapping("temp2")
	public String tmpe2(@ModelAttribute("tempForm") TempForm temeForm, BindingResult result){
		new TempFormValidator().validate(tempForm, result);
		if(result.hasErrors(){
			return "..";
		}else return "..";
	}
~~~~

~~~~
<form:form commandName="tempForm" action="/temp2">

....

</form:form>
~~~~

또 다른 방법으로는 @ModelAttribute메서드를 사용하는 것이다.

~~~~
@Controller
@SessionAttributes("tempForm");
public class Controller{

	@ModelAttribute("tempForm")
	public TempFOrm formDate(){
		return new TempForm();
	}

	@RequestMapping("temp")
	public String tmpe1(Model model){
		return "..";
	}

	@RequestMapping("temp2")
	public String tmpe2(@ModelAttribute("tempForm") TempForm temeForm, BindingResult result){
		new TempFormValidator().validate(tempForm, result);
		if(result.hasErrors(){
			return "..";
		}else return "..";
	}

~~~~


위 코드처럼 @ModelAttribute가 적용된 메서드에서 모델 객체를 생성하면 @RequestMapping메서드에 Model에 객체를 추가할 필요가 없다. 위 코드를 보면 formDate()에  @ModelAttribute 메서드가 적용되어 있는데, 이 경우 매번 새로운 TempForm()객체가 생성되기 때문에 이상하지만 스프링은 @ModelAttritebu가 적용된 메서드를 실행하기 전에 세션에 동일 이름을 갖는 객체가 존재하면 그 객체를 모델 객체로 사용한다.

~~~~
@RequestMapping
public String temp(@ModelAttribute("tempForm") TempForm formDate, SessionStatus sessionStatus){
	sessionStatus.setComplete();
}
~~~~
세션에서 객체 제거. 


#### 익셉션 처리

* @ExceptionHandler 애노테이션
* @ControllerAdvice 애노테이션을 이용한 공통 익셉션
* @ResponseStatus 애노테이션

~~~~
@Controller
public class Controller{


	@RequestMapping()
	public String foo(){

	}

	@ExceptionHandler(ArithmeticException.class)
	public String handleException(){
		
		return "error/exception";
	}

}

~~~~

> ExceptionHandeler 처리?
> 스프링 MVC는 컨트롤러에서 익셉션이 발생하면 HandlerExceptionResolver에 처리를 위임한다. HandlerExceptionResolver에는 여러 종류가 존재하는데, MVC 설정(mvc:annotation-driven) 태그나  @EnabelWebMvc 애노테이션)을 사용할 경우 내부적으로 ExceptionHandlerExceptionResolver를 등록한다. 이 클래스는 @ExceptionHandler 애노테이션이 적용된 메서드를 이용해서 익셉션을 처리하는 기능을 제공하고 있다. MVC 설정을 사용할 경우 다음의 순서대로 HandlerExceptionResolver를 사용하게 된다.
> 1. ExceptionHandlerExceptionResolver : 발생한 익셉션과 매칭되는 @Exception Handler 메서드를 이용해서 익셉션을 처리한다.
> 2. DefaultHandlerExceptionResolver : 스프링이 발생시키는 익셉션에 대한 처리. 예를 들어 , 요청 URL에 매핑되는 컨트롤러가 없을 경우 NoHandlerFoundException 이 발생하는데 이 경우 DefaultHandlerExceptionResolver는 404 에러 코드를 응답으로 전송한다.
> 3. ResponseStatusExceptionResolver : 익셉션 타입에 @ResponseStatus 애노테이션이 적용되어 있을 경우, @ResponseStatus 애노테이션의 값을 이용해서 응답 코드를 전송한다.
DispatcherServlet은 익셉션이 발생하면 가장 먼저 ExceptionHandlerExceptionResolver에 익셉션 처리를 요청한다. 만약 익셉션에 매핑되는 @ExceptionHandler메서드가 존재하지 않으면 ExceptionHandlerExceptionResolver 는 익셉션을 처리하지 않는다. 익셉션이 처리되지 않으면 그 다음 차례인 DefaultHandlerExceptionResolver 를 사용하고, 여기서도 익셉션을 처리하지 않으면 마지막으로   ResponseStatusExceptionResolver를 사용한다. 여기서도 처리하지 않으면 컨테이너가 익셉션을 처리하게 만든다.

##### @ControllerAdvice 를 이용한 공통 익셉션 처리
~~~~
@ControllerAdvice("com.company")
public class CommonExceptionHandler{
	@ExceptionHandler(RuntimeException.calss)
	public String handleRuntimeException(){    
		return "error/commonException";
	}
}
~~~~

지정한 범위를 설정할수 있다. 이 클래스가 동작하려면 스프링빈으로 등록해주어야 한다.

1. 같은 컨트롤러에 위치한 @ExceptionHandler 메서드중 해당 익셉션을 처리할 수 있는 메서드를 검색
2. 같은 클래스에 위치한 메서드가 익셉션을 처리할 수 없을 경우, @ControllerAdvice 클래스에 위치한 @ExceptionHandler 메서드 검색

@ControllerAdvice의 속성

<table>
<tr><th>속성</th><th>타입</th><th>설명</th></tr>
<tr>
<td>value<br>basePackages</td>
<td>String[]</td>
<td>공통 설정을 적용할 컨트롤러들이 속하는 기준 패키지</td>
</tr>
<tr>
<td>annotations</td>
<td>Class<? extends Annotation>[]</td>
<td>특정 애노테이션이 적용된 컨트롤러 대상</td>
</tr>
<tr>
<td>assignableTypes</td>
<td>Class<?>[]</td>
<td>특정 타입 또는 그 하위 타입인 컨트롤러 대상</td>
</tr>
</table>


~~~~

##### @ResponseStatus 를 이용한 익셉션의 응답 코드 설정

~~~~
@ResponseStatus(HttpStatus.NOT_FOUND)
public class NoFileInfoException extends Exception{}
~~~~

@ResponseStatus의 값은 HttpStatus를 사용한다. HttpStatus열거 타입은 여러 응답 코드를 위한 열거 값을 정의하고 있다.

org.springframework.http.HttpStatus 열거 타입에서 주로 사용되는 값.

* OK(200, "OK")
* MOVEN_PERMANENTLY(301, "Moved Permanently")
* NOT_MODIFIED(304, "Not Modified")
* TEMPORARY_REDIRECT(307, "Temporary Redirect")
* BAD_REQUEST(400, "Bad Request")
* UNAUTHORIZED(401, "Unauthorized")
* PAYMENT_REQUIRED(402, "Payment Required")
* FORBIDDN(403, "Forbidden")
* NOT_FOUND(404, "Not Found")
* METHOD_NOT_ALLOW(405, "Method Not Allow")
* NOT_ACCEPTABLE(406, "Not Acceptable")
* UNSUPPORTED_MEDIA_TYPE(415, "Unsupported Media Type")
* TOO_MANY_REQUESTS(429, "Too Many Requests")
* INTERNAL_SERVER_ERROR(500, "Internal Server Error")
* NOT_IMPLEMENTED(501, "Not Implemented")
* SERVICE_UNAVAILABLE(503, "Service Unavailable")

> 서비스/도메인/영속성 영역의 익셉션 코드에서는 @ResponseStatus를 사용하지 말것
> 컨트롤러 영역의 익셉션이 아닌 서비스/도메인/영속성 영역의 익셉션에 @ResponseStatus애노테이션을 적용하지 않도록 하자. @ResponseStatus 애노테이션은 그 자체가 HTTP 요청/응답 영역인 UI 처리의 의미를 내포하고 있기 때문에 서비스/도메인/영속성 영역의 코드에 @ResponseStatus 애노테이션을 사용하면 UI영역에 의존하는 결과를 만든다. 이 경우 UI를 HTTP에서 소켓을 직접 이용하는 방식으로 변경하면 서비스/도메인/영속성 코드도 함께 영향을 받을 가능성이 높아진다.


#### 컨트롤러 메서드의 파라미터 타입과 리턴타입

@RequestMapping 애노테이션이 적용된 메서드에서 사용할 수 있는 파라미터 타입

<table>
<tr><th>파라미터</th><th>설명</th></tr>
<tr>
<td>HttpServletRequest, HttpServletResponse</td>
<td>요청/응답 처리를 위한 서블릿 API</td>
</tr>
<tr>
<td>HttpSession</td>
<td>HTTP 세션을 위한 서블릿 API</td>
</tr>
<tr>
<td>org.springframe.ui.Model, org.springframework.ui.ModelMap, java.util.Map</td>
<td>뷰에 데이터를 전달하기 위한 모델</td>
</tr>
<tr>
<td>@RequestParam</td>
<td>HTTP 요청 파라미터 값</td>
</tr>
<tr>
<td>@RequestHeader, @CookieValue</td>
<td>요청 헤더와 쿠키 값</td>
</tr>
<tr>
<td>@PathVariable</td>
<td>경로 변수</td>
</tr>
<tr>
<td>커맨드객체</td>
<td>요청 데이터를 저장할 객체</td>
<tr>
<td>Errors, BindingResult</td>
<td>검증 결과를 보관할 객체, 커맨드 객체 바로 뒤에 위치해야함</td>
</tr>
<tr>
<td>@RequestBody(파라미터에 적용)</td>
<td>요청 몸체를 객체로 변환. 요청 몸체의 JSON이나 XML을 알맞게 객체로 변환.</td>
</tr>
<tr>
<td>Writer, OutputStream</td>
<td>응답 결과를 직접 쓸 때 사용할 출력 스트림</td>
</tr>
</table>

리턴타입

<table>
<tr><th>리턴 타입</th><th>설명</th></tr>
<tr>
<td>String</td>
<td>뷰 이름</td>
</tr>
<tr>
<td>void</td>
<td>컨트롤러에서 응답을 직접 생성</td>
</tr>
<tr>
<td>ModelAndView</td>
<td>모델과 뷰 정보를 함께 리턴</td>
</tr>
<tr>
<td>객체</td>
<td>메서드에 @ResponseBody가 적용된 경우, 리턴 객체를 JSON이나 XML과 같은 알맞은 응답으로 변환</td>
</tr>
</table>

리턴 타입이 void 인 경우 컨트롤러에서 직접 응답을 생성하는 것을 뜻한다.
