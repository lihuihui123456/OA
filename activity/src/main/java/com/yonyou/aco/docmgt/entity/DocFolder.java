package com.yonyou.aco.docmgt.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.yonyou.cap.common.util.IdEntity;

/**
 * 
 * 文档管理-个人文件夹基础信息类
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016-6-20
 * @author  yh
 * @since   1.0.0
 */
@Entity
@Table(name = "biz_doc_folder")
public class DocFolder extends IdEntity implements Serializable {

	private static final long serialVersionUID = 1L;

	private String folderName;//文件夹名称
	private String parentId; //父节点id
	private String folderType; //文件夹类型
	private String remark;  //备注
	private String sort;  //排序号
	private String ts;  //时间
	
	public String getFolderName() {
		return folderName;
	}
	public void setFolderName(String folderName) {
		this.folderName = folderName;
	}
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
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
	public String getFolderType() {
		return folderType;
	}
	public void setFolderType(String folderType) {
		this.folderType = folderType;
	}
}