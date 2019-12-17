package com.yonyou.aco.cloudydisk.dao.impl;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Query;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;
import org.springside.modules.utils.Identities;

import com.yonyou.aco.cloudydisk.dao.ICloudDiskDao;
import com.yonyou.aco.cloudydisk.entity.CloudAuthNode;
import com.yonyou.aco.cloudydisk.entity.CloudAuthNodes;
import com.yonyou.aco.cloudydisk.entity.CloudAuthorityEntity;
import com.yonyou.aco.cloudydisk.entity.CloudFileEntity;
import com.yonyou.aco.cloudydisk.entity.CloudUserRefFileEntity;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;

@Repository("ICloudDiskDao")
public class CloudDiskDaoImpl extends BaseDao implements ICloudDiskDao{
	@Override
	public PageResult<CloudFileEntity> findCloudFileByUser(ShiroUser user,
			int pagenum, int pagesize, String sortName, String sortOrder,String filters,String orFilters) {
		StringBuilder sql=new StringBuilder();
		sql.append("SELECT "
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
				+ "A.IS_DOWNLOAD AS isDownload,"
				+ "A.IS_COVER AS isCover,"
				+ "A.MD5 AS md5,"
				+ "concat(A.DR,'') AS dr,"
				+ "A.TS AS ts,"
				+ "C.auths FROM CLOUD_FILE A "
				+ "INNER JOIN cloud_user_ref_file B ON A.FILE_ID=B.FILE_ID "
				+ "LEFT JOIN (SELECT FILE_ID, GROUP_CONCAT(auth_name) AS auths,AUTH_USER_ID "
				+ "FROM CLOUD_AUTHORITY WHERE AUTH_VALUE='allow' "
				+ "AND (AUTH_USER_ID ='"+user.getId()+"' or AUTH_USER_ID='all'"
				+ "or (	'"+user.deptCode+"' LIKE CONCAT('%',AUTH_USER_ID,'%') ) ) "
				+ "GROUP BY FILE_ID,AUTH_USER_ID ) C ON A.FILE_ID=C.FILE_ID"
				+ " WHERE A.DR='N' AND B.DR='N' AND "
				+ " (CASE WHEN A.FILE_OWNER_ID='"+user.getId()+"' AND  A.FILE_ATTR = 'PUBLIC' THEN C.AUTH_USER_ID='"+user.getId()+"' ELSE 1=1 END)");
		if(filters != null) {
			String[] paramsArr = filters.split("&");
			if(paramsArr != null && paramsArr.length > 0) {
				String[] keyValueArr;
				for (String keyValue : paramsArr) {
					keyValueArr = keyValue.split("=");
					if(keyValueArr.length == 2) {
						String key = keyValueArr[0];
						String value = keyValueArr[1];
						if(StringUtils.isNotBlank(key)&&StringUtils.isNotBlank(value)) {
							if("fileName".equals(key)){
								sql.append(" AND A.FILE_NAME LIKE '%" + value.trim() + "%'  ");
							}else if("fileOwnerName".equals(key)){
								sql.append(" AND A.FILE_OWNER_NAME LIKE  '%" + value + "%' ");
							}else if("fileDate".equals(key)){
								sql.append(" AND A.FILE_DATE >= '"+value+"' ");
							}else if("fileDate".equals(key)){
								sql.append(" AND A.FILE_DATE <= '"+value+"' ");
							}else if("parentFileId".equals(key)){
								sql.append(" AND A.PARENT_FILE_ID = '"+value+"' ");
							}else if("fileType".equals(key)){
								sql.append(" AND A.FILE_TYPE = '"+value+"' ");
							}else if("fileId".equals(key)){
								sql.append(" AND A.FILE_ID = '"+value+"' ");
							}else if("fileAttr".equals(key)){
								sql.append(" AND A.FILE_ATTR = '"+value+"' ");
								if(value.equals("PRIVATE")){
									sql.append(" AND B.USER_ID='"+user.getId()+"'");
								}else if(value.equals("PUBLIC")){
									sql.append(" AND C.auths like '%onSee%'");
								}
							}
						}
					}
				}
			}
		}
		if(orFilters != null&&!"".equals(orFilters)) {
			sql.append(" AND (A.FILE_NAME LIKE '%"+orFilters+"%' OR A.FILE_OWNER_NAME LIKE '%"+orFilters+"%')");
		}
		if(StringUtils.isNotEmpty(sortName)){
			sql.append(" ORDER BY CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sql.append(" ORDER BY A.TS");
		}
		return this.getPageData(CloudFileEntity.class, pagenum, pagesize, sql.toString());
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<CloudFileEntity> findCloudFiles(ShiroUser user, String filters) {
		StringBuilder sql=new StringBuilder();
		sql.append("SELECT * FROM (SELECT "
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
				+ "A.IS_DOWNLOAD AS isDownload,"
				+ "A.IS_COVER AS isCover,"
				+ "A.MD5 AS md5,"
				+ "concat(A.DR,'') AS dr,"
				+ "A.TS AS ts FROM CLOUD_FILE A "
				+ "INNER JOIN cloud_user_ref_file B ON A.FILE_ID=B.FILE_ID "
				+ "LEFT JOIN (SELECT FILE_ID, GROUP_CONCAT(auth_name) AS auths,AUTH_USER_ID "
				+ "FROM CLOUD_AUTHORITY WHERE AUTH_VALUE='allow' "
				+ "AND (AUTH_USER_ID ='"+user.getId()+"' or AUTH_USER_ID='all'"
				+ "or (	'"+user.deptCode+"' LIKE CONCAT('%',AUTH_USER_ID,'%') ) ) "
				+ "GROUP BY FILE_ID,AUTH_USER_ID ) C ON A.FILE_ID=C.FILE_ID "
				+ "WHERE A.DR='N' AND B.DR='N' AND FILE_ATTR='PUBLIC' AND C.auths like '%onSee%'"
				+ " AND (CASE WHEN A.FILE_OWNER_ID='"+user.getId()+"' AND  A.FILE_ATTR = 'PUBLIC' THEN C.AUTH_USER_ID='"+user.getId()+"' ELSE 1=1 END) ");
		sql.append(" UNION ");
		sql.append("SELECT "
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
				+ "A.IS_DOWNLOAD AS isDownload,"
				+ "A.IS_COVER AS isCover,"
				+ "A.MD5 AS md5,"
				+ "concat(A.DR,'') AS dr,"
				+ "A.TS AS ts FROM CLOUD_FILE A "
				+ "INNER JOIN cloud_user_ref_file B ON A.FILE_ID=B.FILE_ID "
				+ "WHERE A.DR='N' AND B.DR='N' AND A.FILE_ATTR='PRIVATE' AND B.USER_ID='"+user.getId()+"') T WHERE 1=1 ");
		if(filters != null) {
			String[] paramsArr = filters.split("&");
			if(paramsArr != null && paramsArr.length > 0) {
				String[] keyValueArr;
				for (String keyValue : paramsArr) {
					keyValueArr = keyValue.split("=");
					if(keyValueArr.length == 2) {
						String key = keyValueArr[0];
						String value = keyValueArr[1];
						if(StringUtils.isNotBlank(key)&&StringUtils.isNotBlank(value)) {
							if("fileName".equals(key)){
								sql.append(" AND T.fileName LIKE '%" + value.trim() + "%'  ");
							}else if("fileOwnerName".equals(key)){
								sql.append(" AND T.fileOwnerName LIKE= '%" + value + "%' ");
							}else if("fileDate".equals(key)){
								sql.append(" AND T.fileDate >= '"+value+"' ");
							}else if("fileDate".equals(key)){
								sql.append(" AND T.fileDate <= '"+value+"' ");
							}else if("parentFileId".equals(key)){
								sql.append(" AND T.parentFileId = '"+value+"' ");
							}else if("fileType".equals(key)){
								sql.append(" AND T.fileType = '"+value+"' ");
							}else if("fileId".equals(key)){
								sql.append(" AND T.fileId = '"+value+"' ");
							}else if("fileAttr".equals(key)){
								sql.append(" AND T.fileAttr = '"+value+"' ");
							}
						}
					}
				}
			}
		}
		sql.append(" ORDER BY T.TS");
		Query query = em.createNativeQuery(sql.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(CloudFileEntity.class));
		return query.getResultList();
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<CloudFileEntity> findCloudFiles(String filters) {
		StringBuilder sql=new StringBuilder();
		sql.append("SELECT "
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
				+ "A.IS_DOWNLOAD AS isDownload,"
				+ "A.IS_COVER AS isCover,"
				+ "A.MD5 AS md5,"
				+ "concat(A.DR,'') AS dr,"
				+ "A.TS AS ts FROM CLOUD_FILE A "
				+ "INNER JOIN cloud_user_ref_file B ON A.FILE_ID=B.FILE_ID "
				+ "WHERE A.DR='N' AND B.DR='N'");
		if(filters != null) {
			String[] paramsArr = filters.split("&");
			if(paramsArr != null && paramsArr.length > 0) {
				String[] keyValueArr;
				for (String keyValue : paramsArr) {
					keyValueArr = keyValue.split("=");
					if(keyValueArr.length == 2) {
						String key = keyValueArr[0];
						String value = keyValueArr[1];
						if(StringUtils.isNotBlank(key)&&StringUtils.isNotBlank(value)) {
							if("fileName".equals(key)){
								sql.append(" AND A.FILE_NAME LIKE '%" + value.trim() + "%'  ");
							}else if("fileOwnerName".equals(key)){
								sql.append(" AND A.FILE_OWNER_NAME LIKE= '%" + value + "%' ");
							}else if("fileDate".equals(key)){
								sql.append(" AND A.FILE_DATE >= '"+value+"' ");
							}else if("fileDate".equals(key)){
								sql.append(" AND A.FILE_DATE <= '"+value+"' ");
							}else if("parentFileId".equals(key)){
								sql.append(" AND A.PARENT_FILE_ID = '"+value+"' ");
							}else if("fileType".equals(key)){
								sql.append(" AND A.FILE_TYPE = '"+value+"' ");
							}else if("fileId".equals(key)){
								sql.append(" AND A.FILE_ID = '"+value+"' ");
							}else if("fileAttr".equals(key)){
								sql.append(" AND A.FILE_ATTR = '"+value+"' ");
								/*if(key.equals("PRIVATE")){
									sql.append(" AND B.USER_ID='"+userId+"'");
								}*/
							}
						}
					}
				}
			}
		}
		sql.append(" ORDER BY A.TS");
		Query query = em.createNativeQuery(sql.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(CloudFileEntity.class));
		return query.getResultList();
	}
	@Override
	public PageResult<CloudFileEntity> findCloudFiles(int pagenum,
			int pagesize, String sortName, String sortOrder, String filters) {
		StringBuilder sql=new StringBuilder();
		sql.append("SELECT "
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
				+ "A.IS_DOWNLOAD AS isDownload,"
				+ "A.IS_COVER AS isCover,"
				+ "A.MD5 AS md5,"
				+ "concat(A.DR,'') AS dr,"
				+ "A.TS AS ts FROM CLOUD_FILE A "
				+ "INNER JOIN cloud_user_ref_file B ON A.FILE_ID=B.FILE_ID "
				+ "WHERE A.DR='N' AND B.DR='N' ");
		if(filters != null) {
			String[] paramsArr = filters.split("&");
			if(paramsArr != null && paramsArr.length > 0) {
				String[] keyValueArr;
				for (String keyValue : paramsArr) {
					keyValueArr = keyValue.split("=");
					if(keyValueArr.length == 2) {
						String key = keyValueArr[0];
						String value = keyValueArr[1];
						if(StringUtils.isNotBlank(key)&&StringUtils.isNotBlank(value)) {
							if("fileName".equals(key)){
								sql.append(" AND A.FILE_NAME LIKE '%" + value.trim() + "%'  ");
							}else if("fileOwnerName".equals(key)){
								sql.append(" AND A.FILE_OWNER_NAME LIKE= '%" + value + "%' ");
							}else if("fileDate".equals(key)){
								sql.append(" AND A.FILE_DATE >= '"+value+"' ");
							}else if("fileDate".equals(key)){
								sql.append(" AND A.FILE_DATE <= '"+value+"' ");
							}else if("parentFileId".equals(key)){
								sql.append(" AND A.PARENT_FILE_ID = '"+value+"' ");
							}else if("fileType".equals(key)){
								sql.append(" AND A.FILE_TYPE = '"+value+"' ");
							}else if("fileId".equals(key)){
								sql.append(" AND A.FILE_ID = '"+value+"' ");
							}else if("fileAttr".equals(key)){
								sql.append(" AND A.FILE_ATTR = '"+value+"' ");
								/*if(key.equals("PRIVATE")){
									sql.append(" AND B.USER_ID='"+userId+"'");
								}*/
							}
						}
					}
				}
			}
		}
		if(StringUtils.isNotEmpty(sortName)){
			sql.append(" ORDER BY CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sql.append(" ORDER BY A.TS");
		}
		return this.getPageData(CloudFileEntity.class, pagenum, pagesize, sql.toString());
	}
	@SuppressWarnings("unchecked")
	@Override
	public void setAuthority(String fileId, String userIds,String authorities) {
		String userIdStr[]=userIds.split(",");
		for(int i=0;i<userIdStr.length;i++){
			
			StringBuilder sql=new StringBuilder();
			sql.append("SELECT * FROM CLOUD_USER_REF_FILE WHERE F.FILE_ID=? AND USER_ID=? AND DR=? ");
			Query query = em.createNativeQuery(sql.toString(),CloudUserRefFileEntity.class);
			query.setParameter(1, fileId);
			query.setParameter(2, userIdStr[i]);
			query.setParameter(3, "N");
			List<CloudUserRefFileEntity> list=query.getResultList();
			if(list.size()>0){
				CloudUserRefFileEntity ref=list.get(0);
				String authId=ref.getAuthId();
				if("".equals(authId)||authId==null){
					authId=Identities.uuid2();
				}else{
					this.deleteAuthList(ref.getAuthId());
				}
				String authStr[]=authorities.split(",");
				List<CloudAuthorityEntity> authList=new ArrayList<CloudAuthorityEntity>();
				for(int j=0;j<authorities.length();j++){
					CloudAuthorityEntity auth=new CloudAuthorityEntity();
					auth.setAuthValue(authStr[j]);
					auth.setDr("N");
					auth.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
					auth.setAuthId(authId);
					authList.add(auth);
				}
				this.saveEntitys(authList);
			}
		}
		
	}
	@Override
	public void deleteAuthList(String authId) {
		StringBuilder sql=new StringBuilder();
		sql.append("DELETE FROM CLOUD_AUTHORITY WHERE AUTH_ID=? ");
		Query query = em.createNativeQuery(sql.toString());
		query.setParameter(1, authId);
		query.executeUpdate();
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<Dept> findDeptList() {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * FROM ISC_DEPT WHERE DR='N' ORDER BY SORT ASC");
		Query query = em.createNativeQuery(sb.toString(),Dept.class);
		return query.getResultList();
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<User> findUserList() {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * FROM ISC_USER WHERE DR='N' AND IS_ADMIN='N' ORDER BY SORT ASC");
		Query query = em.createNativeQuery(sb.toString(),User.class);
		return query.getResultList();
	}
	@Override
	public void setAuth(CloudAuthNode node) {
		List<CloudAuthorityEntity> authList=new ArrayList<CloudAuthorityEntity>();
		authList.add(saveAuth("onSee",node.getOnSee(), node));
		authList.add(saveAuth("beforeAdd",node.getBeforeAdd(), node));
		authList.add(saveAuth("beforeRename",node.getBeforeRename(), node));
		authList.add(saveAuth("onShowLog",node.getOnShowLog(), node));
		authList.add(saveAuth("buttonUpload",node.getButtonUpload(), node));
		authList.add(saveAuth("btnDelete",node.getBtnDelete(), node));
		authList.add(saveAuth("btnShareAuth",node.getBtnShareAuth(), node));
		authList.add(saveAuth("buttonDownload",node.getButtonDownload(), node));
		this.saveEntitys(authList);
	} 
	public CloudAuthorityEntity saveAuth(String authName,String authValue,CloudAuthNode node){
		CloudAuthorityEntity entity =new CloudAuthorityEntity();
		entity.setAuthValue(authValue);
		entity.setAuthName(authName);
		entity.setFileId(node.getFileId());
		if("dept".equals(node.getType())){
			entity.setAuthUserId(getDeptCode(node.getId()));
		}else{
			entity.setAuthUserId(node.getId());
		}
		entity.setAuthType(node.getType());
		entity.setAuthUserName(node.getName());
		entity.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		entity.setDr("N");
		entity.setSort(getAuthMaxSort());
		return entity;
	}
	@SuppressWarnings("unchecked")
	private String getDeptCode(String deptId){
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT DEPT_CODE FROM ISC_DEPT WHERE DR='N' AND DEPT_ID='"+deptId+"'"
				+ " UNION "
				+ "SELECT ORG_CODE FROM ISC_ORG WHERE DR='N' AND ORG_ID='"+deptId+"'");
		Query query = em.createNativeQuery(sb.toString());
		List<String> list=query.getResultList();
		if(list.size()>0){
			String code=list.get(0);
			return code;
		}
		return "";
	}
	@SuppressWarnings("unchecked")
	public String getAuthMaxSort(){
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT CASE WHEN SORT IS NULL THEN 0 ELSE MAX(SORT)+1 END FROM CLOUD_AUTHORITY");
		Query query = em.createNativeQuery(sb.toString());
		List<Double> list=query.getResultList();
		if(list.size()>0){
			Double code=list.get(0);
			return code.intValue()+"";
		}
		return "";
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<CloudAuthNodes> findAuths(String fileId, String userId) {
		StringBuffer sb = new StringBuffer();
		sb.append("select auth_id as authId,"
				+ "file_id as fileId,"
				+ "AUTH_TYPE as authType,"
				+ "AUTH_USER_ID as authUserId,"
				+ "AUTH_USER_NAME as authUserName,"
				+ "GROUP_CONCAT(AUTH_NAME,\"\\:\\'\",AUTH_VALUE,\"\\'\") as nodes"
				+ " from cloud_authority WHERE DR=? AND FILE_ID=? group by file_id,AUTH_USER_ID order by sort");
		Query query = em.createNativeQuery(sb.toString());
		query.unwrap(SQLQuery.class).setResultTransformer(
				Transformers.aliasToBean(CloudAuthNodes.class));
		query.setParameter(1, "N");
		query.setParameter(2, fileId);
		return query.getResultList();
	}
	@Override
	public void deleteAuthBeforeSave(String fileId) {
		StringBuilder sql=new StringBuilder();
		sql.append("DELETE FROM CLOUD_AUTHORITY WHERE FILE_ID=? ");
		Query query = em.createNativeQuery(sql.toString());
		query.setParameter(1, fileId);
		query.executeUpdate();
	}
	/* (non-Javadoc)
	 * @see com.yonyou.aco.cloudydisk.dao.ICloudDiskDao#beforeAddFolder(java.lang.String, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<CloudFileEntity> beforeAddFolder(String folderName,
			String parentFolderId) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * FROM CLOUD_FILE WHERE FILE_NAME='"+folderName+"' AND PARENT_FILE_ID='"+parentFolderId+"' AND DR='N'");
		Query query = em.createNativeQuery(sb.toString(),CloudFileEntity.class);
		return query.getResultList();
	}
}
