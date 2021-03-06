package com.company;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ViewController {
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public String view() {
		return "index";
	}
	
	@RequestMapping(value="/simple", method=RequestMethod.POST)
	@ResponseBody
	public String simple(@RequestBody String body){
		return body;
	}
	
	@RequestMapping(value="/list.xml", method=RequestMethod.GET)
	@ResponseBody
	public GuestMessageList simpleXml(){
		return getMessageList();
	}
	
	private GuestMessageList getMessageList(){
		List<GuestMessage> messages = Arrays.asList(
				new GuestMessage(1, "가나다", new Date()),
				new GuestMessage(2, "abc", new Date()),
				new GuestMessage(3, "qwe", new Date()),
				new GuestMessage(4, "435", new Date()),
				new GuestMessage(5, "ㅇㅇ", new Date()),
				new GuestMessage(6, "ㅈㄸ", new Date())
				);
		
		return new GuestMessageList(messages);
	}
	
	
	@RequestMapping(value="/list.json", method=RequestMethod.GET)
	@ResponseBody
	public GuestMessageList2 simpleJson(){
		return getMessageList2();
	}
	
	private GuestMessageList2 getMessageList2(){
		List<GuestMessage> messages = Arrays.asList(
				new GuestMessage(1, "가나다", new Date()),
				new GuestMessage(2, "abc", new Date()),
				new GuestMessage(3, "qwe", new Date()),
				new GuestMessage(4, "435", new Date()),
				new GuestMessage(5, "ㅇㅇ", new Date()),
				new GuestMessage(6, "ㅈㄸ", new Date())
				);
		
		return new GuestMessageList2(messages);
	}
	
}
