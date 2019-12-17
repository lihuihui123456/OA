package com.yonyou.aco.biz.service;

import java.util.List;
import java.util.Map;

import com.yonyou.cap.bpm.entity.TaskNodeBean;

public interface IBpmRunService {
	
	/**
	 * 获取流程拟稿节点指向的所有任务节点
	 * @param procdefId     流程定义id
	 * @param isFreeSelect  流程是否允许自由跳转   0 ：不允许   1:允许
	 * @return (List<TaskNodeBean>) 流程节点集合
	 */
	public List<TaskNodeBean> findSendTaskNode(String procdefId, String isFreeSelect);
	/**
	 * 获取流程拟稿节点指向的所有任务节点
	 * @param procdefId     流程定义id
	 * @param isFreeSelect  流程是否允许自由跳转   0 ：不允许   1:允许
	 * @return (List<TaskNodeBean>) 流程节点集合
	 */
	public List<TaskNodeBean> findSendTaskNode(String procdefId);
	
	/**
	 * 获取流程当前环节节点指向的所有任务节点
	 * @param procdefId
	 * @param isFreeSelect
	 * @param taskId
	 * @return
	 */
	public List<TaskNodeBean> findSendTaskNode(String procdefId, String isFreeSelect, String taskId);
	
	/**
	 * 获取流程当前环节节点指向的所有任务节点
	 * @param isFreeSelect
	 * @param taskId
	 * @return
	 */
	public List<TaskNodeBean> findNextTaskNodes(String isFreeSelect, String taskId);
	
	/**
	 * 获取业务拟稿属性
	 * @param  solId 业务解决方案
	 * @return (Map<String, Object>) map  业务拟稿所需要的属性
	 */
	public Map<String, Object> getDraftProperty(String solId ,String bizId);
	
	/**
	 * 获取业务编辑属性
	 * @param  bizId 业务Id
	 * @return (Map<String, Object>) map  业务编辑所需要的属性
	 */
	public Map<String, Object> getUpdateProperty(String bizId);
	
	/**
	 * 获取业务办理属性
	 * @param  bizId  业务Id
	 * @param  taskId 任务Id
	 * @return (Map<String, Object>) map  业务办理所需要的属性
	 * @throws Exception 
	 */
	public Map<String, Object> getDealProperty(String bizId, String taskId) throws Exception;
	
	/**
	 * 获取业务查看属性
	 * @param bizId  业务Id
	 * @param taskId 任务 Id
	 * @return (Map<String, Object>) map  业务查看所需要的属性
	 */
	public Map<String, Object> getViewProperty(String bizId, String taskId);
	
	
	/**
	 * 手机端获取办理数据
	 * @param bizId  业务Id
	 * @param taskId 任务Id
	 * @return(Map<String, Object>) 手机端业务办理数据
	 */
	public Map<String, Object> getMobileDealData(String bizId, String taskId);
	
}
