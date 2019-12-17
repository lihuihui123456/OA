package com.yonyou.aco.cloudydisk.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.persistence.Query;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.cloudydisk.dao.ICloudShareDao;
import com.yonyou.aco.cloudydisk.entity.CloudShareBean;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.user.entity.UserAll;
import com.yonyou.cap.isc.user.service.IUserService;

@Repository("CloudShareDao")
public class CloudShareDaoImpl extends BaseDao implements ICloudShareDao{
	@Resource
	IUserService userService;
	@SuppressWarnings("unchecked")
	@Override
	public List<CloudShareBean> getShareFileByUser(String senderId,String receiverId) {
		
		StringBuilder sql=new StringBuilder();
		sql.append("SELECT F.*,F.FILE_ID AS ID_,"
				+ "S.SENDER_ID AS SENDER_ID,"
				+ "S.SENDER_NAME AS SENDER_NAME,"
				+ "S.RECEIVER_ID AS RECEIVER_ID,"
				+ "S.RECEIVER_NAME AS RECEIVER_NAME,"
				+ "S.TS AS SHARE_TIME FROM CLOUD_FILE F INNER JOIN CLOUD_SHARE S ON F.FILE_ID=S.FILE_ID"
				+ " WHERE F.DR=? AND S.DR=? AND S.SENDER_ID=? AND S.RECEIVER_ID=? ");
		Query query = em.createNativeQuery(sql.toString(),CloudShareBean.class);
		query.setParameter(1, "N");
		query.setParameter(2, "N");
		query.setParameter(3, senderId.substring(1));
		query.setParameter(4, receiverId);
		return query.getResultList();
	}

	@Override
	public Map<String, String> getUserNames() {
		List<UserAll> userList=userService.findUserAll();
		Map<String,String> map=new HashMap<String,String>();
		for(int i=0;i<userList.size();i++){
			UserAll userAll=userList.get(i);
			map.put(userAll.getUserId(), userAll.getUserName());
		}
		return map;
	}

	@Override
	public PageResult<CloudShareBean> findShareFile(int pagenum, int pagesize,
			String sortName, String sortOrder, String senderId, String receiverId,boolean groupBy,String fileId) {
		StringBuilder sql=new StringBuilder();
		sql.append("SELECT B.ID_ AS id,"
				+ "A.FILE_ID AS fileId,"
				+ "A.FILE_NAME AS fileName,"
				+ "A.RECORD_ID AS recordId,"
				+ "A.PARENT_FILE_ID AS parentFileId,"
				+ "A.FILE_TYPE AS fileType,"
				+ "A.FILE_ATTR AS fileAttr,"
				+ "A.FILE_PATH AS filePath,"
				+ "A.FILE_SIZE AS fileSize,"
				+ "A.FILE_OWNER_ID AS fileOwnerId,"
				+ "A.FILE_OWNER_NAME AS fileOwnerName,"
				+ "A.FILE_DATE AS fileDate,"
				+ "A.FILE_COUNT AS fileCount,"
//				+ "A.IS_DOWNLOAD AS isDownload,"
//				+ "A.IS_COVER AS isCover,"
//				+ "A.MD5 AS md5,"
//				+ "concat(A.DR,'') AS dr,"
//				+ "A.TS AS ts,"
				+ "B.SENDER_ID AS senderId,"
				+ "B.SENDER_NAME AS senderName,"
				+ "B.RECEIVER_ID AS receiverId,"
				+ "B.RECEIVER_NAME AS receiverName,"
				+ "B.TS AS shareTime  "
				+ "FROM CLOUD_FILE A INNER JOIN CLOUD_SHARE B ON A.FILE_ID=B.FILE_ID WHERE A.DR='N' AND B.DR='N'");
		if(senderId!=null&&!"".equals(senderId)){
			sql.append(" AND B.SENDER_ID='"+senderId+"'");
		}
		if(receiverId!=null&&!"".equals(receiverId)){
			sql.append(" AND B.RECEIVER_ID='"+receiverId+"'");
		}
		if(fileId!=null&&!"".equals(fileId)){
			sql.append(" AND A.FILE_ID='"+fileId+"'");
		}
		if(groupBy){
			sql.append("GROUP BY A.MD5");
		}
		if(StringUtils.isNotEmpty(sortName)){
			sql.append(" ORDER BY CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sql.append(" ORDER BY A.TS");
		}
		return this.getPageData(CloudShareBean.class, pagenum, pagesize, sql.toString());
	}

}
