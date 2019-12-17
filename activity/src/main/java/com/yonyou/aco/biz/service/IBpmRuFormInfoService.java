package com.yonyou.aco.biz.service;

import java.util.Map;

/**
 * <p>概述：业务表单信息Service层接口
 * <p>功能：实现业务表单信息逻辑处理
 * <p>作者：卢昭炜
 * <p>创建时间：2016-08-05
 * <p>类调用特殊情况：无
 */
public interface IBpmRuFormInfoService {
	
	/**
	 * 保存业务实体对象
	 * @param entity
	 */
	public void doSaveBpmDuForm(Object entity);

	/**
	 * 更新业务实体对象
	 * @param entity
	 */
	public void doUpdateBpmDuForm(Object entity);
	
	/**
	 * java反射机制获取实体对象
	 * @param entityName  业务表单对应的实体
	 * @param bizId       业务Id
	 * @return (Object)   entity  实体对象
 	 */
	public Object findEntityByBizId(String entityName, String bizId);
	
	/**
	 * java反射机制获取实体对象
	 * @param bizId      业务Id
	 * @param tableName  业务表单对应数据表
	 * @return (Object)  entity  实体对象
 	 */
	public Object findEntityByTableNameAndBizId(String bizId, String tableName);
	
	/**
	 * 业务编辑获取表单数据
	 * @param bizId      业务Id
	 * @param tableName  业务表单对应数据表名称
	 * @return(Map<String, Object>) keyValueMap 业务表单数据
	 */
	public Map<String, Object> findEditFormData(String bizId, String tableName);

	/**
	 * 业务办理获取表单数据
	 * @param bizId       业务Id
	 * @param tableName   业务表单对应数据表名称
	 * @param procInstId  流程实例Id
	 * @return(Map<String, Object>) keyValueMap 业务表单数据
	 */
	public Map<String, Object> findDealFormData(String bizId, String tableName,
			String procInstId);

	/**
	 * 业务查看获取表单数据
	 * @param bizId       业务Id
	 * @param tableName   业务表单对应数据表名称
	 * @param procInstId  流程实例Id
	 * @return(Map<String, Object>) keyValueMap 业务表单数据
	 */
	public Map<String, Object> findViewFormData(String bizId, String tableName,
			String procInstId);

	
	/**
	 *  手机端获取代办表单数据以及流程意见
	 * @param bizId       业务基本信息Id
	 * @param procInstId  流程实例Id
	 * @param tableName   业务表单对应的表名称
	 * @return
	 */
	public Map<String, Object> findMobileDealFormData(String bizId, String procInstId,
			String tableName);
	
}
