package com.yonyou.aco.indexlibrary.service;

import com.yonyou.aco.indexlibrary.entity.IndexLibrary;
import com.yonyou.cap.common.util.PageResult;

public interface IIndexLibraryService {
	public PageResult<IndexLibrary> findLeaveDateByQueryParams(int pageNum, int pageSize, String deptName);

	/**
	 * 保存指标库信息
	 * @param ilEntity
	 */
	public void doSaveOrUpdateIndexLibraryInfo(IndexLibrary ilEntity);

	/**
	 * 删除指标库信息
	 * @param id
	 */
	public void doDelIndexLiarbryById(String id);

	public IndexLibrary findIndexLibDateById(String id);
}
