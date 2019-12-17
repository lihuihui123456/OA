//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：张多一$手机：18701386200#
// SVN版本号                    日   期                 作     者              变更记录
// IBorrInforService-001     2016/12/21   张多一                  新建
//*********************************************************************
package com.yonyou.aco.arc.borr.service.impl;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yonyou.aco.arc.borr.dao.IBorrInforDao;
import com.yonyou.aco.arc.borr.entity.BorrInfoTableBean;
import com.yonyou.aco.arc.borr.entity.BorrInfor;
import com.yonyou.aco.arc.borr.entity.BorrInforWebShow;
import com.yonyou.aco.arc.borr.entity.BorrSHR;
import com.yonyou.aco.arc.borr.entity.BorrType;
import com.yonyou.aco.arc.borr.entity.IWebDocumentBean;
import com.yonyou.aco.arc.borr.service.IBorrInforService;
import com.yonyou.aco.arc.otherarc.dao.IArcPubInfoDao;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.aco.arc.type.dao.IActTypeDao;
import com.yonyou.aco.arc.type.entity.ArcTypeEntity;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.org.dao.IDeptDao;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.user.dao.IUserDao;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.sys.iweboffice.entity.IWebDocumentEntity;
import com.yonyou.cap.sys.iweboffice.service.DocumentService;

/**
 * <p>概述：实现借阅管理service层接口
 * <p>功能：实现在service层提供借阅管理接口IBorrInforService
 * <p>作者：张多一
 * <p>创建时间：2016-12-28
 * <p>类调用特殊情况：无
 */
@Service
public class BorrInforServiceImpl implements IBorrInforService {
	
	@Autowired
	DocumentService documentService;
	@Resource
	IBorrInforDao borrInforDao;
	@Resource
	IUserDao userDao;
	@Resource
	IDeptDao deptDao;
	@Resource
	IArcPubInfoDao arcPubDao;
	@Resource
	IActTypeDao arcTypeDao;

	@Override
	public PageResult<BorrInforWebShow> findBorrInforByWhereSql(int pageNum,
			int pageSize, String whereSql) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public PageResult<BorrInforWebShow> findBorrInfor(int pageNum, int pageSize) {
		
		PageResult<BorrInfor> borrList = borrInforDao.getPageData(BorrInfor.class, pageNum, pageSize," o.dr='N' ",null,null);
		return convertToWebShow(borrList);
	}

