### 기본 제공 인터페이스

~~~~
public interface EmployeeRepository extends Repository<Employee, Long> {
	Employee findOne(Long id);
	Employee save(Employee employee);
}

public interface TeamRepository extends Repository<Team, Long>{
	Team findOne(Long id);
	Team save(Team team);
}
~~~~

스프링 데이터 JPA는 이런 기본 메서드를 각 리파지터리마다 작성해야 하는 번거로움을 없애기 위해, 자주 사용되는 기본 메서드를 정의한 인터페이스를 이미 제공하고 있다.

리파지터리로 사용할 인터페이스는 필요한 메서드를 정의한 인터페이스를 상속받기만 하면 된다. CrudRepository 인터페이스는 findOne()과 save()를 비롯해 CRUD에 필요한 기본적인 메서드를 포함하고 있기 때문에, 기본 CRUD 기능 외에 자신만의 추가적인 조회 메서드가 필요하다면 Repository 인터페이스 대신 CrudRepository인터페이스를 상속받은 리파지터리를 만들면 된다.

~~~~
public interface EmployeeRepository extends CrudRepository<Employee, Id>{
	//findOne(),save()등의 메서드는 이미 CrudRepository에 정의
}
~~~~

> JpaRepository 인터페이스와 JpaSpecificationExecutor 인터페이스를 상속받으면, 기본적인 모든 메서드를 상속받기 때문에 추가할 메서드는 몇 개 되지 않는다. 이런 이유로 코딩의 편리함을 위해 이 두 인터페이스를 모두 상속받고 시작할 때도 있다.

#### CrudRepository 인터페이스의 메서드

~~~~
@NoRepositoryBean
public interface CrudRepository<T, ID extends Serializable> extends Repository<T, ID>{
	<S extends T> S save(S entity);
	<S extends T> Iterable<S> save(Iterable<S> entities);
	T findOne(ID id);
	boolean exists(ID id);
	Iterable<T> findAll();
	Itereable<T> findAll(Iterabble<ID> ids);
	long count();
	void delete(ID id);
	void delete(T entity);
	void delete(Iterable<? extends T> entities);
	void deleteAll();
}

~~~~

#### PagingAndSortingRepository 인터페이스의 메서드

~~~~
public interface PageingAndSortingRepository<T, ID extends Serializable> extends CrudRepository<T, ID>{
Iterable<T> findAll(Sort sort);
Page<T> findAll(Pageable pageable);
~~~~

#### JpaRepository 인터페이스의 메서드

~~~~
public interface JpaRepository<T, ID extends Serializable> extends PagingAndSortingRepository<T, ID>{
	List<T> findAll();
	List<T> findAll(Sort sort);
	List<T> findAll(Iterable<ID> ids);
	<S extends T> List<S> save(Iterable<S> entities);
	void flush();
	<S extends T> S saveAndFlush(S entity);
	void deleteInBatch(Iterable<T> entities);
	void deleteAllInBatch();
	T getOne(ID id);
}
~~~~

메서드 목록에서 flush()메서드는 아직 DB에 반영되지 않은 내용을 DB에 반영시킨다. saveAndFlush() 메서드는 save()를 수행한 뒤에 flush()를 한다.

deleteInBatch() 메서드는 파라미터로 전달받은 엔티티 목록의 식별값을 이용해서 다음의 쿼리를 실행한다.(JPA Query 의 executeUpdate() 메서드를 이용해서 실행한다.)

~~~~
delete from 엔티티타입 x where x = ?1 or x= ?2 or ....
~~~~

deleteAllInBatch() 메서드는 다음 쿼리를 이용해서 전체 삭제 처리를 한다.

~~~~
delete from 엔티티타입 x
~~~~

getOne() 메서드는 EntityManager의 getRefrence() 메서드를 이용해서 엔티티에 대한 레퍼런스를 구한다. 참고로 EntityManager.getReference()가 리턴한 레퍼런스 객체는 실제 엔티티 객체가 아닌 프록시 객체다. 이프록시 객체는 최초로 데이터에 접근할 때 DB에서 데이터를 읽어오는데 만약 DB에 식별값에 해당하는 데이터가 존재하지 않으면 EntityNotFoundException을 발생시킨다.(스프링은 EntityNotFoundException을 다시 스프링에 맞는 ObjectRetrievalFailureException으로 변한해서 발생한다.)


#### JpaSpecificationExecutor 인터페이스의 메서드

~~~~
public interface JpaSpecificationExecutor<T>{
	T findOne(Specification<T> spec);
	List<T> findAll(Specification<T> spec);
	Page<T> findAll(Specification<T> spec, Pageable pageable);
	List<T> findAll<Specification<T> spec, Sort sort);
	long count(Specification<T> spec);
}
~~~~

