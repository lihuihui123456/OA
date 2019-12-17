//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcDestryDaoImpl-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.destry.dao.impl;

import java.util.List;

import javax.persistence.Query;

import org.apache.commons.lang.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.destry.dao.IArcDestryDao;
import com.yonyou.aco.arc.destry.entity.ArcDestryAll;
import com.yonyou.aco.arc.destry.entity.ArcDestryBean;
import com.yonyou.aco.arc.destry.entity.ArcDestryEntity;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
/**
 * <p>概述：持久模块销毁管理管理 dao实现类
 * <p>功能：实现对销毁管理管理业务数据处理实现类
 * <p>作者：lzh
 * <p>创建时间：2016-12-28
 * <p>类调用特殊情况：无
 */
@SuppressWarnings("unchecked")
@Repository("arcDestryDao")
public class ArcDestryDaoImpl extends BaseDao implements IArcDestryDao {
	public PageResult<ArcDestryEntity> pageArcDestryEntityList(int pageNum,
			int pageSize, ArcDestryAll arcDestryAll,ShiroUser user) {
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<ArcDestryEntity> pr = new PageResult<ArcDestryEntity>();
		StringBuffer sb=new StringBuffer();
		sb.append("select adi.id as id, adi.nbr as nbr , adi.nbr_time as nbrTime,adi.destry_time as destryTime ,adi.arc_name as arcName,adi.arc_id as arcId,adi.arc_expiry_date as arcExpiryDate,adi.oper as oper,adi.oper_time as operTime,adi.remarks as remarks,adi.data_org_id as dataOrgId ,adi.data_dept_code as dataDeptCode,adi.data_user_id as dataUserId ,adi.tenant_id as tenantId,adi.ts as ts ,cast(adi.dr as CHAR) as dr   from biz_arc_destry_ifno adi LEFT JOIN biz_arc_pub_info api on adi.arc_id = api.arc_id where 1=1 and adi.dr='N' and api.dr='N' AND adi.DATA_USER_ID='"+user.getUserId()+"'");
		if(StringUtils.isNotBlank(arcDestryAll.getDataUserId())){
			sb.append(" and adi.data_user_id=:datauserid ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getNbr())){
			sb.append(" and adi.nbr like:nbr ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getArcType())){
			sb.append(" and api.arc_type =:arctype ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getArcName())){
			sb.append(" and adi.arc_name like:arcname ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getFileStartTime())){
			sb.append(" and DATE_FORMAT(api.file_time,'%Y-%m-%d')  >=:filestarttime ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getFileEndTime())){
			sb.append(" and DATE_FORMAT(api.file_time,'%Y-%m-%d')  <=:fileendtime ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getOperStartTime())){
			sb.append(" and DATE_FORMAT(adi.oper_time,'%Y-%m-%d')  >=:operstarttime ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getOperEndTime())){
			sb.append(" and DATE_FORMAT(adi.oper_time,'%Y-%m-%d')  <=:operendtime ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getOperStartTime())||StringUtils.isNotBlank(arcDestryAll.getOperEndTime())){
			sb.append(" and api.is_invalid='2' ");
		}
		sb.append(" order by adi.oper_time desc");
		Query query = em.createNativeQuery(sb.toString());
		if(StringUtils.isNotBlank(arcDestryAll.getDataUserId())){
			query.setParameter("datauserid",arcDestryAll.getDataUserId());
		}
		if(StringUtils.isNotBlank(arcDestryAll.getNbr())){
			query.setParameter("nbr","%" + arcDestryAll.getNbr() + "%");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getArcType())){
			query.setParameter("arctype",arcDestryAll.getArcType());
		}
		if(StringUtils.isNotBlank(arcDestryAll.getArcName())){
			query.setParameter("arcname","%" +arcDestryAll.getArcName()+ "%");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getFileStartTime())){
			query.setParameter("filestarttime",arcDestryAll.getFileStartTime());
		}
		if(StringUtils.isNotBlank(arcDestryAll.getFileEndTime())){
			query.setParameter("fileendtime",arcDestryAll.getFileEndTime());
		}
		if(StringUtils.isNotBlank(arcDestryAll.getOperStartTime())){
			query.setParameter("operstarttime",arcDestryAll.getOperStartTime());
		}
		if(StringUtils.isNotBlank(arcDestryAll.getOperEndTime())){
			query.setParameter("operendtime",arcDestryAll.getOperEndTime());
		}
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcDestryEntity.class));
		long size = query.getResultList().size();// 总数据长度
		
		/** 通过传过来的页码*每页显示条数和总数进行对比 判断第一条数据的取值 **/
		if (firstindex >= size) {
			if (size > pageSize) {
				query.setFirstResult(((int) size / pageSize - 1) * pageSize).setMaxResults(maxresult);
			} else {
				query.setFirstResult(0).setMaxResults(maxresult);
			}
		} else {
			query.setFirstResult(firstindex).setMaxResults(maxresult);
		}
		List<ArcDestryEntity> list = query.getResultList();
		pr.setResults(list);
		pr.setTotalrecord(size);
		return pr;
	}

	@Override
	public PageResult<ArcDestryBean> pageArcDestryBeanList(int pageNum,
			int pageSize, ArcDestryAll arcDestryAll, ShiroUser user) {
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<ArcDestryBean> pr = new PageResult<ArcDestryBean>();
		StringBuffer sb=new StringBuffer();
		sb.append("select *from (select trim(api.expiry_date) as expiry_date ,api.expiry_date_time as expiry_date_time, api.arc_type as arc_type , bati.type_name as type_name ,api.reg_dept reg_dept,trim(api.file_start)  file_start , trim(api.is_invalid)  is_invalid ,api.file_time file_time, adi.id as id, adi.nbr as nbr  ,adi.arc_name as arc_name,adi.arc_id as arc_id,adi.oper_time as oper_time  from biz_arc_destry_ifno adi LEFT JOIN biz_arc_pub_info api on adi.arc_id = api.arc_id LEFT JOIN biz_arc_type_info bati on api.ARC_TYPE=bati.ID where 1=1 and adi.dr='N' and api.dr='N' AND adi.DATA_USER_ID='"+user.getUserId()+"'");
		if(StringUtils.isNotBlank(arcDestryAll.getDataUserId())){
			sb.append(" and adi.data_user_id=:datauserid ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getNbr())){
			sb.append(" and adi.nbr like:nbr ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getArcType())){
			sb.append(" and api.arc_type =:arctype ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getArcName())){
			sb.append(" and adi.arc_name like:arcname ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getFileStartTime())){
			sb.append(" and DATE_FORMAT(api.file_time,'%Y-%m-%d')  >=:filestarttime ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getFileEndTime())){
			sb.append(" and DATE_FORMAT(api.file_time,'%Y-%m-%d')  <=:fileendtime ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getOperStartTime())){
			sb.append(" and DATE_FORMAT(adi.oper_time,'%Y-%m-%d')  >=:operstarttime ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getOperEndTime())){
			sb.append(" and DATE_FORMAT(adi.oper_time,'%Y-%m-%d')  <=:operendtime ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getOperStartTime())||StringUtils.isNotBlank(arcDestryAll.getOperEndTime())){
			sb.append(" and api.is_invalid='2' ");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getSortName())&&StringUtils.isNotBlank(arcDestryAll.getSortOrder())){
			sb.append(") tablea order by CONVERT(");
			sb.append(arcDestryAll.getSortName()+" USING gbk) "+arcDestryAll.getSortOrder());
		}
		else{
			sb.append(") tablea order by oper_time desc");
		}
		Query query = em.createNativeQuery(sb.toString());
		if(StringUtils.isNotBlank(arcDestryAll.getDataUserId())){
			query.setParameter("datauserid",arcDestryAll.getDataUserId());
		}
		if(StringUtils.isNotBlank(arcDestryAll.getNbr())){
			query.setParameter("nbr","%" + arcDestryAll.getNbr() + "%");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getArcType())){
			query.setParameter("arctype",arcDestryAll.getArcType());
		}
		if(StringUtils.isNotBlank(arcDestryAll.getArcName())){
			query.setParameter("arcname","%" +arcDestryAll.getArcName()+ "%");
		}
		if(StringUtils.isNotBlank(arcDestryAll.getFileStartTime())){
			query.setParameter("filestarttime",arcDestryAll.getFileStartTime());
		}
		if(StringUtils.isNotBlank(arcDestryAll.getFileEndTime())){
			query.setParameter("fileendtime",arcDestryAll.getFileEndTime());
		}
		if(StringUtils.isNotBlank(arcDestryAll.getOperStartTime())){
			query.setParameter("operstarttime",arcDestryAll.getOperStartTime());
		}
		if(StringUtils.isNotBlank(arcDestryAll.getOperEndTime())){
			query.setParameter("operendtime",arcDestryAll.getOperEndTime());
		}
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcDestryBean.class));
		long size = query.getResultList().size();// 总数据长度
		
		/** 通过传过来的页码*每页显示条数和总数进行对比 判断第一条数据的取值 **/
		if (firstindex >= size) {
			if (size > pageSize) {
				query.setFirstResult(((int) size / pageSize - 1) * pageSize).setMaxResults(maxresult);
			} else {
				query.setFirstResult(0).setMaxResults(maxresult);
			}
		} else {
			query.setFirstResult(firstindex).setMaxResults(maxresult);
		}
		List<ArcDestryBean> list = query.getResultList();
		pr.setResults(list);
		pr.setTotalrecord(size);
		return pr;
	}
}
