package com.yonyou.aco.contacts.dao.Impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Query;

import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yonyou.aco.contacts.dao.IBizContactsDao;
import com.yonyou.aco.contacts.entity.BizContactorsEntity;
import com.yonyou.aco.contacts.entity.BizContactsUserBean;
import com.yonyou.aco.contacts.entity.ContactsUserBean;
import com.yonyou.aco.contacts.entity.ContactsUserInfoBean;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.BeanUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.org.dao.IDeptDao;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
@Service("iBizContactsDao")
public class BizContactsDaoImpl extends BaseDao implements IBizContactsDao {


	@Autowired
	private IDeptDao deptDao;
	@Override
	public PageResult<BizContactsUserBean> findAllUserBySearchValue(String searchValue,
			String userId,int pageNum,int pageSize) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT iui.USER_ID AS userId,iui.USER_NAME AS userName,trim(iui.USER_SEX) AS userSex,"
				+ "iui.PIC_URL AS picUrl,iui.USER_BITRTH  AS userBitrth,iui.USER_EMAIL AS userEmail,"
				+ "iui.USER_MOBILE AS userMobile,u.ORG_NAME AS orgName,u.ORG_ID AS orgId,'' AS qq,"
				+ "iui.REMARK AS remark,iui.DEPT_NAME AS deptName,iui.POST_NAME as postName,u.ACCT_LOGIN AS userCode,'' AS tel FROM isc_user u,isc_user_info iui WHERE u.DR='N' AND iui.DR='N'"
				+ " AND u.USER_ID = iui.USER_ID ");
		if (StringUtils.isNotEmpty(searchValue)) {
			sb.append("AND iui.USER_NAME LIKE '%" + searchValue + "%'");
		}
		sb.append("UNION ALL ");
		sb.append("SELECT cu.USER_ID AS userId,"
				+ "cu.USER_NAME AS userName,trim(cu.SEX) AS userSex,cu.IMG_URL  AS picUrl,cu.BIRTHDAY AS userBitrth,"
				+ "cu.EMAIL AS userEmail,cu.MOBILE AS userMobile,cu.COMPANY AS orgName,'' AS orgId,cu.QQ AS qq ,"
				+ "cu.REMARK AS remark,'' AS deptName, cu.POST as postName,'' AS userCode,cu.TEL AS tel FROM biz_contacts_user cu WHERE cu.DR='N'");
		if (StringUtils.isNotEmpty(searchValue)) {
			sb.append("AND cu.USER_NAME LIKE '%" + searchValue
					+ "%' AND cu.CREATE_USER_ID ='" + userId + "'");
		}
		return getPageData(BizContactsUserBean.class, pageNum, pageSize,
				sb.toString());
	}
	@Override
	public String findOrgIdByUserId(String userId) {
		String sql = "SELECT ORG_ID FROM ISC_USER WHERE USER_ID='" + userId
				+ "'";
		Query query = em.createNativeQuery(sql);
		return query.getSingleResult().toString();
	}
	@Override
	public String findOrgNameByUserId(String userId) {
		String sql = "SELECT ORG_NAME FROM ISC_USER WHERE USER_ID='" + userId
				+ "'";
		Query query = em.createNativeQuery(sql);
		return query.getSingleResult().toString();
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<BizContactsUserBean> findMobileBizContactsUserInfo(
			String userId, String orgId) {
		String sql = "SELECT iui.USER_ID AS userId,iui.USER_NAME AS userName,trim(iui.USER_SEX) "
				+ "AS userSex,u.PIC_URL AS picUrl,iui.USER_BITRTH  AS userBitrth,"
				+ "iui.USER_EMAIL AS userEmail,iui.USER_MOBILE AS userMobile,u.ORG_NAME "
				+ "AS orgName,u.ORG_ID AS orgId,'' AS qq,iui.REMARK AS remark,u.DEPT_NAME AS"
				+ " deptName,p.POST_NAME AS postName,u.ACCT_LOGIN AS userCode,'' AS tel "
				+ "FROM isc_user_info iui,isc_user u LEFT JOIN isc_post_ref_user f "
				+ "ON f.USER_ID = u.USER_ID LEFT JOIN isc_post p ON p.POST_ID = f.POST_ID"
				+ " WHERE u.DR='N' AND f.IS_MAIN='Y' AND u.USER_ID=iui.USER_ID "
				+ "AND u.ORG_ID='"
				+ orgId
				+ "'"
				+ " GROUP BY iui.USER_ID"
				+ " UNION ALL select cu.USER_ID AS userId,cu.USER_NAME AS userName,trim(cu.SEX) AS userSex,cu.IMG_URL AS picUrl,"
				+ "cu.BIRTHDAY AS userBitrth,cu.EMAIL AS userEmailm,cu.MOBILE AS userMobile,cu.COMPANY AS orgName,"
				+ "'' AS orgId,cu.QQ AS qq ,cu.REMARK AS remark,cu.DEPT_NAME as deptName,cu.POST as postName,"
				+ "'' AS userCode,cu.TEL AS tel FROM "
				+ "biz_contacts_user cu WHERE cu.DR='N' AND cu.CREATE_USER_ID='"
				+ userId + "'";
		Query query = em.createNativeQuery(sql);
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(BizContactsUserBean.class));
		List<BizContactsUserBean> list = query.getResultList();
		return list;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Dept> findDeptList() {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * FROM ISC_DEPT WHERE DR='N' ORDER BY SORT ASC");
		Query query = em.createNativeQuery(sb.toString(),Dept.class);
		return query.getResultList();
	}


	@SuppressWarnings("unchecked")
	@Override
	public PageResult<ContactsUserBean> findUserByDept(int pageNum, int pageSize,
			String deptId,String word,String param) {
		PageResult<ContactsUserBean> pr = new PageResult<ContactsUserBean>();
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT DISTINCT "
				+ "U.USER_ID AS ID_,"
				+ "U.USER_ID AS USER_ID,"
				+ "U.USER_NAME AS USER_NAME,"
				+ "INFO.USER_TELEPHONE AS USER_TELEPHONE,"
				+ "INFO.USER_MOBILE AS USER_MOBILE,"
				+ "INFO.USER_EMAIL AS USER_EMAIL, "
				+ "D.DEPT_ID AS DEPT_ID,"
				+ "D.DEPT_NAME AS DEPT_NAME,"
				+ "U.PIC_URL AS PIC_URL "
				+ " FROM ISC_USER U"); 
		sb.append(" LEFT JOIN ISC_DEPT_REF_USER UAD ON U.USER_ID=UAD.USER_ID "); 
		sb.append(" LEFT JOIN ISC_DEPT D ON D.DEPT_ID=UAD.DEPT_ID ");
		sb.append(" LEFT JOIN ISC_USER_INFO INFO ON U.USER_ID=INFO.USER_ID "
				+ "WHERE 1=1 "
				+ "AND U.DR='N' "
				+ "AND INFO.DR='N' "
				+ "AND UAD.DR='N' "
				+ "AND D.DR='N' "
				+ "AND U.IS_ADMIN='N' "
				+ "AND UAD.IS_MAIN='Y' ");
		List<String> deptLists=this.recycleQueryDept(deptId);
		
		if(deptLists.size()>0&&deptLists!=null){
			sb.append(" AND D.DEPT_ID IN (");
			sb.append("?");
			for(int i=1;i<deptLists.size();i++){
				sb.append(",?");
			}
			sb.append(" )");
		}
		if(param!=null&&!"".equals(param)){
			sb.append(" AND (U.USER_NAME LIKE :USER_NAME "
					+ "OR D.DEPT_NAME LIKE :DEPT_NAME "
					+ "OR INFO.USER_TELEPHONE LIKE :USER_TELEPHONE "
					+ "OR INFO.USER_MOBILE LIKE :USER_MOBILE "
					+ "OR INFO.USER_EMAIL LIKE :USER_EMAIL )");
		}
		sb.append(" ORDER BY D.SORT asc, UAD.SORT ASC, UAD.WEIGHT DESC");
		Query query = em.createNativeQuery(sb.toString(),ContactsUserBean.class);
		if(deptLists.size()>0&&deptLists!=null){
			for(int i=0;i<deptLists.size();i++){
				query.setParameter(i+1, deptLists.get(i));
			}
		}
		if(param!=null&&!"".equals(param)){
			query.setParameter("USER_NAME", "%"+param+"%");
			query.setParameter("DEPT_NAME", "%"+param+"%");
			query.setParameter("USER_TELEPHONE", "%"+param+"%");
			query.setParameter("USER_MOBILE", "%"+param+"%");
			query.setParameter("USER_EMAIL", "%"+param+"%");
		}
		query.setFirstResult(0).setMaxResults(Integer.MAX_VALUE);
		long size = query.getResultList().size();// 总数据长度
		List<ContactsUserBean> list = query.getResultList();
		List<ContactsUserBean> reList=new ArrayList<ContactsUserBean>();
		if(word==null||"".equals(word)){
			reList=list;
		}else{
			for(int i=0;i<list.size();i++){
				ContactsUserBean cub=list.get(i);
				String NAME=cub.getUserName();
				HanyuPinyinOutputFormat defaultFormat = new HanyuPinyinOutputFormat();   
	            defaultFormat.setCaseType(HanyuPinyinCaseType.UPPERCASE);   
	            defaultFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE); 
	            String[] firstWord={};
				try {
					firstWord = PinyinHelper.toHanyuPinyinStringArray(NAME.charAt(0), defaultFormat);
				} catch (BadHanyuPinyinOutputFormatCombination e) {
					e.printStackTrace();
				}
				if(firstWord.length>=1){
					if(firstWord[0].substring(0,1).equalsIgnoreCase(word)){
						reList.add(cub);
					}
				}
			}
			size=reList.size();
		}
		if(reList.size()>pageSize){
			if(reList.size()<(pageNum*pageSize)){
				reList=reList.subList((pageNum-1)*pageSize, reList.size());
			}else{
				reList=reList.subList((pageNum-1)*pageSize, (pageNum)*pageSize);
			}
		}
		pr.setTotalrecord(size);
		pr.setResults(reList);
		return pr;
	}
	@SuppressWarnings("unchecked")
	@Override
	public PageResult<ContactsUserBean> findUserByDept(int pageNum, int pageSize,String userIds,String isSelectorNot) {
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<ContactsUserBean> pr = new PageResult<ContactsUserBean>();
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT DISTINCT "
				+ "U.USER_ID AS ID_,"
				+ "U.USER_ID AS USER_ID,"
				+ "U.USER_NAME AS USER_NAME,"
				+ "INFO.USER_TELEPHONE AS USER_TELEPHONE,"
				+ "INFO.USER_MOBILE AS USER_MOBILE,"
				+ "INFO.USER_EMAIL AS USER_EMAIL, "
				+ "D.DEPT_ID AS DEPT_ID,"
				+ "D.DEPT_NAME AS DEPT_NAME,"
				+ "U.PIC_URL AS PIC_URL "
				+ " FROM ISC_USER U"); 
		sb.append(" LEFT JOIN ISC_DEPT_REF_USER UAD ON U.USER_ID=UAD.USER_ID "); 
		sb.append(" LEFT JOIN ISC_DEPT D ON D.DEPT_ID=UAD.DEPT_ID ");
		sb.append(" LEFT JOIN ISC_USER_INFO INFO ON U.USER_ID=INFO.USER_ID "
				+ "WHERE 1=1 "
				+ "AND U.DR='N' "
				+ "AND INFO.DR='N' "
				+ "AND UAD.DR='N' "
				+ "AND D.DR='N' "
				+ "AND U.IS_ADMIN='N' "
				+ "AND UAD.IS_MAIN='Y' ");
		String userStr[]=userIds.split(",");
		if(!"0".equals(isSelectorNot)){
			sb.append(" AND U.USER_ID IN (");
			for(int i=0;i<userStr.length;i++){
				if(i==0){
					sb.append("?");
				}else{
					sb.append(",?");
				}
			}
			sb.append(")");
		}
		sb.append(" ORDER BY D.SORT asc, UAD.SORT ASC, UAD.WEIGHT DESC");
		Query query = em.createNativeQuery(sb.toString(),ContactsUserBean.class);
		/*query.setFirstResult(0).setMaxResults(Integer.MAX_VALUE);*/
		if(!"0".equals(isSelectorNot)){
			for(int i=0;i<userStr.length;i++){
				query.setParameter(i+1, userStr[i]);
			}
		}
		long size = query.getResultList().size();// 总数据长度
		if (firstindex >= size) {
			if (size > pageSize) {
				query.setFirstResult(((int) size / pageSize - 1) * pageSize).setMaxResults(maxresult);
			} else {
				query.setFirstResult(0).setMaxResults(maxresult);
			}
		} else {
			query.setFirstResult(firstindex).setMaxResults(maxresult);
		}
		List<ContactsUserBean> list = query.getResultList();
		pr.setTotalrecord(size);
		pr.setResults(list);
		return pr;
	}

	private List<String> recycleQueryDept(String parentDeptId){
		List<String> list=new ArrayList<String>();
		List<String> listAll=new ArrayList<String>();
		list.add(parentDeptId);
		List<Dept> deptList=this.findDeptList();
		for(int i=0;i<deptList.size();i++){
			Dept deptAll=deptList.get(i);
			listAll.add(deptAll.getDeptId());
			if(deptAll.getParentDeptId().equals(parentDeptId)){
				list.add(deptAll.getDeptId());
				this.recycleQueryDept(deptAll.getDeptId());
			}
		}
		if(parentDeptId==null||"".equals(parentDeptId)){
			return listAll;
		}
		return list;
	}

	@Override
	public void addAlwaysContactors(String userIds,ShiroUser user) {
		String userStr[]=userIds.split(",");
		for(int i=0;i<userStr.length;i++){
			if(isHasAlwaysContactors(user.getId(),userStr[i])){
				BizContactorsEntity entity=new BizContactorsEntity();
				entity.setContactsUserId(userStr[i]);
				entity.setCreateUserId(user.getId());
				entity.setDr("N");
				entity.setCreateDate(new SimpleDateFormat("YYYY-MM-DD HH:mm:ss").format(new Date()));
				em.merge(entity);
			}
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public boolean isHasAlwaysContactors(String sendUserId,String receiverUserId) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * FROM BIZ_CONTACTORS WHERE CREATE_USER_ID=? AND CONTACTS_USER_ID=? AND DR=?");
		Query query = em.createNativeQuery(sb.toString(),BizContactorsEntity.class);
		query.setParameter(1, sendUserId);
		query.setParameter(2, receiverUserId);
		query.setParameter(3, "N");
		List<BizContactorsEntity> list=query.getResultList();
		if(list.size()>0){
			return false;
		}
		return true;
	}

	@SuppressWarnings("unchecked")
	@Override
	public PageResult<ContactsUserBean> findAlwaysContactors(int pageNum,int pageSize,String word,String param,ShiroUser user) {
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<ContactsUserBean> pr = new PageResult<ContactsUserBean>();
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT DISTINCT "
				+ "U.USER_ID AS ID_,"
				+ "U.USER_ID AS USER_ID,"
				+ "U.USER_NAME AS USER_NAME,"
				+ "INFO.USER_TELEPHONE AS USER_TELEPHONE,"
				+ "INFO.USER_MOBILE AS USER_MOBILE,"
				+ "INFO.USER_EMAIL AS USER_EMAIL, "
				+ "D.DEPT_ID AS DEPT_ID,"
				+ "D.DEPT_NAME AS DEPT_NAME,"
				+ "U.PIC_URL AS PIC_URL "
				+ " FROM ISC_USER U"); 
		sb.append(" LEFT JOIN ISC_DEPT_REF_USER UAD ON U.USER_ID=UAD.USER_ID "); 
		sb.append(" LEFT JOIN BIZ_CONTACTORS C ON C.CONTACTS_USER_ID=U.USER_ID ");
		sb.append(" LEFT JOIN ISC_DEPT D ON D.DEPT_ID=UAD.DEPT_ID ");
		sb.append(" LEFT JOIN ISC_USER_INFO INFO ON U.USER_ID=INFO.USER_ID "
				+ "WHERE 1=1 "
				+ "AND U.DR='N' "
				+ "AND INFO.DR='N' "
				+ "AND UAD.DR='N' "
				+ "AND D.DR='N' "
				+ "AND U.IS_ADMIN='N' "
				+ "AND UAD.IS_MAIN='Y'"
				+ "AND C.CREATE_USER_ID=? "
				+ "AND C.DR='N'");
		if(param!=null&&!"".equals(param)){
			sb.append(" AND (U.USER_NAME LIKE :USER_NAME "
					+ "OR D.DEPT_NAME LIKE :DEPT_NAME "
					+ "OR INFO.USER_TELEPHONE LIKE :USER_TELEPHONE "
					+ "OR INFO.USER_MOBILE LIKE :USER_MOBILE "
					+ "OR INFO.USER_EMAIL LIKE :USER_EMAIL )");
		}
		//sb.append(" ORDER BY D.DEPT_CODE DESC,U.ACCT_LOGIN ASC");
		sb.append(" ORDER BY D.SORT asc, UAD.SORT ASC, UAD.WEIGHT DESC");
		Query query = em.createNativeQuery(sb.toString(),ContactsUserBean.class);
		query.setParameter(1, user.getId());
		if(param!=null&&!"".equals(param)){
			query.setParameter("USER_NAME", "%"+param+"%");
			query.setParameter("DEPT_NAME", "%"+param+"%");
			query.setParameter("USER_TELEPHONE", "%"+param+"%");
			query.setParameter("USER_MOBILE", "%"+param+"%");
			query.setParameter("USER_EMAIL", "%"+param+"%");
		}
//		query.setFirstResult(0).setMaxResults(Integer.MAX_VALUE);
		long size = query.getResultList().size();// 总数据长度
		if (firstindex >= size) {
			if (size > pageSize) {
				query.setFirstResult(((int) size / pageSize - 1) * pageSize).setMaxResults(maxresult);
			} else {
				query.setFirstResult(0).setMaxResults(maxresult);
			}
		} else {
			query.setFirstResult(firstindex).setMaxResults(maxresult);
		}
		List<ContactsUserBean> list = query.getResultList();
		List<ContactsUserBean> reList=new ArrayList<ContactsUserBean>();
		if(word==null||"".equals(word)){
			reList=list;
		}else{
			for(int i=0;i<list.size();i++){
				ContactsUserBean cub=list.get(i);
				String NAME=cub.getUserName();
				HanyuPinyinOutputFormat defaultFormat = new HanyuPinyinOutputFormat();   
	            defaultFormat.setCaseType(HanyuPinyinCaseType.UPPERCASE);   
	            defaultFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE); 
	            String[] firstWord={};
				try {
					firstWord = PinyinHelper.toHanyuPinyinStringArray(NAME.charAt(0), defaultFormat);
				} catch (BadHanyuPinyinOutputFormatCombination e) {
					e.printStackTrace();
				}
				if(firstWord.length>=1){
					if(firstWord[0].substring(0,1).equalsIgnoreCase(word)){
						reList.add(cub);
					}
					
				}
			}
		}
		pr.setTotalrecord(size);
		pr.setResults(reList);
		return pr;
	}
	@Override
	public void deleteAlwaysContactors(String userIds,ShiroUser user) {
		StringBuffer sb = new StringBuffer();
		String userStr[]=userIds.split(",");
		sb.append("UPDATE BIZ_CONTACTORS SET DR=? where CREATE_USER_ID=?");
		sb.append(" AND CONTACTS_USER_ID IN (");
		sb.append("?");
		for(int i=1;i<userStr.length;i++){
			sb.append(",?");
		}
		sb.append(" )");
		Query query  =  em.createNativeQuery(sb.toString());
		query.setParameter(1, "Y");
		query.setParameter(2, user.getUserId());
		for(int i=0;i<userStr.length;i++){
			query.setParameter(i+3, userStr[i]);
		}
		query.executeUpdate();
		
	}
	@SuppressWarnings("unchecked")
	@Override
	public ContactsUserBean queryContactor(String userId) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT U.USER_ID AS ID_,"
				+ "U.USER_ID AS USER_ID,"
				+ "I.USER_NAME AS USER_NAME,"
				+ "I.USER_TELEPHONE AS USER_TELEPHONE,"
				+ "I.USER_MOBILE AS USER_MOBILE,"
				+ "I.USER_EMAIL AS USER_EMAIL,"
				+ "R.DEPT_ID AS DEPT_ID,"
				+ "I.DEPT_NAME AS DEPT_NAME"
				+ " FROM ISC_USER U "
				+ "LEFT JOIN ISC_USER_INFO I ON U.USER_ID=I.USER_ID "
				+ "LEFT JOIN ISC_DEPT_REF_USER R ON U.USER_ID=R.USER_ID"
				+ " WHERE U.DR='N' AND I.DR='N' AND R.DR='N' ");
		if(userId!=null&&!"".equals(userId)){
			sb.append(" AND U.USER_ID=?");
		}
		Query query = em.createNativeQuery(sb.toString(),ContactsUserBean.class);
		if(userId!=null&&!"".equals(userId)){
			query.setParameter(1, userId);

		}
		List<ContactsUserBean> list=query.getResultList();
		ContactsUserBean bean=new ContactsUserBean();
		if(list.size()>0){
			bean=list.get(0);
		}
		return bean;
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<ContactsUserInfoBean> queryAllUserData() {

		StringBuffer sb = new StringBuffer();
		sb.append("SELECT DISTINCT "
				+ "U.USER_ID AS ID_,"
				+ "U.USER_ID AS USER_ID,"
				+ "U.USER_NAME AS USER_NAME,"
				+ "INFO.USER_TELEPHONE AS USER_TELEPHONE,"
				+ "INFO.USER_MOBILE AS USER_MOBILE,"
				+ "INFO.USER_EMAIL AS USER_EMAIL, "
				+ "D.DEPT_ID AS DEPT_ID,"
				+ "D.DEPT_NAME AS DEPT_NAME,"
				+ "U.PIC_URL AS PIC_URL, "
				+ "'' AS FIRST_WORD,"
				+ "D.PARENT_DEPT_ID AS PARENT_DEPT_ID "
				+ " FROM ISC_USER U"); 
		sb.append(" LEFT JOIN ISC_DEPT_REF_USER UAD ON U.USER_ID=UAD.USER_ID "); 
		sb.append(" LEFT JOIN ISC_DEPT D ON D.DEPT_ID=UAD.DEPT_ID ");
		sb.append(" LEFT JOIN ISC_USER_INFO INFO ON U.USER_ID=INFO.USER_ID "
				+ "WHERE 1=1 "
				+ "AND U.DR='N' "
				+ "AND INFO.DR='N' "
				+ "AND UAD.DR='N' "
				+ "AND D.DR='N' "
				+ "AND UAD.IS_MAIN='Y'"
				+ "AND U.IS_ADMIN='N' ");
		sb.append(" ORDER BY D.SORT asc, UAD.SORT ASC, UAD.WEIGHT DESC");
		Query query = em.createNativeQuery(sb.toString(),ContactsUserInfoBean.class);
		query.setFirstResult(0).setMaxResults(Integer.MAX_VALUE);
		List<ContactsUserInfoBean> list = query.getResultList();
		List<ContactsUserInfoBean> reList=new ArrayList<ContactsUserInfoBean>();
		for(int i=0;i<list.size();i++){
			ContactsUserInfoBean cub=list.get(i);
			String NAME=cub.getUserName();
			/**
			 * modify by hegd 2017-06-21 如果不是汉字就跳过直接添加到list中
			 */
			ContactsUserInfoBean newCub=new ContactsUserInfoBean();
			if(isFirstEn(NAME)){
				BeanUtil.copy(newCub, cub);
			}else{
				HanyuPinyinOutputFormat defaultFormat = new HanyuPinyinOutputFormat();   
				defaultFormat.setCaseType(HanyuPinyinCaseType.UPPERCASE);   
				defaultFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE); 
				String[] firstWord={};
				try {
					firstWord = PinyinHelper.toHanyuPinyinStringArray(NAME.charAt(0), defaultFormat);
				} catch (BadHanyuPinyinOutputFormatCombination e) {
					e.printStackTrace();
				}
				if(firstWord.length>=1){
					BeanUtil.copy(newCub, cub);
					newCub.setFirstWord(firstWord[0].substring(0,1));
				}
			}
			reList.add(newCub);
		}
		return reList;
	
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<ContactsUserInfoBean> queryAllContactors(String userId) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT DISTINCT "
				+ "U.USER_ID AS ID_,"
				+ "U.USER_ID AS USER_ID,"
				+ "U.USER_NAME AS USER_NAME,"
				+ "INFO.USER_TELEPHONE AS USER_TELEPHONE,"
				+ "INFO.USER_MOBILE AS USER_MOBILE,"
				+ "INFO.USER_EMAIL AS USER_EMAIL, "
				+ "D.DEPT_ID AS DEPT_ID,"
				+ "D.DEPT_NAME AS DEPT_NAME,"
				+ "U.PIC_URL AS PIC_URL, "
				+ "'' AS FIRST_WORD,"
				+ "D.PARENT_DEPT_ID AS PARENT_DEPT_ID "
				+ " FROM ISC_USER U"); 
		sb.append(" LEFT JOIN ISC_DEPT_REF_USER UAD ON U.USER_ID=UAD.USER_ID "); 
		sb.append(" LEFT JOIN BIZ_CONTACTORS C ON C.CONTACTS_USER_ID=U.USER_ID ");
		sb.append(" LEFT JOIN ISC_DEPT D ON D.DEPT_ID=UAD.DEPT_ID ");
		sb.append(" LEFT JOIN ISC_USER_INFO INFO ON U.USER_ID=INFO.USER_ID "
				+ "WHERE 1=1 "
				+ "AND U.DR='N' "
				+ "AND INFO.DR='N' "
				+ "AND UAD.DR='N' "
				+ "AND D.DR='N' "
				+ "AND UAD.IS_MAIN='Y'"
				+ "AND C.CREATE_USER_ID=? "
				+ "AND C.DR='N'");
		Query query = em.createNativeQuery(sb.toString(),ContactsUserInfoBean.class);
		if(userId!=null&&!"".equals(userId)){
			query.setParameter(1, userId);
		}
		List<ContactsUserInfoBean> list=query.getResultList();
		return list;
	}
	
	
	/**
	 * 判断字符串第一个字符是否为字母
	 * @param s
	 * @return
	 */
	public static boolean isFirstEn(String s) {
		char c = s.charAt(0);
		int i = (int) c;
		if ((i >= 65 && i <= 90) || (i >= 97 && i <= 122)) {
			return true;
		} else {
			return false;
		}
	}
}
