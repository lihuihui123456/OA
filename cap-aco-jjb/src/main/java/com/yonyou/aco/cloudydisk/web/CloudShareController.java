package com.yonyou.aco.cloudydisk.web;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yonyou.aco.cloudydisk.entity.CloudShareBean;
import com.yonyou.aco.cloudydisk.service.ICloudShareService;
import com.yonyou.cap.common.audit.operatelog.annotation.AroundAspect;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * <p>概述：业务模块分享controller层
 * <p>功能：分享
 * <p>作者：葛鹏
 * <p>创建时间：2017年3月18日
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/cloudsharec")
public class CloudShareController {
	@Resource
	ICloudShareService service;
	@RequestMapping("/shareFile")
	@ResponseBody
	@AroundAspect(description="办公云盘-分享文件和文件夹")
	public void shareFile(
			@RequestParam(value = "fileIds", defaultValue = "") String fileIds,
			@RequestParam(value = "receiverId", defaultValue = "") String receiverId
			){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return;
		}
		service.shareFile(fileIds,receiverId,user);
	}
	@RequestMapping("/getShareFile")
	@AroundAspect(description="办公云盘-分享文件和文件夹详情")
	public @ResponseBody TreeGridView<CloudShareBean> getShareFile(
			@RequestParam(value = "shareType", defaultValue = "") String shareType,
			@RequestParam(value = "page", defaultValue = "0") int pagenum,
			@RequestParam(value = "rows", defaultValue = "10") int pagesize,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder){
		if (pagenum != 0) {
			pagenum = pagenum / pagesize;
		}
		pagenum++;
		TreeGridView<CloudShareBean> page = new TreeGridView<CloudShareBean>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return null;
		}
		PageResult<CloudShareBean> pags =null;
		if("shareother".equals(shareType)){
			pags=service.findShareFile(pagenum, pagesize, sortName, sortOrder, user.getId(), null,true,null);
		}else if("othershare".equals(shareType)){
			pags=service.findShareFile(pagenum, pagesize, sortName, sortOrder, null, user.getId(),true,null);
		}
		if(page!=null){
			page.setRows(pags.getResults());
			page.setTotal(pags.getTotalrecord());
		}
		return page;
	}
	@RequestMapping("/getShareFileNotGroupBy")
	@AroundAspect(description="办公云盘-文件和文件夹分享情况列表")
	public @ResponseBody TreeGridView<CloudShareBean> getShareFileNotGroupBy(
			@RequestParam(value = "shareType", defaultValue = "") String shareType,
			@RequestParam(value = "fileId", defaultValue = "") String fileId,
			@RequestParam(value = "page", defaultValue = "0") int pagenum,
			@RequestParam(value = "rows", defaultValue = "10") int pagesize,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder
			){
		if (pagenum != 0) {
			pagenum = pagenum / pagesize;
		}
		pagenum++;
		TreeGridView<CloudShareBean> page = new TreeGridView<CloudShareBean>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return null;
		}
		PageResult<CloudShareBean> pags =null;
		if("shareother".equals(shareType)){
			pags=service.findShareFile(pagenum, pagesize, sortName, sortOrder, user.getId(),null,false,fileId);
		}else if("othershare".equals(shareType)){
			pags=service.findShareFile(pagenum, pagesize, sortName, sortOrder, null, user.getId(),false,fileId);
		}
		page.setRows(pags.getResults());
		page.setTotal(pags.getTotalrecord());
		return page;
	}
	
	@RequestMapping("/cancelShare")
	@AroundAspect(description="办公云盘-文件和文件夹取消分享")
	@ResponseBody
	public String cancelShare(@RequestParam(value = "ID_", defaultValue = "") String ID_){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return null;
		}
		/*if(!service.beforeDelFolder(fileId)){
			return "{result:\"error\",reMsg:\"包含上传文件,不能删除!\"}";
		}*/
		try {
			service.cancelShare(ID_);
		} catch (Exception e) {
			return "{result:\"error\"}";
		}
		
		return "{result:\"success\"}";
	}
}
