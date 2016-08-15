### 커맨드 객체 값 검증과 에러 메시지

웹 개발에서 깁력 폼의 값이 올바른지 검증하는 것은 매우 중요한 작업이다. 요청 파라미터 값을 확인하지 않고 그대로 사용하게 되면, 데이터베이스 등에 잘못된 데이터가 들어갈 가능성이 높아지게 된다. 요청 파라미터 값을 검사할 때에는 크게 두 가지 방법을 이용한다.

* 웹 브라우저 : 자바 스크립트를 이용해서 데이터를 웹 서버에 전송하기 전에 미리 검사한다.
* 웹 서버 : 전달받은 요청 파라미터의 값을 검사한다. 파라미터 값이 올바르지 않을 경우 에러 코드를 응답하거나 재입력을 위한 폼 화면을 웹 브라우저에 전송한다.

스프링은 이 두 영역 중에서 서브 측의 요청 파라미터 검사 기능을 지원하고 있다.
> 웹 브라우저에서 자바 스크립트를 이용해서 폼 값을 검사하는 것은 사용자에게 빠르게 검사 결과를 보여 줄 수 있기 때문에 사용자 입장에서 중요하다. 하지만, 악의적으로 잘못된 데이터를 서버에 전송하거나 클라이언트에서 완전히 값을 검증하지 못할 수도 있기 때문에, 서버에서도 반드시 값을 검증해야 한다.

#### Validator와 Errors/BindingResult를 이용한 객체 검증

org.springframework.validation.Validator 인터페이스를 사용하면, 스프링이 제공하는 객체 검증 및 에러 메시지 지원 등의 기능을 사용할 수 있다. 컨트롤러에서 커맨드 객체의 값을 검증할 때 특히  Validator를 유용하게 사용할 수 있다.

Validator 인터페이스는 다음과 같이 두 개의 메서드를 정의하고 있다.

~~~~
package org.springframework.validation;

public interface Validator{
	boolean supports(Class<?> clazz);
	void validate(Object target, Errors erros);
}
~~~~


supports() 메서드는 Validator 가 해당 타입의 객체를 지원하는지 여부를 리턴한다. 실제 값을 검증하는 코드는 validate() 메서드에 위치한다. validate()메서드의 target파라미터는 값을 검증할 객체이며, errors 파라미터는 값이 올바르지 않을 경우 그 내용을 저장하기 위해 사용된다.

~~~~
@Override
public void validate(Object target, Errors erros){
	.....
	//null이면
	//errors.rejectValue() 를 이용해서 email 프로퍼티에 에러가 있음을 저장한다.
	errors.rejectValue("email", "required");	

	....
    //regReq의 name프로퍼티가 null 이거나 값이 없으면 에러가 있음을 저장한다. ValidationUtils 클래스를 이용하면 코드를 좀 더 간결하게 표현 할 수 있다.
	ValidationUtils.rejectIfEmptyOrWhitespace(errors, "name", "required");

	....
	//중첩 프로퍼티에 대한 검사를 할 경우 ,errors에 중첩 프로퍼티 진입을 지정한다.
	errors.pushNestedPath("address");

	....
	//중첩 프로퍼티에 대한 검사가 끝나면, errors에 중첩 프로퍼티 끝을 지정한다.
	errors.popNestedPath();
}

~~~~

Validator 구현 코드에서 Errors.rejectValue() 메서드를 이용해서 잘못된 프로퍼티를 등록했을때 이렇게 reject 메서드를 이용하면 데이터에 오류가 있다고 등록하게 된다. 따라서, Validator 에서 Errors의  reject 메서드를 한 번 이상 호출하면 Errors.hasErrors() 메서드는 true를 리턴하게 된다.

