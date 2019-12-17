//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcPubInfoDaoImpl-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.otherarc.dao.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.persistence.Query;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.otherarc.dao.IArcPubInfoDao;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoBean;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.dataauth.datarule.entity.DataRuleEnum;
import com.yonyou.cap.isc.dataauth.datarule.entity.SqlParam;
import com.yonyou.cap.isc.dataauth.datarule.service.IDataRuleService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * <p>
 * 概述：业务模块其它档案管理 dao实现类
 * <p>
 * 功能：实现对其它档案管理业务数据处理实现类
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-12-21
 * <p>
 * 类调用特殊情况：无
 */
@Repository("arcPubInfoDao")
public class ArcPubInfoDaoImpl extends BaseDao implements IArcPubInfoDao {

	@Resource
	IDataRuleService dateRuleService;

	@SuppressWarnings("unchecked")
	@Override
	public ArcPubInfoEntity selectArcPubInfoEntityByArcId(String arcId) {
		String sql = " select api.file_type as fileType, api.id as Id,api.arc_id as arcId,api.reg_user as regUser ,api.reg_dept as regDept,api.reg_time as regTime ,api.arc_type as arcType ,"
				+ "api.arc_name as arcName,api.key_word as keyWord,api.dep_pos as depPos,cast(api.file_start as CHAR) as fileStart ,api.file_user as fileUser,api.file_dept as fileDept ,api.file_time as fileTime,cast(api.expiry_date as CHAR) as expiryDate ,api.expiry_date_time as expiryDateTime,"
				+ "api.data_org_id as dataOrgId ,api.data_dept_id as dataDeptId ,api.data_dept_code as dataDeptCode , "
				+ "cast(api.is_invalid as CHAR) as isInvalid,cast(api.dr as CHAR) as dr,api.remarks,api.data_user_id as dataUserId from biz_arc_pub_info api where api.dr='N' and api.arc_id=:arcId  order by api.file_time desc";
		Query query = em.createNativeQuery(sql);
		query.setParameter("arcId", arcId);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcPubInfoEntity.class));
		List<ArcPubInfoEntity> list = query.getResultList();
		if (list.size() > 0) {
			return list.get(0);
		}
		return null;
	}

	public void doUpdateFileStartByArcId(String arcId,ShiroUser user) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();
		String fileTime = sdf.format(date);
		String userId = "";
		String deptId = "";
		if (user != null) {
			userId = user.getUserId();
			deptId = user.getDeptId();
		}
		StringBuffer sb = new StringBuffer();
		sb.append("UPDATE biz_arc_pub_info SET FILE_START='1',FILE_USER='" + userId
				+ "',FILE_TIME='" + fileTime + "',FILE_DEPT ='" + deptId
				+ "' WHERE ARC_ID=?");
		Query query = this.em.createNativeQuery(sb.toString());
		query.setParameter(1, arcId);
		query.executeUpdate();
	}

	public void doAddFileUpdateFileStartByArcId(String arcId) {
		StringBuffer sb = new StringBuffer();
		sb.append("UPDATE biz_arc_pub_info SET FILE_START='0',FILE_USER=NULL,FILE_TIME=NULL WHERE ARC_ID=?");
		Query query = this.em.createNativeQuery(sb.toString());
		query.setParameter(1, arcId);
		query.executeUpdate();
	}

	public void doDelArcInfoByArcId(String arcId) {
		StringBuffer sb = new StringBuffer();
		sb.append("UPDATE biz_arc_pub_info SET DR='Y' WHERE ARC_ID=?");
		Query query = this.em.createNativeQuery(sb.toString());
		query.setParameter(1, arcId);
		query.executeUpdate();
	}

	public void doInvArcInfoByArcId(String arcId) {
		StringBuffer sb = new StringBuffer();
		sb.append("UPDATE biz_arc_pub_info SET IS_INVALID='1' WHERE ARC_ID=?");
		Query query = this.em.createNativeQuery(sb.toString());
		query.setParameter(1, arcId);
		query.executeUpdate();
	}

	@SuppressWarnings("unchecked")
	@Override
	public PageResult<ArcPubInfoEntity> pageArcPubInfoEntityList(int pageNum,
			int pageSize, String arcName, String startTime, String endTime) {
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<ArcPubInfoEntity> pr = new PageResult<ArcPubInfoEntity>();
		StringBuffer sql = new StringBuffer();
		String sqlStr = " select api.file_type as fileType, api.id as Id,api.arc_id as arcId,api.reg_user as regUser ,api.reg_dept as regDept,api.reg_time as regTime ,api.arc_type as arcType ,"
				+ "api.arc_name as arcName,api.key_word as keyWord,api.dep_pos as depPos,trim(api.file_start) as fileStart ,api.file_user as fileUser,api.file_dept as fileDept ,api.file_time as fileTime,trim(api.expiry_date) as expiryDate ,api.expiry_date_time as expiryDateTime,"
				+ "trim(api.is_invalid) as isInvalid,trim(api.dr) as dr,api.remarks from biz_arc_pub_info api where api.dr='N' and (api.is_invalid='1' or api.expiry_date_time < sysdate()) AND api.ARC_ID NOT IN(SELECT ARC_ID FROM biz_arc_destry_ifno) ";
		sql.append(sqlStr);
		if (StringUtils.isNotBlank(arcName)) {
			sql.append(" and api.arc_name like:arcName ");
		}
		if (StringUtils.isNotBlank(startTime)) {
			sql.append(" and DATE_FORMAT(api.file_time,'%Y-%m-%d') >=:startTime ");
		}
		if (StringUtils.isNotBlank(endTime)) {
			sql.append(" and DATE_FORMAT(api.file_time,'%Y-%m-%d') <=:endTime ");
		}
		sql.append(" ORDER BY api.FILE_TIME DESC ");
		Query query = em.createNativeQuery(sql.toString());
		if (StringUtils.isNotBlank(arcName)) {
			query.setParameter("arcName", "%" + arcName + "%");
		}
		if (StringUtils.isNotBlank(startTime)) {
			query.setParameter("startTime", startTime);
		}
		if (StringUtils.isNotBlank(endTime)) {
			query.setParameter("endTime", endTime);
		}

		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcPubInfoEntity.class));
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

		List<ArcPubInfoEntity> list = query.getResultList();
		pr.setResults(list);
		pr.setTotalrecord(size);
		return pr;
	}

	@SuppressWarnings("unchecked")
	@Override
	public PageResult<ArcPubInfoEntity> pageArcPubInfoEntity(int pageNum,
			int pageSize, String arcName, String fileUser, String fileDept,
			String startTime, String endTime, String modCode) {

		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<ArcPubInfoEntity> pr = new PageResult<ArcPubInfoEntity>();
		StringBuffer sql = new StringBuffer();
		String sqlStr = " SELECT api.FILE_TYPE  fileType,api.ID  Id,api.ARC_ID  arcId,"
				+ "api.REG_USER  regUser,api.REG_DEPT  regDept,api.REG_TIME  regTime,"
				+ "api.ARC_TYPE  arcType,api.ARC_NAME  arcName,api.KEY_WORD  keyWord,"
				+ "api.DEP_POS  depPos,trim(api.FILE_START)  fileStart,"
				+ "api.FILE_USER  fileUser,api.file_dept as fileDept,api.FILE_TIME  fileTime,"
				+ "trim(api.EXPIRY_DATE)  expiryDate,api.EXPIRY_DATE_TIME  expiryDateTime,"
				+ "trim(api.IS_INVALID)  isInvalid,trim(api.DR)  dr,api.REMARKS remarks"
				+ " FROM biz_arc_pub_info api WHERE api.DR = 'N' AND api.FILE_START = '1' and api.IS_INVALID ='0' and api.expiry_date_time >= sysdate() ";
		sql.append(sqlStr);
		if(user != null){
			sql.append(" AND api.DATA_USER_ID='" + user.getUserId() + "'");
		}
		if (StringUtils.isNotBlank(arcName)) {
			sql.append(" AND api.ARC_NAME LIKE:arcName ");
		}
		if (StringUtils.isNotBlank(fileUser)) {
			sql.append(" AND api.FILE_USER =:fileuser ");
		}
		if (StringUtils.isNotBlank(fileDept)) {
			sql.append(" AND api.file_dept =:filedept ");
		}
		if (StringUtils.isNotBlank(startTime)) {
			sql.append(" AND DATE_FORMAT(api.FILE_TIME,'%Y-%m-%d') >=:startTime ");
		}
		if (StringUtils.isNotBlank(endTime)) {
			sql.append(" AND DATE_FORMAT(api.FILE_TIME,'%Y-%m-%d') <=:endTime ");
		}
		sql.append(" ORDER BY api.FILE_TIME DESC ");
		Query query = em.createNativeQuery(sql.toString());
		if (StringUtils.isNotBlank(arcName)) {
			query.setParameter("arcName", "%" + arcName + "%");
		}
		if (StringUtils.isNotBlank(fileUser)) {
			query.setParameter("fileuser", fileUser);
		}
		if (StringUtils.isNotBlank(fileDept)) {
			query.setParameter("filedept", fileDept);
		}
		if (StringUtils.isNotBlank(startTime)) {
			query.setParameter("startTime", startTime);
		}
		if (StringUtils.isNotBlank(endTime)) {
			query.setParameter("endTime", endTime);
		}

		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcPubInfoEntity.class));
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
		List<ArcPubInfoEntity> list = query.getResultList();
		pr.setResults(list);
		pr.setTotalrecord(size);
		return pr;
	}

	/**
	 * @add by zhang duoyi 2017.01.17 根据arcId还原已经作废的档案
	 */
	@Override
	public void doHuanyuanByArcId(String arcId) {
		StringBuffer sb = new StringBuffer();
		sb.append("UPDATE biz_arc_pub_info SET IS_INVALID='0' , FILE_START='1' WHERE ARC_ID=?");
		Query query = this.em.createNativeQuery(sb.toString());
		query.setParameter(1, arcId);
		query.executeUpdate();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.yonyou.aco.arc.otherarc.dao.IArcPubInfoDao#pageArcPubInfoEntity(int,
	 * int, java.lang.String, java.lang.String, java.lang.String,
	 * java.lang.String, java.lang.String, java.lang.String, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public PageResult<ArcPubInfoEntity> pageArcPubInfoEntity(int pageNum,
			int pageSize, String arcName, String fileUser, String fileDept,
			String startTime, String endTime, String arcType, String modCode) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		SqlParam sqlParam = dateRuleService.createSqlParam(modCode, "api",DataRuleEnum.DATA_ORG_ID);
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<ArcPubInfoEntity> pr = new PageResult<ArcPubInfoEntity>();
		StringBuffer sql = new StringBuffer();
		String sqlStr = " SELECT api.FILE_TYPE  fileType,api.ID  Id,api.ARC_ID  arcId,"
				+ "api.REG_USER  regUser,api.REG_DEPT  regDept,api.REG_TIME  regTime,"
				+ "api.ARC_TYPE  arcType,api.ARC_NAME  arcName,api.KEY_WORD  keyWord,"
				+ "api.DEP_POS  depPos,trim(api.FILE_START)  fileStart,"
				+ "api.FILE_USER  fileUser,api.file_dept as fileDept,api.FILE_TIME  fileTime,"
				+ "trim(api.EXPIRY_DATE)  expiryDate,api.EXPIRY_DATE_TIME  expiryDateTime,"
				+ "trim(api.IS_INVALID)  isInvalid,trim(api.DR)  dr,api.REMARKS remarks"
				+ " FROM biz_arc_pub_info api WHERE api.DR = 'N' AND api.FILE_START = '1'"
				+ " AND api.IS_INVALID !='1' AND api.IS_INVALID !='2' and api.expiry_date_time >= sysdate()";
		sql.append(sqlStr);
		if (sqlParam.isHasDataRole() && StringUtils.isNotBlank(sqlParam.getParam())) {
			sql.append(sqlParam.getParam());
		} else {
			sql.append(" AND api.DATA_USER_ID='" + user.getUserId() + "'");
		}
		if (StringUtils.isNotBlank(arcName)) {
			sql.append(" AND api.ARC_NAME LIKE:arcName ");
		}
		if (StringUtils.isNotBlank(fileUser)) {
			sql.append(" AND api.FILE_USER =:fileuser ");
		}
		if (StringUtils.isNotBlank(fileDept)) {
			sql.append(" AND api.file_dept =:filedept ");
		}
		if (StringUtils.isNotBlank(arcType)) {
			if (!"all".equalsIgnoreCase(arcType)) {
				sql.append(" AND api.ARC_TYPE =:arctype ");
			}
		}
		if (StringUtils.isNotBlank(startTime)) {
			sql.append(" AND DATE_FORMAT(api.FILE_TIME,'%Y-%m-%d') >=:startTime ");
		}
		if (StringUtils.isNotBlank(endTime)) {
			sql.append(" AND DATE_FORMAT(api.FILE_TIME,'%Y-%m-%d') <=:endTime ");
		}
		sql.append(" ORDER BY api.FILE_TIME DESC ");
		Query query = em.createNativeQuery(sql.toString());
		if (StringUtils.isNotBlank(arcName)) {
			query.setParameter("arcName", "%" + arcName + "%");
		}
		if (StringUtils.isNotBlank(fileUser)) {
			query.setParameter("fileuser", fileUser);
		}
		if (StringUtils.isNotBlank(fileDept)) {
			query.setParameter("filedept", fileDept);
		}
		if (StringUtils.isNotBlank(startTime)) {
			query.setParameter("startTime", startTime);
		}
		if (StringUtils.isNotBlank(endTime)) {
			query.setParameter("endTime", endTime);
		}
		if (StringUtils.isNotBlank(arcType)) {
			if (!"all".equalsIgnoreCase(arcType)) {
				query.setParameter("arctype", arcType);
			}
		}
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcPubInfoEntity.class));
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
		List<ArcPubInfoEntity> list = query.getResultList();
		pr.setResults(list);
		pr.setTotalrecord(size);
		return pr;
	}

	@SuppressWarnings("unchecked")
	@Override
	public PageResult<ArcPubInfoBean> pageArcPubInfoEntity(int pageNum,
			int pageSize, String arcName, String fileUser, String fileDept,
			String startTime, String endTime, String arcType, String modCode,
			String sortName, String sortOrder) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		SqlParam sqlParam = dateRuleService.createSqlParam(modCode, "api",DataRuleEnum.DATA_ORG_ID);
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<ArcPubInfoBean> pr = new PageResult<ArcPubInfoBean>();
		StringBuffer sql = new StringBuffer();
		String sqlStr = " SELECT api.ID  id,api.ARC_ID arc_id,"
				+ "api.ARC_NAME  arc_name,api.ARC_TYPE arc_type,trim(api.IS_INVALID) is_invalid,"
				+ "api.FILE_USER  file_user,api.file_dept as file_dept,api.FILE_TIME  file_time,"
				+ "bati.TYPE_NAME type_name"
				+ " FROM biz_arc_pub_info api LEFT JOIN biz_arc_type_info bati on api.ARC_TYPE=bati.ID WHERE api.DR = 'N' AND api.FILE_START = '1'"
				+ " AND api.IS_INVALID !='1' AND api.IS_INVALID !='2' and api.expiry_date_time >= sysdate()";
		sql.append(sqlStr);
		if (sqlParam.isHasDataRole() && StringUtils.isNotBlank(sqlParam.getParam())) {
			sql.append(sqlParam.getParam());
		} else {
			sql.append(" AND api.DATA_USER_ID='" + user.getUserId() + "'");
		}
		if (StringUtils.isNotBlank(arcName)) {
			sql.append(" AND api.ARC_NAME LIKE:arcName ");
		}
		if (StringUtils.isNotBlank(fileUser)) {
			sql.append(" AND api.FILE_USER =:fileuser ");
		}
		if (StringUtils.isNotBlank(fileDept)) {
			sql.append(" AND api.file_dept =:filedept ");
		}
		if (StringUtils.isNotBlank(arcType)) {
			if (!"all".equalsIgnoreCase(arcType)) {
				sql.append(" AND api.ARC_TYPE =:arctype ");
			}
		}
		if (StringUtils.isNotBlank(startTime)) {
			sql.append(" AND DATE_FORMAT(api.FILE_TIME,'%Y-%m-%d') >=:startTime ");
		}
		if (StringUtils.isNotBlank(endTime)) {
			sql.append(" AND DATE_FORMAT(api.FILE_TIME,'%Y-%m-%d') <=:endTime ");
		}
		if(StringUtils.isNotBlank(sortName)&&StringUtils.isNotBlank(sortOrder)){
			sql.append(" order by CONVERT(");
			sql.append(sortName+" USING gbk) "+sortOrder);
		}
		else{
			sql.append(" ORDER BY api.FILE_TIME DESC ");
		}
		Query query = em.createNativeQuery(sql.toString());
		if (StringUtils.isNotBlank(arcName)) {
			query.setParameter("arcName", "%" + arcName + "%");
		}
		if (StringUtils.isNotBlank(fileUser)) {
			query.setParameter("fileuser", fileUser);
		}
		if (StringUtils.isNotBlank(fileDept)) {
			query.setParameter("filedept", fileDept);
		}
		if (StringUtils.isNotBlank(startTime)) {
			query.setParameter("startTime", startTime);
		}
		if (StringUtils.isNotBlank(endTime)) {
			query.setParameter("endTime", endTime);
		}
		if (StringUtils.isNotBlank(arcType)) {
			if (!"all".equalsIgnoreCase(arcType)) {
				query.setParameter("arctype", arcType);
			}
		}
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcPubInfoBean.class));
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
		List<ArcPubInfoBean> list = query.getResultList();
		pr.setResults(list);
		pr.setTotalrecord(size);
		return pr;
	}
}
