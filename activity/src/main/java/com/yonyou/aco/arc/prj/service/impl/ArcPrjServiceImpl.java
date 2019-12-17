package com.yonyou.aco.arc.prj.service.impl;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.prj.dao.IArcPrjDao;
import com.yonyou.aco.arc.prj.entity.ArcPrjBean;
import com.yonyou.aco.arc.prj.entity.ArcPrjEntity;
import com.yonyou.aco.arc.prj.entity.ArcPrjPageBean;
import com.yonyou.aco.arc.prj.service.IArcPrjService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

@Repository("arcPrjService")
public class ArcPrjServiceImpl implements IArcPrjService {
	@Resource
	IArcPrjDao arcPrjDao;

	@Override
	public ArcPrjBean findArcPrjByArcId(String arcId,String fileStart) {
		return arcPrjDao.findArcPrjByArcId(arcId,fileStart);
	}

	@Override
	public void doAddarcprjInfo(ArcPrjEntity abEntity) {
		arcPrjDao.save(abEntity);
	}

	@Override
	public PageResult<ArcPrjBean> findAllArcPrjData(int pageNum, int pageSize,
			String arcName, String prjName, String startTime, String endTime,
			String year, String fileStart,ShiroUser user) {
		
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT p.ARC_ID arcId,p.ARC_NAME arcName,a.PRJ_NAME prjName,a.PRJ_ADD prjAdd,"
				+ "a.PRJ_USER prjUser,p.REG_TIME regTime,trim(p.FILE_START) fileStart,trim(p.IS_INVALID) isInvalid,p.REG_USER regUser,"
				+ "p.DEP_POS depPos,a.PRJ_NBR prjNbr,p.KEY_WORD keyWord FROM biz_arc_prj_cstr a,biz_arc_pub_info p  "
				+ "WHERE a.ARC_ID = p.ARC_ID AND p.DR='N' AND p.IS_INVALID!='2' "
				+ "AND p.EXPIRY_DATE_TIME > sysdate() ");
		sb.append(" AND a.DATA_USER_ID='" + user.getUserId() + "'");
		if(StringUtils.isNotEmpty(fileStart)){
			if(fileStart.equals("5")||fileStart=="5"){
			}else if(fileStart.equals("4")||fileStart=="4"){
				sb.append(" AND p.IS_INVALID ='1'");
			}else{
				sb.append(" AND p.FILE_START ='"+fileStart+"'");
				sb.append(" AND p.IS_INVALID ='0'");
			}
		}
		if (StringUtils.isNotEmpty(arcName)) {
			sb.append(" AND p.ARC_NAME LIKE '%" + arcName + "%'");
		}
		if (StringUtils.isNotEmpty(prjName)) {
			sb.append(" AND a.PRJ_NAME LIKE '%" + prjName + "%'");
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
			sb.append(" AND p.REG_TIME like '%" + year + "%'");
		}

		sb.append(" ORDER BY p.REG_TIME DESC");
		PageResult<ArcPrjBean> page = null;
		try {
			page = arcPrjDao.getPageData(ArcPrjBean.class, pageNum, pageSize,
					sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}

		return page;
	}

	@Override
	public void doUpdateArcPrjInfo(ArcPrjEntity adEntity) {
		arcPrjDao.update(adEntity);

	}

	@Override
	public PageResult<ArcPrjPageBean> findAllArcPrjData(int pageNum,
			int pageSize, String arcName, String prjName, String startTime,
			String endTime, String year, String fileStart, ShiroUser user,
			String sortName, String sortOrder) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT p.ARC_ID arc_id,p.ARC_NAME arc_name,a.PRJ_NAME prj_name,a.PRJ_ADD prj_add,"
				+ "a.PRJ_USER prj_user,p.REG_TIME reg_time,trim(p.FILE_START) file_start,trim(p.IS_INVALID) is_invalid,"
				+ "p.DEP_POS dep_pos FROM biz_arc_prj_cstr a,biz_arc_pub_info p  "
				+ "WHERE a.ARC_ID = p.ARC_ID AND p.DR='N' AND p.IS_INVALID!='2' "
				+ "AND p.EXPIRY_DATE_TIME > sysdate() ");
		sb.append(" AND a.DATA_USER_ID='" + user.getUserId() + "'");
		if(StringUtils.isNotEmpty(fileStart)){
			if(fileStart.equals("5")||fileStart=="5"){
			}else if(fileStart.equals("4")||fileStart=="4"){
				sb.append(" AND p.IS_INVALID ='1'");
			}else{
				sb.append(" AND p.FILE_START ='"+fileStart+"'");
				sb.append(" AND p.IS_INVALID ='0'");
			}
		}
		if (StringUtils.isNotEmpty(arcName)) {
			sb.append(" AND p.ARC_NAME LIKE '%" + arcName + "%'");
		}
		if (StringUtils.isNotEmpty(prjName)) {
			sb.append(" AND a.PRJ_NAME LIKE '%" + prjName + "%'");
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
			sb.append(" AND p.REG_TIME like '%" + year + "%'");
		}
		if(StringUtils.isNotBlank(sortName)&&StringUtils.isNotBlank(sortOrder)){
			sb.append(" order by CONVERT(");
			sb.append(sortName+" USING gbk) "+sortOrder);
		}
		else{
			sb.append(" ORDER BY p.REG_TIME DESC");
		}
		PageResult<ArcPrjPageBean> page = null;
		try {
			page = arcPrjDao.getPageData(ArcPrjPageBean.class, pageNum, pageSize,
					sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}

		return page;
	}

}
