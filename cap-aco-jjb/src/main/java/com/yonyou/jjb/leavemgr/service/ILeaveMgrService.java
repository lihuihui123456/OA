package com.yonyou.jjb.leavemgr.service;


import com.yonyou.cap.common.util.PageResult;
import com.yonyou.jjb.leavemgr.entity.BizLeaveBean;
import com.yonyou.jjb.leavemgr.entity.BizLeaveDaysEntity;
import com.yonyou.jjb.leavemgr.entity.BizLeaveEntity;

public interface ILeaveMgrService {
	/**
	 * 分页获取请假信息
	 * 
	 * @param pageNum
	 *            页码
	 * @param pageSize
	 *            每页数目
	 * @return
	 */
	public PageResult<BizLeaveBean> findAllLeaveBeanInfo(int pageNum, int pageSize,String modCode);
	/**
	 * 分页获取请假信息
	 * 
	 * @param pageNum
	 *            页码
	 * @param pageSize
	 *            每页数目
	 * @return
	 */
	public PageResult<BizLeaveEntity> findAllLeaveInfo(int pageNum, int pageSize,String modCode);
	/**
	 * 分页搜索请假信息
	 * 
	 * @param pageNum
	 *            页码
	 * @param pageSize
	 *            每页数目
	 * @param roomName
	 *            搜索条件：
	 * @return
	 */
	public PageResult<BizLeaveBean> findAllLeaveBeanInfo(int pageNum, int pageSize,
			String searchInfo,String modCode);
	/**
	 * 分页搜索请假信息
	 * 
	 * @param pageNum
	 *            页码
	 * @param pageSize
	 *            每页数目
	 * @param roomName
	 *            搜索条件：
	 * @return
	 */
	public PageResult<BizLeaveEntity> findAllLeaveInfo(int pageNum, int pageSize,
			String searchInfo,String modCode);

	/**
	 * 根据ID获取一条请假信息
	 * 
	 * @param id
	 * @return
	 */
	public BizLeaveEntity findLeaveInfoById(String id);

	/**
	 * 根据ID获取已休假总天数
	 * 
	 * @param id
	 * @return
	 */
	public BizLeaveDaysEntity findLeaveDaysById(String id);
	
	/**
	 * 添加请假信息
	 * 
	 * @param ui
	 */
	public void doAddLeaveInfo(BizLeaveEntity li);

	/**
	 * 修改请假信息
	 * 
	 * @param meetingRoom
	 */
	public void doUpdateLeaveInfo(BizLeaveEntity leaveInfoEntity);

	/**
	 * 更新已休假总天数方法
	 */
	public void doUpdateLeaveDays(BizLeaveDaysEntity leaveDaysEntity);

	/**
	 * 根据主键删除一条请假信息
	 * 
	 * @param ids[]
	 * @return 
	 */
	public void doDelLeaveInfo(String userid);
	
	/**
	 * 根据主键提交一条请假信息
	 * 
	 * @param ids[]
	 * @return 
	 */
	public void doSendLeaveInfo(String userid);
	
	public String exportLeaveInfoToExcel(String sql,String modCode);

	/**
	 * 根据主键提交一条请假信息
	 * 
	 * @param ids[]
	 * @return 
	 */
	public BizLeaveBean getSolId(String bizId);
}
