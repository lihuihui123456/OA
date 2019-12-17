package com.yonyou.aco.mtgmgr.service;

import com.yonyou.aco.mtgmgr.entity.BizMtRoomApplyEntity;
import com.yonyou.aco.mtgmgr.entity.RoomApplySearchBean;
import com.yonyou.aco.mtgmgr.entity.RoomBean;
import com.yonyou.cap.common.util.PageResult;

public interface IRoomApplyService {

	/**
	 * 获取所有申请信息
	 * @param meetingname
	 * @param pageNum
	 * @param pageSize
	 * @param userId
	 * @return
	 */
	public PageResult<RoomBean> findAllPerApply(String meetingname, int pageNum, int pageSize, String userId);

	/**
	 * 获取会议室申请信息
	 * @param id
	 * @return
	 */
	public RoomBean findPerApplyById(String id);

	/**
	 * 保存申请信息
	 * @param roomApply
	 */
	public void doSaveRoomApply(BizMtRoomApplyEntity roomApply);

	public int getCount();

	/**
	 * 修改会议室申请状态
	 * @param ids
	 * @param status
	 */
	public void doUpdateStatus(String ids, String status);
	
	/**
	 * 获取会议室申请记录
	 * @param modCode      模块code
	 * @param pageNum      当前页码数
	 * @param pageSize     每页分页数
	 * @param meetingname  会议名称（搜索参数）
	 * @return
	 */
	public PageResult<RoomApplySearchBean> findRoomApplyData(String modCode, int pageNum,
			int pageSize,String sortName,String sortOrder, String meetingname,String queryParams);

}
