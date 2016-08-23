### 작업 실행과 스케줄링

스프링은 작업 실행 및 작업 스케줄링을 위한 인터페이스와 구현 클래스를 제공하고 있으며, 이를 통해 간단한 설정만으로 스케쥴링, 비동기 처리 등을 할수 있게 해주고 있다.

~~~~
<dependency>
	<groupId>org.springframework</groupId>
	<artifactId>spring-context-support</artifactId>
	<version>4.0.4.RELEASE</version>
</dependency>
~~~~

#### &lt;task:executor&gt;를 이용한 작업 실행

작업 실행과 관련된 핵심 인터페이스는 TaskExecutor이다. TaskExecutor 인터페이스및 하위 인터페이스는 작업 실행과 관련된 인터페이스를 제공하고 있다.

* <task:executor> 태그를 이용한 TaskExecutor 빈 설정
* TaskExecutor 빈 객체에 Runnable 구현 객체를 전달해서 작업 실행

~~~~
<?xml version="1.0" encoding="UTF-8"?>
<beans:beans xmlns="http://www.springframework.org/schema/mvc"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:beans="http://www.springframework.org/schema/beans"
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:task="http://www.springframework.org/schema/task"
	xsi:schemaLocation="http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc.xsd
		http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd
		http://www.springframework.org/schema/task http://www.springframework.org/schema/task/spring-task-3.1.xsd">
	
	<annotation-driven />
	<resources mapping="/resources/**" location="/resources/" />
	<context:component-scan base-package="com.company"/>
	
	<beans:bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
		<beans:property name="prefix" value="/WEB-INF/views/" /> <!-- mapping 앞에 들어갈 내용 -->
		<beans:property name="suffix" value=".jsp" />  <!-- mapping 뒤에 들어갈 내용 -->
	</beans:bean>
	
	<task:executor id="executor" keep-alive="10" pool-size="10-20" queue-capacity="10" rejection-policy="ABORT" />
</beans:beans>

~~~~

| 속성 | 설명 |
|---|---|
|id|생성할 빈의 식별 값을 지정한다.|
|pool-size|쓰레드 풀의 개수를 지정한다. '최소크기-최대크기' 으로 지정하거나 '개수' 를 지정한다. 기본값은 1-Integer.MAX_VALUE이다.|
|queue-capacity|풀의쓰레드가 모두 작업을 실행중인 경우 큐에서 대기할 수 있는 작업의 개수를 지정한다. 기본값은 Integer.MAX_VALUE이다.|
|keep-alive|풀에 있는 쓰레드의 최대 유휴 시간을 지정한다. 이 시간 동안 새로운 작업을 실행 하지 않은 쓰레드는 풀에서 제거된다. 단위는 초이다.|
|rejection-policy|큐가 다 차서 더 이상 작업을 받을 수 없을 때 작업을 어떻게 처리할지 결정한다.        * ABORT : 작업을 거부하고 익셉션을 발생시킨다.   * CALLER_RUNS: 호출한 쓰레드를 이용해서 실행한다.* DISCART: 작업을 실행하지 않고 무시한다.   * DISCART_OLDEST : 큐의 헤드에서 하나를 제거하고 작업을 추가한다.   * 기본값은 ABORT이다.|


<task:executor> 태그를 사용하며 내부적으로 java.util.concurrent.ThreadPoolExecutor 를 이용해서 작업을 실행하게 되는데, ThreadPoolExecutor는 다음과 같은 규칙을 이용해서 풀의 크기를 관리한다.

* 풀에 최소 크기보다 작은 개수의 쓰레드가 존재할 경우, 쓰레드를 새롭게 생성한다.
* 풀에 최소 크기와 같거나 많은 개수의 쓰레드가 존재하고 큐에 여분이 남아 있는 경우, 작업을 큐에 저장한다.
* 작업을 큐에 보관할 수 없을 경우, 풀에 최대 크기보다 작은 개수의 쓰레드가 존재할 경우 쓰레드를 새롭게 생성한다. 그렇지 않을 경우 작업을 거부한다.

위 규칙에 따르면 큐의 개수가 Integer.MAX_VALUE인 경우, 큐에 객체를 저장하는 과정에서 메모리 부족 현상이 발생할 수도 있다. 또한, 쓰레드의 최대 개수가 Integer.MAX_VALUE인 경우 불필요하게 많은 쓰레드가 생성되어 오히려 전반적인 처리속도가 저하될 수 있다.



