package com.yonyou.jjb.usermanager.web;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;





import com.yonyou.cap.common.util.ConfigProvider;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.jjb.usermanager.entity.UserInfoEntity;
import com.yonyou.jjb.usermanager.service.IUserManagerService;


/**
 * TODO: 人事管理findAllUser
 * TODO: 填写Class详细说明 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年10月10日
 * @author 申浩
 * @since 1.0.0
 */
@Controller
@RequestMapping("/userManager")
public class UserManagerController {
	@Resource
	private IUserManagerService userManagerService;
	PageResult<UserInfoEntity> pags=null;
	/**
	 * 名称: 跳转到人员管理页 
	 * @return
	 */
	@RequestMapping("/toUserMList")
	public String toUserMList() {
		return "/jjb/usermgr/userlist";
	}
	
	/**
	 * 获取所有人员信息
	 * 备注：原方法名称（getAllData）
	 * @param pagen
	 * @param rows
	 * @param roomName
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/findAllUser")
	public Map<String, Object> findAllUser(@RequestParam(value = "page", defaultValue = "0") int pageNum,
			@RequestParam(value = "rows", defaultValue = "10") int pageSize,
			@RequestParam(value = "userName", defaultValue = "") String userName,
			@RequestParam(value = "userAge", defaultValue = "") String userAge,
			@RequestParam(value = "userSex", defaultValue = "") String userSex,
			@RequestParam(value = "deptName", defaultValue = "") String deptName,
			@RequestParam(value = "postName", defaultValue = "") String postName,
			@RequestParam(value = "entryTime", defaultValue = "") String entryTime,
			@RequestParam(value = "userDutyTyp", defaultValue = "") String userDutyTyp) {
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			
			userName = new String(userName.getBytes("iso-8859-1"), "utf-8");
			userAge = new String(userAge.getBytes("iso-8859-1"), "utf-8");
			deptName = new String(deptName.getBytes("iso-8859-1"), "utf-8");
			postName = new String(postName.getBytes("iso-8859-1"), "utf-8");
			entryTime = new String(entryTime.getBytes("iso-8859-1"), "utf-8");	
			pags = userManagerService.findAllUserInfo(pageNum, pageSize,userName,userAge,deptName,postName,entryTime,userSex,userDutyTyp);	
			map.put("total", pags.getTotalrecord());
			map.put("rows", pags.getResults());
			return map;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 名称: 查询人员信息
	 * 说明: 通过主键查询人员信息
	 * 备注：原方法名（getDataById）
	 * @param id
	 * @return
	 */
	@RequestMapping("/findUserInfoByUserId/{userId}")
	public @ResponseBody UserInfoEntity findUserInfoByUserId(@PathVariable String userId){
		UserInfoEntity userInfo = new UserInfoEntity();
		try {
			userInfo = userManagerService.findUserInfoByUserId(userId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return userInfo;
	}

	/**
	 * 添加人员信息
	 * 备注：原方法名（addMeetingRoom）
	 * @param mr
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("/doAddUserInfo")
	public void doAddUserInfo(@Valid UserInfoEntity ui,HttpServletResponse response) throws IOException {
		try {
			if(StringUtils.isNotEmpty(ui.getUserName())){
				ui.setUserId(null);
				String date = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
				ui.setTs(date);
			    if(ui.getUserBitrth()!=null){
			 	  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
			 	   /*  String userBirth=ui.getUserBitrth();
			    	  Date beginDate=format.parse(userBirth);*/
			 	      Date beginDate=ui.getUserBitrth();
				      Date endDate=format.parse(date);
				      Long day=(endDate.getTime()-beginDate.getTime())/(24*3600*1000);
				      Long year=day/365;
				      ui.setUserAge(String.valueOf(year));			      
				}
			    String deptid=ui.getDeptId();
			    ui.setDeptCode(userManagerService.findDeptCodeById(deptid));
			    String postid=ui.getPostId();
			    ui.setPostCode(userManagerService.findPostCodeById(postid));
			    ui.setUserCreateTime(date);
				ui.setUserSource("1");
				ui.setDr("N");
				userManagerService.doAddUserInfo(ui);
				// 另外一种response返回json
				response.getWriter().write("true");
				response.getWriter().flush();
			}else{
				response.getWriter().write("warn");
				response.getWriter().flush();
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("false");
			response.getWriter().flush();
		}
		
	}

	/**
	 * 修改人员信息
	 * 备注：原方法名（doUpdateUserInfo）
	 * @param mr
	 * @return
	 * @throws IOException
	 */
	@ResponseBody
	@RequestMapping("/doUpdateUserInfo")
	public void doUpdateUserInfo(@Valid UserInfoEntity ui,HttpServletResponse response) throws IOException {
		try {
			 String date = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
			 ui.setDr("N");
			// UserInfoEntity userInfo = userManagerService.findUserInfoByUserId(ui.getUserId());
			 if(ui.getUserBitrth()!=null){
		    	  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
		    	 /* String userBirth=ui.getUserBitrth();
		    	  Date beginDate=format.parse(userBirth);*/
		    	  Date beginDate=ui.getUserBitrth();
			      Date endDate=format.parse(date);
			      Long day=(endDate.getTime()-beginDate.getTime())/(24*3600*1000);
			      Long year=day/365;
			      ui.setUserAge(String.valueOf(year));			      
			}
			    String deptid=ui.getDeptId();
			    ui.setDeptCode(userManagerService.findDeptCodeById(deptid));
			    String postid=ui.getPostId();
			    ui.setPostCode(userManagerService.findPostCodeById(postid));
			userManagerService.doUpdateUserInfo(ui);
			response.getWriter().write("true");
			response.getWriter().flush();
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("false");
			response.getWriter().flush();
		}
	}

	/**
	 * 根据id删除人员
	 * 备注：原方法名（delMeetingRoom）
	 * @param userid
	 *            多个id拼成的字符串以 , 分割
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/doDelUserInfo")
	public int doDelUserInfo(@RequestParam(value = "ids[]") String[] ids) {
		int count = 0;
		String userid="";
		try {
			if (ids != null && ids.length != 0) {
				for (int i = 0; i < ids.length; i++){
					userid=ids[i];
					userManagerService.doDelUserInfo(userid);	
				}							     
			}
		} catch (Exception e) {
			e.printStackTrace();
			count=1;
		}
		return count;
	}
	
	@RequestMapping(value = "openUploadWindow")
	public ModelAndView index(HttpServletRequest request) {
		ModelAndView mv=new ModelAndView();
		String chunk = request.getParameter("chunk");
		String url = request.getParameter("url");
		mv.addObject("chunk", chunk);
		mv.addObject("url", url);
		mv.setViewName("jjb/usermgr/fileUpload");
		return mv;
	}
	
	@RequestMapping(value = "uploadImg")
	public void uploaderImg(@RequestParam("file") MultipartFile file,HttpServletResponse response) throws IOException{
		try {
			String fileFileName=file.getOriginalFilename();
			Date date = new Date();
			fileFileName =date.getTime()+fileFileName.substring(fileFileName.lastIndexOf("."));
			String filePath=ConfigProvider.getPropertiesValue("config.properties", "rootPath");
			filePath=filePath+"/Img";
			
			File file2 = new File(filePath,fileFileName);    
            if(!file2.exists()) {    
                file2.mkdirs();     
            } 
			file.transferTo(file2);  
			response.getWriter().write("{\"status\":true,\"newName\":\""+fileFileName+"\"}");
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("{\"status\":false}");
		}
	}
	
	/**
	 * 
	 * @Description: 导出用户信息 Excel格式
	 * @param @param request
	 * @param @param response
	 * @param @return
	 * @param @throws IOException
	 * @return HSSFWorkbook
	 * @throws
	 * @author shenhao
	 * @date 2016-10-10
	 */
	@RequestMapping("/exportUserInfoToExcel/{myArr}")
	public void exportUserInfoToExcel(HttpServletRequest request,
			@PathVariable String myArr,
			HttpServletResponse response) throws IOException {	
		myArr = java.net.URLDecoder.decode(myArr,"UTF-8");
		myArr = java.net.URLDecoder.decode(myArr,"UTF-8");
		String[] arr = myArr.split("&");
		String[] params = new String[7];
		for (int i = 0; i < arr.length; i++) {
			params[i] = arr[i];
		}
		String userName = params[0];
		String userAge = params[1];
		String userSex = params[2];
		String deptName = params[3];
		String postName = params[4];
		String entryTime = params[5];
		String userDutyTyp = params[6];		
		String filePath = userManagerService.exportUserInfoToExcel(userName,userAge,deptName,postName,
				 entryTime,userSex,userDutyTyp);
		// 这里实现下载弹出窗口那种
		File file = new File(filePath);
		if (!file.exists()) {
			response.sendError(404, "File not found!");
			return;
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
	}
	@RequestMapping("/toUserPage")
	public ModelAndView toUserPage(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		UserInfoEntity userInfo = new UserInfoEntity();
		String userType = request.getParameter("userType");
		String userId = request.getParameter("userId");
		String edittype = request.getParameter("edittype");
		if(StringUtils.isNotEmpty(userId)){
			userInfo = userManagerService.findUserInfoByUserId(userId);
		}
		if("".equals(userInfo.getPicUrl())){
			userInfo.setPicUrl("default_man.png");
		}
		if(userInfo.getUserBitrth()!=null){
			String formatDate = DateUtil.formatDate(userInfo.getUserBitrth(), "yyyy-MM-dd");		
			userInfo.setUserBitrthStr(formatDate);
		}
		mv.addObject("userInfo", userInfo);
		if("0".equals(userType)){
			mv.setViewName("/jjb/usermgr/userinfo");
		}else if("1".equals(userType)){
			mv.setViewName("/jjb/usermgr/juserinfo");
		}else if("2".equals(userType)){
			mv.setViewName("/jjb/usermgr/userinfo");
		}else if("5".equals(userType)){
			mv.setViewName("/jjb/usermgr/suserinfo");
		}
		mv.addObject("edittype", edittype);
		return mv;
	}
}
