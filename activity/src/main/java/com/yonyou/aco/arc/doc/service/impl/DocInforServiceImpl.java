//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：张多一$手机：18701386200#
// SVN版本号                    日   期                 作     者              变更记录
// DocInforServiceImpl-001     2016/12/21   张多一                  新建
//*********************************************************************
package com.yonyou.aco.arc.doc.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.yonyou.aco.arc.doc.dao.IDocInforDao;
import com.yonyou.aco.arc.doc.entity.DocInfor;
import com.yonyou.aco.arc.doc.entity.DocInforShow;
import com.yonyou.aco.arc.doc.entity.DocTableBean;
import com.yonyou.aco.arc.doc.entity.FileStart;
import com.yonyou.aco.arc.doc.service.IDocInforService;
import com.yonyou.aco.arc.otherarc.dao.IArcPubInfoDao;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.aco.arc.otherarc.service.IArcPubInfoService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.org.dao.IDeptDao;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.user.dao.IUserDao;
import com.yonyou.cap.isc.user.entity.User;
/**
 * <p>概述：实现档案文书登记表service层接口
 * <p>功能：实现在service层提供档案文书登记表接口IDocInforService
 * <p>作者：张多一
 * <p>创建时间：2016-07-11
 * <p>类调用特殊情况：无
 */
@Service
public class DocInforServiceImpl implements IDocInforService {
	@Resource
	private IDocInforDao docInforDao;
	@Resource
	private IArcPubInfoDao arcPubInfoDao;
	@Resource
	private IArcPubInfoService arcPubInforService;
	@Resource
	private IUserDao userDao;
	@Resource
	private IDeptDao deptDao;
	

	/**
	 * @param pageNum
	 * @param pageSize
	 * @return
	 */
	@Override
	public PageResult<DocInforShow> findAllDocInfor(int pageNum, int pageSize) {
		StringBuffer where = new StringBuffer();
		PageResult<DocInforShow> results = new PageResult<DocInforShow>();
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		where.append(" o.dr='N' ");
		PageResult<DocInfor> docInforList = docInforDao.getPageData(DocInfor.class, pageNum,pageSize,where.toString(), null, null);

		List<DocInfor> doclist = docInforList.getResults();
		if(doclist==null||doclist.size()==0){
			
		}else{
			resultsList = completeWholInfor(doclist);
		}
 		//get deptname from table
		results.setResults(resultsList);
		results.setTotalrecord(docInforList.getTotalrecord());
		return results;
	}
	
	/**
	 * 把docinfor list补全程完整的信息体(DocInforShow)
	 * @param doclist : a list of docinfor
	 * @return the complete information of docinfor
	 */
	private List<DocInforShow> completeWholInfor(List<DocInfor> doclist){
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		StringBuffer pubWhere = new StringBuffer();
		pubWhere.append(" o.dr='N' AND o.arcId IN ( ");
		String tempWhere;
		for(DocInfor temp: doclist){
			pubWhere.append("'").append(temp.getArcId()).append("',");
		}
		tempWhere = pubWhere.toString();
		tempWhere = tempWhere.substring(0, tempWhere.length()-1);
		tempWhere = tempWhere + ")";
		List<ArcPubInfoEntity> publist = arcPubInfoDao.getListBySql(ArcPubInfoEntity.class,tempWhere , null, null);

		DocInforShow show = null;
		for(DocInfor temp: doclist){
			for(ArcPubInfoEntity pubInfor: publist){
				if(temp.getArcId().equals(pubInfor.getArcId())){
					show = new DocInforShow();
					show.setDocInfor(temp);
					show.setArcPubInfor(pubInfor);
					resultsList.add(show);
				}
			}
		}
		//get the username from table
		StringBuffer userWherSql = new StringBuffer();
		userWherSql.append(" o.dr='N' AND o.userId IN ( ");
		if(publist==null||publist.size()==0){
			userWherSql.append("'' ");
		}else{
			for(ArcPubInfoEntity entity:publist){
				userWherSql.append("'").append(entity.getRegUser()).append("',");
			}
		}
		String userWhereString = userWherSql.toString();
		userWhereString = userWhereString.substring(0, userWhereString.length()-1);
		userWhereString = userWhereString + ")";
		List<User> userList = userDao.getListBySql(User.class, userWhereString, null, null);
		
		String deptWhere = " o.deptId IN ( ";
		if(publist==null||publist.size()==0){
			deptWhere = deptWhere + " '' ";
		}else{
			for(ArcPubInfoEntity entity:publist){
				deptWhere = deptWhere + "'" + entity.getRegUser() +"',";
			}
			deptWhere = deptWhere.substring(0, deptWhere.length()-1);
		}
		deptWhere += ")" ;
		List<Dept> deptList = deptDao.getListBySql(Dept.class, deptWhere, null, null);
		
		String fileUserWhere = " o.userId IN ( ";
		if(publist==null||publist.size()==0){
			fileUserWhere = fileUserWhere +"'' ";
		}
		for(ArcPubInfoEntity entity:publist){
			fileUserWhere = fileUserWhere + "'" + entity.getFileUser() +"',";
		}
		fileUserWhere = fileUserWhere.substring(0, fileUserWhere.length()-1);
		fileUserWhere += ")" ;
		List<User> fileUsers = userDao.getListBySql(User.class, fileUserWhere, null, null);
		
		//set the user real name in the docinforshow
		for(DocInforShow showtemp :resultsList){
			//set the regUser name
			for(User usertemp:userList){
				if(showtemp.getArcPubInfor().getRegUser().equals(usertemp.getUserId())){
					showtemp.setRegUserName(usertemp.getUserName());
				}
			}
			//set dept name
			for(Dept deptTemp: deptList){
				if(showtemp.getArcPubInfor().getRegDept().equals(deptTemp.getDeptId())){
					showtemp.setRegDeptName(deptTemp.getDeptName());
				}
			}
			//set the fileuser name
			for(User userTemp: fileUsers){
				if(showtemp.getArcPubInfor().getFileUser().equals(userTemp.getUserId())){
					showtemp.setFileUserName(userTemp.getUserName());
				}
			}
		}
		return resultsList;
	}

