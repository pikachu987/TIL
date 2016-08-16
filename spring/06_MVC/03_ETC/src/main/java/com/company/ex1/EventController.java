package com.company.ex1;

import java.sql.Date;
import java.text.SimpleDateFormat;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/event")
public class EventController {

	@InitBinder
	protected void initBinder(WebDataBinder binder){
//		CustomDateEditor dateEditor = new CustomDateEditor(new SimpleDateFormat("yyyyMMdd"), true);
//		binder.registerCustomEditor(Date.class, dateEditor);
		
		CustomDateEditor dateEditor1 = new CustomDateEditor(new SimpleDateFormat("yyyyMMdd"), true);
		binder.registerCustomEditor(Date.class, "from", dateEditor1);
		
		CustomDateEditor dateEditor2 = new CustomDateEditor(new SimpleDateFormat("HH:mm"), true);
		binder.registerCustomEditor(Date.class, "reserveTime", dateEditor2);
	}
	
	@RequestMapping("/list")
	public String list(SearchOption option, Model model){
		
		
		return "";
	}
}
