package com.company;

import org.springframework.context.EnvironmentAware;
import org.springframework.core.env.Environment;

public class Ex_4_ConnectionProvider implements EnvironmentAware{
	private String driver;
	private String user;
	private String password;
	private String url;
	private Environment env;
	@Override
	public void setEnvironment(Environment environment) {
		// TODO Auto-generated method stub
		this.env = environment;
	}
	public void init(){
		driver = this.env.getProperty("db.driver");
		user = this.env.getProperty("db.user");
		password = this.env.getProperty("db.password");
		url = this.env.getProperty("db.url");
	}
	
}
