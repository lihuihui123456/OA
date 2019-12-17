package com.yonyou.aco.mtgmgr.service.Impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.yonyou.aco.mtgmgr.dao.IRoomUsedDao;
import com.yonyou.aco.mtgmgr.entity.BizMtRoomUsingEntity;
import com.yonyou.aco.mtgmgr.entity.DateFindBean;
import com.yonyou.aco.mtgmgr.entity.RoomApplySearchBean;
import com.yonyou.aco.mtgmgr.entity.RoomBean;
import com.yonyou.aco.mtgmgr.entity.RoomUsingSearchBean;
import com.yonyou.aco.mtgmgr.service.IRoomUsedService;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;

@Service("roomUsedService")
public class RoomUsedServiceImpl implements IRoomUsedService {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource
	private IRoomUsedDao roomUsedDao;

	@Override
	public void doSaveMtRoomUsing(BizMtRoomUsingEntity roomUsed) {
		roomUsedDao.save(roomUsed);
	}
	
	@Override
	public PageResult<RoomBean> findAllApply(int pageNum, int pageSize, String meetingname) {
		return roomUsedDao.findAllApply(pageNum, pageSize, meetingname);
	}
	
	@Override
	public void doUpdateStatus(String ids, String status){
		roomUsedDao.doUpdateStatus(ids, status);
	}
	
