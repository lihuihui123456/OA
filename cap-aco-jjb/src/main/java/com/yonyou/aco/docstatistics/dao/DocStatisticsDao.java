package com.yonyou.aco.docstatistics.dao;

import com.yonyou.aco.docstatistics.entity.DocStatisticsBean;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;

/**
 * <p>概述：业务模块公文统计dao层
 * <p>功能：按照部门划分，统计公文的行文数与流转数
 * <p>作者：葛鹏
 * <p>创建时间：2017年5月26日
 * <p>类调用特殊情况：无
 */
/**
 * @author gp
 *
 */
public interface DocStatisticsDao extends IBaseDao{
	
	/**
	 * 
	 * @param parentDeptId
	 * @return
	 */
	public PageResult<DocStatisticsBean> queryByDeptId(String parentDeptId,int pageNum,int pageSize,String deptName);
	/**
	 * 
	 * @param parentDeptId
	 * @return
	 */
	public PageResult<DocStatisticsBean> queryByOrgId(String orgId,int pageNum,int pageSize,String orgName);
	
	/**
	 * @param userId
	 * @return
	 */
	public String findOrgIdByUserId(String userId);
	
	/**
	 * @param deptId
	 * @return
	 */
	public boolean isHasChildDept(String deptId);
	
	public String getParentDeptId(String deptId);
}
