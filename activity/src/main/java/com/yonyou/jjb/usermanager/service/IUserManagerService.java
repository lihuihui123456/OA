package com.yonyou.jjb.usermanager.service;

import com.yonyou.cap.common.util.PageResult;
import com.yonyou.jjb.usermanager.entity.UserInfoEntity;


public interface IUserManagerService {
	/**
	 * 分页搜索人员信息
	 * 
	 * @param pageNum
	 *            页码
	 * @param pageSize
	 *            每页数目
	 * @param roomName
	 *            搜索条件：
	 * @return
	 */
	public PageResult<UserInfoEntity> findAllUserInfo(int pageNum, int pageSize,
			String userName,String userAge,String deptName,String postName,
			String entryTime,String userSex,String userDutyTyp);

	/**
	 * 根据ID获取一条人员信息
	 * 
	 * @param id
	 * @return
	 */
	public UserInfoEntity findUserInfoByUserId(String id);

	/**
	 * 添加人员信息
	 * 
	 * @param ui
	 */
	public void doAddUserInfo(UserInfoEntity ui);

	/**
	 * 修改人员信息
	 * 
	 * @param meetingRoom
	 */
	public void doUpdateUserInfo(UserInfoEntity userInfoEntity);

	/**
	 * 根据主键删除一条人员信息
	 * 
	 * @param ids[]
	 * @return 
	 */
	public void doDelUserInfo(String userid);
	/**
	 * 
	 * 导出人员信息
	 */
	public String exportUserInfoToExcel(String userName,String userAge,String deptName,String postName,
			String entryTime,String userSex,String userDutyTyp);

	public String findDeptCodeById(String deptid);
	
	public String findPostCodeById(String postid);
}
