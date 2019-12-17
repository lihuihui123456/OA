package com.yonyou.aco.persfile.dao.impl;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.yonyou.aco.persfile.dao.IPersFileDao;
import com.yonyou.aco.persfile.entity.PersInfoEntity;
import com.yonyou.cap.common.base.impl.BaseDao;

@Repository("persFileDao")
public class PersFileDaoImpl extends BaseDao implements IPersFileDao {

	@Override
	public void doUpdatePersInfoEntity(PersInfoEntity persInfoEntity) {
		String sql="update fd_biz_people set dr='Y' where id='"+persInfoEntity.getId()+"'";
		Query query = em.createNativeQuery(sql);
		query.executeUpdate();
	}

}
