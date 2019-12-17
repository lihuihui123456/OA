package com.yonyou.aco.biz.service.impl;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.activiti.engine.HistoryService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricTaskInstance;
import org.activiti.engine.task.Task;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.yonyou.aco.biz.service.IBpmRuFormInfoService;
import com.yonyou.aco.biz.service.IBpmRunService;
import com.yonyou.cap.bpm.dao.IBizSolDao;
import com.yonyou.cap.bpm.dao.IBpmRuBizInfoDao;
import com.yonyou.cap.bpm.entity.BpmReFormNodeBean;
import com.yonyou.cap.bpm.entity.BpmReNodeCfgBean;
import com.yonyou.cap.bpm.entity.BpmReNodeCfgEntity;
import com.yonyou.cap.bpm.entity.BpmReNodeEntity;
import com.yonyou.cap.bpm.entity.BpmRuBizInfoEntity;
import com.yonyou.cap.bpm.entity.TaskNodeBean;
import com.yonyou.cap.bpm.service.IBizSolService;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.bpm.service.IBpmService;
import com.yonyou.cap.bpm.service.IDocNumMgrService;
import com.yonyou.cap.bpm.util.BpmConstants;
import com.yonyou.cap.bpm.util.BpmUtils;

/**
 * <p> 概述：业务信息service层接口
 * <p> 功能：实现业务信息逻辑处理
 * <p> 作者：卢昭炜
 * <p> 创建时间：2016-07-24
 * <p> 类调用特殊情况：无
 */
@Service("bpmRunService")
public class BpmRunServiceImpl implements IBpmRunService {
	
	@Resource
	IBpmService bpmService;
	@Resource
	TaskService taskService;
	@Resource
	IBizSolService bizSolService;
	@Resource
	IBpmRuBizInfoDao bpmRuBizInfoDao;
	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;
	@Resource
	IBpmRuFormInfoService bpmRuFormInfoService;
	@Resource
	HistoryService historyService;
	
	
	@Resource
	IBizSolDao bizSolDao;
	@Resource
	IDocNumMgrService docNumMgrService;
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/** 是否标记：是 */
	public static String YES = "1";
	
	/** 是否标记：否 */
	public static String NO = "0";
	
