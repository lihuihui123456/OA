package com.yonyou.aco.userinfo.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.io.FileUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.cap.common.util.ConfigProvider;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.entity.UserInfo;
import com.yonyou.cap.isc.user.service.IUserService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping(value = "/uploader")
public class UploaderController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	IUserService userService;
	
	@RequestMapping(value = "index")
	public ModelAndView index(HttpServletRequest request) {
		ModelAndView mv=new ModelAndView();
		String chunk = request.getParameter("chunk");
		String url = request.getParameter("url");
		mv.addObject("chunk", chunk);
		mv.addObject("url", url);
		mv.setViewName("aco/userinfo/fileUpload");
		return mv;
	}
	@RequestMapping(value = "contactsIndex")
	public ModelAndView contactIndex(HttpServletRequest request) {
		ModelAndView mv=new ModelAndView();
		String chunk = request.getParameter("chunk");
		String url = request.getParameter("url");
		mv.addObject("chunk", chunk);
		mv.addObject("url", url);
		mv.setViewName("aco/contacts/fileUpload");
		return mv;
	}
	@RequestMapping(value = "upfile")
	public void uploader(@RequestParam("file") CommonsMultipartFile file,
			HttpServletRequest request,
			HttpServletResponse response) throws IOException{
		try {
			String fileFileName=file.getOriginalFilename();
			String filePath=ConfigProvider.getPropertiesValue("config.properties", "rootPath");
			filePath=filePath+"/icon";
			File files = new File(filePath);
			DiskFileItem fi = (DiskFileItem)file.getFileItem(); 
		    File picFile = fi.getStoreLocation();
			if (!files.exists()) {
				files.mkdirs();
			}
			// 文件拷贝
			FileUtils.copyFile(picFile, new File(files,fileFileName));
			response.getWriter().write("{\"status\":true,\"newName\":\""+fileFileName+"\"}");
		} catch (Exception e) {
			logger.error("error",e);
			response.getWriter().write("{\"status\":false}");
		}
	}
	@RequestMapping(value = "upfileImg")
	public void uploaderImg(@RequestParam("file") MultipartFile file,HttpServletResponse response) throws IOException{
		try {
			String fileFileName=file.getOriginalFilename();
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			if(null != user){
				fileFileName = user.getId() + fileFileName.substring(fileFileName.lastIndexOf("."));
				String filePath=ConfigProvider.getPropertiesValue("config.properties", "rootPath");
				filePath=filePath+"/Img";
				
				File file2 = new File(filePath,fileFileName);    
	            if(!file2.exists()) {    
	                file2.mkdirs();     
	            } 
				
				file.transferTo(file2);  
				User _user = userService.findUserById(user.getId());
				user.setPicture(fileFileName);
				_user.setPicUrl(fileFileName);
				userService.doUpdateUser(_user);
				response.getWriter().write("{\"status\":true,\"newName\":\""+fileFileName+"\"}");
			}
		} catch (Exception e) {
			logger.error("error",e);
			response.getWriter().write("{\"status\":false}");
		}
	}
	
	@RequestMapping(value = "uploaderContactsImg")
	public void uploaderContactsImg(@RequestParam("file") MultipartFile file,HttpServletResponse response) throws IOException{
		try {
			String fileFileName=file.getOriginalFilename();
			//生产随机数防止
			fileFileName = UUID.randomUUID().toString() + fileFileName.substring(fileFileName.lastIndexOf("."));
			String filePath=ConfigProvider.getPropertiesValue("config.properties", "rootPath");
			
			filePath=filePath+"/Img";
			File file2 = new File(filePath,fileFileName);    
            if(!file2.exists()) {    
                file2.mkdirs();     
            } 
			file.transferTo(file2);  
			response.getWriter().write("{\"status\":true,\"newName\":\""+fileFileName+"\"}");
		} catch (Exception e) {
			logger.error("error",e);
			response.getWriter().write("{\"status\":false}");
		}
	}
	@RequestMapping(value = "uploadfile")
	public void uploaderImg(
			@RequestParam(value="bro", required=false) String browerVersion, 
			@RequestParam("pic") String fileName,
			HttpServletRequest request,
			HttpServletResponse response) throws IOException{
		try {
			if(fileName==null||"".equals(fileName)||"null".equalsIgnoreCase(fileName)){
				fileName = "default_man.png";
			}
			Map<String,String> ctMapIE = new HashMap<String,String>();
			ctMapIE.put("png","x-png");
			ctMapIE.put("jpg","jpeg");
			ctMapIE.put("jpeg","pjepg");
			ctMapIE.put("bmp","bmp");
			ctMapIE.put("gif","gif");
			ctMapIE.put("ico","x-icon");
			String filePath=ConfigProvider.getPropertiesValue("config.properties", "rootPath");
			File pic = new File(filePath + "/Img/"+  fileName);

			InputStream in=null;
			if(pic.exists()){
				in = new FileInputStream(pic);  
			}else{
				fileName = "avatar.png";
				ClassLoader cl =this.getClass().getClassLoader();
				in=cl.getResourceAsStream(fileName);


				//in = new FileInputStream(pic);
			}
			response.setHeader("Pragma", "No-cache");  
			response.setHeader("Cache-Control", "no-cache");  
			response.setDateHeader("Expires", 0L);  
			response.setHeader("Content-Length", in.available() + ""); 
			response.setContentType("image/"+ctMapIE.get(fileName.split("\\.")[1])); 
			OutputStream out = response.getOutputStream();
			byte[] b = new byte[1024]; 
			while( in.read(b)!= -1){ 
				out.write(b);    
			}
			in.close();
			out.flush();
			//out.close();
		} catch (Exception e) {
			logger.error("error",e);
		}
	}

	@RequestMapping(value = "changePicture")
	public @ResponseBody
	String changePicture(@RequestParam("picture") String picture,
			HttpServletRequest request,
			HttpServletResponse response) throws IOException{
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			if(null == user){
				return "";
			}
			User _user = userService.findUserById(user.getId());
			user.setPicture(picture);
			_user.setPicUrl(picture);
			userService.doUpdateUser(_user);
			return "true";
		} catch (Exception ex) {
			logger.error("error",ex);
			return "false";
		}
	}
	
	/**
	 * 名称：个人基本信息修改
	 * @param p
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping(value="/changeData")
	public void profileChangeSave(@Valid UserInfo u,HttpServletResponse response) throws IOException{
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(null != user){
			UserInfo userinfo = userService.findUserInfoById(user.getId());
		    userinfo.setUserName(u.getUserName());
		    userinfo.setUserSex(u.getUserSex());
		    userinfo.setUserMobile(u.getUserMobile());
		    userinfo.setUserEmail(u.getUserEmail());
		    userService.doUpdateUserInfo(userinfo);
		    response.getWriter().write("true");
			response.getWriter().flush();
		}
	}
	
}