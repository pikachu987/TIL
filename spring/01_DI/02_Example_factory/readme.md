### 팩토리 방식의 스프링 빈 설정

객체를 생성할 때 new 키워드를 이용하는 것이 보통이지만, 객체를 생성하기 위해 정적(static) 메서드를 사용해야 할 때가 있다. 또한, new 키워드로 객체를 생성한 뒤에 다소 복잡한 과정을 거쳐 초기화를 진행하는 경우도 있다. 지금까지 살펴본 XML 설정으로는 이 두가지 경우 즉, 정적 메서드를 이용해서 객체를 생성하는 경우와 객체 생성 과정이 다소 복잡한 경우를 처리할 수 없는데, 이런 경우를 위해 스프링은 다음과 같은 두 가지 방식의 객체 생성 방식을 제공하고 있다.

* 객체 생성에 사용되는 static 메서드 지정
* FactoryBean 인터페이스를 이용한 객체 생성 처리

#### 객체 생성을 위한 정적 메서드 설정

~~~~

<bean id="factory" class="com.company.ErpClientFactory">
	<contructor-arg>
		<props>
			<prop key="server">10.50.0.10</prop>
		</props>
	</contructor-arg>
</bean>

~~~~


#### FactoryBean 인터페이스를 이용한 객체 생성 처리

~~~~

SearchClientFactoryBuilder builder = new SearchClientFactoryBuilder();
builder.server("10.20.1.100")
	.port(8181)
	.contentType(type == null ? "json" : type)
	.encoding("utf-8");
SearchClientFactory searchClientFactory = builder.build();
searchClientFactory.init();

~~~~

>  스프링 빈으로 정의하고 싶은 타입이 SearchClientFactory라고 할 경우, XML 설정으로 SearchClientFactory 타입의 빈을 정의하기에는 SearchClientFactory 객체를 생성하는 과정이 다소 복잡하다. 이럴 때 사용할 수 있는 것이 FactoryBean 인터페이스이다.

> FactoryBean 인터페이스는 다음과 같이 정의되어 있다.

~~~~

package org.springframework.beans.factory;

public interface FactoryBean<T>{
	T getObject() throws Exception;
	Class<?> getObjectType();
	boolean isSingleton();
}

~~~~

> 세개의 메서드가 정의되어 있는데, 각 메서드는 다음과 같다.

* **T getObject()**: 실제 스프링 빈으로 사용될 객체를 리턴한다.
* **Class<?> getObjectType()**: 스프링 빈으로 사용될 객체의 타입을 리턴한다.
* **boolean isSingleton()**: getObject() 메서드가 매번 동일한 객체를 리턴하면 true, 그렇지 않고 매번 새로운 객체를 리턴하면 false를 리턴한다.

> 스프링은 &lt;bean&gt; 태그에서 지정한 클래스나 @Bean 애노테이션이 적용된 메서드가 생성하는 객체가 FactoryBean 인터페이스를 구현한 경우, getObject() 메서드가 리턴하는 객체를 실제 빈 객체로 사용한다. 즉, FactoryBean 인터페이스를 알맞게 구현하면 생성자나 정적 메서드가 아닌 다른 방법으로 생성되는 개체를 스프링 빈으로 사용할 수 있게 된다.


#### FactoryBean 을 자바코드 설정하는 방법

~~~~

@Configuration
public class Config{
    @Bean
    public SearchClientFactoryBean orderSearchClientFactory(){
    	SearchClientFactoryBean searchClientFactoryBean = new SearchClientFactoryBean();
        searchClientFactoryBean.setServer("10.20.30.40");
        searchClientFactoryBean.setPort(8888);
        searchClientFactoryBean.setContentType("json");
        return searchClientFactoryBean;
    }
}


~~~~

> @Bean 애노테이션이 붙은 orderSearchClientFactory() 메서드의 리턴 타입은 FactoryBean 인터페이스를 구현한 SearchClientFactoryBean 클래스다. 리턴 타입이 FactoryBean이긴 하지만, getBean() 메서드로 빈 객체를 구할 때에는 다음 코드처럼 SearchClientFactoryBean이 생성하는 객체의 타입인 SearchClientFactory 타입을 사용한다.


~~~~
SearchClientFactory orderSearchClientFactory = ctx.getBean("orderSearchClientFactory", searchClientFactory.class);
~~~~

> 다른 빈 객체를 설정할 때 SearchClientFactory 빈이 필요하면 어떻게 해야 할까? 이때는 아래 코드처럼 FactoryBean 구현 객체를 리턴하는 메서드를 호출해서 FactoryBean 객체를 구하고, 그 다음에 그 객체의 getObject() 메서드를 호출해서 필요한 객체를 구하면 된다.

