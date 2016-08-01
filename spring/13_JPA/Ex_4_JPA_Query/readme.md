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
@Query("from Employee e where e.birthYear < : year")
public List<Employee> findEmployeeBornBefore(@Param("year") int year, Sort sort);

@Query("from Employee e where e.birthYear < :year order by e.birthYear")
public Page<Employee> findEmployeeBornBefore(@Param("year") int year, Pageable pageable);
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