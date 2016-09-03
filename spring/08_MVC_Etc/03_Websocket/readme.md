### 웹 소켓 서버 구현 지원

HTML5의 주요 API중 하나인 웹소켓(WebSocket)은 HTTP 프로토콜을 기반으로 웹 브라우저와 웹 서버 간 양 방향 통신을 지원하기 위한표준이다. 웹 소켓을 사용하면 마치 소켓을 사용하는 것처럼 클라이언트와 서버가 메시지를 자유롭게 주고 받을 수 있다.이런 이유로 실시간 알림, 채팅, 웹 기반의 실시간 협업 도구와 같이클라이언트와 서버 간의 메시지를 빈번하게 주고 받는 웹 어플리케이션을 개발할 때 웹 소켓을 적용하는 사례가 늘고 있다.

자바의 웹 소켓 표준인 JSR-356 표준에 맞춰 웹 소켓 서버 기능을 구현할 경우 스프링의 DispatcherServlet 의 연동이나 스프링 빈 객체를 사용하기가 매우 번거롭다. 스프링은 이런 번거로움을 줄여주기 위한 기반 클래스를 제공하고 있으며, 이를 통해 컨트롤러를 구현하는 것과 비슷한 방식으로 서버를 구현할 수 있게 된다.


메이븐 의존 설정

~~~~
<dependency>
	<groupId>org.springframework</groupId>
	<artifactId>spring-websocket</artifactId>
	<version>4.0.4.RELEASE</version>
</dependency>
~~~~


#### WebSocketHandler를 이용한 웹 소켓 서버 구현

스프링 웹 소켓 기능은 스프링 MVC를 지원하기 때문에, 스프링 MVC환경에서 간단한 설정만으로 웹소켓 서버 프로그램을 구현할 수 있다. 스프링 웹소켓을 이용해서 웹 소켓 서버를 구현하려면 다음순서대로 하면 된다.

* WebSocketHandler 인터페이스 구현
* &lt;websocket:handlers&gt; 또는 @EnableWebSocket 애노테이션을 이용해서 앞서 구현한 WebSocketHandler 구현 객체를 웹 소켓 엔드포인트로 등록한다.

먼저 할 작업은 WebSocketHandler 인터페이스를 구현하는것이다. 스프링 웹소켓을 이용해서 웹 소켓서버를 구현할 때 개발자가 직접 구현하는 부분은 이것 뿐이다.
스프링 웹 소켓 모듈은 웹소켓 클라이언트가 연결되거나 데이터를 보내거나 연결을 끊는 경우 WebSocketHandler에 관련 데이터를 전달한다. 예를 들어, 웹 소켓 클라이언트가 특정 엔드포인트로 연결하면, 웹 소켓 모듈은 엔드포인트에 매핑된 WebSocketHandler의 afterConnectionEstablished() 메서드를 호출한다. 비슷하게 웹소켓 클라이언트가 데이터를 전송하면 WebSocketHandler의 handleMessage() 를 호출해서 클라이언트 전송한 데이터를 전달한다.

~~~~
package com.company.ex1;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class EchoHandler extends TextWebSocketHandler {
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.printf("%s 연결 됨\n",session.getId());
	}
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		System.out.printf("%s로 부터 [%s] 받음", session.getId(), message.getPayload());
		session.sendMessage(new TextMessage("echo: "+message.getPayload()));
	}
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		System.out.printf("%s 연결 끊김\n",session.getId());
	}
}
~~~~

웹 소켓 서버를 구현할 때 WebSocketHendler 인터페이스를 직접 상속받기 보다는 기본 구현을 일부 제공하고 있는 AbstractWebSocketHandler 나 TextWebSocketHandler 클래스를 상속받아 구현하게 된다. EchoHandler 클래스는 TextWebSocketHandler 클래스를 상속받았는데, TextWebSocketHandler 클래스는 텍스트 데이터를 주고 받을때 상속받아 사용할 수 있는 기반 클래스이다.

XML을 사용할 경우