#### 공통 인터페이스 만들기

많은 엔티티 클래스가 PK에 해당하는 식별값 프로퍼티 외에 추가로 고유한 값을 갖는 name프로퍼티를 갖는다고 하면 이 경우 각 엔티티에 해당하는 리파지터리 인터페이스는 findByName(String name) 메서드를 정의할 것이다.

이렇게 중복해서 출현하는 메서드가 있다면, 이 중복 메스드를 정의한 인터페이스를 정의하는 방법으로 메서드 중복 입력을 줄일 수 있다.

~~~~
import org.springframework.data.repository.NoRepositoryBean;

public interface NameFindableRepository<T>{
	T findByName(String name);
}
~~~~

~~~~
public interface EmployeeRepository extends JpaRepository<Employee, Long>, NameFindableRepository<Employee>{

}
~~~~



### 커스텀 구현하기

~~~~
public class Option<T>{

	private T value;

	public Option(T value){
		this.value = value;
	}

	public boolean hasValue(){
		return value != null;
	}

	public T get(){
		if(value == null) throw new IllegalStateException("no value");
		return value;
	}
}

~~~~

Option 타입을 리턴 값으로 사용하면 다음과 같이 null 체크 대신에 hasValue() 메서드를 이용해서 값이 존재하는지 여부를 확인하도록 바꿀 수 있다.


~~~~
Option<Employee> empOp = employeeRepo.getOptionEmployee(someId);
if(empOp.hasVale()){
	Employee emp = empOp.getValue();
	....
}
~~~~

null을 리턴하는 대신 Option을 리턴하면 값이 존재하지 않을 수도 있다는 것을 명시적으로 표현할 수 있기 때문에, null 검사를 안해서 NullPointerException이 발생하는 실수를 줄일수 있다.

그런데, 스프링 데이터 JPA는 리턴 타입으로 Option 타입을 지원하지 않기 때문에 다음 메서드를 추가할 수 없다.
~~~~
public interface EmployeeRepository extends Repository<Employee, Long>{
	//익셉션 발생
	public Option<Employee> getOptionEmployee(Long id);
}
~~~~

이렇게 스프링이 지원하는 규칙에서 벗어난 메서드를 추가하고 싶다면, 직접 커스텀 구현을 만들어야 한다. 커스텀 구현을 추가하는 방법은 두 가지가 있다. 첫 번째는 단일 리파지터리를 위한 커스텀 구현을 추가하는 방법법은 두 가지가 있다. 첫 번째는 단일 리파지터리를 위한 커스텀 구현 추가 방법이고 다른 하나는 모든 리파지터리를 위한 커스텀 구현 추가 방법이다.

#### 단일 리파지터리를 위한 구현 클래스 등록

* 1. 커스텀 메서드를 정의한 인터페이스를 정의한다.
* 2. 리파지터리로 사용할 인터페이스가 1에서 만든 커스텀 인터페이스를 상속받도록 한다.
* 3. 1에서 정의한 커스텀 인터페이스를 구현한 커스텀 구현 클래스를 작성한다.
* 4. (선택) 3에서 구현한 커스텀 클래스를 스프링 빈으로 등록한다.
*   	 A. 리파지터리 인터페이스 이름 뒤에 지정한 접미사(Impl)을 붙인 이름을 커스텀 클래스의 이름으로 사용했다면 스프링 빈으로 등록하지 않아도 된다.

먼저 할 일은 커스텀 메서드를 정의한 인터페이스를 작성하는 것이다.

~~~~
public interface EmployeeCustomRepository{
	public Option<Employee> getOptionEmployee(Long id);
}
~~~~

