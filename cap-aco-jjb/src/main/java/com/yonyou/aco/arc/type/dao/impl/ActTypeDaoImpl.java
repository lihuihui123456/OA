package com.yonyou.aco.arc.type.dao.impl;

import java.util.List;

import javax.annotation.Resource;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.type.dao.IActTypeDao;
import com.yonyou.aco.arc.type.entity.ArcTypeBean;
import com.yonyou.aco.arc.type.entity.ArcTypeEntity;
import com.yonyou.cap.common.base.impl.BaseDao;

@Repository("actTypeDao")
public class ActTypeDaoImpl extends BaseDao implements IActTypeDao {

	@Resource
	EntityManagerFactory emf;

	@SuppressWarnings("unchecked")
	@Override
	public List<ArcTypeEntity> findArcTypeInfo() {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * FROM biz_arc_type_info");
		sb.append(" WHERE DR='N'");
		sb.append(" ORDER BY ORDER_BY ASC");
		Query query = em.createNativeQuery(sb.toString(), ArcTypeEntity.class);
		return query.getResultList();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ArcTypeBean> findArcTypeInfoById(String id) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT a.ID Id,a.TYPE_NAME typeName,"
				+ "trim(a.ARC_TYPE) arcType,a.CRE_TIME createTime,a.REMARK remark,"
				+ "trim(a.IS_PRNT) isPrnt,a.PRNT_ID as prntId,a.ORDER_BY as orderBy,a.HREF href "
				+ "FROM biz_arc_type_info a ");
		sb.append(" WHERE a.DR='N'");
		sb.append(" AND a.ID='"+id+"'");
		Query query = em.createNativeQuery(sb.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcTypeBean.class));
		return query.getResultList();
	}

	@Override
	public void doDelArcTypeById(String id) {
		StringBuffer sb = new StringBuffer();
		sb.append("UPDATE biz_arc_type_info SET DR='Y' WHERE ID=?");
		Query query = this.em.createNativeQuery(sb.toString());
		query.setParameter(1, id);
		query.executeUpdate();
		
	}

	@Override
	public String selectMaxOrderBy() {
		String sql="select MAX(ati.ORDER_BY) from biz_arc_type_info ati";
		Query query = em.createNativeQuery(sql);
		String result=query.getSingleResult().toString();
		return result;
	}

	@Override
	public String validate(String id) {
		StringBuffer sb = new StringBuffer();
		sb.append( "select a.FILE_TYPE from biz_arc_pub_info a ");
		sb.append("left join biz_arc_type_info b on a.FILE_TYPE = b.ID ");
		sb.append("where b.DR='N' and a.DR='N' and b.ID = ?");
		Query query = em.createNativeQuery(sb.toString());
		query.setParameter(1, id);
		String flag = "";
		@SuppressWarnings("unchecked")
		List<String> list = query.getResultList();
		if(list != null && list.size()>0){
			flag = "N";
		}else{
			flag = "Y";
		}
		return flag;
	}
}
