package config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.company.ex1.EchoHandler;
import com.company.ex2.ChatWebSocketHandler;

@Configuration
@EnableWebSocket
public class WsConfig implements WebSocketConfigurer {

	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		//ex1
		registry.addHandler(echoHandler(), "/echo-ws");
		//ex2
		registry.addHandler(chatHandler(), "/chat-ws");
		//ex3
		registry.addHandler(echoHandler(), "/echo.sockjs").withSockJS();
		//ex4
		registry.addHandler(chatHandler(), "/chat.sockjs").withSockJS();
	}

	@Bean
	public EchoHandler echoHandler() {
		return new EchoHandler();
	}
	
	@Bean
	public ChatWebSocketHandler chatHandler() {
		return new ChatWebSocketHandler();
	}

}
