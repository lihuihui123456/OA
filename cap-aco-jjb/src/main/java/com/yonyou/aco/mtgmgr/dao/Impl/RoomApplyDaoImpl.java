package com.yonyou.aco.mtgmgr.dao.Impl;

import java.util.List;

import javax.annotation.Resource;
import javax.persistence.Query;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.mtgmgr.dao.IRoomApplyDao;
import com.yonyou.aco.mtgmgr.entity.RoomApplySearchBean;
import com.yonyou.aco.mtgmgr.entity.RoomBean;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.dataauth.datarule.entity.DataRuleEnum;
import com.yonyou.cap.isc.dataauth.datarule.entity.SqlParam;
import com.yonyou.cap.isc.dataauth.datarule.service.IDataRuleService;

@Repository("roomApplyDao")
@SuppressWarnings("unchecked")
public class RoomApplyDaoImpl extends BaseDao implements IRoomApplyDao {
	
	@Resource IDataRuleService dataRuleService;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * TODO: 获取当前最大排序值
	 * TODO: 填入方法说明
	 * @see com.yonyou.cap.nxtbg.meetingmanager.repository.IRoomApplyDao#getCount()
	 */
	@Override
	public int getCount() {
		int count = 0;
		try {
			String sql = "SELECT MAX(SORT) AS SORT FROM BIZ_MT_ROOMAPPLY";
			Query query = em.createNativeQuery(sql);
			List<Integer> list = query.getResultList();
			if(list.get(0) != null){
				count = list.get(0).intValue();
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return count;
	}

	@Override
	public void doUpdateStatus(String ids, String status) {
		try {
			String sql = "update BizMtRoomApplyEntity r set r.status = ? where r.id = '" + ids + "'";
			Query query = em.createQuery(sql);
			query.setParameter(1, status);
			query.executeUpdate();
		} catch (Exception e) {
			logger.error("error",e);
		}

	}

	@Override
	public PageResult<RoomApplySearchBean> findAllPerApply(String meetingname, int pageNum,
			int pageSize,String sortName,String sortOrder,String queryParams, String modCode) {
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT m.id_ , m.meeting_name, r.room_name, a.USER_NAME, ");
		sql.append("m.starttime , m.endtime ,  m. status, m.ts FROM BIZ_MT_ROOMAPPLY m ");
		sql.append("LEFT JOIN ISC_USER a ON m.APPLY_USER_ID = a.USER_ID LEFT JOIN BIZ_MT_MEETINGROOM r ON m.ROOM_ID = r.ID_  ");
		sql.append(" WHERE 1 = 1 ");
		SqlParam sqlParam = dataRuleService.createSqlParam(modCode, "m",DataRuleEnum.DATA_ORG_ID);
		if (sqlParam != null && sqlParam.isHasDataRole()) {
			sql.append(sqlParam.getParam());
		}
		if (!"".equals(meetingname)) {
			sql.append("AND m.MEETING_NAME LIKE "+"'%"+meetingname.trim()+"%'");
		}else if(StringUtils.isNotBlank(queryParams)){
			if(StringUtils.isNotBlank(queryParams)){
				String[] paramsArr = queryParams.split("&");
				if(paramsArr != null && paramsArr.length > 0) {
					String[] keyValueArr;
					for (String keyValue : paramsArr) {
						keyValueArr = keyValue.split("=");
						if(keyValueArr.length == 2) {
							String key = keyValueArr[0];
							String value = keyValueArr[1];
							if(StringUtils.isNotBlank(key)&&StringUtils.isNotBlank(value)) {
								if("room_name".equals(key)){
									sql.append(" AND r.room_name like '%" + value.trim() + "%'");
								}else if("meeting_name".equals(key)){
									sql.append(" AND m.meeting_name like '%" + value.trim() + "%'");
								}else if("USER_NAME".equals(key)){
									sql.append(" AND a.USER_NAME like '%" + value.trim() + "%'");
								}else if("starttime".equals(key)){
									sql.append(" AND m.starttime >= '"+value+"' ");
								}else if("endtime".equals(key)){
									sql.append(" AND m.endtime  <= '"+value+"' ");
								}else if("status".equals(key)){
									sql.append(" AND m.status = '" + value + "'");
								}
							}
						}
					}
				}
			}
		}
		if(StringUtils.isNotEmpty(sortName)){
			if("status".equals(sortName)){
				sql. append(" order by CONVERT( m."+ sortName +" USING gbk) "+sortOrder);
			}else if("ts".equals(sortName)){
				sql. append(" order by CONVERT( m."+ sortName +" USING gbk) "+sortOrder);
			}else{
				sql. append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
			}
		}else{
			sql.append(" order by m.TS "+sortOrder);
		}
/*		Query query = em.createNativeQuery(sql.toString());
		if(!"".equals(meetingname)){
			query.setParameter(1, "%"+meetingname+"%");
		}*/
		return getPageData(RoomApplySearchBean.class, pageNum, pageSize, sql.toString());
	}

	@Override
	public RoomBean findPerApplyById(String id) {
		try {
			String sql = "SELECT m.ID_ roomapply_id, m.MEETING_NAME meeting_name, r.ROOM_NAME room_name, a.USER_NAME apply_user, s.ORG_NAME apply_org, ac.USER_NAME use_user, sy.ORG_NAME use_org, m.STARTTIME start_time, m.ENDTIME end_time, m.PURPOSE purpose, m.RESOURCE resource, m.REMARK remark, m.STATUS status, m.TS apply_time "
					+ "FROM BIZ_MT_ROOMAPPLY m "
					+ "LEFT JOIN BIZ_MT_MEETINGROOM r ON m.ROOM_ID = r.ID_ "
					+ "LEFT JOIN ISC_USER a ON m.APPLY_USER_ID = a.USER_ID "
					+ "LEFT JOIN ISC_ORG s ON m.APPLY_ORG_ID = s.ORG_ID "
					+ "LEFT JOIN ISC_USER ac ON m.USER_ID = ac.USER_ID "
					+ "LEFT JOIN ISC_ORG sy ON m.USER_ORG_ID = sy.ORG_ID "
					+ "WHERE m.ID_ = ?";
			Query query = em.createNativeQuery(sql);
			query.setParameter(1, id);
			query.unwrap(SQLQuery.class).setResultTransformer(
					Transformers.aliasToBean(RoomBean.class));
			RoomBean roomBean = (RoomBean) query.getResultList().get(0);
			return roomBean;
		} catch (Exception e) {
			logger.error("error",e);
			return null;
		}
	}
	
	/**
	 * 根据id获取会议室预订或使用的最晚结束时间
	 * 
	 */
	@Override
	public String getLastTimeById(String id, String dateTime) {
		String endTime = "";
		try {
			String sql = "select max(m.endtime) as endTime from biz_mt_roomapply m where m.room_id = '"+id+"' and m.status !='3'";
			Query  query = em.createNativeQuery(sql);
			String list = (String) query.getSingleResult();
			if( list != null ){
				endTime = list;
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return endTime;
	}

}
