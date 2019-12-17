package com.yonyou.aco.arc.intl.dao.impl;

import java.util.List;

import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.intl.dao.IArcIntlDao;
import com.yonyou.aco.arc.intl.entity.ArcIntlBean;
import com.yonyou.cap.common.base.impl.BaseDao;

/**
 * 
 * TODO: 内部项目dao实现类 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月29日
 * @author hegd
 * @since 1.0.0
 */
@Repository("arcIntlDao")
public class ArcIntlDaoImpl extends BaseDao implements IArcIntlDao {

	@SuppressWarnings("unchecked")
	@Override
	public ArcIntlBean findArcIntlByArcId(String arcId,String fileStart) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT p.ID Id,p.ARC_ID arcId,p.REG_USER regUser,p.REG_TIME regTime,"
				+ "p.REG_DEPT regDept,t.TYPE_NAME arcType,t.ID arcTypeId,p.ARC_NAME arcName,"
				+ "p.KEY_WORD keyWord,p.DEP_POS depPos,p.EXPIRY_DATE expiryDate,"
				+ "p.REMARKS remarks,p.FILE_TIME fileTime,");
		if(fileStart.equals("1") || "1"==fileStart){
			sb.append("u.USER_NAME fileUser,");
		}else{
			sb.append("p.FILE_USER fileUser,");
		}
		sb.append("a.DOC_NBR docNbr,a.PRO_NAME proName,a.AGR_NBR agrNbr"
				+ " FROM biz_arc_intl_info a,biz_arc_pub_info p INNER JOIN "
				+ "biz_arc_type_info t ON t.ID = p.ARC_TYPE ");
		if(fileStart.equals("1") || "1"==fileStart){
			sb.append(" INNER JOIN  isc_user u ON u.USER_ID = p.FILE_USER ");
		}
		sb.append(" WHERE p.ARC_ID = a.ARC_ID AND a.ARC_ID='"+arcId+"'");
		Query query = em.createNativeQuery(sb.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcIntlBean.class));
		List<ArcIntlBean> list = query.getResultList();
		return list.get(0);
	}

}
