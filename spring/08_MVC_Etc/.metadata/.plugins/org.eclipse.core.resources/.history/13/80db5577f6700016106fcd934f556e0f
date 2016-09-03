package com.company.ex2;

import java.util.Date;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class ChatWebSocketHandler extends TextWebSocketHandler {
	private Map<String, WebSocketSession> users = new ConcurrentHashMap<>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.println(new Date()+" : "+session.getId()+" 연결");
		users.put(session.getId(), session);
	}
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		System.out.println(new Date()+" : "+session.getId()+" 메시지수신 : "+message.getPayload());
		for(WebSocketSession ws : users.values()){
			ws.sendMessage(message);
			System.out.println(new Date()+" : "+ws.getId()+" 에게 메시지발신 : "+message.getPayload());
		}
	}
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		System.out.println(new Date()+" : "+session.getId()+" 연결 종료");
		users.remove(session.getId());
	}
	
	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		System.out.println(new Date()+" : "+session.getId()+" 익셉션 : "+exception.getMessage());
	}
}
