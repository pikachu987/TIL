### ViewResolver 설정

<table>
<tr>
<th>ViewResolver 구현 클래스</th><th>설명</th>
</tr>
<tr>
<td>InternalResourceViewResolver</td>
<td>뷰 이름으로부터나 JSP나 Tiles 연동을 위한 View 객체를 리턴한다.</td>
</tr>
<tr>
<td>VelocityViewResolver</td>
<td>뷰 이름으로부터 Velocity 연동을 위한 View 객체를 리턴한다.</td>
</tr>
<tr>
<td>VelocityLayoutViewResolver</td>
<td>VelocityViewResolver 와 동일한 기능을 제공하며, 추가로 Velocity의 레이아웃 기능을 제공한다.</td>
</tr>
<tr>
<td>BeanNameViewResolver</td>
<td>뷰 이름과 동일한 이름을 갖는 빈 객체를 View객체로 사용한다.</td>
</tr>
</table>

ViewResolver 인터페이스
~~~~
package org.springframework.web.servlet;

import java.util.Locale;
public interface ViewResolver{
	View resolveViewName(String viewName, Locale locale) throws Exception;
}
~~~~

ViewResolver는 뷰 이름과 지역화를 위한 Locale을 파라미터로 전달받으며, 매핑되는 View 객체를 리턴한다. 만약, 매핑되는 View 객체가 없으면 null을 리턴한다.

View 인터페이스

~~~~
package org.springframework.web.servlet;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface View{
	String RESPONSE_STATUS_ATTRIBUTE = View.class.getName()+".responseStatus";
	String PATH_VARIABLES = View.class.getName()+".pathVariables";
	String SELECTED_CONTENT_TYPE = View.class.getName()+".selectedContentType";    

	String getContentType();

	void render(Map<String, ?> model, HttpServletRequest request, HttpServletResponse response) thrwos Exception;
}
~~~~

getContentType() 메서드는 "text/html" 과 같은 응답 결과의 컨텐트 타입을 리턴한다. render() 메서드는 실제로 응답 결과를 생성한다. render() 메서드의 첫 번째 파라미터인 model에는 컨트롤러가 생성한 모델 데이터가 전달된다. 각각의 View객체는 이 모델 데이터로 부터 응답 결과를 생성하는데 필요한 정보를 구한다.


viewResolver 설정
~~~~
<bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
	<property name="perfix" value="/WEB-INF/view/" />
	<property name="suffix" value=".jsp" />
</bean>
~~~~



BeanNameViewResolver 설정
~~~~
@Controller
public class DownloadCtrl{
	@RequestMapping("..")
	public ModelAndView download(HttpServletRequest request, HttpServletResponse response){
		File downloadFile = getFile(request);
		return new ModelAndView("download", "downloadFile", downloadFile);
	}
}


<bean id="viewResolver" class="org.springframework.web.servlet.BeanNameViewResolver" />
<bean id="download" class="com.compnay.DownloadView" />
~~~~

위 코드와 같이 설정하면 BeanNameViewResolver는 이름이 "download"인 DownloadView 객체를 뷰로 검색하며, DispatcherServlet은 DownloadView를 이요해서 DownloadController의 처리 결과를 출력하게 된다.

#### 다수의 ViewResolver 설정

* ViewResolver 구현 클래스가 org.springframework.core.Ordered 인터페이스를 구현했다면, order 프로퍼티에 우선 순위 값을 설정
* ViewResolver 구현 클래스에 @Order 애노테이션이 있다면, @Order 애노테이션의 값을 우선순위 값으로 사용


~~~~
<bean class="org.springframework.web.servlet.view.BeanNameViewResolver" p:order="0" />
<bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver" p:prefix="/WEB-INF/viewjsp" p:suffix=".jsp"/>
~~~~

우선순위를 결정할 때 InternalResourceViewResolver는 마지막 우선순위를 갖도록 지정해야 한다. 그 이유는 InternalResourceViewResolver는 항상 뷰 이름에 매핑되는 View 객체를 리턴하기 떄문이다.

### HTML 특수 문자 처리 방식 설정
스프링은 JSP나 몇몇 템플릿 엔젠을 위해 메시지나 커맨드 객체의 값을 출력할 수 있는 기능을 제공하고 있다. JSP를 뷰 기술로 사용할 경우 다음의 커스텀 태그를 이용해서 메시지를 출력할 수 있다.
~~~~
<title><spring:message code="login.form.title"/></title>
~~~~
만약 <spring:message> 커스텀 태그가 출력하는 값이 '&lt;입력폼&gt;'이라고 하면 이때 '&lt;'와 '&gt;'는 HTML에서 특수 문자이기 때문에 &amp;lt;나 &amp;gt; 와 같은 엔티티 레퍼런스로 변환해주어야 원하는 형태로 화면에 표시가 된다.

