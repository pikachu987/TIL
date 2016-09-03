package com.company.ex3;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class EchoHandlerSock extends TextWebSocketHandler {
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.printf("%s 연결 됨\n",session.getId());
	}
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		System.out.printf("%s로 부터 [%s] 받음", session.getId(), message.getPayload());
		session.sendMessage(new TextMessage("echo: "+message.getPayload()));
	}
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		System.out.printf("%s 연결 끊김\n",session.getId());
	}
}