	/**
	 * 获取当前环节节点指向的下一环节任务节点
	 */
	@Override
	public List<TaskNodeBean> findSendTaskNode(String procdefId, 
			String isFreeSelect, String taskId) {
		List<TaskNodeBean> list = null;
		try {
			String actId = "";
			//获取当前任务节点Id
			Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
			if(task != null) {
				actId = task.getTaskDefinitionKey();
				//根据流程定义id,任务节点id查询节点信息
				TaskNodeBean bean = bpmService.findTaskNodeBeanByProcDefIdAndActParentId(procdefId, actId);
				if ("exclusiveGateway".equals(bean.getActType())) {
					actId = bean.getActId();
				}
				list = bpmService.findTaskNodeBeanListByProcDefIdAndActParentId(procdefId, actId);
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return list;
	}
	
	/**
	 * 获取当前环节节点指向的下一环节任务节点
	 */
	@Override
	public List<TaskNodeBean> findNextTaskNodes(String isFreeSelect, String taskId) {
		List<TaskNodeBean> list = null;
		try {
			String actId = "";
			String procDefId = "";
			//获取当前任务节点Id
			Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
			actId = task.getTaskDefinitionKey();
			procDefId = task.getProcessDefinitionId();
			//根据流程定义id,任务节点id查询节点信息
			TaskNodeBean bean = bpmService.findTaskNodeBeanByProcDefIdAndActParentId(procDefId, actId);
			if ("exclusiveGateway".equals(bean.getActType())) {
				actId = bean.getActId();
			}
			list = bpmService.findTaskNodeBeanListByProcDefIdAndActParentId(procDefId, actId);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return list;
	}


	
	/**
	 * 获取业务拟稿属性
	 * @param  solId 业务解决方案
	 * @return (Map<String, Object>) map  业务拟稿所需要的属性
	 */
	@Override
	public Map<String, Object> getDraftProperty(String solId, String bizId) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			/*业务基本信息页面参数 以及 送交参数*/
			String isFreeSelect = NO;   //(送交参数)流程是否自由跳转   0：否  1：是
			String procdefId = "";     //(页面参数、送交参数)业务绑定流程定义Id
			String tableName = "";       //(页面参数)表单所对应的数据表
			String sfwType = "";         //(页面参数)收发文类别
			String commentColumn = "";   //(页面参数)当前环节需要批示的意见字段
			
			/*拟稿页面显示参数*/
			String formType = "";
			String formName = "";       //表单页签显示名称
			String formsrc = "";        //表单页面访问链接
			String isMainBody = NO;      //页面是否显示正文页签   0：不显示  1：显示
			String mainBodySRC = "";    //正文页面访问链接
			String isAttachment = NO;    //页面是否显示附件页签   0：不显示   1：显示
			String attachmentSRC = "";  //附件页面访问链接
			String symbol = "";   //是否有文号标记
			String docno="";//文号
			// 获取业务解决方案开始节点绑定的表单信息
			BpmReFormNodeBean beginForm = bpmRuBizInfoService.findFormInfo(solId,BpmConstants.FORM_SCOPE_BEGIN);
			if (null != beginForm) {
				procdefId = beginForm.getProcDefId_();
				formName = beginForm.getFormName_();
				tableName = beginForm.getTableName_();
				sfwType = beginForm.getSfwType_();
				
				// 获取拟稿节点配置信息
				BpmReNodeCfgEntity draftNodeCft = bizSolService.findDraftNodeCfg(solId, procdefId);
				//处理全局节点属性配置
				//处理拟稿节点属性配置
				if (draftNodeCft != null) { 
					symbol = draftNodeCft.getSymbol_();
					if(StringUtils.isNotEmpty(symbol)){
						docno = docNumMgrService.getDocNumByBizId(bizId,symbol,sfwType);
						docno = URLEncoder.encode(docno, "utf-8");
						docno = URLEncoder.encode(docno, "utf-8");
					}
					// 获取全局节点配置
					BpmReNodeCfgBean cfgBean = bpmRuBizInfoService.findOverallSituationNodeCfg(solId, procdefId);
					if (null != cfgBean) { 
						// 是否可以自由跳转
						isFreeSelect = cfgBean.getFreeSelect_()+"";
						// 是否有正文
						isMainBody = cfgBean.getMainBody_()+"";
						if(isMainBody != null && isMainBody.equals(YES)){
							mainBodySRC = "iweboffice/toDocumentEdit?bizId="+bizId+"&fileType=.doc&docType="+sfwType;
							if(StringUtils.isNotEmpty(draftNodeCft.getRedPrint_())){
								mainBodySRC += "&template="+ draftNodeCft.getRedPrint_();
							}
						}
						// 是否有附件
						isAttachment = cfgBean.getAttachment_()+"";
						if(isAttachment != null && isAttachment.equals(YES)){
							attachmentSRC = "media/toDocMgrAtch?";
						}
					}
					//是否超链接表单
					formType = beginForm.getFormType_()+"";
					//处理拟稿表单访问链接
					if (formType != null && formType.equals(YES)) { //超链接表单
						commentColumn = BpmUtils.changeColumnName(draftNodeCft.getColumnName_());
						
						formsrc = "bpmRuFormInfoController/toFormDraftPage?bizId="+bizId
								+ "&tableName=" + beginForm.getTableName_() 
								+ "&viewName=" + beginForm.getFormUrl_()
								+ "&commentColumn=" + commentColumn
								+ "&symbol_="+ symbol;
						/*formsrc = "bpmRuFormInfoController/toDraftForm?solId="+solId+"&bizId="+bizId;*/
					} else { //自由表单
						commentColumn = draftNodeCft.getColumnName_();
						formsrc = "formController/formurl?formid="+ beginForm.getFreeFormId_()
								+ "&key=" + bizId
								+ "&commentColumn=" + commentColumn
								+ "&formstype=draft"
								+ "&docno="+ docno;
					}
				} 
				
			}
			
			map.put("bizId", bizId);
			map.put("solId", solId);// 业务解决方案Id
			map.put("procdefId", procdefId);// 流程定义Id
			map.put("isFreeSelect", isFreeSelect);//流程是否允许自由跳转
			
			map.put("sfwType", sfwType);    // 业务类型
			map.put("tableName", tableName);// 实体对应的表名
			map.put("commentColumn", commentColumn);// 实体对应的表名
			
			map.put("sendState", "0");  // 下发状态 拟稿时赋值为0
			
			map.put("formType", formType);
			map.put("formsrc", formsrc);// 业务表单请求路径
			map.put("formName", formName);  // 表单名称
			map.put("isMainBody", isMainBody);
			map.put("mainBodySRC", mainBodySRC);
			map.put("isAttachment", isAttachment);
			map.put("attachmentSRC", attachmentSRC);
			map.put("symbol", symbol);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return map;
	}

	/**
	 * 获取业务编辑属性
	 * @param  bizId 业务Id
	 * @return (Map<String, Object>) map  业务编辑所需要的信息
	 */
	@Override
	public Map<String, Object> getUpdateProperty(String bizId) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			
			/*业务基本信息页面参数 以及 送交参数*/
			String solId = "";
			String isFreeSelect = NO;   //(送交参数)流程是否自由跳转   0：否  1：是
			String procdefId = "";     //(页面参数、送交参数)业务绑定流程定义Id
			String sfwType = "";         //(页面参数)收发文类别
			String commentColumn = "";// 环节需要批示的意见字段
			/*拟稿页面显示参数*/
			String formType = "";
			String formName = "";       //表单页签显示名称
			String formsrc = "";        //表单页面访问链接
			String isMainBody = NO;      //页面是否显示正文页签   0：不显示  1：显示
			String mainBodySRC = "";    //正文页面访问链接
			String isAttachment = NO;    //页面是否显示附件页签   0：不显示   1：显示
			String attachmentSRC = "";  //附件页面访问链接
			String symbol = "";   //是否有文号标记
			String docno="";//文号
			BpmRuBizInfoEntity bizInfoEntity = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
			
			BpmReFormNodeBean beginForm = null;
			if(bizInfoEntity != null){
				solId = bizInfoEntity.getSolId_();
				// 获取审批单配置 及生成审批单链接
				beginForm = bpmRuBizInfoService.findFormInfo(solId,BpmConstants.FORM_SCOPE_BEGIN);
			}
			
			if (null != beginForm) {
				procdefId = beginForm.getProcDefId_();
				formName = beginForm.getFormName_();
				sfwType = beginForm.getSfwType_();
				// 获取拟稿节点配置信息
				BpmReNodeCfgEntity draftNodeCft = bizSolService.findDraftNodeCfg(solId, procdefId);
				
				String template = null; // 套红表单
				if (draftNodeCft != null) {
					template = draftNodeCft.getRedPrint_();
					symbol = draftNodeCft.getSymbol_();
					if(StringUtils.isNotEmpty(symbol)){
						docno = docNumMgrService.getDocNumByBizId(bizId,symbol,sfwType);
						docno = URLEncoder.encode(docno, "utf-8");
						docno = URLEncoder.encode(docno, "utf-8");
					}
					// 获取业务解决方案全局节点配置，获取是否正文、是否有附件页以及生成对应链接链接
					 //处理全局节点属性配置
					BpmReNodeCfgBean cfgBean = bpmRuBizInfoService.findOverallSituationNodeCfg(solId, procdefId);
					if (null != cfgBean) {
						isFreeSelect = cfgBean.getFreeSelect_()+"";

						// 是否有正文
						isMainBody = cfgBean.getMainBody_()+"";
						if(isMainBody != null && isMainBody.equals(YES)){
							mainBodySRC = "iweboffice/toDocumentEdit?fileType=.doc&bizId="+ bizId+"&docType="+sfwType;
							if(StringUtils.isNotEmpty(template)){
								mainBodySRC += "&template=" + template;
							}
						}
						
						// 是否有附件
						isAttachment = cfgBean.getAttachment_()+"";
						if(isAttachment != null && isAttachment.equals(YES)){
							attachmentSRC = "media/toDocMgrAtch?bizId="+ bizId;
						}
						
					} 
					
					//是否超链接表单
					formType = beginForm.getFormType_()+"";
					//处理拟稿表单访问链接
					if (formType != null && formType.equals(YES)) { //超链接表单
						commentColumn = BpmUtils.changeColumnName(draftNodeCft.getColumnName_());
						formsrc = "bpmRuFormInfoController/toFormUpdatePage?bizId=" + bizId
								+ "&tableName=" + beginForm.getTableName_() 
								+ "&serialNumber=" + bizInfoEntity.getSerialNumber_() 
								+ "&viewName=" + beginForm.getFormUrl_()
								+ "&commentColumn=" + commentColumn
								+ "&symbol_=" + symbol;
						/*formsrc = "bpmRuFormInfoController/toEditForm?bizId="+bizId;
						if(StringUtils.isNotEmpty(symbol)){
							formsrc += "&symbol_="+ symbol;
						}*/
					} else {
						commentColumn = draftNodeCft.getColumnName_();
						formsrc = "formController/formurl?formid="
								+ beginForm.getFreeFormId_() 
								+ "&key=" + bizId
								+ "&sno=" + bizInfoEntity.getSerialNumber_()
								+ "&commentColumn=" + commentColumn
								+ "&formstype=update"
								+ "&docno=" + docno;
					}
				}
			}
			
			map.put("solId", solId);
			map.put("bizId", bizId);
			map.put("procdefId", procdefId); // 流程定义Id
			map.put("isFreeSelect", isFreeSelect);
			map.put("sendState", bizInfoEntity.getSendState_());
			
			map.put("formType", formType);
			map.put("sfwType", sfwType);    // 业务类型
			map.put("commentColumn", commentColumn);
			map.put("formName", formName);
			map.put("formsrc", formsrc);
			map.put("isMainBody", isMainBody);
			map.put("mainBodySRC", mainBodySRC);
			map.put("isAttachment", isAttachment);
			map.put("attachmentSRC", attachmentSRC);
			map.put("symbol", symbol);
			
		} catch (Exception e) {
			logger.error("error",e);
		}
		return map;
	}

