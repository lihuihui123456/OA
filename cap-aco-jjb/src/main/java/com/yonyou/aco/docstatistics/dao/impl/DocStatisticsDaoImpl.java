package com.yonyou.aco.docstatistics.dao.impl;

import java.util.List;

import javax.persistence.Query;

import org.apache.commons.lang.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.docstatistics.dao.DocStatisticsDao;
import com.yonyou.aco.docstatistics.entity.DocStatisticsBean;
import com.yonyou.aco.docstatistics.util.DataUtil;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;
@Repository("DocStatisticsDao")
public class DocStatisticsDaoImpl extends BaseDao implements DocStatisticsDao{

	@SuppressWarnings("unchecked")
	@Override
	public PageResult<DocStatisticsBean> queryByDeptId(String parentDeptId,int pageNum,int pageSize,String deptName) {
		StringBuilder sql=new StringBuilder();
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		 sql.append("SELECT deptId,deptName,parentDeptId,deptCode,sort,"
		 		+ "concat(draftDocAmount,'') as draftDocAmount,"
		 		+ "concat(commDocAmount,'') as commDocAmount,"
		 		+ "concat(weekDraftDocAmount,'') as weekDraftDocAmount,"
		 		+ "concat(weekcommDocAmount,'') as weekcommDocAmount,"
		 		+ "concat(monthDraftDocAmount,'') as monthDraftDocAmount,"
		 		+ "concat(monthcommDocAmount,'') as monthcommDocAmount FROM (SELECT DEPT_ID AS deptId,DEPT_CODE AS deptCode,DEPT_NAME AS deptName,PARENT_DEPT_ID as parentDeptId,sort,");
		 sql.append(" (SELECT COUNT(1) FROM BPM_RU_BIZ_INFO B INNER JOIN ACT_HI_PROCINST P ON B.PROC_INST_ID_=P.PROC_INST_ID_");
		 sql.append("    WHERE B.DR_='N' AND SUBSTRING(B.BIZ_TYPE_,1,4)='1001' AND SUBSTRING(B.DATA_DEPT_CODE,1,CHAR_LENGTH(DEPT_CODE))=DEPT_CODE) AS draftDocAmount,");
		 sql.append("  (SELECT COUNT(1) FROM BPM_RU_BIZ_INFO B INNER JOIN ACT_HI_PROCINST P ON B.PROC_INST_ID_=P.PROC_INST_ID_");
		 sql.append(" 	INNER JOIN ACT_HI_TASKINST T ON P.PROC_INST_ID_=T.PROC_INST_ID_");
		 sql.append("   WHERE B.DR_='N' AND SUBSTRING(B.BIZ_TYPE_,1,4)='1001' AND SUBSTRING(B.DATA_DEPT_CODE,1,CHAR_LENGTH(DEPT_CODE))=DEPT_CODE) AS commDocAmount,");
		 sql.append("    (SELECT COUNT(1) FROM BPM_RU_BIZ_INFO B INNER JOIN ACT_HI_PROCINST P ON B.PROC_INST_ID_=P.PROC_INST_ID_");
		 sql.append("   WHERE B.DR_='N' AND SUBSTRING(B.BIZ_TYPE_,1,4)='1001' AND B.CREATE_TIME_ BETWEEN '"+DataUtil.getTimesWeekStart()+"' and '"+DataUtil.getTimesWeekEnd()+"' AND SUBSTRING(B.DATA_DEPT_CODE,1,CHAR_LENGTH(DEPT_CODE))=DEPT_CODE) AS weekDraftDocAmount,");
		 sql.append("  (SELECT COUNT(1) FROM BPM_RU_BIZ_INFO B INNER JOIN ACT_HI_PROCINST P ON B.PROC_INST_ID_=P.PROC_INST_ID_");
		 sql.append(" 	INNER JOIN ACT_HI_TASKINST T ON P.PROC_INST_ID_=T.PROC_INST_ID_");
		 sql.append("   WHERE B.DR_='N' AND SUBSTRING(B.BIZ_TYPE_,1,4)='1001' AND B.CREATE_TIME_ BETWEEN '"+DataUtil.getTimesWeekStart()+"' and '"+DataUtil.getTimesWeekEnd()+"' AND SUBSTRING(B.DATA_DEPT_CODE,1,CHAR_LENGTH(DEPT_CODE))=DEPT_CODE) AS weekcommDocAmount,");
		 sql.append("    (SELECT COUNT(1) FROM BPM_RU_BIZ_INFO B INNER JOIN ACT_HI_PROCINST P ON B.PROC_INST_ID_=P.PROC_INST_ID_");
		 sql.append("   WHERE B.DR_='N' AND SUBSTRING(B.BIZ_TYPE_,1,4)='1001' AND B.CREATE_TIME_ BETWEEN '"+DataUtil.getTimesMonthStart()+"' and '"+DataUtil.getTimesMonthEnd()+"' AND SUBSTRING(B.DATA_DEPT_CODE,1,CHAR_LENGTH(DEPT_CODE))=DEPT_CODE) AS monthDraftDocAmount,");
		 sql.append("  (SELECT COUNT(1) FROM BPM_RU_BIZ_INFO B INNER JOIN ACT_HI_PROCINST P ON B.PROC_INST_ID_=P.PROC_INST_ID_");
		 sql.append(" 	INNER JOIN ACT_HI_TASKINST T ON P.PROC_INST_ID_=T.PROC_INST_ID_");
		 sql.append("   WHERE B.DR_='N' AND SUBSTRING(B.BIZ_TYPE_,1,4)='1001' AND B.CREATE_TIME_ BETWEEN '"+DataUtil.getTimesMonthStart()+"' and '"+DataUtil.getTimesMonthEnd()+"' AND SUBSTRING(B.DATA_DEPT_CODE,1,CHAR_LENGTH(DEPT_CODE))=DEPT_CODE) AS monthcommDocAmount");
		 sql.append("   FROM ISC_DEPT WHERE DR='N' GROUP BY DEPT_CODE ) G WHERE  G.parentDeptId = ?"); 
		 if(deptName!=null&&!"".equals(deptName)){
			 sql.append(" AND G.deptName like ?");
		 }
		 sql.append("ORDER BY G.SORT");
		Query query = em.createNativeQuery(sql.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(DocStatisticsBean.class));
		query.setParameter(1, parentDeptId);
		 if(deptName!=null&&!"".equals(deptName)){
			 deptName=StringUtils.trim(deptName);
			 query.setParameter(2, "%"+deptName+"%");
		 }
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
		PageResult<DocStatisticsBean> pr = new PageResult<DocStatisticsBean>();
		pr.setResults(query.getResultList());
		pr.setTotalrecord(size);
		return pr;
	}

