package com.company;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.PropertySources;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.core.io.ClassPathResource;

@Configuration	
//@PropertySources(@PropertySource("classpath:/db.properties"))
public class Ex_7_Config {
	@Value("${db.driver}")
	private String driver;
	@Value("${db.jdbcUrl}")
	private String jdbcUrl;
	@Value("${db.user}")
	private String user;
	@Value("${db.password}")
	private String password;
	
	@Bean
	public static PropertySourcesPlaceholderConfigurer properties(){
		PropertySourcesPlaceholderConfigurer configurer = new PropertySourcesPlaceholderConfigurer();
		configurer.setLocation(new ClassPathResource("db.properties"));
		return configurer;
	}
	
	@Bean(initMethod="init")
	public Ex_6_ConnectionProvider connectionProvider(){
		Ex_6_ConnectionProvider cp = new Ex_6_ConnectionProvider();
		cp.setDriver(driver);
		cp.setDriver(jdbcUrl);
		cp.setDriver(user);
		cp.setDriver(password);
		return cp;
	}
}
