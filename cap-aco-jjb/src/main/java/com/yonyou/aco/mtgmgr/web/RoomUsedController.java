package com.yonyou.aco.mtgmgr.web;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.mtgmgr.entity.BizMtMeetingRoomEntity;
import com.yonyou.aco.mtgmgr.entity.RoomBean;
import com.yonyou.aco.mtgmgr.entity.RoomUsingSearchBean;
import com.yonyou.aco.mtgmgr.service.IMeetingRoomService;
import com.yonyou.aco.mtgmgr.service.IRoomApplyService;
import com.yonyou.aco.mtgmgr.service.IRoomUsedService;
import com.yonyou.cap.common.audit.operatelog.annotation.AroundAspect;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;

/**
 * 
 * 名称: 会议室占用信息
 * ---------------------------------------------------------
 * 
 * @Date 2016年3月18日
 * @author 卢昭炜
 * @since 1.0.0
 */
@Controller
@RequestMapping("/roomUsed")
public class RoomUsedController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource
	private IRoomUsedService roomUsedService;

	@Resource
	private IMeetingRoomService meetingRoomService;
	
	@Resource
	private IRoomApplyService roomApplyService;
	
	/**
	 * 名称: 全部申请记录.
	 * 
	 * @return
	 */
	@RequestMapping("/toAllApplyList")
	@AroundAspect(description="会议室申请审批-跳转到会议室申请审批")
	public String toAllApplyList() {
		return "/aco/meetingroom/all-applylist";
	}
	
	/**
	 * 名称: 全部申请记录.
	 * 
	 * @return
	 */
	@RequestMapping("/toRoomUsed")
	@AroundAspect(description="会议看板-跳转到会议看板")
	public String toMeetingRoomUsed() {
		return "/aco/meetingroom/roomused-list";
	}
	
	/**
	 * 查询全部申请记录
	 * @param pageNum
	 * @param pageSize
	 * @param meetingname
	 * @return
	 */
	@RequestMapping("/findRoomUsed")
	@AroundAspect(description="会议看板-分页查询会议看板")
	public @ResponseBody Map<String, Object> findRoomUsed(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "meetingname", defaultValue = "") String meetingname,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value="query", required=false) String queryParams) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			meetingname = new String(meetingname.getBytes("iso-8859-1"), "utf-8");
			queryParams = java.net.URLDecoder.decode(queryParams,"UTF-8");
			queryParams = java.net.URLDecoder.decode(queryParams,"UTF-8");
			PageResult<RoomUsingSearchBean> page = null;
			page = roomUsedService.findRoomUsed(pageNum, pageSize, meetingname,sortName,
					sortOrder,queryParams);
			map.put("total", page.getTotalrecord());
			map.put("rows", page.getResults());
		} catch (Exception e) {
			logger.error("error",e);
		}
		return map;
	}
	
	/**
	 * 名称: 查询全部申请记录
	 * 备注：原方法名（getAllData）
	 * @param pageNum
	 * @param pageSize
	 * @param meetingname
	 * @return
	 */
	@RequestMapping("/findAllApply")
	@AroundAspect(description="会议室申请审批-分页查询会议室申请审批")
	public @ResponseBody Map<String, Object> findAllApply(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "meetingname", defaultValue = "") String meetingname) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			meetingname = new String(meetingname.getBytes("iso-8859-1"), "utf-8");
			PageResult<RoomBean> page = roomUsedService.findAllApply(pageNum,pageSize, meetingname);
			map.put("total", page.getTotalrecord());
			map.put("rows", page.getResults());
		} catch (Exception e) {
			logger.error("error",e);
		}
		return map;
	}

	/**
	 * 名称: 修改申请状态.
	 * 备注：原方法名（changeStatus）
	 * @param roomused_ids
	 * @param roomapply_ids
	 * @param action
	 * @return
	 */
	@RequestMapping("/doUpdateStatus")
	@AroundAspect(description="会议室申请审批--修改申请状态（通过或不通过）")
	public @ResponseBody String doUpdateStatus(@RequestParam(value = "roomused_ids", defaultValue="") String roomused_ids,
			@RequestParam(value = "roomapply_ids", defaultValue="") String roomapply_ids,
			@RequestParam(value = "action",defaultValue="") String action) {
		try {
			String status = "";
			if("true".equals(action)){
				//2表示申请通过
				status = "2";
			}else{
				//3表示申请不通过
				status ="3";
			}
			String [] ids = roomapply_ids.split(",");
			for (int i = 0; i < ids.length; i++) {
				roomUsedService.doUpdateStatus(ids[i], status);
				roomApplyService.doUpdateStatus(ids[i], status);
			}
			return "true";
		} catch (Exception e) {
			logger.error("error",e);
			return "false";
		}
	}

	/**
	 * 跳转会议室预定申请
	 * 备注：原方法名（roomBoard）
	 * @param sunday Date 周日日期
	 * @param action next：下一周 last： 上一周
	 * @return
	 */
	@SuppressWarnings({ "unused", "rawtypes" })
	@RequestMapping("/findRoomBoard")
	@AroundAspect(description="会议室预定申请-跳转会议室预定申请")
	public ModelAndView findRoomBoard(@RequestParam(value = "sunday", defaultValue = "") String sundayDate,
					@RequestParam(value = "action", defaultValue = "") String action) {
		ModelAndView mv = new ModelAndView();
		try {
			String theSundayDate = "";
			String sunday = "";
			// 定义期日格式
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			// 定义时间格式
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			if (!"".equals(sundayDate) && !"".equals(action)) {
				theSundayDate = addDaysFromDate(sundayDate, action);
				sunday = getFirstDateOfWeek(theSundayDate);
			} else {
				sunday = getFirstDateOfWeek(sundayDate);
			}
			Calendar cal = Calendar.getInstance();// 当天日历
			cal.setTime(dateFormat.parse(sunday));
			cal.add(Calendar.DAY_OF_MONTH, 6);
			String saturday = dateFormat.format(cal.getTime());
			// 获取服务器时间
			String nowTime = DateUtil.getServerDataTime(true);
			// 获取今天是本周第几天
			Calendar da = Calendar.getInstance();
			int nowDay = da.get(Calendar.DAY_OF_WEEK);// 获取今天是本周第几天
			// 得到一周的日期时间
			String[] time = roomUsedService.getOneWeekMeetingTime(sunday);
			List<BizMtMeetingRoomEntity> roomList = meetingRoomService.findUsableMeetingRoom();// 会议室基础信息
			Map<String, Object> map = new LinkedHashMap<String, Object>();
			List[] meetingInfo = null;
			String roomName = "";
			if (roomList != null) {
				for (int i = 0; i < roomList.size(); i++) {// 循环出所有会议室
					roomName = roomList.get(i).getRoom_name();
					String roomid = roomList.get(i).getId();
					String start = sunday + " 00:00";
					String end = saturday + " 23:59";
					// 一周记录
					meetingInfo = roomUsedService.getOneWeekMeetingInfo(roomid,start, end);
					map.put(roomName, meetingInfo);
				}
			}
			mv.addObject("roomList", roomList);// 本周周日日期
			mv.addObject("sunday", sunday);// 本周周日日期
			mv.addObject("saturday", saturday);// 本周周六日期
			mv.addObject("nowDay", nowDay);// 本周第几天
			mv.addObject("nowTime", nowTime);// 当前服务器时间
			mv.addObject("time", time);// 本周日期集合
			mv.addObject("map", map);
			mv.setViewName("/aco/meetingroom/roomboard");
		} catch (Exception e) {
			logger.error("error",e);
		}
		return mv;
	}

	/**
	 * 在指定的日期里加上天数，返回一个新的日期
	 * 
	 * @throws ParseException
	 * 
	 */
	public String addDaysFromDate(String date, String action) {
		String newDate = null;
		try {
			int amount;
			if ("next".equals(action)) {
				amount = 7;
			} else {
				amount = -7;
			}
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Calendar cal = Calendar.getInstance();
			if (date == null || "".equals(date)) {
				newDate = sdf.format(new Date());
			}
			cal.setTime(sdf.parse(date));
			cal.add(Calendar.DAY_OF_MONTH, amount);
			newDate = sdf.format(cal.getTime());
		} catch (Exception e) {
			logger.error("error",e);
		}
		return newDate;
	}

	/**
	 * 根据指定日期返回该星期第一天的日期
	 * 
	 * @param dateString
	 *            日期字符串 格式：yyyy-MM-dd
	 * @return
	 */
	public String getFirstDateOfWeek(String dateString) {
		String dateTime = dateString;
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Calendar cal = Calendar.getInstance();
			if (dateString == null || "".equals(dateString)) {
				dateString = sdf.format(new Date());
			}
			Date date = sdf.parse(dateString);
			cal.setTime(date);
			int days = cal.get(Calendar.DAY_OF_WEEK) - 1;
			cal.add(Calendar.DAY_OF_MONTH, days * -1);
			dateTime = sdf.format(cal.getTime());
		} catch (Exception e) {
			logger.error("error",e);
		}
		return dateTime;
	}
	
	
	
	/**
	 * 
	 * TODO: 通过会议Id删除会议信息
	 * @param roomApplyId
	 * @return
	 */
	@RequestMapping("/delRoomUsingById")
	@ResponseBody
	public String delRoomUsingById(@RequestParam(value="roomApplyId",defaultValue="") String roomApplyId ){
		if(StringUtils.isNotBlank(roomApplyId)){
			roomUsedService.delRoomUsingById(roomApplyId);
			return "0";
		}else{ 
			return "1";
		}
		
	}
}