//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// IArcPubInfoDao-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.pubinfo.dao;

import com.yonyou.aco.arc.pubinfo.entity.ArcPubInfoBean;
import com.yonyou.aco.arc.pubinfo.entity.ArcPubInfoListBean;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;
/**
 * <p>
 * 概述：持久模块其它档案管理 dao接口
 * <p>
 * 功能：实现对其它档案管理业务数据处理接口
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-1-7
 * <p>
 * 类调用特殊情况：无
 */
public interface IArcPubInfoDao  extends IBaseDao{
	/**
	 * 分页查询
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcpubinfoEntity
	 *            查询条件
	 * @return
	 */
	public PageResult<ArcPubInfoListBean> pageArcPubInfoEntityList(int pageNum,
			int pageSize, ArcPubInfoBean arcPubInfoBean);
	/**
	 * 通过arcid查询ArcPubInfoListBean
	 * @param arcId
	 * @return
	 */
	public ArcPubInfoListBean  getArcPubInfoBeanByArcId(String arcId);
}
