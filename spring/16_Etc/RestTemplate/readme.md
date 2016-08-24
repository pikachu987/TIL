### RestTemplate 을 이용한 HTTP 클라이언트 구현

HTTP 기반의 오픈 API가 증가하고, 내부 서비스 간에도 HTTP 를 기반으로 통신하는 경우가 증가하고 있다. 이런 이유로 HTTP에 기반한 클라이언트 코드를 작성해야 할 때가 많은데, 스프링은 HTTP 클라이언트를 구현하는데 필요한 기능을 구현한 RestTemplate 클래스를 제공하고 있다.

> 여기서 에러가 나면
~~~~
<dependency>
<groupId>org.codehaus.jackson</groupId>
<artifactId>jackson-mapper-asl</artifactId>
<version>1.9.13</version>
</dependency>
~~~~
~~~~
<mvc:annotation-driven />
~~~~
> 이 두가지를 확인해보자

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

* T postForObject(String url, Object request, Class&lt;T&gt; responseType, Object... uriVariables)
* T postForObject(String url, Object request, Class&lt;T&gt; responseType, Map&lt;String, ?&gt; uriVariables)
* T postForObject(URI url, Object request, Class&lt;T&gt;  responseType)
* ResponseEntity&lt;T&gt; postForEntity(String url, Object request, Class&lt;T&gt; responseType, Object... uriVariables)
* ResponseEntity&lt;T&gt; postForEntity(String url, Object request, Class&lt;T&gt; responseType, Map&lt;String, ?&gt; uriVariables)
* ResponseEntity&lt;T&gt; postForEntity(URI url, Object request, Class&lt;T&gt; responseType)
* URI postFOrLocation(String url, Object request, Object... urlVariables)
* URI postForLocation(String url, Object reqeust, Map&lt;String, ?&gt; urlVariables)
* URI postForLocation(URI url, Object request)

request 파라미터는 요청 몸체로 전송되며, 나머지 파라미터는 GET의 경우와 동일하다. postForObject() 와 postForEntity() 는 응답의 몸체 내용을 구할 때 사용되고, URI를 리턴하는 postForLocation() 메서드는 응답 결과로 응답의 Location 헤더 값을 구할 때 사용된다.

> RESTful 방식 API 에서 POST는 새로운 데이터를 추가하는 목적으로 사용되는데, 이때 서버는 응답으로 새로 생성된 데이터에 접근할 수 있는 URL을 'Location' 응답 헤더에 담아 주는 경우가 많다. 이를 위해 RestTemplate 은 postForLocation() 메서드를 추가로 제공하고 있다.

PUT 방식을 위한 메서드는 다음과 같다. 이들 메서드는 리턴 타입이 모두void이다.

* void put(String url, Object request, Object... urlVariables)
* void put(String url, Object request, Map&lt;String, ?&gt; urlVariables)
* void put(URI url, Object request)

DELETE 방식을 위한 메서드는 다음과 같다. 리턴 타입이 모두 void이다.

* void delete(String url, Object... urlVariables)
* void delete(String url, Map&lt;String, ?&gt; urlVariables)
* void delete(URI url)

##### HttpMessageConverter 를 이용한 타입 변환

GET이나 POST를 위한 메서드는 몸체 내용을 특정 타입의 객체로 변환해서 리턴한다. 비슷하게 POST나 PUT을 위한 메서드는 메서드에 전달한 객체를 요청 몸체로 알맞게 변환한다.

RestTemplate 은 자바 객체와 요청/응답 몸체 사이의 변환 처리를 위해 HttpMessageConverter를 사용한다. RestTemplate가 기본으로 사용하는 HttpMessageConverter이다.

* ByteArrayHttpMessageConverter
* StringHttpMessageConverter
* ResourceHttpMessageConverter
* SourceHttpMessageConverter&lt;Source&gt; 
* AllEncompassingFormHttpMessageConverter
* AtomFeedHttpMessageConverter (Rome 라이브러리 존재시)
* RssChannelHttpMessageConverter (Rome 라이브러리 존재시)
* Jaxb2RootElementHttpMessageConverter
* MappingJackson2HttpMessageConverter (Jackson2 라이브러리 존재시)

MappingJackson2HttpMessageConverter와 Jaxb2RootElementHttpMessageConverter가 기본으로 사용되기 때문에, JSON이나 XML 형식의 응답을 자바 객체로 받거나 반대의 경우를 쉽게 처리할 수 있다.

만약 RestTemplate이 사용하는 MessageConverter 구현체 목록을 변경하고 싶다면, 다음의 메서드를 이용해서 교체하면 된다.

* setMessageConverters(List &lt;HttpMessageConverter&lt;?&gt;&gt; messageConverters)

##### exchange() 메서드를 이용한 헤더 요청

요청 헤더를 직접 설정하고 싶다면 다음의 exchange() 메서드를 사용한다.

