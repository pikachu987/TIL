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