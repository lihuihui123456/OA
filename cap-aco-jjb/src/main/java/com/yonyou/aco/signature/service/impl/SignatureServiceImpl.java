package com.yonyou.aco.signature.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import com.yonyou.aco.signature.dao.ISignatureDao;
import com.yonyou.aco.signature.entity.BizSignatureBean;
import com.yonyou.aco.signature.entity.BizSignatureEntity;
import com.yonyou.aco.signature.service.ISignatureService;

@Repository("signatureService")
public class SignatureServiceImpl implements ISignatureService{

	@Resource
	ISignatureDao signatureDao;

	@Override
	public String doSaveSignature(BizSignatureEntity entity) {
		signatureDao.update(entity);
		return entity.getId();
	}

	@Override
	public BizSignatureEntity findSignature(String id) {
		return signatureDao.findEntityByPK(BizSignatureEntity.class, id);
	}
	
	@Override
	public BizSignatureEntity findSignature(String taskId, String filedName) {
		return signatureDao.findSignature(taskId,filedName);
	}

	@Override
	public List<BizSignatureBean> loadSignature(String bizId) {
		return signatureDao.loadSignature(bizId);
	}

	@Override
	public List<BizSignatureBean> loadSignature(String bizId, String fieldName) {
		return signatureDao.loadSignature(bizId, fieldName);
	}

	@Override
	public List<BizSignatureBean> loadSignatureByTaskId(String taskId) {
		return signatureDao.loadSignatureByTaskId(taskId);
	}

	@Override
	public List<BizSignatureBean> loadSignatureByTaskIdAndFildName(
			String taskId, String fieldName) {
		return signatureDao.loadSignatureByTaskIdAndFildName(taskId, fieldName);
	}

}
 


