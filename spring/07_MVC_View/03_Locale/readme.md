### Locale  처리

스프링이 제공하는 &lt;spring:message&gt; 커스텀 태그는 웹 요청과 관련된 언어 정보를 이용해서 알맞은 언어의 메시지를 출력한다.

실제로 스프링 MVC는 LocaleResolver를 이용해서 웹 요청과 관련된 Locale을 추출하고, 이 Locale 객체를 이용해서 알맞은 언어의 메시지를 선택하게 된다.

#### LocaleResolver 인터페이스

org.springframework.web.servlet.LocaleResolver 인터페이스

~~~~
package org.springframework.web.servlet;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface LocaleResolver{
	Locale resolverLocale(HttpServletRequest request);
	void setLocale(HttpServletRequest request, HttpServletResponse response, Locale locale);
}
~~~~

resolveLocale() 메서드는 요청 관련된 Locale을 리턴한다. DispatcherServlet은 등록되어 있는 LocaleResolver의 reolveLocale() 메서드를 호출해서 웹 요청을 처리할 때 사용할 Locale을 구한다.

setLocale() 메서드는 Locale을 변경할 때 사용한다.

#### LocaleResolver 의 종류

스프링이 기본적으로 제공하는 LocaleResolver 구현 클래스는 다음과 같다. 모두 org.springframework.web.servlet.i18n 패키지에 위치한다.

<table>
<tr><th>클래스</th><th>설명</th></tr>
<tr>
<td>AcceptHeaderLocaleResolver</td>
<td>웹 브라우저가 전송한 Accept-Language 헤더로부터 Locale 선택한다. setLocale() 메서드를 지원하지 않는다.</td>
</tr>
<tr>
<td>CookieLocaleResolver</td>
<td>쿠키를 이용해서 Locale 정보를 구한다. setLocale() 메서드는 쿠키에 Locale 정보를 저장한다.</td>
</tr>
<tr>
<td>SesseionLocaleResolver</td>
<td>세션으로부터 Locale 정보를 구한다. setLocale() 메서드는 세션에 Locale 정보를 저장한다.</td>
</tr>
<tr>
<td>FixedLocaleResolver</td>
<td>웹 요청에 상관없이 특정한 Locale로 설정한다. setLocale() 메서드를 지원하지 않는다.</td>
</tr>
</table>


LocaleResolver를 직접 등록할 경우 빈의 이름을 "localeResolver"로 등록해주어야 한다.

##### AcceptHeaderLocaleResolver
LocaleResolver를 별도로 설정하지 않을 경우 AcceptHeaderLocaleResolver를 기본 LocaleResolver로 사용한다. AcceptHeaderLocaleResolver는 Accept-Language 헤더로부터 Locale 정보를 추출한다.

헤더로부터 Locale 정보를 추출하기 때문에, setLocale() 메서드를 이용해서 Locale 설정을 변경할 수 없다.

##### CookieLocaleResolver
CookieLocaleResolver는 쿠키를 이용해서 Locale 정보를 저장한다. setLocale() 메서드를 호출하면 Locale 정보를 담은 쿠키를 생성하고, resolveLocale() 메서드는 쿠키로부터 Locale 정보를 가져와 Locale을 설정한다. 만약 Locale 정보를 담은 쿠키가 존재하지 않을 경우, defaultLocale 프로퍼티의 값을 Locale로 사용한다. defaultLocale 프로퍼티의 값이 null인 경우에는 Accept-Language 헤더로부터 Locale 정보를 추출한다.

CookieLocaleResolver는 쿠키와 관련해서 별도 설정을 필요로 하지 않지만, 생성할 쿠키이름, 도메인, 경로 등의 설정을 직접 하고 싶다음 다음과 같은 프로퍼티를 알맞게 설정해주면 된다.

<table>
<tr><th>프로퍼티</th><th>설명</th></tr>
<tr>
<td>cookieName</td>
<td>사용할 쿠키 이름</td>
</tr>
<tr>
<td>cookieDomain</td>
<td>쿠키 도메인</td>
</tr>
<tr>
<td>cookiePath</td>
<td>쿠키 경로. 기본값은 "/" 이다.</td>
</tr>
<tr>
<td>cookieMaxAge</td>
<td>쿠키 유효 시간</td>
</tr>
<tr>
<td>cookieSecure</td>
<td>보안 쿠키 여부, 기본값은 false이다.</td>
</tr>
</table>

##### SessionLocaleResolver
SessionLocaleResolver는 HttpSession에 Locale 정보를 저장한다. setLocale() 메서드를 호출하면 Locale 정보를 세션에 저장하고, resolveLocale() 메서드는 세션으로부터 Locale을 가져와 웹 요청의 Locale을 설정한다. 만약 Locale정보가 세션에 존재하지 않으면, defaultLocale 프로퍼티의 값을 Locale로 사용한다. defaultLocale프로퍼티의 값이 null인 경우에는 Accept-Language 헤더로부터 Locale 정보를 추출한다.

##### FixedLocaleResolver

FixedLocaleResolver는 웹 요청에 상관없이 defaultLocale 프로퍼티로 설정한 값을 웹 요청을 위한 Locale로 사용한다. FixedLocaleResolver는 setLocale() 메서드를 지원하지 않는다. setLocale() 메서드를 호출할 경우 UnsupportedOperationException예외를 발생한다.

#### LocaleResolver 등록

DispatcherServlet은 이름이 localeReolver인 빈을 LocaleResolver로 사용된다.
~~~~
<bean id="localeResolveer" class="org.springframework.web.servlet.i18n.SessionLocaleResolver" />
~~~~


#### LocaleChangeInterceptor을 이용한 Locale 변경

Locale을 변경하기 위해 별도의 컨트롤러 클래스를 개발한다는 것은 다소 성가신 일이다. 이 경우, 스프링이 제공하는 LocaleChangeInterceptor 클래스를 사용하면 웹 요청 파라미터를 이용해서 손쉽게 Locale을 변경할 수 있다.

LocaleChangeInterceptor 클래스는 HandlerInterceptor로서 다음과 같이 설정한다.

~~~~
<mvc:interceptor>
	<bean class="org.springframework.web.servlet.i18n.LocaleChangeInteceptor">
		<property name="paramName" value="language" />
	</bean>
</mvc:interceptor>
~~~~

위 코드에서는 paramName 프로퍼티의 값으로 language 를 설정했는데, 이 경우 language 요청 파라미터를 사용해서 Locale을 변경할 수 있다