package com.yonyou.aco.delegate.web;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.activiti.engine.TaskService;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springside.modules.utils.Identities;

import com.yonyou.aco.delegate.service.IDelegateService;
import com.yonyou.cap.bpm.entity.BizRuDelegateEntity;
import com.yonyou.cap.bpm.entity.BizSolBean;
import com.yonyou.cap.bpm.entity.BizSolRelationEntity;
import com.yonyou.cap.bpm.service.IBpmDelegateService;
import com.yonyou.cap.bpm.util.TimerTaskUtils;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;


/**
 * TODO:委托管理
 * TODO: 填写Class详细说明 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2017年03月28日
 * @author 申浩
 * @since 1.0.0
 */
@Controller
@RequestMapping("/delegate")
public class DelegateController {
	@Resource
	private IDelegateService delegateService;
	@Resource
	TaskService taskService;
	@Resource
	IBpmDelegateService bpmDelegateService;
	/**
	 * 名称: 跳转到委托管理页 
	 * @return
	 */
	@RequestMapping("/toDelegateList")
	public String toDelegateList() {
		return "/aco/delegate/delegate_list";
	}
	/**
	 * 获取所有委托信息
	 * @param pagen
	 * @param rows
	 * @param title 查询信息
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findDelegateList")
	public Map<String, Object> findDelegateList(@RequestParam(value = "page", defaultValue = "0") int pageNum,
			@RequestParam(value = "rows", defaultValue = "10") int pageSize,
			@RequestParam(value = "title", defaultValue = "") String title,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder) {
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user!=null){
				PageResult<BizRuDelegateEntity> pags;		
				pags = delegateService.findDelegateList(pageNum, pageSize,title,sortName,sortOrder,user.id);
				map.put("total", pags.getTotalrecord());
				map.put("rows", pags.getResults());
			}		
			return map;
		} catch (Exception e) {
			return null;
		}
	}
	/**
	 * 跳转到委托页面
	 * @param request
	 * @return
	 */
	@RequestMapping("/toDelegatePage")
	public ModelAndView toDelegatePage(HttpServletRequest request) {
		String userid=request.getParameter("userid");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/aco/delegate/sol_list");
		mv.addObject("userid", userid);
		return mv;
	}
	/**
	 * 获取所有委托信息
	 * @param pagen
	 * @param rows
	 * @param title 查询信息
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findSolList")
	public Map<String, Object> findSolList(@RequestParam(value = "page", defaultValue = "0") int pageNum,
			@RequestParam(value = "rows", defaultValue = "10") int pageSize,
			@RequestParam(value = "title", defaultValue = "") String title,
			@RequestParam(value = "userid", defaultValue = "") String userid) {
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			PageResult<BizSolBean> pags;		
			pags = delegateService.findSolList(pageNum, pageSize,userid,title);
			map.put("total", pags.getTotalrecord());
			map.put("rows", pags.getResults());
			return map;
		} catch (Exception e) {
			return null;
		}
	}
	/**
	 * 添加委托配置
	 * @param mr
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "doAddDelegate")
	public void doAddDelegate(@Valid BizRuDelegateEntity delegateEntity,HttpServletResponse response) throws IOException {
		try {
			String date = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
			String solid=delegateEntity.getSol_id();
			String solname=delegateEntity.getSol_name();
			String startTime=delegateEntity.getStart_time_()+" 00:00:00";
			String endTime=delegateEntity.getEnd_time_()+" 23:59:59";
			String newId = Identities.uuid();
			delegateEntity.setId(null);
			delegateEntity.setSol_id(null);
			delegateEntity.setSol_name(null);
			delegateEntity.setTs(date);
			delegateEntity.setDelegate_id(newId);
			delegateEntity.setStart_time_(startTime);
			delegateEntity.setEnd_time_(endTime);
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user!=null){
				delegateEntity.setCreate_user_id_(user.id);
				delegateEntity.setUpdate_user_id_(user.id);
			}
			delegateService.doAddDelegate(delegateEntity);
			String[] solids=solid.split(",");
			String[] solnames=solname.split(",");
			for(int i=0;i<solids.length;i++){
				BizSolRelationEntity solRelationEntity=new BizSolRelationEntity();
				solRelationEntity.setId(null);
				solRelationEntity.setDelegateId(newId);
				solRelationEntity.setSolId(solids[i]);
				solRelationEntity.setSolName(solnames[i]);
				delegateService.doAddSolRelation(solRelationEntity);
			}
			SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date beginDate=format.parse(date);
		    Date endDate=format.parse(endTime);
		    Long seconds=(endDate.getTime()-beginDate.getTime());
		    if(seconds>0){
		    	Timer timer = new Timer();
			    timer.schedule(new TimerTaskUtils(taskService,bpmDelegateService,newId), seconds);
		    }	
				// 另外一种response返回json
				response.getWriter().write("true");
				response.getWriter().flush();
			
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("false");
			response.getWriter().flush();
		}		
	}
	/**
	 * 删除委托配置
	 * @param mr
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "doDelDelegate")
	public void doDelDelegate(@RequestParam(value = "ids[]") String[] ids,@RequestParam(value = "delegates[]") String[] delegates,HttpServletResponse response) throws IOException {
		try {
				if (ids != null && ids.length != 0) {
					delegateService.doDelDelegate(ids,delegates);
					}
				// 另外一种response返回json
				response.getWriter().write("true");
				response.getWriter().flush();
			
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("false");
			response.getWriter().flush();
		}	
	}
	/**
	 * 修改委托配置
	 * @param mr
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "doUpdateDelegate")
	public void doUpdateDelegate(@Valid BizRuDelegateEntity delegateEntity,HttpServletResponse response) throws IOException {
		try {
			String date = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
			String newId = Identities.uuid();
			String solid=delegateEntity.getSol_id();
			String solname=delegateEntity.getSol_name();
			String delegateId = delegateEntity.getDelegate_id();
			String startTime=delegateEntity.getStart_time_()+" 00:00:00";
			String endTime=delegateEntity.getEnd_time_()+" 23:59:59";
			delegateEntity.setSol_id(null);
			delegateEntity.setSol_name(null);
			delegateEntity.setDelegate_id(newId);
			delegateEntity.setTs(date);
			delegateEntity.setStart_time_(startTime);
			delegateEntity.setEnd_time_(endTime);
			BizRuDelegateEntity delegate=delegateService.findBizRuDelegateEntityById(delegateEntity.getId());
			delegateEntity.setCreate_user_id_(delegate.getCreate_user_id_());
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user!=null){
				delegateEntity.setUpdate_user_id_(user.id);
			}
			delegateService.doUpdateDelegate(delegateEntity);
			List<BizSolBean> list=delegateService.findSolRelations(delegateId);
			for(int j=0;j<list.size();j++){
				delegateService.doDelete(list.get(j).getId_());	
			}			
			String[] solids=solid.split(",");
			String[] solnames=solname.split(",");
			for(int i=0;i<solids.length;i++){
				BizSolRelationEntity solRelationEntity=new BizSolRelationEntity();
				solRelationEntity.setId(null);
				solRelationEntity.setDelegateId(newId);
				solRelationEntity.setSolId(solids[i]);
				solRelationEntity.setSolName(solnames[i]);
				delegateService.doAddSolRelation(solRelationEntity);
			}	
			SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date beginDate=format.parse(date);
		    Date endDate=format.parse(endTime);
		    Long seconds=(endDate.getTime()-beginDate.getTime());
		    if(seconds>0){
		    	Timer timer = new Timer();
			    timer.schedule(new TimerTaskUtils(taskService,bpmDelegateService,newId), seconds);
		    }
				// 另外一种response返回json
				response.getWriter().write("true");
				response.getWriter().flush();
			
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("false");
			response.getWriter().flush();
		}		
	}
	/**
	 * 名称: 查询委托信息
	 * 说明: 通过主键查询委托信息
	 * @param id
	 * @return
	 */
	@RequestMapping(value ="findDelegateInfo")
	public @ResponseBody BizRuDelegateEntity findDelegateInfo(@RequestParam(value = "id") String id,
			@RequestParam(value = "delegate_id") String delegate_id){
		BizRuDelegateEntity delegateEntity=null;
		delegateEntity=delegateService.findBizRuDelegateEntityById(id);
		List<BizSolBean> list=delegateService.findSolRelations(delegate_id);
		String solids="";
		String solnames="";
		if(list!=null&&list.size()>0){
			for(int i=0;i<list.size();i++){
				solids=solids+list.get(i).getSol_id()+",";
				solnames=solnames+list.get(i).getSol_name()+",";
			}
		}
		solids=solids.substring(0, solids.length()-1);
		solnames=solnames.substring(0, solnames.length()-1);
		delegateEntity.setSol_id(solids);
		delegateEntity.setSol_name(solnames);
		return delegateEntity;
	}
}
