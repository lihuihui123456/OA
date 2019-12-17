package com.yonyou.aco.mobile.bpm.service;

import com.yonyou.aco.notice.entity.BizNoticeInfoEntity;
import com.yonyou.cap.bpm.entity.BizGwCircularsBean;
import com.yonyou.cap.bpm.entity.TaskBean;
import com.yonyou.cap.common.util.PageResult;

/**
 * 
 * ClassName: 移动端-流程业务接口类
 * 
 * @Description: TODO
 * @author hegd
 * @date 2016-8-23
 */
public interface IMobileBpmCountService {

	/**
	 * 
	 * @Description: 移动端-获取用户待办文件数量
	 * @param @param userId
	 * @param @return
	 * @return int
	 * @throws
	 * @author hegd
	 * @date 2016-8-23
	 */
	public PageResult<TaskBean> findtTaskInfoByUserId(int pageNum,
			int pageSize, String userId);

	/**
	 * 
	 * @Description: 移动端-获取用户待阅文件数量
	 * @param @param userId
	 * @param @return
	 * @return int
	 * @throws
	 * @author hegd
	 * @date 2016-8-23
	 */
	public PageResult<BizGwCircularsBean> findMobileReadInfoByUserId(int pageNum,
			int pageSize, String userId);

	/**
	 * 
	 * @Description: 移动端-获取用户待办通知公告数量
	 * @param @param userId
	 * @param @return
	 * @return int
	 * @throws
	 * @author hegd
	 * @date 2016-8-23
	 */
	public PageResult<BizNoticeInfoEntity> findNoticeInfoByUserId(int pageNum,
			int pageSize, String userId);
	
	/**
	 * 移动端-获取用户待办通知公告
	 * @param @param userId
	 * @param @return
	 * @author add by luzhw
	 * @date 2016-12-20
	 */
	PageResult<BizNoticeInfoEntity> findUneadNoticeNoReadInfoByUserId(
			int pageNum, int pageSize, String userId);

}
