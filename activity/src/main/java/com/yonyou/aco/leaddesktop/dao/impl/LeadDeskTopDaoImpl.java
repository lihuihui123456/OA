package com.yonyou.aco.leaddesktop.dao.impl;

import java.math.BigInteger;
import java.util.List;

import javax.annotation.Resource;
import javax.persistence.Query;

import org.apache.commons.lang.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.leaddesktop.dao.LeadDeskTopDao;
import com.yonyou.aco.leaddesktop.entity.LeadDktpMenuEntity;
import com.yonyou.aco.leaddesktop.entity.LeadDktpYjEntity;
import com.yonyou.cap.bpm.entity.DeskTaskBean;
import com.yonyou.cap.bpm.entity.TaskNodeBean;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.isc.menu.dao.IModuleDao;
import com.yonyou.cap.isc.menu.entity.Module;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
@Repository("LeadDeskTopDao")
public class LeadDeskTopDaoImpl extends BaseDao implements LeadDeskTopDao{
	@Resource
	IModuleDao moduleDao;
	@Override
	public void saveLeadDktpEntity(LeadDktpMenuEntity entity) {
		em.merge(entity);
	}

	@Override
	public Module getModuleById(String ModuleId) {
		Module module=moduleDao.findEntityByPK(Module.class, ModuleId);
		return module;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String isChecked(String ModuleId) throws Exception {
		StringBuffer sb = new StringBuffer();
		sb.append("select count(1) from leaddkt_menu where mod_id=:mod_id");
		Query query  =  em.createNativeQuery(sb.toString());
		query.setParameter("mod_id", ModuleId);
		List<BigInteger> list=query.getResultList();
		String isChecked="unchecked";
		if(list.size()>0){
			isChecked=list.get(0).equals(BigInteger.ZERO)?"unchecked":"checked";
		}
		return isChecked;
	}

	@Override
	public void removeCustomMenu(String modId,ShiroUser user) throws Exception {
		StringBuffer sb = new StringBuffer();
		sb.append("delete from leaddkt_menu where mod_id=:mod_id and user_id=:user_id");
		Query query  =  em.createNativeQuery(sb.toString());
		query.setParameter("mod_id", modId);
		query.setParameter("user_id", user.getUserId());
		query.executeUpdate();
	}

	@Override
	public void removeAll(ShiroUser user) throws Exception {
		StringBuffer sb = new StringBuffer();
		sb.append("delete from leaddkt_menu where user_id=:user_id");
		Query query  =  em.createNativeQuery(sb.toString());
		query.setParameter("user_id", user.getUserId());
		query.executeUpdate();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<LeadDktpMenuEntity> getChecked(ShiroUser user) throws Exception {
		StringBuffer sb = new StringBuffer();
		sb.append("select mod_id as modId,mod_name as modName,mod_url as modUrl,mod_icon as modIcon,"
				+ "sort,user_id as userId from leaddkt_menu where user_id=:user_id");
		Query query  =  em.createNativeQuery(sb.toString());
		query.setParameter("user_id", user.getUserId());
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(LeadDktpMenuEntity.class));
		return query.getResultList();
	}

	/**
	 * 查询处理意见
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public LeadDktpYjEntity findYj(String clyj,ShiroUser user) throws Exception{
		StringBuffer sb = new StringBuffer();
		sb.append("select leader_comment as leaderComment,id_ id , yj_count as yjCount ,user_id as userId "
				+ " from leader_opinion where user_id=:user_id and leader_comment=:leader_comment ");
		Query query  =  em.createNativeQuery(sb.toString());
		query.setParameter("user_id", user.getUserId());
		query.setParameter("leader_comment", clyj);
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(LeadDktpYjEntity.class));
		List<LeadDktpYjEntity> list = query.getResultList();
		if(list.size()>0){
			LeadDktpYjEntity lead = list.get(0);
			return lead;
		}else{
			return null ;
		}
	}

	/**
	 * 查找所有处理意见
	 * @throws Exception
	 */
	@Override
	@SuppressWarnings("unchecked")
	public List<LeadDktpYjEntity> findAllComment(String userId)
			throws Exception {
		StringBuffer sb = new StringBuffer();
		sb.append("select leader_comment as leaderComment,id_ id , yj_count as yjCount ,user_id as userId "
				+ " from leader_opinion where user_id=:user_id  order by yj_count desc");
		Query query  =  em.createNativeQuery(sb.toString());
		query.setParameter("user_id", userId);
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(LeadDktpYjEntity.class));
		List<LeadDktpYjEntity> list = query.getResultList();
		return list;
	}
	@SuppressWarnings("unchecked")
	public List<DeskTaskBean> findDeskTaskList(String bizid,String userid){
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT t2.id_ taskId,t1.SOL_ID_ solid,t1.PROC_INST_ID_ procinst_id,t1.ID_ bizid,t1.ID_ id,t1.BIZ_TITLE_ taskname,t1.CREATE_TIME_ creattime,t3.USER_NAME createuser from ");
		sb.append("bpm_ru_biz_info t1,act_ru_task t2,isc_user t3 ");
		sb.append("WHERE t1.PROC_INST_ID_ = t2.PROC_INST_ID_ and t1.CREATE_USER_ID_=t3.USER_ID ");
		sb.append("AND t1.id_ =? ");
		sb.append("AND t2.suspension_state_ = 1");
		sb.append(" and (t2.assignee_=? or t2.owner_=?)");
		sb.append(" order by t2.CREATE_TIME_ desc");
		Query query = em.createNativeQuery(sb.toString());
		query.setParameter(1, bizid).setParameter(2, userid).setParameter(3, userid);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(DeskTaskBean.class));
		return query.getResultList();
	}
	@SuppressWarnings("unchecked")
	public String findActTypeByActId(String actId){
		String actType="";
		if(StringUtils.isNotEmpty(actId)){
			String sql="SELECT ACT_TYPE_ actType FROM BPM_RE_NODE_INFO WHERE ACT_ID_ =?";
			Query query  =  em.createNativeQuery(sql).setParameter(1,actId);;
			query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(TaskNodeBean.class));
			List<TaskNodeBean> list = query.getResultList();
			if(list.size()>0){
				actType=list.get(0).getActType();
			}
		}
		return actType;
	}
}