~~~~
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:mvc="http://www.springframework.org/schema/mvc" xmlns:websocket="http://www.springframework.org/schema/websocket"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/mvc
       http://www.springframework.org/schema/mvc/spring-mvc.xsd
       http://www.springframework.org/schema/websocket
       http://www.springframework.org/schema/websocket/spring-websocket.xsd">

	<websocket:handlers>
		<websocket:mapping handler="echoHandler" path="/echo-ws" />
		<websocket:mapping handler="chatHandler" path="/chat-ws" />
	</websocket:handlers>

	<bean id="echoHandler" class="com.company.ex1.EchoHandler" />
	<bean id="chatHandler" class="com.company.ex2.ChatWebSocketHandler" />

	<websocket:handlers>
		<websocket:mapping handler="echoHandler" path="/echo.sockjs" />
		<websocket:mapping handler="chatHandler" path="/chat.sockjs" />
		<websocket:sockjs /> <!-- SockJS 서버 지원 -->
	</websocket:handlers>
	
	<mvc:default-servlet-handler />
	
</beans>

~~~~

java 를 사용할 경우

~~~~
package config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.company.ex1.EchoHandler;

@Configuration
@EnableWebSocket
public class WsConfig implements WebSocketConfigurer {

	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		registry.addHandler(echoHandler(), "/echo-ws");
		registry.addHandler(chatHandler(), "/chat-ws");
		registry.addHandler(echoHandler(), "/echo.sockjs").withSockJS();
		registry.addHandler(chatHandler(), "/chat.sockjs").withSockJS();
	}

	@Bean
	public EchoHandler echoHandler() {
		return new EchoHandler();
	}
	
	@Bean
	public ChatWebSocketHandler chatHandler() {
		return new ChatWebSocketHandler();
	}

}
~~~~

&lt;websocket:mapping&gt; 는 웹 소켓 클라이언트가 연결할 때 사용할 엔드포인트(path 속성)와 WebSockethandler 객체를 연결해준다.


&lt;websocket:mapping&gt;는 내부적으로 스프링 MVC의 SimpleUrlHandlerMapping을 포함해 몇 개의 빈을 등록해준다.
web.xml
~~~~
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns="http://java.sun.com/xml/ns/javaee"
	xsi:schemaLocation="http://java.sun.com/xml/ns/javaee 
		http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
	id="spring4-chap09-ws" version="3.0">
	<display-name>ws</display-name>

	<servlet>
		<servlet-name>dispatcher</servlet-name>
		<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
