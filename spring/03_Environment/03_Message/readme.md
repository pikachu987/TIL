## MessageSource를 이용한 메시지 국제화 처리

웹 어플레케이션은 화면에 다양한 텍스트 메시지를 출력한다. 게시글 목록을 보여 줄 때 각 칼럼에 '제목', '번호'와 같은 메시지를 사용하고, 특정 기능을 성공적으로 수행한 경우에도 그 결과를 메시지로 출력해러 알려 주게 된다.만약 개발해야 할 어플레케이션이 다국어를 지원해야 한다면, 각 언어에 맞는 메시지가 화면에 출력되어야 할 것이다.

스프링은 메시지의 국제화를 지원하기 위해 org.springframework.context.MessageSource 인터페이스를 제공하고 있다. MessageSource 인터페이스에는 지역 및 언어에 따라 알맞은 메시지를 구할 수 있는 메서드가 정의되 있다.
~~~~
package org.springframwork.context;

import java.util.Locale;

public interface MessageSource{

	String getMessage(String code, Object[] args, String defaultMessage, Locale locale);

	String getMessage(String code, Object[] args, Locale locale) throws NoSuchMessageException;

	String getMessage(MessageSourceResolvable resolvable, Locale locale) throws NoSuchMessageException;

}
~~~~
각 getMessage() 메서드는 Locale에 따라 알맞은 메시지를 리턴한다. 예를 들어, Locale.KOREAN을 값으로 주면 한국어를 기준으로 메시지를 읽어오며, Locale.ENGLISH를 값으로 주면 영어를 기준으로 메시지를 읽어온다. 해당 Locale에 맞는 메시지가 없을 경우 기본 메시지를 리턴한다.

ApplicationContext는 등록된 빈 객체 중에서 이름이 'messageSource'인 MessagSource 타입의 빈 객체를 이용해서 메시지를 가져온다. 따라서, ApplicationContext를 이용하여 메시지를 가져오려면, 아래와 같이 스프링 설정 파일에 이름이 'messageSource'인 빈 객체를 정의해주어야 한다.

~~~~
<bean id="messageSource" class="org.springframework.context.support.ResourceBundleMessageSource">
	<property name="basename">
		<value>message.greeting</value>
	</property>
</bean>
~~~~

### 프로퍼티 파일과 MessageSource
MessageSource 인터페이스에서 주로 사용하는 메서드는 다음의 두 가지이다.
* String getMessage(String code, Object[] args, String defaultMessage, Locale locale)
* String getMessage(String code, Object[] args, Locale locale)

이 두 메서드에서 code는 메시지를 식별하기 위한 코드로서, 이 code의 값은 메시지로 사용될 프로퍼티 파일의 프로퍼티 이름과 연결된다.
~~~~
hello=안녕?
welcome=환영!
~~~~

여기서 hello와 welcome프로퍼티 이름이 getMessage() 메서드의 code파라미터의 값으로 사용된다. 

~~~~
String msg = messageSource.getMessage("hello", null, someLocale);
~~~~
이건 hello인 프로퍼티의 값을리턴한다.

getMessage() 메서드의 args 파라미터는 메시지에 플레이스홀더의 값을 지정할 때 사용된다. 이는 주로 메시지의 일부를 지정한 값으로 표시하고 싶을 때 사용된다. 예를 들어, 환영 인사로 사용될 메시지에 고객의 이름을 넣고 싶다고 해보자. 이 경우, 프로퍼티 파일에 다음과 같이 플레이스 홀더를 넣을 수 있다.
~~~~
welcome=${0}님 환영!
~~~~
플레이스홀더의 숫자는 getMessage() 메서드에 전달되는 args 파라미터, 즉 String 배열의 인덱스에 해당된다.
~~~~
String args[] = {"가나다"};
String welcome = messageSource.getMessage("welcome", args, Locale.getDefault());
~~~~

실제 스프링이 어떤 위치의 프로퍼티 파일을 사용하느냐는 MessageSource 인터페이스를 구현한 클래스에 따라 다른다.

### ResourceBuldleMessageSource를 이용한 설정
ResourceBundleMessageSource 클래스는 MessageSource 인터페이스의 구현 클래스로서 java.util.ResourceBundle을 이용해서 메시지를 읽어온다. basename 프로퍼티의 값은 메시지를 로딩할 때 사용할 ResoureBundle의 베이스 이름을 의미한다. 베이스 이름은 패키지를 포함한 완전한 이름이어야 한다.

한 개 이상의 프로퍼티 파일로부터 메시지를 로딩하고 싶다면, basenames프로퍼티에 &lt;list&gt;태그를 이용하여 베이스 이름 목록을 전달하면 된다.
~~~~
<bean id="messageSource" class="org.springframework.context.support.ResourceBundleMessageSource">
	<property name="basenames">
		<list>
			<value>message.greeting</value>
			<value>message.error</value>
		</list>
	</property>
	<property name="defaultEncoding" value="UTF-8" />
</bean>
~~~~~

