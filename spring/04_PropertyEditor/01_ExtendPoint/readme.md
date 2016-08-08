### BeanFactoryPostProcessor를 이용한 빈 설정 정보 변경


> XML 설정

~~~~
<beans .....>
	<!-- context:property-ploaceholder 태그는 내부적으로 PropertySourcesPlaceholderConfugurar 객체를 스프링 빈으로 등록 -->
	<context:property-placeholder location="classpath:/db.property" />
	<bean id="connProvider" class="com.company.ConnectionProvider" init-method="init">
		<property name="driver" value="${db.driver}"/>
	</bean>
</beans>
~~~~

> JAVA 기반 설정

~~~~
@Configuration
public class ConfigByApp{
	@Value("${db.driver}")
	private String value;

	@Bean
	public static PropertySourcesPlaceholderConfigurer properties(){
		PropertySourcesPlaceholderConfigurer configurer = new PropertySourcesPlaceholderConfigurer();
		configurer.setLocation(new ClassPathResource("db.properties"));
		return configurer;
	}
}
~~~~

 PropertySourcesPlaceholderConfigurer 클래스는 BeanFactoryPostProcessor 인터페이스를 구현하고 있는데, 스프링은 빈 객체를 실제로 생성하기 전에 설정 메타 정보를 변경하기 위한 용도로 BeanFactoryPostProcessor 인터페이스를 사용한다. 예를 들어, PropertySourcesPlaceholderConfigurer는 스프링 설정 정보에서 플레이스 홀더를 프로퍼티 값으로 변경해주는 기능을 제공한다.
 
 ~~~~
 <bean id="connProvider" class="com.company.ConnectionProvider" init-method="init">
 <!-- PropertySourcesPlaceholderConfigurer 가 ${db.driver}를 실제 값으로 변경 -->
 	<property name="driver" value="${db.driver}" />
 ~~~~
 
 실제로 BeanFactoryPostProcessor는 설정 정보의 값을 변경할 수 있을 뿐만 아니라 새로운 빈 설정을 추가할  수도 있다.

BeanFactoryPostProcessor 인터페이스는 다음과 같다.
~~~~
package org.springframework.beans.factory.config;

import org.springframework.beans.BeansException;

public interface BeanFactoryPostProcessor{
	void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException;
}
~~~~

BeanFactoryPostProcessor 인터페이스를 구현한 클래스는 postProcessBeanFactory() 메서드에 전달되는 ConfigurableListableBeanFactory를 이용해서 설정 정보를 읽어와 변경하거나 새로운 설정 정보를 추가할 수 있다.
* ThresholdRequired 인터페이스를 구현한 빈 객체가 threshold 프로퍼티의 값을 설정하지 않은 경우, threshold 프로퍼티의 값을 10으로 설정한다.

~~~~
import org.springframework.beans.BeansException;
import org.springframework.beans.FatalBeanException;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.config.BeanFactoryPostProcessor;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;

public class ThresholdRequiredBeanFactoryPostProcessor implements BeanFactoryPostProcessor{
	private int defaultThreshold;

	public void setDefaultThreshold(int defaultThreshold){
		this.defaultThreshold = defaultThreshold;
	}

