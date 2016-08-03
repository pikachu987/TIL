package com.company.domain;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="user")
public class User {
	@Id
	@GeneratedValue
	private Integer seq;
	private String id;
	private String password;
	private String nickname;
	private String hp;
	public Integer getSeq() {
		return seq;
	}
	public String getId() {
		return id;
	}
	public String getPassword() {
		return password;
	}
	public String getNickname() {
		return nickname;
	}
	public String getHp() {
		return hp;
	}
	public User(){}
	
	public User(Integer seq, String id, String password, String nickname, String hp) {
		super();
		this.seq = seq;
		this.id = id;
		this.password = password;
		this.nickname = nickname;
		this.hp = hp;
	}
	public User(String id, String password, String nickname, String hp) {
		super();
		this.id = id;
		this.password = password;
		this.nickname = nickname;
		this.hp = hp;
	}
	
	
}