	/**
	 * 获取业务办理属性
	 * @param  bizId 业务Id
	 * @param  taskId 任务Id
	 * @return (Map<String, Object>) map  业务办理所需要的属性
	 */
	@Override
	public Map<String, Object> getDealProperty(String bizId, String taskId) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			
			/*业务基本信息页面参数 以及 送交参数*/
			String solId = "";         //(页面参数)业务解决方案
			String sfwType = "";         //(页面参数)收发文类别
			String commentColumn = "";   //(页面参数)当前环节需要批示的意见字段
			String procdefId = "";     //(页面参数、送交参数)业务绑定流程定义Id
			String procInstId = "";    //(页面参数、送交参数)流程实例
			String isFreeSelect = NO;    //(送交参数)流程是否自由跳转   0：否  1：是
			
			/*拟稿页面显示参数*/
			String formType ="";
			String formName = "";       //表单页签显示名称
			String formsrc = "";        //表单页面访问链接
			String isMainBody = NO;       //页面是否显示正文页签   0：不显示  1：显示
			String mainBodySRC = "";    //正文页面访问链接
			String isAttachment = NO;     //页面是否显示附件页签   0：不显示   1：显示
			String attachmentSRC = "";  //附件页面访问链接
			String symbol = ""; //是否又文号标记  
			String docno = ""; //文号
			BpmRuBizInfoEntity bizInfoEntity = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
			BpmReFormNodeBean beginForm = null;
			String serialNumber = "";  //流水号
			if(bizInfoEntity != null){
				solId = bizInfoEntity.getSolId_();// 业务解决方案
				procInstId = bizInfoEntity.getProcInstId_();// 流程实例
				serialNumber = bizInfoEntity.getSerialNumber_();// 流水号
				// 获取审批单配置 及生成审批单链接
				beginForm = bpmRuBizInfoService.findFormInfo(solId,BpmConstants.FORM_SCOPE_BEGIN);
			}
			if (null != beginForm) {
				// 获取 流程定义id
				procdefId = beginForm.getProcDefId_();
				formName = beginForm.getFormName_();
				sfwType = beginForm.getSfwType_();
				Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
				// 获取业务解决方案全局节点配置，获取是否正文、是否有附件页以及生成对应链接链接
				BpmReNodeCfgBean cfgBean = bpmRuBizInfoService.findOverallSituationNodeCfg(solId,beginForm.getProcDefId_());
				// 获取当前办理节点配置信息
				BpmReNodeCfgEntity taskNodeCft = bizSolDao.findTaskNodeCfg(solId,
						beginForm.getProcDefId_(), task.getTaskDefinitionKey());
				String template = "";
				if (taskNodeCft != null) {
					commentColumn = taskNodeCft.getColumnName_();
					template = taskNodeCft.getRedPrint_();
					symbol = taskNodeCft.getSymbol_();
					if(StringUtils.isNotEmpty(symbol)){
						docno = docNumMgrService.getDocNumByBizId(bizId,symbol,sfwType);
						docno = URLEncoder.encode(docno, "utf-8");
						docno = URLEncoder.encode(docno, "utf-8");
					}
				}
				
				if (null != cfgBean) {
					isFreeSelect = cfgBean.getFreeSelect_() + "";
					
					// 是否有正文
					isMainBody = cfgBean.getMainBody_() + "";
					if(isMainBody != null && isMainBody.equals(YES)){
						mainBodySRC = "iweboffice/toDocumentEdit?fileType=.doc&bizId="+ bizId+"&docType="+sfwType;
						if(StringUtils.isNotEmpty(template)){
							mainBodySRC += "&template=" + template;
						}
					}
					
					// 是否有附件
					isAttachment = cfgBean.getAttachment_()+"";
					if(isAttachment != null && isAttachment.equals(YES)){
						attachmentSRC = "media/toDocMgrAtch?bizId=" + bizId;
					}
				}
				
				//是否超链接表单
				formType = beginForm.getFormType_()+"";
				//处理拟稿表单访问链接
				if (formType != null && formType.equals(YES)) { //超链接表单
					commentColumn = BpmUtils.changeColumnName(commentColumn);
					formsrc = "bpmRuFormInfoController/toFormDealPage?bizId=" + bizId 
							+ "&serialNumber="+ serialNumber
							+ "&taskId=" + taskId
							+ "&procInstId=" + procInstId 
							+ "&tableName=" + beginForm.getTableName_() 
							+ "&viewName=" + beginForm.getFormUrl_()
							+ "&commentColumn=" + commentColumn
							+ "&symbol_="+ symbol;
					/*formsrc = "bpmRuFormInfoController/toDealForm?bizId="+bizId+"&taskId="+taskId;*/
				} else {
					formsrc = "formController/formurl?formid="
							+ beginForm.getFreeFormId_() + "&key=" + bizId
							+ "&sno="+ serialNumber
							+ "&procInstId=" + procInstId
							+ "&commentColumn=" + commentColumn
							+ "&taskId=" + taskId
							+ "&formstype=deal"
							+ "&docno=" + docno;
				}
				
			}
			map.put("solId", solId);
			map.put("bizId", bizId);
			map.put("taskId", taskId);
			map.put("procdefId", procdefId);
			map.put("isFreeSelect", isFreeSelect);
			
