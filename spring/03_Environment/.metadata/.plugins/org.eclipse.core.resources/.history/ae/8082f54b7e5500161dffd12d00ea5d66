## 프로필을 이용한 설정
보통 로컬 개발 환경, 통합 테스트환경, 실제운영환경은 동일하지 않다. 데이터베이스 IP정보, 디렉토리 경로, 외부서비스 URL등이 동일하지 않다. 단순히 DB IP/사용자 정보만 바뀌는 경우라면, 프로퍼티 파일에 DB 정보를기록하고 &lt;context:property-placeholder&gt;를 사용하면 될 것이다. 이 경우 사용할 DB 정보가 변경되면 프로퍼티 파일에서 값을 알맞게 변경해주면 된다. 하지만, 환경이 바뀔때마다 프로퍼티 파일을 수정하는 방법은 좋아보이지 않는다.

더 나은 방법은 각 환경에 맞는 설정 정보를 따로 만들고, 환경에 따라 알맞은 설정 정보를 사용하는 것이다. 스프링의 프로필(profile)은 정확하게 이를 위한 기능이다. 스프링은 설정 정보에서 프로필 이름을 설정할 수 있도록 하고 있으며, 컨테이너를 생성할 때 프로필을 선택할 수 있도록 하고 있다. 즉, 환경에 따라 설정 정보를 만들어서 각각 별도의 프로필 이름을 부여하고 환경에 알맞은 프로필을 선택함으로써, 환경에 따라 다른 설정을 사용할 수 있게 된다.


### XML 설정에서 프로필 사용하기

XML 설정에서 프로필을 사용하려면, &lt;beans&gt; 태그의 profile 속성을 이용해서 프로필 이름을 지정해주어야 한다. 예를 들어, 다음과 같이 테스트 환경과 실제 제품 환경에 대한 DB 연결 설정을 별도 파일로 작성하고, 각각의 파일에 profile 속성값을 준다.

~~~~
<beans xmlns="http://www ....." profile="dev">

....
</beans>
~~~~

~~~~
<beans xmlns="http://www ....." profile="prod">

....
</beans>
~~~~

위 설정을 보면 각 설정 파일이 같은 이름의 빈 객체를 성정하고 있는 것을 할 수 있고, <beans> 태그의 profile 속성은 각각 dev와 prod를 값으로 갖고 있다.

XML 파일이 profile 속성을 갖고 있을 경우, 그 파일은 해당 프로필을 선택한 경우에만 사용된다. 특정 프로필을 선택하려면 ConfigurableEnvironment에 정의 되어 있는 setActiveProfiles() 메서드를 사용하면 된다.

~~~~
GenericXmlApplicationContext context = new GenericXmlApplicationContext();
context.getEnvironment().setActiveProfiles("dev");
context.load("classpath:/confprofile/app-config.xml",
		"classpath:/confprofile/datasource-dev.xml",
		"classpath:/confprofile/datasource-prod.xml"
);
context.refresh();
~~~~

위 코드는 setActiveProfiles() 메서드에 "dev"를 값으로 전달했으므로 profile 속성의 값으로 "dev"를 갖는 XML 설정이 사용된다. 따라서, 위 설정에서는 프로필 값이 "dev"인 datasource-dev.xml 파일에 정의된 설정을 사용하게 된다.

두 개 이상의 프로필을 활성화하고 싶다면 다음과 같이 각 프로필 이름을 메서드에 파라미터로 전달하면 된다.

~~~~
context.getEnvironment().setActiveProfiles("dev", "mysql");
~~~~

프로필을 선택하는 또 다른 방법은 spring.profiles.active 시스템 프로퍼티에 사용할 프로필 값을 지정해주는 것이다. 두 개이상인 경우 사용할 프로필을 콤마로 구분해서 설정하면 된다. (spring.profiles.active 환경 변수에 프로필을 지정해도 된다.)

~~~~
java -Dspring.profiles.active=prod,oracle com.company.Main
~~~~


#### &lt;beans&gt; 태그 중첩과 프로필


XML 설정을 사용할 경우 다음과 같이 프로필에 해당하는 &lt;beans&gt; 태그를 중첩해서 정의할 수 있다.

~~~~
<?xml version="1.0" encoding="UTF-8"?>

<beans ...>
	<beans profile="dev">
		<bean>...</bean>
	</beans>
	<beans profile="prod">
		<bean>...</bean>
	</beans>
</beans>
~~~~


