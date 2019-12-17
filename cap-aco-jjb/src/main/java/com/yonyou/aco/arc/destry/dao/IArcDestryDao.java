//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// IArcDestryDao-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.destry.dao;
import com.yonyou.aco.arc.destry.entity.ArcDestryAll;
import com.yonyou.aco.arc.destry.entity.ArcDestryBean;
import com.yonyou.aco.arc.destry.entity.ArcDestryEntity;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
/**
 * <p>概述：持久模块销毁管理管理 dao实现类
 * <p>功能：实现对销毁管理管理业务数据处理实现类
 * <p>作者：lzh
 * <p>创建时间：2016-12-28
 * <p>类调用特殊情况：无
 */
public interface IArcDestryDao extends IBaseDao {
	/**
	 * 分页查询
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcDestryEntity
	 *            查询条件
	 * @return
	 */
	public PageResult<ArcDestryEntity> pageArcDestryEntityList(int pageNum,
			int pageSize, ArcDestryAll arcDestryAll,ShiroUser user);
	/**
	 * 分页查询排序
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcDestryBean
	 *            查询条件
	 * @return
	 */
	public PageResult<ArcDestryBean> pageArcDestryBeanList(int pageNum,
			int pageSize, ArcDestryAll arcDestryAll,ShiroUser user);
}
