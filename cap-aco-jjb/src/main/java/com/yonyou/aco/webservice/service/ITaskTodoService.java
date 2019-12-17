package com.yonyou.aco.webservice.service;

import javax.jws.WebService;

@WebService
public interface ITaskTodoService {
	/**
	  * 由用户登录名获取用户待办数量
	  * @param acctlogin 用户登录名
	  * @return String xml
	  */
	public String getTaskList(String acctlogin);
}
