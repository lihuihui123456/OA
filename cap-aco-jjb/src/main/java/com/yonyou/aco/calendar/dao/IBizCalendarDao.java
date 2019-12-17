package com.yonyou.aco.calendar.dao;

import java.util.List;

import com.yonyou.aco.calendar.entity.BizCalendarEntity;
import com.yonyou.aco.calendar.entity.BizCalendarHolidayEntity;
import com.yonyou.cap.common.base.IBaseDao;

/**
 * <p>概述：业务模块日程管理 dao接口
 * <p>功能：实现对日程管理业务数据处理接口类
 * <p>作者：贺国栋
 * <p>创建时间：2016年8月1日
 * <p>类调用特殊情况：无
 */
public interface IBizCalendarDao extends IBaseDao {
	/**
	 * 根据用户ID查找实体类
	 * @param userId
	 */
	public List<BizCalendarEntity> findAllCalendarByUserId(String userId,String state);
	
	/**
	 * 根据实体保存对象
	 * @param BizCalendarEntity
	 */
	public void doSaveCalendar(BizCalendarEntity bcEntity);
	/**
	 * 根据实体更新对象
	 * @param BizCalendarEntity
	 */
	public void doUpdateCalendar(BizCalendarEntity bcEntity);
	/**
	 * 通过日期和用户ID查询实体类 by:hegd
	 * @param userId
	 * @param data
	 * @return
	 */
	public List<BizCalendarEntity> findToMonthCalendarByUserid(String userId,String date);
	/**
	 * 删除日程
	 * @param id
	 */
	public void doDeleteCalendar(String id);
	/**
	 * 修改日程状态
	 * @param userId
	 */
	public void doUpdateCalendarStateByUserId(String userId);
	/**
	 * 根据年月查询当前月份的所有时间
	 * @param time
	 * @return
	 */
	public List<BizCalendarEntity> findMonthMessageDay(String time,String userId);

	/**
	 * 获取某一天的日程信息
	 * @param userId
	 * @param date
	 * @return
	 */
	public List<BizCalendarEntity> findCalendarByDate(String userId, String date);

	/**
	 * 
	 * TODO: 通过ID查看节假日信息
	 * @param id
	 * @return
	 */
	public BizCalendarHolidayEntity findBizCalendarHolidayDataById(String id);
}
