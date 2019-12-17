package com.yonyou.jjb.contractmgr.service;

import com.yonyou.cap.common.util.PageResult;
import com.yonyou.jjb.contractmgr.entity.BizContractEntity;
import com.yonyou.jjb.contractmgr.entity.BpmRuBizInfoBean;

public interface IContractMgrService {
	/**
	 * 分页获取请假信息
	 * 
	 * @param pageNum
	 *            页码
	 * @param pageSize
	 *            每页数目
	 * @return
	 */
	public PageResult<BizContractEntity> getAllData(int pageNum, int pageSize,String modCode);

	/**
	 * 分页搜索请假信息
	 * 
	 * @param pageNum
	 *            页码
	 * @param pageSize
	 *            每页数目
	 * @param roomName
	 *            搜索条件：
	 * @return
	 */
	public PageResult<BizContractEntity> getAllData(int pageNum, int pageSize,
			String searchInfo,String modCode);

	/**
	 * 根据ID获取一条信息
	 * 
	 * @param id
	 * @return
	 */
	public BizContractEntity findLeaveInfoById(String id);


	/**
	 * 修改信息
	 * 
	 * @param meetingRoom
	 */
	public void doUpdateContractInfo(BizContractEntity contractEntity);

	/**
	 * 根据主键删除一条信息
	 * 
	 * @param ids[]
	 * @return 
	 */
	public void doDelLeaveInfo(String userid);
	
	
	
	public PageResult<BpmRuBizInfoBean> findBpmRuBizInfoBeanBySolId(String modCode,int pageNum,
			int pageSize, String userId, String solId, String title,String sortName, String sortOrder );
	public PageResult<BpmRuBizInfoBean> findBpmRuBizInfoBeanBySolId(String modCode,int pageNum,
			int pageSize, String userId, String solId, String title,String state,String sortName,String sortOrder);
	public PageResult<BpmRuBizInfoBean> findBpmRuBizInfoBeanByQueryParams(
			String modCode,int pageNum, int pageSize, String userId, String solId,
			String queryParams,String sortName,String sortOrder);
	//列表排序
	public PageResult<BpmRuBizInfoBean> findBpmRuBizInfoBeanBySolId(String modCode,int pageNum,
			int pageSize, String userId, String solId,String sortName, String sortOrder);
	
}
