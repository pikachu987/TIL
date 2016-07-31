### 리파지터리 인터페이스 메서드 작성 규칙

#### Repository 인터페이스
스프링 데이터 JPA모듈이 리파지터리로 사용할 인터페이스는 org.springframwork.data.repository.Repository 인터페이스를 상속받아야 한다.
~~~~
public interface Repository<T, ID extends Serializable>{
}
~~~~

Repository 인터페이스의 타입 파라미터 T는 엔티티의 타입을 의미하며, 타입파라미터 ID는 식별값 타입을 의미한다. 식별값으로 사용될 타입은 Serializable 인터페이스를 구현하고 있어야 한다. 앞서 작성해 본 EmployeeRepository 인터페이스의 경우 엔티티 타입으로 Employee를 사용하고 식별값 타입으로 Long을 사용했었다.

~~~~
import org.springframework.data.repository.Repository;

public interface EmployeeRepository extends Repository<Employee, Long>{
	public Employee findOne(Long id);
}
~~~~

> 트랜젝션 범위
> 스프링 데이터 JPA가 생성하는 리파지터리 객체는 기본적으로 다음과 같이 @Transactional 애노테이션을 적용한다.
> * 조회 메서드 : @Transactional(readOnly = true)
> * 변경 메서드 : @Transactional
> 즉, 리파지터리 각 메서드는 스프링의 트랜젝션 범위 내에서 실행되며, 조회 메서드만 실행할 경우 읽기 전용 트랜젝션으로 실행한다.

#### 조회 메서드 규칙
스프링 데이터 JPA 모듈을 사용할 때 가장 많이 참조하게 될 규칙이 바로 조회 메서드 작성 규칙이다. 먼저, 특정 식별값을 갖는 엔티티를 검색하는 메서드는 다음과 같이 findOne() 메서드를 사용한다.
* T findOne(ID primarKey)
T는 엔티티 타입이고 ID는 식별값 타입이다. 식별값에 해당하는 엔티티가 존재하면 해당 엔티티 객체를 리턴하고, 존재하지 않으면 null을 리턴한다.

모든 엔티티 목록을 구하고 싶을 때에는 findAll() 메서드를 사용한다. 리턴 타입은 다음과 같이 List나 Iterable 중 하나를 사용하면 된다.

* List<T> findAll()
* Iterable<T> findAll()

특정 프로퍼티 값을 이용해서 검색하고 싶다면 fintBy프로퍼티이름() 형식의 메서드를 사용한다. 예를 들어, biythYear 프로퍼티 값을 사용하면
* List<T> findByBirthYear(int value)
라고 하면 된다.
두개 이상의 프로퍼티를 검색하고 싶다면
* List<T> findByNameAndPassword(String name, String password)
* List<T> findByNameOrPassword(String name, String password)
으로 하면 된다.
And나 Or 외에 크기 비교나 Null여부, Like쿼리를 위한 메서드 키워드를 제공하고 있다.

