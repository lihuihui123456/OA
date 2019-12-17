package com.yonyou.jjb.leavemgr.web;


import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Writer;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springside.modules.utils.PropertiesLoader;

import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.common.util.BeanUtil;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.sys.iweboffice.entity.IWebDocumentEntity;
import com.yonyou.cap.sys.iweboffice.service.DocumentService;
import com.yonyou.jjb.leavemgr.entity.BizLeaveBean;
import com.yonyou.jjb.leavemgr.entity.BizLeaveDaysEntity;
import com.yonyou.jjb.leavemgr.entity.BizLeaveEntity;
import com.yonyou.jjb.leavemgr.service.ILeaveMgrService;
import com.yonyou.jjb.usermanager.entity.UserInfoEntity;
import com.yonyou.jjb.usermanager.service.IUserManagerService;

import freemarker.template.Configuration;
import freemarker.template.Template;

/**
 * TODO: 请假管理
 * TODO: 填写Class详细说明 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年10月12日
 * @author 申浩
 * @since 1.0.0
 */
@Controller
@RequestMapping("/leaveManager")
public class LeaveMgrController {
	@Resource
	private ILeaveMgrService leaveMgrService;
	@Resource
	private DocumentService documentService;
	@Resource
	private IUserManagerService userManagerService;
	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;
	@Autowired
	private HttpServletRequest request;
	private String modCode="";

	/**
	 * 名称: 跳转到请假管理页 
	 * @return
	 */
	@RequestMapping("/toLeaveMList")
	public String toUserMList() {
		modCode= request.getParameter("modCode");
		return "/jjb/leavemgr/leavelist";
	}
	
	
	/**
	 * 获取所有请假信息
	 * 备注：原方法名称（getAllData）
	 * @param pagen
	 * @param rows
	 * @param roomName
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/findAllLeaveInfo")
	public Map<String, Object> findAllLeaveInfo(@RequestParam(value = "page", defaultValue = "0") int pageNum,
			@RequestParam(value = "rows", defaultValue = "10") int pageSize,
			@RequestParam(value = "searchInfo", defaultValue = "") String searchInfo) {
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			List<BizLeaveBean> list=new ArrayList<BizLeaveBean>();
			PageResult<BizLeaveEntity> pags;
			searchInfo = new String(searchInfo.getBytes("iso-8859-1"), "utf-8");
			if ("".equals(searchInfo)) {
				pags = leaveMgrService.findAllLeaveInfo(pageNum, pageSize,modCode);
			} else {
				pags = leaveMgrService.findAllLeaveInfo(pageNum, pageSize,searchInfo,modCode);
			}
			for(int i=0;i< pags.getResults().size();i++){
				BizLeaveEntity bizLeaveEntity = pags.getResults().get(i);
				BizLeaveBean bizLeaveBean = leaveMgrService.getSolId(bizLeaveEntity.getBiz_id_());
				if(bizLeaveBean!=null){
					BeanUtil.copy(bizLeaveBean, bizLeaveEntity);
					list.add(bizLeaveBean);
				}
			}
			map.put("total", pags.getTotalrecord());
			map.put("rows", list);
			return map;
		} catch (Exception e) {
			return null;
		}
	}


	/**
	 * 请假登记功能
	 * @param 
	 * @return
	 */
	@RequestMapping("/draft")
	public ModelAndView draft() {
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(draftProperty());
		mv.setViewName("/jjb/leavemgr/form_template");
		return mv;
	}
	@ResponseBody
	@RequestMapping("/getParam")
	public Map<String, Object> getParam() {
		return  draftProperty();
		
	}
    private Map<String, Object> draftProperty() {
		Map<String, Object> map = new HashMap<String, Object>();		
		String tableName = "biz_leave";    //表单所对应的数据表
		String formName = "请假登记";     //表单名称
		String isMainBody = "0";  // 流程是否有正文   0 ： 没有   1： 有
		String mainBodySRC = "";  // 正文访问链接
		String attachmentSRC = ""; //附件访问链接
		String isAttachment = "0"; //流程是否有附件  0：没有     1：有
		//String bizId=UUID.randomUUID().toString();
		//String formUrl="/jjb/leavemgr/leavemgr";
	/*	String formsrc = "leaveManager/toFormDraftPage?tableName="
				+ tableName + "&viewName="
				+ formUrl+ "&bizId="+ bizId;*/
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		UserInfoEntity uie = userManagerService.findUserInfoByUserId(user.id);
		BizLeaveDaysEntity blde = leaveMgrService.findLeaveDaysById(user.id);
		if(blde==null){
			map.put("already_day", "0");
			map.put("leave_already", "0");
			BizLeaveDaysEntity bizday=new BizLeaveDaysEntity();
			bizday.setUserId(user.id);
			bizday.setTotalDays_("0");
			bizday.setLeaveDays_("0");
			leaveMgrService.doUpdateLeaveDays(bizday);
		}else{
			if(StringUtils.isEmpty(blde.getTotalDays_())){
				map.put("already_day", "0");
				blde.setTotalDays_("0");
				leaveMgrService.doUpdateLeaveDays(blde);
			}else{
				map.put("already_day", blde.getTotalDays_());
			}
			if(StringUtils.isEmpty(blde.getLeaveDays_())){
				map.put("leave_already", "0");
				blde.setLeaveDays_("0");
				leaveMgrService.doUpdateLeaveDays(blde);
			}else{
				map.put("leave_already", blde.getLeaveDays_());
			}
		}
		map.put("postName",uie.getPostName());
		map.put("workTime", uie.getWorkTime());//参加工作时间
		map.put("formName", formName);  // 表单名称
		/*map.put("formsrc", formsrc)*/;// 业务表单请求路径
		map.put("isMainBody", isMainBody);
		map.put("mainBodySRC", mainBodySRC);
		map.put("isAttachment", isAttachment);
		map.put("attachmentSRC", attachmentSRC);
	/*	map.put("bizId", bizId);*/
		map.put("tableName", tableName);// 实体对应的表名
		map.put("sendState", "0");// 实体对应的表名
		return map;
	}
    
