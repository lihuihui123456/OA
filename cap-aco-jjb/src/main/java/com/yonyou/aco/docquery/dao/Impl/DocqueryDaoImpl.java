package com.yonyou.aco.docquery.dao.Impl;

import java.util.List;

import javax.annotation.Resource;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Component;

import com.yonyou.aco.docquery.dao.IDocqueryDao;
import com.yonyou.aco.docquery.entity.SearchEntity;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
@Component("docqueryDao")
public class DocqueryDaoImpl extends BaseDao implements IDocqueryDao{
	@Resource
	EntityManagerFactory emf;
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
/*	*//**
	 * TODO： 联合分页查询
	 * 
	 * @param entityClass
	 *            根据需要建立的不需要和数据库对应的实体类
	 * @param pageNum
	 *            当前页数
	 * @param pageSize
	 *            每页条目数
	 * @param sql
	 *            查询语句
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public <T> PageResult<T> getPageData(Class<T> entityClass, int pageNum,
			int pageSize, String sql) {
	/*	String sql1 = "SELECT aa.BIZ_TITLE_ bizTitle, aa.BIZ_TYPE_ bizType,aa.CREATE_TIME_ createTime,aa.URGENCY_ urgency, aa.CREATE_DEPT_ID_ createDeptId,aa.SERIAL_NUMBER_ serialNumber, bb.USER_NAME userName, bb.DEPT_NAME deptName,"
	+"aa.STATE_ state FROM BPM_RU_BIZ_INFO aa LEFT JOIN ISC_USER bb ON aa.CREATE_USER_ID_ = bb.USER_ID WHERE 1 = 1 ORDER BY aa.CREATE_TIME_ DESC";*/
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<T> pr = new PageResult<T>();
		Query query = em.createNativeQuery(sql);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(entityClass));
		long size = query.getResultList().size();// 总数据长度
		
		//** 通过传过来的页码*每页显示条数和总数进行对比 判断第一条数据的取值 **//*
		if (firstindex >= size) {
			if (size > pageSize) {
				query.setFirstResult(((int) size / pageSize - 1) * pageSize).setMaxResults(maxresult);
			} else {
				query.setFirstResult(0).setMaxResults(maxresult);
			}
		} else {
			query.setFirstResult(firstindex).setMaxResults(maxresult);
		}

		List<T> list = query.getResultList();
		pr.setResults(list);
		pr.setTotalrecord(size);
		return pr;
	}

	@Override
	public boolean updateSignTime(String bizId,String date) {
		try {
			String sql = "UPDATE BPM_RU_BIZ_INFO SET SIGN_TIME_ = ? WHERE ID_ = ?";
			Query query = em.createNativeQuery(sql).setParameter(1, date).setParameter(2, bizId);
			query.executeUpdate();
			return true;
		} catch (Exception e) {
			logger.error("error",e);
			return false;
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<SearchEntity> getExcel_fw(Class<SearchEntity> entityClass, String sql) {
		Query query = em.createNativeQuery(sql);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(entityClass));
		return query.getResultList();
	}
}
