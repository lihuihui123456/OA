package com.yonyou.aco.earc.earcquery.dao.impl;

import java.util.List;

import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.earc.earcquery.dao.IEarcQueryDao;
import com.yonyou.aco.earc.earcquery.entity.EarcQueryBean;
import com.yonyou.cap.common.base.impl.BaseDao;


/**
 * 
 * TODO: 档案总库查询数据层实现类
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2017年5月3日
 * @author  贺国栋
 * @since   1.0.0
 */
@Repository("earcQueryDao")
public class EarcQueryDaoImpl extends BaseDao implements IEarcQueryDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<EarcQueryBean> findEarcDateAll(String sb) {

		Query query = em.createNativeQuery(sb.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(EarcQueryBean.class));
		return query.getResultList();
	}

	
}