    /**
	 * @param 跳转到附件页面
	 * 备注：原方法名：touploadView 
	 * view="1"查看
	 * @return
	 */
		@RequestMapping("/toDocMgrAtch")
		public ModelAndView toDocMgrAtch(@RequestParam(required=false) String bizId,
				@RequestParam(required=false) String view) {
			ModelAndView mv = new ModelAndView();
			mv.addObject("bizid", bizId);
			mv.addObject("view", view);
			mv.setViewName("jjb/leavemgr/docmgr-atch");
			return mv;
		}
    	@RequestMapping("/toFormDraftPage")
        public ModelAndView toFormDraftPage(HttpServletRequest request) {
				String tableName = request.getParameter("tableName");
				String viewName = request.getParameter("viewName");
				String bizId = request.getParameter("bizId");
				ModelAndView mv = new ModelAndView();
				if(StringUtils.isNotEmpty(tableName) && StringUtils.isNotEmpty(viewName)){
					mv.addObject("keyValueMap", "{}");//表单页面数据（拟稿时为空）
					mv.addObject("tableName", tableName);//表单对应数据表名称
					mv.addObject("style", "draft");//表单访问标记   draft  表示拟稿操作
					mv.addObject("bizId", bizId);
					mv.setViewName(viewName);
				}
				return mv;
}
    	
