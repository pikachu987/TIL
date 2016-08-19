### 파일 업로드

파일을 업로드해야 할 경우 HTML 폼의 enctype 속성 값으로 multipart/form-data를 사용한다.

인코딩 타입이 multipart/form-data인 경우 파라미터나 업로드한 파일 데이터를 사용하려면 전송 데이터를 알맞게 처리해주어야 한다. 스프링은 멀티파트 형식을 지원하고 있기 때문에, 이 기능을 이용하면 멀티파트를 위한 별도 처리 없이 멀티파트 형식으로 전송된 파라미터와 파일 정보를 구할 수 있다.

#### MultipartResolver 설정

멀티파트 지원 기능을 사용하려면 먼저 MultipartResolver 를 스프링 설정 파일에 등록해주어야 한다.
스프링이 기본으로 제공하는 MultipartResolver 는 두개가 있다.

* org.springframework.web.multipart.commons.CommonsMultipartResolver
* > Commons FileUpload API 를 이용해서 멀티파트 데이터를 처리한다.
* org.springframework.web.multipart.support.StandardServletMultipartResolver
* > 서블릿 3.0의 Part를 이용해서 멀티파트 데이터를 처리한다.

이 두 MultipartResolver 구현체 중 하나를 스프링 빈으로 등록해주면 된다. 이 때 주의할 점은 스프링 빈의 이름은 "multipartResolver" 이어야 한다는 점이다. DispatcherServlet은 이름이 "multipartResolver"인 빈을 사용하기 때문에, 다른 이름을 사용할 경우 MultipartResolver로 사용되지 않는다.

##### Commons FileUpload를 이용하기 위한 설정

CommonsMultipartResolver는 Commons FileUpload API를 이용해서 Multipart를 처리해준다.
~~~~
<bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
</bean>
~~~~

CommonsMultipartResolver 클래스는 다음과 같은 프로퍼티를 제공하고 있다.

<table>
<tr><th>프로퍼티</th><th>타입</th><th>설명</th></tr>
<tr>
<td>maxUploadSize</td>
<td>long</td>
<td>최대 업로드 가능한 바이트 크기. -1은 제한이 없음. 기본값이 -1</td>
</tr>
<tr>
<td>maxInMemorySize</td>
<td>int</td>
<td>디스크에 임시 파일을 생성하기 전에 메모리에 보관할 수 있는 최대 바이트 크기. 기본값은 10240 바이트이다.</td>
</tr>
<tr>
<td>defaultEncoding</td>
<td>String</td>
<td>요청을 파싱할 때 사용할 캐릭터 인코딩. 지정하지 않을 경우, HttpServletRequest.setCharacterEncoding() 메서드로 지정한 캐릭터 셋이 사용된다. 아무 값도 없을 경우는 ISO-8859-1 을 사용한다.</td>
</tr>
</table>

> CommonsMultipartResolver는 Commons FileUpload API를 사용하기 때문에, Commons FileUpload 라이브러리를 클래스패스에 추가해 주어야 한다.
> ~~~~
> <dependency>
> <groupId>commons-fileupload</groupId>
> <artifactId>commons-fileupload</artifactId>
> <version>1.3</version>
> </dependency>
> ~~~~

##### 서블릿 3의 파일 업로드 기능 사용을 위한 설정

* DispatcherServlet이 서블릿 3의 Multipart를 처리하도록 설정
* StandardServletMultipartResolver 클래스를 MultipartResolver로 설정

먼저, 서블릿 3의 파일 업로드 기능을 사용하려면 multipart-config 태그를 이용해서 DispatcherServlet이 멀티파트를 처리할 수 있도록 설정해주어야 한다.

~~~~
<servlet>
		<servlet-name>dispatcher2</servlet-name>
		<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
		<init-param>
			<param-name>contextConfigLocation</param-name>
			<param-value>
				/WEB-INF/sample2.xml
			</param-value>
		</init-param>
		<load-on-startup>1</load-on-startup>
		<multipart-config>
			<max-file-size>-1</max-file-size>
			<max-request-size>-1</max-request-size>
			<file-size-threshold>1024</file-size-threshold>
		</multipart-config>
	</servlet>
~~~~

multipart-config 의 설정 태그

