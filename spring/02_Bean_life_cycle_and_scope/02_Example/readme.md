### 싱글톤 범위

별도 설정을 하지 않을 경우 스프링은 빈 객체를 한 번만 생성한다. getBean() 메서드를 두 번 이상 호출해서 빈을 구하면 매번 동일한 빈 객체를 리턴한다. 예를 들어, 아래와 같은 XML 설정이 있다고 하자.

~~~~
<bean id="pool1" class="com.company.ConnPool1" />
~~~~
> 이 XML 설정을 이용해서 컨테이너를 생성한다음에 "pool1" 빈 객체를 아래와 같이 구했다고 해보자

~~~~
ConnPool1 p1 = ctx.getBean("pool1", ConnPool1.class);
ConnPool2 p2 = ctx.getBean("pool2", ConnPool2.class);
//p1 == p2 는 true, 즉, p1과 p2는 동일한 객체를 참조함
~~~~

> 스프링 컨테이너는 이름이 "pool1"인 빈 객체를 한 개만 생성하고, getBean() 메서드는 매번 동일한 객체를 리턴하기 때문에, 위 코드에서 p1과 p2는 동일한 객체를 참조하게 된다.

> 스프링 컨테이너가 초기화되고 종료되기 직전까지 빈 객체는 한 개만 생성되는데, 즉, 스프링 컨테이너를 기준으로 이들 빈 객체는 한 개만 존재하므로, 이들 빈은 싱글톤(singleton) 범위를 갖는다고 한다.

> 스프링 싱글톤은 기본 값으로 갖기 때문에, 별도 설정을 하지 않으면 빈은 싱글톤 범위를 갖는다. 싱글톤 범위라는 것을 명시적으로 표시하고 싶다면 다음과 같이 scope 속성이나 @Scope 애노테이션을 추가해주면 된다.

-- XML
~~~~
<bean id="pool1" class="com.company.ConnPool1" scope="singleton"/>
~~~~

-- JAVA
~~~~
import org.springframework.context.annotation.Scope;

@Bean
@Scope("singleton")
public ConnPool1 pool1(){
	return new ConnPool1();
}
~~~~

### 프로토타입 범위

~~~~
for(Long ordNum : orderNumbers){
	Work work = new Work();
	work.setTimeout(2000);
	work.setType(WorkType.SINGLE);
	work.setOrder(ordNum);
	workRunner.execute(work);
}
~~~~

> 위 코드는 for 루프에서 매번 새로운 Work 객체를 생성하는데, 생성되는 Work 객체는 order 프로퍼티를 제외한 나머지가 동일한 값을 갖고 있다. 이런 경우, 해당 프로퍼티를 제외한 나머지가 동일한 객체를 생성해주는 기능이 있다면, 다음과 같이 코드를 만들 수 있을 것이다.

~~~~
for(Long ordNum : orderNumbers){
	Work work = createWork();
	work.setOrder(ordNum);
	workRunner.execute(work);
}
~~~~

> 이렇게 동일한 값을 갖는 객체를 생성할 때 사용할 수 있는 것이 프로토타입 범위를 갖는 빈이다. 프로토타입(prototype) 범위의 빈은 객체의 원형(즉, 프로토타입)으로 사용되는 빈으로서, 프로토타입 범위 빈을 getBean() 등을 이용해서 구할 경우 스프링 컨테이너는 매번 새로운 객체를 생성한다. 프로토타입 범위를 설정하기 위해서는 다음과 같이 &lt;bean&gt; 태그의 scope 속성을 "prototype"으로 지정하면 된다.

~~~~
<bean id="workProto" class="com.company.Work" scope="prototype">
	<property name="timeout" value="2000" />
	<property name="type" value="#{T(com.company.Work$WorkType).SINGLE}" />
</bean>
~~~~

> 코드에서 type 프로퍼티의 값을 설정하기 위해 #{표현식} 형식을 사용했는데, 이는 스프링이 제공하는표현식이다. 열거타입인 WorkType.SINGLE 값을 type 프로퍼티의 값을 설정하였다.

~~~~
import org.springframework.context.annotation.Scope;

@Configuration
public class ConfigScope{

	@Bean
	@Scope("prototype")
	public Work workProto(){
		Work work = new Work();
		work.setTimeout(2000);
		work.setType(WorkType.SINGLE);
		return work;
	}
}
~~~~

> 프로토타입 범위를 가진 빈을 찾을 경우, 스프링은 매번 새로운 객체를 생성해서 리턴한다. 예를 들어, 아래와 같이 getBean() 메서드로 프로토타입 범위를 가진 빈을 두 번 이상 구했다고 하자.

 ~~~~
 Work work1 = ctx.getBean("workProto",Work.class);
 Work work2 = ctx.getBean("workProto",Work.class);
 Work work3 = ctx.getBean("workProto",Work.class);
 
//work1 == work2 -> false
//work2 == work3 -> false
//work1 == work3 -> false
~~~~

> 이 경우 스프링 컨테이너는 매번 새로운 객체를 생성하기 때문에 work1, work2, work3은 모두 다른 객체가 된다.

> 스프링 컨테이너는 프로토타입 범위를 가진 빈의 초기화까지만 관리를 한다. 즉, 스프링 컨테이너를 종료한다고 해서 생성된 프로토타입 빈 객체의 소멸 과정이 실행되지는 않는다.
 