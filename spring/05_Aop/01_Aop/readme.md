###  AOP 소개

Aspect Oriented Programming, 줄여서 AOP는 문제를 바라보는 관점을 기준으로 프로그래밍 하는 기법을 말한다. AOP는 문제를 해결하기 위한 핵심 관심 사항과 전체에 적용되는 공통 관심 사항을 기준으로 프로그래밍 함으로써 공통 모듈을 여러 코드에 쉽게 적용할 수 있도록 도와준다.

AOP를 구현하는 방법에는 다양한 방법이 존재하지만, 기본적인 개념은 공통 관심 사항을 구현한 코드를 핵심 로직을 구현한 코드 안에 삽입하는 것이다.

AOP 기법에서는 핵심 로직을 구현한 코드에서 공통 기능을 직접적으로 호출하지 않고 핵심 로직을 구현한 코드를 컴파일하거나 컴파일 된 클래스를 로딩하거나, 또는 로딩한 클래스의 객체를 생성할 때 AOP가 적용되어 핵심 로직 구현 코드 안에 공통 기능이 삽입된다.

AOP 프로그래밍에서는 AOP 라이브러리가 공통 기능을 알맞게 삽입해주기 때문에 개발자는 게시글 쓰기나 목록 읽기와 같은 핵심 로직을 구현할 때 트랜젝션 보안이나 보안 검사와 같은 공통 기능을 처리하기 위한 코드를 핵심 로직에 삽입할 필요가 없다.

핵심 로직을 구현한 코드에 공통 기능 관련 코드가 포함되어 있지 않으므로 적용해야 할 공통 기능이 변경되더라도 핵심 로직 구현 코드를 변경할 필요가 없다. 단지, 공통 기능 코드를 변경한 뒤 핵심 로직 구현 코드에 적용만 하면 된다.

#### AOP 용어

AOP는 다양한 용어를 소개하고 있다.

<table>
<tr><th>용어</th><th>의미</th></tr>
<tr>
<td>Joinpoint</td>
<td>Advice를 적용 가능한 지점을 의미한다. 메서드 호출, 필드 값 변경 등이 Joinpoint에 해당한다.</td>
</tr>
<tr>
<td>Pointcut</td>
<td>Joinpoint의 부분 집합으로서 실제로 Advice가 적용되는 Joinpoint를 나타낸다. 스프링에서는 정규 표현식이나 AspectJ의 문법을 이용하여 Pointcut을 정의할수 있다.</td>
</tr>
<tr>
<td>Advice</td>
<td>언제 공통 관심 기능을 핵심 로직에 적용할 지를 정의하고 있다. 예를 들어, '메서드를 호출하기 전'(언제)에 '트랜젝션시작'(공통기능) 기능을 적용한다는 것을 정의하고 있다.</td>
</tr>
<tr>
<td>Weaving</td>
<td>Advice를 핵심 로직 코드에 적용하는 것을 weaving이라고 한다.</td>
</tr>
<tr>
<td>Aspect</td>
<td>여러 객체에 공통으로 적용되는 기능을 Aspect라고 한다. 트랜젝션이나 보안 등이 Aspect의 좋은 예이다.</td>
</tr>
</table>


#### 세가지 Weaving 방식

Advice를 Weaving하는 방식에는 다음과 같이 세 가지 방식이 존재한다.

* 컴파일 시에 Weaving 하기
* 클래스 로딩 시에 Weaving 하기
* 런타임 시에 Weaving 하기

컴파일 시에 코드를 삽입하는 방법은 AspectJ에서 사용하는 방식이다. 컴파일 방식에서는 핵심 로직을 구현한 자바 소스 코드를 컴파일 할 때, 알맞은 위치에 공통 코드를 삽입하면, 컴파일 결과 AOP가 적용된 클래스 파일이 생성된다. 컴파일 방식을 제공하는 AOP 도구는 공통 코드를 알맞은 위치에 삽입할 수 있도록 도와주는 컴파일러나 IDE를 함께 제공한다.

클래스를 로딩할 때에 AOP를 적용할 수도 있다. AOP 라이브러리는 JVM이 클래스를 로딩할 때 클래스 정보를 변경할 수 있는 에이전트를 제공한다. 이 에이전트는 로딩한 클래스의 바이너리 정보를 변경하여 알맞은 위치에 공통 코드를 삽입한 새로운 클래스 바이너리 코드를 사용하도록 한다. 즉, 원본 클래스 파일은 변경하지 않고 클래스를 로딩할 때에 JVM이 변경된 바이트코드를 사용하도록 함으로써 AOP를 적용한다. AspectJ는 컴파일 방식과 더불어 클래스 로딩 방식을 함께 지원하고 있다.

