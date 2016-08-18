package com.company;

public class Hobby {
	private int key;
	private String hobby;
	public int getKey() {
		return key;
	}
	public void setKey(int key) {
		this.key = key;
	}
	public String getHobby() {
		return hobby;
	}
	public void setHobby(String hobby) {
		this.hobby = hobby;
	}
	public Hobby(int key, String hobby) {
		super();
		this.key = key;
		this.hobby = hobby;
	}
	
}
