package com.yonyou.aco.mtgmgr.dao;

import com.yonyou.cap.common.base.IBaseDao;

public interface IMeetingRoomDao extends IBaseDao{
	
	
	
	/**
	 * 获取当前会议室最大排序数
	 * @return
	 */
	public int getCount();


}
