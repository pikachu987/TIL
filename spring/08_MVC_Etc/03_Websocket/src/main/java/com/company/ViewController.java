package com.company;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class ViewController {
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public String view() {
		return "index";
	}
	
	@RequestMapping(value="/ex1", method=RequestMethod.GET)
	public String ex1() {
		return "ex1";
	}
	
	@RequestMapping(value="/ex2", method=RequestMethod.GET)
	public String ex2() {
		return "ex2";
	}
	
	@RequestMapping(value="/ex3", method=RequestMethod.GET)
	public String ex3() {
		return "ex3";
	}
	
	@RequestMapping(value="/ex4", method=RequestMethod.GET)
	public String ex4() {
		return "ex4";
	}
}
