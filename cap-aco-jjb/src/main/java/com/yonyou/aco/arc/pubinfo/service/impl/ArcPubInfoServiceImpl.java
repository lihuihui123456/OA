//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcPubInfoServiceImpl-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.pubinfo.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.aco.arc.pubinfo.dao.IArcPubInfoDao;
import com.yonyou.aco.arc.pubinfo.entity.ArcPubInfoBean;
import com.yonyou.aco.arc.pubinfo.entity.ArcPubInfoListBean;
import com.yonyou.aco.arc.pubinfo.service.IArcPubInfoService;
import com.yonyou.cap.common.util.PageResult;
/**
 * 
 * <p>
 * 概述：业务模块其它档案管理功能接口实现类
 * <p>
 * 功能：其它档案功能实现类
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-1-7
 * <p>
 * 类调用特殊情况：无
 */
@Service("pubInfoService")
public class ArcPubInfoServiceImpl implements IArcPubInfoService {
	@Resource
	IArcPubInfoDao pubInfoDao;
	@Override
	public void addArcPubInfo(ArcPubInfoEntity arcPubInfoEntity) {
		pubInfoDao.save(arcPubInfoEntity);
	}

	@Override
	public void deleteArcPubInfo(String id) {
		pubInfoDao.delete(ArcPubInfoEntity.class, id);
	}

	@Override
	public void updateArcPubInfo(ArcPubInfoEntity arcPubInfoEntity) {
		pubInfoDao.update(arcPubInfoEntity);
	}

	@Override
	public ArcPubInfoEntity selectArcPubInfoEntityById(String id) {
		return pubInfoDao.findEntityByPK(ArcPubInfoEntity.class, id);
	}

	@Override
	public PageResult<ArcPubInfoListBean> pageArcPubInfoEntityList(int pageNum,
			int pageSize, ArcPubInfoBean arcPubInfoBean) {
		return pubInfoDao.pageArcPubInfoEntityList(pageNum, pageSize, arcPubInfoBean);
	}
	public ArcPubInfoListBean  getArcPubInfoBeanByArcId(String arcId){
		return pubInfoDao.getArcPubInfoBeanByArcId(arcId);
	}
}
