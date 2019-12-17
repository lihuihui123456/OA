package com.yonyou.aco.signature.dao.impl;

import java.util.List;

import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.signature.dao.ISignatureDao;
import com.yonyou.aco.signature.entity.BizSignatureBean;
import com.yonyou.aco.signature.entity.BizSignatureEntity;
import com.yonyou.cap.common.base.impl.BaseDao;

@Repository("signatureDao")
@SuppressWarnings("unchecked")
public class SignatureDaoImpl extends BaseDao implements ISignatureDao{

	@Override
	public BizSignatureEntity findSignature(String taskId, String filedName) {
		String sql = "SELECT * FROM BIZ_SIGNATURE S WHERE S.TASK_ID_ = ? AND S.FIELD_NAME_ = ?";
		Query query = em.createNativeQuery(sql , BizSignatureEntity.class)
			.setParameter(1, taskId).setParameter(2, filedName);
		List<BizSignatureEntity> list = query.getResultList();
		if(list != null && list.size() > 0){
			return list.get(0);
		}else{
			return null;
		}
	}

	@Override
	public List<BizSignatureBean> loadSignature(String bizId) {
		StringBuilder sb=new StringBuilder();
		sb.append("SELECT a.ID_ id_,a.BIZ_ID_ bizId_,a.FIELD_NAME_ fieldName_,a.FIELD_HEADER_ fieldHeader_,"
				+ "a.FIELD_VALUE_ fieldValue_,a.USER_ID_ userId_,a.DATE_TIME_ dateTime_,a.TASK_ID_ taskId_,"
				+ "a.PROC_INST_ID_ procInstId_,b.USER_NAME userName_ ");
		sb.append("from biz_signature a LEFT JOIN isc_user b on a.USER_ID_=b.USER_ID ");
		sb.append("where a.BIZ_ID_=?");
		Query query = em.createNativeQuery(sb.toString()).setParameter(1, bizId);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(BizSignatureBean.class));
		return query.getResultList();
	}

	@Override
	public List<BizSignatureBean> loadSignature(String bizId, String fieldName) {
		StringBuilder sb=new StringBuilder();
		sb.append("SELECT a.ID_ id_,a.BIZ_ID_ bizId_,a.FIELD_NAME_ fieldName_,a.FIELD_HEADER_ fieldHeader_,"
				+ "a.FIELD_VALUE_ fieldValue_,a.USER_ID_ userId_,a.DATE_TIME_ dateTime_,a.TASK_ID_ taskId_,"
				+ "a.PROC_INST_ID_ procInstId_,b.USER_NAME userName_ ");
		sb.append("from biz_signature a LEFT JOIN isc_user b on a.USER_ID_=b.USER_ID ");
		sb.append("where a.FIELD_NAME_ = ? and a.BIZ_ID_=?");
		Query query = em.createNativeQuery(sb.toString()).setParameter(1, fieldName).setParameter(2, bizId);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(BizSignatureBean.class));
		return query.getResultList();
	}

	@Override
	public List<BizSignatureBean> loadSignatureByTaskId(String taskId) {
		StringBuilder sb=new StringBuilder();
		sb.append("SELECT a.ID_ id_,a.BIZ_ID_ bizId_,a.FIELD_NAME_ fieldName_,a.FIELD_HEADER_ fieldHeader_,"
				+ "a.FIELD_VALUE_ fieldValue_,a.USER_ID_ userId_,a.DATE_TIME_ dateTime_,a.TASK_ID_ taskId_,"
				+ "a.PROC_INST_ID_ procInstId_,b.USER_NAME userName_ ");
		sb.append("from biz_signature a LEFT JOIN isc_user b on a.USER_ID_=b.USER_ID ");
		sb.append("where a.TASK_ID_=?");
		Query query = em.createNativeQuery(sb.toString()).setParameter(1, taskId);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(BizSignatureBean.class));
		return query.getResultList();
	}

	@Override
	public List<BizSignatureBean> loadSignatureByTaskIdAndFildName(
			String taskId, String fieldName) {
		StringBuilder sb=new StringBuilder();
		sb.append("SELECT a.ID_ id_,a.BIZ_ID_ bizId_,a.FIELD_NAME_ fieldName_,a.FIELD_HEADER_ fieldHeader_,"
				+ "a.FIELD_VALUE_ fieldValue_,a.USER_ID_ userId_,a.DATE_TIME_ dateTime_,a.TASK_ID_ taskId_,"
				+ "a.PROC_INST_ID_ procInstId_,b.USER_NAME userName_ ");
		sb.append("from biz_signature a LEFT JOIN isc_user b on a.USER_ID_=b.USER_ID ");
		sb.append("where a.FIELD_NAME_ = ? and a.TASK_ID_=?");
		Query query = em.createNativeQuery(sb.toString()).setParameter(1, fieldName).setParameter(2, taskId);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(BizSignatureBean.class));
		return query.getResultList();
	}
}
 


