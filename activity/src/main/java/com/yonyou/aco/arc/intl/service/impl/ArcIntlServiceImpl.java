package com.yonyou.aco.arc.intl.service.impl;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.arc.intl.dao.IArcIntlDao;
import com.yonyou.aco.arc.intl.entity.ArcIntlBean;
import com.yonyou.aco.arc.intl.entity.ArcIntlEntity;
import com.yonyou.aco.arc.intl.entity.ArcIntlPageBean;
import com.yonyou.aco.arc.intl.service.IArcIntlService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * TODO: 内部项目档案service接口实现类 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月29日
 * @author hegd
 * @since 1.0.0
 */
@Repository("arcIntlService")
public class ArcIntlServiceImpl implements IArcIntlService {

	@Resource
	IArcIntlDao arcIntlDao;

	@Override
	public void doAddArcIntlInfo(ArcIntlEntity adEntity) {
		arcIntlDao.save(adEntity);
	}

	@Override
	public PageResult<ArcIntlBean> findAllArcIntlData(int pageNum,
			int pageSize, String arcName, String proName, String startTime,
			String endTime,String year,String fileStart,ShiroUser user) {
		
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT p.ARC_ID arcId,a.DOC_NBR docNbr,a.PRO_NAME proName,"
				+ "p.ARC_NAME arcName,p.REG_TIME regTime,trim(p.FILE_START) fileStart,"
				+ "p.REG_USER regUser,p.DEP_POS depPos,a.AGR_NBR agrNbr,trim(p.IS_INVALID) isInvalid,p.KEY_WORD keyWord FROM biz_arc_intl_info a,"
				+ "biz_arc_pub_info p WHERE a.ARC_ID = p.ARC_ID  AND p.DR='N' AND p.IS_INVALID!='2' "
				+ "AND p.EXPIRY_DATE_TIME > sysdate() ");
		sb.append(" AND a.DATA_USER_ID='"+user.getUserId()+"'");
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
		PageResult<ArcIntlBean> page = null;
		try {
			page = arcIntlDao.getPageData(ArcIntlBean.class, pageNum, pageSize,
					sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}

		return page;
	}

	@Override
	public ArcIntlBean findArcIntlByArcId(String arcId,String fileStart) {
		return arcIntlDao.findArcIntlByArcId(arcId,fileStart);
	}

	@Override
	public void doUpdateArcIntlInfo(ArcIntlEntity adEntity) {
			arcIntlDao.update(adEntity);
	}

	@Override
	public PageResult<ArcIntlPageBean> findAllArcIntlData(int pageNum,
			int pageSize, String arcName, String proName, String startTime,
			String endTime, String year, String fileStart, ShiroUser user,
			String sortName, String sortOrder) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT p.ARC_ID arc_id,a.DOC_NBR doc_nbr,a.PRO_NAME pro_name,"
				+ "p.ARC_NAME arc_name,p.REG_TIME reg_time,trim(p.FILE_START) file_start,"
				+ "p.REG_USER reg_user,p.DEP_POS dep_pos,trim(p.IS_INVALID) is_invalid FROM biz_arc_intl_info a,"
				+ "biz_arc_pub_info p WHERE a.ARC_ID = p.ARC_ID  AND p.DR='N' AND p.IS_INVALID!='2' "
				+ "AND p.EXPIRY_DATE_TIME > sysdate() ");
		sb.append(" AND a.DATA_USER_ID='"+user.getUserId()+"'");
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
		PageResult<ArcIntlPageBean> page = null;
		try {
			page = arcIntlDao.getPageData(ArcIntlPageBean.class, pageNum, pageSize,
					sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}

		return page;
	}

}