	@Override
	@Deprecated
	public void doDeleteDocInforById(String arcId) {
		arcPubInforService.deleteArcPubInfo(arcId);
	}

/*	@Override
	public void doUpdate(DocInforShow docInforShow) {
		//if one unique column exists
		Boolean exist= true;
		if(exist){
			//check the unique value, see org update
		}else{
			docInforDao.update(docInforShow.getDocInfor());
			arcPubInfoDao.update(docInforShow.getArcPubInfor());
		}
	}*/

	@Override
	public void doSaveDocInfor(DocInfor docInfor, ArcPubInfoEntity pubInfor) {
		//set the default value
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String ts = (df.format(new Date())).toString();
		docInfor.setTs(ts);
		if(pubInfor!=null){
			pubInfor.setDr("N");
			//归档状态0:未归档1:已归档2：追加归档'
			pubInfor.setFileStart("0");
			//是否作废销毁0：正常1：作废2：销毁
			pubInfor.setIsInvalid("0");
			pubInfor.setId(null);
		}
		docInforDao.save(docInfor);
		arcPubInfoDao.save(pubInfor);
	}

	@Override
	public void doUpdate(DocInfor docInfor,ArcPubInfoEntity pubInfor) {
		//if one unique column exists
		Boolean exist= false;
		if(exist){
			//check the unique value, see org update
		}else{
			docInforDao.update(docInfor);
			arcPubInfoDao.update(pubInfor);
		}
		
	}

	@Override
	public DocInforShow findDocInforById(String docInforId) {
		DocInforShow show = new DocInforShow();
		show.setDocInfor(docInforDao.findEntityByPK(DocInfor.class, docInforId));
		List<ArcPubInfoEntity> pubList = arcPubInfoDao.findByProperty(ArcPubInfoEntity.class, "arcId", docInforId);
		List<DocInforShow> showlist = new ArrayList<DocInforShow>();
		if(pubList!=null&&pubList.size()>0){
			showlist= completeDocInforByArcPub(pubList);
		}
		if(showlist.size()>0){
			return showlist.get(0);
		}
		return null;
	}

	@Override
	public PageResult<DocInfor> findDocInforByType(int pageNum, int pageSize,
			String type) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public PageResult<DocInforShow> findDocInforByWhereSql(int pageNum,
			int pageSize, String whereSql) {
		PageResult<DocInfor> docInforList = docInforDao.getPageData(DocInfor.class, pageNum,pageSize,whereSql, null, null);
		PageResult<DocInforShow> results = new PageResult<DocInforShow>();
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		List<DocInfor> doclist = docInforList.getResults();
		if(doclist==null||doclist.size()==0){
			
		}else{
			resultsList = completeWholInfor(doclist);
		}
		results.setResults(resultsList);
		results.setTotalrecord(docInforList.getTotalrecord());
		return results;
	}

	@Override
	public PageResult<DocInforShow> findAllDocInfor(int pageNum, int pageSize,
			String fileTypeId) {
		//first get the list from arcpubinfor table
		StringBuffer where = new StringBuffer();
		PageResult<DocInforShow> results = new PageResult<DocInforShow>();
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		where.append(" o.dr='N' AND o.fileType ='").append(fileTypeId).append("'");
		PageResult<ArcPubInfoEntity> arcPubList = arcPubInfoDao.getPageData(ArcPubInfoEntity.class, pageNum,pageSize,where.toString(), null, null);

		List<ArcPubInfoEntity> publist = arcPubList.getResults();
		if(publist==null||publist.size()==0){
			
		}else{
			resultsList = completeDocInforByArcPub(publist);
		}
 		//get deptname from table
		results.setResults(resultsList);
		results.setTotalrecord(arcPubList.getTotalrecord());
		return results;
	}
	
