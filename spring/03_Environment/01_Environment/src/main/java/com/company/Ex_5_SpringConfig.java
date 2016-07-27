package com.company;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;

public class Ex_5_SpringConfig{
	@Autowired
	private Environment env;
	
	@Bean(initMethod="init")
	public ConnectionProvider2 init(){
		ConnectionProvider2 connectionProvider = new ConnectionProvider2();
		connectionProvider.setDriver(env.getProperty("db.driver"));
		connectionProvider.setUrl(env.getProperty("db.url"));
		connectionProvider.setUser(env.getProperty("db.user"));
		connectionProvider.setPassword(env.getProperty("db.password"));
		return connectionProvider;
	}
	
}

class ConnectionProvider2{
	private String driver;
	private String user;
	private String password;
	private String url;
	public String getDriver() {
		return driver;
	}
	public void setDriver(String driver) {
		this.driver = driver;
	}
	public String getUser() {
		return user;
	}
	public void setUser(String user) {
		this.user = user;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
}