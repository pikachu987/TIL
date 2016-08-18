package com.company;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ViewController implements ApplicationContextAware {
	private WebApplicationContext context = null;
	
	@Override
	public void setApplicationContext(ApplicationContext applicationContext)
			throws BeansException {
		this.context = (WebApplicationContext) applicationContext;
	}
	
	@RequestMapping(value="/download", method=RequestMethod.GET)
	public ModelAndView download(HttpServletResponse response) throws IOException {
		File downloadFile = new File(context.getServletContext().getRealPath("/WEB-INF/files"), "객체지향JCO14회.zip");
		return new ModelAndView("download", "downloadFile", downloadFile);
	}
	
	@RequestMapping("/excelDownload")
	public String pageRank(Model model) {
		List<PageRank> pageRanks = Arrays.asList(
				new PageRank(1, "/board/humor/1011"),
				new PageRank(2, "/board/notice/12"),
				new PageRank(3, "/board/phone/190")
				);
		model.addAttribute("pageRankList", pageRanks);
		return "pageRank";
	}
	
	@RequestMapping("/pdf")
	public String pageRankReport(Model model) {
		List<PageRank> pageRanks = Arrays.asList(
				new PageRank(1, "/board/humor/1011"),
				new PageRank(2, "/board/notice/12"),
				new PageRank(3, "/board/phone/190")
				);
		model.addAttribute("pageRankList", pageRanks);
		return "pdf";
	}
}
