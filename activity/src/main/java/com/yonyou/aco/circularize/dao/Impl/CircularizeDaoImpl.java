package com.yonyou.aco.circularize.dao.Impl;

import java.util.List;

import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Component;

import com.yonyou.aco.circularize.dao.CircularizeDao;
import com.yonyou.aco.circularize.entity.BizCircularizeBasicInfoEntity;
import com.yonyou.aco.circularize.entity.BizCircularizeLinkEntity;
import com.yonyou.cap.bpm.entity.DeskTaskBean;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;

@Component("circularizeDao")
public class CircularizeDaoImpl extends BaseDao implements CircularizeDao {

	@Override
	public String queryGTasksstatus(Long id) {
		String sql = "SELECT count(id) FROM biz_circularize_link WHERE bid = "+ id;
		Query  query = em.createNativeQuery(sql);
		return query.getResultList().get(0)+"";
	}

	/**
	 * 个人桌面传阅件
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<DeskTaskBean> findCyLinkList(String userid) {
		
		StringBuffer sb = new StringBuffer();
		sb.append("select bb.id_ id,bb.title taskname,bb.circulated_people createuser,bb.creation_time create_time,"
				+ " '/circularize/queryBasicById_js?type=open&id=' url from biz_circularize_basicinfo bb "
				+ " LEFT JOIN biz_circularize_link bc on bb.id_ = bc.bid where bc.receiveuid =  '"+userid+"' and bc.status='0' "
				+ " order by bb.creation_time desc");
		Query query  =  em.createNativeQuery(sb.toString());
		//query.setParameter(1, userid);
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(DeskTaskBean.class));
		return query.getResultList();
	}

	@SuppressWarnings("rawtypes")
	@Override
	public String getMaxTableid() {
		String sql = "SELECT IFNULL(max(table_id),0) FROM iweb_document";
		Query  query = em.createNativeQuery(sql);
		
		List list = query.getResultList();
		String ret = null;
		int id = 0;
		if(list != null && list.size() != 0){
			ret = query.getResultList().get(0)+"";
			id = Integer.valueOf(ret) + 1;
		}
		return String.valueOf(id);
	}
	
	/**
	 * TODO： 联合分页查询
	 * 
	 * @param entityClass
	 *            根据需要建立的不需要和数据库对应的实体类
	 * @param pageNum
	 *            当前页数
	 * @param pageSize
	 *            每页条目数
	 * @param sql
	 *            查询语句
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public <T> PageResult<T> getPageData(Class<T> entityClass, int pageNum,
			int pageSize, String sql) {
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<T> pr = new PageResult<T>();
		Query query = em.createNativeQuery(sql);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(entityClass));
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

		List<T> list = query.getResultList();
		pr.setResults(list);
		pr.setTotalrecord(size);
		return pr;
	}

	@Override
	public PageResult<BizCircularizeBasicInfoEntity> getAllBasicinfoJs(int pageNum,
			int pageSize, String userid,String query) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT bb.id_ id,bc.id_ AS bid,bb.title,priority,bb.circulated_people,bb.creation_time,bc.STATUS AS status"
				+ " from biz_circularize_basicinfo bb LEFT JOIN biz_circularize_link bc on bb.id_ = bc.bid "
				+ " where bc.receiveuid =  '"+userid+"' and bb.title like '%"+query+"%' order by bb.creation_time desc");
		return this.getPageData(BizCircularizeBasicInfoEntity.class, pageNum, pageSize,sb.toString());
		
	}

	@Override
	public BizCircularizeLinkEntity queryLinkById(String id, String bid) {
		String sql = "SELECT * FROM biz_circularize_link WHERE bid='"+id +"' and receiveuid='"+bid+"'";
		Query  query = em.createNativeQuery(sql,BizCircularizeLinkEntity.class);
		return (BizCircularizeLinkEntity) query.getResultList().get(0);
	}

	@SuppressWarnings("unchecked")
	@Override
	public PageResult<BizCircularizeLinkEntity> getAllLinkinfo(String id) {
		String sql = "SELECT bc.id_,bc.bid,u.user_name as receiveuid,bc.senduid,bc.receivetime,bc.sendtime, "
				+ "bc.circularizestatus,bc.finishtime,bc.importance,bc.status,bc.opinion FROM biz_circularize_link bc "
				+ "INNER JOIN isc_user u ON bc.receiveuid = u.USER_ID AND  bc.bid='"+id+"'";
		Query  query = em.createNativeQuery(sql,BizCircularizeLinkEntity.class);
		List<BizCircularizeLinkEntity> list = (List<BizCircularizeLinkEntity>)query.getResultList();
		PageResult<BizCircularizeLinkEntity> pages = new PageResult<BizCircularizeLinkEntity>();
		pages.setResults(list);
		
		return pages;
	}

	@SuppressWarnings("unchecked")
	@Override
	public BizCircularizeLinkEntity findLinkInfoByUserId(String id, String userid) {
		String sql = "SELECT * FROM biz_circularize_link WHERE receiveuid='"+userid+"' and bid='"+id+"'";
		Query  query = em.createNativeQuery(sql,BizCircularizeLinkEntity.class);
		List<BizCircularizeLinkEntity> list = (List<BizCircularizeLinkEntity>)query.getResultList();
		if(list != null && list.size() != 0){
			return (BizCircularizeLinkEntity) query.getResultList().get(0);
		}else{
			return null;
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public BizCircularizeLinkEntity getCount(String id) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT count(1) AS col1,count(opinion) as col2 ,count(1) - count(opinion) AS col3 "
				+ " FROM biz_circularize_link t where t.bid = '"+id+"'");
		Query query  =  em.createNativeQuery(sb.toString());
		//query.setParameter(1, userid);
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BizCircularizeLinkEntity.class));
		
		List<BizCircularizeLinkEntity> link = query.getResultList();
		if (link != null && link.size() != 0) {
			return link.get(0);
		}
		return null;
	}

}
 