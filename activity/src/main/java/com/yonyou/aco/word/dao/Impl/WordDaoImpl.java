package com.yonyou.aco.word.dao.Impl;

import java.util.List;
import java.util.Map;

import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.word.dao.IWordDao;
import com.yonyou.aco.word.entity.ActHiCommentWordBean;
import com.yonyou.aco.word.entity.ExportWordBean;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.form.entity.FormTable;

/**
 * 
 * ClassName: WordDaoImpl
 * 
 * @Description: 业务表单Word操作Dao实现类
 * @author hegd
 * @date 2016-8-24
 */

@Repository(value = "wordDao")
public class WordDaoImpl extends BaseDao implements IWordDao {

	@Override
	@SuppressWarnings("unchecked")
	public ExportWordBean getWordInfor(String bizId) {
		String sql = "SELECT W.TITLE_ AS bizTitle,i.PROC_INST_ID_ as procInstId,I.URGENCY_ AS ungency,"
				+ "W.SECURITY_LEVEL_ AS securityLevel,W.MAIN_SEND_ AS mainSend,W.DRAFT_DEPT_ID_NAME_ AS "
				+ "draftDeptIdName,W.DRAFT_TIME_ AS draftTime,W.DRAFT_USER_ID_NAME_ AS draftUserIdName,"
				+ "W.CHECK_USER_ID_NAME_ AS checkUserIdName,I.SERIAL_NUMBER_ AS serialNumber,'' AS idea "
				+ "FROM BPM_RU_BIZ_INFO I INNER JOIN BIZ_DU_WJBPD W ON I.ID_ = W.BIZ_ID_   WHERE W.BIZ_ID_ =?";
		Query query = em.createNativeQuery(sql);
		query.setParameter(1, bizId);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ExportWordBean.class));
		List<ExportWordBean> list = query.getResultList();
		return list.get(0);
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<ActHiCommentWordBean> getCommentMessage(String procInstId) {
		String sql = "SELECT I.USER_NAME AS userName,C.TIME_ AS time ,C.MESSAGE_ AS message"
				+ " FROM ACT_HI_COMMENT C INNER JOIN ISC_USER I ON I.USER_ID = C.USER_ID_ "
				+ "WHERE C.PROC_INST_ID_ = ?";
		Query query = em.createNativeQuery(sql);
		query.setParameter(1, procInstId);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ActHiCommentWordBean.class));
		return query.getResultList();
	}
	@SuppressWarnings("unchecked")
	@Override
	public FormTable getFormTable(String formId) {
		String sql="SELECT A.* FROM FORM_DB_TABLE A INNER JOIN FORM_DESIGN B ON A.TABLE_ID=B.FORM_URL WHERE B.FORM_ID=?";
		Query query = em.createNativeQuery(sql,FormTable.class);
		query.setParameter(1, formId);
		List<FormTable> list=query.getResultList();
		if(list.size()>0){
			return list.get(0);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String,String>> getDicColumns(String formId) {
		// TODO Auto-generated method stub
		try {
			StringBuffer sb = new StringBuffer();
			sb.append("SELECT trim(C.COL_CODE)  COLCODE,trim(C.DIC_TYPE) DICTYPE FROM FORM_DESIGN D,FORM_DB_COLUMN C WHERE "
					+ "D.FORM_URL=C.TABLE_ID AND CTR_TYPE='SYS_DIC' AND D.FORM_ID= ?");
			Query query = em.createNativeQuery(sb.toString());
			query.setParameter(1,formId);
			query.unwrap(SQLQuery.class).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
			return query.getResultList();
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return null;
		}
	}
}
