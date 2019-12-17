package com.yonyou.jjb.usermanager.dao;

import java.util.List;

import com.yonyou.jjb.usermanager.entity.UserInfoEntity;
import com.yonyou.cap.common.base.IBaseDao;

public interface IUserManagerDao extends IBaseDao{
	
	public List<UserInfoEntity> findAllUser(String userName,String userAge,String deptName,String postName,
			String entryTime,String userSex,String userDutyTyp);
	
	public String findLoginByUserId(String userid);
	
	public String findDeptCodeById(String deptid);
	
	public String findPostCodeById(String postid);
}
