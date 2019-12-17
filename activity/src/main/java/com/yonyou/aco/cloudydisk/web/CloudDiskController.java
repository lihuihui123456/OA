package com.yonyou.aco.cloudydisk.web;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springside.modules.utils.PropertiesLoader;

import com.yonyou.aco.cloudydisk.entity.CloudAuthNode;
import com.yonyou.aco.cloudydisk.entity.CloudFileEntity;
import com.yonyou.aco.cloudydisk.entity.CloudLogEntity;
import com.yonyou.aco.cloudydisk.service.ICloudDiskService;
import com.yonyou.aco.cloudydisk.service.ICloudLogService;
import com.yonyou.aco.cloudydisk.util.MergeFileUtil;
import com.yonyou.aco.cloudydisk.util.ZipUtils;
import com.yonyou.cap.common.audit.operatelog.annotation.AroundAspect;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * <p>概述：业务模块办公云盘controller层
 * <p>功能：1.个人办公云存储 2.共享
 * <p>作者：葛鹏
 * <p>创建时间：2017年3月10日
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/clouddiskc")
public class CloudDiskController {
	@Resource
	ICloudDiskService service;
	@Resource
	ICloudLogService log;
	
	public static final String FileDir = "uploadfile/";  

	@RequestMapping("/initialData")
	@AroundAspect(description="办公云盘-跳转办公云盘操作页面")
	public ModelAndView initialData(){
		ModelAndView mv=new ModelAndView();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return mv;
		}
		StringBuilder tree=new StringBuilder("["+service.findCloudFolder(user));
 		tree.append("]");
		mv.addObject("tree", tree);
		mv.setViewName("/aco/clouddisk/clouddisk");
		return mv;
	}
	@RequestMapping("/initTree")
	@AroundAspect(description="办公云盘-加载文件目录树形结构")
	public @ResponseBody String initTree(){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return null;
		}
		StringBuilder tree=new StringBuilder("["+service.findCloudFolder(user));
 		tree.append("]");
		return tree.toString();
	}
	@RequestMapping("/addFolder")
	@ResponseBody
	@AroundAspect(description="办公云盘-新增文件夹")
	public CloudFileEntity addFolder(
			@RequestParam(value = "folderName", defaultValue = "") String folderName,
			@RequestParam(value = "parentFolderId", defaultValue = "") String parentFolderId,
			@RequestParam(value = "filetype", defaultValue = "") String filetype,
			@RequestParam(value = "fileAttr", defaultValue = "") String fileAttr,
			@RequestParam(value = "authorityUserId", defaultValue = "") String authorityUserId
			){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return null;
		}
		return service.addFolder(folderName, parentFolderId, filetype,fileAttr, user,authorityUserId);
	}
	@RequestMapping(value = "beforeAddFolder")
	@AroundAspect(description="办公云盘-新增文件夹前校验文件名是否存在")
	public @ResponseBody String beforeAddFolder(
			@RequestParam(value = "folderName", defaultValue = "") String folderName,
			@RequestParam(value = "parentFolderId", defaultValue = "") String parentFolderId,
			HttpServletResponse response) throws IOException  {
		List<CloudFileEntity> list=service.beforeAddFolder(folderName,parentFolderId);
		if(list.size()>0){
			return "{\"status\":false}";
		}else{
			return "{\"status\":true}";
		}
	}
	
	@RequestMapping("/delFile")
	@ResponseBody
	@AroundAspect(description="办公云盘-删除文件或文件夹")
	public String delFile(@RequestParam(value = "fileId", defaultValue = "") String fileId){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return null;
		}
		if(!service.beforeDelFolder(fileId)){
			return "{result:\"error\",reMsg:\"包含上传文件,不能删除!\"}";
		}
		service.delFile(fileId, user.getId());
		return "{result:\"success\"}";
	}
	/**
	 * 上传文件
	 * @param file
	 * @param request
	 * @param response
	 * @throws IOException 
	 * @throws Exception
	 */
	@RequestMapping(value = "fileUpload")
	@AroundAspect(description="办公云盘-上传文件")
	public @ResponseBody void fileUpload(@RequestParam("file") MultipartFile file, HttpServletRequest request,
			HttpServletResponse response) throws IOException  {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return;
		}
		try {
			service.uploadFile(file, request, response,user);
			response.getWriter().write("{\"status\":true,\"newName\":\"" + file.getOriginalFilename() + "\"}");
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("{\"status\":false}");
		}
	}
	
	/**
	 * 上传文件
	 * @param file
	 * @param request
	 * @param response
	 * @throws IOException 
	 * @throws Exception
	 */
	@RequestMapping(value = "largerFileUpload")
	@AroundAspect(description="办公云盘-大文件分片上传文件")
	public @ResponseBody String largerFileUpload(@RequestParam("file") MultipartFile file, HttpServletRequest request,
			HttpServletResponse response) throws IOException  {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return null;
		}
		String chunk=request.getParameter("chunk");
		String chunks=request.getParameter("chunks");
		String name=request.getParameter("name");
		if(name.indexOf(".")!=-1){
			name=name.substring(0,name.indexOf("."));
		}
		String filePath = new PropertiesLoader("config.properties").getProperty("rootPath");
		filePath += ("/" + DateUtil.getCurDate("yy") + "/" + DateUtil.getCurDate("MM") + "/"
				+ DateUtil.getCurDate("dd")+"/"+name);
		String tempFilePath=filePath+"/temp";
		File tempFolder=new File(tempFilePath);
		if(!tempFolder.exists()){
			tempFolder.mkdirs();
		}
		if("false".equals(chunk)){
			chunk="0";
		}
		String tempFile=tempFilePath+"/"+chunk+".part";
		File tempFile_=new File(tempFile);
		file.transferTo(tempFile_);
		if(Integer.parseInt(chunk)==(Integer.parseInt(chunks)-1)){
			String recordId = DateUtil.getCurDate("yyMMddHHmmssS") + new Random().nextInt(9);
			MergeFileUtil.mergeFiles(tempFilePath, filePath+"/"+recordId);
			File[] tempFiles=tempFolder.listFiles();
			for(int i=0;i<tempFiles.length;i++){
				if(!tempFiles[i].exists()){
					tempFiles[i].delete();
				}
			}
			service.uploadFile(request, user, filePath, file.getSize(),recordId);
			return filePath+"/"+recordId;
		}
		return null;
	}
	
	
	
	@RequestMapping("/rename")
	@ResponseBody
	@AroundAspect(description="办公云盘-重命名文件或文件夹")
	public void rename(
			@RequestParam(value = "fileId", defaultValue = "") String fileId,
			@RequestParam(value = "fileName", defaultValue = "") String fileName){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return;
		}
		service.rename(user.getId(),fileId, fileName);
	}
	
	@RequestMapping(value = "fileDownload")
	@AroundAspect(description="办公云盘-下载文件")
	public @ResponseBody void fileDownload(
			HttpServletRequest request, 
			HttpServletResponse response)  {
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user==null){
				return;
			}
			service.downloadFile(request, response,user.getId());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	@RequestMapping(value = "filePackDownload")
	@AroundAspect(description="办公云盘-批量下载文件")
	public @ResponseBody void filePackDownload(
			HttpServletRequest request, 
			HttpServletResponse response)  {
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user==null){
				return;
			}
			List<File> listFiles=new ArrayList<File>();
			String folderId=request.getParameter("folderId");
			String fileIds=request.getParameter("fileIds");
			String[] fileId=fileIds.split(",");
			String tempFolderPath=new Date().getTime()+"";
			String deleteTempPath="";
			for(int i=0;i<fileId.length;i++){
				File tempFile=service.getDownloadFile(request, response,user.getId(),fileId[i],folderId,tempFolderPath);
				if(tempFile!=null){
					listFiles.add(tempFile);
					deleteTempPath=tempFile.getParent();
				}
			}
			String zipName = new Date().getTime()+".zip";
			response.setContentType("APPLICATION/OCTET-STREAM");  
			response.setHeader("Content-Disposition","attachment; filename="+zipName);
			ZipOutputStream out = new ZipOutputStream(response.getOutputStream());
			try {
			    for(int i=0;i<listFiles.size();i++){
			        ZipUtils.doCompress(listFiles.get(i).getAbsolutePath(), out);
			        response.flushBuffer();
			    }
			} catch (Exception e) {
			    e.printStackTrace();
			}finally{
			    out.close();
			}
			if(deleteTempPath!=null){
		    	//清理临时文件
		    	File tempFolder=new File(deleteTempPath);
		    	if(tempFolder.exists()){
		    		File[] tempFile=tempFolder.listFiles();
		    		for(int i=0;i<tempFile.length;i++){
		    			tempFile[i].delete();
		    		}
		    		tempFolder.delete();
		    	}
		    }
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "findLog")
	@AroundAspect(description="办公云盘-分页查询详情列表")
	public @ResponseBody TreeGridView<CloudLogEntity> findLog(
			@RequestParam(value = "page", defaultValue = "0") int pagenum,
			@RequestParam(value = "rows", defaultValue = "10") int pagesize,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value = "folderId", defaultValue = "") String folderId)  {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		TreeGridView<CloudLogEntity> page = new TreeGridView<CloudLogEntity>();
		if(user==null){
			return null;
		}
		if (pagenum != 0) {
			pagenum = pagenum / pagesize;
		}
		pagenum++;
		PageResult<CloudLogEntity> pags=log.findCloudLog(pagenum, pagesize, sortName, sortOrder, folderId);
		page.setRows(pags.getResults());
		page.setTotal(pags.getTotalrecord());
		return page;
	}
	
	@RequestMapping(value = "findByFileId")
	@AroundAspect(description="办公云盘-查看文件或文件夹详情")
	public @ResponseBody List<CloudFileEntity> findByFileId(
			@RequestParam(value = "fileId", defaultValue = "") String fileId
			)  {
		return service.findByFileId(fileId);
	}
	
	@RequestMapping(value = "findDeptList")
	@AroundAspect(description="办公云盘-查询部门树")
	public @ResponseBody String findDeptList(){
		List<Dept> deptList=service.findDeptList();
		StringBuilder sb=new StringBuilder("[");
		for(int i=0;i<deptList.size();i++){
			Dept dept=deptList.get(i);
			sb.append("{id:'"+dept.getDeptId()+"',");
			sb.append("name:'"+dept.getDeptName()+"',");
			sb.append("iconSkin:'dept',");
			if(i==deptList.size()-1){
				sb.append("pId:'"+dept.getParentDeptId()+"'},");
			}else{
				sb.append("pId:'"+dept.getParentDeptId()+"'},");
			}
		}
		sb.append("]");
		return sb.toString();
	}
	@RequestMapping(value = "findUserList")
	@AroundAspect(description="办公云盘-查询人员树")
	public @ResponseBody String findUserList(){
		StringBuilder sb=new StringBuilder("[");
		List<Dept> deptList=service.findDeptList();
		List<User> userList=service.findUserList();
		for(int i=0;i<deptList.size();i++){
			Dept dept=deptList.get(i);
			sb.append("{id:'"+dept.getDeptId()+"',");
			sb.append("name:'"+dept.getDeptName()+"',");
			sb.append("type:'dept',");
			sb.append("iconSkin:'dept',");
			sb.append("pId:'"+dept.getParentDeptId()+"'},");
		}
		for(int i=0;i<userList.size();i++){
			User user=userList.get(i);
			sb.append("{id:'"+user.getUserId()+"',");
			sb.append("name:'"+user.getUserName()+"',");
			sb.append("iconSkin:'user-o',");
			sb.append("type:'user',");
			if(i==userList.size()-1){
				sb.append("pId:'"+user.getDeptId()+"'}");
			}else{
				sb.append("pId:'"+user.getDeptId()+"'},");
			}
		}
		sb.append("]");
		return sb.toString();
	}
	@RequestMapping(value = "saveAuth")
	@AroundAspect(description="办公云盘-保存文件权限")
	public @ResponseBody void saveAuth(String auths){
		JSONArray jsonArray=JSONArray.fromObject(auths);
		
		for(int i=0;i<jsonArray.size();i++){
			CloudAuthNode node=(CloudAuthNode)JSONObject.toBean(JSONObject.fromObject(jsonArray.get(i)),CloudAuthNode.class);
			if(i==0){
				service.deleteAuthBeforeSave(node.getFileId());
			}
			service.setAuth(node);
		}
	}
	
}
