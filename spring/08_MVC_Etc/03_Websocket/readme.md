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