런타임 시에 AOP를 적용할 때에는 소스 코드나 클래스 정보 자체를 변경하지 않는다. 대신, 프록시를 이용하여 AOP를 적용한다.프록시 기반의 AOP는 핵심 로직을 구현한 객체에 직접 접근하는 것이 아니라 중간에 프록시를 생성하여 프록시를 통해서 핵심 로직을 구현한 객체에 접근하게 된다.

이때, 프록시는 핵심 로직을 실행하기 전 또는 후에 공통 기능을 적용하는 방식으로 AOP를 구현하게 된다. 프록시 기반에서는 메서드가 호출될 때에만 Advice를 적용할 수 있기 때문에 필드 값 변경과 같은 Joinpoint에 대해서는 적용할 수 없는 한계가 있다.

#### 스프링에서의 AOP

스프링은 자체적으로 프록시 기반의 AOP를 지원하고 있다. 따라서, 스프링 AOP는 메서드 호출 Joinpoint만을 지원한다. 필드 값 변경과 같은 Joinpoint를 사용하고 싶다면 AspectJ와 같이 다양한 Joinpoint를 지원하는 AOP 도구를 사용해야 한다.

스프링은 완전한 AOP 기능을 제공하는 것이 목적이 아니라 엔터프라이즈 어플리케이션을 구현하는 데 필요한 기능을 제공하는 것을 목적으로 하고 있다.

스프링 AOP의 또 다른 특징은 자바 기반이라는 점이다. AspectJ는 Aspect를 위한 별도의 문법을 제공하고 있는 반면에 스프링은 별도의 문법을 익힐 필요 없이 자바 언어만을 이용하며 ㄴ된다.

스프링은 세 가지 방식으로 AOP를 구현할수 있도록 하고 있다.

* XML 스키마 기반의 POJO 클래스를 이용한 AOP 구현
* AspectJ에서 정의한 @Aspect 애노테이션 기반의 AOP 구현
* 스프링 API를 이용한 AOP 구현

어떤 방식을 사용하더라도 내부적으로는 프록시를 이용하여 AOP가 구현되므로 메서드 호출에 대해서만 AOP를 적용할 수 있다는 것에 유의하자. (즉, AspectJ에서 정의한 @Aspect 애노테이션을 사용하더라도 메서드 호출과 관련된 Pointcut만 사용가능하다.)

