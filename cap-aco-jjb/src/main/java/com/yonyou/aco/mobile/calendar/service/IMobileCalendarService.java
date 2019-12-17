package com.yonyou.aco.mobile.calendar.service;

import java.util.List;

import com.yonyou.aco.calendar.entity.BizCalendarEntity;



/**
 * 
 * ClassName: IMobileCalendarService
 * 
 * @Description: 移动端-日程管理接口类
 * @author hegd
 * @date 2016-8-31
 */
public interface IMobileCalendarService {

	/**
	 * 
	 * @Description: TODO
	 * @param @param 移动端-通过用户ID获取日程信息
	 * @param @return   
	 * @return String  
	 * @throws
	 * @author hegd
	 * @date 2016-8-31
	 */
	public String findCalendarInfoByUserId(String userId,String type);
	
	/**
	 * 根据年月查询当前月份的所有时间
	 * @param time
	 * @return
	 */
	public List<BizCalendarEntity> findMonthMessageDay(String time,String userId);
}