##### 키워드 목록
<table>
<tr><th>키워드</th><th>메서드예시</th><th>JPQR변환</th></tr>
<tr>
<td>And</td>
<td>findByLastnameAndFirstname</td>
<td>where x.lastname = ?1 and x.firstname = ?2</td>
</tr>
<tr>
<td>Or</td>
<td>findByFirstNameOrLastName</td>
<td>where x.firstname = ?1 and x.lastname = ?2</td>
</tr>
<tr>
<td>Is, Equals</td>
<td>findByName, findByNamels, findByNameEquals</td>
<td>where x.name = ?1</td>
</tr>
<tr>
<td>Between</td>
<td>findByStartDateBetween</td>
<td>where x.startDate between 1? and 2?</td>
</tr>
<tr>
<td>LessThan</td>
<td>findByAgeLessThan</td>
<td>where x.age &lt; ?1</td>
</tr>
<tr>
<td>LessThanEqual</td>
<td>findByAgeLessThanEqual</td>
<td>where x.age &lt;= ?1</td>
</tr>
<tr>
<td>GreaterThan</td>
<td>findByAgeGreaterThan</td>
<td>where x.age &gt; ?1</td>
</tr>
<tr>
<td>GreaterThanEqual</td>
<td>findByAgeGreaterThanEqual</td>
<td>where x.age &gt;= ?1</td>
</tr>
<tr>
<td>After</td>
<td>findByStartDateAfter</td>
<td>where x.startDate &gt; ?1</td>
</tr>
<tr>
<td>Before</td>
<td>findByStartDateBefore</td>
<td>where x.startDate &lt; ?1</td>
</tr>
<tr>
<td>IsNull</td>
<td>findByAgeIsNull</td>
<td>where x.age is null</td>
</tr>
<tr>
<td>IsNotNull</td>
<td>findByAgeIsNotNull</td>
<td>where x.age not null</td>
</tr>
<tr>
<td>NotNull</td>
<td>findByAgeNotNull</td>
<td>where x.age not null</td>
</tr>
<tr>
<td>Like</td>
<td>findByNameLike</td>
<td>where x.name like ?1('%'가 붙지 않는다.)</td>
</tr>
<tr>
<td>NotLike</td>
<td>findByNameNotLike</td>
<td>where x.name not like ?1</td>
</tr>
<tr>
<td>StartingWith</td>
<td>findByNameStartingWith</td>
<td>where x.name like ?1(파라미터 뒤에 %가 붙음)</td>
</tr>
<tr>
<td>EndingWith</td>
<td>findByNameEndingWith</td>
<td>where x.name like ?1(파라미터 값 앞에 %가 붙음)</td>
</tr>
<tr>
<td>Containing</td>
<td>findByNameContaining</td>
<td>where x.name like ?1 (파라미터 양쪽에 %가 붙음)</td>
</tr>
<tr>
<td>Not</td>
<td>findByNameNot</td>
<td>where x.name &lt;&gt; ?1</td>
</tr>
<tr>
<td>In</td>
<td>findByAgeIn(Collection<Age> ages)</td>
<td>where x.age in ?1</td>
</tr>
<tr>
<td>NotIn</td>
<td>findByAgeNotIn(Collection<Age> ages)</td>
<td>where x.age not in ?1</td>
</tr>
<tr>
<td>True</td>
<td>findByActiveTrue</td>
<td>where x.active = true</td>
</tr>
<tr>
<td>False</td>
<td>findByActiveFalse</td>
<td>where x.active = false</td>
</tr>
<tr>
<td>IgnoreCase</td>
<td>findByNameIgnoreCase</td>
<td>where x.name like ?1 (파라미터 양쪽에 %가 붙음)</td>
</tr>
</table>

조회결과가 1개나 0개인 쿼리 메서드는 리턴 타입으로 Iterable 대신 엔티티 타입을 사용해도 된다.


##### 개수 조회 메서드
전체 개수를 구하는 메서드를 작성하고 싶다면 count()로 지정하면 된다.
특정 조건을 충족하는 엔티티의 개수를 구하고 싶다면 countBy로 시작하는 메서드를 추가하면 된다.
~~~~
public int countByTeamId(int teamId);
~~~~

##### 쿼리 메서드의 중첩 프로퍼티 접근

~~~~
public Iterable<Employee> findByTeamName(String teamName);
-> from Employee e where e.team.name = ?1
~~~~

만약 다음처럼 두개의 프로퍼티는?
~~~~
public class Employee{
	@Column(name="teamname") private String teamname;
	@ManyToOne private Team team;
}
~~~~
이 경우 리파지터리 인터페이스의 findByTeamName(String name) 메서드는 teamName 프로퍼티 값과 비교하게 된다. 만약 teamName 프로퍼티가 아니라 team프로퍼티의 중첩된 프로퍼티인 name값을 이용해서 비교하고 싶다면
~~~~
public List<Employee> findByTeam_Name(String teamname);
~~~~
구체적으로 지정해주어야 한다.

##### 정렬과 페이징
정렬을 처리하는방법은 크게 두 가지가 있다. 하나는 메서드 이름에 OrderBy를 이용해서 지정하는 것이다.
~~~~
public List<Employee> findByNameStartingWithOrderByNameAsc(String name);
public List<Employee> findByTeamIdOrderByIdDesc(Long teamId);
public List<Employee> findByBirthYearOrderByTeamNameAscNameAsc(int year);
~~~~
> 주의할 점은 OrderBy 키워드를 사용하려면 반드시 findBy와 함께 사용해야 한다는 점이다. findAllOrderByNameDesc()와 같은 이름을 사용할 경우 스프링 데이터 JPA모듈이 리파지터리 인테페이스의 메서드 이름을 분석하는 과정에서 익셉션을 발생시킨다. findAll() 메서드에 정렬을 적용하고 싶다면 뒤에서 설명할 Sort나 Pageable을 파라미터로 전달하는 방법을 사용해야 한다.

정렬하는 두 번째 방법은 Sort나 Pageable을 사용하는 것이다. OrderBy 키워드는 정렬 기준이 고정된 반면에, Sort나 Pageable을 사용하면 런타임에 정렬 순서를 지정할 수 있다. 따라서, 런타임에 정렬 순서를 지정하려면 Sort나 Pageable 타입의 파라미터를 사용해야 한다.

