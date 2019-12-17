package com.yonyou.aco.mtgmgr.dao;

import java.util.List;

import com.yonyou.aco.mtgmgr.entity.DateFindBean;
import com.yonyou.aco.mtgmgr.entity.RoomBean;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;

public interface IRoomUsedDao extends IBaseDao {

	/**
	 * 根据roomid 查询一周的会议室使用信息
	 * @param roomId
	 * @param start_date
	 * @param end_date
	 * @return
	 */
	public List<RoomBean> getOneWeekMeetingInfo(String roomId, String start_date, String end_date);
	
	/**
	 * 
	 * @param sundayDate
	 * @return
	 */
	public List<DateFindBean> getOneWeekMeetingTime(String sundayDate);

	/**
	 * 方法: 所有申请记录.
	 * 说明: 填入方法说明
	 * @param pageNum
	 * @param pageSize
	 * @param meetingname
	 * @return
	 */
	public PageResult<RoomBean> findAllApply(int pageNum, int pageSize,String meetingname);
	
	public void doUpdateStatus(String ids, String status);

	/**
	 * 
	 * TODO: 通过会议id删除会议信息
	 * @param roomApplyId
	 */
	public void delRoomUsingById(String roomApplyId);
	
}
