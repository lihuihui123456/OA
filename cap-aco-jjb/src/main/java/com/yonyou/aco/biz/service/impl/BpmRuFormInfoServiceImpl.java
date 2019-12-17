//*********************************************************************
// 系统名称：cap-base
// 版本信息：Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// 作        者：石磊
// 手       机：15567666214
// SVN版本号                                 日   期                作     者              变更记录
// SolutionCfgServiceImpl-001  2016/07/22    石磊　                新建
//*********************************************************************
package com.yonyou.aco.biz.service.impl;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONObject;

import org.activiti.engine.TaskService;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.yonyou.aco.biz.dao.IBpmRuFormInfoDao;
import com.yonyou.aco.biz.service.IBpmRuFormInfoService;
import com.yonyou.cap.bpm.entity.BpmReCommentBean;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.bpm.util.BpmConstants;
import com.yonyou.cap.bpm.util.BpmUtils;
import com.yonyou.cap.common.util.DateUtil;

/**
 * <p> 概述：业务表单信息Service层
 * <p> 功能：实现业务表单信息逻辑处理
 * <p> 作者：卢昭炜
 * <p> 创建时间：2016-08-05
 * <p> 类调用特殊情况：无
 */
@Service("bpmRuFormInfoService")
public class BpmRuFormInfoServiceImpl implements IBpmRuFormInfoService {
	
	@Resource
	TaskService taskService;
	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;
	@Resource
	private IBpmRuFormInfoDao bpmRuFormInfoDao;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 保存业务实体对象
	 * @param entity
	 */
	@Override
	public void doSaveBpmDuForm(Object entity) {
		bpmRuFormInfoDao.save(entity);
	}

	/**
	 * 更新业务实体对象
	 * @param entity
	 */
	@Override
	public void doUpdateBpmDuForm(Object entity) {
		bpmRuFormInfoDao.update(entity);
	}

