package com.yonyou.aco.persfile.service;

import com.yonyou.aco.persfile.entity.PersFileEntity;
import com.yonyou.aco.persfile.entity.PersInfoBean;
import com.yonyou.aco.persfile.entity.PersInfoEntity;
import com.yonyou.cap.common.util.PageResult;

public interface IPersFileService {

	/**
	 * 分页获取人事管理信息
	 * @param pageNum
	 * @param pageSize
	 * @param solId
	 * @param userName
	 * @param sortName
	 * @param sortOrder
	 * @param userId
	 * @param queryParams
	 * @return
	 */
	public PageResult<PersInfoBean> findPersFileDateByQueryParams(int pageNum, int pageSize, String solId, String userName,
			String sortName, String sortOrder, String userId, String queryParams);

	/**
	 * 保存人事业务信息
	 * @param pfEntity
	 */
	public void doSavePersFileInfo(PersFileEntity pfEntity);

	/**
	 * 通过ID删除人事信息
	 * @param ids
	 */
	public void doDelPersFileInfoByPersFileId(String []ids);
	/**
	 * 通过ID查询人员基本信息
	 * @param id
	 */
	public PersInfoEntity findPersInfoEntityById(String id);
	/**
	 * 
	 * TODO: 填入方法说明
	 * @param adEntity
	 */
	public void doUpdatePersInfoEntity(PersInfoEntity persInfoEntity);
}
