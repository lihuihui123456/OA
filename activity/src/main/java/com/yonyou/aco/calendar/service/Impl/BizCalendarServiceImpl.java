package com.yonyou.aco.calendar.service.Impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONException;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.yonyou.aco.calendar.dao.IBizCalendarDao;
import com.yonyou.aco.calendar.entity.BizCalendarEntity;
import com.yonyou.aco.calendar.entity.BizCalendarHolidayEntity;
import com.yonyou.aco.calendar.service.IBizCalendarService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.service.IUserService;

/**
 * 
 * <p>
 * 概述：业务模块——日程管理功能接口实现类
 * <p>
 * 功能：日程管理功能实现类
 * <p>
 * 作者：贺国栋
 * <p>
 * 创建时间：2016年8月1日
 * <p>
 * 类调用特殊情况：无
 */
@Service("bizCalendarService")
public class BizCalendarServiceImpl implements IBizCalendarService {

	@Resource
	IBizCalendarDao iBizCalendarDao;

	@Resource
	IUserService userService;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 获取用户所有日程信息
	 * 
	 * @see com.yonyou.aco.calendar.service.IBizCalendarService#getCalendarByUser(java.lang.String)
	 */
	@Override
	public List<Object> findAllCalendarByUserId(String userID) {

		ShiroUser shiroUser = (ShiroUser) SecurityUtils.getSubject()
				.getPrincipal();
		// 当前登录用户Id
		String loginUserId = shiroUser.getUserId();
		List<BizCalendarEntity> list = iBizCalendarDao.findAllCalendarByUserId(
				userID, "1','0");
		List<Object> listObj = new ArrayList<Object>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (list == null) {
		} else {
			for (int i = 0; i < list.size(); i++) {
				BizCalendarEntity bcEntity = list.get(i);
				Map<String, Object> map = new HashMap<String, Object>();
				User user = userService.findUserById(bcEntity
						.getAppoint_user_());
				// 创建用户Id
				String userId = bcEntity.getUserId_();
				// 被指派人Id
				String apponitUserId = bcEntity.getAppoint_user_();
				map.put("id", bcEntity.getId());
				map.put("title", bcEntity.getTitle_());
				map.put("loginUserId", loginUserId);
				map.put("appointUserName", user.getUserName());
				map.put("userName", bcEntity.getUserName_());
				map.put("appointUserId", bcEntity.getAppoint_user_());
				map.put("allDay", false);
				if (StringUtils.isNotBlank(userId)
						&& StringUtils.isNotBlank(apponitUserId)
						&& StringUtils.isNotBlank(loginUserId)) {
					map.put("userId", userId);
					map.put("shiroUser", loginUserId);
					map.put("appointUserId", apponitUserId);
					if (!userId.equals(apponitUserId) && userId.equals(loginUserId)) {
						map.put("backgroundColor", "#A3E492");// 登录人为他人创建的日程
					} else if (!userId.equals(loginUserId)
							&& apponitUserId.equals(loginUserId) ) {
						map.put("backgroundColor", "#E0E097");// 他人为登录人创建的日程
					} else {
						map.put("backgroundColor", "");// 自己给自己创建的
					}
				}
				if (bcEntity.getStartTime_() != null
						&& bcEntity.getEndTime_() != null) {
					map.put("start", sdf.format(bcEntity.getStartTime_()));
					map.put("end", sdf.format(bcEntity.getEndTime_()));
				}
				listObj.add(map);
			}

		}
		return listObj;
	}