커스텀 인터페이스를 작성했다면, 리파지터리로 사용할 인터페이스가 커스텀 인터페이스를 상속하도록 한다.

~~~~
public interface EmployeeRepository extends EmployeeCustomRepository, Repository<Employee, Long>{
	...
}
~~~~

이제 클래스를 구현

~~~~
public class EmployeeRepositoryImpl implements EmployeeCustomRepository{
	@PersistenceContext
	private EntityManager entityManager;

	@Override
	public Option<Employee> getOptionEmployee(Long id){
		Employee emp = entityManager.find(Employee.class, id);
		return Option.value(emp);
	}
}
~~~~


커스텀 구현 클래스르 스프링 빈으로 등록하면된다. 스프링 빈으로 등록하는 방법에는 두 가지가 있다. 먼저 구현 클래스 이름이 인터페이스이름 + 접미사(Impl)이면 JPA가 자동으로 검색해서 빈으로 등록한다.

단 이 클래스는 스프링데이터 JPA가 스캔하는 패키지에 위치해야한다.

접미사를 붙이는 방법을 사용하면 커스텀 구현체가 스캔을 통해서 등록된다. 커스텀 구현 클래스에서 다른 빈 객체를 내부에서 사용해야 한다면, @Autowired나 @Resource 등의 애노테이션을 이용해서 의존 자동 주입을 해야 한다.

기본 접미사를 바꾸려면

~~~~
<jpa-repositories base-package="com.company.domail" repository-impl-postfix="foo"></jpa:repositories>
~~~~

~~~~
@EnableJpaRepositories(basePackages = "com.company.domain", repositoryImplementationPostfix = "foo")
public class JpaConfig{

}
~~~~


남은건 리파지터리의 커스텀 메서드를 사용하는거다.
스프링 데이터 JPA는 리파지터리의 커스텀 메서드를 호출하면, 앞서 구현한커스텀 구현 클래스를 이용해서 기능을 제공하게 된다.

~~~~
//EmployeeRepositoryImpl의 getOptionEmployee()를 실제 구현으로 사용
Option<Employee> empOp = employeeRepository.getOptionEmployee(100L);
~~~~

만약 정해진 접미사를 사용하지 않았거나 복잡한 설정 때문에 자동 스캔을 사용할 수 없다면, 직접 커스텀 구현 객체를 스프링 빈으로 등록해도 된다. 이때 빈의 식별 값은 '리파지터리 타입 이름 + 접미사' 의 형식을 가져야 한다.

아래코드는 직접 빈으로 등록한 설정 예를 보여준다
이 코드는 커스텀 구현 클래스 위치가 <jpa:repositories> 에서 지정한 패키지가 아닌 다른 패키지에 있다.
~~~~
<jpa-repositories base-package="com.company.domail" repository-impl-postfix="foo"></jpa:repositories>
<bean id="employeeRepositoryImpl" class="com.company.temp.EmployeeRepositoryImpl">
</bean>
~~~~

#### 전체 리파지터리를 위한 메서드 구현 등록

개별 리파지터리가 아닌 전체 리파지터리에 커스텀 기능을 추가할 수도 있다.

스프링 데이터 JPA는 런타임에 리파지터리 구현 객체를 생성할 때, SimpleJpaRepository 객체의 메서드를 구현으로 사용한다. 예를 들어, EmployeeRepository 인터페이스에 정의된 findOne() 메서드를 실행하면 실제로 SimpleJpaRepository 객체의 findOne() 메서드가 실행된다. 즉, 런타임에 리파지터리에서 사용할 구현체로 SimpleJpaRepository 클래스를 사용한다.

런타임에 사용할 리파지터리 구현체를 생성해주는 것이 바로 JpaRepositoryFactory클래스이고, 이 클래스이 객체를 생성할 때 사용하는 것이 JpaRepositoryFactoryBean 클래스이다.

가장 먼저 기능을 정의한 인터페이스를 작성한다. 이 인터페이스는 JpaRepository인터페이스를 상속받은 뒤, 추가할 메서드를 정의한다.

