package com.yonyou.aco.home.web;

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
import com.yonyou.cap.common.util.AcoConstant;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * <p>概述：业务模块个人桌面
 * <p>功能：领导桌面
 * <p>作者：李超
 * <p>创建时间：2017年03月01日
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/personHomeQueryController")
public class PersonHomeQueryController {

	private static Logger logger = LoggerFactory.getLogger(PersonHomeQueryController.class);
	@Resource
	IBpmQueryService bpmQueryService;
	/**
	 * 初始化待办任务页面任务
	 * 公文缓急程度标记：平件-1  急件-2 特急-3
	 * @param
	 * @return
	 */
	@RequestMapping("/getToDoTasks")
	@ResponseBody
	public String getToDoTasks(@RequestParam String taskType) {
		JSONObject obj = new JSONObject();
		String flag = "0";//查询是否成功的标记 0：失败 1：成功
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user!=null) {
				List<HomeTasksBean> list = bpmQueryService.findHomeTasks(AcoConstant.DESKCOUNT, taskType, user.getUserId());
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
		System.out.println(obj.toString());
		return obj.toString();
	}
	/**
	 * 初始化待办时待办数量
	 * 公文缓急程度标记：平件-1  急件-2 特急-3
	 * @param
	 * @return
	 */
	@RequestMapping("/getToDoTasksNums")
	@ResponseBody
	public String getToDoTasksNums() {
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
		System.out.println(obj.toString());
		return obj.toString();
	}
}