package com.yonyou.aco.cloudydisk.service;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartFile;

import com.yonyou.aco.cloudydisk.entity.CloudAuthNode;
import com.yonyou.aco.cloudydisk.entity.CloudAuthNodes;
import com.yonyou.aco.cloudydisk.entity.CloudFileEntity;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;





/**
 * <p>概述：业务模块办公云盘Service层
 * <p>功能：1.个人办公云存储 2.共享
 * <p>作者：葛鹏
 * <p>创建时间：2017年3月10日
 * <p>类调用特殊情况：无
 */
public interface ICloudDiskService {
	
	/**
	 * 查询公共云盘
	 * @param userId
	 * @return
	 */
	public StringBuilder findCloudFolder(ShiroUser user);
	
	/**
	 * 新增文件夹
	 * @param folderName
	 * @param parentFolderId
	 * @param folderType
	 * @param userId
	 * @return
	 */
	public CloudFileEntity addFolder(String folderName,String parentFolderId,String folderType,String fileAttr,ShiroUser user,String authorityUserId);
	
	/**
	 * @param fileId
	 * @param userId
	 */
	public void delFile(String fileId,String userId);
	/**
	 * @param folderId
	 * @return
	 */
	/**
	 * @param folderId
	 * @return
	 */
	public List<CloudFileEntity> findByFileId(String fileId);
	/**
	 * @param fileId
	 * @return
	 */
	public boolean beforeDelFolder(String fileId);
	/**
	 * @param file
	 * @param request
	 * @param response
	 * @param user
	 */
	public void uploadFile(MultipartFile file, HttpServletRequest request,
			HttpServletResponse response,ShiroUser user)throws IOException;
	
	public void uploadFile(HttpServletRequest request,ShiroUser user,String path,long size,String recordId);
	
	/**
	 * @param folderId
	 * @param folderName
	 */
	public void rename(String userId,String folderId,String folderName);
	/**
	 * 下载文件
	 * @param request
	 * @param response
	 */
	public void downloadFile(HttpServletRequest request,HttpServletResponse response,String userId) throws Exception;
	
	
	public File getDownloadFile(HttpServletRequest request,HttpServletResponse response,String userId,String fileId,String folderId,String tempFolder)throws Exception;
	/**
	 * 分页查询文件信息
	 * @param userId
	 * @param pagenum
	 * @param pagesize
	 * @param sortName
	 * @param sortOrder
	 * @return
	 */
	public PageResult<CloudFileEntity> findCloudFileByUser(ShiroUser user ,int pagenum, int pagesize,String sortName,String sortOrder,String filters,String orFilters);
	
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
	 * @param fileId
	 * @param userIds
	 * @param authorities
	 */
	public void setAuthority(String fileId,String userIds,String authorities);
	
	public void setAuth(CloudAuthNode node);
	
	public List<CloudAuthNodes> findAuths(String fileId,String userId);
	public void deleteAuthBeforeSave(String fileId);
	
	public List<CloudFileEntity> beforeAddFolder(String folderName,String parentFolderId );
	
	public CloudFileEntity findFileById(String fileId);
}
