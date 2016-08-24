# TIL

### Spring

### Description
> 오늘 나는 무었을 하였는가?? 배운거에 대해서 적는거이지만 올라오지 않을때가 더 많은 곳.... 언젠가는 저 폴더들안에 내용이 꽉 차겠지....

### Start
* 일단 기본적으로 웹 개발자를 위한 Spring 4.0 프로그래밍(저자 최범균님)의 책을 기본으로 하겠다.

| 목록 | 프로젝트 |
|---|---|
| 00_maven | projectLayout |
| 01_DI | 01_Example
| | 02_Example_factory
| 02_Beanlife_cycle_and_scope | 01_Example
|  | 02_Example
| 03_Environment | 01_Environment
|  | 02_Profile
|  | 03_Message
| 04_PropertyEditor | 01_ExtendPoint
|  | 02_PropertyEditor
| 05_Aop | 01_Aop
| 06_MVC | 01_MVC
|  | 02_Validator
|  | 03_ETC
|  | 04_Setting
| 07_MVC_View | 01_View |
|  | 02_EtcView |
|  | 03_Locale |
| 08_MVC_Etc | 01_XmlJSON |
|  | 02_Upload |
|  | 03_WebSocket -미완료 |
| 09_MVC_Etc2 | 01_Spring |
| 10_Database - 미완료 | 
| 11_Transaction - 미완료 | 
| 12_ORM - 미완료 | 
| 13_JPA | Ex_1_JPA |
|  | Ex_2_JPA |
|  | Ex_3_JPA_Java |
|  | Ex_4_JPA_Query |
|  | Ex_5_JPA_Custom | 
| 14_WebApplication | 01_webApplication |
|  | 02_webApplication
| 15_Security - 미완료 | 
| 16_Etc | Mail |
|  |  Task
|  |  RestTemplate
| 17_Test | 01_test
|  | 02_mock |
| 18_Log | Log |


~~~~
pom.xml


<dependency>
<groupId>javax.servlet.jsp</groupId>
<artifactId>jsp-api</artifactId>
<version>2.2</version>
<scope>provided</scope>
</dependency>
<dependency>
<groupId>javax.servlet</groupId>
<artifactId>javax.servlet-api</artifactId>
<version>3.0.1</version>
<scope>provided</scope>
</dependency>
<dependency>
<groupId>javax.servlet</groupId>
<artifactId>jstl</artifactId>
<version>1.2</version>
<scope>runtime</scope>
</dependency>



//Springframework
<dependency>
<groupId>org.springframework</groupId>
<artifactId>spring-webmvc</artifactId>
<version>4.0.4.RELEASE</version>
</dependency>
<dependency>
<groupId>org.springframework</groupId>
<artifactId>spring-context</artifactId>
<version>4.2.4.RELEASE</version>
</dependency>
<dependency>
<groupId>org.springframework</groupId>
<artifactId>spring-aop</artifactId>
<version>4.2.4.RELEASE</version>
</dependency>
<dependency>
<groupId>org.aspectj</groupId>
<artifactId>aspectjweaver</artifactId>
<version>1.7.4</version>
</dependency>

//Validation
<dependency>
<groupId>javax.validation</groupId>
<artifactId>validation-api</artifactId>
<version>1.0.0.GA</version>
</dependency>
<dependency>
<groupId>org.hibernate</groupId>
<artifactId>hibernate-validator</artifactId>
<version>4.3.1.Final</version>
</dependency>


//Log
<dependency>
<groupId>log4j</groupId>
<artifactId>log4j</artifactId>
<version>1.2.12</version>
</dependency>


//Excel
<dependency>
<groupId>org.apache.poi</groupId>
<artifactId>poi</artifactId>
<version>3.9</version>
</dependency>



//PDF
<dependency>
<groupId>com.lowagie</groupId>
<artifactId>itext</artifactId>
<version>2.1.7</version>
<exclusions>
<exclusion>
<groupId>bouncycastle</groupId>
<artifactId>bcmail-jdk14</artifactId>
</exclusion>
<exclusion>
<groupId>bouncycastle</groupId>
<artifactId>bcprov-jdk14</artifactId>
</exclusion>
<exclusion>
<groupId>bouncycastle</groupId>
<artifactId>bctsp-jdk14</artifactId>
</exclusion>
</exclusions>
</dependency>


//파일 업로드
<dependency>
<groupId>commons-fileupload</groupId>
<artifactId>commons-fileupload</artifactId>
<version>1.3</version>
</dependency>
~~~~



