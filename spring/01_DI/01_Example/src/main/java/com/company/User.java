package com.company;

public class User {
	private String id;
	private String password;
	
	
	public User(String id, String password) {
		super();
		this.id = id;
		this.password = password;
	}
	public String getId() {
		return id;
	}
	public boolean matchPassword(String password){
		return this.password.equals(password);
	}
	
	public void changePassword(String oldPassword, String newPassword){
		if(!matchPassword(oldPassword))
			throw new IllegalArgumentException("illegal password");
		password = newPassword;
	}
}