	/**
	 * 根据公共信息表，补全相关联的信息
	 * @param publist
	 * @return
	 */
	private List<DocInforShow> completeDocInforByArcPub(List<ArcPubInfoEntity> publist){
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		StringBuffer pubWhere = new StringBuffer();
		pubWhere.append(" o.arcId IN ( ");
		String tempWhere;
		for(ArcPubInfoEntity temp: publist){
			pubWhere.append("'").append(temp.getArcId()).append("',");
		}
		tempWhere = pubWhere.toString();
		tempWhere = tempWhere.substring(0, tempWhere.length()-1);
		tempWhere = tempWhere + ")";
		List<DocInfor> doclist = docInforDao.getListBySql(DocInfor.class,tempWhere , null, null);

		DocInforShow show = null;
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		for(ArcPubInfoEntity pubInforTemp: publist){
			for(DocInfor docInfor: doclist){
				if(pubInforTemp.getArcId().equals(docInfor.getArcId())){
					show = new DocInforShow();
					show.setDocInfor(docInfor);
					show.setArcPubInfor(pubInforTemp);
					show.setRegTime((df.format(pubInforTemp.getRegTime())).toString());
					show.setRegUserName(pubInforTemp.getRegUser());
					show.setFileUserName(pubInforTemp.getFileUser());
					show.setRegDeptName(pubInforTemp.getRegDept());
					resultsList.add(show);
				}
			}
		}
		//get the username from table
		StringBuffer userWherSql = new StringBuffer();
		userWherSql.append(" o.userId IN ( ");
		if(publist==null||publist.size()==0){
			userWherSql.append("'' ");
		}else{
			for(ArcPubInfoEntity entity:publist){
				userWherSql.append("'").append(entity.getRegUser()).append("',");
			}
		}
		String userWhereString = userWherSql.toString();
		userWhereString = userWhereString.substring(0, userWhereString.length()-1);
		userWhereString = userWhereString + ")";
		List<User> userList = userDao.getListBySql(User.class, userWhereString, null, null);
		
//		String deptWhere = " o.deptId IN ( ";
//		if(publist==null||publist.size()==0){
//			deptWhere = deptWhere + " '' ";
//		}else{
//			for(ArcPubInfoEntity entity:publist){
//				deptWhere = deptWhere + "'" + entity.getRegDept() +"',";
//			}
//			deptWhere = deptWhere.substring(0, deptWhere.length()-1);
//		}
//		deptWhere += ")" ;
//		List<Dept> deptList = deptDao.getListBySql(Dept.class, deptWhere, null, null);
		
		String fileUserWhere = " o.userId IN ( ";
		if(publist==null||publist.size()==0){
			fileUserWhere = fileUserWhere +"'' ";
		}
		for(ArcPubInfoEntity entity:publist){
			fileUserWhere = fileUserWhere + "'" + entity.getFileUser() +"',";
		}
		fileUserWhere = fileUserWhere.substring(0, fileUserWhere.length()-1);
		fileUserWhere += ")" ;
		List<User> fileUsers = userDao.getListBySql(User.class, fileUserWhere, null, null);
		
		//set the user real name in the docinforshow
		for(DocInforShow showtemp :resultsList){
			//set the regUser name
			for(User usertemp:userList){
				if(usertemp.getUserId().equals(showtemp.getArcPubInfor().getRegUser())){
					showtemp.setRegUserName(usertemp.getUserName());
				}
			}
//			//set dept name
//			for(Dept deptTemp: deptList){
//				if(deptTemp.getDeptId().equals(showtemp.getArcPubInfor().getRegDept())){
//					showtemp.setRegDeptName(deptTemp.getDeptName());
//				}
//			}
			//set the fileuser name
			for(User userTemp: fileUsers){
				if(userTemp.getUserId().equals(showtemp.getArcPubInfor().getFileUser())){
					showtemp.setFileUserName(userTemp.getUserName());
				}
			}
		}
		return resultsList;
	}

