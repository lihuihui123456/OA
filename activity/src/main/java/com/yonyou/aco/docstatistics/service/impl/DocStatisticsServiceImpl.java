package com.yonyou.aco.docstatistics.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yonyou.aco.docstatistics.dao.DocStatisticsDao;
import com.yonyou.aco.docstatistics.entity.DocStatisticsBean;
import com.yonyou.aco.docstatistics.service.DocStatisticsService;
import com.yonyou.cap.common.util.PageResult;

@Service("DocStatisticsService")
public class DocStatisticsServiceImpl implements DocStatisticsService{
	@Resource
	DocStatisticsDao dao;
	@Override
	public PageResult<DocStatisticsBean> queryByDeptId(String parentDeptId,int pageNum,int pageSize,String deptName) {
		return dao.queryByDeptId(parentDeptId,pageNum,pageSize,deptName);
	}
	@Override
	public String findOrgIdByUserId(String userId) {
		return dao.findOrgIdByUserId(userId);
	}
	@Override
	public boolean isHasChildDept(String deptId) {
		return dao.isHasChildDept(deptId);
	}
	@Override
	public String getParentDeptId(String deptId) {
		return dao.getParentDeptId(deptId);
	}
	@Override
	public PageResult<DocStatisticsBean> queryByOrgId(String orgId,
			int pageNum, int pageSize, String orgName) {
		return dao.queryByOrgId(orgId, pageNum, pageSize, orgName);
	}

}
