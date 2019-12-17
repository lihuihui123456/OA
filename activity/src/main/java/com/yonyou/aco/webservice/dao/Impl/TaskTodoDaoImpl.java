package com.yonyou.aco.webservice.dao.Impl;

import java.util.List;
import javax.persistence.Query;
import org.apache.commons.lang.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;
import com.yonyou.aco.webservice.dao.ITaskTodoDao;
import com.yonyou.cap.bpm.entity.TaskBean;
import com.yonyou.cap.common.base.impl.BaseDao;

@Repository("taskTodoDao")
public class TaskTodoDaoImpl extends BaseDao implements ITaskTodoDao{
	public int getTaskList(String userid){
		int number=0;
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT a.BIZ_TITLE_ name_ ");
		sb.append("FROM bpm_ru_biz_info a ");
		sb.append("LEFT JOIN act_ru_task b ON a.proc_inst_id_ = b.proc_inst_id_ ");
		sb.append("LEFT JOIN act_hi_taskinst c on b.PARENT_TASK_ID_=c.ID_ ");
		sb.append("LEFT JOIN isc_user d on c.ASSIGNEE_=d.USER_ID ");
		sb.append("WHERE b.assignee_ =:assignee_ ");
		sb.append("AND b.suspension_state_ = 1 ");
		sb.append("union all ");
		sb.append("SELECT a.BIZ_TITLE_ name_ ");
		sb.append("from biz_gw_circulars h LEFT JOIN bpm_ru_biz_info a on h.bizid=a.ID_ LEFT JOIN act_ru_task b ON a.proc_inst_id_ = b.proc_inst_id_ ");
		sb.append("LEFT JOIN act_hi_taskinst c ON b.PARENT_TASK_ID_ = c.ID_ ");
		sb.append("LEFT JOIN isc_user d ON c.ASSIGNEE_ = d.USER_ID WHERE h.view_man=:view_man ");
		sb.append("AND h.isread='0'  AND (a.state_='1' or a.state_='2') GROUP BY b.PROC_INST_ID_ ");
		sb.append("union all ");
		sb.append("SELECT a.BIZ_TITLE_ name_ ");
		sb.append("FROM bpm_ru_biz_info a ");
		sb.append("LEFT JOIN act_ru_task b ON a.proc_inst_id_ = b.proc_inst_id_ ");
		sb.append("LEFT JOIN act_hi_taskinst c on b.PARENT_TASK_ID_=c.ID_ ");
		sb.append("LEFT JOIN isc_user d on c.ASSIGNEE_=d.USER_ID ");
		sb.append("WHERE b.OWNER_ =:OWNER_ ");
		sb.append("AND b.suspension_state_ = 1 AND b.OWNER_ is not null");
		Query query  =  em.createNativeQuery(sb.toString());
		if(StringUtils.isNotEmpty(userid)){
			query.setParameter("assignee_", userid);
			query.setParameter("view_man", userid);
			query.setParameter("OWNER_", userid);
			setQueryParams(query, null);
			query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(TaskBean.class));	
			long size = query.getResultList().size();// 总数据长度
			number=(int)size;
		}
		return number;
	}
	
	protected void setQueryParams(Query query, Object[] queryParams) {
		if (null != queryParams && 0 < queryParams.length) {
			for (int i = 0; i < queryParams.length; i++) {
				query.setParameter(i + 1, queryParams[i]);
			}
		}
	}
	@SuppressWarnings("unchecked")
	public String getUserId(String acctlogin){
		 String userId="";
		 String sql="select USER_ID from isc_user where dr='N' and ACCT_LOGIN=?";
		 Query query = em.createNativeQuery(sql).setParameter(1, acctlogin);
		 List<String> list = query.getResultList();
		 if(list!=null && list.size()>0) {
			 userId = list.get(0);
			}
		 return userId;
	 }
}