	/**
	 * 获取用户当天的日程信息——首页展示
	 * 
	 * @throws JSONException
	 * 
	 * @see com.yonyou.aco.calendar.service.IBizCalendarService#getUserCalendarByToDay(java.lang.String)
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public Map<String, List> findToMonthCalendarByUserid(String userId,
			String date) throws JSONException {
		// 日期转换
		Calendar cld = Calendar.getInstance();
		List<BizCalendarEntity> list = iBizCalendarDao
				.findToMonthCalendarByUserid(userId, date);
		if (list != null) {
			List resList = new ArrayList<>();
			Map resObj = new HashMap<>();
			for (int i = 0; i < list.size(); i++) {
				BizCalendarEntity bcEntity = list.get(i);
				Date startTime = bcEntity.getStartTime_();
				// 日期转换
				cld.setTime(startTime);
				int year = cld.get(Calendar.YEAR);// 年
				int month = cld.get(Calendar.MONTH) + 1;// 月
				int day = cld.get(Calendar.DAY_OF_MONTH);// 日
				/*
				 * int hour = cld.get(Calendar.HOUR_OF_DAY);// 时 int minute =
				 * cld.get(Calendar.MINUTE);// 分
				 */
				Map ymdMap = new HashMap<>();
				ymdMap.put("year", year);
				ymdMap.put("month", month);
				ymdMap.put("day", day);
				resList.add(ymdMap);
			}
			resObj.put("events", resList);
			System.out.println(resObj.toString());
			return resObj;
		} else {
			return null;
		}

	}

	/**
	 * 通过日程ID删除日程
	 * 
	 * @see com.yonyou.aco.calendar.service.IBizCalendarService#doDeleteCalendarByUserid(java.lang.String)
	 */
	@Override
	public void doDeleteCalendarByUserid(String id) {
		iBizCalendarDao.delete(BizCalendarEntity.class, id);

	}

	/**
	 * 保存和修改日程实体
	 * 
	 * @see com.yonyou.aco.calendar.service.IBizCalendarService#saveOrUpdateCalendar(com.yonyou.aco.calendar.entity.BizCalendarEntity)
	 */
	@Override
	public String doSaveOrUpdateCalendar(BizCalendarEntity bcEntity) {

		String ids = bcEntity.getId();
		if (ids != null && !"".equals(ids)) {
			iBizCalendarDao.update(bcEntity);
		} else {
			bcEntity.setId(null);
			iBizCalendarDao.save(bcEntity);
		}
		return bcEntity.getId();
	}

	/**
	 * 通过日程ID查询日程信息
	 * 
	 * @see com.yonyou.aco.calendar.service.IBizCalendarService#selectCalendarById(java.lang.String)
	 */
	@Override
	public BizCalendarEntity findCalendarById(String id) {
		BizCalendarEntity bcEntity = iBizCalendarDao.findEntityByPK(
				BizCalendarEntity.class, id);
		return bcEntity;
	}

	/**
	 * 通过 日程ID修改日程状态
	 * 
	 * @see com.yonyou.aco.calendar.service.IBizCalendarService#doUpdateCalendarStateByUserId(java.lang.String)
	 */
	public void doUpdateCalendarStateByUserId(String id) {
		iBizCalendarDao.doUpdateCalendarStateByUserId(id);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public Map<String, List> findCalendarByDate(String userId, String date) {
		Map<String, List> resMap = new HashMap<String, List>();
		List resList = new ArrayList<>();
		List<Map<String, String>> calendarList = new ArrayList<Map<String, String>>();
		Calendar cld = Calendar.getInstance();
		List<BizCalendarEntity> list = iBizCalendarDao.findCalendarByDate(
				userId, date);
		int year = 0;// 年
		int month = 0;// 月
		int day = 0;// 日
		if (list != null) {
			Map<String, Object> map = new HashMap<String, Object>();
			for (int i = 0; i < list.size(); i++) {
				BizCalendarEntity bcEntity = list.get(i);
				Date startTime = bcEntity.getStartTime_();
				// 日期转换
				cld.setTime(startTime);
				year = cld.get(Calendar.YEAR);// 年
				month = cld.get(Calendar.MONTH) + 1;// 月
				day = cld.get(Calendar.DAY_OF_MONTH);// 日
				int hour = cld.get(Calendar.HOUR_OF_DAY);// 时
				int minute = cld.get(Calendar.MINUTE);// 分
				String min;
				String strHour;
				if (minute < 10) {
					min = "0" + minute;
				} else {
					min = String.valueOf(minute);
				}
				if (hour < 10) {
					strHour = "0" + hour;
				} else {
					strHour = String.valueOf(hour);
				}
				Map<String, String> newmap = new HashMap<String, String>();
				newmap.put("time", strHour + ":" + min);
				newmap.put("title", bcEntity.getTitle_());
				calendarList.add(newmap);
			}
			map.put("list", calendarList);
			map.put("month", String.valueOf(month));
			map.put("day", String.valueOf(day));
			map.put("year", String.valueOf(year));
			resList.add(map);
			resMap.put("events", resList);
			return resMap;
		} else {
			return null;
		}

	}

	/**
	 * 
	 * TODO: 分页获取节假日信息
	 * 
	 * @see com.yonyou.aco.calendar.service.IBizCalendarService#findBizCalendarHolidayData(int,
	 *      int, java.lang.String)
	 */
	@Override
	public PageResult<BizCalendarHolidayEntity> findBizCalendarHolidayData(
			int pageNum, int pageSize, String holidayName, String sortName,
			String sortOrder, String year) {
		PageResult<BizCalendarHolidayEntity> pages = null;
		try {
			StringBuilder sb = new StringBuilder();
			sb.append("SELECT a.ID,a.HOLIDAY_NAME,a.HOLIDAY_NUM,a.HOLIDAY_START_DATE,"
					+ "a.HOLIDAY_END_DATE,a.HOLIDAY_REMARK,u.USER_NAME DATA_USER_ID "
					+ "FROM biz_calendar_holiday_info a LEFT JOIN isc_user u "
					+ "ON u.USER_ID = a.DATA_USER_ID");

			if (StringUtils.isNotBlank(holidayName)) {
				sb.append(" WHERE a.HOLIDAY_NAME LIKE '%" + holidayName + "%' ");
			}
			if (StringUtils.isNotBlank(year)) {
				sb.append(" WHERE a.HOLIDAY_END_DATE LIKE '%" + year + "%' ");
			}

			if (StringUtils.isNotBlank(sortName)
					&& StringUtils.isNotBlank(sortOrder)) {
				sb.append(" ORDER BY a." + sortName + " " + sortOrder);
			} else {
				sb.append(" ORDER BY a.HOLIDAY_END_DATE ASC");
			}
			pages = iBizCalendarDao.getPageData(BizCalendarHolidayEntity.class,
					pageNum, pageSize, sb.toString());
		} catch (Exception e) {
			logger.error("error", e);
		}
		return pages;
	}

	/**
	 * 
	 * TODO: 保存或修改节假日信息
	 * 
	 * @see com.yonyou.aco.calendar.service.IBizCalendarService#doSaveOrUpdateCalendarHoliday(com.yonyou.aco.calendar.entity.BizCalendarHolidayEntity)
	 */
	@Override
	public String doSaveOrUpdateCalendarHoliday(
			BizCalendarHolidayEntity bchEntity) {
		String id = bchEntity.getID();
		if (StringUtils.isBlank(id)) {
			bchEntity.setID(null);
			iBizCalendarDao.save(bchEntity);
		} else {
			iBizCalendarDao.update(bchEntity);
		}
		return "1";
	}

	/**
	 * 
	 * TODO: 通过ID查看节假日信息
	 * 
	 * @see com.yonyou.aco.calendar.service.IBizCalendarService#findBizCalendarHolidayDataById(java.lang.String)
	 */
	@Override
	public BizCalendarHolidayEntity findBizCalendarHolidayDataById(String id) {
		return iBizCalendarDao.findBizCalendarHolidayDataById(id);
	}

	/**
	 * 通过ID删除节假日信息
	 */
	@Override
	public void doDelCalendarHoliDayById(String id) {
		iBizCalendarDao.delete(BizCalendarHolidayEntity.class, id);

	}
}
