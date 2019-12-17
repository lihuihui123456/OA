package com.yonyou.aco.signature.service;

import java.util.List;

import com.yonyou.aco.signature.entity.BizSignatureBean;
import com.yonyou.aco.signature.entity.BizSignatureEntity;

public interface ISignatureService {

	public String doSaveSignature(BizSignatureEntity entity);

	public BizSignatureEntity findSignature(String id);

	public BizSignatureEntity findSignature(String taskId, String filedName);

	public List<BizSignatureBean> loadSignature(String bizId);

	public List<BizSignatureBean> loadSignature(String bizId, String fieldName);
	
	public List<BizSignatureBean> loadSignatureByTaskId(String taskId);

	public List<BizSignatureBean> loadSignatureByTaskIdAndFildName(String taskId, String fieldName);


}