> 커맨드 객체의 에러 정보를 담기 위해 사용되는 Errors 파라미터나 BindingResult 파라미터는 반드시 커맨드 객체 파라미터 바로 뒤에 위치해야 한다.
> @RequestMapping(method = RequestMethod.POST)
> public String regist(@ModelAttribute("memberInfo") MemberRegisRequest memberRegReq, BindingResult bindingResult, HttpServletResponse response){}
> 만약 Errors나 BindingResult 가 커맨드 객체 바로 뒤에 위치하지 않으면 스프링 MVC는 익셉션을 발생시킨다.


#### Errors와 BindingResult 인터페이스의 주요 메서드

Validator는 객체 데이터에 오류가 있을 경우 Errors 객체에 오류를 등록한다. org.springframework.validation.Errors 인터페이스는 오류를 등록하기 위한 다양한 메서드를 제공하고 있으며, 주요 메서드는 다음과 같다.

*  reject(String errorCode)
*  > 전체 객체에 대한 글로벌 에러 코드를 추가한다.
*  reject(String errorCode, String defaultMessage)
*  > 전체 객체에 대한 글로벌 에러 코드를 추가한다. 에러 코드에 대한 메시지가 존재하지 않을 경우 defaultMessage를 사용한다.
*  reject(String  errorCode, Object[] errorArgs, String defaultMessage)
*  > 전체 객체에 대한 글로벌 에러 코드를 추가한다. 메시지 인자로 errorArgs를 전달한다. 에러 코드에 대한 메시지가 존재하지 않을 경우 defaultMessage를 사용한다.
*  rejectValue(String field, String errorCode)
*  > 필드에 대한 에러 코드를 추가한다.
*  rejectValue(String field, String errorCode, String defaultMessage)
*  > 필드에 대한 에러 코드를 추가한다. 에러 코드에 대한 메시지가 존재하지 않을 경우 defaultMessage를 사용한다.
*  rejectValue(String field, String errorCode, Object[] errorArgs, String defaultMessage)
*  > 필드에 대한 에러 코드를 추가한다. 메시지 인자로 errorsArgs를 전달한다. 에러 코드에 대한 메시지가 존재하지 않을 경우 defaultMessage를 사용한다.

reject() 메서드는 객체 자체의 에러 정보를 추가할 때 사용된다. 예를 들어, 로그인을 처리하는 경우 아이디와 암호가 일치하지 않으면 로그인 폼을 다시 보여주고 에러 정보를 에러 정보를 출력할 것이다. 이 경우 아이디 필드나 암호 필드에 에러가 있다기 보다는 개체 자체에 문제가 있다고 볼 수 있다. 이렇게 객체 자체에 문제가 있는 경우 다음과 같이 reject() 메서드를 사용해서 글로벌 에러 정보를 추가할 수 있다.

글로벌 에러 정보나 특정 필드에 대한 에러 정보는 두 번 이상 추가될 수 있다. 예를 들어 다음과 같이 특정 필드에 대해 에러 정보를 두 번 이상 등록할 수 있다.

~~~~
errors.rejectValue("id", "invalidLength");
errors.rejectValue("id", "invalidCharacter");
~~~~


Errors 인터페이스는 에러가 발생했는지의 여부를 확인할 수 있도록 다음과 같은 메서드를 제공한다.

* boolean hasErros()
* > 에러가 존재하는 경우 true를 리턴한다.
* int getErrorCount()
* > 에러 개수를 리턴한다.
* boolean hasGlobalErrors()
* > reject() 메서드를 이용해서 추가된 글로벌 에러가 존재할 경우 true를 리턴한다.
* int getGlobalErrorCount()
* > reject() 메서드를 이용해서 추가된 글로벌 에러 개수를 리턴한다.
* boolean hasFieldErrors()
* > rejectValue() 메서드를 이용해서 추가된 에러가 존재할 경우 true를 리턴한다.
* int getFieldErrorCount()
* > rejectValue() 메서드를 이용해서 추가된 에러 개수를 리턴한다.
* boolean hasFieldErrors(String field)
* > rejectValue() 메서드를 이용해서 추가한 특정 필드의 에러가 존재할 경우 true를 리턴한다.
* int getFieldErrorCount(String field)
* > rejectValue() 메서드를 이용해서 추가한 특정 필드의 에러 개수를 리턴한다.

