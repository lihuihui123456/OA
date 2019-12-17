package com.yonyou.aco.calendar.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.validation.Valid;





import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.calendar.entity.BizCalendarEntity;
import com.yonyou.aco.calendar.entity.BizCalendarHolidayEntity;
import com.yonyou.aco.calendar.service.IBizCalendarService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.service.IUserService;

/**
 * <p>
 * 概述：业务日程管理 Controller类
 * <p>
 * 功能：实现对业务日程管理解决方案业务请求处理
 * <p>
 * 作者：贺国栋
 * <p>
 * 创建时间：2016-08-01
 * <p>
 * 类调用特殊情况：无calendar
 */
@Controller
@RequestMapping("/bizCalendarController")
public class BizCalendarController {

	@Resource
	IBizCalendarService bizCalendarService;
	@Resource
	IUserService userService;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 
	 * @Title: modeler
	 * @Description: 跳转日程首页
	 * @return
	 */
	@RequestMapping("/index")
	public ModelAndView modeler(
			@RequestParam(value = "date", defaultValue = "") String date) {
		String newDate;
		if (StringUtils.isNoneBlank(date)) {
			newDate = date + " 00:00:00";
		} else {
			newDate = "";
		}
		ModelAndView mv = new ModelAndView();
		mv.addObject("newDate", newDate);
		mv.setViewName("/aco/calendar/calendar-index");
		return mv;
	}

	/**
	 * 
	 * @Description: 节假日主页
	 * @return
	 */
	@RequestMapping("/goToHodidayIndex")
	public String goToHodidayIndex() {
		return "/aco/calendar/holiday-list";
	}

	/**
	 * 
	 * @Title: detail
	 * @Description:跳转日程详细页
	 * @return
	 */
	@RequestMapping("/detail")
	public String detail() {
		return "/aco/calendar/calendar-detail";
	}

	/**
	 * 
	 * @Title: findAllCalendarByUserId
	 * @Description: 通过用户Id获取所有日程信息
	 * @return
	 */
	@RequestMapping("/findAllCalendarByUserId")
	@ResponseBody
	public List<Object> findAllCalendarByUserId() {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (null != user) {
			List<Object> list = bizCalendarService.findAllCalendarByUserId(user
					.getUserId());
			return list;
		}
		return new ArrayList<Object>();

	}

	/**
	 * 
	 * @Title: findToDayCalendarByuserId
	 * @Description: 获取当前登录用户 当天的所有日程信息
	 * @param response
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping("/findToMonthCalendarByUserid")
	public @ResponseBody Map<String, List> findToMonthCalendarByUserid(
			@RequestParam(value = "year", defaultValue = "") String year,
			@RequestParam(value = "month", defaultValue = "") String month,
			@RequestParam(value = "type", defaultValue = "") String type) {

		String newMonth;
		if (Integer.parseInt(month) < 10) {
			newMonth = "0" + month;
		} else {
			newMonth = month;
		}
		String date = year + "-" + newMonth;
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (null != user) {
			Map<String, List> list = bizCalendarService
					.findToMonthCalendarByUserid(user.getUserId(), date);
			return list;
		}
		return new HashMap<String, List>();
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping("/findCalendarByDate")
	@ResponseBody
	public Map<String, List> findCalendarByDate(
			@RequestParam(value = "date", defaultValue = "") String date) {
		Map<String, List> map = new HashMap<String, List>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (!"".equals(date) && null != user) {
			map = bizCalendarService.findCalendarByDate(user.getUserId(), date);
		}
		return map;
	}

	/**
	 * 
	 * @Title: doDeleteCalendarByUserid
	 * @Description: 根据日程Id删除日程
	 * @param id
	 * @return
	 */
	@RequestMapping("/doDeleteCalendarByUserid")
	@ResponseBody
	public String doDeleteUserCalendarById(
			@RequestParam(value = "id", defaultValue = "") String id) {
		if (StringUtils.isNotEmpty(id)) {
			bizCalendarService.doDeleteCalendarByUserid(id);
			return "true";
		} else {
			return "false";
		}
	}

	/**
	 * 
	 * @Title: doUpdateCalendarStateByUserId
	 * @Description: 通过日程ID修改日程状态
	 * @param id
	 * @return
	 */
	@RequestMapping("/doUpdateCalendarStateByUserId")
	@ResponseBody
	public String doUpdateCalendarStateByUserId(
			@RequestParam(value = "id", defaultValue = "0") String id) {
		if (StringUtils.isNotEmpty(id)) {
			bizCalendarService.doUpdateCalendarStateByUserId(id);
			return "true";
		} else {
			return "false";
		}
	}

	/**
	 * 
	 * @Title: doSaveOrUpdateCalendar
	 * @Description: 保存和修改日程信息
	 * @param bcEntity
	 * @return
	 */
	@RequestMapping("/doSaveOrUpdateCalendar")
	@ResponseBody
	public BizCalendarEntity doSaveOrUpdateCalendar(@Valid BizCalendarEntity bcEntity) {
		ShiroUser shiroUser = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (null != shiroUser) {
			String id = bizCalendarService.doSaveOrUpdateCalendar(bcEntity);
			BizCalendarEntity resBcEntity = bizCalendarService.findCalendarById(id);
			if(resBcEntity!=null){
				User user = userService.findUserById(resBcEntity.getAppoint_user_());
				resBcEntity.setAppoint_user_name(user.getUserName());
			}
			
			return resBcEntity;
		}
		return new BizCalendarEntity();
	}

