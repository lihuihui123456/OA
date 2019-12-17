package com.yonyou.aco.earc.ctlg.dao.impl;

import java.util.List;

import javax.persistence.Query;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.earc.ctlg.dao.IEarcCtlgDao;
import com.yonyou.aco.earc.ctlg.entity.EarcCtlgEntity;
import com.yonyou.aco.earc.ctlg.entity.EarcCtlgTreeBean;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * TODO: 档案目录管理数据实现类 TODO: 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2017年4月18日
 * @author 贺国栋
 * @since 1.0.0
 */
@Repository("earcCtlgDao")
public class EarcCtlgDaoImpl extends BaseDao implements IEarcCtlgDao {


	@SuppressWarnings("unchecked")
	@Override
	public List<EarcCtlgTreeBean> findCtlgInfoByUserId(String userId) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT ID_ Id,PARENT_ID pId,EARC_CTLG_NAME name FROM earc_ctlg_info"
				+ " WHERE (DATA_USER_ID=? OR ID_=?) AND DR='N'  ORDER BY ORDER_BY+0 ASC");
		Query query = em.createNativeQuery(sb.toString());
		query.setParameter(1, userId);
		query.setParameter(2, "0");
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(EarcCtlgTreeBean.class));
		return query.getResultList();
	}

	@SuppressWarnings("unchecked")
	@Override
	public String isCtlgParent(String Id) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT ID_ Id,PARENT_ID pId,EARC_CTLG_NAME name FROM earc_ctlg_info WHERE PARENT_ID=? AND DR='N' AND DATA_USER_ID=? ");
		Query query = em.createNativeQuery(sb.toString());
		query.setParameter(1, Id);
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		query.setParameter(2, user.getUserId());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(EarcCtlgTreeBean.class));
		List<EarcCtlgTreeBean> list = query.getResultList();
		if(list!=null && list.size()>0){
			return "1";
		}else{
			return "0";
		}
	}

	@Override
	public String doDelCtlgDataById(String id) {
		if(StringUtils.isNotBlank(id)){
			String sql = "UPDATE earc_ctlg_info SET DR='Y' WHERE ID_='"+id+"'";
			Query query = em.createNativeQuery(sql);
			query.executeUpdate();
			return "0";
		}else{
			return "1";
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public EarcCtlgEntity findCtlgInfoByCtlgId(String ctlgId) {
		EarcCtlgEntity acEntity;
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT ID_,EARC_CTLG_NAME,CREATE_USER_NAME,trim(CREATE_TIME) CREATE_TIME ,ORDER_BY,PARENT_ID FROM earc_ctlg_info "
				+ "WHERE ID_=? AND DATA_USER_ID=? ");
		Query query = em.createNativeQuery(sb.toString());
		query.setParameter(1,ctlgId);
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		query.setParameter(2, user.getUserId());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(EarcCtlgEntity.class));
		List<EarcCtlgEntity> list = query.getResultList();
		if(list!=null&&list.size()>0){
			acEntity=list.get(0);
		}else{
			acEntity = new EarcCtlgEntity();
		}
		return acEntity;
	}

	@Override
	public String getMaxOrderBy(EarcCtlgEntity acEntity) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT  CONCAT(max(order_by + 0),'') AS ORDER_BY FROM earc_ctlg_info WHERE DR='N'");
		Query query = em.createNativeQuery(sb.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(EarcCtlgEntity.class));
		return ((EarcCtlgEntity)query.getResultList().get(0)).getORDER_BY();
	}
}