	@Override
	public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException{
		// 빈 이름 목록을 구한다.
		String[] beanNames = beanFactory.getBeanDefinitionNames();
		for(String name : beanNames){
			// 지정한 이름을 가진 빈의 설정 정보(BeanDefinition)를 구한다.
			BeanDefinition beanDef = beanFactory.getBeanDefinition(name);
			// 설정 정보에서 빈의 클래스 타입을 구하기 위해 BeanDefinition.getBeanClassName()을 사용한다.
			Class<?> klass = getClassFromBeanDef(beanDef);
			// 빈의 클래스 타입이 ThresholdRequired 인터페이스를 구현했는지 검사한다.
			if(klass != null && ThresholdRequired.class.isAssignableFrom(klass)){
				// 빈의 프로퍼티 설정 정보(MutablePropertyValues) 를 구한다.
				MutablePropertyValues prop = beanDef.getPropertyValues();
				if(!prop.contains("threshold")){
					// 빈의 프로퍼티 설정 중에 "threshold" 프로퍼티의 값이 없을 경우, defalutThreshold를 값으로 갖는 "threshold" 프로퍼티를 추가한다.
					prop.add("threshold", defaultThreshold);
				}
			}
		}
	}
	private Class<?> getClassFromBeanDef(BeanDefinition beanDef){
		if(beanDef.getBeanClassName() == null) return null;
		try{
			return Class.forName(beanDef.getBean(ClassName());
		} catch(ClassNotFoundException e){
			throw new FatalBeanException(e.getMessage(), e);
		}
	}
}

~~~~


ConfigurableListableBeanFactory는 설정 정보를 구할 수 있는 두 개의 메서드를 제공하고 있다.

* String[] getBeanDefinitionNames()
* > 설정된 모든 빈의 이름을 구한다.
* BeanDefinition getBeanDefinition(String beanName) throws NoSuchBeanDefinitionException
* > 지정한 이름을 갖는 빈의 설정 정보를 구한다.

이 두 메서드를 이용해서 각 빈의 설정 정보를 담고 있는 BeanDefinition을 구할 수 있는데, 이 BeanDefinition을 통해서 설정 정보를 확인하고 변경할 수 있다.

스프링이 BeanFactoryPostProcessor 구현 클래스를 사용하도록 만들려면, BeanFactoryPostProcessor 구현 클래스를 스프링 빈으로 등록해주어야 한다.

~~~~
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

<bean class="com.company.ThresholdRequiredBeanFactoryPostProcessor">
	<property name="defaultThreshold" value="10" />
</bean>

<bean id="collector1" class="com.company.DataCollector">
	<property name="threshold" value="5" />
</bean>

<bean id="collector2" class="com.company.DataCollector">
</bean>

</beans>
~~~~

collector2 빈 설정의 threshold 프로퍼티를 설정하지 않았으므로, 위 코드에서 기대하는 것은 collector2빈의 threshold 프로퍼티 값이 10으로 설정되는 것이다. 

~~~~
import org.springframework.context.support.GenericXmlApplicationContext;

public class Main{
	public static void main(String[] args){
		GenericXmlApplicationContext ctx = new GenericXmlApplicationContext("classpath:applicationContext.xml");
		DataCollector collector1 = ctx.getBean("collector1", DataCollector.class);
		DataCollector collector2 = ctx.getBean("collector2", DataCollector.class);
		System.out.println("collector1.threshold = "+collector1.getThreshold());
		System.out.println("collector2.threshold = "+collector2.getThreshold());
		ctx.close();
	}
}
~~~~


~~~~
collector1.threshold = 5
collector2.threshold = 10
~~~~

실행 결과를 보면 collector2 빈의 threshold 프로퍼티 값이 10으로 출력되었다. 이 결과를 통해, ThresholdRequiedBeanFactoryPostProcessor가 빈의 설정 정보를 변경한 것을 확인할 수 있다.

BeanFactoryPostProcessor는 빈의 설정 정보를 변경하는 방법을 사용하는데, 이런 이유로 @Configuration 애노테이션을 이용해서 생성한 빈 객체에는 적용되지 않는다. 

~~~~
@Configuration
public class Config{
	@Bean
	public static ThresholdRequiedBeanFactoryPostProcessor processor(){
		ThresholdRequiedBeanFactoryPostProcessor p = new ThresholdRequiedBeanFactoryPostProcessor();
		p.setDefaultThreshold(10);
		return p;
	}

	@Bean
	public DataCollector collector1(){
		DataCollector collector = new DataCollector();
		collector.setThreshold(5);
		return collector;
	}