ResourceBundle은 프로퍼티 파일의 이름을 이용하여 언어 및 지역에 따른 메시지를 로딩한다. 예를 들어, basename 프로퍼티의 값으로 message.greeting을 사용한 경우, 클래스패스의 message 패키지에 위치할 greeting 프로퍼티 파일은 지원할 언어나 지역에 따라 다음과 같은 파일명을 갖게 된다.

* greeting.properties : 기본 메시지, 시스템의 언어 및 지역에 맞는 프로퍼티 파일이 존재 하지 않을 경우에 사용된다.
* greeting_en.properties : 영어메시지
* greeting_ko.properties : 한글 메시지
* greeting_en_UK.properties : 영국메시지

> 각 프로퍼티 파일은 해당 언어에 알맞은 메시지를 포함한다.
> ~~~~
> # greeting_en.properties
> hello=Hello!
> 
> # greeting_ko.properties
> hello=안녕!
> ~~~~
> 스프링의 ApplicationContext는 MessageSource 인터페이스를 상속하고 있으며, 스프링 빈 중에서 이름이 'messageSource'인 MessageSource가 존재할 경우, 해당 빈을 이용해서 메시지를 처리한다.
> ~~~~
> Locale locale = Locale.getDefault();
> String greeting = context.getMesssage("hello", null, locale);
> Locale engLocale = Locale.ENGLISH;
> String englishGreeting = context.getMessage("hello", null, endLocale);
> ~~~~


### ReloadableResourceBundleMessageSource를 이용한 설정
ResourceBundleMessageSource가 자바의 리소스 번들을 이용해서 메시지를 읽어오는데, 이때 메시지 파일을 클래스패스 외에 다른 곳에는 위치시킬 수 없는 불편함이 있다.
그리고 한번 메시지파일을 읽어오면 메시지파일이 변경되더라도 변경된 내용이 반영되지 않는다.

스프링은 이런 두 가지 단점을 보안하기 위해 ReloadableResourceBundleMessageSource를 제공하고있다.(왜 이리 길어...) ReloadableResourceBundleMessageSource는 다음과 같은 특징이 있다.

* 클래스패스뿐만 아니라 특정 디렉토리에 위치한 메시지 파일을 사용할 수있다.
* 클래스패스를 사용하지 않을 경우, 파일 내용이 변경되었을 때, 변경된 내용이 반영된다.

ReloadableResourceBundleMessageSource를 설정하는 방법은 앞서 ResourceBundleMessageSource와 거의 유사하다. 차이점이라면 basenames을 지정할 때 스프링의 자원 경로를 지정한다는 점이다.
~~~~
<bean id="messageSource" class="org.springframework.context.support.ReloadableResourceBundleMessageSource">
	<property name="basenames">
		<list>
			<value>file:src/message/greeting</value>
			<value>classpath:/message/error</value>
		</list>
	</property>
	<property name="defalutEncoding" value="UTF-8" />
	<property name="cacheSeconds" value="10" />
</bean>
~~~~

cacheSeconds 프로퍼티는 메시지 파일 정보를 캐싱할 시간을 초 단위로 기록한다. 이 코드에서는 10초마다 메시지 변경 내역을 반영하게 된다. 값이 -1이 기본값인데 이 때는 변경 내용을 반영하지 않는다.

basenames 프로퍼티에서 값을 지정할 때 주의할 점은 클래스패스 자원의 경우는 리로딩 기능이 적용되지 않는다는 점이다. 따라서, 리로드 대상 메시지는 클래스패스가 아닌 파일 자원을 이용해야 한다.

### 빈 객체에서 메시지 이용하기

빈 객체에서 스프링이 제공하는 MessageSource를 사용하려면 다음의 두 가지 방법 중 한 가지를 사용하면 된다.
* ApplicationContextAware 인터페이스를 구현한 뒤, setApplicationContext() 메서드를 통해서 전달받은 ApplicationContext의 getMessage() 메서드를 이용해서 메시지 사용
* MessageSourceAware 인터페이스를 구현한 뒤, setMessageSource() 메서드를 통해서 전달받은 MessageSource의 getMessage() 메서드를 이용해서 메시지 사용

ApplicationContextAware 인터페이스를 구현하는 방법은 앞에서 봤다.

~~~~
package org.springframwork.context;

import org.springframwork.beans.factory.Aware;

public interface MessageSourceAware extends Aware{
	void setMessageSource(MessageSource messageSource)
}
~~~~

MessageSourceAware 인터페이스를 구현한 빈 클래스는 setMessageSource() 메서드를 통해 전달받은 MessageSource를 이용하여 필요한 메시지를 가져와 사용할 수 있다.

~~~~
public class LoginProcessor implements MessageSourceAware{
	private MessageSource messageSource;
	public void setMessageSource(MessageSource messageSource){
		this.messageSource = messageSource;
	}

	public void login(String username, String password){
		....
		Object[] args = new String[] {username};
		String failMessage = messageSource.getMessage("login.fail", args, locale);
		....
	}
}
~~~~