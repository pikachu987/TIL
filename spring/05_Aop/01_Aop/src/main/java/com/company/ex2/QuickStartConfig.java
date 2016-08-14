package com.company.ex2;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

import com.company.ex2.aop.Profiler;

@Configuration
@EnableAspectJAutoProxy
public class QuickStartConfig {
	@Bean
	public Profiler performanceTraceAspect(){
		return new Profiler();
	}
}
