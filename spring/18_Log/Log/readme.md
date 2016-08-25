### JCL과 Log4j 사용 설정

스프링 프레임워크는 JCL(Java Commons Logging) 을 이용해서 로그를 남긴다. 스프링이 JCL을 이용해서 생성하는 로그 메시지를 Log4j를 이용해서 남기고 싶다면 다음 의존을 추가한다.

~~~~
<dependency>
			<groupId>log4j</groupId>
			<artifactId>log4j</artifactId>
			<version>1.2.12</version>
		</dependency>
~~~~

log4j.xml파일 추가

~~~~
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE log4j:configuration SYSTEM "log4j.dtd">
<log4j:configuration xmlns:log4j="http://jakarta.apache.org/log4j/">
	<appender name="console" class="org.apache.log4j.ConsoleAppender">
		<layout class="org.apache.log4j.PatternLayout">
			<param name="ConversionPattern" value="[%t] %-5p %c:%M -%m%n" />
		</layout>
	</appender>
	<root>
		<priority value="DEBUG" />
		<appender-ref ref="console" />
	</root>
</log4j:configuration>
~~~~


### JCL 대신 SLF4J 사용

SLF4J 가 나오기 전까지만 해도 많은 프레임워크나 라이브러리가 JCL을 이용해서 로그를 남기는 경우가 많았지만 SLF4J가 이제 많이 쓰인다.

의존
~~~~
<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-core</artifactId>
			<version>4.0.4.RELEASE</version>
			<exclusions>
				<exclusion>
		        	<groupId>commons-logging</groupId>
					<artifactId>commons-loggin</artifactId>
		        </exclusion>
			</exclusions>
		</dependency>
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>jcl-over-slf4j</artifactId>
			<version>1.7.7</version>
		</dependency>
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-log4j12</artifactId>
			<version>1.7.7</version>
		</dependency>

~~~~


spring-core 모듈의 exclusion설정부분은 의존 모듈중 사용하지 않을 의존 모듈을 설정할때 사용되며 spring-core모듈이 사용하는 모듈중에서 JCL(commons-loggin) 모듈을 사용하지 않는다고 설정하고 있다.

로그 메시지를 기록할 때 Log4j 대신 사용되는 로깅 모듈로 Logback를 들 수 있는데 SLF4J를 사용하면서 Log4j 대신 Logback를 사용하고 싶다면 다음과 같이 설정한다.
~~~~
<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-core</artifactId>
			<version>4.0.4.RELEASE</version>
			<exclusions>
				<exclusion>
		        	<groupId>commons-logging</groupId>
					<artifactId>commons-loggin</artifactId>
		        </exclusion>
			</exclusions>
		</dependency>
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>jcl-over-slf4j</artifactId>
			<version>1.7.7</version>
		</dependency>
		<dependency>
			<groupId>ch.qos.logback</groupId>
			<artifactId>logback-classic</artifactId>
			<version>1.1.2</version>
		</dependency>
~~~~