<!-- 		<init-param> -->
<!-- 			<param-name>contextConfigLocation</param-name> -->
<!-- 			<param-value> -->
<!-- 				/WEB-INF/ws-config.xml -->
<!-- 			</param-value> -->
<!-- 		</init-param> -->
		<init-param>
			<param-name>contextConfigLocation</param-name>
			<param-value>
				config.MvcConfig
				config.WsConfig
			</param-value>
		</init-param>
		<init-param>
			<param-name>contextClass</param-name>
			<param-value>
		org.springframework.web.context.support.AnnotationConfigWebApplicationContext
			</param-value>
		</init-param>
		<load-on-startup>1</load-on-startup>
	</servlet>

	<servlet-mapping>
		<servlet-name>dispatcher</servlet-name>
		<url-pattern>/</url-pattern>
	</servlet-mapping>

	<filter>
		<filter-name>encodingFilter</filter-name>
		<filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
		<init-param>
			<param-name>encoding</param-name>
			<param-value>UTF-8</param-value>
		</init-param>
	</filter>
	<filter-mapping>
		<filter-name>encodingFilter</filter-name>
		<url-pattern>/*</url-pattern>
	</filter-mapping>
</web-app>


~~~~



script 부분

~~~~
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		var wsocket;
		
		function sendMessage(){
			wsocket = new WebSocket("ws://localhost:8080/03_Websocket/echo-ws");
			wsocket.onmessage = onMessage;
			wsocket.onclose = onClose;
			wsocket.onopen = function(){
				wsocket.send($('#msg').val());
			};
		}
		
		function onMessage(e){
			var data = e.data;
			$('#chatArea').append(data+"<br>");
			wsocket.close();
		}
		
		function onClose(e){
			$('#chatArea').append('연결 끊김<br>');
		}
		
		$('#send').click(function(){
			sendMessage();
		});
	});
</script>
~~~~

> 웹 브라우저의 WebSocket API에 대한 내용은 웹 소켓 표준 문서인 http://www.w3.org/TR/websockets/를 참고

org.springframework.web.socket.WebSocketHandler 인터페이스에 정의된 메서드는 다음과 같다.

* void afterConnectionEstablished(WebSocketSession session) throws Exception : 웹 소켓 클라이언트가 연결되면 호출된다.
* void handleMessage(WebSocketSession session, WebSocketMessage&lt?&gt; message) throws Exception : 웹 소켓 클라이언트가 데이터를 전송하면 호출된다. message는 클라이언트가 전송한 데이터를 담고있다.
* void handleTransportError(WebSocketSession session, Throwable exception) throws Exception : 웹 소켓 클라이언트와의 연결에 문제가 발생하면 호출된다.
* void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception : 웹 소켓 클라이언트가 연결을 직접 끊거나 서버에서 타임아웃이 발생해서 연결을 끊을 때 호출된다.
* boolean supportsPartialMessages() : 큰 데이터를 나눠 받을 수 있는지 여부를 지정한다. 이 값이 true고 웹소켓 컨테이너(톰캣 등등) 가 부분 메시지를 지원할 경우, 데이터가 크거나 미리 데이터의 크기를 알 수 없을 때 handleMessage()를 여러번 호출해서 데이터를 부분적으로 전달한다.


WebSocketHandler 인터페이스를 상속받아 모든 메서드를 구현하기 보다는 AbstractWebSocketHandler클래스를 상속받아 필요한 메서드만 구현하는 것이 보통이다.

AbstractWebSocketHandler 클래스의 handleMessage() 메서드는 WebSocketMessage의 타입에 따라 다음의 세 메서드중 하나를 호출한다. 
* protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception
* protected void handleBinaryMessage(WebSocketSession session, BinaryMessage message) throws Exception
* protected void handlePongMessage(WebSocketSession session, PongMessage message) throws Exception


AbstractWebSocketHandler를 상속받은 하위 클래스는 처리하려는 메시지 타입에 따라 알맞은 메서드를 재정의하면 된다. 

TextWebSocketHandler 클래스는 handleBinaryMessage() 메서드가 익셉션을 발생하도록 재정의 하고 있으며, 이를 통해 텍스트 메시지만을 처리하도록 제한하고 있다.
BinaryWebSocketHandler 클래스는 유사한 방법으로 바이너리 메시지만 처리하도록 제한하고 있다.

스프링 웹소켓은 주고 받는 데이터를 담기 위해 org.springframework.web.socket.WebSocketMessage 인터페이스를 사용한다. WebSocketMessage인터페이스는 다음과 같다.

~~~~
package org.springframework.web.scoket;

public interface WebSocketMessage<T>{
	T getPayload();
	boolean isLast();
}
~~~~

WebSocketMessage의 하위 타입은 다음과 같이 두개가 존재한다.

* TextMessage : 텍스트를 담는 메시지로 String 타입 데이터를 담는다.
* BinaryMessage : 바이트를 담는 메시지로 java.nio.ByteBuffer 타입 데이터를 담는다.

BinaryMessage도 비슷하게 ByteBuffer를 이용해서 객체를 생성할 수 있다. 또는 byte배열을 이용해서 생성해도 된다.

> WebSocketMessage의 하위 타입에는 PingMessage와 PongMessage도 존재한다. 이 두 클래스는 서버와 클라이언트 간 연결을 유지하거나 확인하기 위해 사용되는 메시지이다.

org.springframework.web.socket.WebSocketSession 인터페이스는 웹소켓 클라이언트의 세션을 표현한다.
* String getId() : 세션 Id를 리턴한다.
* URI getUri() : 엔드포인트 경로를 리턴한다.
* InetSocketAddress getLocalAddress() : 로컬 서버 주소를 리턴한다.
* InetSocketAddress getRemoteAddress() : 클라이언트 주소를 리턴한다.
* boolean isOpen() : 소켓이 열려있는지 여부를 리턴한다.
* sendMessage(WebSocketMessage&lt;?&gt; message) throws IOException : 메시지를 전송한다.
* void close() throws IOException : 소켓을 종료한다.

#### 채팅

ChatWebSocketHandler
~~~~
package com.company.ex2;

import java.util.Date;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class ChatWebSocketHandler extends TextWebSocketHandler {
	private Map<String, WebSocketSession> users = new ConcurrentHashMap<>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.println(new Date()+" : "+session.getId()+" 연결");
		users.put(session.getId(), session);
	}
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		System.out.println(new Date()+" : "+session.getId()+" 메시지수신 : "+message.getPayload());
		for(WebSocketSession ws : users.values()){
			ws.sendMessage(message);
			System.out.println(new Date()+" : "+ws.getId()+" 에게 메시지발신 : "+message.getPayload());
		}
	}
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		System.out.println(new Date()+" : "+session.getId()+" 연결 종료");
		users.remove(session.getId());
	}
	
	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		System.out.println(new Date()+" : "+session.getId()+" 익셉션 : "+exception.getMessage());
	}
}
~~~~


script

~~~~
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		var wsocket;
		
		
		$('#enter').click(function(){
			wsocket = new WebSocket("ws://localhost:8080/03_Websocket/chat-ws");
			wsocket.onopen = onOpen;
			wsocket.onmessage = onMessage;
			wsocket.onclose = onClose;
		});
		$('#disconnect').click(function(){
			wsocket.close();
		});
		
		
		function onOpen(e){
			$('#chatArea').append('연결<br>');
		}
		function onMessage(e){
			var data = e.data;
			if(data.substring(0,4) == "msg:"){
				$('#chatArea').append(data.substring(4)+"<br>");
			}
		}
		function onClose(e){
			$('#chatArea').append('연결 끊김<br>');
		}
		
		$('#send').click(function(){
			send();
		});
		
		$('#msg').keypress(function(event){
			var keycode = (event.keyCode ? event.keyCode : event.which);
			if(keycode == '13'){
				send();
			}
			event.stopPropagation();
		});
		
		function send(){
			var nickname = $('#nickname').val();
			var msg = $('#msg').val();
			wsocket.send("msg:"+nickname+":"+msg)
			$('#msg').val("");
		}
	});
</script>
~~~~



> 웹 소켓 적용시 고려사항
> 웹 소켓 서버를 지원하는 컨테이너에 따라 서버의 동작 방식이 일부 다를 수 있다. Tomcat 7.0.52버전은 웹소켓 클라이언트가 연결되면, 직접 연결을 종료하기 전까지 연결을 유지한다. 반면에 Jetty 9버전의 경우 Ping/Pong 메시지를 이용해서 클라이언트가 연결을 유지하고 있는지 확인한다. 따라서, Jetty를 서버로 사용할 때 웹 브라우저가 Ping에 대한 응답으로 Pong을 전송하지 않으면 Jetty는 연결이 정상이 아닌것으로 간주하고 마지막 메시지 송수신 이후 일정 시간(default: 300s) 이 지나면 연결을 끊는다. 문제는 웹 브라우저마다 Ping/Pong을 지원할지 여부가 다르고, Ping/Pong을 지원하더라도 스프링에서 제대로 처리하지 못하는 경우가 있다는 점이다. 따라서, 이를 고려해서 웹컨테이너를 선택하고 클라이언트 코드는 연결이 끊기면 재열결을 하는 처리가 필요하다.

> 네트워크-웹소켓 읽어볼 내용 : http://www.infoq.com/articles/Web-Sockets-Proxy-Servers



 ### SockJS 지원
 
 웹소켓이 웹 브라우저에 적용되기 이전에 클라이언트와 서버간에 데이터를 주고 받기 위한 다양한 기법이 존재했는데, 이런 기법들 역시 브라우저 종류와 버전마다 다르게 적용해야 했다. ex)iframe, Long_Polling
 또한 웹소켓을 지원하면 직접 웹소켓을 쓰기도 한다. 문제는 각 방식에 따라 자바스크립트코드와 서버코드를 작성해야 했는데 이런 불편함을해소하기 위해 SockJS가 나왔다.
 
> http://caniuse.com/websockets

> SockJS
> SockJS는 이런 다양한 우회 기법들을 추상화해서 웹소켓과 유사한 API로 웹 서버와 웹 브라우저가 통신할수 있도록 해준다. 실제로  SocketJS가 제공하는 클라이언트 API를 이용해서 작성한 코드는 웹소켓API를 이용해서 작성한 코드와 거의 동일하다.
> SockJS는 다양한 환경을 위한 서버 모듈과 클라이언트 모듈을 제공하고 있다. 예를 들어, sockjs-client는 웹브라우저를 위한 자바 스크립트 모듈로서 브라우저환경에 상관없이 SockJS API를 이용해서 서버와 클라이언트가 양방향 통신을 할 수 있도록 만들어준다. 실제 SockJS가 내부적으로 웹소켓, Long-Polling등을 사용할지 여부는 몰라도 된다.
> SockJS 클라이언트와 통신할 수 있는 SockJS 서버는 웹소켓, Long-POling 등 SockJS 클라이언트가 사용하는 다양한 방식을 지원한다. 현재 SockJS를 지원하는 서버로는 Node.js, 파이썬, 자바,Vert.x 서버 등이 있으며, 이들 서버를 사용하면 단일 서버 API를 이용해서 SockJS 클라이언트와 양방향 통신하는 서버를 만들수 있다.

스프링 웹소켓 모듈을 사용하면 SockJS 서버를 만들 수 있다.

--xml
~~~~
<websocket:sockjs /> <!-- SockJS 서버 지원 -->
~~~~

--java
~~~~
package config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.company.ex1.EchoHandler;
import com.company.ex2.ChatWebSocketHandler;

@Configuration
@EnableWebSocket <!-- SockJS -->
public class WsConfig implements WebSocketConfigurer {  <!-- SockJS -->

	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		registry.addHandler(echoHandler(), "/echo.sockjs").withSockJS();  <!-- SockJS -->
	}

	@Bean
	public EchoHandler echoHandler() {
		return new EchoHandler();
	}
	
	@Bean
	public ChatWebSocketHandler chatHandler() {
		return new ChatWebSocketHandler();
	}

}
~~~~

SockJS를 사용하는 자바스크립트 코드는 다음과 같이 SockJS 자바스크립트 클라이언트 코드를 이용해서 서버에 접속하면 된다.
웹소켓과 차이점은 WebSocket 대신 SockJS를 사용하고 ws 대신 http를 사용한다.

~~~~
<script src="//cdn.jsdelivr.net/sockjs/1/sockjs.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		var sock;
		
		
		$('#enter').click(function(){
			sock = new SockJS("http://localhost:8080/03_Websocket/chat.sockjs");
			sock.onopen = onOpen;
			sock.onmessage = onMessage;
			sock.onclose = onClose;
		});
		$('#disconnect').click(function(){
			sock.close();
		});
		
		
		function onOpen(e){
			$('#chatArea').append('연결<br>');
		}
		function onMessage(e){
			var data = e.data;
			if(data.substring(0,4) == "msg:"){
				$('#chatArea').append(data.substring(4)+"<br>");
			}
		}
		function onClose(e){
			$('#chatArea').append('연결 끊김<br>');
		}
		
		$('#send').click(function(){
			send();
		});
		
		$('#msg').keypress(function(event){
			var keycode = (event.keyCode ? event.keyCode : event.which);
			if(keycode == '13'){
				send();
			}
			event.stopPropagation();
		});
		
		function send(){
			var nickname = $('#nickname').val();
			var msg = $('#msg').val();
			sock.send("msg:"+nickname+":"+msg)
			$('#msg').val("");
		}
	});
</script>
~~~~

> 현재의 다양한 환경-브라우저, 웹서버의 지원여부, 네트워크 장비의 웹소켓 지원- 을 고려하면, 웹브라우저에서 웹소켓 API를 직접 사용하는 것 보다는 SockJS를 사용하는 것이 안정적으로 양방향을 지원하는 방법이다. 브라우저와 네트워크구성을 마음대로 결정할 수 있는 환경이 아니라면 웹소켓 API를 직접 사용하지 말고 SockJS를 사용하는 것이 바람직하다. 
> 관련 내용 - https://github.com/sockjs/sockjs-client