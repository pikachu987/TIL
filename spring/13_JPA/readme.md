## 스프링 데이터 JPA

DB 연동을 위해 사용되는 코드는 중복된 코드를 갖는 경우가 많다.

~~~~
public class JpaEmployeeRepository implement EmployeeRepository{

	@PersistenceContext
	private EntityManager entityManager;

	@Override
	public Employee findById(Long Id){
		return entityManager.find(Employee.class, id);
	}
}

public class JpaTeamRepository implements TeamRepository{
	@PersistenceContext
	private EntityManager entityManager;

	@Override
	public Employee findById(Long Id){
		return entityManager.find(Team.class, id);
	}
}    
~~~~

이 코드를 보면 JPA를 이용해서 DAO를 구현할 때, 두 클래스는 사용하는 엔티티 클래스의 이름만 드를 뿐 나머지 구현은 완전히 동일하다.

스프링 데이터(Spring Data) 모듈은 이렇게 단순 반복되는 코드의 양을 줄이는 것을 목표로 하고 있다. 스프링 데이터 모듈은 구현 클래스를 만들 필요 없이 정해진 규칙에 따라 인터페이스를 만들기만 하면, 런타임에 알맞은 구현 객체를 생성해주는 기능을 제공한다.

다음과 같은 인터페이스가 존재하면, 스프링 데이터 모듈은 이 인터페이스를 이용해서 JPA에 맞게 구현한 스프링 빈 객체를 런터임에 생성해준다.
~~~~
public interface EmployeeRepository extends Repository<Employee, Long>{
	public Employee findOne(Long id);
}
~~~~

흔히 보일러플레이트(boiler-plate)라고 불리는 반복되는 구조의 코드를 작성하지 않아도 되기 때문에, 스프링 데이터 모듈을 사용하면 단순 DB연동 코드 작성 시간을 줄이고 핵심 로직을 구현하는데 더 집중할 수 있게 된다.

스프링 데이터는 JPA, MongoDB, Neo4j, Redis, JDBC 확장 등 다양한 벡엔드 연동 기술에 맞는 모듈을 제공하고 있다.

> 리파지터리(Repository)
> 도메인 주도 설계 (Domain Driven Design: DDD) 방식으로 애플리케이션을 개발할 때 사용되는 주요 모델로 엔티티, 서비스, 리파지터리 등이 존재하며, 이 중에서 리파지터리는 엔티티를 보관하는 목적으로 사용된다. 새로운 엔티티 객체를 생성하면 리파지터리에 보관하며, 리파지터리로부터 필요한 엔티티 객체를 검색하게 된다. 즉, 리파지터리는 엔티티를 보관하는 역활을 표현하는 용어로 사용된다. 일반적으로 엔티티 객체의 지속적인 보관을 위해 저장소로 데이터베이스를 사용하는데, DDD 리파지터리를 구현할 때 객체와 데이터베이스 간의 매핑을 위해 ORM을 사용하곤 한다.

> 스프링 데이터는 데이터를 관리하는 인터페이스의 이름으로 DAO가 아닌 리파지터리란 용어를 선택했는데, 이는 DDD의 리파지터리와 잘 들어맞는다. 실제로 DDD방식으로 어플리케이션을 구현할 때 스프링 데이터 JPA를 이용해서 DDD의 리파지터리를 구현하는 경우가 많다.