    	/**
    	 * 流程撤回后，关联的请假信息作废
    	 * @param bizId 
    	 * @param request   
    	 * @return
    	 */
    	@RequestMapping("/resetLeaveInfo")
    	@ResponseBody
    	public void resetLeaveInfo(HttpServletRequest request) {
    		String bizId = request.getParameter("bizId");
			BizLeaveEntity ble = leaveMgrService.findLeaveInfoById(bizId);
			if(ble!=null){
	    		BizLeaveDaysEntity blde = leaveMgrService.findLeaveDaysById(ble.getDataUserId());
	    		if(StringUtils.isNotEmpty(ble.getXiujia_days())){
	    			int j = Integer.parseInt(blde.getTotalDays_())-Integer.parseInt(ble.getXiujia_days());
		    		blde.setTotalDays_(String.valueOf(j));
	    		}
	    		if(StringUtils.isNotEmpty(ble.getQingjia_days())){
	    			int n = Integer.parseInt(blde.getLeaveDays_())-Integer.parseInt(ble.getQingjia_days());
		    		blde.setLeaveDays_(String.valueOf(n));
	    		}	
	    		leaveMgrService.doUpdateLeaveDays(blde);
		    }
    		
    	} 	
/*    	@RequestMapping("/resetLeaveInfo")
    	@ResponseBody
    	public void resetLeaveInfo(HttpServletRequest request) {
    		String bizId = request.getParameter("bizId");
    		 BizLeaveEntity	bizLeaveEntity=leaveMgrService.findLeaveInfoById(bizId);
    		if(bizLeaveEntity != null ){
    			BizLeaveDaysEntity blde = leaveMgrService.findLeaveDaysById(bizLeaveEntity.getDataUserId());
				if(blde!=null){
					if(StringUtils.isNotEmpty(bizLeaveEntity.getXiujia_days())){
						   int i = Integer.parseInt(blde.getTotalDays_())-Integer.parseInt(bizLeaveEntity.getXiujia_days());
						   int already_day=Integer.parseInt(bizLeaveEntity.getAlready_day())-Integer.parseInt(bizLeaveEntity.getXiujia_days());
						   int total_days=Integer.parseInt(bizLeaveEntity.getTotal_days())-Integer.parseInt(bizLeaveEntity.getXiujia_days());						   
						   bizLeaveEntity.setAlready_day(already_day+"");
						   bizLeaveEntity.setTotal_days(total_days+"");
						   blde.setTotalDays_(String.valueOf(i));
						} 
						if(StringUtils.isNotEmpty(bizLeaveEntity.getQingjia_days())){
						    int j = Integer.parseInt(blde.getLeaveDays_())-Integer.parseInt(bizLeaveEntity.getQingjia_days());
							int leave_already=Integer.parseInt(bizLeaveEntity.getLeave_already())-Integer.parseInt(bizLeaveEntity.getQingjia_days());
						    int total_days=Integer.parseInt(bizLeaveEntity.getTotal_days())-Integer.parseInt(bizLeaveEntity.getQingjia_days());						   
						    bizLeaveEntity.setLeave_already(leave_already+"");
						    bizLeaveEntity.setTotal_days(total_days+"");
						   blde.setLeaveDays_(String.valueOf(j));
						} 
						leaveMgrService.doUpdateLeaveDays(blde);	
				} 
				bizLeaveEntity.setDr("Y");
	    		leaveMgrService.doUpdateLeaveInfo(bizLeaveEntity);
    		}
    		
    	} 	*/
    	
    	
    	/**
    	 * 业务表单拟稿保存公共方法
    	 * @param tableName 业务表单对应数据表名称
    	 * @param request   
    	 * @return
    	 */
    	@RequestMapping("/doSaveBpmDuForm")
    	@ResponseBody
    	public String doSaveBpmDuForm(HttpServletRequest request) {
    		    ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
    		    String msg = "N";
    		    BizLeaveEntity bizLeaveEntity=new BizLeaveEntity();
    		    String date = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
    		    bizLeaveEntity.setId(request.getParameter("id"));
    		    bizLeaveEntity.setBiz_id_(request.getParameter("id"));
    		    bizLeaveEntity.setUser_name(request.getParameter("user_name"));
    		    bizLeaveEntity.setPost_name(request.getParameter("post_name"));
    		    bizLeaveEntity.setLeave_time(request.getParameter("leave_time"));
    		    bizLeaveEntity.setRemark(request.getParameter("remark"));
    		    bizLeaveEntity.setDr("N");
    		    bizLeaveEntity.setTs(date);
    		    bizLeaveEntity.setWork_time(request.getParameter("work_time"));
    		    bizLeaveEntity.setLeave_day(request.getParameter("leave_day"));
    		    bizLeaveEntity.setAlready_day(request.getParameter("already_day"));
    		    bizLeaveEntity.setRest_time(request.getParameter("rest_time"));
    		    bizLeaveEntity.setLeave_capital(request.getParameter("leave_capital"));
    		    bizLeaveEntity.setCapital(request.getParameter("capital"));
    		    bizLeaveEntity.setLeave_country(request.getParameter("leave_country"));
    		    bizLeaveEntity.setCountry(request.getParameter("country"));
    		    bizLeaveEntity.setComment_bm(request.getParameter("comment_bm"));
    		    bizLeaveEntity.setComment_ld(request.getParameter("comment_ld"));
    		    bizLeaveEntity.setLeave_type(request.getParameter("leave_type"));
    		    bizLeaveEntity.setLeave_reason(request.getParameter("leave_reason"));
    		    bizLeaveEntity.setLeave_already(request.getParameter("leave_already"));
    		    bizLeaveEntity.setLeave_time_end(request.getParameter("leave_time_end"));
    		    bizLeaveEntity.setRest_time_end(request.getParameter("rest_time_end"));
    		    bizLeaveEntity.setDept_name(request.getParameter("dept_name"));
    		    bizLeaveEntity.setState(request.getParameter("state"));
    		    bizLeaveEntity.setDataUserId(user.getUserId());
    		    bizLeaveEntity.setDataOrgId(user.getOrgid());
    		    bizLeaveEntity.setDataTenantId("0");
    		    bizLeaveEntity.setDataDeptCode(user.getDeptCode());
    		    bizLeaveEntity.setSurplus_days(request.getParameter("surplus_days"));
    		    bizLeaveEntity.setTotal_days(request.getParameter("total_days"));
    		    bizLeaveEntity.setXiujia_days(request.getParameter("xiujia_days"));
    		    bizLeaveEntity.setQingjia_days(request.getParameter("qingjia_days"));
    		    if("3".equals(request.getParameter("state"))){
    		    	bizLeaveEntity.setSendTime(date);
    		    	//暂存不进行逻辑处理，请假天数不增加，送交包含拟稿送交此时需要进行逻辑处理，请假天数进行加，否则其他的处理此任务不需要进行逻辑加
					BizLeaveDaysEntity blde = leaveMgrService.findLeaveDaysById(user.id);
					if(blde!=null){
						if(StringUtils.isNotEmpty(request.getParameter("xiujia_days"))){
							   int i = Integer.parseInt(blde.getTotalDays_())+Integer.parseInt(request.getParameter("xiujia_days"));
							   blde.setTotalDays_(String.valueOf(i));
							} 
							if(StringUtils.isNotEmpty(request.getParameter("qingjia_days"))){
							    int j = Integer.parseInt(blde.getLeaveDays_())+Integer.parseInt(request.getParameter("qingjia_days"));
							    blde.setLeaveDays_(String.valueOf(j));
							} 
							leaveMgrService.doUpdateLeaveDays(blde);	
					}  	
    		    }else if("2".equals(request.getParameter("state"))){
    		    	bizLeaveEntity.setSendTime(date);
    		    }
    		    if(StringUtils.isNotEmpty(request.getParameter("leave_time"))){
    		    	bizLeaveEntity.setStartTime(request.getParameter("leave_time"));
    		    	bizLeaveEntity.setEndTime(request.getParameter("leave_time_end"));
    		    }
                if(StringUtils.isNotEmpty(request.getParameter("rest_time"))){
                	bizLeaveEntity.setStartTime(request.getParameter("rest_time"));
    		    	bizLeaveEntity.setEndTime(request.getParameter("rest_time_end"));
    		    }
    		    leaveMgrService.doUpdateLeaveInfo(bizLeaveEntity);
    			msg = "Y";
    		return msg;
    	}
    	
    	/**
    	 * 业务数据修改公共方法
    	 * @param solId   业务解决方案Id
    	 * @param bizId   业务Id
    	 * @param serialNumber  流水号
    	 * @return
    	 */
    	@RequestMapping("/update")
    	public ModelAndView update(@RequestParam String bizId) {
    		
    		ModelAndView mv = new ModelAndView();
    		String tableName = "biz_leave"; 
    		String viewName="/jjb/leavemgr/leavemgr";
    		String formsrc = "leaveManager/toFormUpdatePage?bizId=" + bizId
					 + "&tableName="
					+ tableName + "&viewName="
					+ viewName;    // 表单访问链接
    		String formName = "请假登记";
    		String isMainBody = "0";  // 流程是否有正文   0 ： 没有   1： 有
    		String mainBodySRC = "";  // 正文访问链接
    		String isAttachment = "0"; //流程是否有附件  0：没有     1：有
    		String attachmentSRC = ""; //附件访问链接
    		
    		
    		// 获取审批单配置 及生成审批单链接
    		mv.addObject("bizId", bizId);
    		mv.addObject("formName", formName);// 表单名称
    		mv.addObject("formsrc", formsrc);
    		mv.addObject("isMainBody", isMainBody);
    		mv.addObject("mainBodySRC", mainBodySRC);
    		mv.addObject("isAttachment", isAttachment);
    		mv.addObject("attachmentSRC", attachmentSRC);   		
    		mv.setViewName("/jjb/leavemgr/form_update_template");
    		return mv;
    	}
    	
