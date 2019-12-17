package com.yonyou.aco.webservice.dao;

import com.yonyou.cap.common.base.IBaseDao;

public interface ITaskTodoDao extends IBaseDao{
	/**
	  * 由用户id获取用户待办数量
	  * @param userid 用户id
	  * @return int number数量
	  */
	 public int getTaskList(String userid);
	 /**
	  * 由用户登录名获取用户id
	  * @param acctlogin 用户登录名
	  * @return userid 用户id
	  */
     public String getUserId(String acctlogin);
}
