package com.yonyou.aco.leave.web;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yonyou.aco.leave.entity.LeaveBean;
import com.yonyou.aco.leave.service.ILeaveService;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.common.util.DataGridView;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * TODO: 请假管理controller类
 * 
 * @Date 2017年6月6日
 * @author 贺国栋
 * @since 1.0.0
 */
@Controller
@RequestMapping("/leaveController")
public class LeaveController {

	@Resource
	ILeaveService leaveService;

	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;

	/**
	 * 
	 * TODO: 多条件分页获取请假管理列表信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param solId
	 * @param userName
	 * @param sortName
	 * @param sortOrder
	 * @param queryParams
	 * @return
	 */
	@RequestMapping("/findLeaveDateByQueryParams")
	@ResponseBody
	public DataGridView<LeaveBean> findLeaveDateByQueryParams(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "solId", defaultValue = "") String solId,
			@RequestParam(value = "userName", defaultValue = "") String userName,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value = "queryParams", defaultValue = "") String queryParams) {
		DataGridView<LeaveBean> page = new DataGridView<LeaveBean>();
		try {
			userName = new String(userName.getBytes("iso-8859-1"), "utf-8");
			queryParams = java.net.URLDecoder.decode(queryParams, "UTF-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<LeaveBean> pags = null;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if (user != null) {
				pags = leaveService.findLeaveDateByQueryParams(pageNum, pageSize, solId, userName, sortName, sortOrder,
						user.getUserId(), queryParams);
			}
			if (pags != null) {
				page.setRows(pags.getResults());
				page.setTotal(pags.getTotalrecord());
			}
			return page;
		} catch (Exception e) {
			return null;
		}

	}

	@RequestMapping("/doSaveLeaveInfo")
	@ResponseBody
	public String doSaveLeaveInfo(@RequestParam(value = "leaveId", defaultValue = "") String leaveId,
			@RequestParam(value = "leaveState", defaultValue = "") String leaveState,
			@RequestParam(value = "leaveType", defaultValue = "") String leaveType,
			@RequestParam(value = "startTime", defaultValue = "") String startTime,
			@RequestParam(value = "endTime", defaultValue = "") String endTime,
			@RequestParam(value = "leaveDayNum", defaultValue = "") String leaveDayNum,
			@RequestParam(value = "is_bj", defaultValue = "") String is_bj,
			@RequestParam(value = "is_exit", defaultValue = "") String is_exit) {

		if (StringUtils.isNotBlank(leaveId)) {
			leaveService.doSaveLeaveInfo(leaveId, leaveState, leaveType, startTime, endTime, leaveDayNum, is_bj,
					is_exit);
			return "true";
		} else {
			return "false";
		}
	}

	@RequestMapping("/doDelLeaveInfoByLeaveIds")
	@ResponseBody
	public String doDelLeaveInfoByLeaveIds(@RequestParam(value = "leaveIds[]", defaultValue = "") String[] leaveIds) {
		String flag = "N";
		try {
			bpmRuBizInfoService.doDeleteBpmRuBizInfoEntitysByBizIds(leaveIds);
			flag = "Y";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}
}
