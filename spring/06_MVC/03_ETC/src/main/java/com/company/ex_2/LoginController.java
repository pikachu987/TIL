package com.company.ex_2;

import javax.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.validation.Errors;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/login")
public class LoginController {
	@RequestMapping(method=RequestMethod.POST)
	public String login(@Valid LoginCommand loginCommand, Errors errors){
		if(errors.hasErrors()){
			return "";
		}
		try{
			return "";
		}catch(Exception e){
			errors.reject("invalidIdOrPassword");
			return "";
		}
	}
	
	@InitBinder
	protected void initBinder(WebDataBinder binder){
		binder.setValidator(new LoginCommandValidator());
	}
}
