package com.yonyou.aco.earc.acctvchr.dao.impl;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.yonyou.aco.earc.acctvchr.dao.IEarcDao;
import com.yonyou.cap.common.base.impl.BaseDao;


@Repository("earcDao")
public class EarcDaoImpl extends BaseDao implements IEarcDao {

	@Override
	public void earcFileByCtlgId(String earcId, String earcCtlgId) {
		String sql = "UPDATE earc_biz_info SET EARC_STATE=?,EARC_CTLG_ID=? WHERE EARC_ID=?";
		Query query = em.createNativeQuery(sql);
		query.setParameter(1, "1");
		query.setParameter(2, earcCtlgId);
		query.setParameter(3, earcId);
		query.executeUpdate();
	}

	@Override
	public void updateEarcStateByEarcId(String earcId, String earcState) {

		String sql = "UPDATE earc_biz_info SET EARC_STATE=? WHERE EARC_ID=?";
		Query query = em.createNativeQuery(sql);
		query.setParameter(1, earcState);
		query.setParameter(2, earcId);
		query.executeUpdate();
	}


}
