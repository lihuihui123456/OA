package com.yonyou.aco.material.service.Impl;
import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.persistence.Query;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Service;

import com.yonyou.aco.material.dao.IBizMaterialDao;
import com.yonyou.aco.material.entity.BizMaterialBeanNew;
import com.yonyou.aco.material.entity.BizMaterialBeanNewQuery;
import com.yonyou.aco.material.entity.BizMaterialEntity;
import com.yonyou.aco.material.entity.BizMaterialStockEntity;
import com.yonyou.aco.material.service.IBizMaterialService;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;
@Service("iBizMaterialService")
public class BizMaterialServiceImpl extends BaseDao implements IBizMaterialService{

	@Resource
	IBizMaterialDao ibmDao;
	@Override
	public PageResult<BizMaterialBeanNew> findAllMaterialData(int pageNum, int pageSize) {
		/*LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		String wheresql ="is_remove_='1'";
		orderby.put("indate_", "DESC");
		return ibmDao.getPageData(BizMaterialEntity.class, pageNum, pageSize, wheresql, null, orderby);*/
		StringBuffer sb = new StringBuffer();
		sb.append("select id_,m_name_,m_number_,standard_,supplier_,unit_,inventory_floor_,status_,indate_,remark_,sort_,");
		sb.append("is_remove_,TENANT_ID,USER_ID,DEPT_CODE,ORG_ID from biz_material_info ");
		sb.append("where is_remove_='1' order by indate_ DESC");
/*		PageResult<BizMaterialBeanNew> a = ibmDao.getPageData(BizMaterialBeanNew.class, pageNum, pageSize, sb.toString() );
*/		return ibmDao.getPageData(BizMaterialBeanNew.class, pageNum, pageSize, sb.toString() );
	}

	@Override
	public PageResult<BizMaterialBeanNew> findAllMaterialData(int pageNum, int pageSize,
		String mname,String sortName,String sortOrder) {
		/*String wheresql = "m_name_ LIKE ?1 AND is_remove_='1' ";
		String param = "%" + mname + "%";
		Object[] queryParams = { param };
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		orderby.put(sortName, sortOrder);
		return ibmDao.getPageData(BizMaterialEntity.class, pageNum, pageSize, wheresql,
				queryParams, orderby);*/
		StringBuffer sb = new StringBuffer();
		sb.append("select id_,m_name_,m_number_,standard_,supplier_,unit_,inventory_floor_,status_,indate_,remark_,sort_,");
		sb.append("is_remove_,TENANT_ID,USER_ID,DEPT_CODE,ORG_ID from biz_material_info ");
		sb.append("where is_remove_='1' ");
		sb.append(" and ");
		if(null != mname){
			sb.append("m_name_ LIKE '%"+mname.trim()+"%'");
		}
		if(StringUtils.isNotEmpty(sortName)){
			sb.append(" order by CONVERT( "+sortName+" USING gbk) "+sortOrder);
		}
		return ibmDao.getPageData(BizMaterialBeanNew.class, pageNum, pageSize, sb.toString() );
	}

	@Override
	public void addMaterial(BizMaterialEntity bmEntity) {
		ibmDao.save(bmEntity);
		
	}

	@Override
	public String findCount() {
		return ibmDao.findCount()+"";
	}

	@Override
	public void updateMaterial(BizMaterialEntity bmEntity) {
		ibmDao.update(bmEntity);
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public BizMaterialBeanNew findMaterialById(String id) {
		String sql = "select * from biz_material_info where id_='"+id+"'";
		Query query = em.createNativeQuery(sql);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(BizMaterialBeanNew.class));
		List<BizMaterialBeanNew>  list= query.getResultList();
		return list.get(0);
	}

	@Override
	public PageResult<BizMaterialEntity> getAllUsingMaterial(int pageNum,
			int pageSize, String wheresql) {
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		orderby.put("indate_", "DESC");
		return ibmDao.getPageData(BizMaterialEntity.class, pageNum, pageSize, wheresql,
				null, orderby);
	}

