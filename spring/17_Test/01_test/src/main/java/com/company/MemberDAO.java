package com.company;

import org.springframework.stereotype.Service;

@Service
public class MemberDAO {
	public int insert(){
		System.out.println("insert");
		return 1;
	}
	public void delete(){
		System.out.println("delete");
	}
	public int count(){
		return 22;
	}
}