org.springframework.data.domain.Sort 클래스는 쿼리 메서드에 정렬 순서를 지정할 때 사용된다. 쿼리 메서드에서 정렬 순서를 지정하고 싶다면, 다음과 같이 쿼리 메서드의 마지막 파라미터로 Sort 타입 파라미터를 사용할 수 있다.

~~~~
import org.springframework.data.domain.Sort;

public interface EmployeeRepository extends Repository<Employee, Long>{
	public List<Employee> findAll(Sort sort);
	public List<Employee> findByTeam(Team team, Sort sort);
}
~~~~

Sort 객체를 생성할 때에는 다음과 같이 org.springframework.data.domain.Sort.Order 클래스를 이용할 수 있다.
~~~~
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.domain.Sort.Order;

Sort sort = new Sort(
	new Order(Direction.DESC, "team.id"),
	new Order(Direction.ASC, "name")
);
List<Employee> em = employeeRepository.findAll(sort);
~~~~

~~~~
new Sort(new Order("team.id"), new Order("name"));
new Sort("team.id", "name");
new Sort(Direction.DESC, "team.id", "name");
~~~~

Sort 대신에 org.springframework.data.domain.Pageable 인터페이스를 사용할 수도 있다. 쿼리 메서드의 마지막 파라미터로 Pageable 타입을 사용하면, 조회 범위와 정렬 순서를 함꼐 지정할 수 있다.
~~~~
public interface EmployeeRepository extends Repository<Employee, Long>{
	....
	public List<Employee> findByBirthYearLessThan(int birthYear, Pageable pageable);
}
~~~~

Pageable 타입의 객체를 생성할 때에는 org.springframework.domain.PageRequest 클래스를 사용한다.(직접 Pageable 인터페이스를 구현한 클래스르 만들 수도 있지만, PageRequest클래스가 이미 필요한 내용을 구현하고 있다.) PageRequest 클래스의 생성자는 다음과 같다.
* PageRequest(int page, int size)
* PageRequest(int page, int size, Sort sort)
* PageRequest(int page, int size, Direction direction, String ... properties)

page 파라미터와 size 파라미터는 페이징과 관련된 것이다. page파라미터는 0 기반의 페이지 번호를 지정하며, size는 한 번에 읽어올 개수를 지정한다. 
~~~~
//세번째 페이지, 5개씩
Pageable page = new PageRequest(2, 5);
List<Employee> em = employeeRepository.findByBirthYearLessThan(2000, pageable);
~~~~

정렬을 지정하고 싶다면
~~~~
Pageable page = new PageRequest(2, 5, new Sort("birthYear"));
~~~~

Pageable 타입 파라미터를 갖는 쿼리 메서드는 리턴 타입으로 org.springframework.data.domain.Page&lt;T&gt; 타입을 사용할 수 있다. 앞서 살펴본 쿼리 메서드가 리턴 타입으로 엔티티 타입이나 Iterable 타입(또는 그 하위 타입인 List 등의 타입)을 사용했는데, 이들 타입은 값 목록만을 표현한다는 특징이 있다. 반면에 Page 타입은 값 목록뿐만 아니라 전체 페이지 개수, 전체 데이터 개수, 이전/다음 페이지를 가졌는지 여부 등의 정보도 함꼐 제공한다.

~~~~
public Page<Employee> findByTeam(Team team, Pageable pageable)
~~~~

Page 인터페이스가 제공하는 메서드

<table>
<tr><th>메서드</th><th>설명</th></tr>
<tr>
<td>int getTotalPages()</td>
<td>전체 페이지 개수를 구한다.</td>
</tr>
<tr>
<td>long getTotalElements()</td>
<td>전체 엘리먼트(엔티티) 개수를 구한다.</td>
</tr>
<tr>
<td>int getNumber()</td>
<td>현재 페이지 번호를 구한다.</td>
</tr>
<tr>
<td>int getNumberOfElements()</td>
<td>리턴된 엘리먼트의 개수를 구한다.</td>
</tr>
<tr>
<td>int getSize()</td>
<td>페이지 기준 크기를 구한다.</td>
</tr>
<tr>
<td>boolean hasContent()</td>
<td>조회 결과가 존재하는지 여부를 구한다.</td>
</tr>
<tr>
<td>List&lt;T&gt; getContent()</td>
<td>조회된 엘리먼트 목록을 구한다.</td>
</tr>
<tr>
<td>boolean isFirst()</td>
<td>첫 번째 페이지인지 여부를 구한다.</td>
</tr>
<tr>
<td>boolean isLast()</td>
<td>마지막 페이지인지 여부를 구한다.</td>
</tr>
<tr>
<td>boolean hasNext()</td>
<td>다음 페이지가 존재하는지 여부를 구한다.</td>
</tr>
<tr>
<td>boolean hasPrevious()</td>
<td>이전 페이지가 존재하는지 여부를 구한다.</td>
</tr>
</table>

