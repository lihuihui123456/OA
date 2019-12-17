//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// IArcMtgSummService-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.mtgsumm.service;
import com.yonyou.aco.arc.mtgsumm.entity.ArcMtgSummAll;
import com.yonyou.aco.arc.mtgsumm.entity.ArcMtgSummBean;
import com.yonyou.aco.arc.mtgsumm.entity.ArcMtgSummEntity;
import com.yonyou.cap.common.util.PageResult;
/**
 * 
 * <p>
 * 概述：业务模块会议纪要管理功能接口
 * <p>
 * 功能：会议纪要功能接口
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-12-21
 * <p>
 * 类调用特殊情况：无
 */
public interface IArcMtgSummService {
	/**
	 * 通过id查询
	 * 
	 * @param id
	 * @return
	 */
	public ArcMtgSummEntity selectArcMtgSummEntityById(String id);

	/**
	 * 分页查询
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcMtgSummEntity
	 *            查询条件
	 * @return
	 */
	public PageResult<ArcMtgSummBean> pageArcMtgSummEntityList(int pageNum,
			int pageSize, ArcMtgSummAll arcMtgSummAll);

	/**
	 * 添加会议纪要实体
	 * 
	 * @param arcPubInfoEntity
	 */
	public void addArcMtgSumm(ArcMtgSummEntity arcMtgSummEntity);

	/**
	 * 通过id删除会议纪要实体
	 * 
	 * @param id
	 */
	public void deleteArcMtgSumm(String id);

	/**
	 * 修改会议纪要
	 * 
	 * @param arcMtgSummEntity
	 */
	public void updateArcMtgSumm(ArcMtgSummEntity arcMtgSummEntity);
}