#### TaskExecutor와 AnyncTaskExecutor 인터페이스를 이용한 작업 실행

ThreadPoolTaskExecutor 클래스가 구현하고 있는 TaskExecutor 인터페이스와 AsyncTaskExecutor 인터페이스는 각각 작업을 실행하는데 필요한 메서드를 정의하고 있다.

* void execute(Runnable task): task를 실행한다.
* Future<?> submit(Runnable task) : task를 실행한다. Future를 통해 작업이 완료될 때 처리 결과를 확인할 수 있다.
* Future<T> submit(Callable<T> task) : task를 실행한다. Future를 통해 작업이 완료된 이후 처리 결과 및 리턴 값을 확인할 수 있다.
* ListenableFuture<?> submitListenable(Runnable task) : task를 실행한다. ListenableFuter에 ListenableFutureCallback을 등록해서 작업이 완료될 때 콜백으로 결과를 받을 수 있다.
* ListenableFuture<T> submitListenable(Callable<T> task) : task를 실행한다. ListenableFuter에 ListenableFutureCallback을 등록해서 작업이 완료될 때 콜백으로 결과를 받을 수 있다.

ThreadPoolTaskExecutor 클래스의 execute() 메서드와 submit() 메서드는 비동기로 작업을 실행한다.

~~~~
@Autowired
	private ThreadPoolTaskExecutor taskExecutor;
	
	
	public void process(final Work work){
		Future<?> future = taskExecutor.submit(new Runnable() {
			@Override
			public void run() {
				work.doWork();
			}
		});
		try{
			future.get();//작업이 끝날때 까지 대기
		}catch(Exception e){
			
		}
		return;
	}

~~~~

submitListenable() 메서드를 사용하면 org.springframework.util.concurrent.ListenableFuture 타입 객체를 리턴하는데, 이 타입 및 ListenableFutureCallback 인터페이스는 다음과 같이 정의되어 있다.

~~~~
public interface ListenableFuture<T> extends Future<T>{
	void addCallback(ListenableFutureCallback<? super T> callback);
}
public interface ListenableFutureCallback<T> {
	void onSuccess(T result);
	void onFailure(Throwable t);
}
~~~~

ListenableFuture의 addCallback() 메서드는 콜백으로 사용할 콜백 객체를 전달받으며, 작업 실행이 성공하면 콜백 객체의 onSuccess() 메서드를, 익셉션이 발생하면 onFailure() 메서를 실행해서 콜백객체에 전달한다.



#### task:scheduler를 이용한 스케줄러 사용

org.springframework.scheduling.TaskScheduler 인터페이스는 지정된 시간 또는 반복적으로 작업을 실행하기 위한 메서드를 제공하고 있다. 이 인터페이스를 구현한 빈 객체를 생성할 때 <task:scheduler> 태그를 이용한다.

~~~~
<task:scheduler id="jobScheduler" pool-size="10" />
~~~~
pool-size를 지정하지 않을 경우 쓰레드 풀의 기본값은 1이다.
<task:scheduler> 태그가 생성하는 빈 객체는 ThreadPoolTaskScheduler 타입이다.

TaskScheduler 인터페이스가 제공하는 메서드
> 모든 메서드의 리턴 타입은 ScheduledFuture이며, period 파라미터와 delay 파라미터의 단위는 1/1000초이다.

* schedule(Runnable task, Trigger trigger)
* > Trigger가 지정한 시간에 작업을 실행한다.
* schedule(Runnable task, Date startTime)
* > startTime에 작업을 한 번 실행한다.
* scheduleAtFixedRate(Runnable task, Date startTime, long period)
* > startTime부터 period 시간마다 작업을 실행한다.
* scheduleAtFixedRate(Runnable task, long period)
* > 가능한 빨리 작업을 실행하고, 이후 period 시간마다 작업을 실행한다.
* scheduleWithFixedDelay(Runnable task, Date startTime, long delay)
* > startTime부터 작업을 delay 시간 간격으로 작업을 실행한다.
* scheduleWithFixedDelay(Runnable task, long delay)
* > 가능한 빨리 작업을 실행하고, 이후 delay 시간 간격으로 작업을 실행한다.

~~~~
xml
<task:scheduler id="jobScheduler" pool-size="10" />

