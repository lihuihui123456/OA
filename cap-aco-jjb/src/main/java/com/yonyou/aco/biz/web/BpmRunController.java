package com.yonyou.aco.biz.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.activiti.engine.HistoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricTaskInstance;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.task.Task;
import org.activiti.engine.task.TaskInfo;
import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springside.modules.utils.Identities;

import com.yonyou.aco.biz.entity.BizNodeFormBean;
import com.yonyou.aco.biz.service.IBizRunService;
import com.yonyou.aco.biz.service.IBpmRunService;
import com.yonyou.cap.bpm.entity.BizRuNestEntity;
import com.yonyou.cap.bpm.entity.BpmReFormNodeBean;
import com.yonyou.cap.bpm.entity.BpmReNodeCfgEntity;
import com.yonyou.cap.bpm.entity.BpmReSolInfoEntity;
import com.yonyou.cap.bpm.entity.BpmRuBizInfoEntity;
import com.yonyou.cap.bpm.entity.TaskNodeBean;
import com.yonyou.cap.bpm.service.IBizSolService;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.bpm.service.IBpmService;
import com.yonyou.cap.bpm.util.BpmConstants;
import com.yonyou.cap.common.util.BrowserTypeUntil;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.service.IUserService;
/**
 * 概 述：       业务运行控制层
 * 功 能：       实现业务运行时请求处理
 * 作 者：       卢昭炜
 * 创建时间：2016-11-09
 * 类调用特殊情况：
 */
@Controller
@RequestMapping("/bpmRunController")
public class BpmRunController {
	
	@Resource
	IBpmRunService bpmRunService;
	@Resource
	IBizSolService bizSolService;
	@Resource
	IBpmService bpmService;
	@Resource
	IUserService userService;
	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;
	@Resource
	HistoryService historyService;
	@Resource
	RuntimeService runtimeService;
	@Resource
	TaskService taskService;
	@Resource
	IBizRunService bizRunService;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 业务模块列表页公共跳转方法
	 * @param solId  业务解决方案id
	 * @return
	 */
	@RequestMapping("/bpmRunList/{solId}")
	public ModelAndView bpmRunList(@PathVariable String solId) {
		ModelAndView mv = new ModelAndView();
		String url = "";
		// 获取业务解决方案绑定的明细表单配置
		BpmReFormNodeBean bean = bpmRuBizInfoService.findFormInfo(solId,
				BpmConstants.FORM_SCOPE_DETAILS);
		if (null != bean) {
			String viewName = "";
			if (StringUtils.isNotEmpty(bean.getFormUrl_())) {
				viewName = bean.getFormUrl_();
				if(StringUtils.isNotEmpty(viewName)){
					int endIndex = viewName.indexOf(".");
					if(endIndex != -1){
						viewName = viewName.substring(0,endIndex);
					}
					
				}
			}
			// 列表页面请求连接
			url = "bpmRuBizInfoController/toBizInfoList?solId=" + solId + "&viewName=" + viewName;
		}
		mv.addObject("solId", solId);
		mv.addObject("src", url);
		mv.setViewName("/aco/bpm/template/form_list_template");
		return mv;
	}
	
	/**
	 * 业务模块拟稿页公共跳转方法
	 * @param solId   业务解决方案Id
	 * @return
	 */
	@RequestMapping("/draft")
	public ModelAndView draft(HttpServletRequest request) {
		String solId = request.getParameter("solId");
		String bizId = request.getParameter("bizId");
		if(StringUtils.isEmpty(bizId)){
			bizId = Identities.uuid();
		}
		ModelAndView mv = new ModelAndView("/aco/bpm/template/form_template");
		mv.addObject("operate", "draft");
		mv.addAllObjects(bpmRunService.getDraftProperty(solId ,bizId));
		
		//判断是不是移动端 start
		String userAgent = request.getHeader("user-agent");
		BrowserTypeUntil browseType=new BrowserTypeUntil();
		Boolean bl=browseType.isMobileDevice(userAgent);
		if(bl){
			mv.addObject("isphone", "1");
		}else{
			mv.addObject("isphone", "0");
		}
		//判断是不是移动端 end
		return mv;
	}
	