	@Override
	public List<BizMaterialEntity> getMaterialByIds(String[] ids) {
		return ibmDao.findMaterialByIds(ids);
	}

	@Override
	public void saveMaterialAndStock(BizMaterialEntity bmEntity,
			BizMaterialStockEntity bmsEntity) {
		ibmDao.doSaveMaterialAndStock(bmEntity, bmsEntity);
		
	}

	@Override
	public void delMaterialAndStock(String ids) {
		if(ids!=null && !"".equals(ids)){
			ibmDao.doDelMaterialAndStock(ids);
		}
		
	}

	@Override
	public PageResult<BizMaterialBeanNew> findAllMaterialData(int pageNum,
			int pageSize, BizMaterialBeanNewQuery bizMaterialBeanNewQuery) {
		StringBuffer sql = new StringBuffer();
		sql.append("select id_,m_name_,m_number_,standard_,supplier_,unit_,inventory_floor_,status_,indate_,remark_,sort_,");
		sql.append("is_remove_,TENANT_ID,USER_ID,DEPT_CODE,ORG_ID from biz_material_info ");
		sql.append("where is_remove_='1' ");
		if(StringUtils.isNotBlank(bizMaterialBeanNewQuery.getM_name_())){
			sql.append(" and m_name_ LIKE '%"+bizMaterialBeanNewQuery.getM_name_()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialBeanNewQuery.getM_number_())){
			sql.append(" and m_number_ LIKE '%"+bizMaterialBeanNewQuery.getM_number_()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialBeanNewQuery.getStandard_())){
			sql.append(" and standard_ LIKE '%"+bizMaterialBeanNewQuery.getStandard_()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialBeanNewQuery.getUnit_())){
			sql.append(" and unit_ LIKE '%"+bizMaterialBeanNewQuery.getUnit_()+"%'");
		}
		if(StringUtils.isNotBlank(bizMaterialBeanNewQuery.getSupplier_())){
			sql.append("  and supplier_ LIKE '%"+bizMaterialBeanNewQuery.getSupplier_()+"%'");
		}

		if(StringUtils.isNotBlank(bizMaterialBeanNewQuery.getStartTime())){
			sql.append(" and DATE_FORMAT(indate_,'%Y-%m-%d')  >='"+bizMaterialBeanNewQuery.getStartTime()+"'");
		}
		if(StringUtils.isNotBlank(bizMaterialBeanNewQuery.getEndTime())){
			sql.append(" and DATE_FORMAT(indate_,'%Y-%m-%d')  <='"+bizMaterialBeanNewQuery.getEndTime()+"'");
		}
		if(StringUtils.isNotBlank(bizMaterialBeanNewQuery.getSortName())&&StringUtils.isNotBlank(bizMaterialBeanNewQuery.getSortOrder())){
			sql.append("  ORDER BY CONVERT(");
			sql.append(bizMaterialBeanNewQuery.getSortName()+" USING gbk) "+bizMaterialBeanNewQuery.getSortOrder());
		}		
		else{
			sql.append(" ORDER BY indate_ DESC");
		}
		return ibmDao.getPageData(BizMaterialBeanNew.class, pageNum, pageSize, sql.toString() );
	}

	@SuppressWarnings("unchecked")
	@Override
	public String findCountById(String id) {
		StringBuffer sb = new StringBuffer();
		sb.append(" select trim(a.amount_) amount_ from biz_material_stock a left join biz_material_info b ");
		sb.append(" on b.id_  = a.material_id_ where a.material_id_ = '"+id+"'");
		Query query = em.createNativeQuery(sb.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(BizMaterialStockEntity.class));
		List<BizMaterialStockEntity>  list= query.getResultList();
		if(list.size()>0){
			return list.get(0).getAmount_();
		}
		return "";
	}

}
