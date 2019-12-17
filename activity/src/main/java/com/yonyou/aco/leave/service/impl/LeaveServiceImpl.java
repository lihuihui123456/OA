package com.yonyou.aco.leave.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.yonyou.aco.leave.dao.ILeaveDao;
import com.yonyou.aco.leave.entity.LeaveBean;
import com.yonyou.aco.leave.entity.LeaveEntity;
import com.yonyou.aco.leave.service.ILeaveService;
import com.yonyou.cap.common.util.PageResult;

/**
 * 
 * TODO:请假管理service实现类
 * 
 * @Date 2017年6月6日
 * @author 贺国栋
 * @since 1.0.0
 */
@Service("leaveService")
public class LeaveServiceImpl implements ILeaveService {

	@Resource
	ILeaveDao leaveDao;

	@Override
	public PageResult<LeaveBean> findLeaveDateByQueryParams(int pageNum, int pageSize, String solId, String userName,
			String sortName, String sortOrder, String userId, String queryParams) {

		StringBuilder sb = new StringBuilder();
		sb.append("SELECT l.ID,l.LEAVE_ID,b.SOL_ID_,b.BIZ_TITLE_ ,u.USER_NAME USER_NAME,"
				+ "u.DEPT_NAME, p.POST_NAME,trim(l.STATE) STATE,trim(l.LEAVE_TYPE) LEAVE_TYPE,"
				+ "trim(l.START_TIME) START_TIME,trim(l.END_TIME) END_TIME,l.LEAVE_DAYS,"
				+ "trim(l.IS_BJ) IS_BJ,trim(l.IS_EXIT) IS_EXIT,b.CREATE_TIME_ SEND_TIME "
				+ "FROM biz_leave_info l "
				+ "LEFT JOIN bpm_ru_biz_info b ON b.ID_ = l.LEAVE_ID "
				+ "LEFT JOIN isc_user u ON u.USER_ID = b.CREATE_USER_ID_ "
				+ "LEFT JOIN isc_post_ref_user pr ON pr.USER_ID = b.CREATE_USER_ID_ "
				+ "LEFT JOIN isc_post p ON p.POST_ID = pr.POST_ID");
		sb.append(" WHERE  b.DR_='N' ");
		// 简单查询
		if (StringUtils.isNotBlank(userName)) {
			sb.append(" AND USER_NAME LIKE '%" + userName + "%'");
		}
		// 列表高级查询
		if (StringUtils.isNotBlank(queryParams)) {
			String[] paramsArr = queryParams.split("&");
			if (paramsArr != null && paramsArr.length > 0) {
				String[] keyValueArr;
				for (String keyValue : paramsArr) {
					keyValueArr = keyValue.split("=");
					if (keyValueArr.length == 2) {
						String key = keyValueArr[0];
						String value = keyValueArr[1];
						if (StringUtils.isNotBlank(key) && StringUtils.isNotBlank(value)) {
							if ("USER_NAME".equals(key)) {
								sb.append(" AND USER_NAME LIKE '%" + value.trim() + "%'");
							} else if ("DEPT_NAME".equals(key)) {
								sb.append(" AND DEPT_NAME LIKE '%" + value.trim() + "%'");
							} else if ("POST_NAME".equals(key)) {
								sb.append(" AND POST_NAME LIKE '%" + value.trim() + "%'");
							} else if ("STATE".equals(key)) {
								sb.append(" AND l.STATE = '" + value + "'");
							} else if ("LEAVE_TYPE".equals(key)) {
								sb.append(" AND l.LEAVE_TYPE LIKE '%" + value.trim() + "%'");
							} else if ("LEAVE_DAYS".equals(key)) {
								sb.append(" AND l.LEAVE_DAYS LIKE '%" + value + "%'");
							} else if ("START_TIME".equals(key)) {
								sb.append(" AND l.START_TIME >= '" + value + "'");
							} else if ("END_TIME".equals(key)) {
								sb.append(" AND l.END_TIME <=' " + value + "'");
							} else if ("IS_BJ".equals(key)) {
								sb.append(" AND l.IS_BJ = '" + value + "'");
							} else if ("SEND_TIME_START".equals(key)) {
								sb.append(" AND b.CREATE_TIME_ >='" + value + "'");
							} else if ("SEND_TIME_END".equals(key)) {
								sb.append(" AND b.CREATE_TIME_  <='" + value + "'");
							} else if ("IS_EXIT".equals(key)) {
								sb.append(" AND IS_EXIT  ='" + value + "'");
							}
						}
					}
				}
			}
		}
		// 列表排序功能
		if (StringUtils.isNotBlank(sortName) && StringUtils.isNotBlank(sortOrder)) {
			sb.append(" ORDER BY CONVERT(" + sortName + " USING gbk) " + sortOrder);
		} else {
			sb.append(" ORDER BY b.CREATE_TIME_ DESC");
		}
		try {

			return leaveDao.getPageData(LeaveBean.class, pageNum, pageSize, sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}

	@Override
	public void doSaveLeaveInfo(String leaveId, String leaveState, String leaveType, String startTime, String endTime,
			String leaveDayNum, String is_bj, String is_exit) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		LeaveEntity lentity = new LeaveEntity();
		lentity.setID(null);
		lentity.setLEAVE_ID(leaveId);
		lentity.setIS_BJ(is_bj);
		lentity.setIS_EXIT(is_exit);
		lentity.setLEAVE_DAYS(leaveDayNum);
		lentity.setLEAVE_TYPE(leaveType);
		lentity.setSTATE(leaveState);
		if(StringUtils.isNotBlank(startTime)){
			Date startDate = null;
			try {
				startDate = sdf.parse(startTime);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			lentity.setSTART_TIME(startDate);
		}
		if(StringUtils.isNotBlank(endTime)){
			Date endDate = null;
			try {
				endDate = sdf.parse(endTime);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			lentity.setEND_TIME(endDate);
		}
		leaveDao.update(lentity);
	}

}
