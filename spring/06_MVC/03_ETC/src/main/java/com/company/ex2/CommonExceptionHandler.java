package com.company.ex2;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice("com.company")
public class CommonExceptionHandler {
	@ExceptionHandler(RuntimeException.class)
	public String handleRuntimeExceptiono(){
		return "error/commonException";
	}
}