java
ThreadPoolTaskScheduler scheduler = ctx.getBean("", ThreadPoolTaskScheduler.class);
Calendar calendar = Calendar.getInstance();
calendar.add(Calendar.SECOND, 5);
scheduler.schedule(cacheInitializerRunner, calendar.getTime());
scheduler.scheduleAtFixedRate(statusMonitorRunner, 1000);
~~~~


#### schedule(Runnable task, Trigger trigger) 메서드의 두 번째 파라미터의 타입은 org.springframework.scheduling.Trigger 인터페이스인데, Trigger 인터페이스이 작업의 다음 실행 시간을 결정해주는 역활을 제공한다.

* org.springframework.scheduling.support.CronTrigger
* org.springframework.scheduling.support.PeriodicTrigger

~~~~
CronTrigger trigger = new CronTrigger("0 30 0 * * *");
scheduler.scheduler(logCtrl, trigger);
~~~~

crop 표현식

* *: 전체값을 의미
* 특정값 : 해당 시간을 정확하게 지정
* 값1-값2 : 값 1부터 값2사이를 표현
* 값1, 값2, 값3 : 콤마로 구분하여 특정 값 목록 지정
* 범위/숫자 : 범위에 속한 값중 숫자 간격으로 값 목록 지정 (0-23/2), (*/2)

허용되는 값 범위

* 초 : 0~59
* 분 : 0~59
* 시 : 0~23
* 일 : 1~31
* 월 : 1~12
* 요일 : 0-7(0또는 7은 일요일)

ex)

* 0 0 * * * * : 매일 매시 정각
* */10 * * * * * : 0, 10 , 20, 30 , 40, 50 초
* 0 0 8-10 * * * : 매일 8, 9, 10시
* 0 0/30 8-10 * * * : 매일 8, 8시30분, 9시, 9시 30분, 10시
* 0 0 9-18 * * 1-5 : 매주 월~금 9시부터 오후 6시까지 매시

xml
~~~~
<task:scheduled-tasks scheduler="scheduler">
	<task:scheduled ref="logCollector" method="collect" cron="0 30 0 0 0 0" />
</task:scheduled-tasks>
~~~~

* cron : cron 표현식
* fixed-delay : 지정된 시간 간격으로 작업 실행
* fixed-rate : 지정한 시간 주기로 작업 실행
* initial-delay : 지정한 시간 이후에 실행 시작

#### 애노테이션을 이용한 작업 실행 설정

@Scheduled 애노테이션과 @Async 애노테이션을 이용

~~~~
<task:scheduler id="jobScheduler" pool-size="10" />
<task:annotation-driven scheduler="jobScheduler" />
~~~~

~~~~
public class Scheduler{
	@Resource(name="schedulerService")
	private SchedulerService schedulerService;
	
	//certification delete  회원인증 매일 아침 6시 삭제
	@Scheduled(cron = "0 0 6 * * ?")
	public void cron(){
		SchedulerUtils.setWriterLoggerDate("certification");
		schedulerService.certificationAllDelete();
	}
}	

~~~~

| 속성 | 타입 | 설명 |
|---|---|---|
|cron|String|cron표현식을설정|
|zone|String|cron표현식의 시간을 구할때 사용할 시간대를 지정. 지정하지 않으면 기본 시간대|
|fixedRate|String|지정한 시간 주기로 실행|
|fixedDelay|String|지정한 시간 간격으로 실행|
|initialDelay|String|지정한 시간 이후에 실행시작|



#### @Async 애노테이션을 이용한 비동기 실행

@Async 애노테이션은 지정한 메서드를 비동기 실행으로 변환해준다.

~~~~
import org.springframework.scheduling.annotation.Async;

public class AsyncTest{
	@Async
	public void test(){
		...
	}
}

~~~~

##### task:annotation-driven 의 프록시 생성 방식

task:annotation-driven 태그는 @Async 애노테이션이 적용된 빈 객체를 비동기로 처리하기 위해 프록시 객체를 생성하는데, 이 프록시 객체를 클래스를 기준으로 생성하고 싶다면 다음과 같이 proxy-target-class 속성 값을 true로 지정하면 된다.

~~~~
<task:annotation-driven executor="executor" scheduler" proxy-target-class="true" />
~~~~




#### @EnableScheduling 애노테이션을 이용한 스케줄러 실행

