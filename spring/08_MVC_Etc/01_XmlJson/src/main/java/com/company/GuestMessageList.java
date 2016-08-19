package com.company;

import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement(name="message-list")
public class GuestMessageList {
	@XmlElement(name="message")
	private List<GuestMessage> messages;
	
	public GuestMessageList() {
	}

	public List<GuestMessage> getMessages() {
		return messages;
	}

	public void setMessages(List<GuestMessage> messages) {
		this.messages = messages;
	}

	public GuestMessageList(List<GuestMessage> messages) {
		super();
		this.messages = messages;
	}
	
	
	
}