> Pageable과 SQL 쿼리
> Pageable을 쿼리 메서드의 파라미터로 사용할 때 리턴 타입이 Iterable 이나 List와 같은 단순 목록이냐 아니면 Page 이냐에 따라 실행되는 쿼리가 달라진다.
> ~~~~
> Pageable pageable = new PageReuqest(1, 4, new Sort("birthYear"));
> Team team = ......
> List<Employee> emps = ...
> Page<Employee> pageEmps = ...
> ~~~~
> 이때, 리턴 타입이 List인 findByTeamId() 메서드와 리턴 타입이 Page인 findByTeam() 메서드는 둘 다 아래의 쿼리를 실행한다.
> ~~~~
> select e.id, .......... order ..... limit ...
> ~~~~
> 그리고 리턴 타입이 Page인 경우는 페이징과 관련된 정보때문에
> ~~~~
> select count(id) from ...
> ~~~~
> 이 쿼리를 한 번 더 실행한다.

만약 쿼리 메서드 이름에 OrderBy 를 사용하고파라미터 타입으로 Sort나 Pageable을 사용하면?
~~~~
public Iterable<Employee> findByTeamIdOrderByNameDesc(Long teamId, Sort sort);
~~~~
이 쿼리 메서드는 OrderBy를 이용해서 name을 역순으로 정렬후 메서드 마지막 파라미터로 Sort를 받는다.
~~~~
Sort sort = new Sort("birthYear");
Iterable<Employee> emps = empRepository.findByTeamIdOrderByNameDesc(1, sort);
-> from table e where e.team.id = 1 order by name desc, birthYear asc
~~~~
이 쿼리를 보면 OrderBy 키워드로 지정한 정렬 순서가 먼저 적용되고 그 다음에 Sort 나 Pageable파라미터 정렬순서가 적용된다.
<br><br><br><br><br><br>
#### 저장 메서드 규칙
엔티티를 DB에 저장하려면
~~~~
publci interface EmployeeRepository extends repository<Employee, int>{
	Employee save(Employee entity);
}
~~~~
save() 메서드는 저장하거나 또는 수정한다.

다음의 경우 save()메서드는 EntityManager.persist() 메서드를 이용해서 엔티티를 DB에 저장하고, 파라미터로 전달받은 entity객체를 리턴한다.
* **버전 프로퍼티가 없는 경우** : 파라미터로 전달한 엔티티 객체의 ID에 해당하는 프로퍼티 값이 null임
* **버전 프로퍼티가 있는 경우** : 버전 프로퍼티의 값이 null임

다음의 경우 EntityManager.merge() 메서드를 이용해서 기존 데이터를 변경하고 merge()메서드의 결과를 리턴한다.
* **버전프로퍼티가 없는 경우** : 파라미터로 전달한 엔티티 객체의 ID에 해당하는 프로퍼티 값이 null이 아님
* **버전 프로퍼티가 있는 경우** : 버전 프로퍼티의 값이 null이 아님

즉, 리파지터리 인터페이스의 save() 메서드는 실제로는 saveOrUpdate()와 같은 기능을 제공한다.

만약 엔티티 클래스가 org.springframework.data.domain.Persistable 인터페이스를 구현하고 있다면, 이 인터페이스에 정의된 isNew() 메서드를 이용해서 새로운 객체인지 여부를 판단한다.

#### 삭제 메서드 규칙

특정 엔티티를 DB에서 삭제하려면 다음의 delete() 메서드를 사용한다.
~~~~
pulbic interface EmployeeRepository extends Repository<Employee, int>{
	void delete(Long id);
	void delete(Employee entity);
	void delete(Iterable<Employee> entites);
	void deleteAll();
}
~~~~

식별값을 파라미터로 전달받는 delete() 메서드는 식별값에 해당하는 데이터를 DB에서 삭제한다. 만약 id에 해당하는 데이터가 존재하지 않으면 EmptyResultDataAccessExcetpion을 발생시킨다.

한 개 엔티티를 전달받는 delete() 메서드와 Iterable로 목록을 전달받는 delete() 메서드는 파라미터로 전달받은 엔티티를 DB에서 삭제한다.

deleteAll() 메서드는 모든 데이터를 삭제한다. deleteAll() 메서드를 사용하면 내부적으로 delete(findAll())) 을 실행한다. 즉, "delete from employee" 가 아닌 "delete from employee where employee_id = ?" 쿼리를 엔티티 개수만큼 실행하므로, 조금이라도 빠른 실행 속도를 원하면 대신 쿼리를 실행하는 방법을 사용해야 한다.