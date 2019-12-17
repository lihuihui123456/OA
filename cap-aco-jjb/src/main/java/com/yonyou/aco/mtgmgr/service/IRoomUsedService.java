package com.yonyou.aco.mtgmgr.service;

import java.text.ParseException;
import java.util.List;

import com.yonyou.aco.mtgmgr.entity.BizMtRoomUsingEntity;
import com.yonyou.aco.mtgmgr.entity.RoomApplySearchBean;
import com.yonyou.aco.mtgmgr.entity.RoomBean;
import com.yonyou.aco.mtgmgr.entity.RoomUsingSearchBean;
import com.yonyou.cap.common.util.PageResult;

public interface IRoomUsedService {

	/**
	 * 保存会议室使用信息
	 * @param roomUsed
	 */
	public void doSaveMtRoomUsing(BizMtRoomUsingEntity roomUsed);
	
	/**
	 * 根据roomid 查询一周的会议室使用信息
	 * @param roomid
	 * @param start_time
	 * @param end_time
	 * @return
	 * @throws ParseException
	 */
	@SuppressWarnings("rawtypes")
	public List[] getOneWeekMeetingInfo(String roomid, String start_time,String end_time) throws ParseException;
	
	/**
	 * 根据星期为第一天算出一周的所有日期时间
	 * @param sunday
	 * @return
	 */
	public String[] getOneWeekMeetingTime(String sunday);

	/**
	 * 方法:查询所有申请.
	 * 说明: 填入方法说明
	 * @param pageNum
	 * @param pageSize
	 * @param meetingname
	 * @return
	 */
	public PageResult<RoomBean> findAllApply(int pageNum, int pageSize, String meetingname);

	/**
	 * 修改会议室使用状态
	 * @param ids
	 * @param status
	 */
	public void doUpdateStatus(String ids, String status);
	
	/**
	 * 获取会议室看板数据
	 * @param pageNum   当前页码数
	 * @param pageSize  每页显示条目数
	 * @return
	 */
	public PageResult<RoomApplySearchBean> findRoomUsed(int pageNum, int pageSize);

	/**
	 * 获取会议室看板数据
	 * @param pageNum     当前页码数
	 * @param pageSize    每页显示条目数
	 * @param meetingname 会议名称
	 * @return
	 */
	public PageResult<RoomUsingSearchBean> findRoomUsed(int pageNum, int pageSize,
			String meetingname,String sortName,String sortOrder,String queryParams);

	/**
	 * 
	 * TODO: 通过会议Id删除会议信息
	 * @param roomApplyId
	 */
	public void delRoomUsingById(String roomApplyId);

	
}
