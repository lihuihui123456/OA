package com.yonyou.aco.earc.seddread.service;


import com.yonyou.aco.earc.seddread.entity.EarcSeddRedBean;
import com.yonyou.aco.earc.seddread.entity.EarcSeddRedEntity;
import com.yonyou.aco.earc.seddread.entity.EarcSeddRedListQuery;
import com.yonyou.cap.common.util.PageResult;


/**
 * 
 * TODO: 电子档案调阅服务层接口类
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2017年5月10日
 * @author  贺国栋
 * @since   1.0.0
 */
public interface IEarcSeddRedService {

	
	/**
	 * 
	 * TODO: 保存调阅业务信息
	 * @param esrEntity
	 */
	public void doSaveSeddRedInfo(EarcSeddRedEntity esrEntity);
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
	 * 分页查询选择档案列表
	 * 
	 * @param pageNum
	 * @param pageSize
	 *            查询条件
	 * @return
	 */
	public PageResult<EarcSeddRedBean> pageEarcSeddRedBeanList(int pageNum,
			int pageSize);

}