	@Override
	public PageResult<DocInforShow> findAllDocInforByCondition(int pageNum,
			int pageSize, String searchArcType, String searcharcName,
			String searchdocNBR, String searchfileStart,String searchregYear,
			String regTimeBeginn, String regTimeEnd,String type) {
		
		PageResult<DocInforShow> results = new PageResult<DocInforShow>();
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		
		String where =" 1=1 AND o.dr='N' ";
		if(searchdocNBR!=null&&!"".equals(searchdocNBR)){
			where = where + " AND o.arcId IN ( SELECT doc.arcId FROM DocInfor doc WHERE doc.docNBR like '%" + searchdocNBR + "%')" ;
		}
		if(searchArcType!=null&&!"".equals(searchArcType)){
			where = where + "AND o.arcType='" + searchArcType +"'";
		}
		if(type!=null&&!"".equals(type)){
			where = where + "AND o.fileType='" + type +"'";
		}
		if(searcharcName!=null&&!"".equals(searcharcName)){
			where = where + " AND o.arcName like '%" + searcharcName + "%'";
		}
		if(searchfileStart!=null&&!"".equals(searchfileStart)){
			if(!"all".equals(searchfileStart)){
				where = where + " AND o.fileStart='" + searchfileStart +"'";
			}
		}
		//year(date)='2011'
		if(searchregYear!=null&&!"".equals(searchregYear)){
			//year search condition
			where = where + " AND year(o.regTime)='" + searchregYear +"'";
		}
		//DATE(PageResult<ArcPubInfoEntity> arcPubList = arcPubInfoDao.getPageData(ArcPubInfoEntity.class, pageNum,pageSize,where.toString(), null, null);)
		if(regTimeBeginn!=null&&!"".equals(regTimeBeginn)){
			where = where + " AND o.regTime >='" + regTimeBeginn +"'";
		}
		if(regTimeEnd!=null&&!"".equals(regTimeEnd)){
			where = where + " AND o.regTime <='" + regTimeEnd +"'";
		}
		//get search result
		PageResult<ArcPubInfoEntity> arcPubList = arcPubInfoDao.getPageData(ArcPubInfoEntity.class, pageNum,pageSize,where, null, null);
		List<ArcPubInfoEntity> publist = arcPubList.getResults();
		if(publist==null||publist.size()==0){
			
		}else{
			resultsList = completeDocInforByArcPub(publist);
		}
		results.setResults(resultsList);
		results.setTotalrecord(arcPubList.getTotalrecord());
		return results;
	}

	@Override
	public List<DocInforShow> findAllDocInforByCondition(String searchArcType,
			String searcharcName, String searchdocNBR, String searchfileStart,
			String searchregYear, String regTimeBeginn, String regTimeEnd) {
		
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		String where =" 1=1 AND o.dr='N' ";
		if(searchdocNBR!=null&&!"".equals(searchdocNBR)){
			where = where + " AND o.arcId IN ( SELECT doc.arcId FROM DocInfor doc WHERE doc.docNBR like '%" + searchdocNBR + "%')" ;
		}
		if(searchArcType!=null&&!"".equals(searchArcType)){
			where = where + "AND o.arcType='" + searchArcType +"'";
		}
		if(searcharcName!=null&&!"".equals(searcharcName)){
			where = where + " AND o.arcName like '%" + searcharcName + "%'";
		}
		if(searchfileStart!=null&&!"".equals(searchfileStart)){
			if(!"all".equals(searchfileStart)){
				where = where + " AND o.fileStart='" + searchfileStart +"'";
			}
		}
		//year(date)='2011'
		if(searchregYear!=null&&!"".equals(searchregYear)){
			//year search condition
			where = where + " AND year(o.regTime)='" + searchregYear +"'";
		}
		//DATE(PageResult<ArcPubInfoEntity> arcPubList = arcPubInfoDao.getPageData(ArcPubInfoEntity.class, pageNum,pageSize,where.toString(), null, null);)
		if(regTimeBeginn!=null&&!"".equals(regTimeBeginn)){
			where = where + " AND o.regTime >='" + regTimeBeginn +"'";
		}
		if(regTimeEnd!=null&&!"".equals(regTimeEnd)){
			where = where + " AND o.regTime <='" + regTimeEnd +"'";
		}
		List<ArcPubInfoEntity> pubEntities = arcPubInfoDao.getListBySql(ArcPubInfoEntity.class, where, null, null);
		
		if(pubEntities==null||pubEntities.size()==0){
			
		}else{
			resultsList = completeDocInforByArcPub(pubEntities);
		}
		return resultsList;
	}

	@Override
	public DocInforShow findDocInforByArcId(String arcId) {
		DocInforShow show = new DocInforShow();
		show.setDocInfor(docInforDao.findEntityByPK(DocInfor.class, arcId));
		List<ArcPubInfoEntity> pubList = arcPubInfoDao.findByProperty(ArcPubInfoEntity.class, "arcId", arcId);
		List<DocInforShow> showlist = new ArrayList<DocInforShow>();
		if(pubList!=null&&pubList.size()>0){
			showlist= completeDocInforByArcPub(pubList);
		}
		if(showlist.size()>0){
			return showlist.get(0);
		}
		return null;
	}