&lt;beans&gt; 태그를 중첩해서 프로필을 설정하면 같은 목적을 위해 사용되는 빈 설정을 XML 파일에 모을 수 있으므로, 여러 파일에 정보가 흩어져 있는 것에 비해 설정 정보 관리가 쉬워진다. 참고로 중첩 &lt;beans&gt; 태그 이후에는 &lt;bean&gt; 설정을 추가할 수 없고, 위 코드처럼 중첩 &lt;beans&gt; 태그 이전 위치에 &lt;bean&gt; 설정이 올 수 있다.


### 자바 @Configuration 설정에서 프로필 사용하기

@Configuration 애노테이션을 이용한 설정에서 프로필을 지정하려면 @Profile 애노테이션을 사용한다.

~~~~
import org.springframwork.context.annotation.Profile;

@Configuration
@Profile("prod")
public class DataSourceProdConfig{

	@Bean
	public JndiConnectionProvider connProvider(){
		JndiConnectionProvider connectionProvider = new JndiConnectionProvider();
		connectionProvider.setJndiName("java:/comp/env/jdbc/db");
		return connectionProvider;
	}
}
~~~~

> 활성화하는 방법은 동일하게 setActiveProfiles() 메서드를 이용하거나 spring.profiles.active 시스템 프로퍼티에 값을 설정하는 것이다.

~~~~
AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext();
context.getEnvironment().setActiveProfiles("dev");
context.register(ApplicationConfig.class, DataSourceDevConfig.class, DataSourceProdConfig.class);
context.refresh();
~~~~

#### 중첩 @Configuration을 이용한 프로필 설정

XML에서 중첩 &lt;beans&gt; 태그를 사용해서 한 XML 파일에 프로필 설정을 모울수 있는 것처럼, @Configuration기반 자바 설정에서도 중첩 클래스를 이용해서 프로필 설정을 한 곳으로 모울 수 있다.

~~~~
@Configuration
public class ApplicationContextConfig{

	@Bean
	public static PropertySourcesPlaceholderConfigurer properties(){
		...
	}

	@Value("${calc.batchSize}")
	private int batchSize;

	@Autowired
	private ConnectionProvider connProvider;

	@Bean
	public ChargeCalculator chargeCalculator(){
		ChargeCalculator cal = new ChargeCalculator();
		cal.setBatchSize(batchSize);
		cal.setConnectionProvider(connProvider);
		return cal;
	}

	@Configuration
	@Profile("dev")
	public static class DataSourceDev{
		@Value("${db.driver}")
		private String driver;
		@Value("${db.jdbcUrl}")
		private String jdbcUrl
		....

		@Bean
		public ConnectionProvider connProvider(){
			JdbcConnectionProvider provider = new JdbcConnectionProvider();
			provider.setDriver(driver);
			....
			return provider;
		}
	}

	@Configuration
	@Profile("prod")
	public static class DataSourceProd{
		@Value("${db.driver}")
		private String driver;
		@Value("${db.jdbcUrl}")
		private String jdbcUrl
		....

		@Bean
		public ConnectionProvider connProvider(){
			JndiConnectionProvider provider = new JndiConnectionProvider;
			provider.setJndiName("java:/comp/env/jdbc/db");
			....
			return provider;
		}
	}
}
~~~~

#### 다수 프로필 설정

스프링 설정은 두 개 이상의 프로필 이름을 가질 수 있다. 아래 코드는 prod와 QA 프로필을 갖는 설정 예를 보여주고 있다. 이 경우 prod 프로필을 활성화 할 때와 QA프로필을 활성화 할 때 모두 해당 XML이 사용된다.

~~~~
<beans xmlns=....
	profile="prod,QA">

....
</beans>
~~~~
> @Configuration 애노테이션을 사용하는 경우에도 @Profile의 값에 콤파로 구분된 프로필 이름 목록을 지정할 수 있다.

~~~~
@Configuration
@Profile("prod,QA")
public class DataSourceJndiConfig{
.....
}
~~~~

프로필 값을 지정할 때 다음 코드처럼 느낌표(!)를 사용 할 수도 있다.
~~~~
<beans xmlns=....
	profile="!prod">

....
</beans>
~~~~

"!prod" 값은 "prod" 프로필이 활성화되지 않을 경우 사용된다는 것을 의미한다. ! 형식은 특정 프로필이 사용되지 않을 때 기본으로 사용될 설정을 지정하는 용도로 주로 사용된다.

> 자바의 빌드 도구로 많이 사용되고 있는 메이븐이나 그래들은 스프링의 프로필과 유사하게 환경에 따라 설정/소스 등을 다르게 사용할 수 있는 기능을 제공하고 있다. 차이가 있다면, 이들 빌드 도구는 빌드 과정에서 프로필을 사용하는데 반해 스프링은 런타임에 프로필을 사용한다는 점이다.