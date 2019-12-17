package com.yonyou.aco.leaddesktop.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.activiti.engine.TaskService;
import org.activiti.engine.task.Task;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.biz.service.IBpmRunService;
import com.yonyou.aco.leaddesktop.dao.LeadDeskTopDao;
import com.yonyou.aco.leaddesktop.service.LeadDeskTopService;
import com.yonyou.cap.bpm.dao.IBizSolDao;
import com.yonyou.cap.bpm.entity.BpmReFormNodeBean;
import com.yonyou.cap.bpm.entity.BpmReNodeCfgBean;
import com.yonyou.cap.bpm.entity.BpmReNodeCfgEntity;
import com.yonyou.cap.bpm.entity.BpmReNodeUserEntity;
import com.yonyou.cap.bpm.entity.BpmRuBizInfoEntity;
import com.yonyou.cap.bpm.entity.DeskTaskBean;
import com.yonyou.cap.bpm.entity.TaskNodeBean;
import com.yonyou.cap.bpm.service.IBizSolService;
import com.yonyou.cap.bpm.service.IBpmQueryService;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.bpm.service.IBpmService;
import com.yonyou.cap.bpm.util.BpmConstants;
import com.yonyou.cap.bpm.util.BpmUtils;
import com.yonyou.cap.form.service.IFormColumnService;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.entity.UserAll;
import com.yonyou.cap.isc.user.service.IUserService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * <p>概述：业务模块领导桌面流程Controller层
 * <p>功能：领导桌面一键审阅
 * <p>作者：葛鹏
 * <p>创建时间：2016年12月10日
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/leaddtpflow")
public class LeadDeskTopFlowController {
	@Resource
	TaskService taskService;
	@Resource
	LeadDeskTopService service;
	@Resource
	IBpmRunService bpmRunService;
	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;
	@Resource
	IBizSolService bizSolService;
	@Resource
	IBpmService ibpmService;
	@Resource
	IBpmQueryService bpmQueryService;
	@Resource
	LeadDeskTopDao leadDeskTopDao;
	@Resource
	IUserService userService;
	@Resource
	IFormColumnService formColumnService;
	@Resource
	IBpmService bpmService;
	@Resource
	IBizSolDao bizSolDao;
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * 一键审阅
	 * @param bizId
	 * @param taskId
	 * @param comment
	 * @return
	 */
	@SuppressWarnings("unused")
	@RequestMapping("/reviewForOnce")
	public ModelAndView reviewForOnce(@RequestParam(value = "ids",defaultValue = "") String ids
							  ){
		ModelAndView mv = new ModelAndView();
		for(int i=0;i<ids.length();i++){
			String id=ids.split(",")[i];
			
		}
		
		
		
		/*if(StringUtils.isNotEmpty(bizId) && StringUtils.isNotEmpty(taskId)){
			BpmRuBizInfoEntity bizInfoEntity = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
			String solId = bizInfoEntity.getSolId_();// 业务解决方案
			String procInstId = bizInfoEntity.getProcInstId_();// 流程实例
			String procDefId = "";// 流程定义名称
			String commentColumn = "";// 环节需要批示的意见字段
			String isFreeSelect = "0";// 是否为自由流程 0 :不是 1：是
			String title = bizInfoEntity.getBizTitle_();
			// 获取 流程定义id
			procDefId = bizInfoEntity.getProDefId_();
			Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
			commentColumn = bpmRuBizInfoService.findColumnNameBySolIdAndProcdefIdAndActId(solId,
					procDefId, task.getTaskDefinitionKey());
			commentColumn = BpmUtils.changeColumnName(commentColumn);
			BpmReNodeCfgBean cfgBean = bizSolService.findOverallSituationNodeCfg(solId,
					procDefId);
			isFreeSelect = String.valueOf(cfgBean.getFreeSelect_());
			List<TaskNodeBean> list = null;
			String isExeUser = "";
			if (StringUtils.isNotEmpty(taskId)) {
				list = bpmRunService.findSendTaskNode(procDefId, isFreeSelect, taskId);
			} else {
				list = bpmRunService.findSendTaskNode(procDefId,isExeUser, isFreeSelect);
			}
			mv.addObject("list",list);
			mv.addObject("title", title);
			mv.addObject("solId", solId);
			mv.addObject("bizId", bizId);
			mv.addObject("isFreeSelect", isFreeSelect);
			mv.addObject("procDefId", procDefId);
			mv.addObject("procInstId", procInstId);
			mv.addObject("taskId", taskId);
			mv.addObject("sendState", bizInfoEntity.getSendState_());
			mv.addObject("fieldName", commentColumn);// 意见字段名称
			mv.setViewName("/sxczbg/leaddesktop/review_for_once");
		}*/
		return mv;
	}
	/**
	 * @跳转到一键审阅页面
	 */
	@RequestMapping("/openForOnce")
	public ModelAndView openForOnce(HttpServletRequest request){
		ModelAndView mv=new ModelAndView();
		String ids=request.getParameter("ids");
		mv.addObject("ids", ids);
		//mv.setViewName("aco/home/todo/reviewlist");
		mv.setViewName("cap/isc/theme/person/todo/reviewlist");
		return mv;
	}
	/**
	 * @跳转到一键审阅页面
	 */
	@RequestMapping("/listReview")
	public @ResponseBody  List<Map<String, Object>> listReview(@RequestParam(value = "ids", defaultValue = "") String ids){
		try {
			List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = null; 
			List<DeskTaskBean> desklist = null;
			List<TaskNodeBean> tasklist=null;
			String[] reviewIds=null;
			BpmRuBizInfoEntity bizInfoEntity = new BpmRuBizInfoEntity();
			String id="";
			String commentColumn = "";   //(页面参数)当前环节需要批示的意见字段
			if(ids!=null&&!"".equals(ids)){
				reviewIds=ids.split(",");
			for(int i=0;i<reviewIds.length;i++){
				map=new HashMap<String, Object>();
				id=reviewIds[i];
				desklist=service.findDeskTaskList(id);
				DeskTaskBean entity = desklist.get(0);
				bizInfoEntity=leadDeskTopDao.findEntityByPK(BpmRuBizInfoEntity.class, id);
				if(bizInfoEntity!=null){
				BpmReFormNodeBean beginForm = bpmRuBizInfoService.findFormInfo(bizInfoEntity.getSolId_(),BpmConstants.FORM_SCOPE_BEGIN);
				tasklist = bpmRunService.findSendTaskNode(bizInfoEntity.getProDefId_(), "", entity.getTaskId());				
				BpmReNodeCfgEntity nodeEntity=findTaskNodeCfg(entity.getSolid(),bizInfoEntity.getProDefId_(),tasklist.get(0).getActId(),id);
				Task task = taskService.createTaskQuery().taskId(entity.getTaskId()).singleResult();
				// 获取业务解决方案全局节点配置，获取是否正文、是否有附件页以及生成对应链接链接
				BpmReNodeCfgBean cfgBean = bpmRuBizInfoService.findOverallSituationNodeCfg(bizInfoEntity.getSolId_(),bizInfoEntity.getProDefId_());
				// 获取当前办理节点配置信息
				BpmReNodeCfgEntity taskNodeCft = bizSolDao.findTaskNodeCfg(bizInfoEntity.getSolId_(),
						bizInfoEntity.getProDefId_(), task.getTaskDefinitionKey());
				commentColumn=taskNodeCft.getColumnName_();
				String formType = beginForm.getFormType_()+"";
				if (formType != null && formType.equals("1")) {
					commentColumn=BpmUtils.changeColumnName(taskNodeCft.getColumnName_());
				}
				if(nodeEntity!=null){
					 map.put("userId", nodeEntity.getUserId());
		             map.put("userName", nodeEntity.getUserName());
				}else{
					 map.put("userId", "");
		             map.put("userName", "");
				}
				map.put("tasklist",tasklist);
				map.put("id", entity.getId());
                map.put("title", entity.getTaskname());
                map.put("taskId", entity.getTaskId());
                map.put("actId", tasklist.get(0).getActId());
                map.put("procdefId", bizInfoEntity.getProDefId_());
                map.put("solId", bizInfoEntity.getSolId_());
                map.put("actType", tasklist.get(0).getActType());
                map.put("commentColumn", commentColumn);
                map.put("isFreeSelect", cfgBean.getFreeSelect_() + "");
                list.add(map);
			}}
				}
			return list;
		} catch (Exception ex) {
			logger.error("error",ex);
			return null;
		}
	}
	public BpmReNodeCfgEntity findTaskNodeCfg(
			@RequestParam(required=true) String solId,
			@RequestParam(required=true) String procdefId,
			@RequestParam(required=true) String actId,
			@RequestParam(required=false) String bizId
			){
		BpmReNodeCfgEntity nodeEntity = bizSolService.findTaskNodeCfg(solId, procdefId, actId);
		//获取当前节点的人员配置信息
		List<BpmReNodeUserEntity> listNode = bizSolService.findNodeUser(procdefId, actId,solId,"1");
		UserAll ua=null;
//		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		//根据业务id查询基本业务信息
		BpmRuBizInfoEntity info = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
		//根据创建人查询所在部门
		User createUser=userService.findUserById(info.getCreateUserId_());
		for(BpmReNodeUserEntity node:listNode){
			if("1".equals(node.getUser_type_())){
				//后台配置信息为拟稿人(通过bizId查询拟稿人的基本信息)
				UserAll userNew =  bizSolService.findUserInfoBybizId(bizId);
				//如果节点人员变量逻辑为and，进行人员的拼接，否则显示当前机构的人员
				if("AND".equals(node.getOperator_())){
					if(ua!=null){
						ua=addUser(ua,userNew);
					}else{
						ua=userNew;
					}
				}else{
					if(userNew!=null){
						if(userNew.getDeptId().equals(createUser.getDeptId())){
							ua=userNew;
						}
					}
				}
			}else if("2".equals(node.getUser_type_())){
				//后台配置人员信息
				List<UserAll> userNew = bizSolService.findUserInfo(procdefId, actId, solId);
				for(UserAll u:userNew){
					if("AND".equals(u.getOPERATOR_())){
						if(ua!=null){
							ua=addUser(ua,u);
						}else{
							ua=u;
						}
					}else{
						if(u.getDeptId().equals(createUser.getDeptId())){
							ua=u;
						}
					}
				}
			}else if("13".equals(node.getUser_type_())){
				BpmReFormNodeBean beginForm = bpmRuBizInfoService.findFormInfo(
						solId, BpmConstants.FORM_SCOPE_BEGIN);
				if(beginForm != null){
					if(beginForm.getFormType_() != null && beginForm.getFormType_()=='2'){
						//自由表单
//						if(StringUtils.isNotEmpty(node.getUser_value_())){
//							String userId  = formColumnService.getTabDataByColId(bizId, node.getUser_value_());
//							if(StringUtils.isNotEmpty(userId)){
//								ua = new UserAll();
//								ua.setUserId(userId);
//								ua.setUserName(userService.findEntityByPK(userId));
//							}
//							node.setUser_name_(formColumnService.getColNameByColId(node.getUser_value_()));
//						}
					}else{
						ua = bizSolService.findUserInForm(bizId, beginForm.getTableName_(),node.getUser_value_());
					}
				}
			}
		}
		if(ua!=null){
			nodeEntity.setUserId(ua.getUserId());
			nodeEntity.setUserName(ua.getUserName());
		}
		return nodeEntity;
	}
	/**
	 * 方法: 下一环节审批节点人员组合.
	 * @param originalUser已有人员，需加入的人员
	 * @return
	 */
	public UserAll addUser(UserAll originalUser,UserAll newUser){
		originalUser.setUserId(originalUser.getUserId()+","+newUser.getUserId());
		originalUser.setUserName(originalUser.getUserName()+","+newUser.getUserName());
		return originalUser;
	}
	@RequestMapping("/startProcess")
	public @ResponseBody String startProcess(@RequestParam(value = "obj", defaultValue = "") String obj){
		String flag = "0";// 0：失败,1:成功
		JSONArray json = JSONArray.fromObject(obj); 
		if(json.size()>0){
		  for(int i=0;i<json.size();i++){
			  JSONObject job = json.getJSONObject(i);  // 遍历 jsonarray 数组，把每一个对象转成 json 对象
			  flag=startBpmProcess(job.get("id").toString(),job.get("isFreeSelect").toString(),job.get("sendUserId").toString(),job.get("actId").toString(),
					    job.get("commentColumn").toString(),job.get("comment").toString(),job.get("taskId").toString(),job.get("procdefId").toString());
		  }
		}		
		return flag;
	}
	/**
	 * 公共提交按钮操作
	 * @param bizId        业务Id
	 * @param isFreeSelect 流程是否允许自由跳转
	 * @param userId       处理人Id
	 * @param nodeId 	         下一环节节点actId
	 * @param fieldName    当前意见字段
	 * @param comment      当前环节处理意见
	 * @param taskId       当前任务Id(流程已经启动时需要)
	 * @param procdefId    流程定义Id(任务没有启动时候需要)
	 * @return
	 */
	public String startBpmProcess(String bizId, String isFreeSelect,String userId,String nodeId,
                                  String fieldName,String comment,String taskId,String procdefId) {
		String flag = "0";// 0：失败,1:成功
		try {
			if (StringUtils.isNotEmpty(bizId)) {
				if(StringUtils.isNotEmpty(taskId)){
					flag = bpmService.runBpmProcess(bizId, taskId, nodeId,isFreeSelect, userId, fieldName, comment, "",null);
				}else{
					if(StringUtils.isNotEmpty(procdefId)){
						flag = bpmService.startBpmProcess(bizId, procdefId, nodeId,isFreeSelect, userId, fieldName, comment, "");
					}
				}
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		
		return flag;
	}
	@RequestMapping("/findActTypeByActId")
	public @ResponseBody String findActTypeByActId(@RequestParam(value = "actId", defaultValue = "") String actId){
		return service.findActTypeByActId(actId);
	}
	@RequestMapping("/findCirculate")
	public @ResponseBody String findCirculate(@RequestParam(value = "ids", defaultValue = "") String ids){        
		return service.findCirculate(ids);				 
	}
}