	@Override
	public String findOrgIdByUserId(String userId) {
		String sql = "SELECT ORG_ID FROM ISC_USER WHERE USER_ID='" + userId
				+ "'";
		Query query = em.createNativeQuery(sql);
		return query.getSingleResult().toString();
	}

	@SuppressWarnings("unchecked")
	@Override
	public boolean isHasChildDept(String deptId) {
		String sql="SELECT * FROM ISC_DEPT WHERE PARENT_DEPT_ID='"+deptId+"'";
		Query query = em.createNativeQuery(sql);
		List<String> list=query.getResultList();
		if(list.size()>0){
			return true;
		}
		return false;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String getParentDeptId(String deptId) {
		String sql="SELECT PARENT_DEPT_ID FROM ISC_DEPT WHERE DEPT_ID='"+deptId+"'"
				+ " UNION "
				+ " SELECT PARENT_DEPT_ID FROM ISC_DEPT WHERE ORG_ID='"+deptId+"'";
		Query query = em.createNativeQuery(sql);
		List<String> list=query.getResultList();
		if(list.size()>0){
			return query.getSingleResult().toString();
		}
		return "";
	}

	@SuppressWarnings("unchecked")
	@Override
	public PageResult<DocStatisticsBean> queryByOrgId(String orgId,
			int pageNum, int pageSize, String orgName) {
		StringBuilder sql=new StringBuilder();
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		 sql.append("SELECT deptId,deptName,parentDeptId,deptCode,sort,"
		 		+ "concat(draftDocAmount,'') as draftDocAmount,"
		 		+ "concat(commDocAmount,'') as commDocAmount,"
		 		+ "concat(weekDraftDocAmount,'') as weekDraftDocAmount,"
		 		+ "concat(weekcommDocAmount,'') as weekcommDocAmount,"
		 		+ "concat(monthDraftDocAmount,'') as monthDraftDocAmount,"
		 		+ "concat(monthcommDocAmount,'') as monthcommDocAmount FROM (SELECT ORG_ID AS deptId,ORG_CODE AS deptCode,ORG_NAME AS deptName,PARENT_ORG_ID as parentDeptId,sort,");
		 sql.append(" (SELECT COUNT(1) FROM BPM_RU_BIZ_INFO B INNER JOIN ACT_HI_PROCINST P ON B.PROC_INST_ID_=P.PROC_INST_ID_");
		 sql.append("    WHERE B.DR_='N' AND SUBSTRING(B.BIZ_TYPE_,1,4)='1001' AND B.DATA_ORG_ID = ORG_ID) AS draftDocAmount,");
		 sql.append("  (SELECT COUNT(1) FROM BPM_RU_BIZ_INFO B INNER JOIN ACT_HI_PROCINST P ON B.PROC_INST_ID_=P.PROC_INST_ID_");
		 sql.append(" 	INNER JOIN ACT_HI_TASKINST T ON P.PROC_INST_ID_=T.PROC_INST_ID_");
		 sql.append("   WHERE B.DR_='N' AND SUBSTRING(B.BIZ_TYPE_,1,4)='1001' AND B.DATA_ORG_ID = ORG_ID) AS commDocAmount,");
		 sql.append("    (SELECT COUNT(1) FROM BPM_RU_BIZ_INFO B INNER JOIN ACT_HI_PROCINST P ON B.PROC_INST_ID_=P.PROC_INST_ID_");
		 sql.append("   WHERE B.DR_='N' AND SUBSTRING(B.BIZ_TYPE_,1,4)='1001' AND B.CREATE_TIME_ BETWEEN '"+DataUtil.getTimesWeekStart()+"' and '"+DataUtil.getTimesWeekEnd()+"' AND B.DATA_ORG_ID = ORG_ID) AS weekDraftDocAmount,");
		 sql.append("  (SELECT COUNT(1) FROM BPM_RU_BIZ_INFO B INNER JOIN ACT_HI_PROCINST P ON B.PROC_INST_ID_=P.PROC_INST_ID_");
		 sql.append(" 	INNER JOIN ACT_HI_TASKINST T ON P.PROC_INST_ID_=T.PROC_INST_ID_");
		 sql.append("   WHERE B.DR_='N' AND SUBSTRING(B.BIZ_TYPE_,1,4)='1001' AND B.CREATE_TIME_ BETWEEN '"+DataUtil.getTimesWeekStart()+"' and '"+DataUtil.getTimesWeekEnd()+"' AND B.DATA_ORG_ID = ORG_ID) AS weekcommDocAmount,");
		 sql.append("    (SELECT COUNT(1) FROM BPM_RU_BIZ_INFO B INNER JOIN ACT_HI_PROCINST P ON B.PROC_INST_ID_=P.PROC_INST_ID_");
		 sql.append("   WHERE B.DR_='N' AND SUBSTRING(B.BIZ_TYPE_,1,4)='1001' AND B.CREATE_TIME_ BETWEEN '"+DataUtil.getTimesMonthStart()+"' and '"+DataUtil.getTimesMonthEnd()+"' AND B.DATA_ORG_ID = ORG_ID) AS monthDraftDocAmount,");
		 sql.append("  (SELECT COUNT(1) FROM BPM_RU_BIZ_INFO B INNER JOIN ACT_HI_PROCINST P ON B.PROC_INST_ID_=P.PROC_INST_ID_");
		 sql.append(" 	INNER JOIN ACT_HI_TASKINST T ON P.PROC_INST_ID_=T.PROC_INST_ID_");
		 sql.append("   WHERE B.DR_='N' AND SUBSTRING(B.BIZ_TYPE_,1,4)='1001' AND B.CREATE_TIME_ BETWEEN '"+DataUtil.getTimesMonthStart()+"' and '"+DataUtil.getTimesMonthEnd()+"' AND B.DATA_ORG_ID = ORG_ID) AS monthcommDocAmount");
		 sql.append("   FROM ISC_ORG WHERE DR='N' GROUP BY ORG_CODE ) G WHERE  G.deptId = ? "); 
		 if(orgName!=null&&!"".equals(orgName)){
			 sql.append(" AND G.deptName like ?");
		 }
		 sql.append("ORDER BY G.SORT");
		Query query = em.createNativeQuery(sql.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(DocStatisticsBean.class));
		query.setParameter(1, orgId);
		 if(orgName!=null&&!"".equals(orgName)){
			 orgName=StringUtils.trim(orgName);
			 query.setParameter(2, "%"+orgName+"%");
		 }
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
		PageResult<DocStatisticsBean> pr = new PageResult<DocStatisticsBean>();
		pr.setResults(query.getResultList());
		pr.setTotalrecord(size);
		return pr;
	}

}
