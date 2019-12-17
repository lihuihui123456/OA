package com.yonyou.aco.material.dao.Impl;

import java.util.List;

import javax.annotation.Resource;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;

import org.apache.commons.lang.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Service;

import com.yonyou.aco.material.dao.IBizMaterialStockDao;
import com.yonyou.aco.material.entity.BizMaterialApplyQuery;
import com.yonyou.aco.material.entity.BizMaterialBean;
import com.yonyou.aco.material.entity.BizMaterialListBean;
import com.yonyou.aco.material.entity.BizMaterialStockBean;
import com.yonyou.aco.material.entity.BizMaterialStockDetailEntity;
import com.yonyou.aco.material.entity.BizMaterialStockDetailListEntity;
import com.yonyou.aco.material.entity.BizMaterialStockDetailQuery;
import com.yonyou.aco.material.entity.BizMaterialStockEntity;
import com.yonyou.aco.material.entity.BizMaterialStockQuery;
import com.yonyou.aco.material.entity.BizMaterialStorageEntity;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service("ibsDao")
public class BizMaterialStockDaoImpl extends BaseDao implements
		IBizMaterialStockDao {

	@Resource
	EntityManagerFactory emf;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Override
	public PageResult<BizMaterialStockBean> findAllStock(int pageNum,
			int pageSize, String mode) {
		/*String sql = "SELECT g.*, s.amount_ from biz_material_stock s "
				+ "LEFT JOIN biz_material_info g ON g.id_ = s.material_id_  "
				+ "WHERE g.status_ = '1' AND g.is_remove_ = '1'";
		// getAll 表示获取所有启用物品的库存信息 ， 不为getAll表示查询库存数量小于库存下限的物品库存信息
		if ("getAll".equals(mode)) {
			sql = sql + " ORDER BY g.indate_ desc";
		} else {
			sql = "SELECT a.* FROM (" + sql + ") a "
					+ "WHERE a.amount_ <= a.inventory_floor_ "
					+ "ORDER BY a.indate_ DESC";
		}*/
		String sql = "SELECT G.ID_ id_, G.M_NAME_ m_name_, G.M_NUMBER_ m_number_, G.STANDARD_ standard_, G.SUPPLIER_ supplier_, "
				+ "G.UNIT_ unit_, G.INVENTORY_FLOOR_ inventory_floor_, G.STATUS_ status_, G.INDATE_ indate_, G.REMARK_ remark_, "
				+ "G.SORT_ sort_, G.IS_REMOVE_ is_remove_, S.AMOUNT_ amount_ FROM BIZ_MATERIAL_STOCK S "
				+ "LEFT JOIN BIZ_MATERIAL_INFO G ON G.ID_ = S.MATERIAL_ID_ WHERE G.STATUS_ = '1' AND G.IS_REMOVE_ = '1'";
		// getAll 表示获取所有启用物品的库存信息 ， 不为getAll表示查询库存数量小于库存下限的物品库存信息
		if ("getAll".equals(mode)) {
			sql = sql + " ORDER BY G.indate_ DESC";
		} else {
			sql = "SELECT A.* FROM (" + sql + ") A WHERE A.AMOUNT_ <= A.INVENTORY_FLOOR_ ORDER BY A.indate_ DESC";
		}
		PageResult<BizMaterialStockBean> page = getPageData(
				BizMaterialStockBean.class, pageNum, pageSize, sql);
		return page;

	}

	@Override
	public PageResult<BizMaterialStockBean> findAllStock(int pageNum,
			int pageSize, String mode, String mname) {
		String sql;
		if ("getAll".equals(mode)) {
			sql = "SELECT G.ID_ id_, G.M_NAME_ m_name_, G.M_NUMBER_ m_number_, G.STANDARD_ standard_, G.SUPPLIER_ supplier_, "
				+ "G.UNIT_ unit_, G.INVENTORY_FLOOR_ inventory_floor_, G.STATUS_ status_, G.INDATE_ indate_, G.REMARK_ remark_, "
				+ "G.SORT_ sort_, G.IS_REMOVE_ is_remove_, S.AMOUNT_ amount_ FROM BIZ_MATERIAL_STOCK S "
					+ "LEFT JOIN BIZ_MATERIAL_INFO G  ON G.ID_ = S.MATERIAL_ID_  "
					+ "WHERE G.STATUS_ = '1' AND G.IS_REMOVE_ = '1' AND G.M_NAME_ LIKE '%"
					+ mname.trim() + "%'  ORDER BY G.indate_ DESC";
		} else {
			sql = "SELECT A.* FROM "
					+ "(SELECT G.ID_ id_, G.M_NAME_ m_name_, G.M_NUMBER_ m_number_, G.STANDARD_ standard_, G.SUPPLIER_ supplier_, "
					+ "G.UNIT_ unit_, G.INVENTORY_FLOOR_ inventory_floor_, G.STATUS_ status_, G.INDATE_ indate_, G.REMARK_ remark_, "
					+ "G.SORT_ sort_, G.IS_REMOVE_ is_remove_, S.AMOUNT_ amount_ FROM BIZ_MATERIAL_STOCK S "
					+ "LEFT JOIN BIZ_MATERIAL_INFO G ON G.ID_ = S.MATERIAL_ID_  "
					+ "WHERE G.STATUS_ = '1' AND G.IS_REMOVE_ = '1' AND G.M_NAME_ LIKE '%"
					+ mname.trim()
					+ "%' ) A "
					+ "WHERE A.AMOUNT_ <= A.INVENTORY_FLOOR_ ORDER BY A.indate_ DESC";
		}
		PageResult<BizMaterialStockBean> page = getPageData(
				BizMaterialStockBean.class, pageNum, pageSize, sql);
		return page;
	}

	@SuppressWarnings("unchecked")
	@Override
	public PageResult<BizMaterialStockBean> findChoosedStock(String[] ids) {
		PageResult<BizMaterialStockBean> page = new PageResult<BizMaterialStockBean>();
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT * FROM ( ");
		sql.append("SELECT g.id_,g.m_name_,g.m_number_,s.amount_ stock_ "
				+ "FROM biz_material_info g "
				+ "LEFT JOIN biz_material_stock s ON g.id_ = s.material_id_  "
				+ "WHERE g.status_ = '1' " + "ORDER BY g.indate_ DESC");
		sql.append(") a ");
		for (int i = 0; i < ids.length; i++) {
			if (i != 0) {
				sql.append("OR a.id_ = '" + ids[i] + "' ");
			} else {
				sql.append(" WHERE a.id_='" + ids[i] + "' ");
			}
		}
		Query query = em.createNativeQuery(sql.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(BizMaterialStockBean.class));
		List<BizMaterialStockBean> list = query.getResultList();
		long size = query.getResultList().size();// 总数据长度
		page.setTotalrecord(size);
		page.setResults(list);
		return page;
	}

	@SuppressWarnings("unchecked")
	@Override
	public BizMaterialStockBean findStockByMaterialId(String materialid) {
		String sql = "SELECT g.*, s.amount_  FROM biz_material_info g LEFT JOIN biz_material_stock s ON g.id_ = s.material_id_ WHERE g.id_ = ?";
		Query query = em.createNativeQuery(sql);
		query.setParameter(1, materialid);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(BizMaterialStockBean.class));
		List<BizMaterialStockBean> list = query.getResultList();
		return list.get(0);
	}

	@Override
	public PageResult<BizMaterialBean> findStockDetials(int pageNum,
			int pageSize, String wheresql) {
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT b1.billid,b1.user,b1.userorg,b1.operator,b1.operatororg,b1.direction," +
				"b1.time, g.m_name_  mname, g.m_number_ mnumber, g.standard_ standard, " +
				"g.supplier_ supplier, g.unit_ unit, d.amount_ amount FROM biz_material_stock_detail d" +
				" LEFT JOIN biz_material_info g ON d.material_id_ = g.id_ LEFT JOIN " +
				"(SELECT b.id_ billid, u1.user_name operator, u2.user_name user, o1.org_name operatororg," +
				" o2.org_name userorg, b.direction_ direction, b.end_time_ time, b.status_ status " +
				"FROM biz_material_storage b LEFT JOIN isc_user u1 ON b.operator_id_ = u1.user_id " +
				"LEFT JOIN isc_user u2 ON b.user_id_ = u2.user_id LEFT JOIN isc_org o1 " +
				"ON b.operatororg_id_ = o1.org_id LEFT JOIN isc_org o2 ON b.userorg_id_ = o2.org_id)" +
				" b1 ON b1.billid = d.storage_id_ ");
		sql.append(" WHERE b1.status ='2' "); // 状态为2 的表示库存已发生变化);
		sql.append(wheresql);
		sql.append("ORDER BY b1.time DESC ");
		PageResult<BizMaterialBean> page = getPageData(
				BizMaterialBean.class, pageNum, pageSize,
				sql.toString());
		return page;
	}

	@Override
	public long findWarningNumber() {
		// TODO Auto-generated method stub
		return 0;
	}
	@Override
	public PageResult<BizMaterialStockBean> findAllStock(int pageNum,
			int pageSize,BizMaterialStockQuery bizMaterialStockQuery) {
		StringBuffer sql=new StringBuffer();
		sql.append("SELECT G.ID_ id_, G.M_NAME_ m_name_, G.M_NUMBER_ m_number_, G.STANDARD_ standard_, G.SUPPLIER_ supplier_, "
				+ "G.UNIT_ unit_, G.INVENTORY_FLOOR_ inventory_floor_, G.STATUS_ status_, G.INDATE_ indate_, G.REMARK_ remark_, "
				+ "G.SORT_ sort_, G.IS_REMOVE_ is_remove_, S.AMOUNT_ amount_ FROM BIZ_MATERIAL_STOCK S "
					+ "LEFT JOIN BIZ_MATERIAL_INFO G  ON G.ID_ = S.MATERIAL_ID_  "
					+ "WHERE G.STATUS_ = '1' AND G.IS_REMOVE_ = '1'");
		if(StringUtils.isNotBlank(bizMaterialStockQuery.getM_name_())){
			sql.append(" and G.M_NAME_ LIKE '%"+bizMaterialStockQuery.getM_name_()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockQuery.getM_number_())){
			sql.append(" and G.M_NUMBER_ LIKE '%"+bizMaterialStockQuery.getM_number_()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockQuery.getStandard_())){
			sql.append(" and G.STANDARD_ LIKE '%"+bizMaterialStockQuery.getStandard_()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockQuery.getUnit_())){
			sql.append(" and G.UNIT_ LIKE '%"+bizMaterialStockQuery.getUnit_()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockQuery.getSupplier_())){
			sql.append("  and G.SUPPLIER_ LIKE '%"+bizMaterialStockQuery.getSupplier_()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockQuery.getAmount_())){
			sql.append(" and S.AMOUNT_ ='"+bizMaterialStockQuery.getAmount_()+"'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockQuery.getInventory_floor_())){
			sql.append(" and G.INVENTORY_FLOOR_ ='"+bizMaterialStockQuery.getInventory_floor_()+"'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockQuery.getStartIndate())){
			sql.append(" and DATE_FORMAT(G.INDATE_,'%Y-%m-%d')  >='"+bizMaterialStockQuery.getStartIndate()+"'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockQuery.getEndIndate())){
			sql.append(" and DATE_FORMAT(G.INDATE_,'%Y-%m-%d')  <='"+bizMaterialStockQuery.getEndIndate()+"'");
		}
		if(!"getAll".equals(bizMaterialStockQuery.getMode())){
			sql.append(" and S.AMOUNT_ <= G.INVENTORY_FLOOR_ ");
		}
		if(StringUtils.isNotBlank(bizMaterialStockQuery.getSortName())&&StringUtils.isNotBlank(bizMaterialStockQuery.getSortOrder())){
			sql.append("  ORDER BY CONVERT(");
			sql.append(bizMaterialStockQuery.getSortName()+" USING gbk) "+bizMaterialStockQuery.getSortOrder());
		}
		
		else{
			sql.append(" ORDER BY G.indate_ DESC");
		}
/*		if ("getAll".equals(mode)) {
			sql = "SELECT G.ID_ id_, G.M_NAME_ m_name_, G.M_NUMBER_ m_number_, G.STANDARD_ standard_, G.SUPPLIER_ supplier_, "
				+ "G.UNIT_ unit_, G.INVENTORY_FLOOR_ inventory_floor_, G.STATUS_ status_, G.INDATE_ indate_, G.REMARK_ remark_, "
				+ "G.SORT_ sort_, G.IS_REMOVE_ is_remove_, S.AMOUNT_ amount_ FROM BIZ_MATERIAL_STOCK S "
					+ "LEFT JOIN BIZ_MATERIAL_INFO G  ON G.ID_ = S.MATERIAL_ID_  "
					+ "WHERE G.STATUS_ = '1' AND G.IS_REMOVE_ = '1' AND G.M_NAME_ LIKE '%"
					+ mname.trim() + "%'  ORDER BY G.indate_ DESC";
		} else {
			sql = "SELECT A.* FROM "
					+ "(SELECT G.ID_ id_, G.M_NAME_ m_name_, G.M_NUMBER_ m_number_, G.STANDARD_ standard_, G.SUPPLIER_ supplier_, "
					+ "G.UNIT_ unit_, G.INVENTORY_FLOOR_ inventory_floor_, G.STATUS_ status_, G.INDATE_ indate_, G.REMARK_ remark_, "
					+ "G.SORT_ sort_, G.IS_REMOVE_ is_remove_, S.AMOUNT_ amount_ FROM BIZ_MATERIAL_STOCK S "
					+ "LEFT JOIN BIZ_MATERIAL_INFO G ON G.ID_ = S.MATERIAL_ID_  "
					+ "WHERE G.STATUS_ = '1' AND G.IS_REMOVE_ = '1' AND G.M_NAME_ LIKE '%"
					+ mname.trim()
					+ "%' ) A "
					+ "WHERE A.AMOUNT_ <= A.INVENTORY_FLOOR_ ORDER BY A.indate_ DESC";
		}*/
		
		PageResult<BizMaterialStockBean> page = getPageData(
				BizMaterialStockBean.class, pageNum, pageSize, sql.toString());
		return page;
	}
	
	@Override
	public PageResult<BizMaterialBean> findMaterialApplyRecords(int pageNum,
			int pageSize, String userId, String title) {
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT b.id_ billid,b.title_ title,u2.user_name user,o2.org_name userorg," +
				"u1.user_name operator,o1.org_name operatororg,b.direction_ direction," +
				"b.register_time_ time,b.status_ status FROM biz_material_storage b" +
				" LEFT JOIN isc_user u1 ON b.operator_id_ = u1.user_id " +
				"LEFT JOIN isc_user u2 ON b.user_id_ = u2.user_id " +
				"LEFT JOIN isc_org o1 ON b.operatororg_id_ = o1.org_id " +
				"LEFT JOIN isc_org o2 ON b.userorg_id_ = o2.org_id");
		if (!"".equals(userId)) {
			sql.append(" WHERE b.user_id_ = '" + userId
					+ "' AND b.direction_ = '出库' ");
		} else {
			sql.append(" WHERE b.status_ != '0' AND b.direction_ = '出库' ");
		}
		if (!title.isEmpty()) {
			sql.append(" AND b.title_ LIKE '%" + title.trim() + "%' ");
		}
		sql.append("ORDER BY b.register_time_ DESC ");
		PageResult<BizMaterialBean> page = getPageData(BizMaterialBean.class, pageNum, pageSize, sql.toString());
		return page;
	}

	@SuppressWarnings("unchecked")
	@Override
	public PageResult<BizMaterialStockBean> findChoosedMateriaById(String id) {
		PageResult<BizMaterialStockBean> page = new PageResult<BizMaterialStockBean>();
		String sql = "SELECT g.id_, g.m_name_ , g.m_number_, " +
				"s1.amount_ stock_, s.amount_ FROM biz_material_stock_detail s " +
				" LEFT JOIN biz_material_info g ON s.material_id_ = g.id_ LEFT" +
				" JOIN biz_material_stock s1 ON s1.material_id_= s.material_id_ WHERE s.storage_id_ = '"+id+"'";
		Query query = em.createNativeQuery(sql);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(BizMaterialStockBean.class));
		List<BizMaterialStockBean> list = query.getResultList();
		long size = query.getResultList().size();// 总数据长度
		page.setTotalrecord(size);
		page.setResults(list);
		return page;
	}

	@Override
	public void doDelMaterialApply(String ids) {
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
			// 删除物资领用记录详情sql
			String sql = "DELETE FROM biz_material_storage   WHERE id_ IN (" + whereId
					+ ") ";
			// 删除物资领用所对应的物品sql
			String sql1 = "DELETE  FROM biz_material_stock_detail  WHERE material_id_ IN ("
					+ whereId + ") ";
			Query query = em.createNativeQuery(sql);
			query.executeUpdate();
			Query query1 = em.createNativeQuery(sql1);
			query1.executeUpdate();
			em.getTransaction().commit();// 提交事务
		} catch (Exception e) {
			logger.error("error",e);
		} finally {
			em.close();// 关闭事务
		}

	}

	@Override
	public void doUpdateStatus(String id, String status, String operator,
			String operatorOrg, String time,
			List<BizMaterialStockDetailEntity> list) {
		EntityManager em = emf.createEntityManager();
		em.getTransaction().begin();// 开始事务
		try {
			String sql = "UPDATE biz_material_storage s SET s.status_ = ? , s.operator_id_ = ? , s.operatororg_id_ = ? , s.end_time_ = ? WHERE s.id_ = ? ";
			// 修改物品领用申请状态
			Query query = em.createNativeQuery(sql);
			query.setParameter(1, status);
			query.setParameter(2, operator);
			query.setParameter(3, operatorOrg);
			query.setParameter(4, time);
			query.setParameter(5, id);
			query.executeUpdate();
			for (int i = 0; i < list.size(); i++) {
				String materialId = list.get(i).getMaterialId_();
				int amount = list.get(i).getAmount_();
				// 获取更新物品库存sql语句
				String sql1 = updateStockSql(materialId, amount, "出库");
				// 修改物品库存
				Query query1 = em.createNativeQuery(sql1);
				query1.executeUpdate();
			}
			em.getTransaction().commit();// 提交事务
		} catch (Exception e) {
			logger.error("error",e);
		} finally {
			em.close();// 关闭事务
		}

	}

	@Override
	public void doUpdateStatus(String id, String status, String operator,
			String operatorOrg, String time) {
		try {
			String sql = "UPDATE biz_material_storage s SET s.status_ = ? , s.operator_id_ = ? , s.operatororg_id_ = ? , s.end_time_ = ? WHERE s.id_ = ? ";
			Query query = em.createNativeQuery(sql);
			query.setParameter(1, status);
			query.setParameter(2, operator);
			query.setParameter(3, operatorOrg);
			query.setParameter(4, time);
			query.setParameter(5, id);
			query.executeUpdate();
		} catch (Exception e) {
			logger.error("error",e);
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<BizMaterialStockDetailEntity> findStockChangeDetailByStorageId(
			String id) {
		String sql = "SELECT s.material_id_, s.amount_ FROM Biz_material_stock_detail s WHERE s.storage_id_= ? ";
		Query query = em.createNativeQuery(sql);
		query.setParameter(1, id);
		List<BizMaterialStockDetailEntity> list = query.getResultList();
		return list;
	}

	@Override
	public void doInStock(BizMaterialStorageEntity bmsEntity,
			List<BizMaterialStockDetailEntity> list) {
		EntityManager em = emf.createEntityManager();
		em.getTransaction().begin();// 开始事务
		try {
			// 保存出库单基本信息
			em.persist(bmsEntity);
			// 逐条对所选入库物品进行保存并更改物品库存
			for (int i = 0; i < list.size(); i++) {
				BizMaterialStockDetailEntity temp = list.get(i);
				temp.setStorageId_(bmsEntity.getId());
				// 保存出库物品详情信息
				em.persist(temp);
				String materialId = temp.getMaterialId_();
				int amount = temp.getAmount_();
				if (findCheckStock(materialId)) {
					// 修改物品库存sql
					String sql = updateStockSql(materialId, amount, "入库");
					// 修改物品库存
					Query query = em.createNativeQuery(sql.toString());
					query.executeUpdate();
				} else {
					BizMaterialStockEntity bmsEntity1 = new BizMaterialStockEntity();
					bmsEntity1.setId(null);
					bmsEntity1.setAmount_(String.valueOf(amount));
					bmsEntity1.setMaterialId_(materialId);
					bmsEntity1.setIsRemove_("1");
					em.persist(bmsEntity1);
				}
			}
			em.getTransaction().commit();// 提交事务
		} catch (Exception e) {
			logger.error("error",e);
		}finally{
			em.close();// 关闭事务
		}

	}

	@SuppressWarnings("unchecked")
	public boolean findCheckStock(String id) {
		boolean b = false;
		String sql = "SELECT id_ FROM biz_material_stock WHERE material_id_ =?";
		Query query = em.createNativeQuery(sql);
		query.setParameter(1, id);
		List<BizMaterialStockEntity> list = query.getResultList();
		if (list != null && !list.isEmpty()) {
			b = true;
		}
		return b;
	}

	@Override
	public void doOutStock(BizMaterialStorageEntity bmsEntity,
			List<BizMaterialStockDetailEntity> list) {
		EntityManager em = emf.createEntityManager();
		em.getTransaction().begin();// 开始事务
		try {
			// 保存出库单基本信息
			em.persist(bmsEntity);
			// 逐条对所选入库物品进行保存并更改物品库存
			for (int i = 0; i < list.size(); i++) {
				BizMaterialStockDetailEntity temp = list.get(i);
				temp.setStorageId_(bmsEntity.getId());
				// 保存出库物品详情信息
				em.persist(temp);
			}
			em.getTransaction().commit();// 提交事务
		} catch (Exception e) {
			logger.error("error",e);
		} finally {
			em.close();// 关闭事务
		}

	}

	@Override
	public void doUpdateMaterialApply(BizMaterialStorageEntity bmsEntity,
			List<BizMaterialStockDetailEntity> list) {
		EntityManager em = emf.createEntityManager();
		em.getTransaction().begin();// 开始事务
		try {
			// 保存出库单基本信息
			em.merge(bmsEntity);
			String id = bmsEntity.getId();
			// 逐条对所选入库物品进行保存并更改物品库存
			String sql = "DELETE FROM biz_material_stock_detail  WHERE storage_id_ =? ";
			Query query = em.createNativeQuery(sql);
			query.setParameter(1, id);
			query.executeUpdate();
			for (int i = 0; i < list.size(); i++) {
				BizMaterialStockDetailEntity temp = list.get(i);
				temp.setStorageId_(id);
				// 保存出库物品详情信息
				em.persist(temp);
			}
			em.getTransaction().commit();// 提交事务
		} catch (Exception e) {
			logger.error("error",e);
		} finally {
			em.close();// 关闭事务
		}

	}

	/**
	 * TODO: 修改物品库存sql TODO: 填入方法说明
	 * 
	 * @param materialId
	 *            物品id
	 * @param amount
	 *            出入库数量
	 * @param action
	 *            出入库操作标志 "入库" "出库"
	 * @return
	 */
	protected String updateStockSql(String materialId, int amount, String action) {
		StringBuilder sql = new StringBuilder();
		sql.append("UPDATE biz_material_stock ");
		if ("入库".equals(action)) {
			sql.append("SET amount_ = amount_ + '" + amount + "' ");
		} else {
			sql.append("SET amount_ = amount_ - '" + amount + "' ");
		}
		sql.append("WHERE material_id_ = '" + materialId + "' ");
		return sql.toString();
	}

	@Override
	public PageResult<BizMaterialListBean> findMaterialApplyRecords(int pageNum,
			int pageSize, String userId,
			BizMaterialApplyQuery bizMaterialApplyQuery) {
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT b.id_ ,b.title_ ,u2.user_name user," +
				"u1.user_name operator,b.direction_," +
				"b.register_time_,b.status_ FROM biz_material_storage b" +
				" LEFT JOIN isc_user u1 ON b.operator_id_ = u1.user_id " +
				"LEFT JOIN isc_user u2 ON b.user_id_ = u2.user_id " +
				"LEFT JOIN isc_org o1 ON b.operatororg_id_ = o1.org_id " +
				"LEFT JOIN isc_org o2 ON b.userorg_id_ = o2.org_id");
		if (!"".equals(userId)) {
			sql.append(" WHERE b.user_id_ = '" + userId
					+ "' AND b.direction_ = '出库' ");
		} else {
			sql.append(" WHERE b.status_ != '0' AND b.direction_ = '出库' ");
		}
		if(StringUtils.isNotBlank(bizMaterialApplyQuery.getTitle_())){
			sql.append(" and b.title_ LIKE '%"+bizMaterialApplyQuery.getTitle_()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialApplyQuery.getUser())){
			sql.append(" and u2.user_name LIKE '%"+bizMaterialApplyQuery.getUser()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialApplyQuery.getOperator())){
			sql.append(" and u1.user_name LIKE '%"+bizMaterialApplyQuery.getOperator()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialApplyQuery.getStatus_())){
			sql.append(" and b.status_ ='"+bizMaterialApplyQuery.getStatus_()+"'");
		}

		if(StringUtils.isNotBlank(bizMaterialApplyQuery.getStartRegisterTime())){
			sql.append(" and DATE_FORMAT(b.register_time_,'%Y-%m-%d')  >='"+bizMaterialApplyQuery.getStartRegisterTime()+"'");
		}
		if(StringUtils.isNotBlank(bizMaterialApplyQuery.getEndRegisterTime())){
			sql.append(" and DATE_FORMAT(b.register_time_,'%Y-%m-%d')  <='"+bizMaterialApplyQuery.getEndRegisterTime()+"'");
		}
		if(StringUtils.isNotBlank(bizMaterialApplyQuery.getSortName())&&StringUtils.isNotBlank(bizMaterialApplyQuery.getSortOrder())){
			sql.append("  ORDER BY CONVERT(");
			sql.append(bizMaterialApplyQuery.getSortName()+" USING gbk) "+bizMaterialApplyQuery.getSortOrder());
		}		
		else{
			sql.append(" ORDER BY b.register_time_ DESC");
		}
		PageResult<BizMaterialListBean> page = getPageData(BizMaterialListBean.class, pageNum, pageSize, sql.toString());
		return page;
	}

	@Override
	public PageResult<BizMaterialStockDetailListEntity> findStockDetials(
			int pageNum, int pageSize,
			BizMaterialStockDetailQuery bizMaterialStockDetailQuery) {
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT *from ( SELECT b1.id_,b1.user,b1.userorg,b1.operator,b1.operatororg,b1.direction_," +
				"b1.end_time_, g.m_name_  m_name_, g.m_number_ m_number_, g.standard_ standard_, " +
				"g.supplier_ supplier_, g.unit_ unit_, d.amount_ amount_ FROM biz_material_stock_detail d" +
				" LEFT JOIN biz_material_info g ON d.material_id_ = g.id_ LEFT JOIN " +
				"(SELECT b.id_ id_, u1.user_name operator, u2.user_name user, o1.org_name operatororg," +
				" o2.org_name userorg, b.direction_ direction_, b.end_time_ end_time_, b.status_ status_ " +
				"FROM biz_material_storage b LEFT JOIN isc_user u1 ON b.operator_id_ = u1.user_id " +
				"LEFT JOIN isc_user u2 ON b.user_id_ = u2.user_id LEFT JOIN isc_org o1 " +
				"ON b.operatororg_id_ = o1.org_id LEFT JOIN isc_org o2 ON b.userorg_id_ = o2.org_id)" +
				" b1 ON b1.id_ = d.storage_id_ ");
		sql.append(" WHERE b1.status_ ='2' ) allline where 1=1 "); // 状态为2 的表示库存已发生变化);
		if(StringUtils.isNotBlank(bizMaterialStockDetailQuery.getM_name_())){
			sql.append(" and M_NAME_ LIKE '%"+bizMaterialStockDetailQuery.getM_name_()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockDetailQuery.getM_number_())){
			sql.append(" and M_NUMBER_ LIKE '%"+bizMaterialStockDetailQuery.getM_number_()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockDetailQuery.getStandard_())){
			sql.append(" and STANDARD_ LIKE '%"+bizMaterialStockDetailQuery.getStandard_()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockDetailQuery.getDirection_())){
			sql.append(" and direction_ = '"+bizMaterialStockDetailQuery.getDirection_()+"'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockDetailQuery.getUser())){
			sql.append("  and user LIKE '%"+bizMaterialStockDetailQuery.getUser()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockDetailQuery.getAmount_())){
			sql.append(" and AMOUNT_ ='"+bizMaterialStockDetailQuery.getAmount_()+"'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockDetailQuery.getOperator())){
			sql.append(" and operator LIKE '%"+bizMaterialStockDetailQuery.getOperator()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockDetailQuery.getStartTime())){
			sql.append(" and DATE_FORMAT(end_time_,'%Y-%m-%d')  >='"+bizMaterialStockDetailQuery.getStartTime()+"'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockDetailQuery.getEndTime())){
			sql.append(" and DATE_FORMAT(end_time_,'%Y-%m-%d')  <='"+bizMaterialStockDetailQuery.getEndTime()+"'");
		}
		if(StringUtils.isNotBlank(bizMaterialStockDetailQuery.getSortName())&&StringUtils.isNotBlank(bizMaterialStockDetailQuery.getSortOrder())){
			sql.append("  ORDER BY CONVERT(");
			sql.append(bizMaterialStockDetailQuery.getSortName()+" USING gbk) "+bizMaterialStockDetailQuery.getSortOrder());
		}
		else{
			sql.append(" ORDER BY end_time_ DESC");
		}
		PageResult<BizMaterialStockDetailListEntity> page = getPageData(
				BizMaterialStockDetailListEntity.class, pageNum, pageSize,
				sql.toString());
		return page;
	}

}