자바 기반 설정을 사용할 경우, @EnableScheduling 애노테이션 이용하면 @Scheduled 애노테이션이 적용된 빈 객체를 스케줄링해서 실행한다.

~~~~
package config;

import java.util.concurrent.ThreadPoolExecutor;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;

@Configuration
@EnableScheduling
public class TaskConfig {
	@Bean
	public ThreadPoolTaskScheduler taskScheduler(){
		ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
		scheduler.setPoolSize(4);
		scheduler.setRejectedExecutionHandler(new ThreadPoolExecutor.AbortPolicy());
		return scheduler;
	}
}
~~~~

작업 스케줄링을 등록하고 싶다면, 다음과 같이 SchedulingConfigurer 인터페이스를 상속 받은 @Configuration 설정 클래스를 작성하면 된다.

~~~~
package config;

import java.util.concurrent.ThreadPoolExecutor;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.SchedulingConfigurer;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;

@Configuration
@EnableScheduling
public class TaskConfig2 implements SchedulingConfigurer {
	@Bean
	public ThreadPoolTaskScheduler taskScheduler(){
		ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
		scheduler.setPoolSize(4);
		scheduler.setRejectedExecutionHandler(new ThreadPoolExecutor.AbortPolicy());
		return scheduler;
	}

	@Override
	public void configureTasks(ScheduledTaskRegistrar taskRegistrar) {
		taskRegistrar.addCronTask(new Runnable() {
			
			@Override
			public void run() {
				System.out.println("dddd");
			}
		}, "*/5 * * * * *");
	}
}
~~~~


SchedulingConfigurer 인터페이스를 상속받은 클래스는 configurerTasks() 메서드에서 스케줄러로 실행할 작업을 등록할 수 있다. configurerTask() 메서드의 ScheduledTaskRegistrar 타입 파라미터는 스케줄링할 작업을 등록할 때 사용되며, 작업 등록을 위해 다음의 메서드를 제공하고 있따.

* addTriggerTask(Runnable task, Trigger trigger)
* addTriggerTask(TriggerTask task)
* addCronTask(Runnable task, String expression)
* addCronTask(CronTask task)
* addFixedRateTask(Runnable task, long period)
* addFixedRateTask(IntervalTask task)
* addFixedDelayTask(Runnable task, long delay)
* addFixedDelayTask(IntervalTask task)

메서드 이름만 보면 어떤 주기로 실행될 작업을 등록하는지 이해가 될 것이다. TriggerTask, CronTask, IntervalTask 클래스는 작업 등록할 때 필요한 정보를 한 객체에 담아 제공할 때 사용되는 클래스로서, 각각 다음의 생성자를 제공하고 있다. 이 클래스 모두 org.springframework.scheduling.config 패키지에 포함되어 있다.

* TriggerTask(Runnable runnable, Trigger trigger)
* CronTask(Runnable runnable, String expression)
* CronTask(Runnable runnable, CronTrigger cronTrigger)
* IntervalTask(Runnable runnable, long interval, long initialDelay)
* IntervalTask(Runnable runnable, long interval)

##### @EnableAsync 애노테이션을 이용한 @Async 비동기 실행

@Configuration설정 클래스에 @EnableAsync 애노테이션을 사용하면 @Async가 붙은 메서드를 비동기로 처리해준다.

~~~~
import org.springframework.scheduling.annotation.EnableAsync;

@Configuration
@EnableAsync
public class TaskConfig{
	@Bean
	public MessageSender messageSender(){
		return new MessageSender();
	}
}
~~~~


만약 비동기로 실행할 때 사용할 실행기를 지정하고 싶다면, 다음과 같이 @Configuration클래스에서 AsyncConfigurer 인터페이스를 상속받아 getAsync Executor() 메서드를 재정의 해주면 된다.

~~~~
@Configuration
@EnableAsync
public class TaskConfig implements AsyncConfigurer{
	@Bean
	public ThreadPoolTaskScheduler taskScheduler(){
		ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
		scheduler.setPoolSize(4);
		scheduler.setRejectedExecutionHandler(new ThreadPoolExecutor.AbortPolicy());
		return scheduler;
	}


	@Bean
	public MessageSender messageSender(){
		return new MessageSender();
	}


	@Override
	public Executor getAsyncExecutor(){
		return taskScheduler(); // 비동기로 실행할 때 사용할 Executor 리턴
	}

}
~~~~