위 메서드를 이용하면 에러 존재 여부에 따라서 알맞은 처리를 수행할 수 있다. 예를 들어, 폼 검증 결과 에러가 존재해서 다시 폼을 보여주도록 하고 있으면, 다음과 같이 hasErrors() 메서드를 이용해서 검증 에러 존재 여부를 확인할 수 있다.

org.springframework.validation.BindingResult 인터페이스는 Errors 인터페이스를 상속 받았으며, 에러 메시지를 구하고나 검증 대상 객체를 구하는 등의 추가 기능을 정의하고 있다. BindingResult 인터페이스에 정의된 메서드 중 주요 메서드는 다음과 같다. ( 실제로 컨트롤러 구현 과정에서 BindingResult 인터페이스의 메서드를 직접 호출하는 경우는 거의 없기 때문에, 이런 메서드가 있다는 정도로만 이해하자.)

* Object getTarget()
* > 검사 대상이 되는 객체를 구한다. 컨트롤러의 경우 커맨드 객체가 된다.
* String[] resolveMessageCodes(String errorCode)
* > 에러 코드를 메시지 코드로 변환한다.
* String[] resolveMessageCodes(String errorCode, String field)
* > 에러 코드를 field에 해당하는 메시지 코드로 변환한다.

참고로, 메시지 코드는 뒤에서 설명할 에러 메시지 출력에 사용된다.

##### ValidationUtils 클래스를 이용한 값 검증

Validator 구현 클래스의 validate() 메서드에서는 프로퍼티의 값이 존재하는지 확인하기 위해 다음과 같이 값이 null 또는 공백 문자인지 여부를 확인한다.

~~~~
@Override
public void validate(Object target, Errors errors){
	MemberRegisRequest regReq = (MemberRegisRequest) target;
	if(regReq.getEmail() == null || regReq.getEmail().trim().isEmpty()) errors.rejectValue("email", "required");
}

~~~~

각 프로퍼티에 대해서 매번 위와 같은 코드를 작성하는 것은 매우 성가시고 비교를 누락하는 등의 실수를 유발하기도 한다. org.springframework.validation.ValidationUtils 클래스가 제공하는 메서드를 사용하면 코드를 간결하게 유지하면서도 불필요한 실수를 줄일 수 있다. ValidationUtils 클래스는 다수의 rejectEmpty() 메서드와 rejectIfEmptyOrWhitespace() 메서드를 제공하고 있으며, 이들 메서드를 이용해서 다음과 같이 위 코드를 대체할 수 있다.
~~~~
public void validate(Object target, Errors errors){
	ValidationUtils.rejectIfEmptyOrWhitespace(errors, "email", "required");
	....
}
~~~~

ValidationUtils.rejectIfEmpty() 메서드는 값이 null이거나 길이가 0인 경우 에러코드를 추가하며, rejectIfEmptyOrWhitespace() 메서드는 값이 null이거나 길이가 9이거나 또는 값이 공백문자로 구성되어 있는 경우 에러코드를 추가한다.


* rejectIfEmpty(Errors errors, String field, String errorCode)
* rejectIfEmpty(Errors errors, String field, String errorCode, String defaultMessage)
* rejectIfEmpty(Errors errors, String field, String errorCode, Object[] errorArgs)
* rejectIfEmpty(Errors errors, String field, String errorCode, Object[] errorArgs, String defaultMessage)
* rejectIfEmptyOrWhitespace(Errors errors, String field, String errorCode)
* rejectIfEmptyOrWhitespace(Errors errors, String field, String errorCode, String defaultMessage)
* rejectIfEmptyOrWhitespace(Errors errors, String field, String errorCode, Object[] errorArgs)
* rejectIfEmptyOrWhitespace(Errors errors, String field, String errorCode, Object[] errorArgs, String defaultMessage)