~~~~
@Bean
public SearchClientFactoryBean orderSearchClientFactory(){
	SearchClientFactoryBean searchClientFactoryBean = new SearchClientFactoryBean();
    
	return searchClientFactoryBean;
}

@Bean
public SearchServiceHealthChecker searchServiceHealthChecker() throws Exception{
	SearchServiceHealthChecker healthChecker = new SearchServiceHealthChecker();
    healthChecker.setFactories(Arrays.asList(
        orderSearchClientFactory().getObject(),
        productSearchClientFactory().getObject()
    ));
    return healthChecker;
}

~~~~

> 자바 코드설정에서 FactoryBean이 생성하는 빈 객체를 참조하는 또 다른 방법은 메서드 파라미터로 전달받는 방법이다.

~~~~
@Bean
public SearchClientFactoryBean orderSearchClientFactory(){
	SearchClientFactoryBean searchClientFactoryBean = new SearchClientFactoryBean();
    
	return searchClientFactoryBean;
}

@Bean
public SearchServiceHealthChecker searchServiceHealthChecker(
SearchClientFactory orderSearchClientFactory, SearchClientFactory productSearchClientFactory) throws Exception{

	SearchServiceHealthChecker healthChecker = new SearchServiceHealthChecker();
    healthChecker.setFactories(Arrays.asList(
        orderSearchClientFactory,productSearchClientFactory
    ));
    
    return healthChecker;
}
~~~~

> 스프링은 @Bean 애노테이션이 적용된 메서드에 파라미터가 존재할 경우, 해당 파라미터의 타입과 이름을 사용하여 빈 객체를 전달한다. 위 코드에서 searchServiceHealthChecker() 메서드의 첫 번째 파라미터와 두번째 파라미터 빈을 사용하게 된다. 따라서, orderSearchClientFactory() 메서드를 이용하여 생성된 빈 객체가 첫 번째 파라미터에 전달된다.
> > 파라미터를 이용해서 의존 객체를 전달받는 방법은 FactoryBean 구현 객체가 생성하는 빈에만 제한적으로 적용되는 것은아니며, 사실 모든 빈에 동일하게 적용할 수 있다.


<br><br>

### 애노테이션을 이용한 객체 간 의존 자동 연결

  프로젝트 규모가 조금만 커져도 한 개의 어플리케이션에서 생성하는 스프링 빈 객체는 수백 개 이상으로 증가하게 되는데, 이 경우 스프링 빈 간의 의존 관계를 XML설정이나 자바 기반 설정을 관리하는 데 시간을 뺏길 수 있다. 또는, 특정 타입의 빈 객체가 한 개 밖에 존재하지 않는 경우가 많아서 의존 객체가 너무 뻔할 때가 있다. 만약 일일이 의존 관계를 설정할 필요 없이 자동으로 프로퍼티나 생성자 파라미터 값으로 동일 타입의 빈 객체를 전달해주는 기능이 있다면 설정이 많이 줄어들 것이다!!

<br><br>
---

# 2시간동안 작성한 마크다운을 날려서 다시적음.....(매우 빡침....)

### 애노테이션 기반 의존 자동 연결을 위한 설정
~~~~
<beans ...
xmlns:context="http://www.springframework.org/schema/context"
......
xsi:schemaLocation="
.....
http://www.springframework.org/schema/context
http://www.springframework.org/schema/context/spring-context.xsd">

<context:annotation-config />
.....

</beans>
~~~~

> &lt;context:annotation-config /&gt;를  쓰려면 xmlns와 xsi에 주소 추가를 해야한다.
> &lt;context:annotation-config /&gt; 태그는 다수의 스프링 전처리기 빈을 등록해준다.
> * org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor
> @Autowired 애노테이션을 처리해주는 전처리기이다. JSR-330에 정의된 @Inject 애노테이션도 처리한다.
> * org.springframework.annotation.CommonAnnotationBeanPostProcessor
> @Resource, @PostConstruct 등 JSR-250에 정의된 애노테이션을 처리해주는 전처리기다.
> * org.springframework.beans.factory.annotation.QualifierAnnotationAutowireCandidateResolver
> @Qualifier 애노테이션을 처리해주는 전처리기다.

