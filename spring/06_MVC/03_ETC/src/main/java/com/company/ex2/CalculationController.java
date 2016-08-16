package com.company.ex2;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class CalculationController {
	@RequestMapping("/cal/divide")
	public String gdivide(Model model, @RequestParam("op1") int op1, @RequestParam("op2") int op2){
		model.addAttribute("result", op1/op2);
		return "cal/result";
	}
	
	@ExceptionHandler(ArithmeticException.class)
	public String handleException(){
		return "error/exception";
	}
}
