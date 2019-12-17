package com.yonyou.aco.mobile.bpm.service;

/**
 * 
 * ClassName: IMobileBpmListService
 * 
 * @Description: 移动端-获取业务列表信息webService接口类
 * @author hegd
 * @date 2016-8-23
 */

public interface IMobileBpmListService {

	/**
	 * 
	 * @Description: 获取业务列表信息
	 * @param @param userId
	 * @param @param status
	 * @param @param page
	 * @param @param perPageNum
	 * @param @return
	 * @return String
	 * @throws
	 * @author hegd
	 * @date 2016-8-23
	 */
	public String findBpmList(String userId, String status, int page,
			int perPageNum);

	/**
	 * 获取待办表单数据
	 * 
	 * @param taskId
	 * @param bizId
	 * @param valueType
	 * @param terminal
	 * @return
	 */
	public String findMobileTaskInfoByTaskIdAndBizInfoId(String taskId,
			String bizId, String terminal, String valueType);

	/**
	 * 
	 * 方法: 人员数据. 说明: 移动端下一节点人员选择数据
	 * 
	 * @param procdefId
	 * @param nodeId
	 * @param bizId
	 * @return
	 */
	public String findMobileSendUser(String procdefId, String nodeId,
			String bizId,String solId);

	/**
	 * 获取下一环节送交节点
	 * 
	 * @param procdefId
	 * @param taskId
	 * @param isFreeSelect
	 * @return
	 */
	public String findSendTaskNode(String procdefId,
			String taskId, String isFreeSelect,String solId);

	
}