			map.put("sfwType", sfwType);
			map.put("commentColumn", commentColumn);
			map.put("sendState", bizInfoEntity.getSendState_());
			
			map.put("formType", formType);
			map.put("formName", formName);
			map.put("formsrc", formsrc);
			map.put("isMainBody", isMainBody);
			map.put("mainBodySRC", mainBodySRC);
			map.put("isAttachment", isAttachment);
			map.put("attachmentSRC", attachmentSRC);
			map.put("symbol", symbol);
			map.put("procInstId", procInstId);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return map;
	}

	/**
	 * 获取业务查看属性
	 * @param bizId  业务Id
	 * @param taskId 任务 Id
	 * @return (Map<String, Object>) map  业务查看所需要的属性
	 */
	@Override
	public Map<String, Object> getViewProperty(String bizId, String taskId) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			
			/*业务基本信息页面参数 以及 送交参数*/
			String solId = null;         //(页面参数)业务解决方案
			String procdefId = null;     //(页面参数、送交参数)业务绑定流程定义Id
			String procInstId = null;    //(页面参数、送交参数)流程实例
			String isFreeSelect = NO;    //(送交参数)流程是否自由跳转   0：否  1：是
			
			/*拟稿页面显示参数*/
			String formType = "";
			String formName = null;       //表单页签显示名称
			String formsrc = null;        //表单页面访问链接
			String isMainBody = NO;       //页面是否显示正文页签   0：不显示  1：显示
			String mainBodySRC = null;    //正文页面访问链接
			String isAttachment = NO;     //页面是否显示附件页签   0：不显示   1：显示
			String attachmentSRC = null;  //附件页面访问链接
			String sfwType = "";         //(页面参数)收发文类别
			BpmReFormNodeBean beginForm = null;
			
			BpmRuBizInfoEntity bizInfoEntity = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
			if(null != bizInfoEntity){
				solId = bizInfoEntity.getSolId_();
				procInstId = bizInfoEntity.getProcInstId_();
				
				// 获取审批单配置 及生成审批单链接
				beginForm = bpmRuBizInfoService.findFormInfo(solId, BpmConstants.FORM_SCOPE_BEGIN);
			}
			if (null != beginForm) {
				
				// 获取 流程定义id
				procdefId = beginForm.getProcDefId_();
				formName = beginForm.getFormName_();
				sfwType = beginForm.getSfwType_();
				// 获取业务解决方案全局节点配置，获取是否正文、是否有附件页以及生成对应链接链接
				BpmReNodeCfgBean cfgBean = bpmRuBizInfoService.findOverallSituationNodeCfg(solId,procdefId);
				if (null != cfgBean) {
					isFreeSelect = cfgBean.getFreeSelect_() + "";
					
					// 是否有正文
					isMainBody = cfgBean.getMainBody_() + "";
					if(isMainBody != null && isMainBody.equals(YES)){
						mainBodySRC = "iweboffice/toDocumentEdit?fileType=.doc&bizId="+ bizId + "&editType=0";
					}
					
					// 是否有附件
					isAttachment = cfgBean.getAttachment_()+"";
					if(isAttachment != null && isAttachment.equals(YES)){
						attachmentSRC = "media/toDocMgrAtch?bizId="+ bizId + "&view=1";
					}
				}
				
				//是否超链接表单
				formType = beginForm.getFormType_()+"";
				//处理拟稿表单访问链接
				if (formType != null && formType.equals(YES)) { //超链接表单
					formsrc = "bpmRuFormInfoController/toFormViewPage?bizId="
							+ bizId + "&serialNumber=" + bizInfoEntity.getSerialNumber_()
							+ "&tableName=" + beginForm.getTableName_()
							+ "&viewName=" + beginForm.getFormUrl_()
							+ "&taskId=" + taskId
							+ "&procInstId=" + procInstId;
					/*formsrc = "bpmRuFormInfoController/toViewForm?bizId="+bizId+"&taskId="+taskId;*/
				} else {
					formsrc = "formController/formurl?formid="
							+ beginForm.getFreeFormId_() 
							+ "&key=" + bizId
							+ "&procInstId=" + procInstId
							+ "&taskId=" + taskId
							+ "&formstype=view"
							+ "&sno=" + bizInfoEntity.getSerialNumber_();
				}
			}
			map.put("solId", solId);
			map.put("bizId", bizId);
			map.put("procInstId", procInstId);
			map.put("procdefId", procdefId);
			map.put("taskId", taskId);
			
			map.put("isFreeSelect", isFreeSelect);
			map.put("sfwType", sfwType);
			
			
			map.put("formType", formType);
			map.put("formName", formName);
			map.put("formsrc", formsrc);
			map.put("isMainBody", isMainBody);
			map.put("mainBodySRC", mainBodySRC);
			map.put("isAttachment", isAttachment);
			map.put("attachmentSRC", attachmentSRC);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return map;
	}

	
	/**
	 * 手机端获取办理数据
	 * @param bizId  业务Id
	 * @param taskId 任务Id
	 * @return(Map<String, Object>) 手机端业务办理数据
	 */
	@Override
	public Map<String, Object> getMobileDealData(String bizId, String taskId) {
		Map<String, Object> map = new LinkedHashMap<String, Object>();
		try {
			String solId = null;// 业务解决方案
			String procInstId = null;// 流程实例
			String tableName = null;
			String procdefId = null;// 流程定义名称
			String commentColumn = "";// 环节需要批示的意见字段
			String freeFormId_ = "";
			String isFreeSelect = "0";// 是否为自由流程 0 :不是 1：是
			BpmRuBizInfoEntity bizInfoEntity = null;
			BpmReFormNodeBean beginForm = null;
			Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
			if(task != null){
				bizInfoEntity = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
				if(bizInfoEntity != null){
					solId = bizInfoEntity.getSolId_();
					procInstId = task.getProcessInstanceId();// 流程实例
					procdefId = task.getProcessDefinitionId();
					// 获取审批单配置 及生成审批单链接
					beginForm = bpmRuBizInfoService.findFormInfo(solId,BpmConstants.FORM_SCOPE_BEGIN);
					if (null != beginForm) {
						tableName = beginForm.getTableName_();
						freeFormId_ = beginForm.getFreeFormId_();
						// 获取业务解决方案全局节点配置，获取是否正文、是否有附件页以及生成对应链接链接
						BpmReNodeCfgBean cfgBean = bpmRuBizInfoService.findOverallSituationNodeCfg(solId, procdefId);
						if (null != cfgBean) {
							isFreeSelect = cfgBean.getFreeSelect_()+"";
						}
						// 获取当前办理节点配置信息
						BpmReNodeCfgEntity taskNodeCft = bizSolDao.findTaskNodeCfg(solId, procdefId, task.getTaskDefinitionKey());
						if (taskNodeCft != null) {
							commentColumn = BpmUtils.changeColumnName(taskNodeCft.getColumnName_());
						}
					}
					map.put("solId", solId);
					map.put("taskId", taskId);
					map.put("procInstId", procInstId);
					map.put("freeFormId", freeFormId_);
					map.put("tableName", tableName);
					map.put("procdefId", procdefId);
					map.put("isFreeSelect", isFreeSelect);
					map.put("commentColumn", commentColumn);
					/*Map<String, Object> formData = bpmRuFormInfoService.findFormData(bizId, procInstId, tableName, "1");
					map.putAll(formData);*/
					//Map<String, Object> formData = bpmRuFormInfoService.findMobileDealFormData(bizId, procInstId, tableName);
					//map.put("formData", formData);
				}
			}else{
				HistoricTaskInstance HisTask = historyService.createHistoricTaskInstanceQuery()
						.taskId(taskId).singleResult();
				bizInfoEntity = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
				if(HisTask != null && bizInfoEntity != null){
					solId = bizInfoEntity.getSolId_();
					procInstId = HisTask.getProcessInstanceId();// 流程实例
					procdefId = HisTask.getProcessDefinitionId();
					// 获取审批单配置 及生成审批单链接
					beginForm = bpmRuBizInfoService.findFormInfo(solId,BpmConstants.FORM_SCOPE_BEGIN);
					if (null != beginForm) {
						tableName = beginForm.getTableName_();
						freeFormId_ = beginForm.getFreeFormId_();
						// 获取业务解决方案全局节点配置，获取是否正文、是否有附件页以及生成对应链接链接
						BpmReNodeCfgBean cfgBean = bpmRuBizInfoService.findOverallSituationNodeCfg(solId, procdefId);
						if (null != cfgBean) {
							isFreeSelect = cfgBean.getFreeSelect_()+"";
						}
					}
					map.put("solId", solId);
					map.put("taskId", taskId);
					map.put("procInstId", procInstId);
					map.put("tableName", tableName);
					map.put("procdefId", procdefId);
					map.put("isFreeSelect", isFreeSelect);
					map.put("freeFormId", freeFormId_);
					map.put("commentColumn", commentColumn);
					/*Map<String, Object> formData = bpmRuFormInfoService.findFormData(bizId, procInstId, tableName, "1");
					map.putAll(formData);*/
					//Map<String, Object> formData = bpmRuFormInfoService.findMobileDealFormData(bizId, procInstId, tableName);
					//map.put("formData", formData);
				}
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return map;
	}

	/**
	 * 获取流程拟稿节点指向的所有任务节点
	 */
	@Override
	public List<TaskNodeBean> findSendTaskNode(String procdefId,String isFreeSelect) {
		List<TaskNodeBean> list = null;
		try {
			String actId = "";
			BpmReNodeEntity bpmReNodeEntity = bpmService.getBpmReNodeByProcDefIdAndActId(procdefId);
			actId = bpmReNodeEntity.getActId_();
			TaskNodeBean bean = bpmService.findTaskNodeBeanByProcDefIdAndActParentId(procdefId, actId);
			if("exclusiveGateway".equals(bean.getActType())){
				actId = bean.getActId();
			}
			list = bpmService.findTaskNodeBeanListByProcDefIdAndActParentId(procdefId, actId);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return list;
	}

	@Override
	public List<TaskNodeBean> findSendTaskNode(String procdefId) {
		// TODO Auto-generated method stub
		List<TaskNodeBean> list = null;
		try {
			String actId = "";
			BpmReNodeEntity bpmReNodeEntity = bpmService.getBpmReNodeByProcDefIdAndActId(procdefId);
			actId = bpmReNodeEntity.getActId_();
			TaskNodeBean bean = bpmService.findTaskNodeBeanByProcDefIdAndActParentId(procdefId, actId);
			if("exclusiveGateway".equals(bean.getActType())){
				actId = bean.getActId();
			}
			list = bpmService.findTaskNodeBeanListByProcDefIdAndActParentId(procdefId, actId);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return list;
	}
	
}
