package com.yonyou.aco.leaddesktop.web;

import java.util.List;
import javax.annotation.Resource;
import net.sf.json.JSONObject;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.yonyou.cap.bpm.entity.HomeTasksBean;
import com.yonyou.cap.bpm.entity.HomeTasksNumsBean;
import com.yonyou.cap.bpm.service.IBpmQueryService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * <p>概述：领导桌面业务数据加载
 * <p>功能：加载领导桌面待办待阅数据
 * <p>作者：luzhw
 * <p>创建时间：2017年6月9日
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/leadDeskTopQueryController")
public class LeadDeskTopQueryController {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource
	private IBpmQueryService bpmQueryService;
	
	/**
	 * 初始化加载领导桌面待办待阅条目数
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/getLeaderToDosNum")
	public @ResponseBody String getLeaderToDosNum() {
		JSONObject obj = new JSONObject();
		String flag = "0";//查询是否成功的标记 0：失败 1：成功
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user!=null) {
				//查询待办数量
				List<HomeTasksNumsBean> list = bpmQueryService.findHomeTasksNums(user.getUserId());
				if(list!=null&&list.size()>0) {
					obj.put("result",list);//查询待办结果
					flag = "1";//查询成功
				}
			}
			logger.debug("查询个人桌面待办数量成功!");
		}catch(Exception e) {
			logger.debug("查询个人桌面待办数量失败!");
			e.printStackTrace();
		}
		obj.put("flag",flag);
		return obj.toString();
	}
	
	/**
	 * 查询领导桌面待办事项
	 * @return
	 */
	@RequestMapping(value = "/getLeaderToDos")
	public @ResponseBody String getLeaderToDos(@RequestParam int pageSize, @RequestParam String taskType) {
		JSONObject obj = new JSONObject();
		String flag = "0";//查询是否成功的标记 0：失败 1：成功
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user!=null) {
				List<HomeTasksBean> list = bpmQueryService.findLeaderHomeTasks(pageSize, taskType, user.getUserId());
				if(list!=null&&list.size()>0) {
					obj.put("result",list);//查询待办结果
					flag = "1";//查询成功
				}
			}
			logger.debug("查询个人桌面待办数据成功!");
		}catch(Exception e) {
			logger.debug("查询个人桌面待办数据失败!");
			e.printStackTrace();
		}
		obj.put("flag",flag);
		return obj.toString();
	}

}