<table>
<tr><th>태그</th><th>설명</th></tr>
<tr>
<td>location</td>
<td>업로드한 파일이 임시로 저장될 위치를 지정한다.</td>
</tr>
<tr>
<td>max-file-size</td>
<td>업로드 가능한 파일의 최대 크기를 바이트 단위로 지정한다. -1은 제한이 없음을 의미하며 기본값은 -1 이다.</td>
</tr>
<tr>
<td>file-size-threshold</td>
<td>업로드한 파일 크기가 이 태그의 값보다 크면 location에서 지정한 디렉토리에 임시로 파일을 생성한다. 업로드 파일 크기가 이 태그의 값 이하면 메모리에 파일 데이터를 보관한다. 단위는 바이트이며, 기본값은 0이다.</td>
</tr>
<tr>
<td>max-requeset-size</td>
<td>전체 Multipart 요청 데이터의 최대 제한 크기를 바이트 단위로 지정한다. -1은 제한이 없음을 의미하고 기본값은 -1이다.</td>
</tr>
</table>

DispatcherServlet이 서블릿3의 파일 업로드 기능을 사용할 수 있도록 multipart-config를 설정했다면, 스프링 설정에서 StandardServletMultipartResolver를 빈으로 등록해주면 된다.
~~~~
<bean id="multipartResolver" class="org.springframework.web.multipart.support.StandardServletMultipartResolver" />
~~~~

파일 최대 크기나 임시 저장 디렉토리 등은 multipart-config 태그를 이용해서 설정하기 때문에, StandardServletMultipartResolver는 별도 프로퍼티 설정을 제공하지 않는다.

서블릿 3 버전부터 자바 클래스를 이용해서 서블릿을 설정하는 방법이 추가됐는데, DispatcherServlet 도 마찬가지로 web.xml이 아닌 자바 코드를 이용해서 설정할수 있게 되었다. 즉 자바코드를 이용해서 서블릿 3의 파일 업로드 관련 부분을 설정할수 있다.

> StandardServletMultipartResolver 는 서블릿 3버전 이상만 지원하므로, 톰캣 6버전과 같이 서블릿 2.5 또는 그 이하를 지원하는 웹컨테이너에서는 올바르게 동작하지 않는다.

#### 업로드한 파일 접근하기

DispatcherServlet 이 사용하는 스프링 설정에 MultipartResolver를 등록했다면, 이제 업로드한 파일 데이터를 컨트롤러에서 사용할 수 있게 된다. 

##### MultipartFile 인터페이스 사용
org.springframework.web.multipart.MultipartFile 인터페이스는 업로드 한 파일 정보 및 파일 데이터를 표현하기 위한 용도를 사용되며, 이 인터페이스를 이용해서 업로드한 파일 데이터를 읽을 수 있다.

<table>
<tr><th>메서드</th><th>설명</th></tr>
<tr>
<td>String getName()</td>
<td>파라미터 이름을 구한다.</td>
</tr>
<tr>
<td>String getOriginalFilename()</td>
<td>업로드한 파일의 이름을 구한다.</td>
</tr>
<tr>
<td>boolean isEmpty()</td>
<td>업로드한 파일이 존재하지 않는 경우 true를 리턴한다.</td>
</tr>
<tr>
<td>long getSize()</td>
<td>업로드한 파일의 크기를 구한다.</td>
</tr>
<tr>
<td>byte[] getBytes() throws IOException</td>
<td>업로드한 파일 데이터를 구한다.</td>
</tr>
<tr>
<td>InputStream getInputStream() throws IOException</td>
<td>업로드한 파일 데이터를 읽어오는 InputStream을 구한다. InputStream의 사용이 끝나면 알맞게 종료해 주어야 한다.</td>
</tr>
<tr>
<td>void transferTo(File dest) throws IOException</td>
<td>업로드한 파일 데이터를 지정한 파일에 저장한다.</td>
</tr>
</table>

업로드한 파일 데이터를 구하는 가장 단순한 방법은 MultipartFile.getBytes() 메서드를 이용하는 것이다.
~~~~
byte[] bytes = multipartFile.getBytes();
File file = new File(uploadPath, multipartFile.getOriginalFilename());
FileCopyUtil.copy(bytes, file);
~~~~

