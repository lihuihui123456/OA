package com.yonyou.aco.notice.dao;


import java.util.List;

import com.yonyou.aco.notice.entity.BizNoticeInfoEntity;
import com.yonyou.aco.notice.entity.BizNoticePeopleEntity;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;

public interface NoticeDao extends IBaseDao{

	
	public BizNoticePeopleEntity findCount(String id);

	public BizNoticePeopleEntity queryPeopleById(String id, String uid);

	public PageResult<BizNoticeInfoEntity> findJsNoticeList(int pageNum, int pageSize,
			String userid, String query, String where);

	public PageResult<BizNoticePeopleEntity> findNoticeAllPeopleinfo(String id);
	/**
	 * 查询已经提交通知的消息
	 */
	public List<BizNoticeInfoEntity> queryBizNoticeInfoEntity();
	
	public PageResult<BizNoticeInfoEntity> findNoticeData(int pageNum, int pageSize,
			String userid, String query, String where);
	
	public List<BizNoticeInfoEntity> findNoticeList(int num,String userid);

}
