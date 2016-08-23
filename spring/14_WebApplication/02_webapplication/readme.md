### 어플리케이션 - 도메인 - 영속성 구조

어플리케이션 - 도메인 - 영속성 구조는 DDD(Domain-Driven-Design)를 비롯해 도메인 모델을 중심으로 설계할 때 사용되는 구조이다. 꼭 DDD를 따르지 않더라도 어필리케이션-도메인-영속성 구조를 사용하면 복잡한 업무를 다루는 웹 어플리케이션을 개발 할 때 객체 지향의 장점을 잘 살릴수 있게 된다.

<table>
<tr><th>영역</th><th>구성요소</th><th>역활</th></tr>
<tr>
<td rowspan="2">도메인영역</td>
<td>엔티티</td>
<td>핵심 도메인 모델로서 구분되는 식별값을 가지며, 도메인 로직을 실행한다. 엔티티 외에 값(Value) 객체 등이 존재한다.</td>
</tr>
<tr>
<td>리파지터리</td>
<td>엔티티 객체를 보관하고 제공하는 기능을 정의한다.</td>
</tr>
<tr>
<td>영속성영역</td>
<td>리파지터리 구현</td>
<td>도메인 영역의 리파지터리 인터페이스의 구현을 제공한다. 보통 JPA나 하이버네이트와 같은 ORM기술을 이용해서 구현한다.</td>
</tr>
<tr>
<td>어플리케이션영역</td>
<td>어플리케이션 서비스</td>
<td>도메인 영역의 리파지터리와 엔티티를 이용해서 클라이언트가 요청한 기능을 실행한다.</td>
</tr>
</table>

> http://goo.gl/NJXWp9 참조

#### 도메인 구성

* 도메인 모델
* > 엔티티, 값 객체 등 도메인 모델을 표현하는 객체를 제공한다. 이들 객체들은 모델을 표현하는 데 필요한 프로퍼티(예, 직원 엔티티의 경우 사번, 이름 등)를 포함한다. 엔티티와 DTO의 중요한 차이점은 엔티티는 도메인 기능을 함께 제공하는데 반해 DTO는 단순 영역간의 주고 받는 데이터를 담는 구조체라는 것이다.
* 엔티티/객체관리
* > 리파지터리는 엔티티 객체의 생명주기를 관리한다. 리파지터리에 엔티티 객체를 보관하고, 리파지터리로터 엔티티를 검색하고, 리파지터리를 통해 엔티티를 제거한다. 도메인 영역에서 리파지터리는 엔티티 관리를 위한 인터페이스만 제공하며, 실제 구현은 영속성 영역에서 다루게 된다.

~~~~
public class Member{
	private Integer seq;
	private String userId;
	private String pwd;
	private String rePwd;

	public void changePwd(String oldPwd, String newPwd){
		if(!matchPwd(oldPw)) throw new WrongPwdException();
		this.pwd = encrypt(newPwd);
	}
    
    public boolean matchPwd(String pwd){....}
}
~~~~

리파지터리는 엔티티를 보관하기 위한 용도로 사용된다.

#### 영속성 구현

리파지터리의 실제 구현은 영속성 영역에 위치한다.

영속성 영역을 구현할 때 다양한 기술을 사용할 수 있지만, 구현의 편리함 때문에 ORM기술을 많이 사용한다. 주요 ORM 기술로는 JPA와 하이버네이트가 있따. 이 중 스프링 데이터 JPA 모듈을 사용하면 구현해야 할 코드의 양이 상당히 줄어든다. 코드에서 JPA를 이용하고 JPA의 프로바이더로 하이버네이트를 이용하면 좋다.

JPA를 이용해서 영속성을 구현할 경우 도메인 영역의 엔티티나 다른 모델 클래스에 JPA 애노테이션을 적용하게 된다. @Entity, @Table, @Column, @Id, @GeneratedValue 등등


도메인 영역의 코드에서 영속성 영역의 코드에 대한 의존을 갖지 않도록 해서 영속성 영역을 다른 기술로 구현하더라도 도메인 코드가 영향을 받지 않도록 해야 겠지만, 실제로 영속성 관련 기술을 변경하는 경우는 거의 없다. 따라서, 도메인 영역의 코드에 애노테이션과 같은 설정 정보가 일부 포함되더라도 실용적인 측면에서는 문제되지 않는다고 생각한다.


스프링 데이터 JPA를 사용하게 되면, 도메인 영역의 리파지터리 인터페이스를 구현할때 Repository 인터페이스를 상속 받아 정의하면 된다. 리파지터리의 일부 기능을 직접 구현해야 한다면, 해당 구현 클래스를 영속성 영역에 위치시킨다.

#### 어플리케이션 서비스 구현

어플리케이션 영역은 시스템이 제공하는 기능을 구현한다. 어플리케이션은 클라이언트의 요청을 받아, 도메인 영역의 구성 요소를 이용해서 요청을 처리하고, 그 결과를 리턴한다.

* 도메인 영역의 리파지터리에서 엔티티를 구한다.
* 엔티티의 기능을 실행한다.
* 결과를 리턴한다.

~~~~
public class ChangePwdServiceImpl implements ChangePwdService{
	@Autowired
	private MemberResitory memberRepository;

	@Transactional
	@Override
	public void changePwd(..){
		....
	}
}
~~~~

어플리케이션 서비스는 스프링 빈으로 등록되며, 어플리케이션의 서비스 메서드는 트랜젝션 단위가 된다.

어플리케이션 서비스의 메서드는 요청을 처리하는데 필요한 입력값을 파라미터로 갖는다.
서비스를 실행하는데 필요한 데이터가 많다면, 데이터를 담은 클래스를 만들어 메서드의 파라미터 타입으로 사용할 수 있을 것이다.

