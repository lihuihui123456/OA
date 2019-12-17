package com.yonyou.aco.notice.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.yonyou.aco.notice.entity.BizNoticeInfoBean;
import com.yonyou.aco.notice.entity.BizNoticeInfoEntity;
import com.yonyou.aco.notice.entity.BizNoticePeopleEntity;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

public interface NoticeService {

	/**
	 * 
	 * TODO: 填入方法概括. TODO: 填入方法说明
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param wheresql
	 * @return
	 */
	public PageResult<BizNoticeInfoBean> findAllNoticeList(int pageNum,
			int pageSize, String wheresql);
	
	public PageResult<BizNoticeInfoBean> findAllNoticeList(int pageNum,
			int pageSize, String query,String sortName,String sortOrder,String queryPams,ShiroUser user);

	public PageResult<BizNoticeInfoBean> findAllNoticeListBean(int pageNum,
			int pageSize, String query,String sortName,String sortOrder,String queryPams,ShiroUser user);
	/**
	 * 保存通知信息
	 * 
	 * @param noticeInfo
	 * @param request 
	 * @return
	 */
	public String doSaveNoticeInfo(BizNoticeInfoEntity noticeInfo, HttpServletRequest request);

	/**
	 * 获取数量（总数、已处理数、未处理数）
	 * 
	 * @param id
	 * @return
	 */
	public BizNoticePeopleEntity findCount(String id);

	/**
	 * 根据主键查询通知信息
	 * 
	 * @param id
	 * @return
	 */
	public BizNoticeInfoEntity findNoticeInfoById(String id);

	public BizNoticePeopleEntity queryPeopleById(String id, String uid);

	/**
	 * 保存通知信息的人员信息
	 * 
	 * @param bean
	 */
	public void doSaveNoticePeopleInfo(BizNoticePeopleEntity bean);

	public void doSaveRecePeople(String senderid, String sceneid, String id,ShiroUser user);

	/**
	 * 获取所有通知信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param userid
	 * @param query
	 * @param where
	 * @return
	 */
	public PageResult<BizNoticeInfoEntity> findJsNoticeList(int pageNum,
			int pageSize, String userid, String query, String where);
	/**
	 * 获取通知消息的所有人员信息
	 * 
	 * @param id
	 * @return
	 */
	public PageResult<BizNoticePeopleEntity> findNoticeAllPeopleinfo(String id);

	/**
	 * 删除发送通知的消息
	 * 
	 * @param id
	 */
	public void doDeleteNoticeById(String id);

	/**
	 * 查询已经提交通知的消息
	 */
	public List<BizNoticeInfoEntity> queryBizNoticeInfoEntity();
	
	/**
	 * 获取所有通知信息 （手机端调用）
	 * @param pageNum
	 * @param pageSize
	 * @param userid
	 * @param query
	 * @param where
	 * @return
	 */
	public PageResult<BizNoticeInfoEntity> findUneadNoticeNoReadInfoByUserId(
			int pageNum, int pageSize, String userId);
	/**
	 * 个人桌面获取通知信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param userid
	 * @param query
	 * @param where
	 * @return
	 */
	public PageResult<BizNoticeInfoEntity> findNoticeData(int pageNum,
			int pageSize, String userid, String query, String where);
	/**
	 * 个人桌面获取通知信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param userid
	 * @param query
	 * @param where
	 * @return
	 */
	public List<BizNoticeInfoEntity> findNoticeList(int num, String userid);
}