메서드 파라미터에서 errorArgs는 에러 메시지에 삽입될 인자 목록이고, defaultMessage는 에러 코드에 해당하는 에러 메시지가 존재하지 않을 때 사용할 기본 메시지이다.

##### 에러 코드와 메시지

Validator를 이용해서 오류를 확인하면, 오류 내용을 화면에 보여주고 싶을 것이다. 오류 내용을 알려줄 때 사용할 수 있는 것이 에러코드다. 스프링 MVC는 에러코드로부터 메시지를 가져오는 방법을 제공하고 있으며, 이 메시지를 응답 결과에 보여주는 방법 또한 제공하고 있다. 검증 과젖ㅇ에서 추가된 에러 메시지를 사용하려면 다음과 같은 코드를 작성해야 한다.

* 메시지를 읽어올 때 사용할 MessageSource를 스프링 설정에 등록
* MessageSoruce 에서 메시지를 가져올 때 사용할 프로퍼티 파일을 작성
* JSP와 같은 뷰 코드에서 스프링이 제공하는 태그를 이용해서 에러 메시지를 출력한다.

~~~~
<bean id="messageSource" class="org.springframework.context.support.ResourceBundleMessageSource">
	<property name="beannames">
		<list>
			<value>message.error</value>
		</list>
	</property>
	<property name="defaultEncoding" value="UTF-8"/>
</bean>
~~~~


위 설정의 경우 message 패키지에 위치한 error.properties 파일(또는 error_언어.properties 파일) 로부터 메시지를 읽어오도록 설정했다. error.properties파일은 다음과 같이 에러 내용을 보여줄 때 사용할 메시지를 담고 있을 것이다.

스프링 MVC는 에러 코드로부터 생성된 메시지 코드를 사용해서 에러 메시지를 출력하게 된다.

글로벌 에러 코드인 경우 다음의 우선순위에 따라 메시지 코드를 생성한다.

1.에러코드 + "." + 커맨드객체이름
2.에러코드

Errors.rejectValue() 를 이용해서 생성한 에러코드는 다음의 우선순위를 사용해서 메시지 코드를 생성한다.

1. 에러코드+"."+커맨드객체이름+"."+필드명
2. 에러코드+"."+필드명
3. 에러코드+"."+필드타입
4. 에러코드

필드가 List나 목록인 경우 다음의 순서를 사용해서 메시지 코드를 생성한다.

1. 에러코드+"."+커맨드객체이름+"."+필드명[인덱스].중첩필드명
2. 에러코드+"."+커맨드객체이름+"."+필드명.중첩필드명
3. 에러코드+"."+필드명[인덱스].중첩필드명
4. 에러코드+"."+필드명.중첩필드명
5. 에러코드+"."+중첩필드명
6. 에러코드+"."+필드타입
7. 에러코드

에러 메시지 프로퍼티 파일이 아래와 같고, email, password 프로퍼티에 값이 없어서 둘 다 에러코드로 "required"를 등록해다고 하자.
~~~~
required=필수 항목입니다.
required.email=이메일을 입력하세요.
~~~~
이 경우, 메시지 코드 우선순위에 따라 "email" 프로퍼티의 에러 메시지는 "required.email" 메시지를 이용하고 "password" 프로퍼티 에러메시지는 "required" 메시지를 이용하게 된다.

##### 에러 메시지 출력
스프링 MVC는 JSP에서 에러 메시지를 출력할 수 있도록 커스텀 태그를 제공하고 있다. JSP에서 에러메시지를 출력하는 가장 쉬운 방법은 스프링이 제공하는 <form:form> 태그와 <form:errors> 태그를 함께 사용하는 것이다.

~~~~
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
~~~~

