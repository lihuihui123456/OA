//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcMgtSummServiceImpl-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.mtgsumm.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yonyou.aco.arc.mtgsumm.dao.IArcMgtSummDao;
import com.yonyou.aco.arc.mtgsumm.entity.ArcMtgSummAll;
import com.yonyou.aco.arc.mtgsumm.entity.ArcMtgSummBean;
import com.yonyou.aco.arc.mtgsumm.entity.ArcMtgSummEntity;
import com.yonyou.aco.arc.mtgsumm.service.IArcMtgSummService;
import com.yonyou.cap.common.util.PageResult;
/**
 * 
 * <p>
 * 概述：业务模块会议纪要管理功能接口实现类
 * <p>
 * 功能：会议纪要功能实现类
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-12-21
 * <p>
 * 类调用特殊情况：无
 */
@Service("arcMgtSummService")
public class ArcMgtSummServiceImpl implements IArcMtgSummService {
	@Resource
	IArcMgtSummDao arcMgtSummDao;
	@Override
	public void addArcMtgSumm(ArcMtgSummEntity arcMtgSummEntity) {
		arcMgtSummDao.save(arcMtgSummEntity);
	}

	@Override
	public void deleteArcMtgSumm(String id) {
		arcMgtSummDao.delete(ArcMtgSummEntity.class, id);
	}

	@Override
	public void updateArcMtgSumm(ArcMtgSummEntity arcMtgSummEntity) {
		arcMgtSummDao.update(arcMtgSummEntity);
	}

	@Override
	public ArcMtgSummEntity selectArcMtgSummEntityById(String id) {
		return arcMgtSummDao.findEntityByPK(ArcMtgSummEntity.class, id);
	}

	@Override
	public PageResult<ArcMtgSummBean> pageArcMtgSummEntityList(int pageNum,
			int pageSize, ArcMtgSummAll arcMtgSummAll) {
		return arcMgtSummDao.pageArcMtgSummEntityList(pageNum, pageSize, arcMtgSummAll);
	}

}
