package com.company;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.Part;

import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
public class ViewController {
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public String view() {
		return "index";
	}
	
	@RequestMapping(value="/view/upload1", method=RequestMethod.POST)
	public String upload1(@RequestParam("file") MultipartFile part) throws IOException {
		System.out.println(part.getSize());
		byte[] bytes = part.getBytes();
		File file = new File("/Users/guanho/Desktop", part.getOriginalFilename());
		FileCopyUtils.copy(bytes, file);
		return "index";
	}
	
	@RequestMapping(value="/view/upload2", method=RequestMethod.POST)
	public String upload2(@RequestParam("file") MultipartFile part) throws IOException {
		if(!part.isEmpty()){
			File file = new File("/Users/guanho/Desktop", part.getOriginalFilename());
			part.transferTo(file);
		}
		return "index";
	}
	
	
	@RequestMapping(value="/view/upload3", method=RequestMethod.POST)
	public String upload3(MultipartHttpServletRequest request) throws IOException {
		List<MultipartFile> parts = request.getFiles("file");
		for(MultipartFile part : parts){
			if(!part.isEmpty()){
				File file = new File("/Users/guanho/Desktop", part.getOriginalFilename());
				part.transferTo(file);
			}
		}
		return "index";
	}
	
	@RequestMapping(value="/view/upload4", method=RequestMethod.POST)
	public String upload4(@RequestParam("name") Part part) throws IOException {
		if(part.getSize() > 0){
			File file = new File("/Users/guanho/Desktop", getFileName(part));
			FileCopyUtils.copy(part.getInputStream(), new FileOutputStream(file));
		}
		return "index";
	}
	private String getFileName(Part part) {
		for (String cd : part.getHeader("Content-Disposition").split(";")) {
			if (cd.trim().startsWith("filename")) {
				return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
			}
		}
		return null;
	}
}