	private PageResult<BorrInforWebShow> convertToWebShow(
			PageResult<BorrInfor> borrList) {
		if(borrList!=null&&borrList.getResults()!=null){
			List<BorrInfor> borrInforlist = borrList.getResults();
			PageResult<BorrInforWebShow> result = new PageResult<BorrInforWebShow>();
			List<BorrInforWebShow> showList = new ArrayList<BorrInforWebShow>();
			BorrInforWebShow item = null;
			//generate the sql
			for(BorrInfor temp: borrInforlist){
				item = new BorrInforWebShow();
				item.setBorrInfor(temp);
				showList.add(item);
			}
			
			StringBuffer userWherSql = new StringBuffer();
			userWherSql.append(" o.userId IN ( ");
			if(borrInforlist==null||borrInforlist.size()==0){
				userWherSql.append("'' ");
			}else{
				for(BorrInfor entity:borrInforlist){
					userWherSql.append("'").append(entity.getCreUser()).append("',");
					userWherSql.append("'").append(entity.getBorrUser()).append("',");
				}
			}
			String userWhereString = userWherSql.toString();
			userWhereString = userWhereString.substring(0, userWhereString.length()-1);
			userWhereString = userWhereString + ")";
			List<User> userList = userDao.getListBySql(User.class, userWhereString, null, null);
			
			//arcName
			
			StringBuffer arcPubWhereSql = new StringBuffer();
			arcPubWhereSql.append(" o.arcId IN ( ");
			if(borrInforlist==null||borrInforlist.size()==0){
				arcPubWhereSql.append("'' ");
			}else{
				for(BorrInfor entity:borrInforlist){
					arcPubWhereSql.append("'").append(entity.getArcId()).append("',");
				}
			}
			String arcPubWhereString = arcPubWhereSql.toString();
			arcPubWhereString = arcPubWhereString.substring(0, arcPubWhereString.length()-1);
			arcPubWhereString = arcPubWhereString + ")";
			List<ArcPubInfoEntity> arcPubList = arcPubDao.getListBySql(ArcPubInfoEntity.class, arcPubWhereString, null, null);
			
			List<ArcTypeEntity> arcTypeList = new ArrayList<ArcTypeEntity>();
			String arcTypeWhere = " o.id IN ( ";
			if(arcPubList==null||arcPubList.size()==0){
				arcTypeWhere = arcTypeWhere + " '' ";
			}else{
				for(ArcPubInfoEntity entity:arcPubList){
					arcTypeWhere = arcTypeWhere + "'" + entity.getArcType() +"',";
				}
				arcTypeWhere = arcTypeWhere.substring(0, arcTypeWhere.length()-1);
				arcTypeWhere += ")" ;
				arcTypeList = arcTypeDao.getListBySql(ArcTypeEntity.class, arcTypeWhere, null, null);
			}
			
			List<Dept> deptList = new ArrayList<Dept>();
			String deptWhere = " o.deptCode IN ( ";
			if(borrInforlist==null||borrInforlist.size()==0){
				deptWhere = deptWhere + " '' ";
			}else{
				for(BorrInfor entity:borrInforlist){
					deptWhere = deptWhere + "'" + entity.getDataDeptCode() +"',";
				}
				deptWhere = deptWhere.substring(0, deptWhere.length()-1);
				deptWhere += ")" ;
				deptList = deptDao.getListBySql(Dept.class, deptWhere, null, null);
			}
			
			List<Dept> borrDeptList = new ArrayList<Dept>();
			String borrDeptWhere = " o.deptId IN ( ";
			if(borrInforlist==null||borrInforlist.size()==0){
				borrDeptWhere = borrDeptWhere + " '' ";
			}else{
				for(BorrInfor entity:borrInforlist){
					borrDeptWhere = borrDeptWhere + "'" + entity.getBorrDept() +"',";
				}
				borrDeptWhere = borrDeptWhere.substring(0, borrDeptWhere.length()-1);
				borrDeptWhere += ")" ;
				borrDeptList = deptDao.getListBySql(Dept.class, borrDeptWhere, null, null);
			}
			
			
			//set the user real name in the docinforshow
			for(BorrInforWebShow showtemp :showList){
				//set the creUser name
				for(User usertemp:userList){
					if(showtemp.getBorrInfor().getCreUser().equals(usertemp.getUserId())){
						showtemp.setCreUserName(usertemp.getUserName());
					}
					if(showtemp.getBorrInfor().getBorrUser().equals(usertemp.getUserId())){
						showtemp.setBorrUserName(usertemp.getUserName());
					}
				}
				//set arcName
				for(ArcPubInfoEntity entity: arcPubList){
					if(showtemp.getBorrInfor().getArcId().equals(entity.getArcId())){
						showtemp.setArcName(entity.getArcName());

					}
				}
				
				//set arcType name
				for(ArcTypeEntity type:arcTypeList){
					if(type.getId().equals(showtemp.getBorrInfor().getArcType())){
						showtemp.setArcTypeName(type.getTypeName());
					}
				}
				
				//set borr dept name
				for(Dept deptTemp: borrDeptList){
					if(showtemp.getBorrInfor().getBorrDept().equals(deptTemp.getDeptId())){
						showtemp.setJieyueBumen(deptTemp.getDeptName());
					}
				}
				
				//set dept name
				for(Dept deptTemp: deptList){
					if(showtemp.getBorrInfor().getDataDeptCode().equals(deptTemp.getDeptCode())){
						showtemp.setDengjiBumen(deptTemp.getDeptName());
					}
				}
//				//set the fileuser name
//				for(User userTemp: fileUsers){
//					if(showtemp.getArcPubInfor().getFileUser().equals(userTemp.getUserId())){
//						showtemp.setFileUserName(userTemp.getUserName());
//					}
//				}
				//according to isBack to set the actltime
				if("N".equals(showtemp.getBorrInfor().getIsBack())){
					showtemp.getBorrInfor().setActlTime(null);
				}
			}
			
			result.setResults(showList);
			result.setTotalrecord(borrList.getTotalrecord());
			return  result;
		}
		return null;
	}

	@Override
	public BorrInforWebShow findBorrInforWebShowById(String id) {
		BorrInfor temp = borrInforDao.findEntityByPK(BorrInfor.class, id);
		BorrInforWebShow result = new BorrInforWebShow();
		//SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String nbrTime = temp.getNbrTime().substring(0, 19);
		temp.setNbrTime(nbrTime);
		String creTime = temp.getCreTime().substring(0, 19);
		temp.setCreTime(creTime);
		String borrTime = temp.getBorrTime().substring(0, 19);
		temp.setBorrTime(borrTime);
		
		if(temp.getPlanTime()!=null){
			temp.setPlanTime(temp.getPlanTime().substring(0, 19));
		}
		if(temp.getActlTime()!=null){
			temp.setActlTime(temp.getActlTime().substring(0, 19));
		}
		
		if("Y".equals(temp.getIsSet())&&"N".equals(temp.getIsBack())){
			temp.setActlTime(null);
		}
		result.setBorrInfor(temp);
		User user = userDao.findEntityByPK(User.class, temp.getCreUser());
		result.setCreUserName(user.getUserName());
		user = userDao.findEntityByPK(User.class, temp.getBorrUser());
		result.setBorrUserName(user.getUserName());
		Dept dept = deptDao.findById(temp.getBorrDept());
		result.setJieyueBumen(dept.getDeptName());
//		result.setJieyueBumen(BorrDept.getFileTypeByValue(temp.getBorrDept()).getChname());
		List<ArcPubInfoEntity> entity = arcPubDao.findByProperty(ArcPubInfoEntity.class, "arcId", temp.getArcId());
		if(entity!=null&&entity.size()==1){
			result.setArcName(entity.get(0).getArcName());
		}
		return result;
	}

