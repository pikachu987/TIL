### 메일발송

MailSender와 JavaMailSender을 이용한 메일 발송

스프링은 메일 발송 기능을 위한 MailSender 인터페이스를 제공하고 있으며, 다음과 같이 정의되어 있다.

~~~~
package org.springframework.mail;

public interface MailSender{
	void send(SimpleMailMessage simpleMessage) throws MailException;
	void send(SimpleMailMessage[] simpleMessages) throws MailException;
}
~~~~

MailSender 인터페이스는 SimpleMailMessage를 전달받아 메일을 발송하는 기능을 정의하고 있다. SimpleMailMessage는 메일 제목과 단순 텍스트 내용으로 구성된 메일을 발송할 때에 사용된다.

MailSender 인터페이스를 상속받은 JavaMailSender는 Java Mail API의 MimeMessage를 이용해서 메일을발송하는 기능을 추가적으로 정의하고 있다. JavaMailSender 인터페이스는 다음과 같이 정의되어 있다.

~~~~
package org.springframework.mail.javamail;

import java.io.InputStream;
import javax.mail.internet.MimeMessage;
import org.springframework.mail.MailException;
import org.springframework.mail.MailSender;

public interface JavaMailSender extends MailSender{
	MimeMessage createMimeMessage();
	MimeMessage createMimeMessage(InputStream contentStream) throws MailException;
	void send(MimeMessage mimeMessage) throws MailException;
	void send(MimeMessage[] mimeMessages) throws MailException;
	void send(MimeMessagePreparator mimeMessagePreparator) throws MailException;
	void send(MimeMessagePreparator[] mimeMessagePreparatprs) throws MailException;
}
~~~~

MailSender 인터페이스와 JavaMailSender 인터페이스의 메서드들이 발생하는 MailException은 RuntimeException이므로, 익셉션 처리가 필요한 경우에만 catch 블록에서 처리해주면 된다.

스프링은 JavaMailSender 인터페이스의 구현체로 JavaMailSenderImpl 클래스를 제공하고 있으므로 이 클래스를 이용해서 빈 설정을 하게 된다.


#### java MailSender 빈 설정

~~~~
<dependency>
	<groupId>org.springframework</groupId>
	<artifactId>spring-context-support</artifactId>
	<version>4.0.4.RELEASE</version>
</dependency>
<dependency>
	<groupId>javax.mail</groupId>
	<artifactId>mail</artifactId>
	<version>1.4.7</version>
</dependency>
~~~~

JavaMailSenderImpl 클래스는 Java Mail API를 이용해서 메일을 발송하며 기본적으로 SMTP 프로토콜을 사용한다. SMTP 서버를 이용해서 메일을 발송하므로 SMTP 주소와 포트번호를 필요로 한다. 이 두 정보는 각각 host 프로퍼티와 port 프로퍼티를 이용해서 입력 받는다.


~~~~
<bean id="mailSender" class="org.springframework.mail.javamail.JavaMailSenderImpl">
	<property name="host" value="mail.host.com" />
	<property name="port" value="25" />
	<property name="defaultEncoding" value="utf-8" />
</bean>
<bean id="someNotifier" class="...">
	<property name="mailSender" ref="mailSender" />
</bean>
~~~~

port 프로퍼티의 기본 값은 25이므로, 포트 번호가 25가 아닌 경우에만 port속성을 설정하면 된다. defaultEncoding 프로퍼티는 발송될 메일의 기본 인코딩을 설정한다. JavaMailSenderImpl은 내부적으로 Java Mail API의 MimeMessage 를 이용하기 때문에, 인코딩을 지정하지 않은 SimpleMailMessage를 이용할 경우에 defaultEncoding 프로퍼티의 속성 값을 알맞게 입력해주는 것이 좋다.

만약, SMTP 서버에서 인증을 필요로 한다면 다음과 같이 프로퍼티에 정보를 입력한다.

~~~~
<bean id="mailSender" class="org.springframework.mail.javamail.JavaMailSenderImpl">
	<property name="host" value="localhost" />
	<property name="port" value="25" />
	<property name="username" value="id" />
	<property name="password" value="pwd" />
	<property name="defaultEncoding" value="utf-08" />
</bean>
~~~~


#### SimpleMailMessage 를 이용한 메일 발송

단순히 텍스트로만 구성된 메일 메시지를 생성할 때에는 SimpleMailMessage를 이용한다.

| 메서드 | 설명 |
|---|---|
|setFrom(String from)|발신자 설정|
|setReplyTo(String replyTo|응답주소설정|
|setTo(String to|수신자설정|
|setTo(String[] to)|수신자 목록 설정|
|setCc(String cc)|참조자 설정|
|setCc(String[] cc)|참조자 목록 설정|
|setBcc(String bcc)|숨은 참조자 설정|
|setBcc(String[] bcc)|숨은 참조자 목록 설정|
|setSentDate(Date sentDate)|메일 발송일 설정|
|setSubject(String subject)|메일 제목(주제)설정|
|setText(String text)|메일 내용설정|


#### Java Mail API의 MimeMessage를 이용한 메시지 생성

SimpleMailMessage 는단순히 텍스트 기반의 메시지를 발송하는 데에는 적합하지만, 메일 내용이 HTML로 구성되어 있다던가, 파일을 첨부해야 하는 경우에는 사용할 수 없다.

이런 기능이 필요한 경우에는 Java Mail API가 제공하는 MimeMessage를 직접 이용해서 메일을 발송해주어야 한다.

JavaMileSender 인터페이스는 MimeMessage 객체를 생성해주는 createMimeMessage()메서드를 제공하고 있으며, 이 메서드가 리턴한 MimeMessage 객체를 이용해서 메시지를 구성한 뒤 메일을 발송하면 된다.


#### MimeMesssageHelper를 이용한 파일 첨부

Java Mail API 의 MimeMessage를 이용하면 파일을 첨부할 수 있긴 하지만, 처리해야 할 코드가 많은데 스프링이 제공하는 MimeMessageHelper클래스를 사용하면 파일 첨부를 간단한 코드로 처리가능하다.

~~~~
MimeMessage message = mailSender.createMimeMessage();
MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "utf-8");
boolean값은 MultiPart 여부
~~~~

~~~~
public class MimeInlineNotifier {
	
	public void sendJoinMail(String email, Integer pn) {
		String title = "hihi";
		String context = "<strong>안녕하세요</strong>";
		context += ", 반갑습니다. 인증번호는 <strong>["+pn+"]</strong> 입니다.";
		context += "<br>";
		context += "<img src='http://mimgnews2.naver.net/image/117/2016/04/28/201604281925861126_1_99_20160428192603.jpg?type=w540' />";
		sendMail(email, title, context);
	}
	
	
	public void sendMail(String email, String title, String context) {
		MailSender mailSender = new MailSender();
		MimeMessage message = mailSender.createMimeMessage();
		try {
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "utf-8");
			messageHelper.setSubject(title);
			String htmlContent = context;
			messageHelper.setText(htmlContent, true);
			messageHelper.setFrom("pikachu987@naver.com", "운영자");
			messageHelper.setTo(new InternetAddress(email, "회원님"));
			mailSender.send(message);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}


~~~~