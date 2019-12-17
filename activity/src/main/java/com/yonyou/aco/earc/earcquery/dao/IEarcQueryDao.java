package com.yonyou.aco.earc.earcquery.dao;

import java.util.List;

import com.yonyou.aco.earc.earcquery.entity.EarcQueryBean;
import com.yonyou.cap.common.base.IBaseDao;

public interface IEarcQueryDao extends IBaseDao {
	/**
	 * 
	 * TODO: 档案总库导出
	 * @param userId
	 * @param trim
	 * @param queryParams
	 * @return
	 */
	public List<EarcQueryBean> findEarcDateAll(String sb);

}
