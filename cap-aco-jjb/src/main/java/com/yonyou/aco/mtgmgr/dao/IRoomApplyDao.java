package com.yonyou.aco.mtgmgr.dao;

import com.yonyou.aco.mtgmgr.entity.RoomApplySearchBean;
import com.yonyou.aco.mtgmgr.entity.RoomBean;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;

public interface IRoomApplyDao extends IBaseDao {

	public int getCount();

	public void doUpdateStatus(String ids, String status);

	/**
	 * 获取所有申请记录
	 * @param meetingname
	 * @param pageNum
	 * @param pageSize
	 * @param userId
	 * @return
	 */
	public PageResult<RoomApplySearchBean> findAllPerApply(String meetingname, 
			int pageNum, int pageSize,String sortName,String sortOrder,String queryParams,String modCode);

	public RoomBean findPerApplyById(String id);

	public String getLastTimeById(String id, String dateTime);

}
