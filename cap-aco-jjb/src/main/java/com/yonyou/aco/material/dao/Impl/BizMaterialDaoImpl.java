package com.yonyou.aco.material.dao.Impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;

import org.springframework.stereotype.Service;

import com.yonyou.aco.material.dao.IBizMaterialDao;
import com.yonyou.aco.material.entity.BizMaterialEntity;
import com.yonyou.aco.material.entity.BizMaterialStockEntity;
import com.yonyou.cap.common.base.impl.BaseDao;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service("ibmDao")
public class BizMaterialDaoImpl extends BaseDao implements IBizMaterialDao {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource
	EntityManagerFactory emf;
	
	
	/**
	 * 
	 * @see com.yonyou.aco.material.dao.IBizMaterialDao#getCount()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public String findCount() {
		String count;
		String sql = "SELECT MAX(SORT_) AS SORT FROM BIZ_MATERIAL_INFO ";
		Query query = em.createNativeQuery(sql);
		List<String> list  = query.getResultList();
		if(list.get(0) == null){
			count= "0";
		}else{
			count = list.get(0);
		}
		return count;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<BizMaterialEntity> findMaterialByIds(String[] ids) {
		List<BizMaterialEntity> list = new ArrayList<BizMaterialEntity>();
		StringBuilder sql = new StringBuilder();
		if (ids != null) {
			sql.append("SELECT o FROM biz_material_info o WHERE ");
			for (int i = 0; i < ids.length; i++) {
				if (i == ids.length - 1) {
					sql.append("id_ = '" + ids[i] + "' ");
				} else {
					sql.append("id_ = '" + ids[i] + "' or ");
				}
			}
			Query query = em.createQuery(sql.toString());
			list = query.getResultList();
		}
		return list;
	}

	@Override
	public void doSaveMaterialAndStock(BizMaterialEntity bmEntity,
			BizMaterialStockEntity bmsEntity) {
		EntityManager em = emf.createEntityManager();
		em.getTransaction().begin();// 开始事务
		try {
			em.persist(bmEntity);//保存物品信息
			bmsEntity.setMaterialId_(bmEntity.getId());
			em.persist(bmsEntity);//保存库存信息
			em.getTransaction().commit();// 提交事务
		} catch (Exception e) {
			logger.error("error",e);
		} finally{
			em.close();// 关闭事务
		}
	}

	@Override
	public void doDelMaterialAndStock(String ids) {
		StringBuilder sb = new StringBuilder("'");
		String whereId ="";
		if(ids.contains(",")){
			String [] idarr  = ids.split(",");
			for (int i = 0; i < idarr.length; i++) {
				sb.append(idarr[i]+"','");
				
			}
			whereId = sb.toString().substring(0,sb.toString().length()-2);
		}else{
			whereId="'"+ids+"'";
		}
		EntityManager em = emf.createEntityManager();
		em.getTransaction().begin();// 开始事务
		try {
			String delMaterialSql = "UPDATE biz_material_info SET is_remove_ ='0' WHERE id_ IN (" + whereId + ") ";
			String delStockSql = "UPDATE biz_material_stock SET is_remove_ ='0' WHERE material_id_ IN ("+ whereId + ") ";
			Query query = em.createNativeQuery(delMaterialSql);
			query.executeUpdate();
			Query query1 = em.createNativeQuery(delStockSql);
			query1.executeUpdate();
			em.getTransaction().commit();// 提交事务
		} catch (Exception e) {
			logger.error("error",e);
		} finally{
			em.close();// 关闭事务
		}
		
	}

}
