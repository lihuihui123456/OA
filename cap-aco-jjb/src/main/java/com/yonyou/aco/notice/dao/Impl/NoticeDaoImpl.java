package com.yonyou.aco.notice.dao.Impl;

import java.util.List;

import javax.persistence.Query;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Component;

import com.yonyou.aco.notice.dao.NoticeDao;
import com.yonyou.aco.notice.entity.BizNoticeInfoEntity;
import com.yonyou.aco.notice.entity.BizNoticePeopleEntity;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;


@Component("noticeDao")
public class NoticeDaoImpl extends BaseDao implements NoticeDao {

	@SuppressWarnings("unchecked")
	@Override
	public BizNoticePeopleEntity findCount(String id) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT count(1) as col1,IFNULL(Convert(SUM(case when t.status = '1' then 1 else 0 end) , SIGNED),0) AS col2, "
				+ " IFNULL(Convert(SUM(case when t.status = '0' then 1 else 0 end) , SIGNED),0) AS col3 from biz_notice_people t where t.bid = :bid");
		Query query  =  em.createNativeQuery(sb.toString());
		query.setParameter("bid", id);
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BizNoticePeopleEntity.class));
		List<BizNoticePeopleEntity> link = query.getResultList();
		if (link != null && link.size() != 0) {
			return link.get(0);
		}
		return null;
	}

	@Override
	public BizNoticePeopleEntity queryPeopleById(String id, String uid) {
		String sql = "SELECT * FROM biz_notice_people WHERE bid=:bid and receive_uid=:uid";
		Query  query = em.createNativeQuery(sql,BizNoticePeopleEntity.class);
		query.setParameter("bid", id);
		query.setParameter("uid", uid);
		return (BizNoticePeopleEntity) query.getResultList().get(0);
	}

	@Override
	public PageResult<BizNoticeInfoEntity> findJsNoticeList(int pageNum, int pageSize,
			String userid, String query,String where) {
		StringBuffer sb = new StringBuffer();
		sb.append("select bb.id_ id,bc.id_ bid,bb.title ,bb.sender,bb.create_time as creationtime,bc.status as status"
				+ " from biz_notice_info bb LEFT JOIN biz_notice_people bc on bb.id_ = bc.bid "
				+ " where bc.receive_uid =  '"+userid+"' and bb.title like '%"+query+"%' ");
		if (where != null && !"".equals(where)) {
			sb.append(where);
		}
		sb.append("order by bb.create_time desc");
		return this.getPageData(BizNoticeInfoEntity.class, pageNum, pageSize,sb.toString());
	}

	@SuppressWarnings("unchecked")
	@Override
	public PageResult<BizNoticePeopleEntity> findNoticeAllPeopleinfo(String id) {
		String sql = "SELECT bc.id_,bc.bid,u.USER_NAME as receive_uid,bc.send_uid,bc.send_time, "
				+ "bc.finish_time,bc.status FROM biz_notice_people bc "
				+ "INNER JOIN ISC_USER u ON  bc.receive_uid = u.USER_ID AND  bc.bid=?";
		Query  query = em.createNativeQuery(sql,BizNoticePeopleEntity.class);
		query.setParameter(1, id);
		List<BizNoticePeopleEntity> list = (List<BizNoticePeopleEntity>)query.getResultList();
		PageResult<BizNoticePeopleEntity> pages = new PageResult<BizNoticePeopleEntity>();
		pages.setResults(list);
		
		return pages;
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
	@SuppressWarnings({ "unchecked", "unused" })
	public <T> PageResult<T> getPageData(Class<T> entityClass, int pageNum,int pageSize, String sql) {
		int firstindex = 0;
		if (pageNum > 0) {   
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<T> pr = new PageResult<T>();
		Query query = em.createNativeQuery(sql);
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(entityClass));
		List<T> list1 = query.getResultList();
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

	@SuppressWarnings("unchecked")
	@Override
	public List<BizNoticeInfoEntity> queryBizNoticeInfoEntity() {
		String sql = "SELECT * FROM biz_notice_info WHERE status=1";
		Query  query = em.createNativeQuery(sql,BizNoticeInfoEntity.class);
		return (List<BizNoticeInfoEntity>)query.getResultList();
	}
	@Override
	public PageResult<BizNoticeInfoEntity> findNoticeData(int pageNum, int pageSize,
			String userid, String query,String where) {
		StringBuffer sb = new StringBuffer();
		sb.append("select bb.id_ id,bc.id_ bid,bb.title ,bb.sender,bb.create_time as creationtime,bc.status as status"
				+ " from biz_notice_info bb LEFT JOIN biz_notice_people bc on bb.id_ = bc.bid "
				+ " where bc.receive_uid =  '"+userid+"' and bb.title like '%"+query+"%' AND bc.STATUS='0'");
		if (where != null && !"".equals(where)) {
			sb.append(where);
		}
		sb.append("order by bb.create_time desc");
		return this.getPageData(BizNoticeInfoEntity.class, pageNum, pageSize,sb.toString());
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<BizNoticeInfoEntity> findNoticeList(int num,String userid){
		StringBuffer sb = new StringBuffer();
		sb.append("select bb.id_ id,bc.id_ bid,bb.title ,bb.sender,bb.create_time as creationtime,bc.status as status"
				+ " from biz_notice_info bb LEFT JOIN biz_notice_people bc on bb.id_ = bc.bid "
				+ " where bc.receive_uid =? AND bc.STATUS='0' order by bb.create_time desc limit ?");
		Query query = em.createNativeQuery(sb.toString());
		query.setParameter(1, userid).setParameter(2, num);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(BizNoticeInfoEntity.class));
		return query.getResultList();
	}

}
 