	/**
	 * java反射机制获取实体对象
	 * @param entityName  业务表单对应的实体
	 * @param bizId      业务Id
	 * @return (Object)  entity  实体对象
 	 */
	@Override
	public Object findEntityByBizId(String entityName, String bizId) {
		Object o = null;
		try {
			Class<?> c = Class.forName(entityName);
			List<?> list = bpmRuFormInfoDao.findByProperty(c, "bizId_", bizId);
			if (null != list && list.size() > 0) {
				o = list.get(0);
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return o;
	}
	
	/**
	 * java反射机制获取实体对象
	 * @param bizId      业务Id
	 * @param tableName  业务表单对应数据表
	 * @return (Object)  entity  实体对象
 	 */
	@Override
	public Object findEntityByTableNameAndBizId(String bizId, String tableName) {
		Object entity = null;
		try {
			if(StringUtils.isNotEmpty(tableName) && StringUtils.isNotEmpty(bizId)){
				// 将表名转化为实体名称
				String entityName = BpmUtils.getEntityName(tableName);
				// 完善实体名称 给实体加包名
				entityName = BpmConstants.FORM_ENTITY_PACKAGE + entityName;
				Class<?> c = Class.forName(entityName);
				List<?> list = bpmRuFormInfoDao.findByProperty(c, "bizId_", bizId);
				if (null != list && list.size() > 0) {
					entity = list.get(0);
				}
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return entity;
	}
	
	/**
	 * 业务编辑获取表单数据
	 * @param bizId      业务Id
	 * @param tableName  业务表单对应数据表名称
	 * @return(Map<String, Object>) keyValueMap 业务表单数据
	 */
	@Override
	public Map<String, Object> findEditFormData(String bizId, String tableName) {
		Map<String, Object> map = new HashMap<String, Object>();
		JSONObject keyValueMap = new JSONObject();
		Map<String, Object> comments = new HashMap<String, Object>();
		try {
			getFormData(bizId, tableName, null, keyValueMap, comments, BpmUtils.UPDATE_ACTION);
		} catch (Exception e) {
			logger.error("error",e);
		}finally{
			map.put("keyValueMap", keyValueMap);
			map.putAll(comments);
		}
		return map;
	}
	
	/**
	 * 业务办理获取表单数据
	 * @param bizId       业务Id
	 * @param tableName   业务表单对应数据表名称
	 * @param procInstId  流程实例Id
	 * @return(Map<String, Object>) keyValueMap 业务表单数据
	 */
	@Override
	public Map<String, Object> findDealFormData(String bizId, String tableName,
			String procInstId) {
		Map<String, Object> map = new HashMap<String, Object>();
		JSONObject keyValueMap = new JSONObject();
		Map<String, Object> comments = new HashMap<String, Object>();
		try {
			getFormData(bizId, tableName, procInstId, keyValueMap, comments, BpmUtils.DEAL_ACTION);
		} catch (Exception e) {
			logger.error("error",e);
		}finally{
			map.put("keyValueMap", keyValueMap);
			map.putAll(comments);
		}
		return map;
	}

	
	/**
	 * 业务查看获取表单数据
	 * @param bizId       业务Id
	 * @param tableName   业务表单对应数据表名称
	 * @param procInstId  流程实例Id
	 * @return(Map<String, Object>) keyValueMap 业务表单数据
	 */
	@Override
	public Map<String, Object> findViewFormData(String bizId, String tableName,
			String procInstId) {
		Map<String, Object> map = new HashMap<String, Object>();
		JSONObject keyValueMap = new JSONObject();
		Map<String, Object> comments = new HashMap<String, Object>();
		try {
			getFormData(bizId, tableName, procInstId, keyValueMap, comments, BpmUtils.VIEW_ACTION);
		} catch (Exception e) {
			logger.error("error",e);
		}finally{
			map.put("keyValueMap", keyValueMap);
			map.putAll(comments);
		}
		return map;
	}

	/**
	 * 获取业务表单数据
	 * @param bizId 业务ID
	 * @param tableName 业务表单数据表
	 * @param procInstId 流程实例ID
	 * @param keyValueMap 待处理表单数据
	 * @param comments 待处理意见数据
	 * @param type 操作类型
	 * @throws Exception
	 */
	private void getFormData(String bizId, String tableName, String procInstId,
			JSONObject keyValueMap, Map<String, Object> comments, String type)
			throws Exception {
		Object entity = findEntityByTableNameAndBizId(bizId, tableName);
		if (null != entity) {
			// 获得object对象对应的所有已申明的属性，包括public、private、和protected
			Field[] fields = entity.getClass().getDeclaredFields();
			// 获取object对象中的方法
			Method[] methods = entity.getClass().getDeclaredMethods();
			String name;// 属性名称
			Object value;// 属性值
			String fieldGetName;// 属性get方法名
			Method fieldGetMet;
			for (Field field : fields) {
				name = field.getName();
				fieldGetName = BpmUtils.parGetName(name);// 获取属性get方法名称
				if (BpmUtils.checkGetMet(methods, fieldGetName)) {// 判断是否存在某属性的 get方法
					// 获取get方法
					fieldGetMet = entity.getClass().getMethod(fieldGetName);
					if (name.startsWith("comment")) {
						//拼接意见（现在异步加载意见不需要）
						if (StringUtils.isNotEmpty(procInstId)) {
							comments.put(name, getComment(procInstId, name));
						}
						if(BpmUtils.VIEW_ACTION.equals(type)) {
							continue;
						}
					}
					// 使用get方法获取该属性的值
					value = fieldGetMet.invoke(entity);
					if (value != null) {
						keyValueMap.put(name, value);
					} 
				}
			}
		}
	}
	
	
	/**
	 * 拼接页面显示的意见块
	 * @param procInstId
	 * @param filedName
	 * @return
	 */
	private String getComment(String procInstId, String filedName) {
		StringBuffer commentStr = new StringBuffer();
		//查询意见
		List<BpmReCommentBean> list = bpmRuBizInfoService.findCommentByProcInstIdAndFieldName(procInstId, filedName);
		if(list != null && !list.isEmpty()) {
			for (BpmReCommentBean comment: list) {
				if("signature".equals(comment.getType_())) {//手写签批
					if(StringUtils.isBlank(comment.getSignature())) {
						continue;
					}
					commentStr.append("<img src=\"" + comment.getSignature() + "\">");
				}else if ("comment".equals(comment.getType_())) {//文字意见
					if(StringUtils.isBlank(comment.getMessage_())) {
						continue;
					}
					commentStr.append("<label style=\"color: #2a2a2a; margin-top: 8px; padding-left: 10px;\">"+comment.getMessage_()+"</label>");
				}else {
					continue;
				}
				commentStr.append("<br><label style=\"color: #888; padding-left: 10px; margin-top: 5px; margin-bottom: 5px;\">");
				commentStr.append("&nbsp;&nbsp;&nbsp;&nbsp;"+comment.getUserName_()+"&nbsp;&nbsp;&nbsp;&nbsp;</label>");
				commentStr.append("<label style=\"color: #888;\">"+DateUtil.formatDate(comment.getTime_(), "yyyy-MM-dd HH:mm:ss")+"</label><br>");
				commentStr.append("<hr>");
			}
		}
		if(commentStr.length() > 0) {
			return commentStr.toString();
		}
		return "";
	}

	
	/**
	 *  手机端获取代办表单数据以及流程意见
	 * @param bizId       业务基本信息Id
	 * @param procInstId  流程实例Id
	 * @param tableName   业务表单对应的表名称
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> findMobileDealFormData(String bizId,
			String procInstId, String tableName) {
		Map<String, Object> formData = new HashMap<String, Object>();
		try {
			Object o = findEntityByTableNameAndBizId(bizId, tableName);
			if (null != o) {
				// 获得object对象对应的所有已申明的属性，包括public、private、和protected
				Field[] fields = o.getClass().getDeclaredFields();
				// 获取object对象中的方法
				Method[] methods = o.getClass().getDeclaredMethods();
				String name = "";// 属性名称
				String fieldGetName = "";// 属性get方法名
				Object value = null;// 属性值
				StringBuffer comment;
				JSONObject json;
				for (Field field : fields) {
					name = field.getName();
					fieldGetName = BpmUtils.parGetName(name);// 获取属性get方法名称
					if (BpmUtils.checkGetMet(methods, fieldGetName)) {// 判断是否存在某属性的get方法
						
						// 用comment开头的为意见字段
						if (name.startsWith("comment")) {
							if (StringUtils.isNotEmpty(procInstId)) {
								// 查询意见
								List<BpmReCommentBean> list = bpmRuBizInfoService.findCommentByProcInstIdAndFieldName(
										procInstId, name);
								// 拼意见
								comment = new StringBuffer();
								String time;
								if(list != null && list.size()>0){
									for (int i = 0; i < list.size(); i++) {
										time = DateUtil.formatDate(list.get(i).getTime_(), "yyyy-MM-dd HH:mm:ss");
										if(i == list.size()-1){
											comment.append("{\"message\":\""+list.get(i).getMessage_().trim()+"\",\"userName\":\""+list.get(i).getUserName_()+"\",\"time\":\""+time+"\"}");
										}else{
											comment.append("{\"message\":\""+list.get(i).getMessage_().trim()+"\",\"userName\":\""+list.get(i).getUserName_()+"\",\"time\":\""+time+"\"},");
										}
									}
								}else{
									comment.append("{}");
								}
								json = new JSONObject();
								json.put(name, "["+comment.toString()+"]");
								formData.putAll(json);
							}
						}else{
							// 获取get方法
							Method fieldGetMet = o.getClass().getMethod(fieldGetName);
							// 使用get方法获取该属性的值
							value = fieldGetMet.invoke(o);
							formData.put(name, value);
						}
					}
				}
			} 
		} catch (Exception e) {
			logger.error("error",e);
		}
		return formData;
	}
	
}
