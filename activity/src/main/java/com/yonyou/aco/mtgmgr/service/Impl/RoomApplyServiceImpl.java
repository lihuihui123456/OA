package com.yonyou.aco.mtgmgr.service.Impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yonyou.aco.mtgmgr.dao.IRoomApplyDao;
import com.yonyou.aco.mtgmgr.dao.IRoomUsedDao;
import com.yonyou.aco.mtgmgr.entity.BizMtRoomApplyEntity;
import com.yonyou.aco.mtgmgr.entity.RoomApplySearchBean;
import com.yonyou.aco.mtgmgr.entity.RoomBean;
import com.yonyou.aco.mtgmgr.service.IRoomApplyService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.dataauth.datarule.service.IDataRuleService;

@Service("roomApplyService")
public class RoomApplyServiceImpl implements IRoomApplyService {

	@Resource
	private IRoomApplyDao roomApplyDao;
	@Resource
	private IRoomUsedDao roomUsedDao;
	
	@Resource
	IDataRuleService dataRuleService;

	@Override
	public PageResult<RoomBean> findAllPerApply(String meetingname, int pageNum, int pageSize, String userId) {
		//return roomApplyDao.findAllPerApply(meetingname, pageNum, pageSize, userId);
		return null;
	}
	
	@Override
	public void doSaveRoomApply(BizMtRoomApplyEntity roomApply) {
		roomApplyDao.save(roomApply);
		
	}

	@Override
	public RoomBean findPerApplyById(String id) {
		return roomApplyDao.findPerApplyById(id);
	}

	@Override
	public int getCount() {
		return roomApplyDao.getCount();
	}

	@Override
	public void doUpdateStatus(String ids, String status) {
		roomApplyDao.doUpdateStatus(ids, status);
		
	}

	/**
	 * 获取会议室申请记录
	 * @param modCode      模块code
	 * @param pageNum      当前页码数
	 * @param pageSize     每页分页数
	 * @param meetingname  会议名称（搜索参数）
	 * @return
	 */
	@Override
	public PageResult<RoomApplySearchBean> findRoomApplyData(String modCode, int pageNum,
			int pageSize,String sortName,String sortOrder, String meetingname,String queryParams) {
		PageResult<RoomApplySearchBean> page = new PageResult<RoomApplySearchBean>();
		page = roomApplyDao.findAllPerApply(meetingname, pageNum, pageSize,
				sortName,sortOrder,queryParams , modCode);
		/*if (sql.getParam().contains("data_user_id")) {
		} else if (sql.getParam().contains("dataOrgId")) {
			page = roomUsedDao.findAllApply(pageNum, pageSize, meetingname);
		}*/
		return page;
	}

}
