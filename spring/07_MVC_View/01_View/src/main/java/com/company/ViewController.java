package com.company;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/view")
public class ViewController {
	@RequestMapping(value="/index", method=RequestMethod.GET)
	public ModelAndView view(@ModelAttribute("loginCommand") LoginCommand loginCommand){
		loginCommand.setSecurityLevel(SecurityLevel.HIGH);
		ModelAndView mav = new ModelAndView("index");
		return mav;
	}
	
	
	@ModelAttribute("loginTypes")
	protected List<String> loginType() throws Exception{
		List<String> loginTypes = new ArrayList<>();
		loginTypes.add("가가");
		loginTypes.add("나나");
		loginTypes.add("다다");
		return loginTypes;
	}
	
	@ModelAttribute("favorityHobby")
	protected List<Hobby> hobby() throws Exception{
		
		List<Hobby> favorityHobby = Arrays.asList(
				new Hobby(1, "축구"),
				new Hobby(2, "야구"),
				new Hobby(3, "농구"),
				new Hobby(4, "배구"),
				new Hobby(5, "테니스")
				);
		
		return favorityHobby;
	}
	@ModelAttribute("favoriteOsNames")
	public List<String> favoriteOs() {
		return Arrays.asList("윈도우XP", "윈도우7", "윈도우8", "맥OS", "우분투");
	}
	
	@ModelAttribute("sex")
	public List<String> sex() {
		return Arrays.asList("남성", "여성");
	}
	
	
	@InitBinder
	protected void initBinder(WebDataBinder binder) {
		binder.setValidator(new LoginCommandValidator());
	}
}
