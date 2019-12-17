package com.yonyou.aco.docmgt.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 
 * 文档管理-个人文件夹 目录表
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016-11-02
 * @author  yh
 * @since   2.0.0
 * modified by gp
 */
@Entity
@Table(name = "biz_doc_folder")
public class BizDocFolderEntity extends IdEntity implements Serializable {

	private static final long serialVersionUID = 1L;
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