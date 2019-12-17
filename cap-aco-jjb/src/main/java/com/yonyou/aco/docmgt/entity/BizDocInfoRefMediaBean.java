package com.yonyou.aco.docmgt.entity;

import java.io.Serializable;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 
 * 文档管理-个人文件夹数据基础信息类
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016-6-20
 * @author  yh
 * @since   1.0.0
 */
public class BizDocInfoRefMediaBean extends IdEntity implements Serializable {

	private static final long serialVersionUID = 1L;
	private String id_;
	private String relationId;
	private String uploadUserId;
	private String uploadTime;
	private int deleteFlag;
	private String fileId;
	private String fileName;
	private String folderId;
	private int share;
	/** 正文id **/
	private String document_id_;
	/** 附件id **/
	private String attach_id_;
	/** 附件地址 **/
	private String attach_path_;
	/** 附件名称 **/
	private String attach_name_;
	private String filePath;
	private String fileType;
	/**共享时间*/
	private String shareTime;
	
	private String shareUserId;
	
	private String uploadUserName;
	
	private String shareUserName;
	private String isNowUser;
	
	public String getUploadUserName() {
		return uploadUserName;
	}
	public void setUploadUserName(String uploadUserName) {
		this.uploadUserName = uploadUserName;
	}
	public String getShareUserName() {
		return shareUserName;
	}
	public void setShareUserName(String shareUserName) {
		this.shareUserName = shareUserName;
	}
	public String getShareUserId() {
		return shareUserId;
	}
	public void setShareUserId(String shareUserId) {
		this.shareUserId = shareUserId;
	}
	public String getShareTime() {
		return shareTime;
	}
	public void setShareTime(String shareTime) {
		this.shareTime = shareTime;
	}
	public String getUploadTime() {
		return uploadTime;
	}
	public void setUploadTime(String uploadTime) {
		this.uploadTime = uploadTime;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getFolderId() {
		return folderId;
	}
	public void setFolderId(String folderId) {
		this.folderId = folderId;
	}
	public String getFileId() {
		return fileId;
	}
	public void setFileId(String fileId) {
		this.fileId = fileId;
	}
	public String getId_() {
		return id_;
	}
	public void setId_(String id_) {
		this.id_ = id_;
	}
	public String getRelationId() {
		return relationId;
	}
	public void setRelationId(String relationId) {
		this.relationId = relationId;
	}
	public String getUploadUserId() {
		return uploadUserId;
	}
	public void setUploadUserId(String uploadUserId) {
		this.uploadUserId = uploadUserId;
	}
	public int getDeleteFlag() {
		return deleteFlag;
	}
	public void setDeleteFlag(int deleteFlag) {
		this.deleteFlag = deleteFlag;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public int getShare() {
		return share;
	}
	public void setShare(int share) {
		this.share = share;
	}
	public String getDocument_id_() {
		return document_id_;
	}
	public void setDocument_id_(String document_id_) {
		this.document_id_ = document_id_;
	}
	public String getAttach_id_() {
		return attach_id_;
	}
	public void setAttach_id_(String attach_id_) {
		this.attach_id_ = attach_id_;
	}
	public String getAttach_path_() {
		return attach_path_;
	}
	public void setAttach_path_(String attach_path_) {
		this.attach_path_ = attach_path_;
	}
	public String getAttach_name_() {
		return attach_name_;
	}
	public void setAttach_name_(String attach_name_) {
		this.attach_name_ = attach_name_;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getIsNowUser() {
		return isNowUser;
	}
	public void setIsNowUser(String isNowUser) {
		this.isNowUser = isNowUser;
	}



	
}