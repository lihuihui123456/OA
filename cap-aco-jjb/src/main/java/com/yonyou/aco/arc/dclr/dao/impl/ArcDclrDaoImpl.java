package com.yonyou.aco.arc.dclr.dao.impl;

import java.util.List;

import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.dclr.dao.IArcDclrDao;
import com.yonyou.aco.arc.dclr.entity.ArcDclrBean;
import com.yonyou.cap.common.base.impl.BaseDao;

@Repository("arcDclrDao")
public class ArcDclrDaoImpl extends BaseDao  implements IArcDclrDao{

	@SuppressWarnings("unchecked")
	@Override
	public ArcDclrBean findArcDclrByArcId(String arcId,String fileStart) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT p.ID id, d.ARC_ID arcId,p.REG_USER regUser,p.REG_TIME regTime,"
				+ "p.REG_DEPT regDept,t.ID arcTypeId,t.TYPE_NAME arcType,p.ARC_NAME arcName,"
				+ "d.DEC_TIME decTime,d.PRO_NAME proName,d.BEAR_DEPT bearDept,"
				+ "d.DEC_USER decUser,d.DEC_MNY decMny,d.PRO_COM proCom,p.EXPIRY_DATE expiryDate,"
				+ "p.KEY_WORD keyWord,p.REMARKS remarks,");
		if(fileStart.equals("1")||"1"==fileStart){
			sb.append("u.USER_NAME fileUser,");
		}else{
			sb.append("p.FILE_USER fileUser,");
		}
		sb.append("p.FILE_TIME fileTime, p.DEP_POS depPos FROM biz_arc_dclr_ifno d,"
				+ "biz_arc_pub_info p INNER JOIN biz_arc_type_info t ON t.ID = p.ARC_TYPE ");
		if(fileStart.equals("1")|| "1"==fileStart){
			sb.append(" INNER JOIN isc_user u ON u.USER_ID = p.FILE_USER ");
		}
		sb.append(" where p.ARC_ID = d.ARC_ID");
		sb.append(" AND p.ARC_ID ='"+arcId+"'");
		sb.append(" ORDER BY p.REG_TIME DESC");
		Query query = em.createNativeQuery(sb.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcDclrBean.class));
		List<ArcDclrBean> list = query.getResultList();
		return list.get(0);
	}


}
