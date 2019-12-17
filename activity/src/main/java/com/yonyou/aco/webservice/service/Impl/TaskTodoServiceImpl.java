package com.yonyou.aco.webservice.service.Impl;

import javax.jws.WebService;
import com.yonyou.aco.webservice.dao.ITaskTodoDao;
import com.yonyou.aco.webservice.service.ITaskTodoService;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.SpringContextUtil;

@WebService(endpointInterface = "com.yonyou.aco.webservice.service.ITaskTodoService")
public class TaskTodoServiceImpl implements ITaskTodoService{
	public String getTaskList(String acctlogin) {
		ITaskTodoDao taskTodoDao = (ITaskTodoDao) SpringContextUtil
				.getBean("taskTodoDao");
		String userid=taskTodoDao.getUserId(acctlogin);
		int number = taskTodoDao.getTaskList(userid);
		String testString="";
		if(number>0){
			String date = DateUtil.getCurDate("yyyy-MM-dd");
			String url="/bpmQuery/toTaskTodoList";		
			testString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
			testString += "<ROOT>";
			testString += "  <FUNCTION NAME=\"OA待办数量\" DESCRIPTION=\"功能名称\">";
			testString += "    <MENU>";
			testString += "      <URL>" + url + "</URL>";
			testString += "      <NAME>OA待办数量</NAME>";
			testString += "      <NUMBER>" + number + "</NUMBER>";
			testString += "      <DATE>" + date + "</DATE>";
			testString += "    </MENU>";
			testString += "  </FUNCTION>";
			testString += "</ROOT>";
		}
		return testString;
	}
}