	@Override
	public void delBorrInforById(String id) {
		BorrInfor temp = borrInforDao.findEntityByPK(BorrInfor.class, id);
		temp.setDr("Y");
		borrInforDao.update(temp);
	}

	@Override
	public void upDateBorrInfor(BorrInfor borrInfor) throws Exception {
		
		BorrInfor temp = borrInforDao.findEntityByPK(BorrInfor.class, borrInfor.getId());
		//copy the property to the target
		temp.setActlTime(borrInfor.getActlTime());
		temp.setArcId(borrInfor.getArcId());
		
		if(borrInfor.getArcId()==null||"".equals(borrInfor.getArcId())||"null".equalsIgnoreCase(borrInfor.getArcId())){
			//arcid is empty
		}else{
			ArcPubInfoEntity pubInfor = arcPubDao.selectArcPubInfoEntityByArcId(borrInfor.getArcId());
			temp.setArcType(pubInfor.getArcType());
		}
		
		temp.setArcName(borrInfor.getArcName());
		temp.setAttId(borrInfor.getAttId());
		temp.setBorNBR(borrInfor.getBorNBR());
		temp.setBorrDept(borrInfor.getBorrDept());
		temp.setBorrMobile(borrInfor.getBorrMobile());
		temp.setBorrSHR(borrInfor.getBorrSHR());
		temp.setBorrTime(borrInfor.getBorrTime());
		temp.setBorrType(borrInfor.getBorrType());
		temp.setBorrUser(borrInfor.getBorrUser());
		temp.setCreTime(borrInfor.getCreTime());
		temp.setCreUser(borrInfor.getCreUser());
		temp.setIsSet(borrInfor.getIsSet());
		temp.setLeaderOpinion(borrInfor.getLeaderOpinion());
		temp.setNbrTime(borrInfor.getNbrTime());
		temp.setPlanTime(borrInfor.getPlanTime());
		temp.setRemarks(borrInfor.getRemarks());
		temp.setIsBack(borrInfor.getIsBack());
		List<ArcPubInfoEntity> entity = arcPubDao.findByProperty(ArcPubInfoEntity.class, "arcId", borrInfor.getArcId());
		if(entity!=null&&entity.size()==1){
			temp.setArcType(entity.get(0).getArcType());
		}else{
			throw new Exception(" the arc id is not unique or exist!");
		}
		borrInforDao.update(temp);
	}

	@Override
	public void saveBorrInfor(BorrInfor borrInfor) throws Exception {
		borrInfor.setId(null);
		borrInfor.setDr("N");
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String ts = (df.format(new Date())).toString();
		borrInfor.setCreTime(ts);
		borrInfor.setTs(ts);
		List<ArcPubInfoEntity> entity = arcPubDao.findByProperty(ArcPubInfoEntity.class, "arcId", borrInfor.getArcId());
		if(entity!=null&&entity.size()==1){
			borrInfor.setArcType(entity.get(0).getArcType());
		}else{
			throw new Exception(" the arc id is not unique or exist!");
		}
		borrInforDao.save(borrInfor);
	}

	@Override
	public BorrInfor findBorrInforById(String id) {
		return borrInforDao.findEntityByPK(BorrInfor.class, id);
	}

	@Override
	public void setReturnBorrInfor(BorrInfor temp) {
		borrInforDao.update(temp);
		
	}

