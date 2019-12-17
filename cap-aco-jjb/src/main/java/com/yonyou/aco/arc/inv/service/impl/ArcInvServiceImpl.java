package com.yonyou.aco.arc.inv.service.impl;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.inv.dao.IArcInvDao;
import com.yonyou.aco.arc.inv.entity.ArcInvBean;
import com.yonyou.aco.arc.inv.entity.ArcInvEntity;
import com.yonyou.aco.arc.inv.entity.ArcInvPageBean;
import com.yonyou.aco.arc.inv.service.IArcInvService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * TODO: 项目投资档案service实现类 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月29日
 * @author hegd
 * @since 1.0.0
 */
@Repository("arcInvService")
public class ArcInvServiceImpl implements IArcInvService {

	@Resource
	IArcInvDao arcInvDao;

	@Override
	public void doAddArcInvInfo(ArcInvEntity adEntity) {
		arcInvDao.save(adEntity);

	}

	@Override
	public ArcInvBean findArcInvByArcId(String arcId,String fileStart) {
		return arcInvDao.findArcInvByArcId(arcId,fileStart);
	}

	@Override
	public PageResult<ArcInvBean> findAllArcInvData(int pageNum, int pageSize,
			String arcName, String proName, String startTime, String endTime,
			String year, String invType, String fileStart,ShiroUser user) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT a.ARC_ID arcId,p.ARC_NAME arcName,a.PRO_NAME proName,"
				+ "a.MNY mny,a.INV_PRO invPro,trim(a.INV_TYPE) invType,a.INV_TIME invTime,"
				+ "a.BANK_SRC bankSrc,a.INV_INCM invIncm,a.INV_DEAL invDeal,"
				+ "a.PRO_SOURCE proSource,a.PRO_MNY proMny,p.REG_TIME regTime,"
				+ "trim(p.FILE_START) fileStart,trim(p.IS_INVALID) isInvalid,"
				+ "p.DEP_POS depPos,p.KEY_WORD keyWord FROM biz_arc_inv_info a,biz_arc_pub_info p"
				+ " WHERE p.ARC_ID = a.ARC_ID AND p.DR='N' AND p.IS_INVALID!='2' "
				+ "AND p.EXPIRY_DATE_TIME > sysdate() ");
		sb.append(" AND a.DATA_USER_ID='" + user.getUserId() + "'");
		
		if(StringUtils.isNotEmpty(invType)){
			if(invType.equals("2")||invType=="2"){
			}else{
				sb.append(" AND a.INV_TYPE ='"+invType+"'");
			}
		}
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
		if (StringUtils.isNotEmpty(proName)) {
			sb.append(" AND a.PRO_NAME LIKE '%" + proName + "%'");
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
		PageResult<ArcInvBean> page = null;
		try {
			page = arcInvDao.getPageData(ArcInvBean.class, pageNum, pageSize,
					sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return page;
	}

	@Override
	public void doUpdateSaveArcInvInfo(ArcInvEntity adEntity) {
		arcInvDao.update(adEntity);

	}

	@Override
	public PageResult<ArcInvPageBean> findAllArcInvData(int pageNum,
			int pageSize, String arcName, String proName, String startTime,
			String endTime, String year, String invType, String fileStart,
			ShiroUser user, String sortName, String sortOrder) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT a.ARC_ID arc_id,p.ARC_NAME arc_name,a.PRO_NAME pro_name,"
				+ "a.MNY mny,a.INV_PRO inv_pro,trim(a.INV_TYPE) inv_type,a.INV_TIME inv_time,"
				+ "a.BANK_SRC bank_src,"
				+ "p.REG_TIME reg_time,"
				+ "trim(p.FILE_START) file_start,trim(p.IS_INVALID) is_invalid,"
				+ "p.DEP_POS dep_pos FROM biz_arc_inv_info a,biz_arc_pub_info p"
				+ " WHERE p.ARC_ID = a.ARC_ID AND p.DR='N' AND p.IS_INVALID!='2' "
				+ "AND p.EXPIRY_DATE_TIME > sysdate() ");
		sb.append(" AND a.DATA_USER_ID='" + user.getUserId() + "'");
		
		if(StringUtils.isNotEmpty(invType)){
			if(invType.equals("2")||invType=="2"){
			}else{
				sb.append(" AND a.INV_TYPE ='"+invType+"'");
			}
		}
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
		if (StringUtils.isNotEmpty(proName)) {
			sb.append(" AND a.PRO_NAME LIKE '%" + proName + "%'");
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
		PageResult<ArcInvPageBean> page = null;
		try {
			page = arcInvDao.getPageData(ArcInvPageBean.class, pageNum, pageSize,
					sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return page;
	}

}
