package com.yonyou.aco.docstatistics.web;

import java.io.UnsupportedEncodingException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.docstatistics.entity.DocStatisticsBean;
import com.yonyou.aco.docstatistics.service.DocStatisticsService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
/**
 * <p>概述：业务模块公文统计controller层
 * <p>功能：按照部门划分，统计公文的行文数与流转数
 * <p>作者：葛鹏
 * <p>创建时间：2017年5月26日
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/docStatistics")
public class DocStatisticsController {
	@Resource
	DocStatisticsService service;
	
	@RequestMapping("/query")
	@ResponseBody
	public TreeGridView<DocStatisticsBean> query(
			@RequestParam(value = "parentDeptId", defaultValue = "") String parentDeptId,
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "deptName", defaultValue = "") String deptName){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return null;
		}
		
		if (pageNum > 0) {
			pageNum = pageNum / pageSize;
		}
		pageNum++;
		try {
			deptName=new String(deptName.getBytes("iso-8859-1"), "utf-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		TreeGridView<DocStatisticsBean> plist = new TreeGridView<DocStatisticsBean>();
		PageResult<DocStatisticsBean> pr=null;
		if(parentDeptId==null||"".equals(parentDeptId)){
			parentDeptId=service.findOrgIdByUserId(user.getId());
			pr=service.queryByOrgId(parentDeptId,pageNum,pageSize,deptName);
		}else{
			pr=service.queryByDeptId(parentDeptId,pageNum,pageSize,deptName);
		}
		plist.setRows(pr.getResults());
		plist.setTotal(pr.getTotalrecord());
		return plist;
	}
	@RequestMapping("/index")
	@ResponseBody
	public ModelAndView initDeptTree(HttpServletRequest request){
		ModelAndView mv=new ModelAndView();
		mv.setViewName("/aco/docstatistics/tablelist");
		return mv;
	}
	
	@RequestMapping("/isHasChildDept")
	@ResponseBody
	public String isHasChildDept(@RequestParam(value = "deptId", defaultValue = "") String deptId){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return null;
		}
		boolean flag=service.isHasChildDept(deptId);
		if(flag){
			return "true";
		}
		return "false";
	}
	
	@RequestMapping("/getParentDeptId")
	@ResponseBody
	public String getParentDeptId(@RequestParam(value = "deptId", defaultValue = "") String deptId){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return null;
		}
		return service.getParentDeptId(deptId);
	}
	
	
}
