package com.company.config;

import java.util.Properties;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.company.main3And4ExFile.Sensor;

@Configuration
public class Config_main3 {
	
	@Bean
	public Sensor sensor1(){
		Sensor s = new Sensor();
		Properties properties = new Properties();
		properties.setProperty("threshold", "1500");
		properties.setProperty("retry", "3");
		s.setAdditionalInfo(properties);
		return s;
	}
}
