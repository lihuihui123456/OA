package com.yonyou.aco.cloudydisk.service;

import com.yonyou.aco.cloudydisk.entity.CloudShareBean;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * <p>概述：业务模块分享service层
 * <p>功能：分享
 * <p>作者：葛鹏
 * <p>创建时间：2017年3月18日
 * <p>类调用特殊情况：无
 */
public interface ICloudShareService {
	/**
	 * @param fileIds
	 * @param receiverId
	 * @param receiverName
	 * @param user
	 */
	public void shareFile(String fileIds,String receiverId,ShiroUser user);
	
	
	/**
	 * @param pagenum
	 * @param pagesize
	 * @param sortName
	 * @param sortOrder
	 * @param senderId
	 * @param userId
	 * @return
	 */
	public PageResult<CloudShareBean> findShareFile(int pagenum, int pagesize,String sortName,String sortOrder,String senderId,String receiverId,boolean groupBy,String fileId);
	
	
	public void cancelShare(String ID_);
	
}
