package com.yonyou.aco.arc.bid.service.impl;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.yonyou.aco.arc.bid.dao.IArcBidDao;
import com.yonyou.aco.arc.bid.entity.ArcBidBean;
import com.yonyou.aco.arc.bid.entity.ArcBidEntity;
import com.yonyou.aco.arc.bid.entity.ArcBidListBean;
import com.yonyou.aco.arc.bid.service.IArcBidService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * TODO: 填写Class概括. TODO: 填写Class详细说明 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月22日
 * @author hegd
 * @since 1.0.0
 */
@Service("arcBidService")
public class ArcBidServiceImpl implements IArcBidService {

	@Resource
	IArcBidDao arcBidDao;

	@Override
	public void doAddArcBidInfo(ArcBidEntity abEntity) {
		arcBidDao.save(abEntity);
	}
	@Override
	public PageResult<ArcBidBean> findAllArcBidData(int pageNum, int pageSize,
			String bidName, String bidCo, String startTime, String endTime,
			String year,String fileStart,ShiroUser user) {
		
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT b.ARC_ID arcId,p.ARC_NAME arcName,p.REG_USER regUser,"
				+ "p.DEP_POS depPos,b.PRO_NBR proNbr,p.KEY_WORD keyWord,"
				+ "b.UNIT_CNTCT_USER unitCntctUser,b.UNIT_CNTCT unitCntct,"
				+ "b.BID_NAME bidName,p.REG_TIME regTime,"
				+ "b.BID_TIME bidTime,b.BID_CO bidCo,trim(p.FILE_START) fileStart,"
				+ "trim(p.IS_INVALID) isInvalid  "
				+ "FROM biz_arc_bid_info b,biz_arc_pub_info p WHERE p.ARC_ID = b.ARC_ID AND p.DR='N' AND p.IS_INVALID!='2' "
				+ "AND p.EXPIRY_DATE_TIME > sysdate() ");
			sb.append(" AND b.DATA_USER_ID='"+user.getUserId()+"'");
		if(StringUtils.isNotEmpty(fileStart)){
			if(fileStart.equals("5")||fileStart=="5"){
			}else if(fileStart.equals("4")||fileStart=="4"){
				sb.append(" AND p.IS_INVALID ='1'");
			}else{
				sb.append(" AND p.FILE_START ='"+fileStart+"'");
				sb.append(" AND p.IS_INVALID ='0'");
			}
		}
		if (StringUtils.isNotEmpty(bidName)) {
			sb.append(" AND b.BID_NAME LIKE '%" + bidName + "%'");
		}
		if (StringUtils.isNotEmpty(bidCo)) {
			sb.append(" AND b.BID_CO LIKE '%" + bidCo + "%'");
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
		PageResult<ArcBidBean> page = null;
		try {
			page = arcBidDao.getPageData(ArcBidBean.class, pageNum, pageSize,
					sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}

		return page;
	}

	@Override
	public PageResult<ArcBidListBean> findAllArcBidData(int pageNum, int pageSize,
			String bidName, String bidCo, String startTime, String endTime,
			String year,String fileStart,ShiroUser user ,String sortName, String sortOrder) {
		
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT b.ARC_ID arc_id,p.ARC_NAME arc_name,"
				+ "p.DEP_POS dep_pos,"
				+ "b.BID_NAME bid_name,p.REG_TIME reg_time,"
				+ "b.BID_TIME bid_time,b.BID_CO bid_co,trim(p.FILE_START) file_start,"
				+ "trim(p.IS_INVALID) is_invalid  "
				+ "FROM biz_arc_bid_info b,biz_arc_pub_info p WHERE p.ARC_ID = b.ARC_ID AND p.DR='N' AND p.IS_INVALID!='2' "
				+ "AND p.EXPIRY_DATE_TIME > sysdate() ");
			sb.append(" AND b.DATA_USER_ID='"+user.getUserId()+"'");
		if(StringUtils.isNotEmpty(fileStart)){
			if(fileStart.equals("5")||fileStart=="5"){
			}else if(fileStart.equals("4")||fileStart=="4"){
				sb.append(" AND p.IS_INVALID ='1'");
			}else{
				sb.append(" AND p.FILE_START ='"+fileStart+"'");
				sb.append(" AND p.IS_INVALID ='0'");
			}
		}
		if (StringUtils.isNotEmpty(bidName)) {
			sb.append(" AND b.BID_NAME LIKE '%" + bidName + "%'");
		}
		if (StringUtils.isNotEmpty(bidCo)) {
			sb.append(" AND b.BID_CO LIKE '%" + bidCo + "%'");
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
		PageResult<ArcBidListBean> page = null;
		try {
			page = arcBidDao.getPageData(ArcBidListBean.class, pageNum, pageSize,
					sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}

		return page;
	}

	@Override
	public ArcBidBean findArcBidByArcId(String arcId,String fileStart) {
		ArcBidBean bean = arcBidDao.findArcBidByArcId(arcId,fileStart);
		return bean;
	}

	@Override
	public void doUpdateArcBidInfo(ArcBidEntity adEntity) {
		arcBidDao.update(adEntity);
	}

}
