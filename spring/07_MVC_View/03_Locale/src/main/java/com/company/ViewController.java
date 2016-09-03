package com.company;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.LocaleResolver;

@Controller
public class ViewController {
	
	@Autowired
	private LocaleResolver localeResolver;
	
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public String view() {
		return "index";
	}
	
	@RequestMapping(value="/view/{language}", method=RequestMethod.GET)
	public String view_language(@PathVariable("language") String language, HttpServletRequest request, HttpServletResponse response){
		Locale locale = new Locale(language);
		System.out.println(locale.getLanguage());
		System.out.println(locale.getCountry());
		localeResolver.setLocale(request, response, locale);
		return "locale";
	}
}