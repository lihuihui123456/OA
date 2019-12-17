package com.yonyou.aco.biz.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yonyou.aco.biz.dao.IBizRunDao;
import com.yonyou.aco.biz.entity.BizNodeFormBean;
import com.yonyou.aco.biz.service.IBizRunService;
import com.yonyou.cap.bpm.entity.BpmReSolInfoEntity;

@Service("bizRunService")
public class BizRunService implements IBizRunService {
	
	@Resource
	IBizRunDao BizRunDao;

	@Override
	public BpmReSolInfoEntity getBpmReSolInfoEntity(String id) {
		// TODO Auto-generated method stub
		return BizRunDao.findEntityByPK(BpmReSolInfoEntity.class, id);
	}

	@Override
	public List<BizNodeFormBean> findNodeFormInfo(String solId, String scope) {
		// TODO Auto-generated method stub
		return BizRunDao.findNodeFormInfo(solId, scope);
	}

	@Override
	public List<BizNodeFormBean> findNodeFormInfo(String solId) {
		// TODO Auto-generated method stub
		return BizRunDao.findNodeFormInfo(solId);
	}

	@Override
	public List<BizNodeFormBean> findNodeFormInfoList(String bizCode) {
		return BizRunDao.findNodeFormInfoList(bizCode);
	}

}
