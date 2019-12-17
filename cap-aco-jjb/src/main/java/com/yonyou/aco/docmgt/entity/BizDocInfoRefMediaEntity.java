package com.yonyou.aco.docmgt.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.fasterxml.jackson.annotation.JsonIgnore;
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
@Entity
@Table(name = "biz_doc_info_ref_media")
public class BizDocInfoRefMediaEntity extends IdEntity implements Serializable {

	private static final long serialVersionUID = 1L;
	private String relationId;
	private String uploadUserId;
	private Date uploadTime;
	private int deleteflag;
	private String folderId;
	private int share;
	private String fileId;
	private String shareUserId;
	
	public String getShareUserId() {
		return shareUserId;
	}
	public void setShareUserId(String shareUserId) {
		this.shareUserId = shareUserId;
	}
	public int getDeleteflag() {
		return deleteflag;
	}
	public void setDeleteflag(int deleteflag) {
		this.deleteflag = deleteflag;
	}
	public int getShare() {
		return share;
	}
	public void setShare(int share) {
		this.share = share;
	}

	public String getFileId() {
		return fileId;
	}
	public void setFileId(String fileId) {
		this.fileId = fileId;
	}
	public String getFolderId() {
		return folderId;
	}
	public void setFolderId(String folderId) {
		this.folderId = folderId;
	}
	@Transient
	@JsonIgnore
	private String fileName;//总数
	
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
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
	public Date getUploadTime() {
		return uploadTime;
	}
	public void setUploadTime(Date uploadTime) {
		this.uploadTime = uploadTime;
	}
	
}