    	/**
    	 * 跳转到业务表单编辑页面
    	 * @param bizId      业务流程基本信息Id
    	 * @param tableName  业务表单对应的数据表名称
    	 * @param viewName   拟稿页面地址
    	 * @return
    	 * @throws Exception
    	 */
    	@RequestMapping("/toFormUpdatePage")
    	public ModelAndView toFormUpdatePage(HttpServletRequest request)throws Exception {
    		ModelAndView mv = new ModelAndView();
    		
    		String bizId = request.getParameter("bizId");
    		String tableName = request.getParameter("tableName");
    		String viewName = request.getParameter("viewName");
    		BizLeaveEntity bizLeaveEntity=new BizLeaveEntity();
    		bizLeaveEntity=leaveMgrService.findLeaveInfoById(bizId);
    		Map<String, Object> keyValueMap = new HashMap<String, Object>();
    		keyValueMap.put("id", bizId);
    		keyValueMap.put("bizId_", bizId);
    		keyValueMap.put("user_name", bizLeaveEntity.getUser_name());
    		keyValueMap.put("post_name", bizLeaveEntity.getPost_name());
    		keyValueMap.put("leave_time", bizLeaveEntity.getLeave_time());
    		keyValueMap.put("ts", bizLeaveEntity.getTs());
    		keyValueMap.put("dr", bizLeaveEntity.getDr());
    		keyValueMap.put("remark", bizLeaveEntity.getRemark());
    		keyValueMap.put("work_time", bizLeaveEntity.getWork_time());
    		keyValueMap.put("leave_day", bizLeaveEntity.getLeave_day());
    		keyValueMap.put("already_day", bizLeaveEntity.getAlready_day());
    		keyValueMap.put("rest_time", bizLeaveEntity.getRest_time());
    		keyValueMap.put("leave_capital", bizLeaveEntity.getLeave_capital());
    		keyValueMap.put("capital", bizLeaveEntity.getCapital());
    		keyValueMap.put("leave_country", bizLeaveEntity.getLeave_country());
    		keyValueMap.put("country", bizLeaveEntity.getCountry());
    		keyValueMap.put("comment_bm", bizLeaveEntity.getComment_bm());
    		keyValueMap.put("comment_ld", bizLeaveEntity.getComment_ld());
    		keyValueMap.put("leave_type", bizLeaveEntity.getLeave_type());
    		keyValueMap.put("leave_already", bizLeaveEntity.getLeave_already());
    		keyValueMap.put("leave_reason", bizLeaveEntity.getLeave_reason());
    		keyValueMap.put("leave_time_end", bizLeaveEntity.getLeave_time_end());
    		keyValueMap.put("rest_time_end", bizLeaveEntity.getRest_time_end());
    		keyValueMap.put("dept_name", bizLeaveEntity.getDept_name());
    		keyValueMap.put("userId", bizLeaveEntity.getDataUserId());
    		keyValueMap.put("deptCode", bizLeaveEntity.getDataDeptCode());
    		keyValueMap.put("orgId", bizLeaveEntity.getDataOrgId());
    		keyValueMap.put("tenantId", bizLeaveEntity.getDataTenantId());
    		keyValueMap.put("state", bizLeaveEntity.getState());
    		keyValueMap.put("surplus_days", bizLeaveEntity.getSurplus_days());
    		keyValueMap.put("total_days", bizLeaveEntity.getTotal_days());
    		keyValueMap.put("xiujia_days", bizLeaveEntity.getXiujia_days());
    		keyValueMap.put("qingjia_days", bizLeaveEntity.getQingjia_days());
    		JSONObject json = new JSONObject();
    		json.putAll(keyValueMap);
    		mv.addObject("keyValueMap", json);
    		
    		mv.addObject("tableName", tableName);
    		mv.addObject("style", "update");
    		mv.addObject("bizId", bizId);
    		mv.setViewName(viewName);
    		return mv;
    	}
    	@ResponseBody
    	@RequestMapping("/togetFromParam")
    	public Map<String, Object> togetFromParam(HttpServletRequest request)throws Exception {    		
    		String bizId = request.getParameter("bizId");
    		BizLeaveEntity bizLeaveEntity=new BizLeaveEntity();
    		bizLeaveEntity=leaveMgrService.findLeaveInfoById(bizId);
    		Map<String, Object> keyValueMap = new HashMap<String, Object>();
    		keyValueMap.put("id", bizId);
    		keyValueMap.put("bizId_", bizId);
    		keyValueMap.put("user_name", bizLeaveEntity.getUser_name());
    		keyValueMap.put("post_name", bizLeaveEntity.getPost_name());
    		keyValueMap.put("leave_time", bizLeaveEntity.getLeave_time());
    		keyValueMap.put("ts", bizLeaveEntity.getTs());
    		keyValueMap.put("dr", bizLeaveEntity.getDr());
    		keyValueMap.put("remark", bizLeaveEntity.getRemark());
    		keyValueMap.put("work_time", bizLeaveEntity.getWork_time());
    		keyValueMap.put("leave_day", bizLeaveEntity.getLeave_day());
    		keyValueMap.put("already_day", bizLeaveEntity.getAlready_day());
    		keyValueMap.put("rest_time", bizLeaveEntity.getRest_time());
    		keyValueMap.put("leave_capital", bizLeaveEntity.getLeave_capital());
    		keyValueMap.put("capital", bizLeaveEntity.getCapital());
    		keyValueMap.put("leave_country", bizLeaveEntity.getLeave_country());
    		keyValueMap.put("country", bizLeaveEntity.getCountry());
    		keyValueMap.put("comment_bm", bizLeaveEntity.getComment_bm());
    		keyValueMap.put("comment_ld", bizLeaveEntity.getComment_ld());
    		keyValueMap.put("leave_type", bizLeaveEntity.getLeave_type());
    		keyValueMap.put("leave_already", bizLeaveEntity.getLeave_already());
    		keyValueMap.put("leave_reason", bizLeaveEntity.getLeave_reason());
    		keyValueMap.put("leave_time_end", bizLeaveEntity.getLeave_time_end());
    		keyValueMap.put("rest_time_end", bizLeaveEntity.getRest_time_end());
    		keyValueMap.put("dept_name", bizLeaveEntity.getDept_name());
    		keyValueMap.put("userId", bizLeaveEntity.getDataUserId());
    		keyValueMap.put("deptCode", bizLeaveEntity.getDataDeptCode());
    		keyValueMap.put("orgId", bizLeaveEntity.getDataOrgId());
    		keyValueMap.put("tenantId", bizLeaveEntity.getDataTenantId());
    		keyValueMap.put("state", bizLeaveEntity.getState());
    		keyValueMap.put("surplus_days", bizLeaveEntity.getSurplus_days());
    		keyValueMap.put("total_days", bizLeaveEntity.getTotal_days());
    		keyValueMap.put("xiujia_days", bizLeaveEntity.getXiujia_days());
    		keyValueMap.put("qingjia_days", bizLeaveEntity.getQingjia_days());
    		return keyValueMap;
    	}
    	/**
    	 * 业务表单修改保存公共方法
    	 * @param bizId     业务基本信息Id
    	 * @param tableName 业务表单对应数据表名称
    	 * @param request   
    	 * @return
    	 */
    	@RequestMapping("/doUpdateBpmDuForm")
    	@ResponseBody
    	public String doUpdateBpmDuForm(HttpServletRequest request) {
    		String msg = "N";
    		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
    		BizLeaveEntity bizLeaveEntity=new BizLeaveEntity();
		    String date = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
		    bizLeaveEntity.setId(request.getParameter("id"));
		    bizLeaveEntity.setBiz_id_(request.getParameter("id"));
		    bizLeaveEntity.setUser_name(request.getParameter("user_name"));
		    bizLeaveEntity.setPost_name(request.getParameter("post_name"));
		    bizLeaveEntity.setLeave_time(request.getParameter("leave_time"));
		    bizLeaveEntity.setRemark(request.getParameter("remark"));
		    bizLeaveEntity.setDr("N");
		    bizLeaveEntity.setTs(date);
		    bizLeaveEntity.setWork_time(request.getParameter("work_time"));
		    bizLeaveEntity.setLeave_day(request.getParameter("leave_day"));
		    bizLeaveEntity.setAlready_day(request.getParameter("already_day"));
		    bizLeaveEntity.setRest_time(request.getParameter("rest_time"));
		    bizLeaveEntity.setLeave_capital(request.getParameter("leave_capital"));
		    bizLeaveEntity.setCapital(request.getParameter("capital"));
		    bizLeaveEntity.setLeave_country(request.getParameter("leave_country"));
		    bizLeaveEntity.setCountry(request.getParameter("country"));
		    bizLeaveEntity.setComment_bm(request.getParameter("comment_bm"));
		    bizLeaveEntity.setComment_ld(request.getParameter("comment_ld"));
		    bizLeaveEntity.setLeave_type(request.getParameter("leave_type"));
		    bizLeaveEntity.setLeave_reason(request.getParameter("leave_reason"));
		    bizLeaveEntity.setLeave_already(request.getParameter("leave_already"));
		    bizLeaveEntity.setLeave_time_end(request.getParameter("leave_time_end"));
		    bizLeaveEntity.setRest_time_end(request.getParameter("rest_time_end"));
		    bizLeaveEntity.setDept_name(request.getParameter("dept_name"));
		    bizLeaveEntity.setDataUserId(request.getParameter("userId"));
		    bizLeaveEntity.setDataOrgId(request.getParameter("orgId"));
		    bizLeaveEntity.setDataTenantId(request.getParameter("tenantId"));
		    bizLeaveEntity.setDataDeptCode(request.getParameter("deptCode"));
		    bizLeaveEntity.setState(request.getParameter("state"));
		    bizLeaveEntity.setSurplus_days(request.getParameter("surplus_days"));
		    bizLeaveEntity.setTotal_days(request.getParameter("total_days"));
		    bizLeaveEntity.setXiujia_days(request.getParameter("xiujia_days"));
		    bizLeaveEntity.setQingjia_days(request.getParameter("qingjia_days"));
		    if("3".equals(request.getParameter("state"))){
		    	bizLeaveEntity.setSendTime(date);
		    	BizLeaveDaysEntity blde = leaveMgrService.findLeaveDaysById(user.id);
		    	if(StringUtils.isNotEmpty(request.getParameter("xiujia_days"))){
				   int i = Integer.parseInt(blde.getTotalDays_())+Integer.parseInt(request.getParameter("xiujia_days"));
				   blde.setTotalDays_(String.valueOf(i));
			    } 
				if(StringUtils.isNotEmpty(request.getParameter("qingjia_days"))){
				   int j = Integer.parseInt(blde.getLeaveDays_())+Integer.parseInt(request.getParameter("qingjia_days"));
				   blde.setLeaveDays_(String.valueOf(j));
				} 
		    		leaveMgrService.doUpdateLeaveDays(blde);		    	
		    }else if("2".equals(request.getParameter("state"))){
		    	bizLeaveEntity.setSendTime(date);
		    }
		    if(StringUtils.isNotEmpty(request.getParameter("leave_time"))){
		    	bizLeaveEntity.setStartTime(request.getParameter("leave_time"));
		    	bizLeaveEntity.setEndTime(request.getParameter("leave_time_end"));
		    }
            if(StringUtils.isNotEmpty(request.getParameter("rest_time"))){
            	bizLeaveEntity.setStartTime(request.getParameter("rest_time"));
		    	bizLeaveEntity.setEndTime(request.getParameter("rest_time_end"));
		    }
		    leaveMgrService.doUpdateLeaveInfo(bizLeaveEntity);
		    
			msg = "Y";
		return msg;
    	}

