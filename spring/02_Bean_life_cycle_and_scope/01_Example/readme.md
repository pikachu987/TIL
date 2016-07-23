### 빈 라이프 사이클 개요
스프링 컨테이너는 빈 객체를 생성하고 초기화하고 소멸할 때 순서대로 빈 객체의 메서드를 실행한다.


* 빈 객체 생성
* 빈 프로퍼티 설정
* BeanNameAware.setBeanName()
* ApplicationContextAware.setBeanName()
* BeanPostProcessor의 초기화 전 처리
* (초기화) @PostConstruct 메서드
* (초기화) InitializingBean.afterPropertiesSet()
* (초기화) 커스텀 init 메서드
* BeanPostProcessor의 초기화 후 처리
* 빈 객체 사용
* (소멸) @PreDestory 메서드
* (소멸) DisposableBean.destory()
* (소멸) 커스텀 destory 메서드

의 순서대로 실행된다.


> 빈의 초기화와 소멸 방법은 각각 세가지가 존재하며, 각 방식이 쌍을 이루어 함께 사용되곤 한다. 즉,@PostConstruct 애노테이션을 사용해서 초기화 메서드를 지정했다면 @PreDestory 애노테이션을 사용해서 소멸 메서드를 지정하고, 커스텀 init 메서드를 사용했다면 destory 메서드를 사용하는 식이다. (물론, 초기화와 소멸 방식을 다르게 해도 문제가 없다.)

> 스프링은 객체의 초기화 및 소멸 과정을 위해 다음의 두 인터페이스를 제공하고 있다.
> * org.springframework.factory.InitializingBean : 빈의 초기화 과정에서 실행될 메서드를 정의
>  * org.springframework.factory.DisposableBean : 빈의 소멸 과정에서 실행될 메서드를 정의

이 두 인터페이스는 각각 다음과 같이 정의되어 있다.

~~~~
public interface InitializingBean{
	void afterPropertiesSet() throws Exception;
}

public interface DisposableBean{
	void destory() throws Exception;
}
~~~~

 스프링 컨테이너는 생성한 빈 객체가 InitializingBean 인터페이스를 구현하고 있으면, InitializingBean 인터페이스로 정의되어 있는 afterPropertiesSet() 메서드를 호출한다. 따라서 스프링 빈 객체가 정상적으로 동작하기 위해 객체 생성 이외의 추가적인 초기화 과정이 필요하다면 InitializingBean 인터페이스를 상속받고 afterPropertiesSet() 메서드에서 초기화 작업을 수행하면 된다. 비슷하게 스프링 컨테이너가 종료될 때, 빈 객체가 알맞은 처리가 필요하다면 DisposableBean 인터페이스를 상속받아 destory() 메서드에서 소멸 작업을 수행하면 된다.

> 초기화/소멸 과정이 필요한 전형적인 예가 데이터베이스 커넥션 풀 기능이다. 커넥션 풀은 미리 커넥션을 생성해 두었다가 커넥션이 필요할 때 제공하는 기능이므로, 초기화 과정을 필요로 한다. 또한, 더 이상 커넥션이 필요 없으면 생생한 커넥션을 모두 닫기 위한 소멸 과정을 필요로 한다. 이런 커넥션 풀 기능을 스프링 빈으로 사용하고 싶은 경우, InitializingBean 인터페이스와 DisposableBean 인터페이스를 상속받아 초기화/소멸 과정을 처리할 수 있을 것이다.

~~~~
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;

public class ConnPool implements InitializingBean, DisposableBean{
	...
    @Override
    public void afterPropertiesSet() throws Exception{
    	//커넥션 풀 초기화 실행 : DB 커넥션을 여는 코드
    }
    
    @Override
    public void destory() throws Exception{
    	//커넥션 풀 종료 실행 : 연 DB 커넥션을 닫는 코드
    }
}
~~~~

 위 클래스를 스프링 빈으로 등록하면, 스프링 컨테이너는 빈 생성 후 afterPropertiesSet() 메서드를 호출해서 초기화를 진행하고 destory() 메서드를 호출해서 소멸을 진행한다.

~~~~
<!-- 스프링 컨테이너가 afterPropertiesSet() 메서드를 실행해서 초기화를 진행하고, 컨테이너를 종료할 때 빈의 destory() 메서드를 실행해서 소멸을 진행한다. -->
<bean id="connPool" class="com.company.CoonPool" />
~~~~

 이 두 인터페이스를 모두 상속해야 하는 것은 아니며, 필요한 인터페이스만 상속받으면 된다. 예를 들어, 스프링 컨테이너가 빈 객체를 생성할 때 초기화만 필요하면 InitializingBean 인터페이스만 상속받아 구현하면 된다.

