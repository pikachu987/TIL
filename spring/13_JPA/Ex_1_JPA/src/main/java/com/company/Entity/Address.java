package com.company.Entity;

import javax.persistence.Embeddable;

@Embeddable
public class Address {
	private String addr1;
	private String addr2;
	
	protected Address(){
		
	}

	public String getAddr1() {
		return addr1;
	}

	public String getAddr2() {
		return addr2;
	}

	public Address(String addr1, String addr2) {
		super();
		this.addr1 = addr1;
		this.addr2 = addr2;
	}
	
}
