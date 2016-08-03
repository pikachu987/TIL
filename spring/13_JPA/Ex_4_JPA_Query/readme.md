### @Query를 이용한 JPQL/네이티브 쿼리 사용

org.springframework.data.jpa.repository.Query 애노테이션을 사용하면 조회 메서드에서 실행할 쿼리를 직접 지정할 수 있다.
~~~~
@Query("from Employee e where e.employeeNumber =?1 or e.name like %?2%")
public Employee findByEmployeeNumberOrNameLike(String empNum, String name);

@Query("from Employee e where e.birthYear < :year order by e.birthYear")
public List<Employee> findEmployeeBornBefore(@Param("year") int year);
~~~~
@Query 애노테이션은 실행할 JPQL을 값으로 갖는다. 첫 번째 @Query 애노테이션 쿼리를 보면 위치 기반 쿼리 파라미터인 ?1과 ?2가 있는데, 여기서 ?1과 ?2는 각각 첫 번째 파라미터 empNum과 두번째 파라미터 name값을 사용한다. ?2를 벼면 앞뒤로 %가 있는데, 이는 like 검색을 위한 것이다.

두 번째 @Query의 JPQL은 ":year"를 포함하고 있다. ":이름"은 이름 기반의 네임드 파라미터로서, 네임드 파라미터의 이름과 동일한 값을 갖는 @Param 애노테이션이 적용된 메서드 파라미터 값이 사용된다. 위 코드의 경우 :year 위치에 year 파라미터 값이 사용된다.

@Query 애노테이션에서 사용하는 쿼리에서 order by 를 사용해서 정렬 순서를 지정할 수 있다. 또한, 다음 코드처럼 조회 메서드의 파라미터로 Sort와 Pageable을 사용해서 정렬 순서와 페이징 처리를 할 수도 있다.
~~~~
@Query("from Employee e where e.birthYear <![CDATA[<]]> : year")
public List<Employee> findEmployeeBornBefore(@Param("year") int year, Sort sort);

@Query("from Employee e where e.birthYear <![CDATA[<]]> :year order by e.birthYear")
public Page<Employee> findEmployeeBornBefore(@Param("year") int year, Pageable pageable);
* 여기서 <![CDATA[]]> 는 마크다운 문법에 부등호가 위배되기 때문에 붙여놓은 것이다. 실제 사용시 <![CDATA[]]>는 제외하여야 한다.
~~~~

첫 번째 메서드처럼 @Query의 쿼리에 order by 절이 없으면 Sort 타입 파라미터나 Pageable에 지정한 Sort를 이용해서 order by 부분을 생성한다. 반면에 두 번째 메서드처럼 @Query의 쿼리에 order by가 존재하고 메서드 파라미터에 Sort가 포함되어 있다면, 쿼리의 order by 절 뒤에 Sort로 지정한 정렬 순서를 추가한다. 예를 들어, 위 코드에서 Pageable을 전달받는 메서드를 다음과 같이 호출했다고 해보자.
~~~~
PageRequest pageReq = new PageRequest(1,2, new Sort("name"));
Page<Employee> pageEmp = empRepository.findEmployeeBornBefore(1980, pageReq)
~~~~
위 코드를 실행하면 실제로 다음과 같은 order by 절을 사용한 JQPL을 실행하게 된다.
~~~~
from Employee e where e.birth < 1980 order by e.birthYear asc, name asc
~~~~

> 자바 7버전 까지는 네임드 파라미터를 사용하려면 @Param 애노테이션을 이용해서 메서드 파라미터와 매핑될 네임드 파라미터의 이름을 지정해 주어야 했다. 하지만, 자바 8 버전부터는 새롭게 추가된 메서드 파라미터 이름 발견 기능을 통해 네임드 파라미터와 동일한 이름을 갖는 메서드 파라미터를 사용할 수 있다.

#### 수정 쿼리 실행하기

수정 쿼리를 사용할 경우 @Modifying애노테이션을 함꼐 사용해야 한다.
~~~~
import org.springframework.data.jpa.repository.Modifying;
public interface TeamRepository extends Repository<Team, Long>{
	@Modifying
	@Query("update Team t set t.name = ?2 where t.id = ?1")
	public int updateName(Long id, String newName);
}
~~~~

수정 쿼리 메서드는 쿼리 실행 결과로 수정된 행의 개수를 리턴한다.
수정 쿼리 메서드를 실행할 때 주의할 점이 있다.

