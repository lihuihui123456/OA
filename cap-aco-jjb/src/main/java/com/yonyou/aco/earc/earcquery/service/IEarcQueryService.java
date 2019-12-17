package com.yonyou.aco.earc.earcquery.service;

import java.util.List;

import com.yonyou.aco.earc.earcquery.entity.EarcQuery;
import com.yonyou.aco.earc.earcquery.entity.EarcQueryBean;
import com.yonyou.cap.common.util.PageResult;

/**
 * 
 * TODO: 档案总库查询服务层接口类
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2017年5月3日
 * @author  贺国栋
 * @since   1.0.0
 */
public interface IEarcQueryService {

	/**
	 * 
	 * TODO: 档案总库查询
	 * @param pageNum
	 * @param pageSize
	 * @param userId
	 * @param trim
	 * @param sortName
	 * @param sortOrder
	 * @param queryParams
	 * @return
	 */
	public PageResult<EarcQueryBean> findEarcDateAll(String modeCode,int pageNum, int pageSize,
			String ctlgId,String userId, String trim, String sortName, String sortOrder,
			String queryParams);
	/**
	 * 
	 * TODO: 档案总库导出
	 * @param userId
	 * @param trim
	 * @param queryParams
	 * @return
	 */
	public List<EarcQueryBean> findEarcDateAll(String modeCode,
			String ctlgId,String userId, String title,
			EarcQuery earcQuery);
	/**
	 * 
	 * TODO: 查询档案
	 * @param id
	 * @return
	 */
    public EarcQueryBean findEarcQueryBeanById(String id);
}