이런 특수문자를 어떻게 처리할지 여부는 defaultHtmlEscape 컨텍스트 파라미터를 통해서 지정할 수 있다.

~~~~
<?xml version="1.0" encoding="UTF-8"?>
<web-app ...>

	<context-param>
		<param-name>defaultHtmlEscape</param-name>
		<param-value>false</param-value>
	<context-param>
</web-app>
~~~~

defaultHtmlEscape 컨텍스트 파라미터의 값을 true로 지정하면 스프링이 제공하는 커스텀 태그나 Velocity 매크로는 HTML의 '&amp;'나 '&lt;'와 같은 특수문자를 엔티티 레퍼런스로 치환한다. defaultHtmlEscape 컨텍스트 파라미터의 값이 false면, 특수 문자를 그대로 출력한다.

참고로, defaultHtmlEscape 컨텍스트 파라미터의 기본 값은 true이다.



#### form:form

예제로 설명
.....

CSS 및 HTML 태그와 관련된 공통 속성

* cssClass : HTML 의 class 속성 값
* cssErrorClass : 폼 검증 에러가 발생했을 때 사용할 HTML의 class 속성 값
* cssStyle : HTML의 style 속성 값

HTML 태그가 사용하는 속성 중 다음의 속성들도 사용 가능하다.

* id, title, dir
* disabled, tabindex
* onfocus, onblur, onchange
* onclick, ondbclick
* onkeydown, onkeypress, onkeyup
* onmousedown, onmousemove, onmouseup
* onmouseout, onmouseover

또한, 각 커스텀 태그는 htmlEscape 속성을 사용해서 커맨드 객체의 값에 포함된 HTML특수문자를 엔티티 레퍼런스로 변환할 지의 여부를 결정할 수 있다.

#### 스프링이 제공하는 에러관련 커스텀 태그

Errors나 BindingResult를 이용해서 에러 정보를 추가한 경우, &lt;form:errors&gt; 커스텀 태그를 이용해서 에러 메시지를 출력할 수 있다. 태그는 path속성을 이용해서 커맨드 객체의 특정 프로퍼티와 관련된 에러 메시지를 출력할 수 있다.

~~~~
<form:form commandName="memberInfo">
<form:input path="email" />
<form:errors path="email" />
</form:form>
~~~~

&lt;form:errors&gt; 커스텀 태그는 지정한 프로퍼티와 관련된 한 개 이상의 에러 메시지를 출력하게 된다. 각 에러 메시지를 생성할 때 다음과 같은 두 개의 속성이 사용된다.

* element : 각 에러 메시지를 출력할 때 사용될 HTML 태그, 기본 값은 span이다.
* delimiter : 각 에러 메시지를 구분할 때 사용될 HTML 태그, 기본 값은 &lt;br&gt; 이다.

#### &lt;spring:htmlEscape&gt; 커스텀 태그와 htmlEscape 속성
defaultHtmlEscape 컨택스트 파라미터를 사용해서 웹 어플리케이션 전반에 걸쳐서 HTML의 특수 문자를 엔티티 레퍼런스로 치환할 지의 여부를 결정하는데, 만약 각 JSP 페이지 별로 특수 문자 치환 여부를 설정해주고 싶다면

~~~~
<% ...... %>
<spring:htmlEscape defaultHtmlEscape="true" />
....
<form:form>
...
</form:form>
~~~~

&lt;spring:htmlEscape&gt; 커스텀 태그를 사용하면, 이후로 실행되는 &lt;spring:message&gt; 커스텀 태그나 &lt;form:input&gt; 커스텀 태그와 같이 스프링이 제공하는 커스텀 태그는 &lt;spring:htmlEscape&gt; 커스텀 태그의 defaultHtmlEscape 속성에서 지정한 값을 기본 값으로 사용한다.

#### RestAPI

PUT, DELETE를 구현하기 위해서
* web.xml 파일에 HiddenHttpMethodFilter 적용
* &lt;form:form&gt; 태그의 method 속성에 PUT 또는 DELETE 이용

~~~~
<web-app>
	<filter>
		<filter-name>httpMethodFilter</filter-name>
		<filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
	</filter>

	<filter-mapping>
		<filter-name>httpMethodFilter</filter-name>
		<servlet-name>dispatcher</servlet-name>
	</filter-mapping>
</web-app>
~~~~

