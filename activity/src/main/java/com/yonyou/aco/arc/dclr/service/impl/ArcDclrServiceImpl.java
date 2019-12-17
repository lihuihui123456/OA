package com.yonyou.aco.arc.dclr.service.impl;


import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.dclr.dao.IArcDclrDao;
import com.yonyou.aco.arc.dclr.entity.ArcDclrBean;
import com.yonyou.aco.arc.dclr.entity.ArcDclrEntity;
import com.yonyou.aco.arc.dclr.entity.ArcDclrPageBean;
import com.yonyou.aco.arc.dclr.service.IArcDclrService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

@Repository("arcDclrService")
public class ArcDclrServiceImpl implements IArcDclrService {

	@Resource
	IArcDclrDao arcDclrDao;

	@Override
	public ArcDclrBean findArcDclrByArcId(String arcId,String fileStart) {
		return arcDclrDao.findArcDclrByArcId(arcId,fileStart);
	}

	@Override
	public PageResult<ArcDclrBean> findAllArcDclrData(int pageNum,
			int pageSize, String arcName, String proName, String startTime,
			String endTime,String year,String proCom,String fileStart,ShiroUser user) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT d.ARC_ID arcId,p.ARC_NAME arcName,d.DEC_TIME decTime,d.PRO_NAME proName,"
				+ "p.REG_USER regUser,d.BEAR_DEPT bearDept,d.DEC_USER decUser,"
				+ "d.DEC_MNY decMny,d.PRO_COM proCom,p.REG_TIME regTime,trim(p.IS_INVALID) isInvalid,"
				+ "trim(p.FILE_START) fileStart,p.DEP_POS depPos,p.KEY_WORD keyWord FROM biz_arc_dclr_ifno d,"
				+ "biz_arc_pub_info p WHERE p.ARC_ID = d.ARC_ID AND p.DR='N' AND p.IS_INVALID!='2' "
				+ "AND p.EXPIRY_DATE_TIME > sysdate() ");
		sb.append(" AND d.DATA_USER_ID='"+user.getUserId()+"'");
		if(StringUtils.isNotEmpty(fileStart)){
			if(fileStart.equals("5")||fileStart=="5"){
			}else if(fileStart.equals("4")||fileStart=="4"){
				sb.append(" AND p.IS_INVALID ='1'");
			}else{
				sb.append(" AND p.FILE_START ='"+fileStart+"'");
				sb.append(" AND p.IS_INVALID ='0'");
			}
		}