스프링 <form:form> 커스텀 태그는 HTML <form> 태그 대신 사용할 수 있는데, 이 태그를 사용하면 스프링 폼 관련 태그에서 커맨드 객체 정보를 사용할 수 있다. 
<form:errors> 태그는 <form:form> 태그에서 지정한 커맨드 객체의 에러코드를 이용해서 에러 메시지를 출력한다.

<form:form> 태그를 사용하지 않고 HTML <form>태그를 사용하고 싶다면 <spring:hasBindErrors> 태그는 <form:errors> 태그를 사용하면 된다.


~~~~
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
~~~~

##### @Valid 애노테이션과 @InitBinder 애노테이션을 이용한 검증 실행

JSR 303 표준에 정의된 @Valid 애노테이션을 이용하면 커맨드 객체를 검사하는 코드를 직접 호출하지 않고 스프링 프레임워크가 호출하도록 설정할 수 있다. JSR 303은 Bean Validation API로서 이 표준에 정의된 @Valid 애노테이션을 사용해서 커맨드 객체의 유효성을 검증한다는 것을 표시한다.

> @Valid 애노테이션을 사용하려면 JSR 303 API를 추가해야햐 한다.
> <groupId>javax.validation</groupId>
> <artifactId>validation-api</artifactId>
> <version>1.0.0.GA</version>

##### 글로벌 Validator 와 컨트롤러 Validator

글로벌 Validator 를 사용하면 한 개의 Validator를 이용해서 모든 커맨드 객체를 검증할 수 있다. 글로벌 Validator를 적용하는 방법은 간단한다. 다음과 같이 <mvc:annotation-driven> 태그의 validator 속성에 글로벌 Validator로 사용할 빈을 등록해주면 된다.
~~~~
<mvc:annotation-driven validator="validator"/>
<bean id="validator" class="custom.CommonValidator"/>
~~~~


글로벌 Validator가 커맨드 객체에 대한 검증을 지원하지 않으면 (즉, 글로벌 Validator 의 supports() 메서드가 false를 리턴하면), 글로벌 Validator는 커맨드 객체를 검증하지 않는다.
글로벌 Validator 를 사용하지 않고 다른 Validator를 사용하려면 @InitBinder가 적용된 메서드에서 WebDataBinder의 setValidator() 메서드를 이용하면 된다. 예를 들어 아래 코드는 글로벌 Validator 대신 LoginCommandValidator를 사용해서 LoginCommand객체를 검증한다.

