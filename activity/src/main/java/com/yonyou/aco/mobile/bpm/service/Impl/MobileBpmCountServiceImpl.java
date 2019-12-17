package com.yonyou.aco.mobile.bpm.service.Impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import com.yonyou.aco.mobile.bpm.service.IMobileBpmCountService;
import com.yonyou.aco.notice.entity.BizNoticeInfoEntity;
import com.yonyou.aco.notice.service.NoticeService;
import com.yonyou.cap.bpm.entity.BizGwCircularsBean;
import com.yonyou.cap.bpm.entity.TaskBean;
import com.yonyou.cap.bpm.service.IBpmQueryService;
import com.yonyou.cap.common.util.PageResult;

/**
 * 
 * ClassName: MobileBpmServiceImpl
 * 
 * @Description: 移动端-流程业务实现类
 * @author hegd
 * @date 2016-8-23
 */
@Repository("mobileBpmService")
public class MobileBpmCountServiceImpl implements IMobileBpmCountService {

	@Resource
	IBpmQueryService bpmQueryService;
	@Resource
	NoticeService noticeService;

	@Override
	public PageResult<TaskBean> findtTaskInfoByUserId(int pageNum,
			int pageSize, String userId) {
		return bpmQueryService.findMobileTaskToDoList(pageNum, pageSize, userId);
	}


	@Override
	public PageResult<BizNoticeInfoEntity> findNoticeInfoByUserId(int pageNum,
			int pageSize, String userId) {
		return noticeService
				.findJsNoticeList(pageNum, pageSize, userId, "", "");
	}

	@Override
	public PageResult<BizNoticeInfoEntity> findUneadNoticeNoReadInfoByUserId(
			int pageNum, int pageSize, String userId) {
		return noticeService.findUneadNoticeNoReadInfoByUserId(pageNum, pageSize, userId);
	}
	
	public PageResult<BizGwCircularsBean> findMobileReadInfoByUserId(int page,
			int perPageNum, String userId) {
		return bpmQueryService.findMobileCirculateByPage(page, perPageNum,
				userId);
	}

}
