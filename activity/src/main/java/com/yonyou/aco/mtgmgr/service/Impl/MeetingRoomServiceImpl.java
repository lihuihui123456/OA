package com.yonyou.aco.mtgmgr.service.Impl;

import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.yonyou.aco.mtgmgr.dao.IMeetingRoomDao;
import com.yonyou.aco.mtgmgr.dao.IRoomApplyDao;
import com.yonyou.aco.mtgmgr.entity.BizMtMeetingRoomBean;
import com.yonyou.aco.mtgmgr.entity.BizMtMeetingRoomEntity;
import com.yonyou.aco.mtgmgr.service.IMeetingRoomService;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;

@Service("meetingRoomService")
public class MeetingRoomServiceImpl implements IMeetingRoomService {

	@Resource
	private IMeetingRoomDao meetingRoomDao;
	
	@Resource
	private IRoomApplyDao roomApplyDao;

	/**
	 * 分页获取会议室并排序
	 */
	@Override
	public PageResult<BizMtMeetingRoomBean> findAllMTGInfo(int pageNum, int pageSize,
			String sortName,String sortOrder) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT id_,room_num, room_name,seats, area, floor,"
				+ "projector,video_conference, status ");
		sb.append("FROM biz_mt_meetingroom ");
		if(StringUtils.isNotEmpty(sortName)){
			sb. append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sb.append(" order by sort "+sortOrder);
		}
		return meetingRoomDao.getPageData(BizMtMeetingRoomBean.class, pageNum, pageSize, sb.toString());
		
		//LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		//orderby.put("sort", "desc");
		//return meetingRoomDao.getPageData(BizMtMeetingRoomEntity.class, pageNum, pageSize,orderby);
	}

	/**
	 * 根据会议室名称模糊查询会议室 实现分页
	 */
	@Override
	public PageResult<BizMtMeetingRoomBean> findAllMTGInfo(int pageNum, int pageSize,
			String roomName,String sortName,String sortOrder) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT id_,room_num, room_name,seats, area, floor,"
				+ "projector,video_conference, status ");
		sb.append("FROM biz_mt_meetingroom ");
		sb.append("where  room_name like '%"+roomName.trim()+"%' ");
		if(StringUtils.isNotEmpty(sortName)){
			sb. append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sb.append(" order by sort "+sortOrder);
		}
		return meetingRoomDao.getPageData(BizMtMeetingRoomBean.class, pageNum, pageSize, sb.toString());
		
		/*String wheresql = "room_name like ?";
		String param = "%" + roomName + "%";
		Object[] queryParams = { param };
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		orderby.put("sort", "desc");
		return meetingRoomDao.getPageData(BizMtMeetingRoomEntity.class, pageNum, pageSize,
				wheresql, queryParams, orderby);*/
	}
	/**
	 * 根据会议室 高级查询 会议室 实现分页
	 */
	@Override
	public PageResult<BizMtMeetingRoomBean> findAllMTGInfo(int pageNum, int pageSize,
			String roomName,String sortName,String sortOrder,String queryParams) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT id_,room_num, room_name,seats, area, floor,"
				+ "projector,video_conference, status ");
		sb.append("FROM biz_mt_meetingroom ");
		sb.append("where  1=1 ");
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
								sb.append(" AND room_name like '%" + value.trim() + "%'");
							}else if("room_num".equals(key)){
								sb.append(" AND room_num = '" + value + "'");
							}else if("seats".equals(key)){
								sb.append(" AND seats = '" + value + "'  ");
							}else if("area".equals(key)){
								sb.append(" AND area = '" + value + "'");
							}else if("floor".equals(key)){
								sb.append(" AND floor = '" + value + "'");
							}else if("projector".equals(key)){
								sb.append(" AND projector = '" + value + "'");
							}else if("video_conference".equals(key)){
								sb.append(" AND video_conference = '" + value + "'");
							}else if("status".equals(key)){
								sb.append(" AND status = '" + value + "'");
							}
						}
					}
				}
			}
		}
		if(StringUtils.isNotEmpty(sortName)){
			sb. append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sb.append(" order by sort "+sortOrder);
		}
		return meetingRoomDao.getPageData(BizMtMeetingRoomBean.class, pageNum, pageSize, sb.toString());
	}

	/**
	 * 保存方法
	 */
	@Override
	public void doAddMeetingRoom(BizMtMeetingRoomEntity mr) {
		meetingRoomDao.save(mr);
	}

	@Override
	public int getCount() {
		return meetingRoomDao.getCount();
	}

	/**
	 * 删除方法
	 */
	@Override
	public int doDelMeetingRoom(String ids[]) {
		String id; // 会议室id
		String endTime = ""; // 单个会议室预订或使用的最晚时间 格式： yyyy-MM-dd HH:mm:ss
		int num = 0; //未成功删除的会议室数目
		String dateTime = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"); //当前服务器时间
		long nowTime = Long.valueOf(dateTime.replaceAll("[-\\s:]",""));// 将当前时间时间转化为long 类型用来比较前后
		long lastTime; // 将最晚时间时间转化为long 类型用来比较前后
		for (int i = 0; i < ids.length; i++) {
			id = ids[i];
			endTime = roomApplyDao.getLastTimeById(id, dateTime);
			if ( !StringUtils.isEmpty(endTime) ) {
				lastTime = Long.valueOf(endTime.replaceAll("[-\\s:]",""));
				if ( nowTime > lastTime ) {
					//删除会议室
					roomApplyDao.delete(BizMtMeetingRoomEntity.class, id);
				} else {
					num++;
				}
			} else {
				//删除会议室
				roomApplyDao.delete(BizMtMeetingRoomEntity.class, id);
			}
		}
		return num;
	}

	/**
	 * 通过id获取一条记录
	 */
	@Override
	public BizMtMeetingRoomEntity findMTGRoomById(String id) {
		return meetingRoomDao.findEntityByPK(BizMtMeetingRoomEntity.class, id);
	}

	/**
	 * 更新方法
	 */
	@Override
	public void doUpdateMeetingRoom(BizMtMeetingRoomEntity meetingRoom) {
		meetingRoomDao.update(meetingRoom);
	}

	/**
	 * 获取所有状态为启用的会议室
	 */
	@Override
	public List<BizMtMeetingRoomEntity> findUsableMeetingRoom() {
		String wheresql = " status = '1' ";
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		orderby.put("sort", "desc");
		return meetingRoomDao.getListBySql(BizMtMeetingRoomEntity.class, wheresql, null, orderby);
	}

	@Override
	public List<BizMtMeetingRoomEntity> findEXSTRoom(String fieldId, String fieldValue) {
		String wheresql = ""+fieldId+" = ? ";
		String param = "" + fieldValue + "";
		Object[] queryParams = { param };
		return meetingRoomDao.getListBySql(BizMtMeetingRoomEntity.class, wheresql , queryParams, null);
	}

	@Override
	public List<BizMtMeetingRoomEntity> getDataByRoomname(String fieldId, String fieldValue) {
		String wheresql = ""+fieldId+" = ? ";
		String param = "" + fieldValue + "";
		Object[] queryParams = { param };
		return meetingRoomDao.getListBySql(BizMtMeetingRoomEntity.class, wheresql , queryParams, null);
	}
}
