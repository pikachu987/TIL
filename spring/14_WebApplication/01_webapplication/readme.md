### 서비스-DAO 구조

웹 어플리케이션을 개발할 때 가장 많이 사용되는 구조는 컨트롤러-서비스-DAO로 이어지는 구성이다.

<table>
<tr><th>구성 요소</th><th>역활</th></tr>
<tr>
<td>모델</td>
<td>데이터베이스 테이블과 관련된 클래스가 위치한다. CRUD의 기본 단위로 사용되며, 서비스-DAO 간 데이터를 주고 받기 위한 객체로도 사용된다.</td>
</tr>
<tr>
<td>DAO</td>
<td>Data Access Object 의 약자로, 데이터베이스 테이블에 대한 CRUD 기능을 정의한다. 데이터 입력이나 수정, 조회 시 데이터 타입으로 모델을 사용한다.</td>
</tr>
<tr>
<td>서비스</td>
<td>컨트롤러를 통해서 전달받은 사용자의 요청을 구한다. DB 연산이 필요한 경우 DAO를 이용한다.</td>
</tr>
<tr>
<td>컨트롤러</td>
<td>사용자의 웹 요청을 받아 서비스나 DAO에 전달하고, 결과를 뷰에 전달한다.</td>
</tr>
</table>

스프링 기반 어플리케이션에서 컨트롤러, 서비스, DAO는 각각 스프링 빈으로 등뢱되며, DI를 이용해서 의존 대상을 조립한다.

#### DAO 인터페이스의 정의

DAO는 Data Access Object 의 약자로 데이터 접근에 필요한 메서드를 정의한다. 보통 SQL의 CRUD에 해당하는 insert, select, update, delete 메서드를 정의한다. insert()와 delete() 는 단순한 인터페이스를 갖는다.

~~~~
public interface EmployeeDao{
	public int insert(Employee emp);
	public int delete(Long id);    
}
~~~~

select는 필요한 기능에 따라 다양한 메서드가 존재할 수 있다. 예를 들어, PK를 이용한 검색과 조건을 이용한 검색이 필요할 경우 다음과 같은 메서드를 사용할 수 있다.

~~~~
public interface EmployeeDao{
	public Employee selectOne(Long id);
	public List<Employee> selectList(검색조건 타입 cond);
}
~~~~

검색 조건 타입을 어떻게 정의하느냐는 검색 조건과 사용하는 기술에 따라 달라진다.

~~~~
public jdbcEmployeeDao implements EmployeeDao{

	@Override
	public List<Employee> selectList(SearchCondition cond){
		if(cond.hasNoCond()){
			return jdbcTemplate.query(SELECT_ALL_QUERY, rowMapper);
		} else {
			JunctionCondition andCondition = new AndCondition();
			if (cond.hasEmpNumber())
				andCondition.add(new BooleanCondition("Employee_NUM = ?", cond.getEmpNumber()));
			if (cond.hasNameKeyword())
				andCondition.add(new BooleanCondition("NAME like ?", "%" + cond.getNameKeyword() + "%"));
			if (cond.hasFormJoinedDate())
				andCondition.add(new BooleanCondition("JOINED_DATE >= ?", cond.getFromJoinedDate()));
			if (cond.hasToJoinedDate())
				andCondition.add(new BooleanCondition("JOINED_DATE <= ?", cond.getToJoinedDate()));

			String query = "select * from EMPLOYEE";
			if (andCondition.hasConditions()){
				query += "where "+andCondition.getQuery();
			}

			return jdbcTemplate.query(query, andCondition.getParams().toArray(), rowMapper);
		}
	}
}
~~~~


조건에 따라 쿼리를 생성하기 위해 별도의 Condition 타입을 만들어 사용했는데 MyBatis를 사용한다면 동적 SQL을 사용할 수 있다.


> http://mybatis.github.io/mybatis-3/dynamic-sql.html <- Mybatis    http://querydsl.com/ <- QueryDSL 참조



##### DAO 인터페이스의 크기

DAO 인터페이스는 조회 기준이 되는 테이블마다 1개를 작성하는 것이 일반적이다.

만약 테이블이 2개인데 서로 조인되는 메서드가 있으면

* 두 DAO에서 읽어와 프로그램에서 객체를 조립한다.
* 주 테이블에 해당하는 DAO에 메서드를 추가한다.
* 조인 결과를 위한 별도 DAO 인터페이스를 작성한다.


첫번째 방법은

~~~~
Member member = memberDao.selectOne(id);
MemberDetail memberDetail = memberDetail.selectOne(id);
MemberDto dto = new MemberDto(member, memberDetail);
return dto;
~~~~


서비스 구현 클래스나 컨트롤러 클래스에서 위와 같은 방식으로 프로그램을 조인을 할 수 있을 것이다.

두번쨰 방법은
~~~~
public interface MemberDao{
	public MemberDto selectDto(Long id);
}

public class JdbcMemberDto implements MemberDao{
	@Override
	public MemberDto selectDto(long id){
		return jdbcTemplate.queryForObject("select * from Member m, Member_DETAIL d where m.id = ? and m.id = d.id", new RowMapper<MemberDto>(){....})
	}
}
~~~~

세 번째 방법은 조인 결과를 제공하는 별도 인터페이스를 작성하는 방법이다.

~~~~
public interface StatisticDao{
	public List<StatisticDto> selectForVisit(Date fromTime, Date toTime);
}
~~~~

> 세 가지 방법중 무엇이 좋다고 단정지을수는 없다.



#### 서비스의 구현

서비스는 사용자 기능을 정의한다. 일반적으로 서비스의 메서드는 트랜젝션 단위가 되므로, @Transactional 애노테이션이나 스키마 기반의 트랜젝션 설정을 이용해서 메서드가 트랜젝션 범위 내에서 실행되도록 한다.


##### 서비스의 크기

서비스 구현 클래스가 구현하는 메서드의 개수가 많아지면, 필요한 의존 객체를 참조하기 위한 필드 개수도 증가하게 된다. 또한, 서로 관련 없는 기능이 한 클래스에 구현되므로 코드를 복잡하게 만들 가능성이 높고 코드 길이도 증가하게 된다. 이는 전반적으로 코드를 관리하기 어렵게 만드는 경향이 있기 때문에, 한 인터페이스에 메서드를 몰아 넣기 보다는 다음과 같이 구분되는 기능별로 인터페이스를 분리하는 방법을 선호한다.

~~~~
public interface EmployeeRegistryService{
	public Long register(Employee emp);
}

public interface RetirementService{
	public void retier(Long empNumber);
}
~~~~


> 객체 지향의 주요 원칙중에 SOLID라 불리는 다섯 가지 원칙이 있다. 이 중 인터페이스의 크기에 대한 원칙으로 SRP(Single Responsibility Principle)와 ISP(Interface Segregation Principle)를 들 수 있는데, 이 두 원칙에 따르면 여러 메서드를 하나의 서비스 인터페이스에 두는 것 보다 각각의 구분되는 기능을 위한 인터페이스를 따로 작성하도록 제안하고 있다. (http://goo.gl/29JzHP  참조)



> 컨트롤러 -서비스 -DAO 로 구성되는 어플리케이션을 개발하다 보면, 서비세에 어떤 업무 로직이 포함되어 있지 않고 단순히 DAO의 메서드를 호출하고 끝나는 경우에도 구성일 일관되게 해야 한다는 규칙 때문에 서비스를 구현하는 경우가 있다. 코드 일관성을 유지한다는 측면에서 모든 경우에 서비스를 만들 수도 있겠지만, 반드시 서비스를 만들 필요는 없다.