~~~~
@Transactional
@Override
public void updateName(Long teamId, String newName){
	Team team = teamRepository.findOne(teamId);
	if(team == null)
		throw new TeamNotFoundException("No Team for ID["+teamId+"]);
	//변경 전 : team.getName() 은 변경 전 값
	int updated = teamRepository.updateName(teamId, newName);
	//쿼리 실행 후 : team.getName() 은 여전히 이전값
}
~~~~

위 코드는 findOne() 메서드로 엔티티 객체를 구한다. 엔티티가 존재하면 updateName() 를 이용해서 수정 쿼리를 실행한다. updateName() 쿼리를 실행하면 DB데이터가 변경 되지만, 앞서 읽어온 엔티티의 데이터는 변경되지 않는다. 이는 JPA의 영속성 컨텍스트에 변경 내역이 반영되지 않았기 때문에 발생하는 증상이다.

만약 수정 쿼리를 실행 한 후에 이미 로딩한 엔티티 객체에 변경 내역을 반영하고 싶다면, 다음과 같이 @Modifying 애노테이션의 clearAutomatically 속성값을 true로 해주면 된다.
~~~~
@Modifying(clearAutomatically=true)
@Query("update Team t set t.name = ?2 where t.id = ?1")
public int updateName(Long id, String newName);
~~~~

#### 네이티브 쿼리 사용하기

네이티브 쿼리를 실행하고 싶다면, @Query 애노테이션의 값으로 네이티브 쿼리를 입력하고 nativeQuery 속성의 값을 true로 지정하면 된다.

~~~~
@Query(value="select * from TEAM where NAME like ?1%", nativeQuery = true)
List<Team> findByNameLike(String name);
~~~~

네이티브 쿼리를 사용할 때 주의할 점은 메서드에 Sort나 Pageable를 파라미터로 추가해도 원하는 결과를 얻을 수 없다. 네이티브 쿼리를 사용하면 정렬이나 페이징 처리와 관련된 쿼리를 각 DBMS에 맞게 생성하는게 어렵기 때문에, Sort나 Pageable이 제대로 반영되지 않는다.



### Specification을 이용한 검색조건

상황에 따라 다양한 조건을 조합해서 검색 조건을 생성해야 할 때가 있다.

* **검색어가 있다면** : 검색어와 같은 name을 갖거나 같은 employeeNumber을 같는 employee를 검색한다.
* **검색 조건에 팀ID가있다면** : 해당 팀에 속하는 Employee를 검색한다.
* **검색어와 팀ID가 없다면** : 최근 한 달 내에 입사한 Employee를 검색한다.

위 조건의 경우 검색어와 팀 ID의 존재 여부에 따라 다음과 같은 쿼리를 실행한다.

* from Employee e where (e.name = 검색어 or e.employeeNumber = 검색어)
* from Employee e where e.team.id = 팀ID
* from Employee e where (e.name = 검색어 or e.employeeNumber = 검색어) and e.team.id = 팀ID
* from Employee e where e.joinDate > '한달전 날짜'

검색 조건이 더 다양하다면 사용해야 할 쿼리도 더 많아지게 되고, 이는 결과적으로 리파지터리의 쿼리 메서드를 증가시키는 상황을 만들게 된다. 이런 문제를 해소하기 위해 다음 코드처럼 JPA의 Criteria API를 사용할 수 있다.

~~~~
public class JpaEmployeeListService implements EmployeeListService{

	@PersistenceUnit
	private EntityManagerFactory entityManagerFactory;
	private EmployeeRepository employeeRepository;

	@Transactional
	@Override
	public List<Employee> getEmployee(String keyword, Long teamId){
		CriteriaBuilder cb = entityManagerFactory.getCriteriaBuilder();
		CriteriaQuery<Employee> query = cb.createQuery(Employee.class);
		Root<Employee> employee = query.form(Employee.class);
		query.select(employee);
		if(hasValue(keyword || hasValue(teamId)){
			if(hasValue(keyword && !hasValue(teamId)){
				query.where(
					cb.or(
						cb.equal(employee.get("name"), keyword),
						cb.equal(employee.get("employeeNumber"),keyword)
					)
				);
			} else if(!hasValue(keyword) && hasValue(teamId)){
				query.where(cb.equal(employee.get("team").get("id"), teamId));
			} else{
				query.where(cb.and(
					cb.or(
						cb.equal(employee.get("name"), keyword),
            			cb.equal(employee.get("employeeNumber"), keyword)
					),cb.equal(employee.get("team").get("id"), teamId)
				));            		
            }
		}else{
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DATE, -30);
			query.where(
				cb.greaterThan(employee.<Date> get("joinedDate"), cal.getTime())
			);
		}
		//실제로 스프링 데이터 JPA는 CriteriaQuery 타입 프로퍼티를 지원하지 않음.
		return employeeRepository.findAll(query);
	}
	....
}

~~~~

위 코드처럼 CriteriaBuilder를 이용해서 조건에 맞는 검색 조건을 생성하는 CriteriaQuery 객체를 생성할 수 있지만, 위 코드는 다음과 같은 담점을 갖고 있다.

* EmployeeListService는 DB에 대한 직접 접근이 필요 없음에도 불구하고 Criteria API를 사용하기 위해 DB와 관련된 EntityManagerFactory를 필드로 참조해야 한다.
* 스프링 데이터 JPA는 리파지터리 메서드의 파라미터로 CriteriaQuery타입을 지원하지 않는다.

스프링 데이터 JPA는 조회 메서드에서 CriteriaQuery를 직접 지원하지 않는 대신, 좀 더 표현력이 좋은 Specification 타입을 도입했다. Specification 타입을 사용하면, Criteria API와 같은 검색 조건 조합을 만들 수 있으면서도 검색 조건을 생성하는 코드에서 EntityManagerFactory, CriteriaBuilder 등 JPA관련 코드를 직접 사용하지 않아도 되는 장점이 있다.

Specification을 이용해서 검색 조건을 지정하려면 다음 작접을 하면 된다.
* Specification을 입력 받도록 Repository 인터페이스를 정의하기
* 검색 조건을 모아 놓은 클래스 만들기
* 검색 조건을 조합한 Specification 인스턴스를 이용해서 검색하기
<br>
<br>
#### 리파지터리 인터페이스에 Specification 타입 파라미터 추가하기