#### 컨트롤러와 뷰 그리고 도메인 객체 접근

* 상태를 변화시키는 기능
* 데이터를 조회하는 기능

이 두기능 중에서 상태를 변화시키는 기능은 어플리케이션 서비스에서 제공한다.
상태 조회 요청을 처리하는 경우에는 다양한 방식으로 접근할수 있다. 첫번째 방식은 컨트롤러에서 직접 리파지터리의 기능을 이용하는것이다.
이럴때 주의할 점은 뷰 코드는 트랜젝션 범위 밖에서 실행한다. 그런데 JPA에서 지연로딩 방식의 연관 객체는 트랜젝션 범위 내에서만 읽어올 수 있다. 따라서, 트랜젝션 범위 밖에서 지연 로딩 프로퍼티에 접근 할 경우 익셉션이 발생하게 된다.
~~~~
org.hibernate.LazyInitializationException: could not initialize proxy - no Session
~~~~
모든 연관에서 지연 로딩을 사용하지 않으면 위 문제가 해결되지만, 대신 연관된 모든 객체를 DB에서 바로 로딩하기 때문에 조회 성능에 문제가 발생할 수 있다. 이런 이유로, 지연 로딩을 사용할 경우 뷰 실행 과정에서 문제가 발생하지 않도록 두가지 방법중 하나를 사용한다

* OSIV 패턴을 사용
* 뷰에서 필요한 데이터를 트랜젝션 범위 내에서 로딩

첫번째 방법은 OSIV(Open Session In View) 라는 패턴을 사용한다. 서블릿 필터를 이용해서 웹 요청이 시작될 때 JPA 세션을 시작하고, 웹 요청 처리가 끝나면 세션을 종료한다. 이 OSIV 필터를 사용하면 JPA 세션 범위에서 JSP를 실행하기 때문에, JSP 코드에서 지연 로딩 대상 프로퍼티에 접근하더라도 DB로 부터 알맞게 대상객체를 로딩할 수 있게 된다.

~~~~
<filter>
	<filter-name>openEntityManagerFilter</filter-name>
	<filter-class>org.springframework.orm.jpa.support.OpenEntityManagerInViewFilter</filter-class>
	<init-param>
		<param-name>entityManagerFactoryBeanName</param-name>
		<param-value>entityManagerFactory</param-value>
	</init-param>
</filter>
<filter-mapping>
	<filter-name>openEntityManagerFilter</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>
~~~~

OpenEntityManagerInViewFilter을 사용할 떄 주의할 점은, OpenEntityManagerInViewFilter가 EntityManagerFactory 객체를 검색할 때 사용하는 스프링 컨테이너는 DispatcherSErvlet 이 사용하는 컨테이너가 아닌 서블릿 컨텍스트를 위한 컨테이너라는 점이다. 즉, ContextLoaderListener를 이용해서 생성한 스프링 컨테이너에서 EntityManagerFactory를 검색한다. 따라서, 스프링 컨테이너를 설정할 때에는 DispatcherServlet 에서는 웹 MVC 관련 설정만 하고, 나머지 EntityManagerFactory를 포함한 어플리케이션과 관련된 설정은 ContextLoaderLister를 이용하는 방법을 사용해야 한다.

> OSIV 패턴을 사용하면 구현을 편하게 할 수 있는 장점이 있지만, OSIV 패턴을 사용하는 것에 호불호가 존재한다. OSIV 패턴을 사용하면 지연 로딩을 사용하면서도 JSP와 같은 뷰 영역의 코드에서 지연로딩 대상 객체를 로딩할 수 있기 때문에, 개발자 입장에서는 지연로딩을 보다 자유롭게 사용할수 있다. 하지만 어플리케이션 서비스의 메서드가 트랜젝션의 적정 범위인데, 트랜잭션 범위가 뷰 영역까지 확산된다. 뷰 영역에서 도메인 객체의 상태를 변경할 수 있기 때문에 개발자가 생각하는 트랜젝션 범위 밖에서 DB상태를 변경하는 상황이 발생 할 수 있다.

OSIV 패턴 외에 지연로딩으로 인해 발생하는 세션 문제를 해소하기 위한 또 다른 방법은 뷰에서 사용할 데이터를 미리 로딩한 뒤에 뷰에 전달하는 것이다.

Hibernate.initialize()는 JPA 프로바이더로 하이버네이트를 선택했을 때 사용할 수 있는 코드로, initialize()메서드에 전달한 객체를 DB에서 로딩하는 기능을 제공한다. 예를 들어,Member 가 locker 프로퍼티를 지연 로딩으로 설정한 경우, Hibernate.initilize(member.getLocker())코드는 DB에서 locker 프로퍼티에 해당하는 값을 로딩해서 Locker객체를생성해준다.

~~~~
public class DataLoader{
	@Autowired
	private MemberRepository memberRepository;

	@Transactional
	public Member loadMember(Long memberId){
		Member member = memberRepository.findOne(memberId);
		if(member == null) return null
		Hibernate.initialize(member.getLocker());
		return member;
	}
}
~~~~

컨트롤러 코드는 리파지터리 대신 DataLoader 클래스를 상용해서 Member 객체를 읽어와 뷰에 전달하면 된다. DataLoader 클래스는 지연 로딩 대상인 객체를 로딩해주기 때문에, 뷰 코드는 지연로딩에 대한 걱정없이 member.getLocker() 객체의 값을 사용할수 있게 된다.

지연 로딩 대상 연관을 미리 읽어오는 것이 또 다른 방법은 뷰에서 필요한 데이터만 제공하는 별도 객체를 사용하는 것이다.