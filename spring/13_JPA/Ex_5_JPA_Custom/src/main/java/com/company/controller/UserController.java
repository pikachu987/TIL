package com.company.controller;

import javax.annotation.Resource;
import javax.transaction.Transactional;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.company.domain.Option;
import com.company.domain.User;
import com.company.repository.UserRepository;
import com.company.repository.UserRepository2;

@Controller
@RequestMapping(value="/user")
@Transactional
public class UserController {
	@Resource
	UserRepository userRepository;
	@Resource
	UserRepository2 userRepository2;
	
	@RequestMapping(value="/login" ,method=RequestMethod.GET)
	public String login(){
		Option<User> user = userRepository.getOptionUser(1);
		System.out.println(user.toString());
		
		return "user/login";
	}
}