~~~~
import org.springframework.data.jpa.repository.JpaRepository;
public interface CustomRepository<T, ID extends Serializable> extends JpaRepository<T,ID>{
	//모든 리파지터리 대상으로 추가 가능한 메서드 정의
	public Option<T> getOption(ID id);
}
~~~~

다음으로 추가할 기능의 구현을 제공할 클래스를 작성한다. 이 클래스는 SimpleJpaRepository 클래스를 상속받고, 앞서 정의한 인터페이스를 구현한다.

~~~~
import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;

public class CustomJpaRepository<T, ID extends Serializable> extends SimpleJpaRepository<T,ID> implements CustomRepository<T,ID>{

	//기능 구현에 필요한 EntityManager 필드에 보관
	private EntityManager entityManager;

	public CustomJpaRepository(Class<T> domainClass, EntityManager em){
		super(domainClass, em);
		this.entityManager = em;
	}

	public CustomJpaRepository(JpaEntityInformation<T,?> entityInformation, EntityManager entityManager){
		super(entityInformation, entityManager);
		this.entityManager = entityManager;
	}

	//커스텀 기능 구현
	@Override
	public Option<T> getOption(ID id){
		return Option.value(entityManager.find(getDomainClass(), id));
	}
}
~~~~


커스텀 기능 구현 클래스를 만들었으니, 이제 이 구현 클래스를 이용해서 객체를 생성하는 팩토리를 만들어야 한다.
이 팩토리 클래스는 JpaRepositoryFactory 클래스를 상속받은 뒤 getTargetRepository() 메서드와 getRepositoryBaseClass()를 재정의 하면 된다.

~~~~
import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.repository.core.RepositoryMetadata;

public class CustomRepositoryFactory extends JpaRepositoryFactory{
	private EntityManager entityManager;

	public CustomRepositoryFactory(EntityManager entityManager){
		super(entityManger);
		this.entityManger = entityManager;
	}

	@SuppressWarnings({"rawtypes", "unchecked"})
	@Override
	protected Object getTargetRepository(RepositoryMetadata metadata){
		return new CustomJpaRepository(metadata.getDomainType(), entityManager);
	}

	@Override
	protected Class<?> getRepositoryBaseClass(RepositoryMetadate metadate){
		return CustomJpaRepository.class;
	}
}
~~~~
위 코드에서 두 메서드는 앞서 구현한 CustomerJpaRepository를 사용해서 재정의했다.

이제 마지막으로 팩토리 생성을 위한 FactoryBean 클래스를 작성할 차례이다.
JpaRepositoryFactoryBean 클래스를 상속받은 뒤 앞서 작성한 팩토리 객체를 리턴하도록 createRepositoryFactory() 메서드를 재정의 해주면 된다.

~~~~
import javax.persistence.EntityManager;


import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.jpa.repository.Repository;
import org.springframework.data.jpa.repository.support.RepositoryFactorySupport;

public class CustomRepositoryFactoryBean <T extends Repository<S, ID>, S, ID extends Serializable> extends JpaRepositoryFactoryBean<T, S, ID> {

	@Override
	protected RepositoryFactorySupport createRepositoryFactory(EntityManager entityManager){
		return new CustomRepositoryFactory(entityManager);
	}

}
~~~~

이제 스프링 데이터 JPA 모듈이 커스텀 구현을 사용하도록 만들자.

스프링이 커스텀 구현 클래스를 사용하도록 하려면, 다음과 같이 JPA설정에 CustomRepositoryFactoryBean 클래스를 팩토리 클래스로 사용하도록 지정하면 된다.

~~~~
<jpa-repositories base-package="com.company.domail" factory-class="com.company.common.CustomRepositoryFactoryBean"></jpa:repositories>
~~~~

~~~~
@EnableJpaRepositories(basePackages = "com.company.domain", repositoryFactoryBeanClass = CustomRepositoryFactoryBean.class)
public class JpaConfig{

}
~~~~

모든 설정이 끝났다. 리파지터리에서 쓰면 된다.

~~~~
public interface EmployeeRepository extends Repository<Employee, Long>{
	public Option<Employee> getOption(Long id);
}
public interface TeamRepository extends Repository<Team, Long>{
	public Option<Team> getOption(Long id);
}
~~~~