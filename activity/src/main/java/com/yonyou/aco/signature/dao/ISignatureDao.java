package com.yonyou.aco.signature.dao;

import java.util.List;

import com.yonyou.aco.signature.entity.BizSignatureBean;
import com.yonyou.aco.signature.entity.BizSignatureEntity;
import com.yonyou.cap.common.base.IBaseDao;

public interface ISignatureDao extends IBaseDao{

	public BizSignatureEntity findSignature(String taskId, String filedName);
	
	public List<BizSignatureBean> loadSignature(String bizId);

	public List<BizSignatureBean> loadSignature(String bizId, String fieldName);

	public List<BizSignatureBean> loadSignatureByTaskId(String taskId);

	public List<BizSignatureBean> loadSignatureByTaskIdAndFildName(
			String taskId, String fieldName);

}
