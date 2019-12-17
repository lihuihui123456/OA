package com.yonyou.aco.leaddesktop.entity;

import java.io.Serializable;

import com.yonyou.cap.common.util.IdEntity;

public class LeadDktpMenuBean extends IdEntity implements Serializable,Comparable<LeadDktpMenuBean>{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/** 模块ID */
	private String modId;
	/** 模块名称 */
	private String modName;
	/** 模块编码 */
	private String modCode;
	/** 模块URL */
	private String modUrl;
	/** 模块图标 */
	private String modIcon;
	/** 父模块ID */
	private String parentModId;
	/** 是否虚拟节点 Y是 N否 */
	private char isVrtlNode;
	/** 是否根节点 Y是 N否 */
	private String isRoot;
	/** 排序号 */
	private Integer sort;
	/** 是否勾选 */
	private String isChecked;
	
	private String userId;
	
	public String getModId() {
		return modId;
	}
	public void setModId(String modId) {
		this.modId = modId;
	}
	public String getModName() {
		return modName;
	}
	public void setModName(String modName) {
		this.modName = modName;
	}
	public String getModCode() {
		return modCode;
	}
	public void setModCode(String modCode) {
		this.modCode = modCode;
	}
	public String getModUrl() {
		return modUrl;
	}
	public void setModUrl(String modUrl) {
		this.modUrl = modUrl;
	}
	public String getModIcon() {
		return modIcon;
	}
	public void setModIcon(String modIcon) {
		this.modIcon = modIcon;
	}
	public String getParentModId() {
		return parentModId;
	}
	public void setParentModId(String parentModId) {
		this.parentModId = parentModId;
	}
	public char getIsVrtlNode() {
		return isVrtlNode;
	}
	public void setIsVrtlNode(char isVrtlNode) {
		this.isVrtlNode = isVrtlNode;
	}
	public String getIsRoot() {
		return isRoot;
	}
	public void setIsRoot(String isRoot) {
		this.isRoot = isRoot;
	}
	public Integer getSort() {
		return sort;
	}
	public void setSort(Integer sort) {
		this.sort = sort;
	}
	
	public String getIsChecked() {
		return isChecked;
	}
	public void setIsChecked(String isChecked) {
		this.isChecked = isChecked;
	}
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	@Override
	public int compareTo(LeadDktpMenuBean o) {
		return getSort().compareTo(o.getSort());
	}
}
