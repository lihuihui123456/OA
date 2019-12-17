package com.yonyou.aco.mtgmgr.dao.Impl;

import java.util.List;

import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.mtgmgr.dao.IRoomUsedDao;
import com.yonyou.aco.mtgmgr.entity.DateFindBean;
import com.yonyou.aco.mtgmgr.entity.RoomBean;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Repository("roomUsedDao")
@SuppressWarnings("unchecked")
public class RoomUsedDaoImpl extends BaseDao implements IRoomUsedDao {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * TODO: 根据会议室id 一周开始时间，一周结束时间检索对应会议室在一周内的预订信息 TODO: 填入方法说明
	 * 
	 * @see com.yonyou.cap.nxtbg.meetingmanager.repository.IRoomUsedDao#getOneWeekMeetingInfo(java.lang.Long,
	 *      java.lang.String, java.lang.String)
	 */
	@Override
	public List<RoomBean> getOneWeekMeetingInfo(String roomId,
			String start_time, String end_time) {
		String sql = " select num, status, meeting_name, purpose, start_time, end_time, room_id, wd, vuser_name apply_user,bm.room_apply_id roomapply_id, "
				+ " (case when CONVERT(start_time, CHAR(16)) >='"
				+ start_time
				+ "' then CONVERT(start_time, CHAR(16))  else '"
				+ start_time
				+ "' end) as virtual_time "
				+ " from ( select num, trim(date_add('"
				+ start_time
				+ "',interval dayofweek('"
				+ start_time
				+ "')*-1+num day)) wd from biz_mt_seq_number where num<8) aa "
				+ " left join (select mr.status,mr.meeting_name,mr.purpose,mr.start_time,mr.end_time,mr.room_id,mr.room_apply_id,ac.USER_NAME vuser_name from biz_mt_roomusing mr LEFT JOIN isc_user ac on mr.apply_user_id = ac.USER_ID)bm "
				+ " on convert(wd,char(10))=convert((case when start_time >='"
				+ start_time
				+ "' then start_time else '"
				+ start_time
				+ "' end),char(10)) "
				+ " and room_id='"
				+ roomId
				+ "' and status != '3' "
				+ " and CONVERT(start_time, CHAR(16))<='"
				+ end_time
				+ "' and CONVERT(end_time, CHAR(16)) >='"
				+ start_time
				+ "' "
				+ " order by num ,start_time";
		Query query = em.createNativeQuery(sql);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(RoomBean.class));
		List<RoomBean> list = query.getResultList();
		return list;
	}

	@Override
	public List<DateFindBean> getOneWeekMeetingTime(String sundayDate) {
		String sql = "select num, trim(date_add('" + sundayDate
				+ "',interval dayofweek('" + sundayDate
				+ "')*-1+num day)) wd from biz_mt_seq_number where num < 8";
		Query query = em.createNativeQuery(sql);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(DateFindBean.class));
		List<DateFindBean> list = query.getResultList();
		return list;
	}

	@Override
	public PageResult<RoomBean> findAllApply(int pageNum, int pageSize,
			String meetingname) {
		PageResult<RoomBean> pr = new PageResult<RoomBean>();
		try {
			StringBuffer sql = new StringBuffer();
			sql.append("select m.id_ roomused_id,m.room_apply_id roomapply_id,a.user_name apply_user,r.room_name room_name,m.meeting_name meeting_name,m.start_time start_time,m.end_time end_time,m.purpose purpose,m.apply_time ,m.status status "
					+ "from biz_mt_roomusing m "
					+ "left join isc_user a on m.apply_user_id = a.user_id "
					+ "left join biz_mt_meetingroom r on m.room_id = r.id_ ");
			if (!"".equals(meetingname)) {
				sql.append("where m.meeting_name like '%" + meetingname + "%' ");
			}
			sql.append("order by m.apply_time desc ");
			Query query = em.createNativeQuery(sql.toString());
			query.unwrap(SQLQuery.class).setResultTransformer(
					Transformers.aliasToBean(RoomBean.class));
			long size = query.getResultList().size();// 总数据长度
			/** 将传过来的页码*每页显示条数与总数进行对比，确定第一条数据的取值 */
			int firstindex = 0;
			if (pageNum > 0) {
				firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
			}
			if (firstindex >= size) {
				if (size > pageSize) {
					query.setFirstResult(((int) size / pageSize) * pageSize)
							.setMaxResults(pageSize);
				} else {
					query.setFirstResult(0).setMaxResults(pageSize);
				}
			} else {
				query.setFirstResult(firstindex).setMaxResults(pageSize);
			}
			List<RoomBean> list = query.getResultList();
			pr.setResults(list);
			pr.setTotalrecord(size);
			return pr;
		} catch (Exception e) {
			 logger.error("error",e);
		}
		return pr;
	}

	@Override
	public void doUpdateStatus(String ids, String status) {
		try {
			String sql = "update BizMtRoomUsingEntity r set r.status = '"
					+ status + "' where r.room_apply_id = '" + ids + "' ";
			Query query = em.createQuery(sql);
			query.executeUpdate();
		} catch (Exception e) {
			 logger.error("error",e);
		}
	}

	@Override
	public void delRoomUsingById(String roomApplyId) {
		try {
			String sql = "DELETE r.*, b.* FROM biz_mt_roomapply r INNER JOIN biz_mt_roomusing b ON r.id_ = b.room_apply_id WHERE r.id_ =?";
			Query query = em.createNativeQuery(sql);
			query.setParameter(1, roomApplyId);
			query.executeUpdate();
		} catch (Exception e) {
			 logger.error("error",e);
		}
	}
}
