package com.yonyou.aco.cloudydisk.dao;

import java.util.List;
import java.util.Map;

import com.yonyou.aco.cloudydisk.entity.CloudShareBean;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;

/**
 * <p>概述：业务模块分享dao层
 * <p>功能：分享
 * <p>作者：葛鹏
 * <p>创建时间：2017年3月18日
 * <p>类调用特殊情况：无
 */
public interface ICloudShareDao extends IBaseDao{
	/**
	 * @param senderId
	 * @param receiverId
	 * @return
	 */
	public List<CloudShareBean> getShareFileByUser(String senderId,String receiverId);
	/**
	 * @return
	 */
	public Map<String,String> getUserNames();
	/**
	 * @param pagenum
	 * @param pagesize
	 * @param sortName
	 * @param sortOrder
	 * @param senderId
	 * @param receiverId
	 * @return
	 */
	public PageResult<CloudShareBean> findShareFile(int pagenum, int pagesize,String sortName,String sortOrder,String senderId,String receiverId,boolean groupBy,String fileId);
}
