package com.yonyou.aco.cloudydisk.entity;

import java.io.Serializable;

public class CloudAuthNode implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -4885721437577224182L;

	private String id;
	
	private String name;
	
	private String type;
	
	private String fileId;
	
	private String onSee;
	
	private String beforeAdd;
	
	private String beforeRename;
	
	private String onShowLog;
	
	private String buttonUpload;
	
	private String btnDelete;
	
	private String btnShareAuth;
	
	private String buttonDownload;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getFileId() {
		return fileId;
	}

	public void setFileId(String fileId) {
		this.fileId = fileId;
	}

	public String getOnSee() {
		return onSee;
	}

	public void setOnSee(String onSee) {
		this.onSee = onSee;
	}

	public String getBeforeAdd() {
		return beforeAdd;
	}

	public void setBeforeAdd(String beforeAdd) {
		this.beforeAdd = beforeAdd;
	}

	public String getBeforeRename() {
		return beforeRename;
	}

	public void setBeforeRename(String beforeRename) {
		this.beforeRename = beforeRename;
	}

	public String getOnShowLog() {
		return onShowLog;
	}

	public void setOnShowLog(String onShowLog) {
		this.onShowLog = onShowLog;
	}

	public String getButtonUpload() {
		return buttonUpload;
	}

	public void setButtonUpload(String buttonUpload) {
		this.buttonUpload = buttonUpload;
	}

	public String getBtnDelete() {
		return btnDelete;
	}

	public void setBtnDelete(String btnDelete) {
		this.btnDelete = btnDelete;
	}

	public String getBtnShareAuth() {
		return btnShareAuth;
	}

	public void setBtnShareAuth(String btnShareAuth) {
		this.btnShareAuth = btnShareAuth;
	}

	public String getButtonDownload() {
		return buttonDownload;
	}

	public void setButtonDownload(String buttonDownload) {
		this.buttonDownload = buttonDownload;
	}
	
	
}