~~~~
@RequstMapping(.....)
public String login(@Value LoginCommand loginCommand, Errors errors(){
	...
}

@InitBinder
protected void initBinder(WebDataBinder binder){
	//글로벌 Validator가 아닌 다른 Validator 사용
	binder.setValidator(new LoginCommandValidator());
}

~~~~


글로벌 Validator 를 사용하면서 컨트롤러를 위한 Validator를 추가하고 싶다면 setValidator() 대신 addValidator() 메서드를 사용해서 Validator를 등록해주면 된다.

~~~~
@InitBinder
protected void initBinder(WebDataBinder binder){
	//글로벌 Validator가 아닌 다른 Validator 사용
	binder.addValidator(new LoginCommandValidator());
}
~~~~

@EnableWebMvc 애노테이션을 사용했다면, 다음과 같이 WebMvcConfigurerAdapter 를 상속받은 @Configuration 클래스에서 글로벌 Validator 객체를 생성하도록 getValidator()메서드를 재정의 한다.

~~~~
@Configuration
@EnableWebMvc
public class Config extends WebMvcConfigurerAdapter{

	@Override
	public Validator getValidator(){
		return new CommonValidation();
	}
}
~~~~

<mvc:annotation-driven> 태그의 validation 속성을 지정하지 않거나 getValidator() 메서드를 재정의하지 않으면 JSR 303 애노테이션을 지원하는 Validator를 글로벌 Validator로 등록한다. JSR 303 지원 Validator는 JSR 303에 정의된 애노테이션을 이용해서 커맨드 객체를 검증하는 기능을 제공한다.


##### @Valid 애노테이션 및 JSR 303 애노테이션을 이용한 값 처리

@Valid 애노테이션은 Bean Validation API(JSR 303) 에 정의되어 있는데, 이 API에는 @Valid 애노테이션뿐만 아니라 @NotNull, @Digits, @Size 등의 애노테이션을 제공하고 있다. 이들 애노테이션을 사용하면 Validator 클래스 작성 없이 애노테이션만으로 커맨드 객체의 값 검증을 처리할 수 있다.

JSR 303 이 제공하는 애노테이션을 이용해서 커맨드 객체의 값을 검증하는 방법은 다음과 같다.

* 커맨드 객체에 @NotNull, @Digits 등의 애노테이션을 이용해서 검증 규칙을 설정한다.
* LocalValidatorFactoryBean 클래스를 이용해서 JSR 303 프ㄹ바이더를 스프링의 Validator로 등록한다.
* 컨트롤러가 두 번째에서 생성한 빈을 Validator로 사용하도록 설정한다.

가장 먼저 할 작업은 JSR 303 API와 JSR 303 프로바이더를 설치하는 것이다. 예를 들어, Hibernate Validator를 프로바이더 구현체로 사용하고 싶으면, Hibernate Validator 을 클래스패스에 등록하면 된다.
~~~~
<dependency>
	<groupId>javax.validation</groupId>
	<artifactId>validation-api</artifactId>
	<version>1.0.0.GA</version>
</dependency>
<dependency>
	<groupId>org.hibernate</groupId>
	<artifactId>hibernate-validator</artifactId>
	<version>4.3.1.Final</version>
</dependency>
~~~~

스프링 JSR 303 프로바이더 구현체로 Hibernate Validator를 사용할 경우, @Range나 @NotEmpty와 같은 추가적인 애노테이션을 사용할 수 있다.

커맨드클래스는 다음과 같이 JSR 303이 제공하는 애노테이션을 이용해서 값 검증 규칙을 설정할 수 있다.

~~~~
import javax.validation.Valid;

import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.NotEmpty;

public class MemberModRequest{
	@NotEmpty
	private String id;
	@NotEmpty
	private String name;
	@NotEmpty
	@Email
	private String email;
	private boolean allowNoti;
	@NotEmpty
	private String currentPassword;
	@Valid
	private Address address;
}

~~~~

JSR 303 애노테이션을 적용했으면, 그 다음으로 할 작업은 커맨드 객체의 값을 검증할 때 JSR 303 프로바이더를 사용하도록 설정하는 것이다. JSR 303 프로바이더를 Validator 로 사용하려면 LocalValidatorFactoryBean 클래스를 빈으로 등록하고, 이 빈을 Validator로 사용하면 된다.

<mvc:annotation-driven> 태그를 사용하면 기본으로 LocalValidatorFactoryBean 이 생성한 JSR 303 Validator를 글로벌 Validator로 등록해준다.

~~~~
<beans .....>
<!-- LocalValidatorFactoryBean을 글로벌 Validator로 등록 -->
<mvc:annotation-driven />
</beans>
~~~~

남은 작업은 JSR 303 애노테이션을 사용하는 커맨드 앞에 @Valid 애노테이션을 붙여서, JSR 303 지원 Validator 가 값을 검증하도록 만들면 된다.

~~~~
@Controller
@RequestMapping("/member/mmodify")
public class MemberModificationController{

	@RequestMapping(method = RequestMethod.POST)
	public String modify(@Valid @ModelAttritube("modReq") MemberModRequest modReq, Errors errors){
		if(errors.hasError()){ return "...";}
		try{
			memberService.modifyMemberInfo(modReq);
			return "...";
		} catch(NotMatchPasswordException ex){
			errors.reject("invalidPassword");
			return "...";
		} catch (MemberNotFoundException ex){
			errors.reject("noMember");
			return "....";
		}
	}
}
~~~~

JSR 303용 Validator가 MemberModRequest 커맨드 객체의 값을 검증할 때, @NotEmpty, @Email 등의 애노테이션을 사용해서 규칙을 검사하게 된다. 커맨드 객체에 오류가 있을 때 보여지는 폼 뷰의 JSP 코드가 아래와 같다고 해보자.

~~~~
<form:form commandName="modReq">
<input type="hidden" name="id" value="${modReq.id}" />
<label for="email">이메일</label>: 
<input type="text" name="email" id="email" value="${modReq.email}"/> 
<form:errors path="email"/><br/>

<label for="name">이름</label>: 
<input type="text" name="name" id="name" value="${modReq.name}"/> 
<form:errors path="name"/><br/>

<label for="address1">주소1</label>: 
<input type="text" id="address1" name="address.address1" value="${modReq.address.address1}" /> 
<form:errors path="address.address1"/><br/>
<label for="address2">주소2</label>:
<input type="text" id="address2" name="address.address2" value="${modReq.address.address2}" />
<form:errors path="address.address2"/><br/>
<label for="zipcode">우편번호</label>:
<input type="text" id="zipcode" name="address.zipcode" value="${modReq.address.zipcode}" /> <br/>

<label>
	<input type="checkbox" name="allowNoti" value="true" ${modReq.allowNoti ? 'checked' : ''} />
	이메일을 수신합니다.
</label>
<br/>
<label for="currentPassword">현재 암호</label>: 
<input type="password" name="currentPassword" id="currentPassword" /> 
<form:errors path="currentPassword"/><br/>
<input type="submit" value="수정" />
</form:form>

~~~~

앞서 MemberModRequest 클래스는 id 필드에 @NotEmpty를 사용했고, email 필드에는 @Email을 사용했다. @NotEmpty는 값이 null이거나 빈문자열이면 에러를 추가하고, @Email은 올바른 이메일 형식이 아닐 경우 에러를 추가한다.

JSR 303의 기본 에러 메시지가 아니라 스프링이 제공하는 메시지를 이용하고 싶다면 MessageSource가 사용하는 프로퍼티 파일에 다음 규칙을 따르는 메시지 코드를 등록해 주어야 한다.

1.애노테이션이름.커맨드객체모델명.프로퍼티명
2.애노테이션이름.프로퍼티명
3.애노테이션이름

~~~~
public class MemberModRequest{
	@NotEmpty
	private String name;
}
~~~~

값을 검사하는 과정에서 @NotEmpty 애노테이션으로 지정한 검사를 통과하지 못할 경우, 에러 메시지를 출력할 때 사용되는 메시지 코드는 다음과 같다.

* NotEmpty.modReq.name
* NotEmpty.name
* NotEmpty

따라서, 다음과 같이 메시지 프로퍼티 파일에 위 규칙에 맞게 에러 메시지를 입력해주면, JSR 303의 기본 에러메시지 대신 원하는 에러 메시지를 출력할 수 있다.

##### JSR 303의 주요 애노테이션

JSR 303이 제공하는 값 규칙 설정과 관련된 주요 애노테이션은 다음과 같고 애노테이션은 javax.validation.constraints 패키지에 정의되어 있다.

<table>
<tr><th>애노테이션</th><th>주요속성(괄호는 기본 값)</th><td>설명</td></tr>
<tr>
<td>@NotNull</td>
<td></td>
<td>값이 Null이면 안된다</td>
</tr>
<tr>
<td>@Size</td>
<td>min: 최소크기, int(0)<br> max: 최대크기, int(int의 최대값)</td>
<td>값의 크기가 min부터 max 사이에 있는지 검사한다. String 인 경우 문자열의 길이를 검사한다. 콜렉션인 경우 구성 요소의 개수를 검사한다. 배열이 ㄴ경우 배열의 길이를 검사한다. 값이 null인 경우 유효한 것으로 판단한다.</td>
</tr>
<tr>
<td>@Min @Max</td>
<td>value: 최소 또는 최대값. long</td>
<td>숫자의 값이 지정한 값 이상(@Min) 또는 이하(@Max 여야 한다. BigDecimal, BigInteger, 정수타입(int, long 등) 및 래퍼티입에 적용된다. (double과 float은 지원하지 않는다.) 값이 null 인 경우 유효한 것으로 판단한다.</td>
</tr>
<tr>
<td>@DecimalMin @DecimalMax</td>
<td>value: 최소 또는 최대값, String(BigDecimal 형식으로 값 표현)</td>
<td>숫자의 값이 지정한 값 이상(@Min) 또는 이하(@Max) 인지 검사한다. BigDecimal, BigInteger, String, 정수타입(int, long 등) 및 래퍼타입에 적용된다. (double과 float는 지원하지 않는다.) 값이 null 일 경우 유효한 것으로 판단한다.</td>
</tr>
<tr>
<td>@Digits</td>
<td>integer : 정수부분 숫자길이, int<br>fraction: 소수부분 숫자 길이, int</td>
<td>숫자의 정수 부분과 소수점 부분의 길이가 범위에 있는지 검사한다. BigDecimal, BigInteger, String, 정수 타입(int, long 등) 및 래퍼타입에 적용된다. 값이 null인 경우 유효한 것으로 판단한다.</td>
</tr>
<tr>
<td>@Pattern</td>
<td>regexp:정규표현식, String</td>
<td>문자열이 지정한 패턴에 일치하는지 검사한다. 값이 null인 경우 유효한 것으로 판단한다.</td>
</tr>
</table>

@NotNull을 제외한 나머지 애노테이션은 검사 대상 값이 null인 경우 유효한 것으로 판단하는 것을 알 수 있다. 따라서, 필수 입력 값을 검사할 때에는 다음과 같이 @NotNull과 @Size를 함께 사용해주어야 한다.
~~~~
@NotNull
@Size(min=1)
private String title;
~~~~

무심코 @NotNull만 사용하면, title의 값이 빈 문자열일 경우 값 검사 과정에서 통과된다.

JSR 303에 정의된 애노테이션의 이런 단점을 보안하기 위해 Hibernate Validator 모듈은 추가로 애노테이션을 제공하고있다.(org.hibenate.validator.constraints 패키지에 정의되어 있다.)

<table>
<tr><th>애노테이션</th><th>주요속성(괄호는 기본 값)</th><td>설명</td></tr>
<tr>
<td>@NotEmpty</td>
<td></td>
<td>String인 경우 빈 문자열이 아니여야 하고, 콜렉션이나 배열인 경우 크기가 1이상이여 한다.</td>
</tr>
<tr>
<td>@NotBlank</td>
<td></td>
<td>@NotEmpty와 동일하다. @NotEmpty와 차이점은 String의 경우, 뒤의 공백문자를 무시한다는 점이다.</td>
</tr>
<tr>
<td>@Length</td>
<td>min: 최소길이, int(0)<br>max: 최대 길이, int(int의 최대값)</td>
<td>문자열의 길이가 min과 max 사이에 있는지 검사한다.</td>
</tr>
<tr>
<td>@Range</td>
<td>min: 최소값, long(0)<br>max:최대값, long(long의 최대값)</td>
<td>숫자 값이 min과 max 사이에 있는지 검사한다. 값의 타입이 String 인 경우 숫자로 변환한 결과를 이용해서 검사한다.</td>
</tr>
<tr>
<td>@Email</td>
<td></td>
<td>값이 올바른 이메일주소인지 검사한다.</td>
</tr>
<tr>
<td>@URL</td>
<td></td>
<td>값이 올바른 URL인지 검사한다.</td>
</tr>
</table>


