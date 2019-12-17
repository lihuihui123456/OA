package com.yonyou.aco.biz.dao.impl;

import java.util.List;

import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.biz.dao.IBizRunDao;
import com.yonyou.aco.biz.entity.BizNodeFormBean;
import com.yonyou.cap.common.base.impl.BaseDao;

@Repository("bizRunDao")
public class BizRunDao extends BaseDao implements IBizRunDao {
	
	@SuppressWarnings("unchecked")
	@Override
	public List<BizNodeFormBean> findNodeFormInfo(String solId, String scope) {
		// TODO Auto-generated method stub
		List<BizNodeFormBean> list = null;
		try {
			StringBuilder sb = new StringBuilder();
			sb.append(" select s.ID_ solId,n.PROC_DEF_ID_ procdefId,s.is_process_ isProcess_,n.SCOPE_ scope_,n.MAIN_BODY_ isMainBody,n.ATTACHMENT_ isAttachment,");
			sb.append(" f.FORM_NAME_ formName,f.FORM_URL_ formUrl,f.table_name_ tableName,s.BIZ_CODE_ bizCode");
			sb.append(" from bpm_re_sol_info s,bpm_re_form_node n,bpm_re_form f");
			sb.append(" where s.ID_=n.SOL_ID_ and n.FORM_ID_=f.ID_");
			sb.append(" and s.ID_= ? and n.SCOPE_ = ?");
			Query query = em.createNativeQuery(sb.toString())
							.setParameter(1, solId)
							.setParameter(2, scope);
			query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BizNodeFormBean.class));
			list = query.getResultList();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<BizNodeFormBean> findNodeFormInfo(String solId) {
		List<BizNodeFormBean> list = null;
		try {
			StringBuilder sb = new StringBuilder();
			sb.append(" select s.ID_ solId,s.is_process_ isProcess_,s.BIZ_CODE_ bizCode,s.PROC_DEF_ID_ procdefId,n.SCOPE_ scope_,n.MAIN_BODY_ isMainBody,n.ATTACHMENT_ isAttachment,n.earc isEarc,");
			sb.append(" f.FREE_FORM_ID_ formid,f.FORM_NAME_ formName,f.TABLE_NAME_ tableName,f.FORM_URL_ formUrl,s.SFW_DICT_CODE_  sfwDictCode_");
			sb.append(" from bpm_re_sol_info s,bpm_re_form_node n,bpm_re_form f");
			sb.append(" where s.ID_=n.SOL_ID_ and n.FORM_ID_=f.ID_");
			sb.append(" and s.ID_= ?");
			Query query = em.createNativeQuery(sb.toString()).setParameter(1, solId);
			query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BizNodeFormBean.class));
			list = query.getResultList();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<BizNodeFormBean> findNodeFormInfoList(String bizCode) {
		List<BizNodeFormBean> list = null;
		try {
			StringBuilder sb = new StringBuilder();
			sb.append(" select s.ID_ solId,s.BIZ_CODE_ bizCode,brsc.SOL_CTLG_NAME_ formName ");
			sb.append(" from bpm_re_sol_ctlg  brsc left join  bpm_re_sol_info s on brsc.code = s.biz_code_ left join isc_module  im on s.ID_= im.SOL_ID_");
			sb.append(" where im.IS_SEAL ='N' and im.IS_BPM_DEPLOY ='Y' and im.dr='N' and   brsc.code like '"+bizCode+"1%'");
			Query query = em.createNativeQuery(sb.toString());
			query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BizNodeFormBean.class));
			list = query.getResultList();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

}