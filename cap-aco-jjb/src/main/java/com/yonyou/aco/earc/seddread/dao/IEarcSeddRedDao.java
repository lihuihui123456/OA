package com.yonyou.aco.earc.seddread.dao;

import com.yonyou.aco.earc.seddread.entity.EarcSeddRedBean;
import com.yonyou.aco.earc.seddread.entity.EarcSeddRedListQuery;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;


/**
 * 
 * TODO: 电子档案dao接口类 
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2017年5月10日
 * @author  贺国栋
 * @since   1.0.0
 */
public interface IEarcSeddRedDao extends IBaseDao {
	/**
	 * 分页查询
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param EarcSeddRedListQuery
	 *            查询条件
	 * @return
	 */
	public PageResult<EarcSeddRedBean> pageEarcSeddRedBeanList(int pageNum,
			int pageSize, EarcSeddRedListQuery earcSeddRedListQuery);
	
	/**
	 * 分页查询档案查询列表
	 * 
	 * @param pageNum
	 * @param pageSize
	 *            查询条件
	 * @return
	 */
	public PageResult<EarcSeddRedBean> pageEarcSeddRedBeanList(int pageNum,
			int pageSize);
}
