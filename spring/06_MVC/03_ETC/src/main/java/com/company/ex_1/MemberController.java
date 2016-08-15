package com.company.ex_1;

import java.util.HashMap;

import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/member")
public class MemberController {
	
	@RequestMapping(value = "/temp", method=RequestMethod.GET)
	public String registGET(){
		return "member/temp";
	}
	
	@RequestMapping(value = "/temp", method=RequestMethod.POST)
	public HashMap<String, Object> regist(@ModelAttribute("memberInfo") MemberRegistRequest memberRegReq, BindingResult bindingResult){
		new MemberRegistValidator().validate(memberRegReq, bindingResult);
		HashMap<String, Object> map = new HashMap<>();
		if(bindingResult.hasErrors()){
			map.put("error", "error");
			return map;
		}
		map.put("success", "success");
		return map;
	}
}
