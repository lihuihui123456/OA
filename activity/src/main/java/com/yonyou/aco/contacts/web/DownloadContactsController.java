package com.yonyou.aco.contacts.web;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yonyou.aco.contacts.entity.ContactsUserBean;
import com.yonyou.aco.contacts.service.IBizContactsService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
/**
 * <p>概述：业务模块通讯录导出Controller层
 * <p>功能：通讯录
 * <p>作者：葛鹏
 * <p>创建时间：2017年2月23日
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/DownloadContactsc")
public class DownloadContactsController {
	@Resource
	IBizContactsService service;
	
	@RequestMapping("/downloadExcelByPoi")
	@ResponseBody
	public String downloadExcelByPoi(HttpServletRequest request,HttpServletResponse response) throws IOException {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return "error";
		}
		String userIds=request.getParameter("userIds");
		String isSelectorNot=request.getParameter("isSelectorNot");
		PageResult<ContactsUserBean> pags =null;
		if(isSelectorNot.equals("")||isSelectorNot==null){
			pags = service.findUserByDept(0, Integer.MAX_VALUE, userIds,isSelectorNot);
		}else{
			String deptId=request.getParameter("hidDeptId");
			String word=request.getParameter("hidWord");
			String param=request.getParameter("hidParam");
			if("alwaysContactors".equals(deptId)){
				pags=service.findAlwaysContactors(0, Integer.MAX_VALUE, "", "", user);
			}else{
				pags = service.findUserByDept(0, Integer.MAX_VALUE, deptId, word, param);
			}
		}
//		PageResult<ContactsUserBean> pags = service.findUserByDept(0, Integer.MAX_VALUE, userIds,isSelectorNot);
		List<ContactsUserBean> list=pags.getResults();
		String filePath=service.exportContactsUserToExcelByPoi(list);
		// 这里实现下载弹出窗口那种
		File file = new File(filePath);
		if (!file.exists()) {
			response.sendError(404, "File not found!");
			return "File not found!";
		}
		BufferedInputStream br = new BufferedInputStream(new FileInputStream(
				filePath));
		String downLoadName = null;
		String agent = request.getHeader("USER-AGENT");
		if(StringUtils.contains(agent, "Chrome") || StringUtils.contains(agent, "Firefox")){	//google,火狐浏览器  
			downLoadName =  new String((file.getName()).getBytes("UTF-8"), "ISO8859-1");
		}else{
			downLoadName = URLEncoder.encode(file.getName(),"UTF8");	//其他浏览器
		}
		byte[] buf = new byte[1024];
		int len = 0;
		response.reset();
		response.setContentType("application/msexcel;charset=UTF-8");
		response.setHeader("Content-Disposition", "attachment; filename="
				+ downLoadName);
		OutputStream out = response.getOutputStream();
		while ((len = br.read(buf)) > 0) {
			out.write(buf, 0, len);
		}
		br.close();
		out.close();
		return "success";
	}
}
