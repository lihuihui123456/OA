package com.yonyou.aco.cloudydisk.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yonyou.aco.cloudydisk.dao.ICloudLogDao;
import com.yonyou.aco.cloudydisk.entity.CloudFolderRefLogEntity;
import com.yonyou.aco.cloudydisk.entity.CloudLogEntity;
import com.yonyou.aco.cloudydisk.service.ICloudLogService;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.service.IUserService;

@Service("ICloudLogService")
public class CloudLogServiceImpl implements ICloudLogService{
	@Resource
	ICloudLogDao dao;
	@Resource
	IUserService userService;
	@Override
	public void saveFolderLog(String folderId,String userId,String act,String time) {
		final String finalAct=act;
		final String finalUserId=userId;
		final String finalFolderId=folderId;
		final User user=userService.findUserById(userId);
		Runnable run = new Runnable() {
			public void run() {
				CloudLogEntity logEntity=new CloudLogEntity();
				logEntity.setAct(finalAct);
				logEntity.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
				logEntity.setActUserId(finalUserId);
				logEntity.setActUserName(user.getUserName());
				logEntity.setDr("N");
				dao.save(logEntity);
				CloudFolderRefLogEntity ref=new CloudFolderRefLogEntity();
				ref.setFolderId(finalFolderId);
				ref.setLogId(logEntity.getLogId());
				ref.setDr("N");
				ref.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
				dao.save(ref);
			}
		};
		new Thread(run).start();
	}
	@Override
	public PageResult<CloudLogEntity> findCloudLog(int pagenum, int pagesize,String sortName,String sortOrder,String folderId) {
		return dao.findCloudLog(pagenum,pagesize,sortName,sortOrder,folderId);
	}

}
