package com.company;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.AsyncRestTemplate;
import org.springframework.web.client.RestTemplate;

@Controller
@RequestMapping(value="/")
public class ViewController {
	@RequestMapping(value="view", method=RequestMethod.GET)
	public String view() {
		RestTemplate restTemplate = new RestTemplate();
		String body = restTemplate.getForObject("http://www.daum.net", String.class);
		System.out.println(body);
		
		
		String response = restTemplate.getForObject("http://localhost:8080/RestTemplate/view/hihi", String.class);
		System.out.println(response);
		
		
		
		AsyncRestTemplate asyncTemplate = new AsyncRestTemplate();
		ListenableFuture<ResponseEntity<String>> future = asyncTemplate.getForEntity("http://www.daume.net", String.class);
		future.addCallback(new ListenableFutureCallback<ResponseEntity<String>>() {

			@Override
			public void onFailure(Throwable arg0) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void onSuccess(ResponseEntity<String> arg0) {
				String content = arg0.getBody();
				System.out.println(content.substring(0, 50));
			}
		
		});
		
		return "index";
	}
	
	@RequestMapping(value="view/{value}", method=RequestMethod.GET)
	@ResponseBody
	public HashMap<String, Object> view(HttpServletRequest request, @PathVariable("value") String value) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("value", value);
		map.put("code", 1);
		map.put("msg", "성공");
		return map;
	}
}
