package com.yonyou.aco.arc.inv.dao.impl;

import java.util.List;

import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.inv.dao.IArcInvDao;
import com.yonyou.aco.arc.inv.entity.ArcInvBean;
import com.yonyou.cap.common.base.impl.BaseDao;

/**
 * 
 * TODO: 项目投资档案dao实现类 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月29日
 * @author hegd
 * @since 1.0.0
 */
@Repository("arcInvDao")
public class ArcInvDaoImpl extends BaseDao implements IArcInvDao {

	@SuppressWarnings("unchecked")
	@Override
	public ArcInvBean findArcInvByArcId(String arcId, String fileStart) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT p.ID id,p.ARC_ID arcId,p.REG_USER regUser,p.REG_DEPT regDept,p.REG_TIME regTime,"
				+ "t.TYPE_NAME arcType,p.ARC_NAME arcName,a.PRO_NAME proName,"
				+ "a.MNY mny,a.INV_PRO invPro,trim(a.INV_TYPE) invType,trim(p.IS_INVALID) isInvalid,"
				+ "a.INV_TIME invTime,a.BANK_SRC bankSrc,a.INV_INCM invIncm,"
				+ "a.INV_DEAL invDeal,a.PRO_SOURCE proSource,a.PRO_MNY proMny,"
				+ "a.START_TIME startTime,a.END_TIME endTime,a.LEGAL_PRSN legalPrsn,"
				+ "a.INV_REG_TIME invRegTime,a.REG_CAP regCap,a.DIR dir,a.SPVS spvs,"
				+ "a.REG_ADD regAdd,a.MAIN_CORE mainCore,p.KEY_WORD keyWord,"
				+ "p.DEP_POS depPos,p.EXPIRY_DATE expiryDate,p.REMARKS remarks,");
		if ("1".equals(fileStart) || "1" == fileStart) {
			sb.append("u.USER_NAME fileUser,");
		} else {
			sb.append("p.FILE_USER fileUser,");
		}
		sb.append("p.FILE_TIME fileTime "
				+ "FROM biz_arc_inv_info a,biz_arc_pub_info p INNER JOIN biz_arc_type_info t"
				+ " ON t.ID = p.ARC_TYPE  ");
		if ("1".equals(fileStart) || "1" == fileStart) {
			sb.append("INNER JOIN isc_user u ON u.USER_ID = p.FILE_USER ");
		}
		sb.append("WHERE p.ARC_ID = a.ARC_ID");
		sb.append(" AND a.ARC_ID='" + arcId + "'");
		Query query = em.createNativeQuery(sb.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcInvBean.class));
		List<ArcInvBean> list = query.getResultList();
		return list.get(0);
	}

}
