package com.yonyou.aco.cloudydisk.dao.impl;

import org.springframework.stereotype.Repository;

import com.yonyou.aco.cloudydisk.dao.ICloudLogDao;
import com.yonyou.aco.cloudydisk.entity.CloudLogEntity;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;
@Repository("ICloudLogDao")
public class CloudLogDaoImpl extends BaseDao implements ICloudLogDao{

	@Override
	public PageResult<CloudLogEntity> findCloudLog(int pagenum, int pagesize,String sortName,String sortOrder,String folderId) {
		StringBuilder sql=new StringBuilder();
		sql.append("SELECT "
				+ "L.LOG_ID AS logId,"
				+ "L.ACT AS act,"
				+ "L.ACT_USER_ID AS actUserId,"
				+ "L.ACT_USER_NAME AS actUserName,"
				+ "concat(L.DR,'') AS dr,"
				+ "L.TS AS ts FROM CLOUD_LOG L INNER JOIN CLOUD_FOLDER_REF_LOG R ON "
				+ " L.LOG_ID=R.LOG_ID WHERE L.DR='N' AND R.DR='N' AND R.FOLDER_ID='"+folderId+"' ORDER BY L.TS DESC");
		return this.getPageData(CloudLogEntity.class, pagenum, pagesize, sql.toString());
	}

}
