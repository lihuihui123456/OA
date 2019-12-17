package com.yonyou.aco.docmgt.entity;

import java.util.Date;
import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.yonyou.cap.common.util.IdEntity;

/**
 * @author gp
 * @date 2016-11-1
 * 共享文件夹:人员与附件关联表
 */
@Entity
@Table(name = "biz_doc_relationship")
public class BizDocRelationshipEntity extends IdEntity implements Serializable{
	private static final long serialVersionUID = 1L;
	private String folderId;
	private String userId;
	private String mediaId;
	private Date createTime;
	public String getFolderId() {
		return folderId;
	}
	public void setFolderId(String folderId) {
		this.folderId = folderId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getMediaId() {
		return mediaId;
	}
	public void setMediaId(String mediaId) {
		this.mediaId = mediaId;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	
}