	@Override
	public PageResult<BorrInforWebShow> findAllDocInforByCondition(int pageNum,
			int pageSize, String dengjiBumen_, String arcType,
			String jieyueBumenId_, String arcName, String borrUser,
			String planTimeBeginn, String planTimeEnd, String actlTimeBeginn,
			String actlTimeEnd, String isSet) throws Exception {
		
		
		String where =" 1=1 AND o.dr = 'N' ";
		if(dengjiBumen_!=null&&!"".equals(dengjiBumen_)){
			Dept depts = deptDao.findById(dengjiBumen_);
			if(depts!=null){
				String deptCode = depts.getDeptCode();
				where = where + "AND o.dataDeptCode='" + deptCode +"'" ;
			}else{
				throw new Exception("dept code not unique or exist!");
			}
		}
		
		if(arcType!=null&&!"".equals(arcType)&&!"ALL".equalsIgnoreCase(arcType)){
			where = where + "AND o.arcType='" + arcType +"'";
		}
		
		if(isSet!=null&&!"".equals(isSet)&&!"ALL".equalsIgnoreCase(isSet)){
			where = where + "AND o.isSet='" + isSet +"'";
		}
		if(jieyueBumenId_!=null&&!"".equals(jieyueBumenId_)){
			where = where + "AND o.borrDept='" + jieyueBumenId_ +"'" ;
		}
		if(arcName!=null&&!"".equals(arcName)){
			where = where + "AND o.arcName='" + arcName +"'";
		}
		if(borrUser!=null&&!"".equals(borrUser)){
			where = where + "AND o.borrUser='" + borrUser +"'";
		}
		if(planTimeBeginn!=null&&!"".equals(planTimeBeginn)){
			where = where + " AND o.planTime >='" + planTimeBeginn +"'";
		}
		if(planTimeEnd!=null&&!"".equals(planTimeEnd)){
			where = where + " AND o.planTime <='" + planTimeEnd +"'";
		}
		
		if(actlTimeBeginn!=null&&!"".equals(actlTimeBeginn)){
			where = where + " AND o.actlTime >='" + actlTimeBeginn +"'";
		}
		if(actlTimeEnd!=null&&!"".equals(actlTimeEnd)){
			where = where + " AND o.actlTime <='" + actlTimeEnd +"'";
		}
			
		PageResult<BorrInfor> borrList = borrInforDao.getPageData(BorrInfor.class, pageNum,pageSize,where, null, null);
		return convertToWebShow(borrList);
	}

	@Override
	public List<BorrInforWebShow> findAllDocInforByCondition(
			String dengjiBumen_, String arcType, String jieyueBumenId_,
			String arcName, String borrUser, String planTimeBeginn,
			String planTimeEnd, String actlTimeBeginn, String actlTimeEnd,
			String isSet) throws Exception {
		
		String where =" 1=1 AND o.dr = 'N' ";
		if(dengjiBumen_!=null&&!"".equals(dengjiBumen_)){
			Dept depts = deptDao.findById(dengjiBumen_);
			if(depts!=null){
				String deptCode = depts.getDeptCode();
				where = where + "AND o.dataDeptCode='" + deptCode +"'" ;
			}else{
				throw new Exception("dept code not unique or exist!");
			}
		}
		
		if(arcType!=null&&!"".equals(arcType)&&!"ALL".equalsIgnoreCase(arcType)){
			where = where + "AND o.arcType='" + arcType +"'";
		}
		
		if(isSet!=null&&!"".equals(isSet)&&!"ALL".equalsIgnoreCase(isSet)){
			where = where + "AND o.isSet='" + isSet +"'";
		}
		if(jieyueBumenId_!=null&&!"".equals(jieyueBumenId_)){
			where = where + "AND o.borrDept='" + jieyueBumenId_ +"'" ;
		}
		if(arcName!=null&&!"".equals(arcName)){
			where = where + "AND o.arcName='" + arcName +"'";
		}
		if(borrUser!=null&&!"".equals(borrUser)){
			where = where + "AND o.borrUser='" + borrUser +"'";
		}
		if(planTimeBeginn!=null&&!"".equals(planTimeBeginn)){
			where = where + " AND o.planTime >='" + planTimeBeginn +"'";
		}
		if(planTimeEnd!=null&&!"".equals(planTimeEnd)){
			where = where + " AND o.planTime <='" + planTimeEnd +"'";
		}
		
		if(actlTimeBeginn!=null&&!"".equals(actlTimeBeginn)){
			where = where + " AND o.actlTime >='" + actlTimeBeginn +"'";
		}
		if(actlTimeEnd!=null&&!"".equals(actlTimeEnd)){
			where = where + " AND o.actlTime <='" + actlTimeEnd +"'";
		}
		
		List<BorrInfor> list = borrInforDao.getListBySql(BorrInfor.class, where, null, null);
		
		PageResult<BorrInfor> tmp = new PageResult<BorrInfor>();
		tmp.setResults(list);
		
		return convertToWebShow(tmp).getResults();
	}
	@Override
	public PageResult<IWebDocumentBean> listEnclosureAndTitle(int pagenum,
			int pagesize,String wheresql) {
		return borrInforDao.listEnclosureAndTitle(pagenum, pagesize,wheresql);
	}

