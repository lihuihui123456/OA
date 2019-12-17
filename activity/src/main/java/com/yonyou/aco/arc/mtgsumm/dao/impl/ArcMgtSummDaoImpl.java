//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcMgtSummDaoImpl-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.mtgsumm.dao.impl;

import java.util.List;

import javax.persistence.Query;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.mtgsumm.dao.IArcMgtSummDao;
import com.yonyou.aco.arc.mtgsumm.entity.ArcMtgSummAll;
import com.yonyou.aco.arc.mtgsumm.entity.ArcMtgSummBean;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * <p>
 * 概述：持久模块会议纪要管理 dao实现类
 * <p>
 * 功能：实现对会议纪要管理业务数据处理实现类
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-12-21
 * <p>
 * 类调用特殊情况：无
 */

@Repository("arcMgtSummDao")
public class ArcMgtSummDaoImpl extends BaseDao implements IArcMgtSummDao {

	@SuppressWarnings("unchecked")
	public PageResult<ArcMtgSummBean> pageArcMtgSummEntityList(int pageNum,
			int pageSize, ArcMtgSummAll arcMtgSummAll) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<ArcMtgSummBean> pr = new PageResult<ArcMtgSummBean>();
		StringBuffer sb = new StringBuffer();
		sb.append("select cast(api.is_invalid as CHAR) as is_invalid, api.dep_pos dep_pos, api.reg_time reg_time,api.file_time  file_time ,cast(api.file_start as CHAR) as file_start, api.reg_user reg_user, api.reg_dept reg_dept , api.arc_name  arc_name, ams.arc_id arc_id, ams.ams_name ams_name, ams.ams_time ams_time,ams.ams_emcee ams_emcee,ams.ams_add ams_add,ams.ams_topic ams_topic,ams.smd_dept smd_dept,ams.ilt_dept ilt_dept,ams.data_org_id data_org_id,ams.data_dept_code data_dept_code ,ams.data_user_id data_user_id,ams.tenant_id tenant_id  from  biz_arc_mtg_summ ams LEFT JOIN biz_arc_pub_info api on ams.arc_id = api.arc_id where 1=1 and api.dr='N'and api.is_invalid !=2 and api.expiry_date_time >= sysdate()");
		if(user != null){
			sb.append(" AND ams.DATA_USER_ID='"+user.getUserId()+"'");
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getDataUserId())) {
			sb.append(" and ams.data_user_id =:datauserid");
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getAmsName())) {
			sb.append(" and ams.ams_name like:amsname ");
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getArcType())) {
			sb.append(" and api.arc_type =:arctype ");
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getAmsType())) {
			sb.append(" and ams.ams_type=:amstype ");
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getFileStart())) {
			if(!"2".equalsIgnoreCase(arcMtgSummAll.getFileStart())){
				sb.append(" and api.file_start=:filestart and api.is_invalid!=1  ");
			}else{
				sb.append(" and api.is_invalid=1");
			}
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getDataUserId())) {
			sb.append(" and ams.data_user_id=:datauserid ");
		}
		// 年度
		if (StringUtils.isNotBlank(arcMtgSummAll.getYearNum())) {
			sb.append(" and YEAR(api.reg_time) like:yearnum ");
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getStartRegTime())) {
			sb.append(" and DATE_FORMAT(api.reg_time,'%Y-%m-%d')  >=:startregtime ");
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getEndRegTime())) {
			sb.append(" and DATE_FORMAT(api.reg_time,'%Y-%m-%d')  <=:endregtime ");
		}
		if(StringUtils.isNotBlank(arcMtgSummAll.getAttribute())&&StringUtils.isNotBlank(arcMtgSummAll.getOrderBy())){
			sb.append(" order by CONVERT(");
			sb.append(arcMtgSummAll.getAttribute()+" USING gbk) "+arcMtgSummAll.getOrderBy());
		}
		else{
			sb.append(" order by api.reg_time desc");
		}
		Query query = em.createNativeQuery(sb.toString());
		if (StringUtils.isNotBlank(arcMtgSummAll.getDataUserId())) {
			query.setParameter("datauserid", arcMtgSummAll.getDataUserId());
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getAmsName())) {
			query.setParameter("amsname", "%" + arcMtgSummAll.getAmsName()
					+ "%");
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getArcType())) {
			query.setParameter("arctype", arcMtgSummAll.getArcType());
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getAmsType())) {
			query.setParameter("amstype", arcMtgSummAll.getAmsType());
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getFileStart())) {
			if("2".equalsIgnoreCase(arcMtgSummAll.getFileStart())){
			}else{
				query.setParameter("filestart", arcMtgSummAll.getFileStart());
			}
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getDataUserId())) {
			query.setParameter("datauserid", arcMtgSummAll.getDataUserId());
		}
		// 年度
		if (StringUtils.isNotBlank(arcMtgSummAll.getYearNum())) {
			query.setParameter("yearnum", "%" + arcMtgSummAll.getYearNum());
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getStartRegTime())) {
			query.setParameter("startregtime", arcMtgSummAll.getStartRegTime());
		}
		if (StringUtils.isNotBlank(arcMtgSummAll.getEndRegTime())) {
			query.setParameter("endregtime", arcMtgSummAll.getEndRegTime());
		}
/*		if(StringUtils.isNotBlank(arcMtgSummAll.getAttribute())&&StringUtils.isNotBlank(arcMtgSummAll.getOrderBy())){
			query.setParameter("attribute", arcMtgSummAll.getAttribute()+" "+arcMtgSummAll.getOrderBy());
		}*/
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcMtgSummBean.class));
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

		List<ArcMtgSummBean> list = query.getResultList();
		pr.setResults(list);
		pr.setTotalrecord(size);
		return pr;
	}

}