	/**
	 * 业务模块编辑页公共跳转方法
	 * @param solId   业务解决方案Id
	 * @param bizId   业务Id
	 * @param serialNumber  流水号
	 * @return
	 */
	@RequestMapping("/update")
	public ModelAndView update(HttpServletRequest request) {
		String bizId = request.getParameter("bizId"); 
		ModelAndView mv = new ModelAndView("/aco/bpm/template/form_template");
		mv.addAllObjects(bpmRunService.getUpdateProperty(bizId));
		mv.addObject("operate", "update");
		
		//判断是不是移动端 start
		String userAgent = request.getHeader("user-agent");
		BrowserTypeUntil browseType=new BrowserTypeUntil();
		Boolean bl=browseType.isMobileDevice(userAgent);
		if(bl){
			mv.addObject("isphone", "1");
		}else{
			mv.addObject("isphone", "0");
		}
		//判断是不是移动端 end
		return mv;
	}
	/**
	 * 业务模块办理页公共跳转方法
	 * @param bizId  业务Id
	 * @param taskId 任务Id
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping("/deal")
	public ModelAndView deal(@RequestParam String bizId, @RequestParam String taskId,HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(bpmRunService.getDealProperty(bizId, taskId));
		mv.addObject("operate", "deal");
		mv.setViewName("/aco/bpm/template/form_deal_template");
		//mv.setViewName("/aco/bpm/template/deal_template");
		//判断是不是移动端 start
		String userAgent = request.getHeader("user-agent");
		BrowserTypeUntil browseType=new BrowserTypeUntil();
		Boolean bl=browseType.isMobileDevice(userAgent);
		if(bl){
			mv.addObject("isphone", "1");
		}else{
			mv.addObject("isphone", "0");
		}
		//判断是不是移动端 end
		return mv;
	}
	
	/**
	 * 业务模块查看页公共跳转方法
	 * @param bizId   业务Id
	 * @param taskId  任务Id（非必须） 任务Id为空则业务流程未启动
	 * @return
	 */
	@RequestMapping("/view")
	public ModelAndView view(HttpServletRequest request) {
		String bizId = request.getParameter("bizId");
		String taskId = request.getParameter("taskId");
		//关闭查看页面时是否刷新父页面 true:刷新 false:不刷新
		String isRefresh = request.getParameter("isRefresh");
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(bpmRunService.getViewProperty(bizId, taskId));
		mv.addObject("isRefresh", isRefresh);
		//判断是不是移动端 start
		String userAgent = request.getHeader("user-agent");
		BrowserTypeUntil browseType=new BrowserTypeUntil();
		Boolean bl=browseType.isMobileDevice(userAgent);
		if(bl){
			mv.addObject("isphone", "1");
		}else{
			mv.addObject("isphone", "0");
		}
		//判断是不是移动端 end
		mv.setViewName("/aco/bpm/template/form_view_template");
		return mv;
	}
	