	@Bean
	public DataCollector collector2(){
		DataCollector collector = new DataCollector();
		return collector;
	}

}

~~~~

위 코드를 보면 Collector2() 메서드가 생성하는 DataCollector는 threshold 프로퍼티를 설정하지 않고 있다. ThresholdRequiedBeanFactoryPostProcessor를 빈으로 등록했기 때문에 위 설정을 사용하면 collector2에 해당하는 빈의 threshold 프로퍼티 값이 10으로 설정될 거라고 생각하기 쉽지만, 실제로 프로퍼티 값은 변경되지 않는다. 그 이유는 @Configuration을 이용해서 생성하는 빈 객체는 빈 설정 정보를 만들지 않기 떄문이다. 빈 설정 정보가 없으므로 ThresholdRequiedBeanFactoryPostProcessor에서 변경할 수도 없는 것이다.

#### BeanDefinition의 주요 메서드

BeanDefination 인터페이스는 빈 설정 정보를 구하거나 수정할 때 필요한 메서드를 정의하고 있다.

<table>
<tr>
<th>
메서드
</th>
<th>
설명
</th>
</tr>
<tr>
<td>
String getBeanClassName()<br>
setBeanClassName(String beanClassName)
</td>
<td>
생성할 빈의 클래스 이름을 구하거나 지정한다.
</td>
</tr>
<tr>
<td>
String getFactoryMethodName()<br>
setFactoryMethodName(String factoryMethodName)
</td>
<td>
팩토리 메서드 이름을 구하거나 지정한다.
</td>
</tr>
<tr>
<td>
ConstructorArgumentValues getConstructorArgumentValues()
</td>
<td>
생성자 인자 값 설정 정보를 구한다.
</td>
</tr>
<tr>
<td>
MutablePropertyValues getPropertyValues()
</td>
<td>
프로퍼티 설정 정보를 구한다.
</td>
</tr>
<tr>
<td>
boolean isSingleton()<br>
boolean isPrototype()
</td>
<td>
싱글톤 또는 프로토타입 범위를 갖는지 여부를 확인한다.
</td>
</tr>
<tr>
<td>
String getScope()<br>
setScope(String scope)
</td>
<td>
빈의 범위를 문자열로 구하거나 설정한다.
</td>
</tr>
</table>

생성자 인자 설정과 프로퍼티 설정을 변경하려면 다음의 두 클래스를 이용하면 된다.

* org.springframework.beans.factor.config.ConstructorArgumentValues
* org.springframework.beans.MutablePropertyValues

앞서 ThresholdRequiedBeanFactoryPostProcessor 예에서는 MutablePropertyValues 클래스를 이용해서 프로퍼티 설정을 추가 했었다. 이외에 프로퍼티 설정 조회/추가/수정/삭제 및 생성자 인자 설정 조회/추가/수정/삭제 등의 처리를 할수 있다. (API문서 http://docs.spring.io/spring/docs/4.0.4.RELEASE/javadoc-api/)

#### BeanPostProcessor를 이용한 빈 객체 변경

스프링의 기능을 확장하는 또 다른 방법은 BeanPostProcessor를 사용하는 것이다. 앞서 살펴본 BeanFactoryPostProcessor가 빈ㅁ의 설정 정보를 변경하는 방법을 사용한다면, BeanPostProcessor는 생성된 빈 객체를 변경하는 방법을 사용한다.

~~~~
package org.springframework.beans.factory.config;

import org.springframework.beans.BeansException;

public interface BeanPostProcessor{
	Object postProcessBeforeInitialzation(Object bean, String beanName) thrwos BeansException;
	Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException;

}

~~~~


스프링은 빈 객체를 초기화하는 과정에서 BeanPostProcessor의 두 메서드를 호출하고, 이 메서드가 리턴한 객체를 빈 객체로 사용된다. 따라서, 실제 사용할 빈 객체를 교체하고 싶다면 메서드로 전달받은 원래 빈 객체(bean 파라미터)가 아닌 새로운 객체를 생성해서 리턴하면 된다.


*
⬇︎
빈객체 생성
⬇︎
빈프로퍼티 설정
⬇︎
BeanNameAware.setBeanName()
⬇︎
ApplicationContextAware.setApplicationContext()
⬇︎
BeanPostProcessor.postProcessBeforeInitialization()
⬇︎
(초기화)@PostConstruce 메서드
⬇︎
(초기화)InitializingBean.afterPropertiesSet()
⬇︎
(초기화)커스텀 init 메서드
⬇︎
BeanPostProcessor.postProcessAfterInitialization()
⬇︎
빈객체사용

스프링은 등록된 빈 중에서 BeanPostProcessor 인터페이스를 구현하고 있는 빈 객체를 BeanPostProcessor로 사용한다. 따라서, BeanPostProcessor를 구현했다면, 스프링 빈으로 등록해주면 된다.

이거는 예제로 설명하겠다.



#### Ordered 인터페이스/@Order 애노테이션 적용 순서 지정
두 개 이상의 BeanPostProcessor가 존재할 경우 org.springframework.core.Ordered 인터페이스를 이용해서 순서를 정할 수 있도록 해야 한다.

~~~~

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProccsor;
import org.springframework.core.Ordered;

public class TraceBeanPostProcessor implements BeanPostProcessor, Ordered{

	private int order;

	@Override
	public int getOrder(int order){
		return order;
	}
    
	public void setOrder(int order){
		this.order = order;
	}

	@Override
	public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException{
		return bean;
	}


	@Override
	public Object postProcessAfterInitialization(final Object bean, String beanName) throws BeansException{
		// bean 객체가 구현한 인터페이스를 구한다.
		Class<?> interfaces = bean.getClass().getInterfaces();
		if(interfaces.length == 0){
			return bean;
			InvocationHandler handler = new InvocationHandler(){
				@Override
				public Object invoke(Object proxy,Method method, Object[] args) throws Throwable{
					// 인터페이스에 정의된 메서드를 호출될 때, 이전/이후 시간을 기록한다.
					long before = System.currentTimeMillis();
					Object result = method.invoke(bean, args);
					long after = System.currentTimeMillis();
					// 실행 시간을 출력한다.
					System.out.println(method.getName()+"실행 시간 = "+(after-before));
					return result;
				}
			};
		// 프록시 객체를 리턴한다.
		return Proxy.newProxyInstance(getClass().getClassLoader(), interfaces, handler);
    }
}

~~~~

Ordered 인터페이스는 getOrder() 메서드를 정의하고 있다. getOrder()메서드가 ordered 인터페이스를 구현한 것으로, 이 메서드는 order 필드의 값을 리턴하고 있다.

> 자바의 리플렉션 API를 사용하고 있어서, 리플렉션 API에 익숙하지 않으면 이해하기 어렵다.
> http://javacan.tistory.com/entry/21 문서에서 기초정보가 있다.

원래 알아보려던 것은 BeanPostProcessor와 Order 인터페이스에 대한 것이므로, 이 부분을 살펴보자.
* BeanPostProcessor 구현 클래스가 Ordered 인터페이스를 구현한 경우, getOrder() 메서드를 이용해서 적용순서 값을 구한다.
* getOrder()로 구한 순서 값이 작은 BeanPostProcessor를 먼저 적용한다.
* Ordered 인터페이스를 구현하지 않은 BeanPostProcessor는 나중에 적용된다.


Ordered 인터페이스 대신에 @Order 애노테이션을 사용해도 된다. Order 애노테이션의 경우 다음과 같이 클래스에 적용되며, 적용 순서를 값으로 갖는다.
~~~~
import org.springframework.core.annotation.Order;

@Order(2)
public class TraceBeanPostProcessor implements BeanPostProcessor{
....
}
~~~~