> 개발자가 직접 스프링 AOP API를 사용해서 AOP를 구현하는 경우는 많지 않으며, 일반적으로 XML스키마를 이용하거나 @Aspect 애노테이션을 이용해서 AOP를 구현한다. 스프링 AOP API를 이용하는 방식은 (http://goo.gl/P7ulvD) 를 참조바람

##### 프록시를 이용한 AOP 구현

스프링이 프록시를 이용해서 AOP를 구현하고 있다. 스프링은 Aspect의 적용대상(target)이 되는 객체에 대한 프록시를 만들어 제공하며, 대상 객체를 사용하는 코드는 대상 객체에 직접 접근하지 않고 프록시를 통해서 간접적으로 접근하게 된다. 이과정에서 프록시는 공통 기능을 실행한 뒤 대상 객체의 실제 메서드를 호출하거나 또는 대상 객체의 실제 메서드를 호출한 후에 공통 기능을 실행하게 된다.

대상 객체는 결국 스프링 빈 객체가 되는데, 스프링은 설정 정보를 이용해서 어떤 빈 객체에 Aspect를 적용할지의 여부를 지정한다. 스프링 컨테이너를 초기화 하는 과정에서 설정 정보에 지정한 빈 객체에 대한 프록시 객체를 생성하고, 원본 빈 객체 대신에 프록시 객체를 사용학도록 한다.
프록시 객체를 생성하는 방식은 대상 객체가 인터페이스를 구현하고 있느냐 없느냐 여부에 따라 달라진다. 대상 객체가 인터페이스를 구현하고 있다면, 스프링은 자바 리플렉션 API가 제공하는 java.lang.reflect.Proxy 를 이용하여 프록시 객체를 생성한다. 이때 생성된 프록시 객체는 대상 객체와 동일한 인터페이스를 구현하게 되며, 클라이언트 인터페이스를 통해서 필요한 메서드를 호출하게 된다. 하지만 인터페이스를 기반으로 프록시 객체를 생성하기 때문에 인터페이스에 정의 되어 있지 않은 메서드에 대해서는 AOP가 적용되지 않는 점에 유의해야 한다.


대상 객체가 인터페이스를 구현하고 있지 않다면, 스프링은 CGLIB를 이용하여 클래스에 대한 프록시 객체를 생성한다. CGLIB는 대상 클래스를 상속받아 프록시를 구현한다. 따라서, 대상 클래스가 final인 경우 프록시를 생성할 수 없으며, final인 메서드에 대해서는 AOP를 적용할 수 없게 된다.

> 많은 프레임워크가 개발 라이브러리가 런타임에 객체를 생성하기 위해 CGLIB를 사용하고 있다. 이들을 함께 사용하다보면 CGLIB 버전 충돌 문제 등이 발생할 수 있는대, 이런 충돌 문제가 발생하지 않도록 하기 위해 프레임워크나 라이브러리에 CGLIB의 패키지 구조를 변경해서 포함시키는 경우가 증가하고 있다. 스프링 4 버전도 패키지 구조를 변경한 CGLIB 클래스를 포함하고 있기 때문에 별도 CGLIB 모듈을 필요로 하지 않는다.

##### 구현 가능한 Advice 종류

스프링은 프록시를 이용해서 메서드를 호출할 때 Aspect를 적용하기 때문에 구현 가능한 Advice 종류는 다음과 같다.

<table>
<tr><th>종류</th><th>설명</th></tr>
<tr>
<td>Before Advice</td>
<td>대상 객체의 메서드 호출 전에 공통 기능을 실행한다.</td>
</tr>
<tr>
<td>After Returning Advice</td>
<td>대상 객체의 메서드가 익셉션 없이 실행된 이후에 공통 기능을 실행한다.</td>
</tr>
<tr>
<td>After Throwing Advice</td>
<td>대상 객체의 메서드를 실행하는 도중 익셉션이 발생한 경우에 공통 기능을 실행한다.</td>
</tr>
<tr>
<td>After Advice</td>
<td>대상 객체의 메서드를 실행하는 도중에 익셉션이 발생했는지의 여부에 상관없이 메서드 실행 후 공통 기능을 실행한다. (try-catch-finally의 finally 블록과 비슷하다)</td>
</tr>
<tr>
<td>Around Advice</td>
<td>대상 객체의 메서드 실행 전, 후 또는 익셉션 발생 시점에 공통 기능을 실행하는데 사용된다.</td>
</tr>
</table>

이들 AOP 중에서 범용적으로 사용되는 것은 Around Advice인데, 그 이유는 대상 객체의 메서드를 실행하기 전/후에 원하는 기능을 삽입할수 있기 때문이다. 이런 이유로 캐시기능, 모니터링기능과 같은 Aspect를 구현할 때에는 Around Advice를 주로 이용하게 된다.

### XML 스키마 기반 AOP 퀵 스타트

XML 스키마를 이용해서 AOP를 구현하는 과정은 다음과 같다.

* 스프링 AOP를 사용하기 위한 의존을 추가한다.
* 공통 기능을 제공할 클래스를 구현한다.
* XML 설정 파일에 <aop:config>를 이용해서 Aspect를 설정한다. Advice를 어떤 Pointcut에 적용할지를 지정하게 된다.

pom.xml의 dependency에 spring-aop와 aspectjweaver를 추가해주자.

~~~~
public void Profiler{
	public Object trace(ProceedingJoinPoint joinPoint) throws Throwable{
		String sinatureString = joinPoint.getSignature().toShortString();
		System.out.println(signatureString + " 시작 ");
		long start = System.currentTimeMillis();
		try{
			Object result = joinPoint.proceed();
			return result;
		} finally{
			long finish = System.currentTimeMillis();
			System.out.println(signatureString + " 종료");
			System.out.println(signatureString + " 실행시간 : " + (finish - start) + "ms");
		}

	}
}
~~~~
Profile.java

이 클래스가 Around Advice인지 Before Advice인지가 명시되어 있지 않다. trace() 메서드는 ProceedingJoinPoint 타입의 joinPoint 파라미터를 전달받는데, 이 파라미터를 이용해서 Around Advice에 맞는 공통 기능을 구현할 수 있게 된다.

Profililer 클래스는 Around Advice 를 구현한 클래스로서, trace() 메서드는 Advice가 적용될 대상 객체를 호출 하기전과 후에 시간을 구해서 대상 객체의 메서드 호출 실행 시간을 출력한다.

~~~~
<beans .......>

<!-- 공통기능을 제공할 클래스를 빈으로 등록 -->
<bean id="profile" classs="com.company.ex1.aop.Propfile" />

<!-- Aspect 설정 : Advice를 어떤 Pointcut에 적용할 지 설정 -->
	<aop:config>
		<aop:aspect id="traceAspect" ref="profile">
			<aop:pointut id="publicMethod" expression="execution(public * com.company..*(**))" />
			<aop:around pointcut-ref="publicMethod" method="trace" />
		</aop:aspect>
	</aop:config>

</beans>
~~~~

공통 기능을 적용하려면 Advice구현 클래스를 빈으로 등록해주고 aop네임 스페이스를 추가해주어야 한다.
그리고 <aop:config>, <aop:aspect>, <aop:pointcut>, <aop:around> 태그를 이용해서 AOP설정을 할 수 있다.

* com.company 패키지 및 그 하위 패키지에 있는 모든 public 메서드를 Pointcut로 설정
* 이들 Pointcut에 Around Advice로 profile 빈 객체의 trace() 메서드를 적용

#### XML 스키마 기반의 POJO 클래스를 이용한 AOP 구현

* <aop:config> : AOP 설정 정보임을 나타낸다.
* <aop:aspect> : Aspect를 설정한다.
* <aop:pointcut> : Pointcut을 설정한다.
* <aop:around> : Around Advice를 설정한다. 

<aop:aspect> 태그의 ref 속성은 Aspect의 공통 기능을 제공할 빈을 설정할 때 사용한다.

##### Aspect 설정

Aspect 설정에서 <aop:aspect> 태그는 한 개의 Aspect를 설정한다.
~~~~
<aop:config>
	<aop:aspect id="traceAspect" ref="profiler">
		<aop:pointcut id="publicMethod" expression="execution(public * com.company..*(..))" />
		<aop:around pointcut-ref="publicMethod" method="trace" />
	</aop:aspect>
</aop:config>
~~~~

Aspect를 적용할 Pointcut은 <aop:pointcut> 태그를 이용하여 설정한다. <aop:pointcut> 태그의 id 속성은 Pointcut을 구분하는데 사용되는 식별값으로서 사용되고, expression속성은 Pointcut을 정의하는 AspectJ의 표현식을 입력받는다.
<table>
<tr><th>태그</th><th>설명</th></tr>
<tr>
<td><aop:before></td>
<td>메서드 실행 전에 적용되는 Advice를 정의한다.</td>
</tr>
<tr>
<td><aop:after-returning></td>
<td>메서드가 정상적으로 실행된 후에 적용되는 Advice를 정의한다.</td>
</tr>
<tr>
<td><aop:after-throwing></td>
<td>메서드가 익셉션을 발생시킬 때 적용되는 Advice를 정의한다. try-catch 블록에서 catch 블록과 비슷하다.</td>
</tr>
<tr>
<td><aop:after></td>
<td>메서드가 정상적으로 실행되는지 또는 익셉션을 발생시키는지 여부에 상관없이 적용되는 Advice를 정의한다. try-catch-finally에서 finally블록과 비슷하다.</td>
</tr>
<tr>
<td><aop:around></td>
<td>메서드 호출 이전, 이후, 익셉션 발생 등 모든 시점에 적용 가능한 Advice를 정의한다.</td>
</tr>
</table>

각 태그는 pointcut속성 또는 pointcut-ref 속성을 사용하여 Advice가 적용될 Pointcut을 지정한다. pointcut-ref 속성은 <aop:pointcut> 태그를 이용하여 설정한 Pointcut을 참조할 때 사용되며, pointcut 속성은 직접 AspectJ 표현식을 이용하여 Pointcut을 지정할때 사용한다.

~~~~
<aop:config>
	<aop:aspect id="traceAspect1" ref="profiler">
		<aop:poinitcut id="publicMethod" expression="execution(public * com.company..*(..))" />
		<aop:around pointcut-ref="publicMethod" method="trace" />
	</aop:aspect>
</aop:config>

~~~~

Advice 각 태그는 Pointcut 에 포함되는 대상 객체의 메서드가 호출될 때, <aop:aspect> 태그의 ref 속성으로 지정한 빈 객체에서 어떤 메서드를 실행할지를 지정한다.


#### @Aspect 애노테이션 기반 AOP 퀵 스타트

aop 스키마가 XML 설정을 이용해서 Advice, Pointcut 등을 설정하는 방식이라면, @Aspect 애노테이션은 자바 코드에서 AOP를 설정하는 방식이다. @Aspect  애노테이션을 이용해서 AOP를 구현하는 과정은 XML 스키마 기반의 AOP를 구현하는 과정과 거의 유사하며, 차이점은 다음과 같다.

* @Aspect 애노테이션을 이용해서 Aspect 클래스를 구현한다. 이때 Aspect 클래스는 Advice를 구현한 메서드와 Pointcut 포함한다.
* XML 설정에서 <aop:aspectj-autoproxy /> 를 설정한다. @Configuration 기반 자바 설정을 이용한다면 @EnableAspectJAutoProxy 를 설정한다.

~~~~
@Aspect
public class ProfilingAspect{

	@Pointcut("execution(public * com.company..*(..))")
	private void profileTarget(){}

	@Around("profileTarget()")
	public Object trace(ProceedingJoinPoint joinPoint) throws Throwable{
		String sinatureString = joinPoint.getSignature().toShortString();
		System.out.println(signatureString + " 시작 ");
		long start = System.currentTimeMillis();
		try{
			Object result = joinPoint.proceed();
			return result;
		} finally{
			long finish = System.currentTimeMillis();
			System.out.println(signatureString + " 종료");
			System.out.println(signatureString + " 실행시간 : " + (finish - start) + "ms");
		}
	}
}

~~~~


@Aspect 애노테이션을 사용했는데, @Aspect 애노테이션이 적용되는 클래스는 Advice 구현 메서드나 Pointcut 정의를 포함할 수 있게 된다. ProfilingAspect 클래스의 경우는 Advice 구현 메서드와 Pointcut 정의를 모두 포함하고 있다.

@Pointcut 애노테이션은 Pointcut을 정의하는 AspectJ 표현식을 값으로 가지며, @Pointcut 애노테이션이 적용된 메서드는 리턴 타입이 void이여야 한다.


~~~~

<aop:aspectj-autoproxt />
~~~~

이 태그는 @Aspect 애노테이션이 적용된 빈 객체를 Aspect로 사용하게 된다.

@Before
~~~~
@Before(....)
public void before(JoinPoint joinPoint){}
~~~~

@After Returning Advice
~~~~
@AfterRetunin(pointcut = ".." returning="ret")
public void afterReturning(Object ret){}
~~~~
~~~~
@AfterRetunin(pointcut = ".." returning="ret")
public void afterReturning(Article ret){}
~~~~
~~~~
@AfterRetunin(pointcut = ".." returning="ret")
public void afterReturning(JoinPoint joinPoint, Object ret){}
~~~~


@After Throwing Advice
~~~~
@AfterThrowing(pointcut = ".." throwing="ex")
public void afterThrowing(Throwable ex){}
~~~~
~~~~
@AfterThrowing(pointcut = ".." throwing="ex")
public void afterThrowing(JoinPoint joinPoint, Exception ex){}
~~~~


@After Advice
~~~~
@After("...")
public void afterFinally(JoinPoint joinPoint){}
~~~~

@Around Advice


##### 자바 설정


~~~~
@Configuration
@EnableAspectJAutoProxy
public class QuickStartConfig{

	@Bean
	public ProfileingAspect performanceTraceAspect(){
		return new ProfilingAspect();
	}

}

~~~~


JoinPoint 인터페이스는 호출되는 대상 객체, 메서드 그리고 전달되는 파라미터 목록에 접근할 수 있는 메서드를 제공하고 있다.

* Sinature getSignature() : 호출되는 메서드에 대한 정보를 구한다.
* Object getTarget() : 대상 객체를 구한다.
* Object[] getArgs() : 파라미터 목록을 구한다.

org.aspectj.lang.Signature 인터페이스는 호출되는 메서드와 관련된 정보를 제공하기 위해 다음과 같은 메서드를 정의하고 있다.

* String getName() : 메서드의 이름을 구한다.
* String toLongString() : 메서드를 완전한게 표현한 문장을 구한다.(메서드의 리턴ㅇ타입, 파라미터 타입이 모두 표시된다.)
* String toShorgString() : 메서드를 축약해서 표현한 문장을 구한다.(기본 구현은 메서드의 이름만을 구한다.)

Around Advice 인 경우 org.aspectj.lang.ProceedingJoinPoint 를 첫 번째 파라미터로 전달받는데, ProceedingJoinPoint 인터페이스는 프록시 대상 객체를 호출할 수 있는 proceed() 메서드를 제공하고 있따. ProceedingJoinPoint는 JoinPoint 인터페이스를 상속받고 있으므로 Around Advice 역시 앞서 설명한 메서드와 Signature를 이용하여 대상객체, 메서드 및 전달되는 파라미터에 대한 정보를 구할 수 있다.

#### 타입을 이용한 파라미터의 접근

JoinPoint의 getArgs() 메서드를 이용하면 대상 객체의 메서드를 호출할 때 사용한 인자에 접근할 수 있다고 했는데, Advice 메서드에서 직접 파라미터를 이용해서 메서드 호출시 사용된 인자에 접근할 수도 있다. 파라미터를 이용해서 대상 객체의 메서드를 호출할 때 사용한 인자에 접근하려면 다음과 같이 두 가지 작업을 진행해주면 된다.

* Advice 구현 메서드에 인자를 전달받은 파라미터를 명시한다.
* Pointcut 표현식에서 args() 명시자를 사용해서 인자목록을 지정한다.

먼저 Advice 구현 메서드에 다음코드와 같이 사용할 파라미터를 명시한다. 다음 코드는 대상객체의 메서드 호출 시 사용되는 인자가 두 개이고 각각 String 타입과 UpdateInfo 타입인 경우에 적용될 Advice 메서드가 된다

~~~~
public class UpdateMemberInfoTraceAdvice{
	public void traceReturn(String memberId, UpdateInfo info){
		System.out.printf("[TA] 정보 수정 : 대상회원 : %s, 수정정보 : %s\n", memberId, info);
	}
}
~~~~

그 다음 할 작업은 XML 설정 파일에서 args() 명시자를 이용해서 인자 목록을 지정해주는 것이다.

~~~~
<bean id="memberUpdateTraceAdvice" class="...." />
<aop:config>
	<aop:aspect id="memberUpdateTraceAspect" ref="memberUpdateTraceAdvice">
		<aop:after-returning pointcut="args(memberId, info)" method="traceReturn" />
	</aop:aspect>
</aop:config>
~~~~

위 설정에서 args() 명시자가 의미하는 것은 다음과 같다.

* 대상 객체의 메서드 호출시 인자가 두 개 전달되고,
* 이 중 첫 번째 인자는 traceReturn 메서드의 memberId파라미터와 타입이 같고, 두 번째 인자는 info 파라미터와 타입이 같다.

Advice 구현 메서드인 traceReturn() 의 memberId파라미터와 info 파라미터는 각각 타입이 String 과 UpdateInfo 이므로, 위 Pointcut 설정은 다음 코드의 update() 메서드에 Advice를 적용하게 된다.

~~~~
public interface MemberService{
	boolean update(String id, UpdateInfo updateInfo);
}
~~~~

args() 명시자의 경우 메서드 정의에 있는 타입이 아닌 실제 메서드 호출시 전달되는 인자의 타입에 따라서 적용 여부가 결정된다. 예를 들어, update() 메서드가 다음과 같이 정의되어 있다고 해보자.

~~~~
public interface MemberService{
	boolean update(String id, Object updateInfo);
}
~~~~

update() 메서드의 두 번째 파라미터 타입은 Object 인데, 이렇게 메서드 선언에서 사용된 타입이 args() 명시자와 매칭되는 타입과 다르다 하더라도, 실제로 메서드에 전달되는 인자의 타입이 args() 명시자를 통해서 지정한 것과 동일하다면 Advice가 적용된다.

~~~~
MemberService service = context.getBean("memberService", MemberService.class);
UpdateInfo updateInfo = new UpdateInfo();
....
//실제로 전달되는 객체의 타입이 UpdateInfo이므로 Aspect 적용됨
service.update("madvirus", updateInfo);
~~~~

@Aspect 애노테이션을 사용하는 경우에도 XML 스키마를 사용할 때처럼 Pointcut 표현식에 args() 명시자를 사용하며 된다.

~~~~
@Aspect
public class UpdateMemberInfo TraceAspect{
	@AfterReturning(pointcut="args(memberId,info)", returning="result")
	public void traceReturn(String memberId, UpdateInfo info, boolean result){
		....
	}
}
~~~~

##### 인자의 이름 매핑 처리

앞서 args() 명시자를 이용해서 메서드 호출시 사용된 인자를 파라미터로 전달받을 수 있다고 했다. args() 명시자에 지정한 이름과 Advice 구현 메서드의 파라미터 이름이 일치하는 지의 여부를 확인하는 순서는 다음과 같다.

* Advice 애노테이션 태그의 argNames 속성이나 Advice 설정 XML 스키마의 arg0names 속성에서 명시한 파라미터이름을 사용한다.
* argName 속성이 없을 경우, 컴파일할 때 생성되는 디버그 정보를 이용해서 파라미터 이름이 일치하는 지의 여부를 확인한다.
* 디버그 옵션이 없을 경우 파라미터 개수를 이용해서 일치 여부를 유추한다.

argNames속성은 Advice 구현 메서드의 파라미터 이름을 입력할 때 사용된다. 아래 코드는 사용 예를 보여주고 있다. argNames 속성은 모든 파라미터의 이름을 순서대로 표시해서 Pointcut 표현식에서 사용된 이름이 몇 번째 파라미터인지 검색할 수 있도록 한다.

~~~~
@AfterReturning(pointcut="args(memberId, info)", argNames="memberInfo, info")
public void traceReturn(String memberId, UpdateInfo info){
	System.out.printf("[TA] 정보 수정 : 대상회원=%s, 수정정보=%s\n", memberId, info);
}
~~~~

만약 첫 번째 파라미터 타입이 JoinPoint나 ProceedingJoinPoint 라면, JoinPoint 타입의 파라미터 이름을 포함하지 않는다.

~~~~
@AfterReturning(pointcut="args(memberId, info)", argNames="memberInfo, info")
public void traceReturn(JoinPoint joinPoint, String memberId, UpdateInfo info){
	....
}
~~~~

XML 스키마를 사용하는 경우 다음과 같이 arg-names 속성을 이용해서 파라미터 이름을 지정한다.

~~~~
<aop:after-returning pointcut="args(memberId, info)" method="traceReturn" returning="result" arg-names="joinPoint, memberId, info" />
~~~~

argNames 속성 또는 arg-names 속성을 지정하지 않은 경우에는 디버그 정보를 이용한다.

마지막으로 디버그 정보도 없는 경우에는 파라미터 개수를 이용해서 유추한다. 예를 들어, Pointcut 표현식에서 사용한 파라미터 개수가 1개이고 실제로 Advice 구현 메서드의 파라미터 개수가 1개라면 일치한다고 판단한다. 만약 Pointcut 표현식에서 사용된 파라미터 개수와 실제 구현 메서드의 파라미터 개수가 다르다면 익셉션이 발생한다.

1번부터 3번까지 모두 해당되지 않는다면 IllegalArgumentException 을 발생한다.

### AOP 프록시 객체 생성 방식 설정

AOP를 사용할 떄에 주의할 점이 한 가지 있는데, 그것은 바로 AOP가 생성하는 프록시와 관련된 것이다.

~~~~
<aop:config proxy-target-class="true">
<aop:aspectj-autoproxy proxy-target-class="true" />

@EnableAspectJAutoProxy(proxyTargetClass = true)
~~~~

각 설정 방식에서 프록시 대상을 클래스로 사용할지 여부를 true로 지정해주면 실제 생성되는 프록시는 인터페이스가 이닌 클래스를 상속받아 생성된다.

### AsjectJ의 Pointcut 표현식

스프링은 공통 기능인 Aspect를 지정할 Pointcut을 지정하기 위해 AspectJ의 문법을 사용한다. 
AspectJ는 Pointcut을 명시할 수 있는 다양한 명시자르 ㄹ제공하는데, 스프링은 메서드 호출과 관련된 명시자(designator) 만을 지원하고 있다.

#### execution 명시자

execution명시자는 Advice를 정용할 메서드를 명시할 때 사용되며, 기본 형식은 다음과 같다.

~~~~
execution(수식어 패턴? 리턴타입패턴 클래스이름패턴?메서드이름패턴(파라미터이름패턴)
~~~~

'수식어패턴'부분은 생략 가능한 부분으로서 public, protected 등이 온다. 스프링 AOP의 경우 public 메서드에만 적용가능하기 때문에 사실상 public 이외의 값은 의미가 없다.

'리턴타입패턴' 부분은 리턴 타입을 명시한다. '클래스이름패턴'과 '이름패턴' 부분은 클래스 이름 및 메서드 이름을 패턴으로 명시한다. '파라미터패턴' 부부은 매칭될 파라미터에 대해서 명시한다.

각 패턴은 '*'을 이용해서 모든 값을 표현할 수 있다. 또한, '..'을 이용해서 0개 이상이라는 의미를 표현할 수 있다.

* execution(public void set*(..))
* > 리턴 타입이 void 이고 메서드 이름이 set으로 시작되고, 파라미터가 0개 이상인 메서드 호출
* execution(* com.company.*.*())
* > com.company 패키지의 파라미터가 없는 모든 메서드 호출
* execution(* com.company..*.*(..))
* > com.company 패키지 및 하위 패키지에 있는, 파라미터가 0개 이상인 메서드 호출
* execution(Integer com.company.Foo.boo(**))
* > 리턴 타입이 Integer인 Foo인터페이스의 boo 메서드 호출
* execution(* get*(*))
* > 이름이 get으로 시작되고 1개의 파라미터를 갖는 메서드 호출
* execution(* get*(*, *))
* > 이름이 get으로 시작되고 2개의 파라미터 갖는 메서드 호출
* execution(* read*(Integer, ..))
* > 메서드이름이 read로 시작되고 첫번째 파라미터 타입이 Integer이며 1개이상의 파라미터를 갖는 메서드 호출

#### within 명시자

within 명시자는 특정 타입에 속하는 메서드를 Pointcut으로 설정할 때 사용된다.

* within(com.company.Foo)
* > Foo 인터페이스의 모든 메서드 호출
* within(com.company.Boo.*)
* > Boo패키지안에 있는 모든 메서드 호출
* within(com.company.Boo..*)
* > Boo패키지및 그 하위에 있는 모든 메서드 호출

#### bean 명시자

bean명시자는 스프링에서 추가적으로 제공하는 명시자로서, 스프링 빈 이름을 이용하여 Pointcut을 정의한다.

* bean(FooService)
* > 이름이 FooService인 빈의 메서드 호출
* bean(*FooService)
* > 이름이 FooService으로 끝나는 빈의 메서드 호출

#### Pointcut의 조합
각각의 표현식은 '&amp;&amp;' 또는 '||' 연산자를 이용하여 연결할 수 있다.
~~~~
@AfterThrowing(pointcut="execution(public * get*()) && execution(public void set*(..))")
......
~~~~
XML 스키마를 이용하여 Aspect를 설정하는 경우에도 다음과 같이 '&amp;&amp;' 또는 '||' 연산자르 사용할 수 있다.

~~~~
<aop:pointcut id="propertyMethod" expression="execution(public * get*()) && execution(public void set*(..))">
~~~~

'&amp;&amp;' 또는 '||' 대신 'and'와 'or'을 이용할 수 있다.

~~~~
@Pointcut("excution(public * *(..))")
private void publicMethod(){}

@Pointcut("within(com.company.Foo..*")
private void inFoo(){}

@Pointcut("publicMethod() and inFoo")
private void fooPublicOperation(){}
~~~~

이런것도 가능하다.
@Pointcut 애노테이션을 이용하면 XML 스키마를 이용하는 경우에 비해 Pointcut의 조합 및 재사용이 보다 쉽기 때문에 공통으로 사용되는 Pointcut은 @Pointcut애노테이션을 이용해서 표현하는 것이 좋다.

### Advice 적용 순서

하나의 JoinPoint에 한 개 이상의 Advice가 적용될 경우, 순서를 명시적으로 지정할 수 있다.  @Order어노테이션이나 Ordered 인터페이스를 구현하면 된다.

* org.springframework.core.annotation.Order
* org.springframework.core.Ordered

~~~~
@Aspect
public class ArticleCacheAspect implements Ordered{
	@Around("execution(public * *..ReadArticleService.*(..))")
	public Article cache(ProceedingJoinPoint joinPoint) throws Throwable{....}

	@Override
	public int getOrder(){
		return 2;
	}
}

~~~~

@Order 애노테이션

~~~~
@Aspect
@Order(3)
public class ProfilingAspect{....}
~~~~

XML에서는
~~~~
<aop:aspect id="..." ref="..." order="2">
....
</aop:aspect>
~~~~
로 하면된다.
order값이 낮은 Advice의 우선순위가 더 높다.