#### @PostConstruct 애노테이션과 @PreDestory애노테이션

스프링 컨테이너가 빈 객체의 초기화/소멸 메서드를 실행할 수 있는 또 다른 방법은 @PostConstruct 애노테이션과 @PreDestory 애노테이션을 사용하는 것이다. 각각 초기화를 실행하는 메서드와 소멸을 실행하는 메서드에 적용한다.

~~~~
import javax.annotation.PostConstruct;
import javax.annotation.PreDestory;

public void ConnPool{
  @PostConstruct
  public void initPool(){
  	//커넥션 풀 초기화 실행 : DB 커넥션을 여는 코드
  }
    
  @PreDestory
  public void destoryPool(){
  	//커넥션 풀 종료 실행 : 연 DB 커넥션을 닫는 코드
  }
}
~~~~

>  이 두 애노테이션은 @Resource 애노테이션과 함께 JSR 250에 정의되어 있다. 따라서, 이 두 애노테이션이 적용된 메서드를 초기화/소멸 과정에서 실행하려면 다음과 같이 CommonAnnotationBeanPostProcessor 전처리기를 스프링 빈으로 등ㄹ록해주어야 한다. (&lt;context:annotation-config&gt; 태그를 사용하면 CommonAnnotationBeanPostProcessor가 빈으로 등록된다.)

~~~~
<beans ...
....>
....
<context:annotation-config />
....
</beans>
~~~~

> AnnotationConfigApplicationContext를 사용할 경우 애노테이션과 관련된 기능을 모두 활성 시키므로, 별도의 설정을 추가할 필요는 없다.
>> 초기화와 소멸 과정에서 사용될 메서드는 파라미터를 가져서는 안된다.

#### 커스텀 init 메서드와 커스텀 destory 메서드

외부에서 제공받은 라이브러리가 있는데, 이 라이브러리의 클래스를 스프링 빈으로 사용해야 할 수도 있다. 이 라이브러리의 클래스는 초기화를 위해 init() 메서드를 제공하고 있는데, 이 init() 메서드는 @PostConstruct 애노테이션을 갖고 있지 않다. 또한 스프링의 InitializingBean 인터페이스를 상속받지도 않았다고 하자. 스프링은 이런 경우에도 초기화 메서드를 실행할 수 있도록 커스텀 초기화 메서드를 지정하는 방법을 제공하고 있다. 또한, 커스텀 소멸 메서드를 지정하는 방법도 제공하고 있다.

> XML 설정을 사용한다면 다음과 같이 init-method 속성과 destory-method 속성을 사용해서 초기화 및 소멸 과정에서 사용할 메서드의 이름을 지정하면 된다.

~~~~
<bean id="pool" class="com.company.ConnPool" init-method="init" destory-method="destory"/>
~~~~

자바 기반 설정을 사용한다면, @Bean 애노테이션의 initMethod 속성과 destoryMethod 속성을 사용하면 된다.

~~~~
@Bean(initMethod="init", destoryMethod="destory")
public ConnPool coonPool(){
	return new CoonPool();
}
~~~~

초기화와 소멸 과정에서 사용될 메서드는 파라미터를 가져서는 안 된다.

#### ApplicationContextAware 인터페이스와 BeanNameAware 인터페이스

> 빈으로 사용될 객체에서 스프링 컨테이너에 접근해야 한다거나, 빈 객체에서 로그를 기록할 때 빈의 이름을 남기고 싶다면 어떻게 해야 할까? 이런 경우에 다음의 두 인터페이스를 사용하면 된다.
> * org.springframework.context.ApplicationContextAware
>  이 인터페이스를 상속받은 빈 객체는 초기화 과정에서 컨테이너(ApplicationContext)를 전달받는다.
>  * org.springframework.beans.factory.BeanNameAware
>  이 인터페이스를 상속받은 빈 객체는 초기화 과정에서 빈 이름을 전달받는다. 

먼저 ApplicationContextAware 인터페이스는 다음과 같이 정의되어 있다.

~~~~
public interface ApplicationContextAware extends Aware{
	void setApplicationContext(ApplicationContext applicationContext) throws BeansException;
}
~~~~

> ApplicationContext 인터페이스를 상속받아 구현한 클래스는 setApplicationContext() 메서드를 통해서 컨테이너 객체(ApplicationContext)를 전달받는다.

BeanNameAware 인터페이스는 당음과 같이 정이되어 있다.
~~~~
public interface BeanNameAware extends Aware{
	void setBeanName(String name);
}
~~~~

> BeanNameAware 인터페이스를 상속받아 구현한 클래스는 setBeanName() 메서드를 이용해서 빈의 이름을 전달받는다.