package com.company.controller;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.domain.Sort.Order;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.company.domain.User;
import com.company.repository.UserRepository;

@Controller
@RequestMapping(value="/user")
public class UserController {
	@Resource
	UserRepository userRepository;
	
	
	@RequestMapping(value="/user" ,method=RequestMethod.GET)
	public String user(){
		return "user/user";
	}
	@RequestMapping(value="/list/{page}" ,method=RequestMethod.GET)
	public String list(@PathVariable("page") Integer page, HttpServletRequest request){
		int pageValue = page-1;
		System.out.println(pageValue);
		Pageable pageable = new PageRequest(pageValue, 5);
		List<User> list = userRepository.findBySeqGreaterThan(0, pageable);
		request.setAttribute("list", list);
		System.out.println(list);
		System.out.println(list.size());
		for(User user : list){
			System.out.println(user);
		}
		return "user/list";
	}
	
	@RequestMapping(value="/list/{page}/{id}" ,method=RequestMethod.GET)
	public String list(@PathVariable("page") Integer page,@PathVariable("id") String id, HttpServletRequest request){
		User user = userRepository.findById(id);
		request.setAttribute("user", user);
		return "user/get";
	}
	
	
	
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
			int count = userRepository.countByIdAndNickname(id, nickname);
			if(count > 0){
				map.put("code", -1);
			}else{
				//userRepository.save(new User(id, password, nickname, hp));
				map.put("code", 0);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return map;
	}
}
