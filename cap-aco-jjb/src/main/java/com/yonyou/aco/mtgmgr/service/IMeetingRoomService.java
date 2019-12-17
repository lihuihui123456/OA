package com.yonyou.aco.mtgmgr.service;

import java.util.List;

import com.yonyou.aco.mtgmgr.entity.BizMtMeetingRoomBean;
import com.yonyou.aco.mtgmgr.entity.BizMtMeetingRoomEntity;
import com.yonyou.cap.common.util.PageResult;

public interface IMeetingRoomService {

	/**
	 * 分页获取会议室信息
	 * 
	 * @param pageNum
	 *            页码
	 * @param pageSize
	 *            每页数目
	 * @return
	 */
	public PageResult<BizMtMeetingRoomBean> findAllMTGInfo(int pageNum, int pageSize
			,String sortName,String sortOrder);

	/**
	 * 分页搜索会议室信息
	 * 
	 * @param pageNum
	 *            页码
	 * @param pageSize
	 *            每页数目
	 * @param roomName
	 *            搜索条件：会议室名称
	 * @return
	 */
	public PageResult<BizMtMeetingRoomBean> findAllMTGInfo(int pageNum, int pageSize,
			String roomName,String sortName,String sortOrder);
	/**
	 * 分页搜索会议室信息
	 * @param pageNum 页码
	 * @param pageSize 每页数目
	 * @param roomName 搜索条件：高级查询
	 * @return
	 */
	
	public PageResult<BizMtMeetingRoomBean> findAllMTGInfo(int pageNum, int pageSize,
			String roomName,String sortName,String sortOrder,String queryParams);

	/**
	 * 根据ID获取一条会议室信息
	 * 
	 * @param id
	 * @return
	 */
	public BizMtMeetingRoomEntity findMTGRoomById(String id);

	/**
	 * 添加会议室
	 * 
	 * @param mr
	 */
	public void doAddMeetingRoom(BizMtMeetingRoomEntity mr);

	/**
	 * 获取当前会议室最大排序数
	 * 
	 * @return
	 */
	public int getCount();

	/**
	 * 修改会议室信息
	 * 
	 * @param meetingRoom
	 */
	public void doUpdateMeetingRoom(BizMtMeetingRoomEntity meetingRoom);

	/**
	 * 根据主键删除一条会议室信息
	 * 
	 * @param ids[]
	 * @return 
	 */
	public int doDelMeetingRoom(String ids[]);
	
	/**
	 * 查询所有状态为启用的会议室
	 * @return
	 */
	public List<BizMtMeetingRoomEntity> findUsableMeetingRoom();

	/**
	 * 查询会议室信息是否被占用
	 * @param fieldId
	 * @param fieldValue
	 * @return
	 */
	public List<BizMtMeetingRoomEntity> findEXSTRoom(String fieldId, String fieldValue);
	
	public List<BizMtMeetingRoomEntity> getDataByRoomname(String fieldId, String fieldValue);
	
}
