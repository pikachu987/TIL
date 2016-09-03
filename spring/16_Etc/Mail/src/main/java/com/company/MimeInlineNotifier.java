package com.company;

import java.util.Properties;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

class MailSender extends JavaMailSenderImpl {
	public MailSender() {
		this.setHost("smtp.naver.com");
		this.setPort(587);
		this.setUsername("pikachu987");
		this.setPassword("950504rl!@#");
		Properties prop = new Properties();
		prop.setProperty("mail.smtp.ssl.trust", "smtp.naver.com");
		prop.setProperty("mail.smtp.starttls.enable", "true");
		prop.setProperty("mail.smtp.auth", "true");
		this.setJavaMailProperties(prop);
	}
}

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