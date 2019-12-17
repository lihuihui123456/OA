package com.yonyou.aco.cloudydisk.dao;

import com.yonyou.aco.cloudydisk.entity.CloudLogEntity;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;

/**
 * <p>概述：业务模块日志Dao层
 * <p>功能：存储操作文件夹与文件的操作日志
 * <p>作者：葛鹏
 * <p>创建时间：2017年3月21日
 * <p>类调用特殊情况：无
 */
public interface ICloudLogDao extends IBaseDao{
	public  PageResult<CloudLogEntity> findCloudLog(int pagenum, int pagesize,String sortName,String sortOrder,String folderId);
}