	@Override
	public PageResult<DocInforShow> findAllDocInfor(String userId, int pageNum,
			int pageSize) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public PageResult<DocInforShow> findAllDocInfor(String userId, int pageNum,
			int pageSize, String fileTypeId) {
		//first get the list from arcpubinfor table
		StringBuffer where = new StringBuffer();
		PageResult<DocInforShow> results = new PageResult<DocInforShow>();
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		where.append(" o.dr='N' ");
		where.append(" AND ( o.isInvalid='0' OR o.isInvalid='1' ) AND o.expiryDateTime > sysdate() ");
		//where.append(" AND o.expiryDateTime > sysdate() ");
		if(!isBlank(userId)){
			where.append(" AND o.regUser='").append(userId).append("'");;
		}
		if(!isBlank(fileTypeId)){
			where.append("  AND o.fileType ='").append(fileTypeId).append("'");
		}
		where.append(" ORDER BY o.regTime DESC");
		PageResult<ArcPubInfoEntity> arcPubList = arcPubInfoDao.getPageData(ArcPubInfoEntity.class, pageNum,pageSize,where.toString(), null, null);

		List<ArcPubInfoEntity> publist = arcPubList.getResults();
		if(publist==null||publist.size()==0){
			
		}else{
			resultsList = completeDocInforByArcPub(publist);
		}
 		//get deptname from table
		results.setResults(resultsList);
		results.setTotalrecord(arcPubList.getTotalrecord());
		return results;
	}
	public PageResult<DocTableBean> findAllDocTabInfor(String userId, int pageNum,
			int pageSize, String fileTypeId,String sortName,String sortOrder) {
		//first get the list from arcpubinfor table
		PageResult<DocTableBean> results = new PageResult<DocTableBean>();
		List<DocTableBean> resultsList = new ArrayList<DocTableBean>();
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT o.ID,o.ARC_ID,trim(o.REG_TIME) REG_TIME,trim(IS_INVALID) IS_INVALID,  ");
		sb.append("ARC_NAME ,b.DOC_CO ,b.DOC_NBR,REG_USER ,trim(FILE_START) FILE_START,DEP_POS ");
		sb.append("FROM biz_arc_pub_info o LEFT JOIN biz_arc_doc_info b ON b.ARC_ID = o.ARC_ID ");
		sb.append(" where o.DR='N'  AND ( o.IS_INVALID = '0' OR o.IS_INVALID = '1' ) "
				+ " AND o.EXPIRY_DATE_TIME > sysdate()  ");
		if(!isBlank(userId)){
			sb.append(" AND o.DATA_USER_ID = '").append(userId).append("'");
		}
		if(!isBlank(fileTypeId)){
			sb.append("  AND o.FILE_TYPE ='").append(fileTypeId).append("'");
		}
		if(StringUtils.isNotEmpty(sortName)){
			sb. append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sb.append(" order by o.REG_TIME "+sortOrder);
		}
		PageResult<DocTableBean> arcPubList = arcPubInfoDao.getPageData(DocTableBean.class, pageNum,pageSize,sb.toString());

 		//get deptname from table
		results.setResults(resultsList);
		results.setTotalrecord(arcPubList.getTotalrecord());
		return arcPubList;
	}
	
	private Boolean isBlank(String para){
		if(para==null||"".equalsIgnoreCase(para)||"null".equalsIgnoreCase(para)){
			return true;
		}else{
			return false;
		}
	}

