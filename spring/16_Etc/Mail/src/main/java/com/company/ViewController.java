package com.company;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class ViewController {
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public String view() {
		//SimpleNotifier ss = new SimpleNotifier();
		//ss.sendMail("pikachu987@naver.com", "hihi", "hihihhihi");
		//MimeInlineNotifier min = new MimeInlineNotifier();
		//min.sendJoinMail("pikachu987@naver.com", 5432);
		return "index";
	}
}
