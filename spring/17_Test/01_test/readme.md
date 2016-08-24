### 스프링 테스트 

~~~~
    	<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-test</artifactId>
			<version>4.0.4.RELEASE</version>
		</dependency>
		<dependency>
			<groupId>junit</groupId>
			<artifactId>junit</artifactId>
			<version>4.11</version>
			<scope>test</scope>
		</dependency>
		<dependency>
			<groupId>org.hamcrest</groupId>
			<artifactId>hamcrest-library</artifactId>
			<version>1.3</version>
			<scope>test</scope>
		</dependency>
~~~~

테스트 관련 모듈은 spring-test, junit 는 필수이고 다양한 기능을 사용하고 싶다면 hamcrest-libaray의존도 추가한다.



기본 테스트

~~~~
package com.company;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import config.MvcConfig;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes={MvcConfig.class})
public class Test_1 {
	@Autowired
	private Calculator calculator;
	
	@Test
	public void sum(){
		assertThat(calculator.sum(1,2), equalTo(3L));
	}
}

~~~~



스프링의 테스트 지원 기능을 이용해서 컨테이너를 생성하고 빈 객체를 구하려면 다음과 같이 테스트 코드를 작성한다.

* SpringJUnit4ClassRunner를 테스트실행기로 지정
* @ContextConfiguration 애노테이션으로 설정 정보 지정
* 자동 주입 애노테이션을 이용해서 테스트에서 사용할 빈 객체 필드로 보관

스프링 MVC를 위한 설정을 이용해서 테스트 코드를 작성하려면, @WebAppConfiguration 애노테이션을 추가로 적용한다.

~~~~
@WebAppConfiguration
~~~~

@WebAppConfiguration 애노테이션을 사용하면, 웹을 위한 WebApplicatoonContext 타입의 컨테이너를 생성한다. 기본 경로는 @WebAppConfiguration("src/main/webapp")으로 되어 있다.

중첩 클래스에 사용 가능

~~~~
package com.company;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;


@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
public class Test_1 {
	@Autowired
	private Calculator calculator;
	
	@Test
	public void sum(){
		assertThat(calculator.sum(1,2), equalTo(3L));
	}
	
	@Configuration
	public static class Config{
		@Bean
		public Calculator calculator3(){
			return new Calculator();
		}
	}
}


~~~~



중복된 설정은 묶을수 있다.
~~~~
package com.company;


import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;

@ContextConfiguration
@WebAppConfiguration
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface Test_4CommonCode {
}
~~~~

@Test_4CommonCode 애노테이션은 앞서 중복해서 존재했던 스프링 테스트 설정을 적용한다.
~~~~
package com.company;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@Test_4CommonCode
public class Test_5 {
	@Autowired
	private Calculator calculator;
	
	@Test
	public void sum(){
		assertThat(calculator.sum(1,2), equalTo(3L));
	}
}
~~~~


스프링 설정 중복을 제거하는 다른 방법은 상속이다.
~~~~
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration
@WebAppConfiguration
public abstract class Test_6Abstract {
}
~~~~


~~~~

package com.company;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

public class Test_7 extends Test_6Abstract {
	@Autowired
	private Calculator calculator;
	
	@Test
	public void sum(){
		assertThat(calculator.sum(1,2), equalTo(3L));
	}
}

~~~~


상위 클래스의 설정목록(@ContextConfiguration 애노테이션의 value/locations속성이나 classes속성) 을 사용하지 않으려면 inheritLocations 속성을 false로 지정한다.



#### 프로필 선택

~~~~
@ActionProfiles({"dev", "local"})
~~~~
@ActiveProfiles 애노테이션도 @ContextConfiguration 애노테이션과 마찬가지로 상위 클래스의 설정을 상속받게 되며, 하위 클래스에서 사용할 프로필을 추가할 수 있다.

#### 컨텍스트 리로딩

JUnit은 각 테스트 메서드를 실행할 때마다 테스트 클래스의 객체를 생성한다.

만약 메서드가 3개가 있으면 스프링컨텍스트도 3개 생성될 거라 예상하지만 실제로는 하나가 생성된다. 통합테스트를 진행하다 보면 스프링 컨텍스트를 초기화 하는 시간이 길어지기 때문에, 테스트 메서드마다 스프링 컨텍스트를 생성하면 그 만큼 테스트 실행시간이 증가하게 된다. 이런 이유로 SpringJUnit4ClassRunner는 스프링 컨텍스트를 한번만 생성하고 각 테스트 메서드마다 스프링 컨텍스트를 재사용한다.

컨텍스트 리로딩 하려면 @DirtiesContext 애노테이션을 사용한다.
~~~~
package com.company;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
public class Test_8 {
	@Autowired
	private Calculator calculator;
	
	@DirtiesContext
	@Test
	public void sum(){
		assertThat(calculator.sum(1,2), equalTo(3L));
	}
	
	@Test
	public void sum2(){
		assertThat(calculator.sum(2,2), equalTo(4L));
	}
	
	@Test
	public void sum3(){
		assertThat(calculator.sum(4,2), equalTo(6L));
	}
}
~~~~

메서드 실행 후, 다음 테스트 실행 전에 컨텍스트 초기화한다.

각 테스트 마다 초기화 하고 싶다면
~~~~
@DirtiesContext(classMode = ClassMode.AFTER_EACH_TEST_METHOD)
public class Test{
	....
}
~~~~

라고 하면 된다.

#### 테스트 코드와 트랜젝션 처리 지정

~~~~
@TransactionConfiguration
@Transactional
public class Test_9DB {
	@Autowired
	private MemberDAO memberDAO;
	
	@Test
	public void count(){
		assertThat(memberDAO.count(), equalTo(22));
	}
	
	@Test
	public void insert(){
		int seq = memberDAO.insert();
		
		assertThat(seq, greaterThan(1));
	}
}
~~~~
@TransactionConfiguration, @Transactional 를 추가해준다.

@TransactionConfiguration 애노테이션은 PlatformTransactionManager를 이용해서 트랜젝션을 처리한다. 따라서 최소한 한개의 PlatformTransactionManager 가 스프링설정에 존재해야 한다.
TransactionConfiguration(transactionManager="txManager") 이름을 지정할 수도 있다.

특정 메서드에만 롤백하고 싶으면 

~~~~
@TransactionConfiguration(defaultRollback=false)
@Transactional
public class Test_9DB {
	@Autowired
	private MemberDAO memberDAO;
	
	@Rollback(true)
	@Test
	public void count(){
		assertThat(memberDAO.count(), equalTo(22));
	}
	....    
}
~~~~

이런식으로 defaultRollback = false와 특정 메서드에 Rollback애노테이션을 주면 된다.