	/**
	 * 
	 * @Title: findCalendarById
	 * @Description: 通过 日程Id获取日程信息
	 * @param id
	 * @return
	 */
	@RequestMapping("/findCalendarById")
	@ResponseBody
	public BizCalendarEntity findCalendarById(
			@RequestParam(value = "id") String id) {
		BizCalendarEntity bcEntity = bizCalendarService.findCalendarById(id);
		if(bcEntity !=null){
			// 日程所属人展示中文名
			String userId = bcEntity.getAppoint_user_();
			User user = userService.findUserById(userId);
			if(user!=null){
				String userName = user.getUserName();
				bcEntity.setAppoint_user_name(userName);
			}
		}
		return bcEntity;
	}

	/**
	 * 
	 * @Title: doDragCalendar
	 * @Description: 日程模块——拖动日程信息
	 * @param id
	 * @param start
	 * @param end
	 * @return
	 */
	@RequestMapping("/doDragCalendar")
	@ResponseBody
	public String doDragCalendar(@RequestParam(value = "id") String id,
			@RequestParam(value = "start") Date start,
			@RequestParam(value = "end") Date end) {
		if (start != null && end != null && StringUtils.isNotEmpty(id)) {

			BizCalendarEntity bcEntity = bizCalendarService
					.findCalendarById(id);
			bcEntity.setStartTime_(start);
			bcEntity.setEndTime_(end);
			String res = bizCalendarService.doSaveOrUpdateCalendar(bcEntity);
			return res;
		} else {
			return "";
		}
	}

	/**
	 * 
	 * TODO: 分页获取节假日信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param holidayName
	 * @return
	 */
	@RequestMapping("/findBizCalendarHolidayData")
	@ResponseBody
	public TreeGridView<BizCalendarHolidayEntity> findBizCalendarHolidayData(
			@RequestParam(value = "page", defaultValue = "0") int pageNum,
			@RequestParam(value = "rows", defaultValue = "10") int pageSize,
			@RequestParam(value = "holiName", defaultValue = "") String holiName,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder) {
		TreeGridView<BizCalendarHolidayEntity> treeGridview = new TreeGridView<BizCalendarHolidayEntity>();
		PageResult<BizCalendarHolidayEntity> pags = null;
		try {
			holiName = java.net.URLDecoder.decode(holiName, "UTF-8");
			holiName = java.net.URLDecoder.decode(holiName, "UTF-8");
			pags = bizCalendarService.findBizCalendarHolidayData(pageNum,
					pageSize, holiName, sortName, sortOrder,null);
			treeGridview.setRows(pags.getResults());
			treeGridview.setTotal(pags.getTotalrecord());
			return treeGridview;
		} catch (Exception e) {
			logger.error("error", e);
			return null;
		}
	}
 	/**
	 * 
	 * @return
	 */
	@RequestMapping("/findBizCalendarHolidayDataToTable")
	@ResponseBody
	public List<BizCalendarHolidayEntity> findBizCalendarHolidayDataToTable(
			@RequestParam(value="year",defaultValue="") String year) {
		PageResult<BizCalendarHolidayEntity> pags = bizCalendarService
				.findBizCalendarHolidayData(Integer.MIN_VALUE,
						Integer.MAX_VALUE, "", "", "",year);
		List<BizCalendarHolidayEntity>  list =  null;
		if(pags!=null){
			list = pags.getResults();
		}
		return list;
	}

	/**
	 * 
	 * @Title: doSaveOrUpdateCalendarHoliday
	 * @Description: 保存和修改节假日信息
	 * @param bcEntity
	 * @return
	 */
	@RequestMapping("/doSaveOrUpdateCalendarHoliday")
	@ResponseBody
	public String doSaveOrUpdateCalendarHoliday(
			@Valid BizCalendarHolidayEntity bchEntity) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (null != user) {
			bchEntity.setDATA_DEPT_CODE(user.getDeptCode());
			bchEntity.setDATA_DEPT_ID(user.getDeptId());
			bchEntity.setDATA_ORG_ID(user.getOrgid());
			bchEntity.setDATA_USER_ID(user.getUserId());
			return bizCalendarService.doSaveOrUpdateCalendarHoliday(bchEntity);
		}
		// 1：成功 0：失败
		return "0";
	}

	/**
	 * 
	 * @Title: findBizCalendarHolidayDataById
	 * @Description: 通过 日程Id获取节假日信息
	 * @param id
	 * @return
	 */
	@RequestMapping("/findBizCalendarHolidayDataById")
	@ResponseBody
	public BizCalendarHolidayEntity findBizCalendarHolidayDataById(
			@RequestParam(value = "Id") String Id) {
		BizCalendarHolidayEntity bchEntity = bizCalendarService
				.findBizCalendarHolidayDataById(Id);
		return bchEntity;
	}

	/**
	 * 
	 * @Title: doDelCalendarHoliDayById
	 * @Description: 通过 日程Id删除节假日信息
	 * @param id
	 * @return
	 */
	@RequestMapping("/doDelCalendarHoliDayById")
	@ResponseBody
	public String doDelCalendarHoliDayById(@RequestParam(value = "Id") String id) {
		if (id != null && !"".equals(id)) {
			String[] ids = id.split(",");
			for (int i = 0; i < ids.length; i++) {
				bizCalendarService.doDelCalendarHoliDayById(ids[i]);
			}
			return "1";
		} else {
			return "0";
		}
	}
}
