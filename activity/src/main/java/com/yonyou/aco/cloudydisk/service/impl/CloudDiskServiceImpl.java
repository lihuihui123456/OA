package com.yonyou.aco.cloudydisk.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springside.modules.utils.PropertiesLoader;

import com.yonyou.aco.cloudydisk.dao.ICloudDiskDao;
import com.yonyou.aco.cloudydisk.dao.ICloudShareDao;
import com.yonyou.aco.cloudydisk.entity.CloudAuthNode;
import com.yonyou.aco.cloudydisk.entity.CloudAuthNodes;
import com.yonyou.aco.cloudydisk.entity.CloudAuthorityEntity;
import com.yonyou.aco.cloudydisk.entity.CloudFileEntity;
import com.yonyou.aco.cloudydisk.entity.CloudUserRefFileEntity;
import com.yonyou.aco.cloudydisk.service.ICloudDiskService;
import com.yonyou.aco.cloudydisk.service.ICloudLogService;
import com.yonyou.aco.cloudydisk.util.ZipUtils;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;

@Service("ICloudDiskService")
public class CloudDiskServiceImpl implements ICloudDiskService{
	@Resource
	ICloudDiskDao dao;
	@Resource
	ICloudShareDao shareDao;
	@Resource
	ICloudLogService log;
	private static final String PUBLIC="公共云盘";
	private static final String PRIVATE="个人云盘";
	private static final String SHARE="他人分享";
	private static final String MY_SHARE="我的分享";
//	private static final String SHARE_SEND="已分享";
//	private static final String SHARE_FLAG="s";//分享标识
	@Override
	public StringBuilder findCloudFolder(ShiroUser user) {
		StringBuilder sb=new StringBuilder();
		sb.append("{id:'PUBLIC',name:'").append(PUBLIC).append("',pId:'',open:'true',editable:'2',filetype:'sys',fileattr:'PUBLIC',iconSkin:'cloud'}");
		sb.append(",{id:'PRIVATE',name:'").append(PRIVATE).append("',pId:'',open:'true',editable:'2',filetype:'sys',fileattr:'PRIVATE',iconSkin:'folder-o'}");
		sb.append(",{id:'SHARE',name:'").append(SHARE).append("',pId:'PRIVATE',open:'false',editable:'2',filetype:'othershare',fileattr:'SHARE',iconSkin:'folder'}");
		sb.append(",{id:'MY_SHARE',name:'").append(MY_SHARE).append("',pId:'PRIVATE',open:'false',editable:'2',filetype:'shareother',fileattr:'MY_SHARE',iconSkin:'folder'}");
		List<CloudFileEntity> privateList=dao.findCloudFiles(user, "fileType=folder");
		for(int i=0;i<privateList.size();i++){
			CloudFileEntity bean=privateList.get(i);
			sb.append(",{id:'").append(bean.getFileId()).append("'");
			sb.append(",name:'").append(bean.getFileName()).append("'");
			sb.append(",pId:'").append(bean.getParentFileId()).append("'");
			sb.append(",filetype:'").append(bean.getFileType()).append("'");
			sb.append(",fileattr:'").append(bean.getFileAttr()).append("'");
			sb.append(",iconSkin:'").append("folder-o").append("'");
			sb.append(",editable:'").append(bean.getIsDownload()).append("'}");
		}
		return sb;
	}
	@Override
	public CloudFileEntity addFolder(String folderName,String parentFolderId,String fileType,String fileAttr,ShiroUser user,String authorityUserId) {
		CloudFileEntity fileEntity=new CloudFileEntity();
		String recordId = DateUtil.getCurDate("yyMMddHHmmssS") + new Random().nextInt(9);
		fileEntity.setFileName(folderName);
		fileEntity.setRecordId(recordId);
		fileEntity.setFileType("folder");
		fileEntity.setFilePath("");
		fileEntity.setFileAttr(fileAttr);
		fileEntity.setFileOwnerId(user.getId());
		fileEntity.setFileOwnerName(user.getName());
		fileEntity.setFileDate(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		fileEntity.setFileCount(0);
		fileEntity.setFileSize(0);
		fileEntity.setIsDownload("");
		fileEntity.setIsCover("");
		fileEntity.setMd5("");
		fileEntity.setDr("N");
		fileEntity.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		fileEntity.setParentFileId(parentFolderId);
		dao.save(fileEntity);
		CloudUserRefFileEntity ref=new CloudUserRefFileEntity();
		ref.setFileId(fileEntity.getFileId());
		ref.setUserId(user.getId());
		ref.setDr("N");
		ref.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		ref.setAuthId(null);
		dao.save(ref);
		if("PUBLIC".equals(fileAttr)){
			String[] authNames={"onSee","beforeAdd","beforeRename","onShowLog","buttonUpload","btnDelete","btnShareAuth"};
			List<CloudAuthorityEntity> authList=new ArrayList<CloudAuthorityEntity>();
			for(int i=0;i<authNames.length;i++){
				CloudAuthorityEntity authEntity=new CloudAuthorityEntity();
				authEntity.setAuthName(authNames[i]);
				authEntity.setAuthValue("allow");
				authEntity.setAuthUserId(user.getUserId());
				authEntity.setAuthUserName(user.getName());
				authEntity.setFileId(fileEntity.getFileId());
				authEntity.setAuthType("user");
				authEntity.setDr("N");
				authEntity.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
				authEntity.setSort(dao.getAuthMaxSort());
				authList.add(authEntity);
			}
			dao.saveEntitys(authList);
		}
		log.saveFolderLog(parentFolderId, user.getId(),"创建文件夹【"+fileEntity.getFileName()+"】",DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		return fileEntity;
	}
	@Override
	public void delFile(String fileId, String userId) {
		CloudFileEntity file=dao.findEntityByPK(CloudFileEntity.class, fileId);
		file.setDr("Y");
		dao.update(file);
		log.saveFolderLog(file.getParentFileId(), userId,"删除文件【"+file.getFileName()+"】",DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
	}
	@Override
	public boolean beforeDelFolder(String fileId) {
		boolean flag=true;
		List<CloudFileEntity> list=dao.findCloudFiles("parentFileId="+fileId);
		if(list.size()>0){
			flag=false;
		}
		return flag;
	}
	@Override
	public void uploadFile(MultipartFile file, HttpServletRequest request,
			HttpServletResponse response,ShiroUser user) throws IOException {
		
		
		// 获取服务器保存的文件名
		String recordId = DateUtil.getCurDate("yyMMddHHmmssS") + new Random().nextInt(9);
		String filePath = new PropertiesLoader("config.properties").getProperty("rootPath");
		filePath += ("/" + DateUtil.getCurDate("yy") + "/" + DateUtil.getCurDate("MM") + "/"
				+ DateUtil.getCurDate("dd"));
		// 文件名称
		File file2 = new File(filePath, recordId);
		if (!file2.exists()) {
			file2.mkdirs();
		}
		// 保存文件
		try {
			file.transferTo(file2);
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		CloudFileEntity fileEntity=new CloudFileEntity();
		fileEntity.setFileName(file.getOriginalFilename());
		fileEntity.setRecordId(recordId);
		String fileType="other";
		if(file.getOriginalFilename().indexOf(".")!=-1){
			fileType=file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".")+1);
		}
		fileEntity.setFileType(fileType);
		fileEntity.setFilePath(filePath);
		fileEntity.setFileOwnerId(user.getId());
		fileEntity.setFileOwnerName(user.getName());
		fileEntity.setFileDate(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		fileEntity.setFileCount(0);
		fileEntity.setFileSize(file.getSize());
		fileEntity.setIsDownload(request.getParameter("isDownload"));
		fileEntity.setIsCover(request.getParameter("isCover"));
		fileEntity.setFileAttr(request.getParameter("fileAttr"));
		fileEntity.setMd5(DigestUtils.md5Hex(new FileInputStream(file2)));
		fileEntity.setDr("N");
		fileEntity.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		fileEntity.setParentFileId(request.getParameter("folderId"));
		dao.save(fileEntity);
		CloudUserRefFileEntity ref=new CloudUserRefFileEntity();
		ref.setFileId(fileEntity.getFileId());
		ref.setUserId(user.getId());
		ref.setDr("N");
		ref.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		dao.save(ref);
		if("PUBLIC".equals(request.getParameter("fileAttr"))){
			String[] authNames={"onSee","beforeRename","onShowLog","buttonUpload","btnDelete","btnShareAuth","buttonDownload"};
			List<CloudAuthorityEntity> authList=new ArrayList<CloudAuthorityEntity>();
			for(int i=0;i<authNames.length;i++){
				CloudAuthorityEntity authEntity=new CloudAuthorityEntity();
				authEntity.setAuthName(authNames[i]);
				authEntity.setAuthValue("allow");
				authEntity.setAuthUserId(user.getUserId());
				authEntity.setAuthUserName(user.getName());
				authEntity.setFileId(fileEntity.getFileId());
				authEntity.setDr("N");
				authEntity.setAuthType("user");
				authEntity.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
				authEntity.setSort(dao.getAuthMaxSort());
				authList.add(authEntity);
			}
			dao.saveEntitys(authList);
		}
		log.saveFolderLog(request.getParameter("folderId"), user.getId(),"上传文件【"+fileEntity.getFileName()+"】",DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		log.saveFolderLog(fileEntity.getFileId(), user.getId(),"上传文件【"+fileEntity.getFileName()+"】",DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
	}
	@Override
	public void rename(String userId,String folderId, String folderName) {
		CloudFileEntity file=dao.findEntityByPK(CloudFileEntity.class, folderId);
		log.saveFolderLog(file.getParentFileId(), userId,"重命名文件夹【"+file.getFileName()+"】为【"+folderName+"】",DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		log.saveFolderLog(file.getFileId(), userId,"重命名文件夹【"+file.getFileName()+"】为【"+folderName+"】",DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		file.setFileName(folderName);
		dao.update(file);
	}
	@Override
	public void downloadFile(HttpServletRequest request,
			HttpServletResponse response,String userId) throws Exception {
		String fileId=request.getParameter("fileId");
		String folderId=request.getParameter("folderId");
		CloudFileEntity fileEntity=dao.findEntityByPK(CloudFileEntity.class, fileId);
		if (fileEntity != null) {
			fileEntity.setFileCount(fileEntity.getFileCount()+1);
			dao.update(fileEntity);
			// 获得下载文件信息
//			String fileName = URLEncoder.encode(fileEntity.getFileName(), "UTF-8");
			String downLoadName = null;
			String agent = request.getHeader("USER-AGENT");
			if(StringUtils.contains(agent, "Chrome") || StringUtils.contains(agent, "Firefox")){	//google,火狐浏览器  
				downLoadName =  new String((fileEntity.getFileName()).getBytes("UTF-8"), "ISO8859-1");
			}else{
				downLoadName = URLEncoder.encode(fileEntity.getFileName(),"UTF8");	//其他浏览器
			}
			String path = fileEntity.getFilePath() + "/" + fileEntity.getRecordId();
			OutputStream o = response.getOutputStream();
			byte b[] = new byte[1024];
			// 开始下载文件
			File fileLoad = new File(path);
			response.setContentType("text/html");
			response.setHeader("Content-Disposition", "attachment;filename=" + downLoadName);
			long fileLength = fileLoad.length();
			String length = String.valueOf(fileLength);
			response.setHeader("Content_Length", length);
			// 下载文件
			FileInputStream in = new FileInputStream(fileLoad);
			int n = 0;
			while ((n = in.read(b)) != -1) {
				o.write(b, 0, n);
			}
			in.close();
			o.close();
			if(folderId!=null&&!"".equals(folderId)){
				log.saveFolderLog(folderId, userId,"下载文件【"+fileEntity.getFileName()+"】",DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
			}
			log.saveFolderLog(fileId, userId,"下载文件【"+fileEntity.getFileName()+"】",DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		}
	}
	@Override
	public List<CloudFileEntity> findByFileId(String fileId) {
		List<CloudFileEntity> list=new ArrayList<CloudFileEntity>();
		CloudFileEntity fileEntity=dao.findEntityByPK(CloudFileEntity.class, fileId);
		list.add(fileEntity);
		return list;
	}
	@Override
	public PageResult<CloudFileEntity> findCloudFileByUser(ShiroUser user,
			int pagenum, int pagesize, String sortName, String sortOrder,String filters,String orFilters) {
		return dao.findCloudFileByUser(user, pagenum, pagesize, sortName, sortOrder,filters,orFilters);
	}
	@Override
	public List<CloudFileEntity> findCloudFiles(String filters) {
		return dao.findCloudFiles(filters);
	}
	@Override
	public PageResult<CloudFileEntity> findCloudFiles(int pagenum,
			int pagesize, String sortName, String sortOrder, String filters) {
		return dao.findCloudFiles(pagenum, pagesize, sortName, sortOrder, filters);
	}
	@Override
	public List<Dept> findDeptList() {
		return dao.findDeptList();
	}
	@Override
	public List<User> findUserList() {
		return dao.findUserList();
	}
	@Override
	public void setAuthority(String fileId, String userIds, String authorities) {
		dao.setAuthority(fileId, userIds, authorities);
	}
	@Override
	public void setAuth(CloudAuthNode node) {
		dao.setAuth(node);
	}
	@Override
	public List<CloudAuthNodes> findAuths(String fileId, String userId) {
		return dao.findAuths(fileId, userId);
	}
	@Override
	public void deleteAuthBeforeSave(String fileId) {
		dao.deleteAuthBeforeSave(fileId);
	}
	@Override
	public List<CloudFileEntity> beforeAddFolder(String folderName,
			String parentFolderId) {
		
		return dao.beforeAddFolder(folderName, parentFolderId);
	}
	@Override
	public File getDownloadFile(HttpServletRequest request, HttpServletResponse response, String userId, String fileId,
			String folderId,String tempFolder) throws Exception {
		CloudFileEntity fileEntity=dao.findEntityByPK(CloudFileEntity.class, fileId);
		if (fileEntity != null) {
			fileEntity.setFileCount(fileEntity.getFileCount()+1);
			dao.update(fileEntity);
			String path = fileEntity.getFilePath() + "/" + fileEntity.getRecordId();
			String tempPath=fileEntity.getFilePath()+"/"+tempFolder;
			File fileTempPath=new File(tempPath);
			if(!fileTempPath.exists()){
				fileTempPath.mkdirs();
			}
			File dest=new File(tempPath+"/"+fileEntity.getFileName());
			ZipUtils.copyFile(path,tempPath+"/"+fileEntity.getFileName(),true);
			if(folderId!=null&&!"".equals(folderId)){
				log.saveFolderLog(folderId, userId,"下载文件【"+fileEntity.getFileName()+"】",DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
			}
			log.saveFolderLog(fileId, userId,"下载文件【"+fileEntity.getFileName()+"】",DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
			if(dest.exists()){
				return dest;
			}
		}
		return null;
		
	}
	@Override
	public void uploadFile(HttpServletRequest request, ShiroUser user,String path,long size,String recordId) {
		CloudFileEntity fileEntity=new CloudFileEntity();
		String fileName=request.getParameter("fileName");
		
		fileEntity.setFileName(fileName);
		fileEntity.setRecordId(recordId);
		String fileType="other";
		if(fileName.indexOf(".")!=-1){
			fileType=fileName.substring(fileName.lastIndexOf(".")+1);
		}
		fileEntity.setFileType(fileType);
		fileEntity.setFilePath(path);
		fileEntity.setFileOwnerId(user.getId());
		fileEntity.setFileOwnerName(user.getName());
		fileEntity.setFileDate(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		fileEntity.setFileCount(0);
		fileEntity.setFileSize(size);
		fileEntity.setIsDownload(request.getParameter("isDownload"));
		fileEntity.setIsCover(request.getParameter("isCover"));
		fileEntity.setFileAttr(request.getParameter("fileAttr"));
//		fileEntity.setMd5(DigestUtils.md5Hex(new FileInputStream(file2)));
		fileEntity.setDr("N");
		fileEntity.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		fileEntity.setParentFileId(request.getParameter("folderId"));
		dao.save(fileEntity);
		CloudUserRefFileEntity ref=new CloudUserRefFileEntity();
		ref.setFileId(fileEntity.getFileId());
		ref.setUserId(user.getId());
		ref.setDr("N");
		ref.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		dao.save(ref);
		if("PUBLIC".equals(request.getParameter("fileAttr"))){
			String[] authNames={"onSee","beforeRename","onShowLog","buttonUpload","btnDelete","btnShareAuth","buttonDownload"};
			List<CloudAuthorityEntity> authList=new ArrayList<CloudAuthorityEntity>();
			for(int i=0;i<authNames.length;i++){
				CloudAuthorityEntity authEntity=new CloudAuthorityEntity();
				authEntity.setAuthName(authNames[i]);
				authEntity.setAuthValue("allow");
				authEntity.setAuthUserId(user.getUserId());
				authEntity.setAuthUserName(user.getName());
				authEntity.setFileId(fileEntity.getFileId());
				authEntity.setDr("N");
				authEntity.setAuthType("user");
				authEntity.setTs(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
				authEntity.setSort(dao.getAuthMaxSort());
				authList.add(authEntity);
			}
			dao.saveEntitys(authList);
		}
		log.saveFolderLog(request.getParameter("folderId"), user.getId(),"上传文件【"+fileEntity.getFileName()+"】",DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		log.saveFolderLog(fileEntity.getFileId(), user.getId(),"上传文件【"+fileEntity.getFileName()+"】",DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
		
	}
	@Override
	public CloudFileEntity findFileById(String fileId) {
		return dao.findEntityByPK(CloudFileEntity.class, fileId);
	}
}