	/**
	 * 根据roomid 查询一周的会议室使用信息
	 */
	@SuppressWarnings({ "rawtypes", "unchecked", "unused" })
	@Override
	public List[] getOneWeekMeetingInfo(String roomId, String start_time,
			String end_time) {
		List[] fss = new List[14];
		try {
			List<RoomBean> list = roomUsedDao.getOneWeekMeetingInfo(roomId,
					start_time, end_time);
			// 拆成半天
			int poa = 0;
			String date;
			for (int i = 0; i < list.size(); i++) {
				RoomBean rs = list.get(i);
				if (rs.getStart_time() != null) {
					date = rs.getEnd_time();
					// 第几天*2+上午或下午-1得到在数组中是第几个上下午
					int pos = getDay_week(rs.getVirtual_time()) * 2
							+ getmorningornoon(rs.getVirtual_time()) - 1; // 第一个数组下标
					poa = getdate(rs.getEnd_time(), rs.getVirtual_time()) + 1; // 根据两个时间返回它们相差多少个半天
					if (poa > 14)
						poa = 14;
					for (int j = 0; j < poa; j++) {
						if (fss[pos + j] == null) {
							fss[pos + j] = new ArrayList();
						}
						fss[pos + j].add(rs); // add
						if ((pos + j) > 12)
							break;
					}
				}
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return fss;
	}

	/**
	 * 根据一个日期返回一个星期的第几天
	 * 
	 * @param Date
	 *            日期
	 * @return
	 */
	public int getDay_week(String str) {
		int week = 0;
		String format = "yyyy-MM-dd HH:mm";
		Date date = DateUtil.parseDate(str, format);
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		week = calendar.get(Calendar.DAY_OF_WEEK);// 返回date为当前星期的第几天
		return week;
	}

	/**
	 * 根据一个时间返回所在时间是上午还是下午,-1:上午 0:下午
	 * 
	 * @param Date
	 *            日期
	 * @return -1:上午 0:下午
	 * @throws ParseException
	 */
	public int getmorningornoon(String str) throws ParseException {
		String format = "yyyy-MM-dd HH:mm";
		Date date = DateUtil.parseDate(str, format);
		Date morning = this.getNoonDateTime(date, 1);// 上午
		Date noon = this.getNoonDateTime(date, 2);// 下午
		if (date.getTime() >= morning.getTime()
				&& date.getTime() < noon.getTime()) {
			return -1;
		}
		return 0;

	}

	/**
	 * 根据两个时间返回它们相差多少个半天
	 * 
	 * @param Date
	 *            max大日期，Date min小日期
	 * @return 相差多少个半天
	 * @throws ParseException
	 */
	public int getdate(String str1, String str2) throws ParseException {
		String format = "yyyy-MM-dd HH:mm";
		Date max = DateUtil.parseDate(str1, format);
		Date min = DateUtil.parseDate(str2, format);
		double ST = max.getTime() / 3600000;
		double SD = min.getTime() / 3600000;
		double CH = ST - SD;
		int i = (int) (CH / 12);
		Date noonmin = this.getNoonDateTime(min, 2);
		Date noonmax = this.getNoonDateTime(max, 2);
		if (i == 0 && max.getTime() > noonmin.getTime()
				&& min.getTime() < noonmin.getTime()) {
			i = i + 1;
		} else if (i >= 1 && max.getTime() <= noonmax.getTime()
				&& min.getTime() >= noonmin.getTime() && i % 2 == 0) {
			i = i - 1;
		} else if (i >= 1 && max.getTime() >= noonmax.getTime()
				&& min.getTime() <= noonmin.getTime() && i % 2 == 0) {
			i = i + 1;
		} else if (i >= 1 && max.getTime() <= noonmax.getTime()
				&& min.getTime() <= noonmin.getTime() && i % 2 == 1) {
			i = i - 1;
		}
		return i;
	}

	/**
	 * 返回当天上午/下午的时间
	 * 
	 * @param date
	 *            指定日期时间
	 * @param type
	 *            1、上午 2、下午 3、晚上
	 * @return
	 * @throws ParseException
	 */
	public Date getNoonDateTime(Date today, int type) throws ParseException {
		Date date = null;
		if (today != null) {
			SimpleDateFormat sdf = new SimpleDateFormat();
			if (type == 1) {
				sdf.applyPattern("yyyy-MM-dd");
				String str_today = sdf.format(today);

				str_today += " 00:00:00";
				sdf.applyPattern("yyyy-MM-dd HH:mm:ss");
				date = sdf.parse(str_today);
			} else if (type == 2) {
				sdf.applyPattern("yyyy-MM-dd");
				String str_today = sdf.format(today);
				str_today += " 12:00:10";
				sdf.applyPattern("yyyy-MM-dd HH:mm:ss");
				date = sdf.parse(str_today);
			} else {
				sdf.applyPattern("yyyy-MM-dd");
				String str_today = sdf.format(today);
				str_today += " 23:59:59";
				sdf.applyPattern("yyyy-MM-dd HH:mm:ss");
				date = sdf.parse(str_today);
			}
		}
		return date;
	}

	/**
	 * 根据星期为第一天算出一周的所有日期时间
	 * 
	 * @param dateTime
	 *            星期天
	 * @return
	 */
	@Override
	public String[] getOneWeekMeetingTime(String sundayDate) {
		String[] time = new String[14];
		List<DateFindBean> list = roomUsedDao.getOneWeekMeetingTime(sundayDate);
		for (int i = 0; i < list.size(); i++) {
			DateFindBean df = list.get(i);
			time[i * 2] = df.getWd() + " 11:59:59";
			time[i * 2 + 1] = df.getWd() + " 12:00:00";
		}
		return time;
	}

	/**
	 * 获取会议室看板数据
	 * @param pageNum     当前页码数
	 * @param pageSize    每页显示条目数
	 * @return
	 */
	public PageResult<RoomApplySearchBean> findRoomUsed(int pageNum, int pageSize) {
		StringBuffer sb = new StringBuffer();
		String dateTime = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
		sb.append("SELECT M.ID_ roomused_id, M.ROOM_APPLY_ID roomapply_id, A.USER_NAME apply_user, R.ROOM_NAME room_name, M.MEETING_NAME meeting_name, ");
		sb.append("M.START_TIME start_time, M.END_TIME end_time, M.PURPOSE purpose, M.apply_time, ( CASE WHEN START_TIME > '"+dateTime+"' THEN '未开始' ELSE '已开始' END ) AS status ");
		sb.append("FROM BIZ_MT_ROOMUSING M LEFT JOIN ISC_USER A ON M.APPLY_USER_ID = A.USER_ID LEFT JOIN BIZ_MT_MEETINGROOM R ON M.ROOM_ID = R.ID_ ");
		sb.append("WHERE M. STATUS = '2' AND M.END_TIME > '"+dateTime+"' ORDER BY M.START_TIME ASC, M.END_TIME ASC,M.APPLY_TIME DESC");
		return roomUsedDao.getPageData(RoomApplySearchBean.class, pageNum, pageSize, sb.toString());
	}

	/**
	 * 获取会议室看板数据
	 * @param pageNum     当前页码数
	 * @param pageSize    每页显示条目数
	 * @param meetingname 会议名称
	 * @return
	 */
	public PageResult<RoomUsingSearchBean> findRoomUsed(int pageNum, int pageSize,
			String meetingname,String sortName,String sortOrder,String queryParams) {
		//StringBuffer sb = new StringBuffer();
		//String dateTime = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
		//sb.append("SELECT M.ID_ roomused_id, M.ROOM_APPLY_ID roomapply_id, A.USER_NAME apply_user, R.ROOM_NAME room_name, M.MEETING_NAME meeting_name, ");
		//sb.append("M.START_TIME start_time, M.END_TIME end_time, M.PURPOSE purpose, M.apply_time, ( CASE WHEN START_TIME > '"+dateTime+"' THEN '未开始' ELSE '已开始' END ) AS status ");
		//sb.append("FROM BIZ_MT_ROOMUSING M LEFT JOIN ISC_USER A ON M.APPLY_USER_ID = A.USER_ID LEFT JOIN BIZ_MT_MEETINGROOM R ON M.ROOM_ID = R.ID_ ");
		//sb.append("WHERE M. STATUS = '2' AND M.END_TIME > '"+dateTime+"' AND M.MEETING_NAME LIKE '%"+meetingname+"%' ORDER BY M.START_TIME ASC, M.END_TIME ASC,M.APPLY_TIME DESC");
		//return roomUsedDao.getPageData(RoomApplySearchBean.class, pageNum, pageSize, sb.toString());
		
		StringBuffer sql = new StringBuffer();
		String dateTime = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
		sql.append("SELECT m.id_ , M.room_apply_id, m.meeting_name, r.room_name, a.USER_NAME, ");
		sql.append("m.start_time , m.end_time ,  ( CASE WHEN START_TIME > '"+dateTime+"' THEN '未开始' ELSE '已开始' END ) AS status"
				+ " FROM BIZ_MT_ROOMUSING m ");
		sql.append("LEFT JOIN ISC_USER a ON m.APPLY_USER_ID = a.USER_ID LEFT JOIN BIZ_MT_MEETINGROOM r ON m.ROOM_ID = r.ID_  ");
		sql.append(" WHERE  M. STATUS = '2' AND M.END_TIME > '"+dateTime+"'  " );
		if (!"".equals(meetingname)) {
			sql.append("AND m.MEETING_NAME LIKE "+"'%"+meetingname.trim()+"%'");
		}else if(StringUtils.isNotBlank(queryParams)){
			if(StringUtils.isNotBlank(queryParams)){
				String[] paramsArr = queryParams.split("&");
				if(paramsArr != null && paramsArr.length > 0) {
					String[] keyValueArr;
					for (String keyValue : paramsArr) {
						keyValueArr = keyValue.split("=");
						if(keyValueArr.length == 2) {
							String key = keyValueArr[0];
							String value = keyValueArr[1];
							if(StringUtils.isNotBlank(key)&&StringUtils.isNotBlank(value)) {
								if("room_name".equals(key)){
									sql.append(" AND r.room_name like '%" + value.trim() + "%'");
								}else if("meeting_name".equals(key)){
									sql.append(" AND m.meeting_name like '%" + value.trim() + "%'");
								}else if("USER_NAME".equals(key)){
									sql.append(" AND a.USER_NAME like '%" + value.trim() + "%'");
								}else if("start_time".equals(key)){
									sql.append(" AND m.start_time >= '"+value+"' ");
								}else if("end_time".equals(key)){
									sql.append(" AND m.end_time  <= '"+value+"' ");
								}else if("status".equals(key)){
									sql.append(" AND m.status = '" + value + "'");
								}
							}
						}
					}
				}
			}
		}
		if(StringUtils.isNotEmpty(sortName)){
			if("status".equals(sortName)){
				sql. append(" order by CONVERT( m."+ sortName +" USING gbk) "+sortOrder);
			}else if("room_name".equals(sortName)){
				sql. append(" order by CONVERT( r."+ sortName +" USING gbk) "+sortOrder);
			}else{
				sql. append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
			}
		}else{
			sql.append(" order by m.start_time "+sortOrder);
		}
/*		Query query = em.createNativeQuery(sql.toString());
		if(!"".equals(meetingname)){
			query.setParameter(1, "%"+meetingname+"%");
		}*/
		return roomUsedDao.getPageData(RoomUsingSearchBean.class, pageNum, pageSize, sql.toString());
	}

	@Override
	public void delRoomUsingById(String roomApplyId) {
		roomUsedDao.delRoomUsingById(roomApplyId);
	}

}