	/**
	 * 根据id提交请假信息
	 * 备注：原方法名（）
	 * @param userid
	 *            多个id拼成的字符串以 , 分割
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/doSendLeaveInfo")
	public int doSendLeaveInfo(@RequestParam(value = "ids[]") String[] ids) {
		int count = 0;
		String id="";
		try {
			if (ids != null && ids.length != 0){	
				for (int i = 0; i < ids.length; i++){
					id=ids[i];
					leaveMgrService.doSendLeaveInfo(id);	
				}									     
			}
		} catch (Exception e) {
			e.printStackTrace();
			count=1;
		}
		return count;
	}
	/**
	 * 根据id删除请假信息
	 * 备注：原方法名（）
	 * @param userid
	 *            多个id拼成的字符串以 , 分割
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/doDelLeaveInfo")
	public int doDelLeaveInfo(@RequestParam(value = "ids[]") String[] ids) {
		int count = 0;
		String id="";
		try {
			if (ids != null && ids.length != 0){	
				for (int i = 0; i < ids.length; i++){
					id=ids[i];
					leaveMgrService.doDelLeaveInfo(id);	
					
					BizLeaveEntity ble = leaveMgrService.findLeaveInfoById(id);
					//删除流程业务基本信息数据
					bpmRuBizInfoService.doDeleteBpmRuBizInfoEntityByBizId(id);
					if(ble!=null){
    		    		BizLeaveDaysEntity blde = leaveMgrService.findLeaveDaysById(ble.getDataUserId());
    		    		if(StringUtils.isNotEmpty(ble.getXiujia_days())){
    		    			int j = Integer.parseInt(blde.getTotalDays_())-Integer.parseInt(ble.getXiujia_days());
	    		    		blde.setTotalDays_(String.valueOf(j));
    		    		}
    		    		if(StringUtils.isNotEmpty(ble.getQingjia_days())){
    		    			int n = Integer.parseInt(blde.getLeaveDays_())-Integer.parseInt(ble.getQingjia_days());
	    		    		blde.setLeaveDays_(String.valueOf(n));
    		    		}	
    		    		leaveMgrService.doUpdateLeaveDays(blde);
	    		    }
				}									     
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			count=1;
		}
		return count;
	}
	/**
	 * 跳转到审批单查看页面
	 * 
	 * @param bizId
	 *            业务流程信息Id
	 * @return
	 */
	@RequestMapping("/view")
	public ModelAndView view(@RequestParam String bizId) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("bizId", bizId);
		String tableName = "biz_leave"; 
		String viewName="/jjb/leavemgr/leavemgr";
		String formName = "请假登记";
		String isMainBody = "0";  // 流程是否有正文   0 ： 没有   1： 有
		String mainBodySRC = "";  // 正文访问链接
		String isAttachment = "0"; //流程是否有附件  0：没有     1：有
		String attachmentSRC = ""; //附件访问链接
		String url = "leaveManager/toFormViewPage?bizId="
				+ bizId+ "&tableName=" + tableName+ "&viewName=" + viewName;
		mv.addObject("formsrc", url);
		mv.addObject("formName", formName);// 表单名称
		mv.addObject("isMainBody",isMainBody);
		mv.addObject("mainBodySRC",mainBodySRC);
        mv.addObject("isAttachment",isAttachment);
		mv.addObject("attachmentSRC", attachmentSRC);
	    mv.setViewName("/jjb/leavemgr/form_view_template");
		return mv;
	}
	
	/**
	 * 跳转到表单查看页面
	 * @param bizId     业务流程基本信息Id
	 * @param tableName 业务表单对应的数据表名称
	 * @param viewName  拟稿页面地址
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/toFormViewPage")
	public ModelAndView toFormViewPage(@RequestParam String bizId,
			@RequestParam String tableName, @RequestParam String viewName)throws Exception {
		ModelAndView mv = new ModelAndView();
		BizLeaveEntity bizLeaveEntity=new BizLeaveEntity();
		bizLeaveEntity=leaveMgrService.findLeaveInfoById(bizId);
		Map<String, Object> keyValueMap = new HashMap<String, Object>();
		keyValueMap.put("id", bizId);
		keyValueMap.put("bizId_", bizId);
		keyValueMap.put("user_name", bizLeaveEntity.getUser_name());
		keyValueMap.put("post_name", bizLeaveEntity.getPost_name());
		keyValueMap.put("leave_time", bizLeaveEntity.getLeave_time());
		keyValueMap.put("ts", bizLeaveEntity.getTs());
		keyValueMap.put("dr", bizLeaveEntity.getDr());
		keyValueMap.put("remark", bizLeaveEntity.getRemark());
		keyValueMap.put("work_time", bizLeaveEntity.getWork_time());
		keyValueMap.put("leave_day", bizLeaveEntity.getLeave_day());
		keyValueMap.put("already_day", bizLeaveEntity.getAlready_day());
		keyValueMap.put("rest_time", bizLeaveEntity.getRest_time());
		keyValueMap.put("leave_capital", bizLeaveEntity.getLeave_capital());
		keyValueMap.put("capital", bizLeaveEntity.getCapital());
		keyValueMap.put("leave_country", bizLeaveEntity.getLeave_country());
		keyValueMap.put("country", bizLeaveEntity.getCountry());
		keyValueMap.put("comment_bm", bizLeaveEntity.getComment_bm());
		keyValueMap.put("comment_ld", bizLeaveEntity.getComment_ld());
		keyValueMap.put("leave_type", bizLeaveEntity.getLeave_type());
		keyValueMap.put("leave_already", bizLeaveEntity.getLeave_already());
		keyValueMap.put("leave_reason", bizLeaveEntity.getLeave_reason());	
		keyValueMap.put("leave_time_end", bizLeaveEntity.getLeave_time_end());
		keyValueMap.put("rest_time_end", bizLeaveEntity.getRest_time_end());
		keyValueMap.put("dept_name", bizLeaveEntity.getDept_name());
		keyValueMap.put("userId", bizLeaveEntity.getDataUserId());
		keyValueMap.put("deptCode", bizLeaveEntity.getDataDeptCode());
		keyValueMap.put("orgId", bizLeaveEntity.getDataOrgId());
		keyValueMap.put("tenantId", bizLeaveEntity.getDataTenantId());
		keyValueMap.put("state", bizLeaveEntity.getState());
		keyValueMap.put("surplus_days", bizLeaveEntity.getSurplus_days());
		keyValueMap.put("total_days", bizLeaveEntity.getTotal_days());
		keyValueMap.put("xiujia_days", bizLeaveEntity.getXiujia_days());
		keyValueMap.put("qingjia_days", bizLeaveEntity.getQingjia_days());
		JSONObject json = new JSONObject();
		json.putAll(keyValueMap);
		mv.addObject("keyValueMap", json);
		mv.addObject("bizId", bizId);
		mv.addObject("view", "1");
		mv.addObject("tableName", tableName);
		mv.addObject("style", "view");
		mv.setViewName(viewName);
		return mv;
	}
   	@ResponseBody
	@RequestMapping("/togetFormViewParam")
	public Map<String, Object> togetFormViewParam(@RequestParam String bizId)throws Exception {
		BizLeaveEntity bizLeaveEntity=new BizLeaveEntity();
		bizLeaveEntity=leaveMgrService.findLeaveInfoById(bizId);
		Map<String, Object> keyValueMap = new HashMap<String, Object>();
		keyValueMap.put("id", bizId);
		keyValueMap.put("bizId_", bizId);
		keyValueMap.put("user_name", bizLeaveEntity.getUser_name());
		keyValueMap.put("post_name", bizLeaveEntity.getPost_name());
		keyValueMap.put("leave_time", bizLeaveEntity.getLeave_time());
		keyValueMap.put("ts", bizLeaveEntity.getTs());
		keyValueMap.put("dr", bizLeaveEntity.getDr());
		keyValueMap.put("remark", bizLeaveEntity.getRemark());
		keyValueMap.put("work_time", bizLeaveEntity.getWork_time());
		keyValueMap.put("leave_day", bizLeaveEntity.getLeave_day());
		keyValueMap.put("already_day", bizLeaveEntity.getAlready_day());
		keyValueMap.put("rest_time", bizLeaveEntity.getRest_time());
		keyValueMap.put("leave_capital", bizLeaveEntity.getLeave_capital());
		keyValueMap.put("capital", bizLeaveEntity.getCapital());
		keyValueMap.put("leave_country", bizLeaveEntity.getLeave_country());
		keyValueMap.put("country", bizLeaveEntity.getCountry());
		keyValueMap.put("comment_bm", bizLeaveEntity.getComment_bm());
		keyValueMap.put("comment_ld", bizLeaveEntity.getComment_ld());
		keyValueMap.put("leave_type", bizLeaveEntity.getLeave_type());
		keyValueMap.put("leave_already", bizLeaveEntity.getLeave_already());
		keyValueMap.put("leave_reason", bizLeaveEntity.getLeave_reason());	
		keyValueMap.put("leave_time_end", bizLeaveEntity.getLeave_time_end());
		keyValueMap.put("rest_time_end", bizLeaveEntity.getRest_time_end());
		keyValueMap.put("dept_name", bizLeaveEntity.getDept_name());
		keyValueMap.put("userId", bizLeaveEntity.getDataUserId());
		keyValueMap.put("deptCode", bizLeaveEntity.getDataDeptCode());
		keyValueMap.put("orgId", bizLeaveEntity.getDataOrgId());
		keyValueMap.put("tenantId", bizLeaveEntity.getDataTenantId());
		keyValueMap.put("state", bizLeaveEntity.getState());
		keyValueMap.put("surplus_days", bizLeaveEntity.getSurplus_days());
		keyValueMap.put("total_days", bizLeaveEntity.getTotal_days());
		keyValueMap.put("xiujia_days", bizLeaveEntity.getXiujia_days());
		keyValueMap.put("qingjia_days", bizLeaveEntity.getQingjia_days());
		return keyValueMap;
	}
	/**
	 * 名称: 附件页面. 
	 * 方法: 引入附件时访问此路径，对附件进行处理
	 * @return
	 */
	@RequestMapping("/accessory")
	public ModelAndView accessory(HttpServletRequest request) {

		String tableId = request.getParameter("tableId");
		ModelAndView mav = new ModelAndView();
		List<IWebDocumentEntity> list = documentService
				.selectBySql("SELECT * from iweb_document where file_status ='0' and enabled = '1' and table_id = '"
						+ tableId + "' order by serial_number");
		mav.setViewName("cap/sys/plupload/accessorys");
		mav.addObject("list", list);
		mav.addObject("tableId", tableId);
		return mav;
	}
	@RequestMapping("exportWord")
	public void exportWord(HttpServletResponse response,
			HttpServletRequest request) throws Exception {
		String bizId = request.getParameter("bizId");
		BizLeaveEntity bizLeaveEntity=new BizLeaveEntity();
		try {
			if (StringUtils.isNotEmpty(bizId)) {
				// add by lzw 获取打印配置
				// 打印模板
				String template = "基金办请假审批表.ftl";
				String title = "基金办请假审批表";
				String fileName=title+".doc";
				// 实体信息
				bizLeaveEntity=leaveMgrService.findLeaveInfoById(bizId);
				String path = createWord(bizLeaveEntity, template,title,response);
			if (path != "1") {// 返回 1 失败
				OutputStream o;
				try {
					o = response.getOutputStream();
					byte b[] = new byte[1024];
					// 开始下载文件
					fileName = fileName.replaceAll(" ", "");
					File fileLoad = new File(path);
					response.setContentType("application/msword");
					response.setHeader(
							"Content-Disposition",
							"attachment;filename="
									+ java.net.URLEncoder.encode(fileName,
											"UTF-8"));
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
				} catch (IOException e) {
					e.printStackTrace();
				}
			} else {
				response.setContentType("text/xml; charset=utf-8");
				PrintWriter out;

				out = response.getWriter();
				out.print("<script>alert('下载失败！');</script>");
				out.close();

			}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}
	/**
	 * 
	 * @Description: 在服务器上通过参数生成Word文件
	 * @param @param obj
	 * @param @param template
	 * @param @param idea
	 * @param @param response
	 * @param @return
	 * @return String
	 * @throws Exception 
	 * @author hegd
	 * @date 2016-8-24
	 */
	public static String createWord(Object obj, String template, String fileName,
			HttpServletResponse response) throws Exception {
		Map<String, Object> map = getEntityData(obj);
		Configuration cfg = new Configuration();
		try {
			String ftlPath = new PropertiesLoader("config.properties").getProperty("ftlPath");
			cfg.setDirectoryForTemplateLoading(new File(ftlPath));
			cfg.setDefaultEncoding("utf-8");
			// 获取模板文件
			Template t = cfg.getTemplate(template);
			fileName = fileName + ".doc";
			File outFile = new File(ftlPath + "\\" + fileName); // 导出文件
			String path = ftlPath + "\\" + fileName;
			Writer out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(outFile), "utf-8"));
			t.process(map, out); // 将填充数据填入模板文件并输出到目标文件
			out.flush();
			out.close();
			return path;
		} catch (Exception e) {
			e.printStackTrace();
			return "1";
		}
	}
	/**
	 * 反射机制获取实体属性以及值
	 * @param obj
	 * @return Map<String, Object>
	 * @author luzhw
	 * @data   2016-09-06
	 */
	private static Map<String, Object> getEntityData(Object obj) {
		Map<String, Object> keyValueMap = new HashMap<String, Object>();
		try {
			if (null != obj) {
				// 获得object对象对应的所有已申明的属性，包括public、private、和protected
				Field[] fields = obj.getClass().getDeclaredFields();
				// 获取object对象中的方法
				Method[] methods = obj.getClass().getDeclaredMethods();
				String name = "";// 属性名称
				String fieldGetName = "";// 属性get方法名
				Object value = null;// 属性值
				for (Field field : fields) {
					name = field.getName();
					fieldGetName = parGetName(name);// 获取属性get方法名称
					if (!checkGetMet(methods, fieldGetName)) {// 判断是否存在某属性的 get方法
						continue;
					}
					// 获取get方法
					Method fieldGetMet = obj.getClass().getMethod(fieldGetName);
					// 使用get方法获取该属性的值
					value = fieldGetMet.invoke(obj);
					// 调用getter方法获取属性值
					if (value != null) {
						keyValueMap.put(name, value);
					} else {
						keyValueMap.put(name, "");
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return keyValueMap;

	}
	/**
	 * 拼接某属性的 get方法
	 * 
	 * @param fieldName
	 * @return String
	 */
	private static String parGetName(String fieldName) {
		if (null == fieldName || "".equals(fieldName)) {
			return null;
		}
		return "get" + fieldName.substring(0, 1).toUpperCase()
				+ fieldName.substring(1);
	}
	/**
	 * 判断是否存在某属性的 get方法
	 * 
	 * @param methods
	 * @param fieldGetMet
	 * @return boolean
	 */
	private static boolean checkGetMet(Method[] methods, String fieldGetMet) {
		for (Method met : methods) {
			if (fieldGetMet.equals(met.getName())) {
				return true;
			}
		}
		return false;
	}

	@RequestMapping("printWord")
	public void printWord(HttpServletRequest request,HttpServletResponse response) throws Exception {
		String bizId = request.getParameter("bizId");
		BizLeaveEntity bizLeaveEntity=new BizLeaveEntity();
		try {
			if (StringUtils.isNotEmpty(bizId)) {
				// 打印模板
				String template = "基金办请假审批表.ftl";
				String title = "基金办请假审批表";
				//String fileName=title+".doc";
				// 实体信息
				bizLeaveEntity=leaveMgrService.findLeaveInfoById(bizId);
				createWord(bizLeaveEntity, template,title,response);
				JSONObject json = new JSONObject();
				json.put("filename", title);
				response.setContentType("text/xml;charset=utf-8");

				json.toString().getBytes("utf-8");
				response.getWriter().print(json);
				response.getWriter().flush();
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
	@RequestMapping("/exportLeaveInfoToExcel/{search}")
	public void exportUserInfoToExcel(HttpServletRequest request,
			@PathVariable String search,
			HttpServletResponse response) throws IOException {	
		StringBuffer wheresql = new StringBuffer();
		search = new String(search.getBytes("iso-8859-1"), "utf-8");
		if(!"search".equals(search)){
			wheresql.append("AND user_name LIKE '%" + search + "%' ");
		}
			
		String filePath = leaveMgrService.exportLeaveInfoToExcel(wheresql.toString(),modCode);
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
		if (null != agent && -1 != agent.indexOf("MSIE")) // IE
		{
			downLoadName = java.net.URLEncoder.encode(file.getName(), "UTF-8");
		} else if (null != agent && -1 != agent.indexOf("Mozilla")) // Firefox
		{
			downLoadName = new String(file.getName().getBytes("UTF-8"),
					"iso-8859-1");
		} else {
			downLoadName = java.net.URLEncoder.encode(file.getName(), "UTF-8");
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
}
