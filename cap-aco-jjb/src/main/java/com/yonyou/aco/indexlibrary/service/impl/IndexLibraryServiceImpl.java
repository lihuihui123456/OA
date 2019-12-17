package com.yonyou.aco.indexlibrary.service.impl;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.yonyou.aco.indexlibrary.dao.IIndexLibraryDao;
import com.yonyou.aco.indexlibrary.entity.IndexLibrary;
import com.yonyou.aco.indexlibrary.service.IIndexLibraryService;
import com.yonyou.cap.common.util.PageResult;

@Service
public class IndexLibraryServiceImpl implements IIndexLibraryService {

	@Resource
	IIndexLibraryDao indexLibraryDao;

	@Override
	public PageResult<IndexLibrary> findLeaveDateByQueryParams(int pageNum, int pageSize, String deptName) {
		StringBuilder sb = new StringBuilder();
		sb.append(
				"select b.id,b.dept_id deptId,b.dept_name deptName,b.pro_name proName,b.func_type funcType,b.budget_amount budgetAmount,b.dept_ext_amount deptExtAmount,b.dept_res_index deptResIndex,b.create_user_name createUserName,b.finc_ext_amount fincExtAmount,b.act_res_index actResIndex,b.remarks ");
		sb.append("from index_library b ");
		if (StringUtils.isNotBlank(deptName)) {
			sb.append("where dept_name like '%" + deptName + "%'");
		}
		try {
			return indexLibraryDao.getPageData(IndexLibrary.class, pageNum, pageSize, sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}

	@Override
	public void doSaveOrUpdateIndexLibraryInfo(IndexLibrary ilEntity) {
		try {
			indexLibraryDao.update(ilEntity);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void doDelIndexLiarbryById(String id) {
			indexLibraryDao.delete(IndexLibrary.class, id);
	}

	@Override
	public IndexLibrary findIndexLibDateById(String id) {
		return indexLibraryDao.findEntityByPK(IndexLibrary.class, id);
	}

}
