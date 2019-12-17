package com.yonyou.aco.calendar.service;

import java.util.List;
import java.util.Map;

import com.yonyou.aco.calendar.entity.BizCalendarEntity;
import com.yonyou.aco.calendar.entity.BizCalendarHolidayEntity;
import com.yonyou.cap.common.util.PageResult;

/**
 * 
 * <p>
 * 概述：业务模块——日程管理接口类
 * <p>
 * 功能：日程管理功能的一些接口方法定义
 * <p>
 * 作者：贺国栋
 * <p>
 * 创建时间： 2016年8月1日
 * <p>
 * 类调用特殊情况：无
 */
public interface IBizCalendarService {

	/**
	 * 
	 * @Title: getCalendarByUser
	 * @Description: 获取用户所有日程信息
	 * @param userID
	 * @return
	 */
	public List<Object> findAllCalendarByUserId(String userId);

	/**
	 * 
	 * @Title: saveOrUpdateCalendar
	 * @Description: 保存或修改日程
	 * @param BizCalendarEntity
	 * @return
	 */
	public String doSaveOrUpdateCalendar(BizCalendarEntity bcEntity);

	/**
	 * 
	 * @Title: selectCalendarById
	 * @Description: 通过Id获取日程信息
	 * @param id
	 * @return
	 */
	public BizCalendarEntity findCalendarById(String id);

	/**
	 * 
	 * @Title: getUserCalendarByToDay
	 * @Description: 获取用户当天的日程
	 * @param userId
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public Map<String, List> findToMonthCalendarByUserid(String userId,
			String date);

	/**
	 * 
	 * @Title: doDeleteCalendarByUserid
	 * @Description: 通过Id删除日程信息
	 * @param id
	 */
	public void doDeleteCalendarByUserid(String id);

	/**
	 * 
	 * @Title: doUpdateCalendarStateByUserId
	 * @Description: 通过Id修改用户日程信息-(拖动调用)
	 * @param id
	 */
	public void doUpdateCalendarStateByUserId(String id);

	/**
	 * 获取指定某一天用户的日程
	 * 
	 * @param userId
	 * @param date
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public Map<String, List> findCalendarByDate(String userId, String date);

	/**
	 * 
	 * TODO: 分页获取节假日信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param holidayName
	 * @return
	 */
	public PageResult<BizCalendarHolidayEntity> findBizCalendarHolidayData(
			int pageNum, int pageSize, String holidayName,String sortName,String sortOrder,String year);

	/**
	 * 
	 * TODO: 保存节假日信息
	 * @param bchEntity
	 * @return
	 */
	public String doSaveOrUpdateCalendarHoliday(
			BizCalendarHolidayEntity bchEntity);

	/**
	 * 
	 * TODO:通过ID查看节假日信息
	 * @param id
	 * @return
	 */
	public BizCalendarHolidayEntity findBizCalendarHolidayDataById(String id);

	/**
	 * 通过ID删除节假日信息
	 * @param id
	 */
	public void doDelCalendarHoliDayById(String id);

}
