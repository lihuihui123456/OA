package com.yonyou.aco.word.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springside.modules.utils.PropertiesLoader;

import com.yonyou.aco.word.utils.PDFBinaryUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * ClassName: WordController
 * 
 * @Description: 业务功能模块word操作(导出；打印)
 * @author hegd
 * @date 2016-8-24
 */
@Controller
@RequestMapping(value = "/pdfController")
public class PdfController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@RequestMapping("/pdf")
	public String pdf() {
		return "aco/pdf/pdf";
	}

	/**
	 * 获取Pdf文件流
	 * 
	 * @param bizId
	 * @return
	 */
	@RequestMapping("/getPdfBufferByBizId")
	@ResponseBody
	public String getPdfBufferByBizId(String bizId) {
		PDFBinaryUtil pdfUtil = new PDFBinaryUtil();
		// TODO 通过bizId获取保存后的PDF文件路径（服务器路径）
		String filePath = "F:/test/a.pdf";
		File file = new File(filePath);
		String res = pdfUtil.getPDFBinary(file);
		System.out.println(res);
		return res;
	}
	
	/**
	 * 方法: 跳转到pdf页面.
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/toPdf")
	public String toPdf(HttpServletRequest request, HttpServletResponse response){
		String filePath=request.getParameter("filePath");
		filePath="";
		return "redirect:/views/aco/pdf/web/viewer.jsp?filePath='"+filePath+"'";
	}

	@RequestMapping("/getPdf")
	public void getPdf(HttpServletRequest request, HttpServletResponse response) {
		String filePath=request.getParameter("filePath");
		String mfilePath = new PropertiesLoader("config.properties").getProperty("rootPath");
		FileInputStream fin = null;
		OutputStream out = null;
		response.setHeader("Pragma", "No-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expires", 0L);
		response.setContentType("application/pdf");
		try {
			out = response.getOutputStream();
			if(StringUtils.isNotBlank(filePath)){
			}else{
				filePath=mfilePath+"/document/PDF/0000000.pdf";
			}
			
			File file = new File(filePath);
			if(file.exists()) {
				fin = new FileInputStream(file);
				byte[] b = new byte[1024];
				while (fin.read(b) != -1) {
					out.write(b);
				}
			}else {
				String tempFilePath = request.getSession().getServletContext().getRealPath("")+"/views/cap/iweb/iwebpdf/temp.pdf";
				fin = new FileInputStream(tempFilePath);
				byte[] b = new byte[1024];
				while (fin.read(b) != -1) {
					out.write(b);
				}
			}
			out.flush();
		} catch (FileNotFoundException e) {
			logger.error("error",e);
		} catch (IOException e) {
			logger.error("error",e);
		} finally {
			if(fin != null) {
				try {
					fin.close();
				} catch (IOException e) {
					logger.error("error",e);
				}
			}
			if(out != null) {
				try {
					out.close();
				} catch (IOException e) {
					logger.error("error",e);
				}
			}
		}
		/*if(!file.exists()) {
			file = new File();
		}
		FileInputStream fin = null;
		OutputStream out = null;
		try {
			fin = new FileInputStream(filePath);
			response.setHeader("Pragma", "No-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setDateHeader("Expires", 0L);
			response.setContentType("application/pdf");
			out = response.getOutputStream();
			byte[] b = new byte[1024];
			while (fin.read(b) != -1) {
				out.write(b);
			}
			out.flush();
		} catch (FileNotFoundException e) {
			logger.error("error",e);
		} catch (IOException e) {
			logger.error("error",e);
		} finally {
			try {
				fin.close();
			} catch (IOException e) {
				logger.error("error",e);
			}
		}*/
	}
}
