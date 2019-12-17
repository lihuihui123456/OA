package com.yonyou.aco.leaddesktop.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 领导自定义菜单表
 * @Date 2016-12-6
 * @author 葛鹏
 *
 */
@Entity
@Table(name = "leaddkt_menu")
public class LeadDktpMenuEntity extends IdEntity implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * 节点ID
	 */
	private String modId;
	
	/**
	 * 节点名称
	 */
	private String modName;
	
	/**
	 * 节点Url
	 */
	private String modUrl;
	
	/**
	 * 节点图标
	 */
	private String modIcon;
	
	/**
	 * 排序
	 */
	private int sort;
	
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

	public int getSort() {
		return sort;
	}

	public void setSort(int sort) {
		this.sort = sort;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	
	
}
