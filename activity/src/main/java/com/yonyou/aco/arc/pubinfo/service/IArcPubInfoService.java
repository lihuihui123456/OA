//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// IArcPubInfoService-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.pubinfo.service;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.aco.arc.pubinfo.entity.ArcPubInfoBean;
import com.yonyou.aco.arc.pubinfo.entity.ArcPubInfoListBean;
import com.yonyou.cap.common.util.PageResult;
/**
 * 
 * <p>
 * 概述：业务模块其它档案管理功能接口
 * <p>
 * 功能：其它档案功能接口
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-1-7
 * <p>
 * 类调用特殊情况：无
 */
public interface IArcPubInfoService {
	/**
	 * 通过id查询
	 * 
	 * @param id
	 * @return
	 */
	public ArcPubInfoEntity selectArcPubInfoEntityById(String id);

	/**
	 * 分页查询
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcPubInfoEntity
	 *            查询条件
	 * @return
	 */
	public PageResult<ArcPubInfoListBean> pageArcPubInfoEntityList(int pageNum,
			int pageSize, ArcPubInfoBean arcPubInfoBean);

	/**
	 * 添加其它档案实体
	 * 
	 * @param arcPubInfoEntity
	 */
	public void addArcPubInfo(ArcPubInfoEntity arcPubInfoEntity);

	/**
	 * 通过id删除其它档案实体
	 * 
	 * @param id
	 */
	public void deleteArcPubInfo(String id);

	/**
	 * 修改其它档案
	 * 
	 * @param arcPubInfoEntity
	 */
	public void updateArcPubInfo(ArcPubInfoEntity arcPubInfoEntity);
	/**
	 * 通过arcid查询ArcPubInfoBean
	 * @param arcId
	 * @return
	 */
	public ArcPubInfoListBean  getArcPubInfoBeanByArcId(String arcId);
}
