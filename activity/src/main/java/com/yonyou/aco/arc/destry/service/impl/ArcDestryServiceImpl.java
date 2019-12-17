//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcDestryServiceImpl-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.destry.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yonyou.aco.arc.destry.service.IArcDestryService;
import com.yonyou.aco.arc.destry.dao.IArcDestryDao;
import com.yonyou.aco.arc.destry.entity.ArcDestryAll;
import com.yonyou.aco.arc.destry.entity.ArcDestryBean;
import com.yonyou.aco.arc.destry.entity.ArcDestryEntity;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
/**
 * 
 * <p>
 * 概述：业务模块销毁管理管理功能接口实现类
 * <p>
 * 功能：销毁管理功能实现类
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-12-28
 * <p>
 * 类调用特殊情况：无
 */
@Service("arcDestryService")
public class ArcDestryServiceImpl implements IArcDestryService {
	@Resource
	IArcDestryDao arcDestryDao;
	@Override
	public void addArcDestry(ArcDestryEntity arcDestryEntity) {
		arcDestryDao.save(arcDestryEntity);
	}

	@Override
	public void deleteArcDestry(String id) {
		arcDestryDao.delete(ArcDestryEntity.class, id);
	}

	@Override
	public void updateArcDestry(ArcDestryEntity arcDestryEntity) {
		arcDestryDao.update(arcDestryEntity);
	}

	@Override
	public ArcDestryEntity selectArcDestryEntityById(String id) {
		return arcDestryDao.findEntityByPK(ArcDestryEntity.class, id);
	}

	@Override
	public PageResult<ArcDestryEntity> pageArcDestryEntityList(int pageNum,
			int pageSize, ArcDestryAll arcDestryAll,ShiroUser user) {
		return arcDestryDao.pageArcDestryEntityList(pageNum, pageSize, arcDestryAll,user);
	}

	@Override
	public PageResult<ArcDestryBean> pageArcDestryBeanList(int pageNum,
			int pageSize, ArcDestryAll arcDestryAll, ShiroUser user) {
		return arcDestryDao.pageArcDestryBeanList(pageNum, pageSize, arcDestryAll,user);

	}

}
