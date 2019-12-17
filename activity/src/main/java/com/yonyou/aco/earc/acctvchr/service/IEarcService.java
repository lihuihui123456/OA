package com.yonyou.aco.earc.acctvchr.service;

import com.yonyou.aco.earc.acctvchr.entity.EarcBean;
import com.yonyou.aco.earc.acctvchr.entity.EarcBizIEntity;
import com.yonyou.cap.common.util.PageResult;

public interface IEarcService {

	/**
	 * 
	 * TODO: 会计凭证列表
	 * @param pageNum
	 * @param pageSize
	 * @param acctVchrName
	 * @param sortName
	 * @param sortOrder
	 * @return
	 */
	public PageResult<EarcBean> findEarcAcctVchrInfo(int pageNum, int pageSize,String solId,
			String acctVchrName, String sortName, String sortOrder,String userId,String queryParams);

	/**
	 * 
	 * TODO: 保存档案业务状态
	 * @param ebEntity
	 */
	public void doSaveEarcState(EarcBizIEntity ebEntity);

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

	/**
	 * 
	 * TODO: 添加电子档案业务信息
	 * @param ebEntity
	 */
	public void doSaveEarcBizInfo(EarcBizIEntity ebEntity);


}
