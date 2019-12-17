package com.yonyou.aco.arc.prj.dao.impl;

import java.util.List;

import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.prj.dao.IArcPrjDao;
import com.yonyou.aco.arc.prj.entity.ArcPrjBean;
import com.yonyou.cap.common.base.impl.BaseDao;

/**
 * 
 * TODO: 工程基建档案dao实现类 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月29日
 * @author hegd
 * @since 1.0.0
 */
@Repository("arcPrjDao")
public class ArcPrjDaoImpl extends BaseDao implements IArcPrjDao {

	@SuppressWarnings("unchecked")
	@Override
	public ArcPrjBean findArcPrjByArcId(String arcId, String fileStart) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT p.ID id,p.ARC_ID arcId, p.REG_USER regUser,p.REG_TIME regTime,"
				+ "p.REG_DEPT regDept,t.TYPE_NAME arcType,"
				+ "p.ARC_NAME arcName,p.KEY_WORD keyWord,p.DEP_POS depPos,"
				+ "p.EXPIRY_DATE expiryDate,p.REMARKS remarks,p.FILE_TIME fileTime,");
		if ("1".equals(fileStart) || "1" == fileStart) {
			sb.append("u.USER_NAME fileUser,");
		} else {
			sb.append("p.FILE_USER fileUser,");
		}
		sb.append("a.PRJ_NAME prjName,a.PRJ_ADD prjAdd,"
				+ "a.PRJ_NBR prjNbr,a.PRJ_USER prjUser FROM biz_arc_prj_cstr a,"
				+ "biz_arc_pub_info p INNER JOIN biz_arc_type_info t ON t.ID = p.ARC_TYPE");
		if ("1".equals(fileStart) || "1" == fileStart) {
			sb.append(" INNER JOIN isc_user u ON u.USER_ID = p.FILE_USER");
		}
		sb.append(" WHERE p.ARC_ID = a.ARC_ID AND a.ARC_ID='" + arcId + "'");
		Query query = em.createNativeQuery(sb.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcPrjBean.class));
		List<ArcPrjBean> list = query.getResultList();
		return list.get(0);
	}

}
