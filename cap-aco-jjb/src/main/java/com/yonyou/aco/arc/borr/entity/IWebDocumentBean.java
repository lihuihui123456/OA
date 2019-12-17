package com.yonyou.aco.arc.borr.entity;

import java.io.Serializable;

public class IWebDocumentBean implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String id;
	private String fileName;
	private String arcId;
	private String arcName;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getArcId() {
		return arcId;
	}
	public void setArcId(String arcId) {
		this.arcId = arcId;
	}
	public String getArcName() {
		return arcName;
	}
	public void setArcName(String arcName) {
		this.arcName = arcName;
	}
}