//		if(StringUtils.isNotEmpty(fileStart)){
//			if(fileStart.equals("4")||fileStart=="4"){
//			}else{
//				sb.append(" AND p.IS_INVALID ='1'");
//			}
//		}
		if (StringUtils.isNotEmpty(arcName)) {
			sb.append(" AND p.ARC_NAME LIKE '%" + arcName + "%'");
		}
		if (StringUtils.isNotEmpty(proCom)) {
			sb.append(" AND d.PRO_COM LIKE '%" + proCom + "%'");
		}
		if (StringUtils.isNotEmpty(proName)) {
			sb.append(" AND d.PRO_NAME LIKE '%" + proName + "%'");
		}
		if(StringUtils.isNotEmpty(startTime) && StringUtils.isNotEmpty(endTime)){
			if (startTime.equals(endTime)) {
				sb.append(" AND DATE_FORMAT(p.REG_TIME,'%Y-%m-%d') = '" + startTime + "'");
			}else{
				if (StringUtils.isNotEmpty(startTime)) {
					sb.append(" AND DATE_FORMAT(p.REG_TIME,'%Y-%m-%d') >= '" + startTime + "'");
				}
				if (StringUtils.isNotEmpty(endTime)) {
					sb.append(" AND DATE_FORMAT(p.REG_TIME,'%Y-%m-%d') <= '" + endTime + "'");
				}
			}
		}else{
			if (StringUtils.isNotEmpty(startTime)) {
				sb.append(" AND DATE_FORMAT(p.REG_TIME,'%Y-%m-%d') >= '" + startTime + "'");
			}
			if (StringUtils.isNotEmpty(endTime)) {
				sb.append(" AND DATE_FORMAT(p.REG_TIME,'%Y-%m-%d') <= '" + endTime + "'");
			}
		}
		if (StringUtils.isNotEmpty(year)) {
			sb.append(" AND p.REG_TIME LIKE '%" + year + "%'");
		}
		sb.append(" ORDER BY p.REG_TIME DESC");
		PageResult<ArcDclrBean> page = null;
		try {
			page = arcDclrDao.getPageData(ArcDclrBean.class, pageNum, pageSize,
					sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}

		return page;
		
	}

	@Override
	public void doAddArcDclrInfo(ArcDclrEntity adEntity) {
		arcDclrDao.save(adEntity);
	}

	@Override
	public void doUpdateArcIntlInfo(ArcDclrEntity adEntity) {
		arcDclrDao.update(adEntity);
		
	}

	@Override
	public PageResult<ArcDclrPageBean> findAllArcDclrData(int pageNum,
			int pageSize, String arcName, String proName, String startTime,
			String endTime, String year, String proCom, String fileStart,
			ShiroUser user, String sortName, String sortOrder) {
	StringBuffer sb = new StringBuffer();
	sb.append("SELECT d.ARC_ID arc_id,p.ARC_NAME arc_name,d.DEC_TIME dec_time,d.PRO_NAME pro_name,"
			+ "p.REG_USER reg_user,"
			+ "p.REG_TIME reg_time,trim(p.IS_INVALID) is_invalid,"
			+ "trim(p.FILE_START) file_start,p.DEP_POS dep_pos FROM biz_arc_dclr_ifno d,"
			+ "biz_arc_pub_info p WHERE p.ARC_ID = d.ARC_ID AND p.DR='N' AND p.IS_INVALID!='2' "
			+ "AND p.EXPIRY_DATE_TIME > sysdate() ");
	sb.append(" AND d.DATA_USER_ID='"+user.getUserId()+"'");
	if(StringUtils.isNotEmpty(fileStart)){
		if(fileStart.equals("5")||fileStart=="5"){
		}else if(fileStart.equals("4")||fileStart=="4"){
			sb.append(" AND p.IS_INVALID ='1'");
		}else{
			sb.append(" AND p.FILE_START ='"+fileStart+"'");
			sb.append(" AND p.IS_INVALID ='0'");
		}
	}
//	if(StringUtils.isNotEmpty(fileStart)){
//		if(fileStart.equals("4")||fileStart=="4"){
//		}else{
//			sb.append(" AND p.IS_INVALID ='1'");
//		}
//	}
	if (StringUtils.isNotEmpty(arcName)) {
		sb.append(" AND p.ARC_NAME LIKE '%" + arcName + "%'");
	}
	if (StringUtils.isNotEmpty(proCom)) {
		sb.append(" AND d.PRO_COM LIKE '%" + proCom + "%'");
	}
	if (StringUtils.isNotEmpty(proName)) {
		sb.append(" AND d.PRO_NAME LIKE '%" + proName + "%'");
	}
	if(StringUtils.isNotEmpty(startTime) && StringUtils.isNotEmpty(endTime)){
		if (startTime.equals(endTime)) {
			sb.append(" AND DATE_FORMAT(p.REG_TIME,'%Y-%m-%d') = '" + startTime + "'");
		}else{
			if (StringUtils.isNotEmpty(startTime)) {
				sb.append(" AND DATE_FORMAT(p.REG_TIME,'%Y-%m-%d') >= '" + startTime + "'");
			}
			if (StringUtils.isNotEmpty(endTime)) {
				sb.append(" AND DATE_FORMAT(p.REG_TIME,'%Y-%m-%d') <= '" + endTime + "'");
			}
		}
	}else{
		if (StringUtils.isNotEmpty(startTime)) {
			sb.append(" AND DATE_FORMAT(p.REG_TIME,'%Y-%m-%d') >= '" + startTime + "'");
		}
		if (StringUtils.isNotEmpty(endTime)) {
			sb.append(" AND DATE_FORMAT(p.REG_TIME,'%Y-%m-%d') <= '" + endTime + "'");
		}
	}
	if (StringUtils.isNotEmpty(year)) {
		sb.append(" AND p.REG_TIME LIKE '%" + year + "%'");
	}
	if(StringUtils.isNotBlank(sortName)&&StringUtils.isNotBlank(sortOrder)){
		sb.append(" order by CONVERT(");
		sb.append(sortName+" USING gbk) "+sortOrder);
	}
	else{
		sb.append(" ORDER BY p.REG_TIME DESC");
	}
	PageResult<ArcDclrPageBean> page = null;
	try {
		page = arcDclrDao.getPageData(ArcDclrPageBean.class, pageNum, pageSize,
				sb.toString());
	} catch (Exception e) {
		e.printStackTrace();
	}

	return page;
	}

}
