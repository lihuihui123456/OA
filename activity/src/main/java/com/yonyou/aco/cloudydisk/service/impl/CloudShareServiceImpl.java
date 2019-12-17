package com.yonyou.aco.cloudydisk.service.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yonyou.aco.cloudydisk.dao.ICloudShareDao;
import com.yonyou.aco.cloudydisk.entity.CloudShareBean;
import com.yonyou.aco.cloudydisk.entity.CloudShareEntity;
import com.yonyou.aco.cloudydisk.service.ICloudShareService;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

@Service("ICloudShareService")
public class CloudShareServiceImpl  implements ICloudShareService{
	@Resource
	ICloudShareDao dao;
	@Override
	public void shareFile(String fileIds, String receiverId,ShiroUser user) {
		String fileIdStr[]=fileIds.split(",");
		Map<String,String> map=dao.getUserNames();
		for(int i=0;i<fileIdStr.length;i++){
			String receiverIdStr[]=receiverId.split(",");
			for(int j=0;j<receiverIdStr.length;j++){
				CloudShareEntity shareEntity=new CloudShareEntity();
				shareEntity.setDr("N");
				shareEntity.setFileId(fileIdStr[i]);
				shareEntity.setReceiverId(receiverIdStr[j]);
				shareEntity.setReceiverName(map.get(receiverIdStr[j]));
				shareEntity.setSenderId(user.getId());
				shareEntity.setSenderName(user.getName());
				shareEntity.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
				dao.save(shareEntity);
			}
		}
	}
	@Override
	public PageResult<CloudShareBean> findShareFile(int pagenum, int pagesize,
			String sortName, String sortOrder, String senderId, String receiverId,boolean groupBy,String fileId) {
		return dao.findShareFile(pagenum, pagesize, sortName, sortOrder, senderId, receiverId,groupBy,fileId);
	}
	@Override
	public void cancelShare(String ID_) {
		CloudShareEntity share=dao.findEntityByPK(CloudShareEntity.class, ID_);
		share.setDr("Y");
		dao.update(share);
	}

}
