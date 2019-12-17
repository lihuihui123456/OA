package com.yonyou.aco.arc.bid.dao.impl;

import java.util.List;

import javax.annotation.Resource;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Service;

import com.yonyou.aco.arc.bid.dao.IArcBidDao;
import com.yonyou.aco.arc.bid.entity.ArcBidBean;
import com.yonyou.cap.common.base.impl.BaseDao;

/**
 * 
 * TODO: 招投标档案Dao实现类. 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月22日
 * @author hegd
 * @since 1.0.0
 */
@Service("arcBidDao")
public class ArcBidDaoImpl extends BaseDao implements IArcBidDao {

	@Resource
	EntityManagerFactory emf;

	@SuppressWarnings("unchecked")
	@Override
	public ArcBidBean findArcBidByArcId(String arcId,String fileStart) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT p.ID id,b.ARC_ID  arcId,b.BID_NAME bidName,b.PRO_NBR proNbr,"
				+ "b.BID_TIME bidTime,b.BID_CO bidCo,b.UNIT_CNTCT_USER unitCntctUser,"
				+ "b.UNIT_CNTCT unitCntct,p.REG_USER regUser,p.REG_TIME regTime,"
				+ "p.REG_DEPT regDept,t.ID arcTypeId,t.TYPE_NAME arcType,"
				+ "p.ARC_NAME arcName,p.KEY_WORD keyWord,p.DEP_POS depPos,");
		if(fileStart.equals("1")||fileStart =="1"){
			sb.append("u.USER_NAME fileUser,");
		}else{
			sb.append("p.FILE_USER fileUser,");
		}
		sb.append("p.FILE_TIME fileTime,p.EXPIRY_DATE expiryDate,"
				+ "p.REMARKS remarks FROM biz_arc_bid_info b,biz_arc_pub_info p "
				+ "INNER JOIN biz_arc_type_info t ON t.ID = p.ARC_TYPE ");
		if(fileStart.equals("1") ||fileStart =="1"){
			sb.append("INNER JOIN isc_user u ON u.USER_ID = p.FILE_USER ");
		}
		sb.append("WHERE p.ARC_ID = b.ARC_ID AND p.ARC_ID ='" + arcId + "'");
		Query query = em.createNativeQuery(sb.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(ArcBidBean.class));
		List<ArcBidBean> list = query.getResultList();
		return list.get(0);
	}
}
