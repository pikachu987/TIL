### 서블릿 3 기반 설정

서블릿 3 버전부터 web.xml 파일을 사용하는 대신 자바 코드를 이용해서 서블릿 / 필터를 등록할 수 있게 되었다. 스프링도 이에 따라 web.xml 이 아닌 자바 코드를 이용해서 DispatchrServlet을 설정할수 있는 방법을 제공하고 있다. 자바 코드로 DispatcherServlet을 설정하는 방법은 간단한다. 스프링이 제공하는 org.springframework.web.WebApplicationInitializer 인터페이스를 상속받아 알맞게 구현해주기만 하면 된다. WebApplicationInitializer ㅇ니터페이스는 다음과 같이 한개의 메서드만을 정의하고 있다.

~~~~
package org.springframework.web;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;

public interface WebApplicationInitializer{
	void onStartup(ServletContext servletContext) throws ServletException;
}

~~~~

WebApplicationInitializer 인터페이스를 상속받은 클래스는 onStartup() 메서드에서 DispatcherServlet을 직접 생성해서 ServletContext에 등록해주면 된다.

~~~~
package config;

import javax.servlet.Filter;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.XmlWebApplicationContext;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractDispatcherServletInitializer;

public class Initializer extends AbstractDispatcherServletInitializer{

	@Override
	protected WebApplicationContext createServletApplicationContext() {
		XmlWebApplicationContext servletAppContext = new XmlWebApplicationContext();
		servletAppContext.setConfigLocation("/WEB-INF/dispatcher.xml");
		return servletAppContext;
	}
	//DispatcherServlet 이 사용할 WebApplicationContext 객체를 생성한다.
	
	
	
	@Override
	protected String getServletName() {
		return "dispatcher";
	}
	//DispatcherServlet의 서블릿 이름을 리턴한다. 이 메서드를 재정의 하지 않을 경우 dispatcher를 이름으로 사용한다.
	
	
	@Override
	protected String[] getServletMappings() {
		return new String[]{"/"};
	}
	//생성할 DispatcherServlet이 매핑될 경로를 리턴한다.
	
	
	
	@Override
	protected boolean isAsyncSupported() {
		return super.isAsyncSupported();
	}
	//DispatcherServlet이 비동기를 지원하는지 여부를 리턴한다. 재정의하지 않을 경우 기본값은 true 이다.
	
	
	
	@Override
	protected WebApplicationContext createRootApplicationContext() {
		XmlWebApplicationContext rootAppContext = new XmlWebApplicationContext();
		rootAppContext.setConfigLocation("/WEB-INF/root.xml");
		return rootAppContext;
	}
	//루트 컨텍스트를 생성한다. 만약 루트 컨텍스트가 필요 없다면 null을 리턴하면 된다.
	
	
	
    @Override
    protected Filter[] getServletFilters() {
    	CharacterEncodingFilter encodingFilter = new CharacterEncodingFilter();
    	encodingFilter.setEncoding("UTF-8");
    	Filter[] filters = new Filter[]{encodingFilter};
    	return filters;
    }
    //DispatcherServlet에 적용할 서블릿 필터 객체를 리턴한다.
}

~~~~

XML 설정이 아니라 @Configuration 기반 자바 설정을 사용하고 싶다면, AbstractAnnotationConfigDispatcherServletInitializer 클래스를 상속받아 좀 더 간결하게 설정 할 수 있다.


~~~~
package config;

import javax.servlet.Filter;

import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class Initializer_java extends AbstractAnnotationConfigDispatcherServletInitializer{

	@Override
	protected Class<?>[] getRootConfigClasses() {
		return new Class<?>[]{RootConfig.class};
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
		return new Class<?>[]{MvcConfig.class};
	}

	@Override
	protected String getServletName() {
		return "dispatcher";
	}
	
	
	
	@Override
	protected String[] getServletMappings() {
		return new String[]{"/"};
	}
	
	@Override
	protected boolean isAsyncSupported() {
		return super.isAsyncSupported();
	}
	
	
    @Override
    protected Filter[] getServletFilters() {
    	CharacterEncodingFilter encodingFilter = new CharacterEncodingFilter();
    	encodingFilter.setEncoding("UTF-8");
    	Filter[] filters = new Filter[]{encodingFilter};
    	return filters;
    }
}

~~~~

실제 AnnotationConfigWebApplicationContext 객체를 생성하는 것은 상위 클래스인 AbstractAnnotationConfigDispatcherServletInitializer에서 이루어진다.


> web.xml을 사용하는 것과 자바 코드 기반의 서블릿 설정을 사용하는 것 중 무엇이 더 좋은지는 말하기 어렵다. 자바 코드 기반의 서블릿 설정을 사용하면 IDE의 코드 자동완성 기능의 도움을 얻을수 있어 좋다. 하지만 급하게 운영중인 서버의 설정을 변경해서 재시작 해야 하는 경우에는 web.xml 파일을 사용할 때 더 민첩하게 반응할 수 있다. 두 가지 방식 중에서 무엇을 사용할지 여부는 명확한 그거 보다는 선호에 의해 결정되는 경우가 더 많다.


