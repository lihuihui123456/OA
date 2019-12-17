package com.yonyou.aco.calendar.dao.Impl;

import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.yonyou.aco.calendar.dao.IBizCalendarDao;
import com.yonyou.aco.calendar.entity.BizCalendarEntity;
import com.yonyou.aco.calendar.entity.BizCalendarHolidayEntity;
import com.yonyou.cap.common.base.impl.BaseDao;

/**
 * <p>概述：业务模块日程管理 dao实现类
 * <p>功能：实现对日程管理业务数据处理实现类
 * <p>作者：贺国栋
 * <p>创建时间：2016-08-01
 * <p>类调用特殊情况：无
 */
@SuppressWarnings("unchecked")
@Repository("iBizCalendarDao")
public class BizCalendarDaoImpl extends BaseDao implements IBizCalendarDao {

	

	/**
	 * 通过用户ID获取用户日程信息
	 * @see com.yonyou.aco.calendar.dao.IBizCalendarDao#getCalendarByuserId(java.lang.String)
	 */
	@Override
	public List<BizCalendarEntity> findAllCalendarByUserId(String userId,String state) {
		String sql = "SELECT * FROM biz_calendar_info WHERE user_id_ = '"+userId+"' OR appoint_user_ ='"+userId+"'  AND state_ IN('"+state+"') ORDER BY start_time_";
		Query  query = em.createNativeQuery(sql,BizCalendarEntity.class);
		return query.getResultList();
	}
	
	/**
	 * 查询当前用户某月的所有日程-首页使用
	 * @param 年份+月份(date)
	 * @param 用户Id(userId)
	 * 
	 */
	@Override
	public List<BizCalendarEntity> findToMonthCalendarByUserid(String userId,String date) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT * FROM biz_calendar_info WHERE user_id_ = ? OR appoint_user_ = ? AND start_time_ LIKE '");
		sb.append(date).append("%'");
		sb.append(" AND state_ IN ('1','0') GROUP BY DATE_FORMAT(start_time_,'%Y-%m-%d') ORDER BY start_time_");
		Query  query = em.createNativeQuery(sb.toString(),BizCalendarEntity.class);
		query.setParameter(1, userId);
		query.setParameter(2, userId);
		return query.getResultList();
	}
	/**
	 * 通过Id修改日程状态
	 * @see com.yonyou.aco.calendar.dao.IBizCalendarDao#updateUserCalendarStateById(java.lang.String)
	 */
	/* (non-Javadoc)
	 * @see com.yonyou.aco.calendar.dao.IBizCalendarDao#doUpdateCalendarStateByUserId(java.lang.String)
	 */
	@Override
	public void doUpdateCalendarStateByUserId(String userId) {
		String sql = "UPDATE biz_calendar_info SET state_='1' WHERE id_='"+userId+"'";
		Query query = em.createNativeQuery(sql);
		query.executeUpdate();
	}
	@Override
	public void doSaveCalendar(BizCalendarEntity bcEntity) {
		this.save(bcEntity);
	}
	@Override
	public void doUpdateCalendar(BizCalendarEntity bcEntity) {
		this.update(bcEntity);
	}
	public void doDeleteCalendar(String id) {
		this.delete(BizCalendarEntity.class, id);
	}
	@Override
	public List<BizCalendarEntity> findMonthMessageDay(String time,String userId) {
		// TODO Auto-generated method stub
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT * FROM biz_calendar_info WHERE user_id_ = ?");
		sb.append(" AND start_time_ LIKE '").append(time).append("%'");
		sb.append(" AND state_ IN('1','0') ORDER BY start_time_");
		Query  query = em.createNativeQuery(sb.toString(),BizCalendarEntity.class);
		query.setParameter(1, userId);
		return query.getResultList();
	}

	@Override
	public List<BizCalendarEntity> findCalendarByDate(String userId, String date) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT * FROM biz_calendar_info WHERE (appoint_user_ = ?");
		sb.append(" OR user_id_ = ?)");
		sb.append(" AND start_time_ LIKE '").append(date).append("%'");
		sb.append(" AND state_ IN('1','0') ORDER BY start_time_");
		Query  query = em.createNativeQuery(sb.toString(),BizCalendarEntity.class);
		query.setParameter(1, userId);
		query.setParameter(2, userId);
		return query.getResultList();
	}

	@Override
	public BizCalendarHolidayEntity findBizCalendarHolidayDataById(String id) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT a.ID,a.HOLIDAY_NAME,a.HOLIDAY_NUM,a.HOLIDAY_START_DATE,"
				+ "a.HOLIDAY_END_DATE,a.HOLIDAY_REMARK,u.USER_NAME DATA_USER_ID,"
				+ "a.DATA_ORG_ID,a.DATA_DEPT_ID,a.TENANT_ID,a.TS,a.DATA_DEPT_CODE"
				+ " FROM biz_calendar_holiday_info a ");
		sb.append(" LEFT JOIN isc_user u ON u.USER_ID = a.DATA_USER_ID ");
		sb.append(" WHERE a.ID='"+id+"'");
		Query  query = em.createNativeQuery(sb.toString(),BizCalendarHolidayEntity.class);
		List<BizCalendarHolidayEntity> list= null;
		try {
			list = query.getResultList();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list.get(0);
	}
	
	
}
