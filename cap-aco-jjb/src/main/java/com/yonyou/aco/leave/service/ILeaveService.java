package com.yonyou.aco.leave.service;

import com.yonyou.aco.leave.entity.LeaveBean;
import com.yonyou.cap.common.util.PageResult;

/**
 * 
 * TODO: 请假管理service接口类
 * 
 * @Date 2017年6月6日
 * @author 贺国栋
 * @since 1.0.0
 */
public interface ILeaveService {

	/**
	 * 
	 * TODO: 多条件分页获取请假信息
	 * 
	 * @param pageNum
	 *            当前页
	 * @param pageSize
	 *            页大小
	 * @param solId
	 *            业务解决方案Id
	 * @param userName
	 *            请假人
	 * @param sortName
	 *            排序列名
	 * @param sortOrder
	 *            排序方式
	 * @param userId
	 *            用户Id
	 * @param queryParams
	 *            高级查询参数
	 * @return
	 */
	public PageResult<LeaveBean> findLeaveDateByQueryParams(int pageNum, int pageSize, String solId, String userName,
			String sortName, String sortOrder, String userId, String queryParams);

	/**
	 * 保存请假管理业务信息
	 * 
	 * @param leaveId
	 *            请假管理业务ID
	 * @param leaveState
	 *            请假状态
	 * @param leaveType
	 *            请假类型
	 * @param startTime
	 *            请假开始时间
	 * @param endTime
	 *            请假结束时间
	 * @param leaveDayNum
	 *            请假天数
	 * @param is_bj
	 *            是否出京
	 * @param is_exit
	 *            是否出境
	 */
	public void doSaveLeaveInfo(String leaveId, String leaveState, String leaveType, String startTime, String endTime,
			String leaveDayNum, String is_bj, String is_exit);

}