	@Override
	public PageResult<DocInforShow> findAllDocInforByCondition(String userId,
			int pageNum, int pageSize, String searchArcType,
			String searcharcName, String searchdocNBR, String searchfileStart,
			String searchregYear, String regTimeBeginn, String regTimeEnd,
			String type) {
		PageResult<DocInforShow> results = new PageResult<DocInforShow>();
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		
		String where =" 1=1 AND o.dr='N' ";
		where = where+" AND ( o.isInvalid='0' OR o.isInvalid='1') AND o.expiryDateTime > sysdate() ";
		//where = where+" AND o.expiryDateTime > sysdate() ";
		where = where + "AND o.regUser='" + userId +"'";
		if(searchdocNBR!=null&&!"".equals(searchdocNBR)){
			where = where + " AND o.arcId IN ( SELECT doc.arcId FROM DocInfor doc WHERE doc.docNBR like '%" + searchdocNBR + "%')" ;
		}
		if(searchArcType!=null&&!"".equals(searchArcType)){
			where = where + "AND o.arcType='" + searchArcType +"'";
		}
		if(type!=null&&!"".equals(type)){
			where = where + "AND o.fileType='" + type +"'";
		}
		if(searcharcName!=null&&!"".equals(searcharcName)){
			where = where + " AND o.arcName like '%" + searcharcName + "%'";
		}
		if(searchfileStart!=null&&!"".equals(searchfileStart)){
			if(!"all".equals(searchfileStart)){
				if(FileStart.YIZUOFEI.getValue().equalsIgnoreCase(searchfileStart)){
					where = where + " AND o.isInvalid='" + "1" +"'";
				}else{
					where = where + " AND o.fileStart='" + searchfileStart +"'";
					where = where + " AND o.isInvalid='" + "0" +"'";
				}
			}
		}
		//year(date)='2011'
		if(searchregYear!=null&&!"".equals(searchregYear)){
			//year search condition
			where = where + " AND year(o.regTime)='" + searchregYear +"'";
		}
		//DATE(PageResult<ArcPubInfoEntity> arcPubList = arcPubInfoDao.getPageData(ArcPubInfoEntity.class, pageNum,pageSize,where.toString(), null, null);)
		if(regTimeBeginn!=null&&!"".equals(regTimeBeginn)){
			where = where + " AND o.regTime >='" + regTimeBeginn +"'";
		}
		if(regTimeEnd!=null&&!"".equals(regTimeEnd)){
			where = where + " AND o.regTime <'" + regTimeEnd +"'";
		}
		where = where + " ORDER BY o.regTime DESC";
		//get search result
		PageResult<ArcPubInfoEntity> arcPubList = arcPubInfoDao.getPageData(ArcPubInfoEntity.class, pageNum,pageSize,where, null, null);
		List<ArcPubInfoEntity> publist = arcPubList.getResults();
		if(publist==null||publist.size()==0){
			
		}else{
			resultsList = completeDocInforByArcPub(publist);
		}
		results.setResults(resultsList);
		results.setTotalrecord(arcPubList.getTotalrecord());
		return results;
	}
	public PageResult<DocTableBean> findAllDocTabInfor(String userId,
			int pageNum, int pageSize, String searchArcType,
			String searcharcName, String searchdocNBR, String searchfileStart,
			String searchregYear, String regTimeBeginn, String regTimeEnd,
			String type,String sortName, String sortOrder) {
		//PageResult<DocTableBean> results = new PageResult<DocTableBean>();
		//List<DocTableBean> resultsList = new ArrayList<DocTableBean>();
		
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT o.ID,o.ARC_ID,trim(o.REG_TIME) REG_TIME,trim(IS_INVALID) IS_INVALID,  ");
		sb.append("ARC_NAME ,b.DOC_CO ,b.DOC_NBR,REG_USER ,trim(FILE_START) FILE_START,DEP_POS ");
		sb.append("FROM biz_arc_pub_info o LEFT JOIN biz_arc_doc_info b ON b.ARC_ID = o.ARC_ID ");
		
		sb.append(" where  o.DR='N' ");
		sb.append(" AND ( o.IS_INVALID='0' OR o.IS_INVALID='1') AND o.EXPIRY_DATE_TIME > sysdate() ");
		sb.append(" AND o.DATA_USER_ID = '" + userId +"'");
		if(searchdocNBR!=null&&!"undefined".equals(searchdocNBR)&&!"".equals(searchdocNBR)){
			sb.append(" AND  REG_USER like '%" + searchdocNBR + "%'") ;
		}
		if(searchArcType!=null&&!"".equals(searchArcType)){
			sb.append(" AND o.ARC_TYPE = '" + searchArcType +"'");
		}
		if(type!=null&&!"".equals(type)){
			sb.append(" AND o.FILE_TYPE = '" + type +"'");
		}
		if(searcharcName!=null&&!"undefined".equals(searcharcName)&&!"".equals(searcharcName)){
 			sb.append(" AND o.ARC_NAME like '%" + searcharcName.trim() + "%'");
		}
		if(searchfileStart!=null&&!"".equals(searchfileStart)){
			if(!"all".equals(searchfileStart)){
				if(FileStart.YIZUOFEI.getValue().equalsIgnoreCase(searchfileStart)){
					sb.append(" AND o.IS_INVALID = '" + "1" +"'");
				}else{
					sb.append(" AND o.FILE_START = '" + searchfileStart +"'");
					sb.append(" AND o.IS_INVALID = '" + "0" +"'");
				}
			}
		}
		//year(date)='2011'
		if(searchregYear!=null&&!"".equals(searchregYear)){
			//year search condition
			sb.append(" AND year(o.REG_TIME)='" + searchregYear +"'");
		}
		//DATE(PageResult<ArcPubInfoEntity> arcPubList = arcPubInfoDao.getPageData(ArcPubInfoEntity.class, pageNum,pageSize,where.toString(), null, null);)
		if(regTimeBeginn!=null&&!"".equals(regTimeBeginn)){
			sb.append(" AND o.REG_TIME >='" + regTimeBeginn +"'");
		}
		if(regTimeEnd!=null&&!"".equals(regTimeEnd)){
			sb.append(" AND o.REG_TIME <'" + regTimeEnd +"'");
		}
		if(StringUtils.isNotEmpty(sortName)){
			sb. append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sb.append(" order by o.REG_TIME "+sortOrder);
		}
		//get search result
		PageResult<DocTableBean> arcPubList = arcPubInfoDao.getPageData(DocTableBean.class, pageNum,pageSize,sb.toString());
		
		//results.setResults(arcPubList);
		//results.setTotalrecord(arcPubList.getTotalrecord());
		return arcPubList;
	}

