package com.yonyou.aco.docmgt.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yonyou.aco.docmgt.entity.BizDocInfoRefMediaBean;
import com.yonyou.aco.docmgt.service.DocMgtService;
import com.yonyou.cap.bpm.entity.BpmRuBizInfoEntity;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.sys.iweboffice.entity.IWebDocumentEntity;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/downLoadMedia")
public class DownLoadMediaController {

	@Resource
	DocMgtService docMgtService;
	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 方法: 下载正文信息.
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	
	@RequestMapping("/downLoadIweb1")
	public void downLoadIweb1(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String id = request.getParameter("id");
		IWebDocumentEntity media = docMgtService.selectIWebDocument(id);
		//BizDocInfoBean bizDocInfoBean=docMgtService.getBizDocFolderEntityById(id);
		if (media != null) {
			// 获得下载文件信息
			//通过bizId查询原文件
		    BpmRuBizInfoEntity oldActicle = bpmRuBizInfoService.findBpmRuBizInfoEntityById(media.getBizid());
			String fileName = URLEncoder.encode(oldActicle.getBizTitle_(), "UTF-8");
			String mFilePath1 = request.getSession().getServletContext().getRealPath("");       //取得服务器路径
			String path = mFilePath1.substring(0,3)+"/Document/" + media.getRecordId()+".doc";
			OutputStream o = response.getOutputStream();
			byte b[] = new byte[1024];
			// 开始下载文件
			File fileLoad = new File(path);
			response.setContentType("text/html");
			response.setHeader("Content-Disposition", "attachment;filename=" + fileName+".doc");
			long fileLength = fileLoad.length();
			String length = String.valueOf(fileLength);
			response.setHeader("Content_Length", length);
			// 下载文件
			FileInputStream in = new FileInputStream(fileLoad);
			int n = 0;
			while ((n = in.read(b)) != -1) {
				o.write(b, 0, n);
			}
			in.close();
			o.close();
		}
	}
	
	/**
	 * 方法: 下载附件信息
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	
	@RequestMapping(value = "downloadMedia")
	public void downloadMedia(HttpServletRequest request, HttpServletResponse response) throws IOException {
		try {
			String id = request.getParameter("id");
			BizDocInfoRefMediaBean media = docMgtService.getFilePath(id);
			if (media != null) {
				// 获得下载文件信息
				String fileName = URLEncoder.encode(media.getFileName(), "UTF-8");
				String path = media.getFilePath() + "/" + media.getFileId();
				OutputStream o = response.getOutputStream();
				byte b[] = new byte[1024];
				// 开始下载文件
				File fileLoad = new File(path);
				response.setContentType("text/html");
				response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
				long fileLength = fileLoad.length();
				String length = String.valueOf(fileLength);
				response.setHeader("Content_Length", length);
				// 下载文件
				FileInputStream in = new FileInputStream(fileLoad);
				int n = 0;
				while ((n = in.read(b)) != -1) {
					o.write(b, 0, n);
				}
				in.close();
				o.close();
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
	}
	
	/**
	 * 方法: 下载附件信息
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	
	@RequestMapping(value = "downloadMedia1")
	public void downloadMedia1(HttpServletRequest request, HttpServletResponse response) throws IOException {
     try{
    	 String id = request.getParameter("id");
 		IWebDocumentEntity media = docMgtService.selectIWebDocument(id);
 		if (media != null) {
 			// 获得下载文件信息
 			String fileName = URLEncoder.encode(media.getFileName(), "UTF-8");
 			String path = media.getHtmlPath() + "/" + media.getRecordId();
 			OutputStream o = response.getOutputStream();
 			byte b[] = new byte[1024];
 			// 开始下载文件
 			File fileLoad = new File(path);
 			response.setContentType("text/html");
 			response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
 			long fileLength = fileLoad.length();
 			String length = String.valueOf(fileLength);
 			response.setHeader("Content_Length", length);
 			// 下载文件
 			FileInputStream in = new FileInputStream(fileLoad);
 			int n = 0;
 			while ((n = in.read(b)) != -1) {
 				o.write(b, 0, n);
 			}
 			in.close();
 			o.close();
 		}
    	 
     }catch(Exception e){
    	 logger.error("error",e);
     }
		
	}
	
}
