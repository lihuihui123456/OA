//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：张多一$手机：18701386200#
// SVN版本号                    日   期                 作     者              变更记录
// BorrInforImpl-001     2016/12/28   张多一                  新建
//*********************************************************************
package com.yonyou.aco.arc.borr.dao.impl;

import javax.persistence.Query;

import org.apache.commons.lang.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.borr.dao.IBorrInforDao;
import com.yonyou.aco.arc.borr.entity.IWebDocumentBean;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;

/**
 * <p>概述：借阅管理dao层接口实现类
 * <p>功能：在dao层获取数据
 * <p>作者：张多一
 * <p>创建时间：2016-12-28
 * <p>类调用特殊情况：无
 */
@Repository
public class BorrInforImpl extends BaseDao implements IBorrInforDao {

	@SuppressWarnings("unchecked")
	@Override
	public PageResult<IWebDocumentBean> listEnclosureAndTitle(int pagenum,
			int pagesize,String wheresql) {
		int firstindex = 0;
		if (pagenum > 0) {
			firstindex = (pagenum - 1) * pagesize; // 从第几条数据开始取数据
		};
		int maxresult = pagesize; // 页大小
		PageResult<IWebDocumentBean> pr = new PageResult<IWebDocumentBean>();
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT a.ARC_ID arcId,a.ARC_NAME arcName,b.id_ id,b.file_name fileName from biz_arc_pub_info a ");
		sb.append("INNER JOIN iweb_document b on a.ARC_ID=b.table_id ");
		sb.append("where a.DR='N' and a.IS_INVALID='0' AND a.FILE_START AND a.expiry_date_time > sysdate() ");
		if(StringUtils.isNotEmpty(wheresql)){
			sb.append(wheresql);
		}
		sb.append(" order by a.FILE_TIME DESC ");
		Query query  =  em.createNativeQuery(sb.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(IWebDocumentBean.class));
		long size = query.getResultList().size();// 总数据长度
		/** 通过传过来的页码*每页显示条数和总数进行对比 判断第一条数据的取值 **/
		if (firstindex >= size) {
			if (size > pagesize) {
				query.setFirstResult(((int) size / pagesize - 1) * pagesize)
						.setMaxResults(maxresult);
			} else {
				query.setFirstResult(0).setMaxResults(maxresult);
			}
		} else {
			query.setFirstResult(firstindex).setMaxResults(maxresult);
		}
		pr.setResults(query.getResultList());
		pr.setTotalrecord(size);
		return pr;
	}
}