	/**
	 * 针对此文起草新文
	 * @return
	 */
	@RequestMapping("/doDraftNewTextForThisArticle")
	public ModelAndView doDraftNewTextForThisArticle(HttpServletRequest request){
		ModelAndView mv =new ModelAndView();
		String bizId = request.getParameter("bizId");
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				//通过bizId查询原文件
				BpmRuBizInfoEntity oldActicle = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
				//保存关联信息
				BizRuNestEntity actRuNestTaskEntity = new BizRuNestEntity();
				String newBizId = Identities.uuid2();
				actRuNestTaskEntity.setBizid(newBizId);
				actRuNestTaskEntity.setBizid_attach(bizId);
				actRuNestTaskEntity.setAttach_title(oldActicle.getBizTitle_());
				actRuNestTaskEntity.setCreate_time(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
				bpmRuBizInfoService.savefileattach(actRuNestTaskEntity);
				
				//旧版现在不用了
				//mv.addAllObjects(bpmRunService.getDraftProperty(oldActicle.getSolId_(),Identities.uuid2()));
				//mv.setViewName("/aco/bpm/template/form_draft_template");
				
				//判断是不是移动端 start
				String userAgent = request.getHeader("user-agent");
				BrowserTypeUntil browseType=new BrowserTypeUntil();
				Boolean bl=browseType.isMobileDevice(userAgent);
				if(bl){
					mv.addObject("isphone", "1");
				}else{
					mv.addObject("isphone", "0");
				}
				
				mv.addObject("bizId", newBizId);
				mv.addObject("status", 1);
				mv.addObject("solId", oldActicle.getSolId_());
				mv.setViewName("redirect:/bizRunController/getBizOperate");
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return mv;
	}
	
	/**
	 * 流程启动送交选项
	 * @param request
	 * @return
	 */
	@RequestMapping("/startProcessSendPage")
	public ModelAndView startProcessSendPage(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		String bizId = request.getParameter("bizId");
		String solId = request.getParameter("solId");
		String procdefId = request.getParameter("procdefId");
		String fieldName = request.getParameter("fieldName");
		try {
			List<TaskNodeBean> list = bpmRunService.findSendTaskNode(procdefId);
			mv.addObject("list", list);
			mv.addObject("bizId", bizId);
			mv.addObject("solId", solId);
			mv.addObject("procdefId", procdefId);
			mv.addObject("fieldName", fieldName);
			mv.setViewName("/aco/bpm/function/sendpage");
		} catch (Exception e) {
			logger.error("error",e);
		}
		return mv;
	}
	/**
	 * 流程启动送交选项
	 * @param request
	 * @return
	 */
	@RequestMapping("/startProcess")
	public ModelAndView startProcess(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		String bizId = request.getParameter("bizId");
		String solId = request.getParameter("solId");
		try {
			BpmReSolInfoEntity entity = bizSolService.findBizSolInfoIdById(solId);
			if(entity!=null) {
				List<TaskNodeBean> list = bpmRunService.findSendTaskNode(entity.getProcDefId_());
				BpmReNodeCfgEntity draftNodeCft = bizSolService.findDraftNodeCfg(solId,entity.getProcDefId_());
				mv.addObject("list", list);
				mv.addObject("bizId", bizId);
				mv.addObject("solId", solId);
				mv.addObject("procdefId", entity.getProcDefId_());
				if(draftNodeCft!=null) {
					mv.addObject("fieldName", draftNodeCft.getColumnName_());
				}
				mv.setViewName("/aco/bpm/function/sendpage");
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return mv;
	}
	
	/**
	 * 获取流程意见字段
	 * @param request
	 * @return
	 */
	@RequestMapping("/getProcessCommentFildName")
	@ResponseBody
	public String getProcessCommentFildName(@RequestParam String solId, @RequestParam String procdefId,
			HttpServletRequest request) {
		String taskId = request.getParameter("taskId");
		BpmReNodeCfgEntity entity = null;
		if(StringUtils.isNotEmpty(taskId)) {
			Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
			if(task != null) {
				entity = bizSolService.findTaskNodeCfg(solId, procdefId, task.getTaskDefinitionKey());
			}
		}else {
			entity = bizSolService.findDraftNodeCfg(solId, procdefId);
		}
		if(entity != null) {
			return entity.getColumnName_();
		}else {
			return null;
		}
	}
	
	/**
	 * 流程运行时送交选项
	 * @param request
	 * @return
	 */
	@RequestMapping("/dealProcess")
	public ModelAndView dealProcess(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		String bizId = request.getParameter("bizId");
		String taskId = request.getParameter("taskId");
		try {
			//查询业务基本信息
			BpmRuBizInfoEntity bizInfoEntity = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
			if(bizInfoEntity!=null){
				TaskInfo task = taskService.createTaskQuery().taskId(taskId).singleResult();
					if(task != null) {
						//节点配置信息
						BpmReNodeCfgEntity entity = bizSolService.findTaskNodeCfg(bizInfoEntity.getSolId_(), bizInfoEntity.getProDefId_(), task .getTaskDefinitionKey());
						if(entity!=null) {
							//获取流程当前环节节点指向的所有任务节点
							List<TaskNodeBean> list = bpmRunService.findSendTaskNode(bizInfoEntity.getProDefId_(), entity.getFreeSelect_(), taskId);
							mv.addObject("list", list);
							mv.addObject("bizId", bizId);
							mv.addObject("solId", bizInfoEntity.getSolId_());
							mv.addObject("taskId", taskId);
							mv.addObject("fieldName", entity.getColumnName_());
							mv.addObject("procdefId", bizInfoEntity.getProDefId_());
							mv.addObject("isFreeSelect", entity.getFreeSelect_());
							mv.addObject("sendState", bizInfoEntity.getSendState_());
					}else {
						logger.info("当前任务不存在!!!");
					}
				}else {
					logger.info("节点信息配置为空!!!");
				}
			}else {
				logger.info("业务基本信息为空!!!");
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		mv.setViewName("/aco/bpm/function/sendpage");
		return mv;
	}
	/**
	 * 流程运行时送交选项
	 * @param request
	 * @return
	 */
	@RequestMapping("/runProcessSendPage")
	public ModelAndView runProcessSendPage(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		String bizId = request.getParameter("bizId");
		String isFreeSelect = request.getParameter("isFreeSelect");
		String taskId = request.getParameter("taskId");
		String fieldName = request.getParameter("fieldName");
		try {
			BpmRuBizInfoEntity bizInfoEntity = bpmRuBizInfoService
					.findBpmRuBizInfoEntityById(bizId);
			if(bizInfoEntity!=null){
				List<TaskNodeBean> list = bpmRunService.findSendTaskNode(bizInfoEntity.getProDefId_(), isFreeSelect, taskId);
				mv.addObject("list", list);
				mv.addObject("bizId", bizId);
				mv.addObject("solId", bizInfoEntity.getSolId_());
				mv.addObject("taskId", taskId);
				mv.addObject("fieldName", fieldName);
				mv.addObject("procdefId", bizInfoEntity.getProDefId_());
				mv.addObject("isFreeSelect", isFreeSelect);
				mv.addObject("sendState", bizInfoEntity.getSendState_());
			}
			mv.setViewName("/aco/bpm/function/sendpage");
		} catch (Exception e) {
			logger.error("error",e);
		}
		return mv;
	}
	
	
	@RequestMapping(value = "/checkProcessBack")
	public @ResponseBody String checkProcessBack(@RequestParam(value = "taskId", required=true)String taskId) {
		JSONObject result = new JSONObject();
		Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
		if(task.getDescription() != null && BpmConstants.TASK_TYPE_JOINT.equals(task.getDescription())) {
			result.put("flag", "N");
			result.put("msg", task.getName());
			return result.toString();
		}
		result.put("flag", "Y");
		return result.toString();
	} 
	
	/**
	 * 流程退回
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/runProcessBackPage")
	public ModelAndView processBackPage(HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("/aco/bpm/function/backpage");
		String bizId = request.getParameter("bizId");
		String taskId = request.getParameter("taskId");
		mv.addObject("taskId", taskId);
		//获取当前环节意见字段
		BpmRuBizInfoEntity bizInfoEntity = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
		Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
		if(bizInfoEntity != null && task != null) {
			BpmReNodeCfgEntity entity = bizSolService.findTaskNodeCfg(bizInfoEntity.getSolId_(), bizInfoEntity.getProDefId_(), task .getTaskDefinitionKey());
			if(null != entity) {
				mv.addObject("fieldName", entity.getColumnName_());
				String backType = entity.getBackType_();
				if(StringUtils.isNotEmpty(backType)) {
					Map<String,TaskNodeBean> map = new LinkedHashMap<String, TaskNodeBean>();
					TaskNodeBean taskNodeBean = null;
					User user;
					List<HistoricTaskInstance> historicTaskInstances = historyService.createHistoricTaskInstanceQuery().processInstanceId(task.getProcessInstanceId())
							.finished().orderByHistoricTaskInstanceEndTime().asc().list();
					if(historicTaskInstances != null && !historicTaskInstances.isEmpty()) {
						if(backType.contains("2")) {
							//自由驳回
							List<ActivityImpl> findBackAvtivity = bpmService.findBackAvtivity(taskId);
							if(findBackAvtivity != null && !findBackAvtivity.isEmpty())
								for (HistoricTaskInstance historicTaskInstance : historicTaskInstances) {
									for (ActivityImpl activityImpl : findBackAvtivity) {
										String id = activityImpl.getId();
										if(historicTaskInstance.getTaskDefinitionKey().equals(id)) {
											taskNodeBean = new TaskNodeBean();
											taskNodeBean.setActName(historicTaskInstance.getName());
											taskNodeBean.setActId(historicTaskInstance.getTaskDefinitionKey());
											user = userService.findUserById(historicTaskInstance.getAssignee());
											if(user != null) {
												taskNodeBean.setUserId(user.getUserId());
												taskNodeBean.setUserName(user.getUserName());
											}
											map.put(taskNodeBean.getActId(), taskNodeBean);
										}
									}
								}
							
						}else {
							if(backType.contains("0")) {
								//驳回拟稿人
								HistoricTaskInstance firstHistoricTaskInstance = historicTaskInstances.get(0);
								taskNodeBean = new TaskNodeBean();
								taskNodeBean.setActName("返回拟稿人");
								taskNodeBean.setActId(firstHistoricTaskInstance.getTaskDefinitionKey());
								user = userService.findUserById(firstHistoricTaskInstance.getAssignee());
								if(user != null) {
									taskNodeBean.setUserId(user.getUserId());
									taskNodeBean.setUserName(user.getUserName());
								}
								map.put(taskNodeBean.getActId(), taskNodeBean);
							}
							if(backType.contains("1")) {
								//驳回上一节点
								ActivityImpl lastActivity = bpmService.getLastActivity(taskId);
								if(null != lastActivity) {
									String id = lastActivity.getId();
									for (HistoricTaskInstance historicTaskInstance : historicTaskInstances) {
										if(historicTaskInstance.getTaskDefinitionKey().equals(id)) {
											taskNodeBean = new TaskNodeBean();
											taskNodeBean.setActName("返回上一节点");
											taskNodeBean.setActId(historicTaskInstance.getTaskDefinitionKey());
											user = userService.findUserById(historicTaskInstance.getAssignee());
											if(user != null) {
												taskNodeBean.setUserId(user.getUserId());
												taskNodeBean.setUserName(user.getUserName());
											}
											map.put(taskNodeBean.getActId(), taskNodeBean);
										}
									}
								}
							}
						}
					}
					mv.addObject("nodeMap", map);
				}
			}
		 	
		}
		
	/*	//获取当前可退回的节点
		List<HistoricTaskInstance> firstAndNewActivitys = bpmService.getFirstAndNewActivitys(taskId);
		if(firstAndNewActivitys != null) {
			Map<String,TaskNodeBean> map = new LinkedHashMap<String, TaskNodeBean>();
			TaskNodeBean taskNodeBean = null;
			User user;
			HistoricTaskInstance historicTaskInstance;
			String draftTaskActId = "";
			for (int i = 0; i < firstAndNewActivitys.size(); i++) {
				historicTaskInstance = firstAndNewActivitys.get(i);
				taskNodeBean = new TaskNodeBean();
				taskNodeBean.setActId(historicTaskInstance.getTaskDefinitionKey());
				if(i != 0) {
					if(draftTaskActId.equals(taskNodeBean.getActId())){
						continue;
					}
					taskNodeBean.setActName("返回上一节点");
				}else {
					draftTaskActId = taskNodeBean.getActId();
					taskNodeBean.setActName("返回拟稿人");
				}
				user = userService.findUserById(historicTaskInstance.getAssignee());
				if(user != null) {
					taskNodeBean.setUserId(user.getUserId());
					taskNodeBean.setUserName(user.getUserName());
				}
				map.put(taskNodeBean.getActId(), taskNodeBean);
			}
			mv.addObject("nodeMap", map);
		}
		mv.addObject("taskId", taskId);*/
		return mv;
	}
	
	/**
	 * 流程撤回
	 * @param taskId
	 * @return
	 */
	@RequestMapping("/processRecall")
	@ResponseBody
	public Map<String, String> processRecall(@RequestParam(value="taskId", required=true) String taskId) {
		Map<String, String> resultMap = new HashMap<String, String>();
		HistoricTaskInstance historicTaskInstance = historyService.createHistoricTaskInstanceQuery().taskId(taskId).singleResult();
		if(historicTaskInstance == null) {
			resultMap.put("flag", "error");
			resultMap.put("msg", "当前已办理的任务不存在！");
			return resultMap;
		}
		List<Task> tasks = taskService.createTaskQuery().processInstanceId(historicTaskInstance.getProcessInstanceId()).list();
		if(tasks == null || tasks.isEmpty()) {
			resultMap.put("flag", "error");
			resultMap.put("msg", "流程已经结束！");
			return resultMap;
		}
		List<Task> list = new ArrayList<Task>();  
		for (Task task : tasks) {
			if(task.getParentTaskId() != null && task.getParentTaskId().equals(taskId)){
				list.add(task);
			}
		} 
		if(!list.isEmpty()) {
			try {
				Map<String, Object> variables;
				variables = new HashMap<String, Object>();
				variables.put("userId", historicTaskInstance.getAssignee());
				bpmService.callBackProcess(list.get(0).getId(), historicTaskInstance.getTaskDefinitionKey());
				Task newTask = taskService.createTaskQuery()
					.processInstanceId(historicTaskInstance.getProcessInstanceId())
					.taskDefinitionKey(historicTaskInstance.getTaskDefinitionKey())
					.orderByTaskCreateTime().desc()
					.singleResult();
				if(newTask == null) {
					resultMap.put("flag", "error");
					resultMap.put("msg", "撤回失败！");
					return resultMap;
				}
				newTask.setAssignee(historicTaskInstance.getAssignee());
				taskService.saveTask(newTask);
				resultMap.put("flag", "success");
				resultMap.put("msg", "撤回成功！");
			}
			catch (Exception e) {
				resultMap.put("flag", "error");
				resultMap.put("msg", "系统异常！");
				logger.error("流程撤回异常", e.getMessage());
			}
		}else {
			resultMap.put("flag", "error");
			resultMap.put("msg", "此任务不可以撤回！");
		}
		return resultMap;
	}
	/**
	 * 获取正文是否套红
	 * @param request
	 * @return
	 */
	@RequestMapping("/getWordTemplate")
	@ResponseBody
	public String getWordTemplate(@RequestParam String solId, @RequestParam String procdefId, @RequestParam String taskId){
		String template="0";
		if(StringUtils.isEmpty(taskId)){
			// 获取拟稿节点配置信息
			BpmReNodeCfgEntity draftNodeCft = bizSolService.findDraftNodeCfg(solId, procdefId);
			if (draftNodeCft != null){
				template=draftNodeCft.getRedPrint_();
			}
		}else{
			Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
			// 获取当前办理节点配置信息
			BpmReNodeCfgEntity taskNodeCft = bizSolService.findTaskNodeCfg(solId,
					procdefId, task.getTaskDefinitionKey());
			if(taskNodeCft!=null){
				template=taskNodeCft.getRedPrint_();
			}
		}		
		return template;
	}
	
	/**
	 * 跳转到发文转收文页面
	 */
	@RequestMapping("/toSwTurnToFw")
	public ModelAndView toSwTurnToFw(HttpServletRequest request){
		ModelAndView mv = new ModelAndView();
		String bizId = request.getParameter("bizId");
		mv.addObject("bizId", bizId);
		mv.setViewName("/aco/bpm/function/swturnrofw");
		return mv;
	}
	
	/**
	 * 收文转发文
	 * @return
	 */
	@RequestMapping("/doSwTurnToFw")
	@ResponseBody
	public String doSwTurnToFw(HttpServletRequest request){
		String bizId = request.getParameter("bizId");
		String solId = request.getParameter("solId");
		JSONObject json = new JSONObject();
		try {
			   String newBizId = Identities.uuid();
			   //BizNodeFormBean findNodeFormInfoByBizCode = bizRunService.findNodeFormInfoByBizCode(bizCode);
				//通过bizId查询原文件
				BpmRuBizInfoEntity oldActicle = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
				//保存关联信息
				BizRuNestEntity actRuNestTaskEntity = new BizRuNestEntity();
				actRuNestTaskEntity.setBizid(newBizId);
				actRuNestTaskEntity.setBizid_attach(bizId);
				actRuNestTaskEntity.setAttach_title(oldActicle.getBizTitle_());
				actRuNestTaskEntity.setCreate_time(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
				bpmRuBizInfoService.savefileattach(actRuNestTaskEntity);
			json.put("bizId", newBizId);
			json.put("solId", solId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return json.toString();
	}
	/**
	 * 收文转发文
	 * @return
	 */
	@RequestMapping("/getFwType")
	@ResponseBody
	public List<BizNodeFormBean> getFwType(HttpServletRequest request){
		try {
			String bizCode = request.getParameter("bizCode");
			List<BizNodeFormBean> findNodeFormInfoList = bizRunService.findNodeFormInfoList(bizCode);
			if(findNodeFormInfoList == null || findNodeFormInfoList.isEmpty()){
				return null;
			}
			return findNodeFormInfoList;
		} catch (Exception ex) {
			return null;
		}
	}
}
