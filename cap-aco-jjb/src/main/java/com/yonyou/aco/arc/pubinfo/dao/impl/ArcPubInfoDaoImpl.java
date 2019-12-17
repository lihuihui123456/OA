//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcPubInfoDaoImpl-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.pubinfo.dao.impl;

import java.util.List;

import javax.persistence.Query;

import org.apache.commons.lang.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.pubinfo.dao.IArcPubInfoDao;
import com.yonyou.aco.arc.pubinfo.entity.ArcPubInfoBean;
import com.yonyou.aco.arc.pubinfo.entity.ArcPubInfoListBean;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;

/**
 * <p>
 * 概述：持久模块其它档案管理 dao实现类
 * <p>
 * 功能：实现对其它档案管理业务数据处理实现类
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-1-7
 * <p>
 * 类调用特殊情况：无
 */
@SuppressWarnings("unchecked")
@Repository("pubInfoDao")
public class ArcPubInfoDaoImpl extends BaseDao implements IArcPubInfoDao {

	public PageResult<ArcPubInfoListBean> pageArcPubInfoEntityList(int pageNum,
			int pageSize, ArcPubInfoBean arcpubinfoAll) {
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<ArcPubInfoListBean> pr = new PageResult<ArcPubInfoListBean>();
		StringBuffer sb = new StringBuffer();
/*		sb.append("select api.file_type as fileType, api.id as Id,api.arc_id as arcId,api.reg_user as regUser ,api.reg_dept as regDept,api.reg_time as regTime ,api.arc_type as arcType ,");
		sb.append("api.arc_name as arcName,api.key_word as keyWord,api.dep_pos as depPos,cast(api.file_start as CHAR) as fileStart ,api.file_user as fileUser ,api.file_time as fileTime,cast(api.expiry_date as CHAR) as expiryDate ,api.expiry_date_time as expiryDateTime,");
		sb.append("cast(api.is_invalid as CHAR) as isInvalid,cast(api.dr as CHAR) as dr,api.remarks from biz_arc_pub_info api where api.dr='N'and api.is_invalid !=2 and api.expiry_date_time >= sysdate() ");*/
		sb.append("select api.arc_id as arc_id,api.reg_user as reg_user ,api.reg_dept as reg_dept,api.reg_time as reg_time  ,");
		sb.append("api.arc_name as arc_name,api.key_word as key_word,api.dep_pos as dep_pos,cast(api.file_start as CHAR) as file_start,cast(api.is_invalid as CHAR) as is_invalid ");
		sb.append(" from biz_arc_pub_info api where api.dr='N'and api.is_invalid !=2 and api.expiry_date_time >= sysdate() ");
		if (StringUtils.isNotBlank(arcpubinfoAll.getArcType())) {
			sb.append(" and api.arc_type =:arctype ");
		}
		if (StringUtils.isNotBlank(arcpubinfoAll.getArcName())) {
			sb.append(" and api.arc_name like:arcname ");
		}
		if (StringUtils.isNotBlank(arcpubinfoAll.getKeyWord())) {
			sb.append(" and api.key_word like:keyword ");
		}
		if (StringUtils.isNotBlank(arcpubinfoAll.getFileStart())) {
			if(!"2".equalsIgnoreCase(arcpubinfoAll.getFileStart())){
				sb.append(" and api.file_start=:filestart and api.is_invalid!=1 ");
			}else{
				sb.append(" and api.is_invalid=1");
			}
		}
		
		  if(StringUtils.isNotBlank(arcpubinfoAll.getRegUser())){
		  sb.append(" and api.reg_user=:datauserid "); }
		 
		// 年度
		if (StringUtils.isNotBlank(arcpubinfoAll.getYearNum())) {
			sb.append(" and YEAR(api.reg_time) like:yearnum ");
		}
		if (StringUtils.isNotBlank(arcpubinfoAll.getStartRegTime())) {
			sb.append(" and DATE_FORMAT(api.reg_time,'%Y-%m-%d')  >=:startregtime ");
		}
		if (StringUtils.isNotBlank(arcpubinfoAll.getEndRegTime())) {
			sb.append(" and DATE_FORMAT(api.reg_time,'%Y-%m-%d')  <=:endregtime ");
		}
		if(StringUtils.isNotBlank(arcpubinfoAll.getAttribute())&&StringUtils.isNotBlank(arcpubinfoAll.getOrderBy())){
			sb.append(" order by CONVERT(");
			sb.append(arcpubinfoAll.getAttribute()+" USING gbk) "+arcpubinfoAll.getOrderBy());
		}
		else{
			sb.append(" order by api.reg_time desc");
		}
		Query query = em.createNativeQuery(sb.toString());
		if (StringUtils.isNotBlank(arcpubinfoAll.getArcType())) {
			query.setParameter("arctype", arcpubinfoAll.getArcType());
		}
		if (StringUtils.isNotBlank(arcpubinfoAll.getArcName())) {
			query.setParameter("arcname", "%" + arcpubinfoAll.getArcName()
					+ "%");
		}
		if (StringUtils.isNotBlank(arcpubinfoAll.getKeyWord())) {
			query.setParameter("keyword", "%" + arcpubinfoAll.getKeyWord()
					+ "%");
		}
		if (StringUtils.isNotBlank(arcpubinfoAll.getFileStart())) {
			if("2".equalsIgnoreCase(arcpubinfoAll.getFileStart())){
			}else{
				query.setParameter("filestart", arcpubinfoAll.getFileStart());
			}
		}
		
		  if(StringUtils.isNotBlank(arcpubinfoAll.getRegUser())){
		  query.setParameter("datauserid",arcpubinfoAll.getRegUser()); }
		 
		// 年度
		if (StringUtils.isNotBlank(arcpubinfoAll.getYearNum())) {
			query.setParameter("yearnum", "%" + arcpubinfoAll.getYearNum());
		}
		if (StringUtils.isNotBlank(arcpubinfoAll.getStartRegTime())) {
			query.setParameter("startregtime", arcpubinfoAll.getStartRegTime());
		}
		if (StringUtils.isNotBlank(arcpubinfoAll.getEndRegTime())) {
			query.setParameter("endregtime", arcpubinfoAll.getEndRegTime());
		}
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcPubInfoListBean.class));
		long size = query.getResultList().size();// 总数据长度

		/** 通过传过来的页码*每页显示条数和总数进行对比 判断第一条数据的取值 **/
		if (firstindex >= size) {
			if (size > pageSize) {
				query.setFirstResult(((int) size / pageSize - 1) * pageSize)
						.setMaxResults(maxresult);
			} else {
				query.setFirstResult(0).setMaxResults(maxresult);
			}
		} else {
			query.setFirstResult(firstindex).setMaxResults(maxresult);
		}

		List<ArcPubInfoListBean> list = query.getResultList();
		pr.setResults(list);
		pr.setTotalrecord(size);
		return pr;
	}
	@Override
	public ArcPubInfoListBean getArcPubInfoBeanByArcId(String arcId) {
		StringBuffer sb = new StringBuffer();
/*		sb.append("select api.file_type as fileType, api.id as Id,api.arc_id as arcId,api.reg_user as regUser ,api.reg_dept as regDept,api.reg_time as regTime ,api.arc_type as arcType ,");
		sb.append("api.arc_name as arcName,api.key_word as keyWord,api.dep_pos as depPos,cast(api.file_start as CHAR) as fileStart ,api.file_user as fileUser ,api.file_time as fileTime,cast(api.expiry_date as CHAR) as expiryDate ,api.expiry_date_time as expiryDateTime,");
		sb.append("cast(api.is_invalid as CHAR) as isInvalid,cast(api.dr as CHAR) as dr,api.remarks from biz_arc_pub_info api where api.dr='N'and api.is_invalid !=2 and api.expiry_date_time >= sysdate() ");*/
		sb.append("select api.arc_id as arc_id,api.reg_user as reg_user ,api.reg_dept as reg_dept,api.reg_time as reg_time  ,");
		sb.append("api.arc_name as arc_name,api.key_word as key_word,api.dep_pos as dep_pos,cast(api.file_start as CHAR) as file_start,cast(api.is_invalid as CHAR) as is_invalid ");
		sb.append(" from biz_arc_pub_info api  WHERE api.arc_id=:arcId ");
		Query query = em.createNativeQuery(sb.toString());
		query.setParameter("arcId", arcId);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcPubInfoListBean.class));
		List<ArcPubInfoListBean> list = query.getResultList();
		if (list.size() > 0) {
			return list.get(0);
		}
		return null;
	}
}