	@Override
	public PageResult<BorrInforWebShow> findBorrInfor(String userId,
			int pageNum, int pageSize) {
		PageResult<BorrInfor> borrList = borrInforDao.getPageData(BorrInfor.class, pageNum, pageSize," o.dr='N' AND o.dataUserId=? ORDER BY o.ts DESC",new Object[]{userId},null);
		return convertToWebShow(borrList);
	}
	
	@Override
	public PageResult<BorrInfoTableBean> doFindAllBorrInforTableBean(String userId,
			int pageNum, int pageSize,String queryPams,String sortName,String sortOrder,String arcName) {
		StringBuilder sb = new StringBuilder();
		try {
			
			sb.append("SELECT a.ID ID,a.ARC_NAME ARC_NAME,e.DEPT_NAME dengjibumen,f.TYPE_NAME TYPE_NAME,c.USER_NAME jiyueren,d.DEPT_NAME jiyuebumen,b.USER_NAME blr,trim(a.PLAN_TIME) PLAN_TIME,trim(a.ACTL_TIME) ACTL_TIME,trim(a.IS_BACK) IS_BACK,"
					+ " trim(a.IS_RET) IS_RET FROM  biz_arc_borr_info a left join isc_user b on a.DATA_USER_ID = b.USER_ID ");
			sb.append(" left join isc_user c on a.BORR_USER = c.USER_ID ");
			sb.append(" left join isc_dept d on a.BORR_DEPT = d.DEPT_ID ");
			sb.append(" left join isc_dept e on a.DATA_DEPT_CODE = e.DEPT_CODE ");
			sb.append(" left join biz_arc_type_info f on a.ARC_TYPE = f.ID");
			sb.append(" where a.DR='N' and a.DATA_USER_ID = '"+userId+"'");
			sb.append("  and a.ARC_NAME like '%"+arcName.trim()+"%'");
			String wheresql = getParams(queryPams);
			if(StringUtils.isNotEmpty(wheresql)){
				sb.append(wheresql);
			}
			if(StringUtils.isNotEmpty(sortName)){
				sb.append("order by CONVERT( "+sortName+" USING gbk) "+sortOrder);
			}else{
				sb.append(" ORDER BY a.TS DESC");
			}
			PageResult<BorrInfoTableBean> borrList = borrInforDao.getPageData(BorrInfoTableBean.class, pageNum, pageSize,sb.toString());
			return borrList;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@Override
	public List<BorrInfoTableBean> findAllDocInfor(String userId,String[] arr){
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT a.ID ID,a.ARC_NAME ARC_NAME,e.DEPT_NAME dengjibumen,f.TYPE_NAME TYPE_NAME,c.USER_NAME jiyueren,d.DEPT_NAME jiyuebumen,b.USER_NAME blr,trim(a.PLAN_TIME) PLAN_TIME,trim(a.ACTL_TIME) ACTL_TIME,trim(a.IS_BACK) IS_BACK,"
				+ " trim(a.IS_RET) IS_RET FROM  biz_arc_borr_info a left join isc_user b on a.DATA_USER_ID = b.USER_ID ");
		sb.append(" left join isc_user c on a.BORR_USER = c.USER_ID ");
		sb.append(" left join isc_dept d on a.BORR_DEPT = d.DEPT_ID ");
		sb.append(" left join isc_dept e on a.DATA_DEPT_CODE = e.DEPT_CODE ");
		sb.append(" left join biz_arc_type_info f on a.ARC_TYPE = f.ID");
		sb.append(" where a.DR='N' and a.DATA_USER_ID = '"+userId+"'");
		if(arr.length > 0 && !arr[0].equals("1")){
			sb.append(" AND a.ID IN (");
			sb.append("'"+arr[0]+"'");
			for(int i=1;i<arr.length;i++){
				sb.append(",'"+arr[i]+"'");
			}
			sb.append(" )");
		}
		int pageNum = 0;
		int pageSize = 10;
		PageResult<BorrInfoTableBean> borrList = borrInforDao.getPageData(BorrInfoTableBean.class, pageNum, pageSize,sb.toString());
		return borrList.getResults();
	}
	
	@Override
	public List<BorrInforWebShow> findAllDocInforByCondition(String userId,
			String dengjiBumen_, String arcType, String jieyueBumenId_,
			String arcName, String borrUser, String planTimeBeginn,
			String planTimeEnd, String actlTimeBeginn, String actlTimeEnd,
			String isSet,String[] arr,String hideInputWord) throws Exception {
		String where =" 1=1 AND o.dr = 'N' ";
		where = where + "AND o.dataUserId='" + userId +"'";
		if(dengjiBumen_!=null&&!"".equals(dengjiBumen_)){
			Dept depts = deptDao.findById(dengjiBumen_);
			if(depts!=null){
				String deptCode = depts.getDeptCode();
				where = where + "AND o.dataDeptCode='" + deptCode +"'" ;
			}else{
				throw new Exception("dept code not unique or exist!");
			}
		}
		
		if(arcType!=null&&!"".equals(arcType)&&!"ALL".equalsIgnoreCase(arcType)){
			where = where + "AND o.arcType='" + arcType +"'";
		}
		
		if(isSet!=null&&!"".equals(isSet)&&!"ALL".equalsIgnoreCase(isSet)){
			if("N".equals(isSet)){
				where = where + "AND o.isSet='" + "Y" +"'" + " AND o.isBack='N' ";
			}else{
				if("Y".equals(isSet)){
					where = where + "AND o.isSet='" + "Y" +"'" + " AND o.isBack='Y' ";
					//actltime not in sql
					if(planTimeBeginn!=null&&!"".equals(planTimeBeginn)){
						where = where + " AND o.planTime >='" + planTimeBeginn +"'";
					}
					if(planTimeEnd!=null&&!"".equals(planTimeEnd)){
						where = where + " AND o.planTime <'" + planTimeEnd +"'";
					}
				}else if("0".equals(isSet)){
					where = where + "AND o.isSet='" + "Y" +"'" + " AND o.isBack='Y' ";
					//actltime and plantime both in sql;
					if(planTimeBeginn!=null&&!"".equals(planTimeBeginn)){
						where = where + " AND o.planTime >='" + planTimeBeginn +"'";
					}
					if(planTimeEnd!=null&&!"".equals(planTimeEnd)){
						where = where + " AND o.planTime <'" + planTimeEnd +"'";
					}
					
					if(actlTimeBeginn!=null&&!"".equals(actlTimeBeginn)){
						where = where + " AND o.actlTime >='" + actlTimeBeginn +"'";
					}
					if(actlTimeEnd!=null&&!"".equals(actlTimeEnd)){
						where = where + " AND o.actlTime <'" + actlTimeEnd +"'";
					}
				}
			}
		}else{
			//sear all status
			if(planTimeBeginn!=null&&!"".equals(planTimeBeginn)){
				where = where + " AND o.isSet='Y' AND o.planTime >='" + planTimeBeginn +"'";
			}
			if(planTimeEnd!=null&&!"".equals(planTimeEnd)){
				where = where + " AND o.isSet='Y' AND o.planTime <'" + planTimeEnd +"'";
			}
			
			if(actlTimeBeginn!=null&&!"".equals(actlTimeBeginn)){
				where = where + " AND o.isBack='Y' AND o.actlTime >='" + actlTimeBeginn +"'";
			}
			if(actlTimeEnd!=null&&!"".equals(actlTimeEnd)){
				where = where + " AND o.isBack='Y' AND o.actlTime <'" + actlTimeEnd +"'";
			}
			
		}
		if(jieyueBumenId_!=null&&!"".equals(jieyueBumenId_)){
			where = where + "AND o.borrDept='" + jieyueBumenId_ +"'" ;
		}
		if(arcName!=null&&!"".equals(arcName)){
			where = where + "AND o.arcName like '%" + arcName +"%'";
		}
		if(borrUser!=null&&!"".equals(borrUser)){
			where = where + "AND o.borrUser='" + borrUser +"'";
		}
		StringBuffer sb = new StringBuffer();
		if(arr.length > 0 && !arr[0].equals("1")){
			sb.append(" AND o.id IN (");
			sb.append("'"+arr[0]+"'");
			for(int i=1;i<arr.length;i++){
				sb.append(",'"+arr[i]+"'");
			}
			sb.append(" )");
		}
		if(StringUtils.isNotEmpty(hideInputWord)){
			sb.append(" AND o.arcName like '%" + hideInputWord +"%'");
		}
		where = where + sb.toString();
		where = where + " ORDER BY o.ts DESC";
		List<BorrInfor> list = borrInforDao.getListBySql(BorrInfor.class, where, null, null);
		
		PageResult<BorrInfor> tmp = new PageResult<BorrInfor>();
		tmp.setResults(list);
		
		return convertToWebShow(tmp).getResults();
	}

	@Override
	public PageResult<BorrInforWebShow> findAllDocInforByCondition(
			String userId, int pageNum, int pageSize, String dengjiBumen_,
			String arcType, String jieyueBumenId_, String arcName,
			String borrUser, String planTimeBeginn, String planTimeEnd,
			String actlTimeBeginn, String actlTimeEnd, String isSet) throws Exception {
		String where =" 1=1 AND o.dr = 'N' ";
		where = where + "AND o.dataUserId='" + userId +"'";
		if(dengjiBumen_!=null&&!"".equals(dengjiBumen_)){
			Dept depts = deptDao.findById(dengjiBumen_);
			if(depts!=null){
				String deptCode = depts.getDeptCode();
				where = where + "AND o.dataDeptCode='" + deptCode +"'" ;
			}else{
				throw new Exception("dept code not unique or exist!");
			}
		}
		
		if(arcType!=null&&!"".equals(arcType)&&!"ALL".equalsIgnoreCase(arcType)){
			where = where + "AND o.arcType='" + arcType +"'";
		}
		
		if(isSet!=null&&!"".equals(isSet)&&!"ALL".equalsIgnoreCase(isSet)){
			if("2".equals(isSet)){
				where = where + "AND o.isSet='" + "N" +"'";
			}else{
				if("1".equals(isSet)){
					where = where + "AND o.isSet='" + "Y" +"'" + " AND o.isBack='N' ";
					//actltime not in sql
					if(planTimeBeginn!=null&&!"".equals(planTimeBeginn)){
						where = where + " AND o.planTime >='" + planTimeBeginn +"'";
					}
					if(planTimeEnd!=null&&!"".equals(planTimeEnd)){
						where = where + " AND o.planTime <'" + planTimeEnd +"'";
					}
				}else if("0".equals(isSet)){
					where = where + "AND o.isSet='" + "Y" +"'" + " AND o.isBack='Y' ";
					//actltime and plantime both in sql;
					if(planTimeBeginn!=null&&!"".equals(planTimeBeginn)){
						where = where + " AND o.planTime >='" + planTimeBeginn +"'";
					}
					if(planTimeEnd!=null&&!"".equals(planTimeEnd)){
						where = where + " AND o.planTime <'" + planTimeEnd +"'";
					}
					
					if(actlTimeBeginn!=null&&!"".equals(actlTimeBeginn)){
						where = where + " AND o.actlTime >='" + actlTimeBeginn +"'";
					}
					if(actlTimeEnd!=null&&!"".equals(actlTimeEnd)){
						where = where + " AND o.actlTime <'" + actlTimeEnd +"'";
					}
				}
			}
		}else{
			//sear all status
			if(planTimeBeginn!=null&&!"".equals(planTimeBeginn)){
				where = where + " AND o.isSet='Y' AND o.planTime >='" + planTimeBeginn +"'";
			}
			if(planTimeEnd!=null&&!"".equals(planTimeEnd)){
				where = where + " AND o.isSet='Y' AND o.planTime <'" + planTimeEnd +"'";
			}
			
			if(actlTimeBeginn!=null&&!"".equals(actlTimeBeginn)){
				where = where + " AND o.isBack='Y' AND o.actlTime >='" + actlTimeBeginn +"'";
			}
			if(actlTimeEnd!=null&&!"".equals(actlTimeEnd)){
				where = where + " AND o.isBack='Y' AND o.actlTime <'" + actlTimeEnd +"'";
			}
			
		}
		if(jieyueBumenId_!=null&&!"".equals(jieyueBumenId_)){
			where = where + "AND o.borrDept='" + jieyueBumenId_ +"'" ;
		}
		if(arcName!=null&&!"".equals(arcName)){
			where = where + "AND o.arcName like '%" + arcName +"%'";
		}
		if(borrUser!=null&&!"".equals(borrUser)){
			where = where + "AND o.borrUser='" + borrUser +"'";
		}
		
		where = where + " ORDER BY o.ts DESC";
		PageResult<BorrInfor> borrList = borrInforDao.getPageData(BorrInfor.class, pageNum,pageSize,where, null, null);
		return convertToWebShow(borrList);
	}

	@Override
	public Map<String,Object> doPrintByBorrId(String id){
		try{
			Map<String,Object> result = new HashMap<String, Object>();
			BorrInforWebShow show = findBorrInforWebShowById(id);
			if(show!=null){
				result.put("jieyuedanhao", show.getBorrInfor().getBorNBR());
				if(isBlank(show.getBorrInfor().getNbrTime())){
					result.put("danhaoriqi", "");
				}else{
					result.put("danhaoriqi", show.getBorrInfor().getNbrTime());
				}
				if(isBlank(show.getBorrUserName())){
					result.put("jieyueren", "");
				}else{
					result.put("jieyueren", show.getBorrUserName());
				}
//				if(){
//					
//				}
				if(isBlank(show.getBorrInfor().getBorrMobile())){
					result.put("jieyuerendianhua", "");
				}else{
					result.put("jieyuerendianhua", show.getBorrInfor().getBorrMobile());
				}
				if(isBlank(show.getBorrInfor().getBorrTime())){
					result.put("jieyueshijian", "");
				}else{
					result.put("jieyueshijian", show.getBorrInfor().getBorrTime());
				}
				if(isBlank(show.getJieyueBumen())){
					result.put("jieyuebumen", "");
				}else{
					result.put("jieyuebumen", show.getJieyueBumen());
				}
				if(isBlank(show.getArcName())){
					result.put("wenjianbiaoti", "");
				}else{
					result.put("wenjianbiaoti", show.getArcName());
					
				}
				IWebDocumentEntity iwebDoc = documentService.selectByPrimaryKey(show.getBorrInfor().getAttId());
				if(iwebDoc!=null){
					result.put("danganfujian", iwebDoc.getFileName());
				}else{
					result.put("danganfujian", "");
				}
				result.put("jieyueleixing", BorrType.getBorrTypeByValue(show.getBorrInfor().getBorrType()).getChname());
				result.put("jieyueshu", BorrSHR.getFileTypeByValue(show.getBorrInfor().getBorrSHR()).getChname());
				if("Y".equals(show.getBorrInfor().getIsSet())){
					result.put("shifouxuyaoguihuan", "是");
					result.put("jhguihuanshijian", show.getBorrInfor().getPlanTime());
					result.put("sjguihuanshijian", "");
					if("Y".equals(show.getBorrInfor().getIsBack())){
						result.put("sjguihuanshijian", show.getBorrInfor().getActlTime());
					}
				}else{
					result.put("shifouxuyaoguihuan", "否");
					result.put("jhguihuanshijian", "");
					result.put("sjguihuanshijian", "");
				}
				String comment = show.getBorrInfor().getLeaderOpinion();
				if(StringUtils.isEmpty(comment)){
					comment = "";
				}
				result.put("lingdaoyijian", comment);
				if(isBlank(show.getBorrInfor().getRemarks())){
					result.put("beizhu", "");
				}else{
					
					result.put("beizhu", show.getBorrInfor().getRemarks());
				}
				if(isBlank(show.getCreUserName())){
					result.put("banliren", "");
				}else{
					result.put("banliren", show.getCreUserName());
				}
				if(isBlank(show.getBorrInfor().getCreTime())){
					result.put("banlishijian", "");
				}else{
					result.put("banlishijian", show.getBorrInfor().getCreTime());
				}
			}
			return result;
		}catch(Exception e){
			return null;
		}
	}
	private Boolean isBlank(String para){
		if(para==null||"".equalsIgnoreCase(para)||"null".equalsIgnoreCase(para)){
			return true;
		}else{
			return false;
		}
	}
//	public String getValue(String value){
//		
//		return ;
//	}

	public String getParams(String queryPams) throws UnsupportedEncodingException{
		StringBuilder wheresql = new StringBuilder();
		queryPams = java.net.URLDecoder.decode(queryPams,"UTF-8");
		if(queryPams != null) {
			String[] paramsArr = queryPams.split("&");
			if(paramsArr != null && paramsArr.length > 0) {
				String[] keyValueArr;
				for (String keyValue : paramsArr) {
					keyValueArr = keyValue.split("=");
					if(keyValueArr.length == 2) {
						String key = keyValueArr[0];
						String value = keyValueArr[1];
						if(StringUtils.isNotBlank(key)&&StringUtils.isNotBlank(value)) {
							if("dengjiBumen_".equals(key)){
								wheresql.append(" AND  e.DEPT_ID = '" + value + "'");
							}else if("arcName".equals(key)){
								wheresql.append(" AND a.ARC_NAME like '%" + value.trim() + "%'");
							}else if("arcType".equals(key)){
								wheresql.append(" AND f.ID = '" + value + "'");
							}else if("jieyueUserId_".equals(key)){
								wheresql.append(" AND c.USER_ID = '" + value + "'");
							}else if("isSet".equals(key) && !value.equals("2")){
								wheresql.append(" AND a.IS_BACK = '" + value + "'");
							}else if("isSet".equals(key) && value.equals("2")){
								wheresql.append(" AND a.IS_RET = 'N'");
							}
							else if("jieyueBumenId_".equals(key)){
								wheresql.append(" AND a.BORR_DEPT = '" + value + "'");
							}
							else if("planTimeBeginn".equals(key)){
								wheresql.append(" AND a.PLAN_TIME >= '"+value+"'");
							}else if("planTimeEnd".equals(key)){
								wheresql.append(" AND a.PLAN_TIME <= '"+value+"'");
							}else if("actlTimeBeginn".equals(key)){
								wheresql.append(" AND a.ACTL_TIME >= '"+value+"'");
							}else if("actlTimeEnd".equals(key)){
								wheresql.append(" AND a.ACTL_TIME <= '"+value+"'");
							}
						}
					}
				}
			}
		}
		return wheresql.toString();
	}
}
