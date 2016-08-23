### RestTemplate 을 이용한 HTTP 클라이언트 구현

HTTP 기반의 오픈 API가 증가하고, 내부 서비스 간에도 HTTP 를 기반으로 통신하는 경우가 증가하고 있다. 이런 이유로 HTTP에 기반한 클라이언트 코드를 작성해야 할 때가 많은데, 스프링은 HTTP 클라이언트를 구현하는데 필요한 기능을 구현한 RestTemplate 클래스를 제공하고 있다.

####  RestTemplate의 기본 사용법

org.springframework.web.client.RestTemplate 클래스의 사용방법은 매우 간단하다.

~~~~
RestTemplate restTemplate = new RestTemplate();
String body = restTemplate.getForObject("http://www.daum.net", String.class);
~~~~

getForObject() 메서드는 HTTP GET 방식으로 http://www.daum.net 에 연결해서 응답 결과를 String 타입으로 구한다. String 타입 외에 HttpMessageConverter를 사용하면 JSON이나 XML 응답을 바로 자바 객체로 변환할 수 있다.

getForObject() 에서 get 은 HTTP GET 방식(method)을의미하는 것으로, postForObject(), put(), delete(), headForHeaders() 등 각 HTTP 방식별로 메서드가 존재한다.

RESTful 방식의 API는 URL이 "http://host/stores/스토어ID/items/아이템ID" 와 같이 자원을 중심으로 경로를 구성하는데, RestTemplate 은 이런 구조의 URL을 좀 더 쉽게 구성할 수 있도록 경로 변수를 사용할 수 있는 메서드를 한께 제공하고 있다.

~~~~
String response = resTemplate.getForObject("http://localhost:8080/{test}", String.class, "1");
~~~~

~~~~
String response = resTemplate.getForObject("http://localhost:8080/{test}/{test2}", String.class, "1", "test2");
~~~~


다음과 같이 Map 을 사용할 수도 있다.

~~~~
Map<String, Object> pathVariableMap = new HashMap<>();
pathVariableMap.put("storeId", 1L);

Store store = resTemplate.getForObject("http://localhost:8080/{test}/{test2}", Store.class, pathVariableMap);

~~~~

RestTemplate 객체를 매번 생성해서 사용할 수 있지만, 그것보다 필드로 설정해서 사용한다.

~~~~
public class ExternalserviceClient{

	private RestTemplate restTemplate = new RestTemplate();

	public void sendOrder(Order order){
		URI uri = restTemplate.postForLocation("...", store3);    
		...
	}


}
~~~~



##### 서버 에러 응답 처리
RestTemplate 은 서버와 통신하는 과정에서 문제가 발생하면 org.springframework.web.clinet.RestClientException을 발생시킨다. 

* HttpStatusCodeException : 응답 코드가 에러에 해당할 경우 발생
* HttpClientErrorException : 응답 코드가 4XX일때 발생
* HttpServerErrorException : 응답 코드가 5XX일때 발생
* ResourceAccessException : 네트워크 연결에 문제가 있을 경우 발생
* UnknownHttpStatusCodeException : 알 수 없는 상태 코드일때 발생

~~~~
try{
}catch(HttpStatusCodeException e){
	if(e.getStatusCode() == HttpStatus.NOT_FOUND){
		...
	}
}
~~~~

HttpStatusCodeException 및 그 하위 타입 두 개는 상태 코드를 구할 수 있도록 다음의 메서드를 제공하고 있다.

* HttpStatus getStatusCode() : org.springframework.http.HttpStatus 열거 타입을 리턴한다.

UnknownHttpStatusCodeException 클래스가 제공하는 메서드는 다음과 같다.
* int getRawStatusCode() : 서버에서 전송한 응답 코드를 구한다.

다음 메서드는 ResourceAccessException을 제외한 나머지 익셉션 타입이 동일하게 제공한다.

* String getStatusText() : HTTP 상태 문자값을 리턴한다.
* HttpHeaders getResponseHeaders() : 응답 헤더를 org.springframework.http.HttpHeaders로 리턴한다.
* String getResponseBodyAsString() : 응답 몸체를 문자열로 구한다.


##### RestTemplate 의 주요 메서드 : GET, POST, PUT, DELETE 처리


RestTemplate 클래스는 각 HTTP 방식(method) 별로 메서드를 제공하고 있는데, 이 중 GET방식과 관련된 메서드는 다음과 같다.

* T getForObject(String url, Class&lt;T&gt; responseType, Object... urlVariables)
* T getForObject(String url, Class&lt;T&gt; responseType, Map&lt;String, ?&gt; urlVariables)
* T getForObject(URL url, Class&lt;T&gt;  responseType)
* ResponseEntity&lt;T&gt;  getForEntity(String url, Class&lt;T&gt;  responseType, Object... urlVariables)
* ResponseEntity&lt;T&gt;  getForEntity(String url, Class&lt;T&gt;  responseType, Map&lt;String, ?&gt; urlVariables)
* ResponseEntity&lt;T&gt;  getForEntity(URI url, Class&lt;T&gt;  responseType)

각 파라미터는 다음과 같다.

* String 타입 url 파라미터 : URL을 지정한다. 경로 변수를 포함할 수 있다.
* URL 타입 url파라미터 : URI를 이용해서 연결할 URL을 지정한다.
* urlVariables :경로 변수에 사용될 값을 지정한다.
* responseType : 응답 결과를 변환할 타입

getForObject() 메서드는 응답 결과를 responseType 으로 지정한 타입으로 바로 변환해서 리턴하며, getForEntity() 메서드는 org.springframework.http.ResponseEntity 타입으로 리턴한다. 상태 코드나 헤더 등의 값에 접근해야 할 경우 ResponseEntity를 사용할 수 있다.

* HttpStatus getStatusCode() : 응답상태코드를 구한다.
* HttpHeaders getHeaders() : 헤더 값을 구한다.
* T getBody() : 몸체를 구한다.



POST 방식을 위한 메서드는 다음과 같다.








