package com.yonyou.aco.docmgt.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Table;
import com.yonyou.cap.common.util.IdEntity;
/**
 * 
 * 
 * 归档管理-归档类型目录表
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2017-02-13
 * @author  申浩
 */
@Entity
@Table(name = "biz_doc_info_type")
public class BizDocInfoTypeEntity extends IdEntity implements Serializable{
	private static final long serialVersionUID = -8651942831796199086L;
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
	private String dr;
	/** 时间戳*/
	private String ts;
	/** 创建时间*/
	private String createTime;
	private String count;
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
	
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getDr() {
		return dr;
	}
	public void setDr(String dr) {
		this.dr = dr;
	}
	public String getTs() {
		return ts;
	}
	public void setTs(String ts) {
		this.ts = ts;
	}
	public String getCount() {
		return count;
	}
	public void setCount(String count) {
		this.count = count;
	}
	
}
