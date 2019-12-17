package com.yonyou.aco.persfile.service.impl;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.yonyou.aco.persfile.dao.IPersFileDao;
import com.yonyou.aco.persfile.entity.PersFileEntity;
import com.yonyou.aco.persfile.entity.PersInfoBean;
import com.yonyou.aco.persfile.entity.PersInfoEntity;
import com.yonyou.aco.persfile.service.IPersFileService;
import com.yonyou.cap.common.util.PageResult;

@Service("persFileService")
public class PersFileServiceImpl implements IPersFileService {

	@Resource
	IPersFileDao persFileDao;

	@Override
	public PageResult<PersInfoBean> findPersFileDateByQueryParams(int pageNum, int pageSize, String solId,
			String userName, String sortName, String sortOrder, String userId, String queryParams) {
		StringBuilder sb = new StringBuilder();
	/*	sb.append("SELECT b.SOL_ID_,p.ID,p.PERS_FILE_ID,p.USER_NAME,p.USER_SEX,"
				+ "p.USER_CERT_CODE,p.MARITAL_STATUS,p.USER_EDUCATION,"
				+ "p.USER_POLICE_TYPE FROM biz_persfile_info p ");
		sb.append("LEFT JOIN bpm_ru_biz_info b ");
		sb.append("ON b.ID_ = p.PERS_FILE_ID ");
		sb.append("WHERE b.DR_='N' AND b.CREATE_USER_ID_='" + userId + "'");*/
		sb.append("SELECT  p.ts, p.data_user_id, p.data_dept_code, p.data_org_id, p.data_tenant_id, p.c_uid, p.dynamic_data, p.userName_, p.user_sex, p.user_height,"
				+"p.marital_status, p.user_native_place, p.user_police_type, p.user_nation, p.user_cert_code, p.user_bitrth, p.user_education, p.user_degree, p.join_time,"
				+"p.entry_time, p.work_time, p.office_phone, p.telephone, p.user_email, p.user_address, p.user_seniority, p.user_duty_type, p.deptName_, p.user_qq,"
				+"p.duty_post, p.id, p.dept_, p.appointment,b.sol_id_"
				+ " FROM fd_biz_people p ");
		sb.append("LEFT JOIN bpm_ru_biz_info b ");
		sb.append("ON b.ID_ = p.id where p.dr='N' ");
		// 简单查询
		if (StringUtils.isNotBlank(userName)) {
			sb.append(" AND p.userName_ LIKE '%" + userName + "%'");
		}

		// 列表高级查询
		if (StringUtils.isNotBlank(queryParams)) {
			String[] paramsArr = queryParams.split("&");
			if (paramsArr != null && paramsArr.length > 0) {
				String[] keyValueArr;
				for (String keyValue : paramsArr) {
					keyValueArr = keyValue.split("=");
					if (keyValueArr.length == 2) {
						String key = keyValueArr[0];
						String value = keyValueArr[1];
						if (StringUtils.isNotBlank(key) && StringUtils.isNotBlank(value)) {
							if ("USER_NAME".equals(key)) {
								sb.append(" AND p.userName_ LIKE '%" + value.trim() + "%'");
							} else if ("USER_SEX".equals(key)) {
								sb.append(" AND p.user_sex ='" + value.trim() + "'");
							} else if ("deptName".equals(key)) {
								sb.append(" AND p.deptName_ LIKE '%" + value.trim() + "%'");
							} else if ("postName".equals(key)) {
								sb.append(" AND p.duty_post  LIKE '%" + value.trim() + "%'");
							} else if ("entryTime".equals(key)) {
								sb.append(" AND p.entry_time  LIKE '%" + value.trim() + "%'");
							}  else if ("user_duty_type".equals(key)) {
								sb.append(" AND p.user_duty_type ='" + value.trim() + "'");
							}
						}
					}
				}
			}
		}
		// 列表排序功能
		if (StringUtils.isNotBlank(sortName) && StringUtils.isNotBlank(sortOrder)) {
			sb.append(" ORDER BY CONVERT(" + sortName + " USING gbk) " + sortOrder);
		} else {
			sb.append(" ORDER BY p.entry_time DESC");
		}
		return persFileDao.getPageData(PersInfoBean.class, pageNum, pageSize, sb.toString());
	}

	@Override
	public void doSavePersFileInfo(PersFileEntity pfEntity) {
		persFileDao.update(pfEntity);
	}

	@Override
	public void doDelPersFileInfoByPersFileId(String [] persFileIds) {
		for (String persFileId : persFileIds) {
			persFileDao.delete(PersFileEntity.class,persFileId );
		}
	}

	@Override
	public PersInfoEntity findPersInfoEntityById(String id) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT  p.ts, p.data_user_id, p.data_dept_code, p.data_org_id, p.data_tenant_id, p.c_uid, p.dynamic_data, p.userName_, p.user_sex, p.user_height,"
				+"p.marital_status, p.user_native_place, p.user_police_type, p.user_nation, p.user_cert_code, p.user_bitrth, p.user_education, p.user_degree, p.join_time,"
				+"p.entry_time, p.work_time, p.office_phone, p.telephone, p.user_email, p.user_address, p.user_seniority, p.user_duty_type, p.deptName_, p.user_qq,"
				+"p.duty_post, p.id, p.dept_, p.appointment"
				+ " FROM fd_biz_people p ");
		sb.append(" where p.id='"+id+"'");
		PageResult<PersInfoEntity> pageData = persFileDao.getPageData(PersInfoEntity.class, 1, 10, sb.toString());
		if(pageData.getResults().size()>=1){
			return pageData.getResults().get(0);
		}else{
			return null;
		}
	}

	@Override
	public void doUpdatePersInfoEntity(PersInfoEntity persInfoEntity) {
		persFileDao.doUpdatePersInfoEntity(persInfoEntity);
	}

}