	@Override
	public List<DocInforShow> findAllDocInforByCondition(String userName,
			String searchArcType, String searcharcName, String searchdocNBR,
			String searchfileStart, String searchregYear, String regTimeBeginn,
			String regTimeEnd) {
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		String where =" 1=1 AND o.dr='N' ";
		where = where+" AND (o.isInvalid='0' OR o.isInvalid='0')  AND o.expiryDateTime > sysdate() ";
		where = where + "AND o.regUser='" + userName +"'";
		if(searchdocNBR!=null&&!"".equals(searchdocNBR)){
			where = where + " AND o.arcId IN ( SELECT doc.arcId FROM DocInfor doc WHERE doc.docNBR like '%" + searchdocNBR + "%')" ;
		}
		if(searchArcType!=null&&!"".equals(searchArcType)){
			where = where + "AND o.arcType='" + searchArcType +"'";
		}
		if(searcharcName!=null&&!"".equals(searcharcName)){
			where = where + " AND o.arcName like '%" + searcharcName + "%'";
		}
		if(searchfileStart!=null&&!"".equals(searchfileStart)){
			if(!"all".equals(searchfileStart)){
				where = where + " AND o.fileStart='" + searchfileStart +"'";
			}
		}
		//year(date)='2011'
		if(searchregYear!=null&&!"".equals(searchregYear)){
			//year search condition
			where = where + " AND year(o.regTime)='" + searchregYear +"'";
		}
		//DATE(PageResult<ArcPubInfoEntity> arcPubList = arcPubInfoDao.getPageData(ArcPubInfoEntity.class, pageNum,pageSize,where.toString(), null, null);)
		if(regTimeBeginn!=null&&!"".equals(regTimeBeginn)){
			where = where + " AND o.regTime >='" + regTimeBeginn +"'";
		}
		if(regTimeEnd!=null&&!"".equals(regTimeEnd)){
			where = where + " AND o.regTime <'" + regTimeEnd +"'";
		}
		where = where + " ORDER BY o.regTime DESC";
		List<ArcPubInfoEntity> pubEntities = arcPubInfoDao.getListBySql(ArcPubInfoEntity.class, where, null, null);
		
		if(pubEntities==null||pubEntities.size()==0){
			
		}else{
			resultsList = completeDocInforByArcPub(pubEntities);
		}
		return resultsList;
	}
	
	@Override
	public List<DocInforShow> findAllDocInforByCondition(String userName,
			String searchArcType, String selectionIds) {
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		String where =" 1=1 AND o.dr='N' ";
		/*where = where+" AND (o.isInvalid='0' OR o.isInvalid='0')  AND o.expiryDateTime > sysdate() ";
		where = where + " AND o.regUser='" + userName +"'";
		if(searchArcType!=null&&!"".equals(searchArcType)){
			where = where + " AND o.arcType='" + searchArcType +"'";
		}*/
		String[] ary = selectionIds.split(",");
		if(StringUtils.isNoneEmpty(ary)){
			where = where+" AND o.Id in (";
			where = where+"'"+ary[0]+"'";
			for(int i=1;i<ary.length;i++){
				where = where+",'"+ary[i]+"'";
			}
			where = where+" )";
		}
		//DATE(PageResult<ArcPubInfoEntity> arcPubList = arcPubInfoDao.getPageData(ArcPubInfoEntity.class, pageNum,pageSize,where.toString(), null, null);)
		where = where + " ORDER BY o.regTime DESC";
		List<ArcPubInfoEntity> pubEntities = arcPubInfoDao.getListBySql(ArcPubInfoEntity.class, where, null, null);
		
		if(pubEntities==null||pubEntities.size()==0){
			
		}else{
			resultsList = completeDocInforByArcPub(pubEntities);
		}
		return resultsList;
	}
	
	@Override
	public List<DocInforShow> findAllDocInforByTitle(String userName,
			String searchArcType, String title) {
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		String where =" 1=1 AND o.dr='N' ";
		where = where+" AND (o.isInvalid='0' OR o.isInvalid='0')  AND o.expiryDateTime > sysdate() ";
		where = where + "AND o.regUser='" + userName +"'";
		if(searchArcType!=null&&!"".equals(searchArcType)){
			where = where + "AND o.arcType='" + searchArcType +"'";
		}
		if(title!=null&&!"".equals(title)){
			where = where + " AND o.arcName like '%" + title + "%'";
		}
		where = where + " ORDER BY o.regTime DESC";
		List<ArcPubInfoEntity> pubEntities = arcPubInfoDao.getListBySql(ArcPubInfoEntity.class, where, null, null);
		
		if(pubEntities==null||pubEntities.size()==0){
			
		}else{
			resultsList = completeDocInforByArcPub(pubEntities);
		}
		return resultsList;
	}