MultipartFile.transferTo() 메서드를 사용하면 더 간결하게 업로드한 파일을 지정한 파일에 저장할 수 있다.

~~~~
if(multipartFile.isEmpty()){
	File file = new File(fileName);
	multipartFile.transferTo(file);
}
~~~~

##### MultipartHttpServletRequest를 이용한 업로드 파일 접근

MultipartHttpServletRequest 인터페이스를 사용하는 것이다.
~~~~
public String upload(MultipartHttpServletRequest request, Model model) throws IOException{
if(!multipartFile.isEmpty()){
File file = new File(uploadPath, multipartFile.getOrigiinalFilename());
multipartFile.transferTo(file);
}
return "";
}
~~~~

MultipartHttpServletRequest 인터페이스는 스프링이 제공하는 인터페이스로서, 멀티파트 요청이 들어올 때 내부적으로 원본 HttpServletRequest 대신 사용되는 인터페이스이다. MultipartHttpServletRequest 인터페이스는 실제로는 어떤 메서드도 선언하고 있지 않다.

MultipartHttpServletRequest 인터페이스는 javax.servlet.HttpServletRequest 인터페이스를 상속받기 때문에 웹 요청 정보를 구하기 위한 getParameter()나 geteHeader()와 같은 메서드를 사용할 수 있으며, 추가로 MultipartRequest 인터페이스가 제공하는 멀티파트 관련 메서드를 사용할 수 있다.

<table>
<tr><th></th><th></th></tr>
<tr>
<td>Iterator&lt;String&gt; getFileNames()</td>
<td>업로드된 파일들의 파라미터 이름 목록을 제공하는 Interator를 구한다.</td>
</tr>
<tr>
<td>MultipartFile getFile(String name)</td>
<td>파라미터 이름이 name 인 업로드 파일 정보를 구한다.</td>
</tr>
<tr>
<td>List&lt;MultipartFile&gt; getFiles(String name)</td>
<td>파라미터 이름이 name인 업로드 파일 정보 목록을 구한다.</td>
</tr>
<tr>
<td>Map&lt;String, MultipartFile&gt; getFileMap()</td>
<td>파라미터 이름을 키로 파라미터에 해당하는 파일 정보를 값으로 하는 Mao을 구한다.</td>
</tr>
</table>

##### 커맨드 객체를 통한 업로드 파일 접근

커멘드 객체를 이용해도 업로드한 파일을 전달받을 수 있따. 단지 커맨드 클래스에 파라미터와 동일한 이름의 MultipartFile타입 프로퍼티를 추가해주기만 하면 된다.

예를 들어 업로드 파일의 파라미터 이름이 reposrt인 경우 report 프로퍼티를 커맨드 클래스에 추가해주면 된다.
~~~~
public class ReportCommand{
	private String studentNumber;
	private MultipartFile report;

	//setter, getter

}

~~~~


위 코드와 같이 MultipartFile 타입의 프로퍼티를 커맨드 클래스에 추가해주었다면,  로드 파일 정보를 커맨드 객체를 통해서 전달 받을 수 있다.

~~~~
public String test(ReportCommand reportCommand){
	MultipartFile reportFile = reportCommand.getReport();
}
~~~~


##### 서블릿 3의 Part 사용하기

서블릿 3의 파일 업로드 기능을 사용했다면, 다음과 같이 서블릿 3에 추가된 javax.servlet.http.Part 타입을 이용해서 업로드한 파일을 처리할 수 있다.

~~~~
public String uploadByMultipartFile(@RequestParam("f") Part part,
			@RequestParam("title") String title, Model model) throws IOException {
		if (part.getSize() > 0) {
			String fileName = getFileName(part);
			File file = new File(uploadPath, fileName);
			FileCopyUtils.copy(part.getInputStream(), new FileOutputStream(file));
			model.addAttribute("title", title);
			model.addAttribute("fileName", fileName);
			model.addAttribute("uploadPath", file.getAbsolutePath());
			return "upload/fileUploaded";
		}
		return "upload/noUploadFile";
	}

	private String getFileName(Part part) {
		for (String cd : part.getHeader("Content-Disposition").split(";")) {
			if (cd.trim().startsWith("filename")) {
				return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
			}
		}
		return null;
	}
~~~~    