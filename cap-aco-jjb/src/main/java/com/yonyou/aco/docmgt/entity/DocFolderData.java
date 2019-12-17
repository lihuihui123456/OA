package com.yonyou.aco.docmgt.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

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
@Table(name = "biz_doc_info")
public class DocFolderData extends IdEntity implements Serializable {

	private static final long serialVersionUID = 1L;

	private String folderId;//所属文件夹id
	private String title; //标题
	private String fileType;  //文件类型
	private String remark;  //备注
	private String sort;  //排序号
	private String ts;  //时间
	
	public String getFolderId() {
		return folderId;
	}
	public void setFolderId(String folderId) {
		this.folderId = folderId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getSort() {
		return sort;
	}
	public void setSort(String sort) {
		this.sort = sort;
	}
	public String getTs() {
		return ts;
	}
	public void setTs(String ts) {
		this.ts = ts;
	}
}