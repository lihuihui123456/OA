package com.yonyou.aco.earc.seddread.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yonyou.aco.earc.seddread.dao.IEarcSeddRedDao;
import com.yonyou.aco.earc.seddread.entity.EarcSeddRedBean;
import com.yonyou.aco.earc.seddread.entity.EarcSeddRedEntity;
import com.yonyou.aco.earc.seddread.entity.EarcSeddRedListQuery;
import com.yonyou.aco.earc.seddread.service.IEarcSeddRedService;
import com.yonyou.cap.common.util.PageResult;

/**
 * 
 * TODO: 电子档案调阅服务层 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2017年5月10日
 * @author 贺国栋
 * @since 1.0.0
 */
@Service("earcSeddRedService")
public class EarcSeddRedServiceImpl implements IEarcSeddRedService {

	@Resource
	IEarcSeddRedDao earcSeddRedDao;

	@Override
	public void doSaveSeddRedInfo(EarcSeddRedEntity esrEntity) {
		earcSeddRedDao.update(esrEntity);

	}

	@Override
	public PageResult<EarcSeddRedBean> pageEarcSeddRedBeanList(int pageNum,
			int pageSize, EarcSeddRedListQuery earcSeddRedListQuery) {
		return earcSeddRedDao.pageEarcSeddRedBeanList(pageNum, pageSize, earcSeddRedListQuery);
	}
	@Override
	public PageResult<EarcSeddRedBean> pageEarcSeddRedBeanList(int pageNum,
			int pageSize) {
		return earcSeddRedDao.pageEarcSeddRedBeanList(pageNum, pageSize);
	}

}