* @Autowired 애노테이션을 필드에 적용하면, 의존 객체를 전달받기 위한 메서드를 추가하지 않아도 된다. 하지만, 단위 테스트와 같이 스프링 이외의 환경에서 사용될 수도 있으니 의존 객체를 전달받기 위한 메서드나 생성자는 남겨두는 것이 좋다.
* XML 설정뿐만 아니라 자바 코드 설정을 사용하는 경우에도 동일하게 동작한다. 단, 차이나는 부분이 있다면 생성자를 사용하는 경우이다. XML 설정에서는 스프링이 생성자를 호출하는데 반해 자바 코드 설정에서는 코드에서 생성자를 직접 호출한다. 이런 이유로, 자바 코드 설정에서는 생성자에 @Autowired 애노테이션을 적용한다더라도 의존 객체가 전달되지 않는다.

> @Autowired는 required라는 속성값을 지니는데 required속성값을 쓰지 않았을 경우 해당 객체가 없으면 Exception이 발생한다. 하지만 required=false라고 하면 Exception이 발생하지 않는다.

> @Qualifier 은 value값으로 같은 클래스의 객체를 여러개 지정 가능하다.
> @Qualifier("order") 이런식으로 value값으로 지정 가능하다.

> @Resource 는 name값으로 같은 클래스의 객체를 여러개 지정 가능하다.
> @Resource(name="foo")

> @Inject 을 사용하려면
> ~~~~
> <dependency>
> 	<groupId>javax.inject</groupId>
> 	<artifactId>javax.inject</artifactId>
> 	<version>1</version>
> </dependenct>
> ~~~~
> 을 pom.xml에 추가해줘야 한다.

### 콤포넌트 스캔
지금 하는 프로젝트에서 코딩 규칙을 정해 놓고 엄격하게 준수한다고 가정해보자. 예를 들어, 모든 컨트롤러 구현 클래스는 com.mycom.web 패키지에 위치해야 하고, 모든 DAO클래스는 com.mycom.dao 패키지에 위치해야 한다. 그리고, 모든 위존은 프로퍼티 설정 메서드를 통해서 정의해야 하고, 모든 빈의 이름은 타입 이름과 동일하게 정의해야 한다고 하자.

이런 경우에 특정 패키지에 위치한 클래스를 스프링 빈으로 자동으로 등록하고 의존 자동 설정을 통해서 각 빈 간의 의존을 처리할 수 있다면 설정 코드를 만드는 수고를 덜 수 있을 것이다. 이런 기능을 스프링이 제공하고 있는데, 그것이 바로 컴포넌트 스캔 기능이다.

스프링은 특정 패키지 또는 그 하위 패키지에서 클래스를 찾아 스프링 빈으로 등록해주는 기능을 제공하고 있다. 이때 검색 대상은 org.springframework.stereotype.Component 애노테이션이 붙은 클래스다. 

~~~~
<context:component-scan base-package="com.company.*" />
~~~~

이런식으로 쓸 수 있다.
> &lt;context:component-scan&gt; 태그는 애노테이션과 관련해서 아래의 BeanPostProcessor를 함께 등록해 준다.
> * AutowiredAnnotationBeanPostProcessor
> * CommonAnnotationBeanPostProcessor
> * ConfigurationClassPostProcessor
> 따라서, &lt;context:component-scan&gt; 태그를 사용하면 @Conponent 애노테이션 뿐만 아니라 @Required, @Autowired, @Inject와 같은 애노테이션을 함께 처리한다.

> 자바에서는
> ~~~~
> import org.springframework.context.annotation.ComponentScan;
> import org.springframework.context.annotation.Configuration;
> 
> @Configuration
> @ComponentScan(basePackages="com.company.*")
> public class ConfigScan{
> ....
> }
> ~~~~~

으로 쓸 수 있다.


> @Component 애노테이션은 용도 별로 의미를 부여하는 하위 타입을 갖고 있는데, 다음은 그 종류들이다.
> * org.springframework.stereotype.Component : 스프링 빈 임을 의미한다.
> * org.springframework.stereotype.Service : DDD(도메인 주도 설계)에서의 서비스를 의미한다.
> * org.springframework.stereotype.Repository : DDD(도메인 주도 설계)에서의 리파지터리를 의미한다.
> * org.springframework.stereotype.Controller : 웹 MVC 의 컨트롤러를 의미한다.
> 
> @Component 애노테이션을 포함한 네 개의 애노테이션은 스프링의 스캔 대상이다.
> 
> 애노테이션에 따라 스프링이 특수하게 처리하는 경우가 있다. 예를 들어, @Controller 애노테이션은 웹 MVC에서 컨트롤러 객체로 사용되며, @Repository 애노테이션의 경우 스프링이 DB 구현 기술과 관련된 익셉션을 스프링에서 제공하는 익셉션으로 변환하는 기능을 자동 적용하는 대상이 된다. 