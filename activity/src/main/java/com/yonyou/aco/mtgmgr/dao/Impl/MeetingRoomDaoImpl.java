package com.yonyou.aco.mtgmgr.dao.Impl;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.yonyou.aco.mtgmgr.dao.IMeetingRoomDao;
import com.yonyou.cap.common.base.impl.BaseDao;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Repository("meetingRoomDao")
public class MeetingRoomDaoImpl extends BaseDao implements IMeetingRoomDao {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Override
	public int getCount() {
		int count = 0;
		try {
			String sql = "SELECT MAX(SORT) AS SORT FROM BIZ_MT_MEETINGROOM";
			Query query = em.createNativeQuery(sql);
			Integer list =  (Integer) query.getSingleResult();
			if(list != null){
				count = list.intValue();
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return count;
	}

}
