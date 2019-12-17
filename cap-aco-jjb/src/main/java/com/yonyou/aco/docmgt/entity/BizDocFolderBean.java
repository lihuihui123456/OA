package com.yonyou.aco.docmgt.entity;

import java.io.Serializable;
import java.util.Date;

import com.yonyou.cap.common.util.IdEntity;

public class BizDocFolderBean extends IdEntity implements Serializable{
	private static final long serialVersionUID = 1L;
	private String id_;
	/** 目录ID*/
	private String catalogId;
	/** 目录名称*/
	private String catalogName;
	/** 目录类型*/
	private int catalogType;
	/** 父目录ID*/
	private String parentCatalogId;
	/** 用户ID*/
	private String userId;
	/** 排序号*/
	private int sortId;
	/** 是否删除*/
	private int deleteFlag;
	/** 创建时间*/
	private Date createTime;
	public String getId_() {
		return id_;
	}
	public void setId_(String id_) {
		this.id_ = id_;
	}
	public String getCatalogId() {
		return catalogId;
	}
	public void setCatalogId(String catalogId) {
		this.catalogId = catalogId;
	}
	public String getCatalogName() {
		return catalogName;
	}
	public void setCatalogName(String catalogName) {
		this.catalogName = catalogName;
	}
	public int getCatalogType() {
		return catalogType;
	}
	public void setCatalogType(int catalogType) {
		this.catalogType = catalogType;
	}
	public String getParentCatalogId() {
		return parentCatalogId;
	}
	public void setParentCatalogId(String parentCatalogId) {
		this.parentCatalogId = parentCatalogId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getSortId() {
		return sortId;
	}
	public void setSortId(int sortId) {
		this.sortId = sortId;
	}
	public int getDeleteFlag() {
		return deleteFlag;
	}
	public void setDeleteFlag(int deleteFlag) {
		this.deleteFlag = deleteFlag;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	
}
