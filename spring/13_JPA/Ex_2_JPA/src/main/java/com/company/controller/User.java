package com.company.controller;

import java.util.HashMap;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.company.repository.UserRepository;

@Controller
@RequestMapping(value="/user")
public class User {
	@Resource
	UserRepository userRepository;
	
	
	@RequestMapping(value="/join" ,method=RequestMethod.GET)
	public String join(){
		return "user/join";
	}
	
	@RequestMapping(value="/join" ,method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> join_post(
			@RequestParam("id") String id,
			@RequestParam("password") String password,
			@RequestParam("nickname") String nickname,
			@RequestParam("hp") String hp
			){
		HashMap<String, Object> map = new HashMap<>();
		try{
			System.out.println(userRepository.findOne(1));
			System.out.println(userRepository.findAll());
			//userRepository.save(new com.company.domain.User(id, password, nickname, hp));
			
			System.out.println(id);
		}catch(Exception e){
			e.printStackTrace();
		}
		return map;
	}
}
