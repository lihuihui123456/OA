package com.yonyou.aco.earc.seddread.dao.impl;

import java.util.List;

import javax.persistence.Query;

import org.apache.commons.lang.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.earc.seddread.dao.IEarcSeddRedDao;
import com.yonyou.aco.earc.seddread.entity.EarcSeddRedBean;
import com.yonyou.aco.earc.seddread.entity.EarcSeddRedListQuery;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;


@Repository("earcSeddRedDao")
public class EarcSeddRedDaoImpl extends BaseDao implements IEarcSeddRedDao {

	@SuppressWarnings("unchecked")
	@Override
	public PageResult<EarcSeddRedBean> pageEarcSeddRedBeanList(int pageNum,
			int pageSize, EarcSeddRedListQuery earcSeddRedListQuery) {
/*		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
*/		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<EarcSeddRedBean> pr = new PageResult<EarcSeddRedBean>();
		StringBuffer sb = new StringBuffer();
		sb.append("select  brbi.id_,brbi.SOL_ID_ solId,brbi.biz_title_ ,ebi.SECURITY_LEVEL security_level ,"
				+ "esri.RECEIVE_USER receive_user,esri.SEND_USER send_user,esri.START_DATE start_date"
				+ " from bpm_ru_biz_info brbi left join earc_sedd_red_info esri on esri.earc_id=brbi.id_"
				+ " left join  earc_biz_info ebi on ebi.earc_id=brbi.id_  where 1=1 ");
		if (StringUtils.isNotBlank(earcSeddRedListQuery.getSolId())) {
			sb.append(" and  brbi.sol_id_ ='"+earcSeddRedListQuery.getSolId()+"'");
		}
		if (StringUtils.isNotBlank(earcSeddRedListQuery.getBiz_title_())) {
			sb.append(" and  brbi.biz_title_  like '%"+earcSeddRedListQuery.getBiz_title_()+"%'");
		}
		if (StringUtils.isNotBlank(earcSeddRedListQuery.getSecurity_level())) {
			sb.append(" and  ebi.SECURITY_LEVEL  = '"+earcSeddRedListQuery.getSecurity_level()+"'");
		}
		if (StringUtils.isNotBlank(earcSeddRedListQuery.getReceive_user())) {
			sb.append(" and  esri.RECEIVE_USER  like '%"+earcSeddRedListQuery.getReceive_user()+"%'");
		}
		if (StringUtils.isNotBlank(earcSeddRedListQuery.getReceive_user())) {
			sb.append(" and  esri.SEND_USER  like '%"+earcSeddRedListQuery.getSend_user()+"%'");
		}
		if (StringUtils.isNotBlank(earcSeddRedListQuery.getStartTime())) {
			sb.append(" and  esri.START_DATE  >= '"+earcSeddRedListQuery.getStartTime()+"'");
		}
		if (StringUtils.isNotBlank(earcSeddRedListQuery.getEndTime())) {
			sb.append(" and  esri.START_DATE  <= '"+earcSeddRedListQuery.getEndTime()+"'");
		}
		if(StringUtils.isNotBlank(earcSeddRedListQuery.getSortName())&&StringUtils.isNotBlank(earcSeddRedListQuery.getSortOrder())){
			sb.append(" order by CONVERT(");
			sb.append(earcSeddRedListQuery.getSortName()+" USING gbk) "+earcSeddRedListQuery.getSortOrder());
		}
		else{
			sb.append(" order by esri.START_DATE desc");
		}
		Query query = em.createNativeQuery(sb.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(EarcSeddRedBean.class));
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

		List<EarcSeddRedBean> list = query.getResultList();
		pr.setResults(list);
		pr.setTotalrecord(size);
		return pr;
	}
	@SuppressWarnings("unchecked")
	@Override
	public PageResult<EarcSeddRedBean> pageEarcSeddRedBeanList(int pageNum,
			int pageSize) {
/*		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
*/		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<EarcSeddRedBean> pr = new PageResult<EarcSeddRedBean>();
		StringBuffer sb = new StringBuffer();
		sb.append("select brbi.id_,brbi.biz_title_ ,ebi.SECURITY_LEVEL security_level ,esri.RECEIVE_USER receive_user,esri.SEND_USER send_user,esri.START_DATE start_date from bpm_ru_biz_info brbi left join earc_sedd_red_info esri on esri.earc_id=brbi.id_ left join  earc_biz_info ebi on ebi.earc_id=brbi.id_ where brbi.dr_='N' and ebi.earc_state='0' ");
			sb.append(" order by esri.START_DATE desc");
		Query query = em.createNativeQuery(sb.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(EarcSeddRedBean.class));
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

		List<EarcSeddRedBean> list = query.getResultList();
		pr.setResults(list);
		pr.setTotalrecord(size);
		return pr;
	}
}