	@Override
	public List<DocInforShow> findAllDocInforByCondition(String userName,
			String searchArcType, String globalFileType, String searcharcName,
			String searchdocNBR, String searchfileStart, String searchregYear,
			String regTimeBeginn, String regTimeEnd) {
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		String where =" 1=1 AND o.dr='N' ";
		where = where+" AND ( o.isInvalid='0' OR o.isInvalid='1') AND o.expiryDateTime > sysdate() ";
		//where = where+" AND o.expiryDateTime > sysdate() ";
		where = where + " AND o.regUser='" + userName +"'";
		if(searchdocNBR!=null&&!"".equals(searchdocNBR)){
			where = where + " AND o.arcId IN ( SELECT doc.arcId FROM DocInfor doc WHERE doc.docNBR like '%" + searchdocNBR + "%')" ;
		}
		if(searchArcType!=null&&!"".equals(searchArcType)){
			where = where + " AND o.arcType='" + searchArcType +"'";
		}
		if(globalFileType!=null&&!"".equals(globalFileType)){
			where = where + " AND o.fileType='" + globalFileType +"'";
		}		
		if(searcharcName!=null&&!"".equals(searcharcName)){
			where = where + " AND o.arcName like '%" + searcharcName + "%'";
		}
		if(searchfileStart!=null&&!"".equals(searchfileStart)){
			if(!"all".equals(searchfileStart)){
				if(FileStart.YIZUOFEI.getValue().equalsIgnoreCase(searchfileStart)){
					where = where + " AND o.isInvalid='" + "1" +"'";
				}else{
					where = where + " AND o.fileStart='" + searchfileStart +"'";
					where = where + " AND o.isInvalid='" + "0" +"'";
				}
			}else{

			}
		}
		//year(date)='2011'
		if(searchregYear!=null&&!"".equals(searchregYear)){
			//year search condition
			where = where + " AND year(o.regTime)='" + searchregYear +"'";
		}
		//DATE(PageResult<ArcPubInfoEntity> arcPubList = arcPubInfoDao.getPageData(ArcPubInfoEntity.class, pageNum,pageSize,where.toString(), null, null);)
		if(regTimeBeginn!=null&&!"".equals(regTimeBeginn)){
			where = where + " AND o.regTime >='" + regTimeBeginn +"'";
		}
		if(regTimeEnd!=null&&!"".equals(regTimeEnd)){
			where = where + " AND o.regTime <='" + regTimeEnd +"'";
		}
		where = where + " ORDER BY o.regTime DESC";
		List<ArcPubInfoEntity> pubEntities = arcPubInfoDao.getListBySql(ArcPubInfoEntity.class, where, null, null);
		
		if(pubEntities==null||pubEntities.size()==0){
			
		}else{
			resultsList = completeDocInforByArcPub(pubEntities);
		}
		return resultsList;
	}
	
	@Override
	public List<DocInforShow> findAllDocInforByCondition(String userName,
			String searchArcType, String globalFileType, String selectionIds) {
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		String where =" 1=1 AND o.dr='N' ";
		/*where = where+" AND ( o.isInvalid='0' OR o.isInvalid='1') AND o.expiryDateTime > sysdate() ";
		//where = where+" AND o.expiryDateTime > sysdate() ";
		where = where + " AND o.regUser='" + userName +"'";
		if(searchArcType!=null&&!"".equals(searchArcType)){
			where = where + " AND o.arcType='" + searchArcType +"'";
		}
		if(globalFileType!=null&&!"".equals(globalFileType)){
			where = where + " AND o.fileType='" + globalFileType +"'";
		}*/	
		String[] ary = selectionIds.split(",");
		if(StringUtils.isNoneEmpty(ary)){
			where = where+" AND o.Id in (";
			where = where+"'"+ary[0]+"'";
			for(int i=1;i<ary.length;i++){
				where = where+",'"+ary[i]+"'";
			}
			where = where+" )";
		}
		where = where + " ORDER BY o.regTime DESC";
		List<ArcPubInfoEntity> pubEntities = arcPubInfoDao.getListBySql(ArcPubInfoEntity.class, where, null, null);
		
		if(pubEntities==null||pubEntities.size()==0){
			
		}else{
			resultsList = completeDocInforByArcPub(pubEntities);
		}
		return resultsList;
	}
	
	@Override
	public List<DocInforShow> findAllDocInforByTitle(String userName,
			String searchArcType, String globalFileType, String title) {
		List<DocInforShow> resultsList = new ArrayList<DocInforShow>();
		String where =" 1=1 AND o.dr='N' ";
		where = where+" AND ( o.isInvalid='0' OR o.isInvalid='1') AND o.expiryDateTime > sysdate() ";
		//where = where+" AND o.expiryDateTime > sysdate() ";
		where = where + " AND o.regUser='" + userName +"'";
		if(searchArcType!=null&&!"".equals(searchArcType)){
			where = where + " AND o.arcType='" + searchArcType +"'";
		}
		if(globalFileType!=null&&!"".equals(globalFileType)){
			where = where + " AND o.fileType='" + globalFileType +"'";
		}		
		if(title!=null&&!"".equals(title)){
			where = where + " AND o.arcName like '%" + title + "%'";
		}
		where = where + " ORDER BY o.regTime DESC";
		List<ArcPubInfoEntity> pubEntities = arcPubInfoDao.getListBySql(ArcPubInfoEntity.class, where, null, null);
		
		if(pubEntities==null||pubEntities.size()==0){
			
		}else{
			resultsList = completeDocInforByArcPub(pubEntities);
		}
		return resultsList;
	}

}
