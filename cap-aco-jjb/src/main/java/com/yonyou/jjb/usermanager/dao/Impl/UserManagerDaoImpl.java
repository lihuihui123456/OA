package com.yonyou.jjb.usermanager.dao.Impl;

import java.util.List;

import javax.persistence.Query;

import org.apache.commons.lang.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.jjb.usermanager.dao.IUserManagerDao;
import com.yonyou.jjb.usermanager.entity.UserInfoEntity;

@Repository("userManagerDao")
public class UserManagerDaoImpl extends BaseDao implements IUserManagerDao{
	
	@SuppressWarnings("unchecked")
	public List<UserInfoEntity> findAllUser(String userName,String userAge,String deptName,String postName,
			String entryTime,String userSex,String userDutyTyp) {
		StringBuffer wheresql = new StringBuffer();
		wheresql.append("select a.user_id userId,a.user_name userName,cast(a.user_sex as CHAR) as userSex,a.user_bitrth userBitrth, cast(a.work_time as CHAR) as workTime,cast(a.user_duty_typ as CHAR) as userDutyTyp,");                          
		wheresql.append("a.user_age userAge,a.user_education userEducation,a.user_police_type userPoliceType,cast(a.join_time as CHAR) as joinTime,a.user_source userSource, ");
		wheresql.append("a.user_height userHeight,a.marital_status maritalStatus,a.user_native_place userNativePlace,a.user_nation userNation,a.user_cert_code userCertCode, ");
		wheresql.append("a.user_degree userDegree,cast(a.entry_time as CHAR) as entryTime,a.office_phone officePhone,a.user_mobile userMobile,a.user_email userEmail,a.user_address userAddress,");
		wheresql.append("a.user_seniority userSeniority,a.dept_name deptName,a.post_name postName,a.user_qq userQq ");
		wheresql.append(" from (select s.* from isc_user_info s LEFT JOIN isc_dept_ref_user ofu ON s.USER_ID = ofu.USER_ID");
		wheresql.append(" LEFT JOIN isc_dept d ON d.dept_ID = ofu.dept_ID where (s.user_source is null or s.user_source!='1') ");
		if(StringUtils.isNotEmpty(userName)){
			wheresql.append("AND s.user_name LIKE '%" + userName + "%' ");
		}
		if(StringUtils.isNotEmpty(userAge)){
			wheresql.append("AND s.user_age LIKE '%" + userAge + "%' ");
		}
		if(StringUtils.isNotEmpty(entryTime)){
			wheresql.append("AND s.entry_time LIKE '%" + entryTime + "%' ");
		}
		if(StringUtils.isNotEmpty(userSex)){
			wheresql.append("AND s.user_sex LIKE '%" + userSex + "%' ");
		}
		if(StringUtils.isNotEmpty(deptName)){
			wheresql.append("AND s.dept_name = '" + deptName + "' ");
		}
		if(StringUtils.isNotEmpty(postName)){
			wheresql.append("AND s.post_name = '" + postName + "' ");
		}
		if(StringUtils.isNotEmpty(userDutyTyp)){
			wheresql.append("AND s.user_duty_typ LIKE '%" + userDutyTyp + "%' ");
		}
		wheresql.append(" AND s.dr='N' and ofu.dr='N' and s.user_name not like '%admin%' ORDER BY d.sort asc ,ofu.sort asc,ofu.weight desc) a ");
		wheresql.append(" union all ");
		wheresql.append("select b.user_id userId,b.user_name userName,cast(b.user_sex as CHAR) as userSex,b.user_bitrth userBitrth, cast(b.work_time as CHAR) as workTime,cast(b.user_duty_typ as CHAR) as userDutyTyp,");
		wheresql.append("b.user_age userAge,b.user_education userEducation,b.user_police_type userPoliceType,cast(b.join_time as CHAR) as joinTime,b.user_source userSource, ");
		wheresql.append("b.user_height userHeight,b.marital_status maritalStatus,b.user_native_place userNativePlace,b.user_nation userNation,b.user_cert_code userCertCode, ");
		wheresql.append("b.user_degree userDegree,cast(b.entry_time as CHAR) as entryTime,b.office_phone officePhone,b.user_mobile userMobile,b.user_email userEmail,b.user_address userAddress,");
		wheresql.append("b.user_seniority userSeniority,b.dept_name deptName,b.post_name postName,b.user_qq userQq ");
		wheresql.append(" from (select * from isc_user_info where user_source='1' ");
		if(StringUtils.isNotEmpty(userName)){
			wheresql.append("AND user_name LIKE '%" + userName + "%' ");
		}
		if(StringUtils.isNotEmpty(userAge)){
			wheresql.append("AND user_age LIKE '%" + userAge + "%' ");
		}
		if(StringUtils.isNotEmpty(entryTime)){
			wheresql.append("AND entry_time LIKE '%" + entryTime + "%' ");
		}
		if(StringUtils.isNotEmpty(userSex)){
			wheresql.append("AND user_sex LIKE '%" + userSex + "%' ");
		}
		if(StringUtils.isNotEmpty(deptName)){
			wheresql.append("AND dept_name = '" + deptName + "' ");
		}
		if(StringUtils.isNotEmpty(postName)){
			wheresql.append("AND post_name = '" + postName + "' ");
		}
		if(StringUtils.isNotEmpty(userDutyTyp)){
			wheresql.append("AND user_duty_typ LIKE '%" + userDutyTyp + "%' ");
		}
		wheresql.append(" AND dr='N' and user_name not like '%admin%' order by ts asc) b ");
		Query query = em.createNativeQuery(wheresql.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(UserInfoEntity.class));
		return query.getResultList();
	}
	
	@SuppressWarnings("unchecked")
	public String findLoginByUserId(String userid){
		String acctLogin="";
		String sql="SELECT ACCT_LOGIN FROM ISC_USER WHERE DR='N' AND USER_ID=?";
		Query query = em.createNativeQuery(sql).setParameter(1, userid);
		List<String> list = query.getResultList();
		if(list!=null && list.size()>0) {
			acctLogin = list.get(0);
		}
		return acctLogin;
	}
	@SuppressWarnings("unchecked")
	public String findDeptCodeById(String deptid){
		String deptCode="";
		if(StringUtils.isNotEmpty(deptid)){
		String sql="SELECT DEPT_CODE FROM ISC_DEPT WHERE DR='N' AND DEPT_ID=?";
		Query query = em.createNativeQuery(sql).setParameter(1, deptid);
		List<String> list = query.getResultList();
		if(list!=null && list.size()>0) {
			deptCode = list.get(0);
		   }
		}
		return deptCode;
	}
	@SuppressWarnings("unchecked")
	public String findPostCodeById(String postid){
		String postCode="";
		if(StringUtils.isNotEmpty(postid)){
			String sql="SELECT POST_CODE FROM ISC_POST WHERE DR='N' AND POST_ID=?";
			Query query = em.createNativeQuery(sql).setParameter(1, postid);
			List<String> list = query.getResultList();
			if(list!=null && list.size()>0) {
				postCode = list.get(0);
			}
		}		
		return postCode;
	}
}
