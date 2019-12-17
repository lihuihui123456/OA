package com.yonyou.aco.earc.acctvchr.dao;

import com.yonyou.cap.common.base.IBaseDao;

public interface IEarcDao extends IBaseDao {

	/**
	 * 
	 * TODO: 电子档案归档
	 * @param earcId
	 * @param earcCtlgId
	 */
	public void earcFileByCtlgId(String earcId, String earcCtlgId);

	/**
	 * 
	 * TODO: 通过档案Id修改档案状态
	 * @param earcId
	 * @param earcState
	 */
	public void updateEarcStateByEarcId(String earcId, String earcState);


}
