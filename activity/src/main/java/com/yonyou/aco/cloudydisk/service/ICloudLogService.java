package com.yonyou.aco.cloudydisk.service;

import com.yonyou.aco.cloudydisk.entity.CloudLogEntity;
import com.yonyou.cap.common.util.PageResult;

/**
 * <p>概述：业务模块日志Service层
 * <p>功能：存储操作文件夹与文件的操作日志
 * <p>作者：葛鹏
 * <p>创建时间：2017年3月21日
 * <p>类调用特殊情况：无
 */
public interface ICloudLogService {
	/**
	 * @param folderId
	 * @param userId
	 * @param act
	 * @param time
	 */
	public void saveFolderLog(String folderId,String userId,String act,String time);
	/**
	 * @param folderId
	 * @return
	 */
	public PageResult<CloudLogEntity> findCloudLog(int pagenum, int pagesize,String sortName,String sortOrder,String folderId);

}
