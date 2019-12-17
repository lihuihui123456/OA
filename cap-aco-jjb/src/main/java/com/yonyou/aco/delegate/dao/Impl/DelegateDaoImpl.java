package com.yonyou.aco.delegate.dao.Impl;

import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.annotation.Resource;
import javax.persistence.Query;

import org.apache.commons.lang.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.delegate.dao.IDelegateDao;
import com.yonyou.cap.bpm.entity.BizSolBean;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.role.entity.Role;
import com.yonyou.cap.isc.role.service.IRoleService;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.entity.UserGroup;
import com.yonyou.cap.isc.user.service.IUserGroupService;
import com.yonyou.cap.isc.user.service.IUserService;
@Repository("delegateDao")
public class DelegateDaoImpl extends BaseDao implements IDelegateDao{
	@Resource
	private IUserService iUserService;
	@Resource
	private IRoleService roleService;
	@Resource
	private IUserGroupService userGroupService;
	@SuppressWarnings("unchecked")
	public PageResult<BizSolBean> findSolList(int pageNum, int pageSize,String userid,String title){
		  User user=iUserService.findUserById(userid);
		  List<Role> findRolesByUserId = roleService.findRolesByUserId(userid);
		 String roleIds="";
		  for(int i=0;i<findRolesByUserId.size(); i++){
			 if(i==0){
				 roleIds="'"+findRolesByUserId.get(i).getRoleId()+"'";
						 
			 }else{
				 roleIds=roleIds+",'"+ findRolesByUserId.get(i).getRoleId()+"'";
			 }
		 }
		  List<UserGroup> findUserGroupListByUserId = userGroupService.findUserGroupListByUserId(userid);
			 String groupIds="";
			  for(int i=0;i<findUserGroupListByUserId.size(); i++){
				 if(i==0){
					 groupIds="'"+findUserGroupListByUserId.get(i).getUserGroupId()+"'";
							 
				 }else{
					 groupIds=groupIds+",'"+ findUserGroupListByUserId.get(i).getUserGroupId()+"'";
				 }
			 }
		  int firstindex = 0;
		    if (pageNum > 0) {
		      firstindex = (pageNum - 1) * pageSize;
		    }
		    int maxresult = pageSize;
		    PageResult<BizSolBean> pr = new PageResult<BizSolBean>();
		    StringBuffer sb = new StringBuffer();
		    sb.append("select b.id_ sol_id,b.sol_name_ sol_name from bpm_re_sol_info b left join bpm_re_node_user u ");
		    sb.append("on u.sol_id_=b.id_ where  b.dr_='N'  ");
		    if (StringUtils.isNotEmpty(title)){
				try {
					title = new String(title.getBytes("iso-8859-1"), "utf-8");
					sb.append(" and b.sol_name_ like '%"+title+"%'");
				} catch (UnsupportedEncodingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		    if (StringUtils.isNotEmpty(user.getUserId())){
				sb.append(" and ((u.user_type_='2' and u.user_value_='"+user.getUserId()+"')");
			}
		    if (StringUtils.isNotEmpty(roleIds)){
					sb.append(" or (u.user_type_='6' and u.user_value_ in ("+roleIds+"))");
				}
		    if (StringUtils.isNotEmpty(groupIds)){
				sb.append(" or (u.user_type_='3' and u.user_value_ in ("+groupIds+"))");
				}
		    if (StringUtils.isNotEmpty(user.getPostId())){
						sb.append(" or (u.user_type_='5' and u.user_value_='"+user.getPostId()+"')");
						}
		    if (StringUtils.isNotEmpty(user.getDeptId())){
						sb.append(" or (u.user_type_='4' and u.user_value_='"+user.getDeptId()+"'))");
						}
		    sb.append(" GROUP BY b.id_  order by b.ts_ desc ");
		    Query query = this.em.createNativeQuery(sb.toString());
		/*    query.setParameter(1, user.getUserId());
		    query.setParameter(2, user.get);
		    query.setParameter(3, user.getDeptId());
		    query.setParameter(3, user.getPostId());
		    query.setParameter(4, userid);*/
		    ((SQLQuery)query.unwrap(SQLQuery.class)).setResultTransformer(Transformers.aliasToBean(BizSolBean.class));
		    long size = query.getResultList().size();

		    if (firstindex >= size) {
		      if (size > pageSize)
		        query.setFirstResult(((int)size / pageSize - 1) * pageSize).setMaxResults(maxresult);
		      else
		        query.setFirstResult(0).setMaxResults(maxresult);
		    }
		    else {
		      query.setFirstResult(firstindex).setMaxResults(maxresult);
		    }
		    pr.setResults(query.getResultList());
		    pr.setTotalrecord(size);
		    return pr;
	}
	    @SuppressWarnings("unchecked")
		public List<BizSolBean> findSolRelations(String delegateId) {
	    	Query query=null;
			try{
				StringBuffer sb= new StringBuffer();
				sb.append("SELECT b.id_,b.sol_id,b.sol_name,b.delegate_id  FROM biz_sol_relation b WHERE b.delegate_id=?");
				query = this.em.createNativeQuery(sb.toString()).setParameter(1, delegateId);
				((SQLQuery)query.unwrap(SQLQuery.class)).setResultTransformer(Transformers.aliasToBean(BizSolBean.class));
			}catch(Exception e){
				e.printStackTrace();
			}
			return query.getResultList();
		}
}