* ResponseEntity&lt;T&gt; exchange(String url, HttpMethod method, HttpEntity&lt;?&gt; requestEntity, Class&lt;T&gt; responseType, Object... uriVariables)
* ResponseEntity&lt;T&gt; exchange(String url, HttpMethod method, HttpEntity&lt;?&gt; requestEntity, Class&lt;T&gt; responseType, Map&lt;String, ?&gt; uriVariables)
* ResponseEntity&lt;T&gt; exchange(URI url, HttpMethod method, HttpEntity&lt;?&gt; requestEntity, Class&lt;T&gt; responseType)

org.springframework.http.HttpMethod 열거 타입은 전송 방식을 정한다. 이 열거 타입에는 GET, POST, HEAD, OPTIONS, PUT, PATCH, DELETE, TRACE의 값이 정의되어 있다.

org.springframework.http.HttpEntity 는 요청 헤더와 요청 몸체를 설정할 때 사용되는 타입으로 주된 사용방법은 다음과 같다.

~~~~
//getForEntity 기능을 exchange를 이용해서 구현
HttpHeaders headers = new HttpHeaders();
headers.add("AUTHKEY", "myKey");
headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));
HttpEntity&lt;Void&gt; requestEntity = new HttpEntity&lt;&gt;((Void) null, headers);

ResponseEntity&lt;Item&gt; itemResponse = restTemplate.exchange("http://...", HttpMethod.GET, requestEntity, Item.class);
Item item = itemResponse.getBody();



//postForLocation의 기능을 exchange를 이용해서 구현
HttpEntity&lt;Store&gt; requestEntity2 = new HttpEntity&lt;&gt;(new Store("new"), headers);

ResponseEntity&lt;Void&gt; postResponse = restTemplate.exchange("http://...", HttpMethod.POST, requestEntity2, Void.class);
URI newStoreUri = postResponse.getHeaders().getLocation();
~~~~


##### URIBuilder를 이용한 URI 생성

RestTemplate 클래스는 java.net.URI 타입을 이용해서 연결할 URL을 지정하는 메서드를 함께 제공하고 있다. URI 객체를 직접 생성할 수도 있지만, 스프링이 제공하는 UriComponentsBuilder 클래스를 이용하면 경로 변수를 사용하는 URL을 포함한 URI객체를 생성할 수 있다.

~~~~
UriComponentsBuilder ub = UriComponentsBuilder.newInstance();
UriCompontents uc = ub.scheme("http");
	.host("localhost")
	.post(8080)
	.path("/...")
	.build();
uc.uc.expand("PathVariable 값들", "...").encode();
URI uri = uc.toUri();
~~~~


UriComponentsBuilder 클래스는 scheme(), host(), port(), path() 메서드를 이용해서 URI를 구성할 수 있다. port()나 path() 등을 지정하지 않으면 생성되는 URI에 포함되지 않는다. path()로 지정하는값은 위 코드에서 보듯 경로 변수를 사용할 수 있다.

UriCompontentsBuilder의 build() 메서드를 호출하면 UriComponents 객체를 생성한다. UriComponents의 expend() 메서드는 경로 변수의 값을 설정할때 사용된다. 위 코드처럼 가변 인자로 경로 변수의 각 값을 설정해도 되고, Map을 이용해서 설정해도 된다.

##### AsyncRestTemplate 을 이용한 비동기 응답 처리

org.springframework.web.client.AsyncRestTemplate 클래스는 RestTemplate과 동일한 메서드를 제공하고 있다. 차이점이 있다면, 결과 객체를 바로 받는 대신 ListableFuture를 리턴타입으로 갖는다.

~~~~
AsyncRestTemplate asyncTemplate = new AsyncRestTemplate();
ListenableFuture&lt;ResponseEntity&lt;String&gt;&gt; future = asyncTemplate.getForEntiy("http://....", String.class);

future.addCallback(new ListenableFutureCallback&lt;ResponseEntity&lt;String&gt;&gt;()P
	@Override
	public void onSuccess(ResponseEntity&lt;String&gt; s){
		String content = s.getBody();
		System.out.println(content.substring(0,100));
	}
	@Override
	public void onFailure(Throwable t){
		...
	}
}

~~~~


비동기로 결과를 처리하기 위해 AsyncRestTemplate 의 메서드는 ListenableFuture타입을 리턴하고, 결과 타입으로는 ResponseEntity를 사용한다.

ListenableFuture.addCallback()에 ListenableFutureCallback 타입의 객체를 전달해서 처리 결과를 받을 수 있다. 성공적으로 처리되면 콜백 객체의 onSuccess() 메서드가 호출되고, 익셉션이 발생하면 onFailure() 메서드가 호출된다. onSuccess() 메서드는 ResponseEntiy를 이용해서 필요한 값을 구할 수 있으며, onFailure() 메서드는 파라미터로 전달된 Throwable 객체를 이용해서 알맞은 익셉션 처리를 하면 된다.

