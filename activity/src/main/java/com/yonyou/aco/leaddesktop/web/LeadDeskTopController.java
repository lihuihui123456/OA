package com.yonyou.aco.leaddesktop.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yonyou.aco.leaddesktop.entity.LeadDktpMenuBean;
import com.yonyou.aco.leaddesktop.entity.LeadDktpMenuEntity;
import com.yonyou.aco.leaddesktop.entity.LeadDktpYjEntity;
import com.yonyou.aco.leaddesktop.service.LeadDeskTopService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * <p>概述：业务模块领导桌面Controller层
 * <p>功能：领导桌面
 * <p>作者：葛鹏，王瑞朝
 * <p>创建时间：2016年12月5日
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/leaddtp")
public class LeadDeskTopController {
	@Resource
	LeadDeskTopService service;
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * 加载用户自定义菜单
	 * @return
	 */
	@RequestMapping("/custmenu")
	public @ResponseBody JSONArray getCustomizedMenu(){
		List<LeadDktpMenuBean> NonVirtualModList=null;
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				NonVirtualModList=service.getNonVirtualMenu(user);//虚拟节点、父节点
				List<LeadDktpMenuBean> VirtualModList=service.getVirtualMenu(user);//子节点
				NonVirtualModList.addAll(VirtualModList);//合并
				Collections.sort(NonVirtualModList);//排序
				return JSONArray.fromObject(NonVirtualModList);
			}
		} catch (Exception e) {
			logger.error("error",e);
			return null;
		}
		return null;
	}
	/**
	 * 根据勾选状态新增或移除自定义菜单
	 * @param modId 节点ID
	 * @param status 勾选状态
	 * @return
	 */
	@RequestMapping("/addcustmenu")
	public @ResponseBody String addCustomMenu(
			@RequestParam(value = "modId",defaultValue = "") String modId,
			@RequestParam(value = "status",defaultValue = "") String status){
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if("checked".equals(status)){
				service.addCustomMenu(modId);//勾选
			}else{
				if(user != null){
					service.removeCustomMenu(modId,user);//取消勾选
				}
			}
		} catch (Exception e) {
			logger.error("error",e);
			return "{\"result\":\"fail\"}";
		}
		return "{\"result\":\"success\"}";
	}
	@RequestMapping("/addallmenu")
	public @ResponseBody String addAllCustomMenu(
			@RequestParam(value = "modIds",defaultValue = "") String modIds){
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				service.updateCustomMenu(modIds,user);
			}
		} catch (Exception e) {
			logger.error("error",e);
			return "{\"result\":\"fail\"}";
		}
		return "{\"result\":\"success\"}";
	}
	@RequestMapping("/getchecked")
	public @ResponseBody JSONArray getChecked(){
		List<LeadDktpMenuEntity> list=new ArrayList<LeadDktpMenuEntity>();
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				list=service.getChecked(user);
			}
		} catch (Exception e) {
			logger.error("error",e);
			return null;
		}
		return JSONArray.fromObject(list);
	}
	@RequestMapping("/addComment")
	public @ResponseBody String addComment(HttpServletResponse response, HttpServletRequest request){
		String clyj = request.getParameter("clyj");// 业务类型
		try {
			LeadDktpYjEntity leader = new LeadDktpYjEntity();
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			//leader.setUserId(user.getId());
			if(user != null){
				leader = service.findYj(clyj,user);
			}
			if(leader!=null){
				leader.setYjCount(leader.getYjCount()+1);
				leader.setUserId(user.id);
				service.updateCount(leader);
			}else{
				leader = new LeadDktpYjEntity();
				leader.setLeaderComment(clyj);
				leader.setYjCount(1);
				leader.setUserId(user.id);
				service.addComment(leader);
			}
		} catch (Exception e) {
			logger.error("error",e);
			return "{\"result\":\"fail\"}";
		}
		return "{\"result\":\"success\"}";
	}
	
	@RequestMapping("/findAllComment")
	public @ResponseBody JSONArray findAllComment(HttpServletResponse response, HttpServletRequest request){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		List<LeadDktpYjEntity> list = null;
		try {
			list = service.findAllComment(user.getId());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.error("error",e);
		}
		return JSONArray.fromObject(list);
	}
}
