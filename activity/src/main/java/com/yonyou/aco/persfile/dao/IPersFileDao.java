package com.yonyou.aco.persfile.dao;

import com.yonyou.aco.persfile.entity.PersInfoEntity;
import com.yonyou.cap.common.base.IBaseDao;

public interface IPersFileDao extends IBaseDao{
	/**
	 * 
	 * TODO: 填入方法说明
	 * @param adEntity
	 */
	public void doUpdatePersInfoEntity(PersInfoEntity persInfoEntity);
}
