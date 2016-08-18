package com.company;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

public class Download extends AbstractView{
	public Download() {
		setContentType("application/download; charset=utf-8"); 
	}
	@Override
	protected void renderMergedOutputModel(Map<String, Object> arg0, HttpServletRequest arg1, HttpServletResponse arg2)
			throws Exception {
		File file = (File) arg0.get("downloadFile");
		arg2.setContentType(getContentType());
		arg2.setContentLength((int)file.length());
		
		String userAgent = arg1.getHeader("User-Agent");
		boolean ie = userAgent.indexOf("MSIE") > -1;
		String fileName = null;
		if(ie){
			fileName = URLEncoder.encode(file.getName(), "utf-8");
		}else{
			fileName = new String(file.getName().getBytes("utf-8"), "iso-8859-1");
		}
		arg2.setHeader("Content-Disposition", "attachment; filename=\""+ fileName +"\";");
		arg2.setHeader("Content-Transfer-Encoding", "binary");
		OutputStream out = arg2.getOutputStream();
		FileInputStream fis = null;
		try{
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
		}finally{
			if(fis != null)
				try{
					fis.close();
				}catch(IOException e){
					
				}
		}
		out.flush();
	}
	
}
