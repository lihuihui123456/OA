package com.yonyou.aco.cloudydisk.dao;

import java.util.List;

import com.yonyou.aco.cloudydisk.entity.CloudAuthNode;
import com.yonyou.aco.cloudydisk.entity.CloudAuthNodes;
import com.yonyou.aco.cloudydisk.entity.CloudFileEntity;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;

/**
 * <p>概述：业务模块办公云盘Dao层
 * <p>功能：1.个人办公云存储 2.共享
 * <p>作者：葛鹏
 * <p>创建时间：2017年3月10日
 * <p>类调用特殊情况：无
 */
public interface ICloudDiskDao extends IBaseDao{

	
	/**
	 * 分页查询文件信息
	 * @param userId
	 * @param pagenum
	 * @param pagesize
	 * @param sortName
	 * @param sortOrder
	 * @return
	 */
	public PageResult<CloudFileEntity> findCloudFileByUser(ShiroUser user,int pagenum, int pagesize,String sortName,String sortOrder,String filters,String orFilters);
	
	/**
	 * @param userId
	 * @param filters
	 * @return
	 */
	public List<CloudFileEntity> findCloudFiles(ShiroUser user,String filters);
	
	/**
	 * @param filters
	 * @return
	 */
	public List<CloudFileEntity> findCloudFiles(String filters);
	/**
	 * @param filters
	 * @return
	 */
	public PageResult<CloudFileEntity> findCloudFiles(int pagenum, int pagesize,String sortName,String sortOrder,String filters);
	
	
	/**
	 * @param fileId
	 * @param userIds
	 * @param authorities
	 */
	public void setAuthority(String fileId,String userIds,String authorities);
	
	/**
	 * @param authId
	 */
	public void deleteAuthList(String authId);
	
	/**
	 * 查询机构
	 * @return
	 */
	public List<Dept> findDeptList();
	
	/**
	 * 查询用户
	 * @return
	 */
	public List<User> findUserList();
	
	/**
	 * @param node
	 */
	public void setAuth(CloudAuthNode node);
	
	public List<CloudAuthNodes> findAuths(String fileId,String userId);
	
	public String getAuthMaxSort();
	
	public void deleteAuthBeforeSave(String fileId);
	
	public List<CloudFileEntity> beforeAddFolder(String folderName,String parentFolderId );
}
