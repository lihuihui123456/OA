package com.yonyou.aco.cloudydisk.entity;

import java.io.Serializable;


public class CloudAuthNodes implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5000652409320813117L;
	private String authId;
	private String authUserId;
	private String authUserName;
	private String authType;
	private String fileId;
	private String nodes;
	
	public String getAuthId() {
		return authId;
	}
	public void setAuthId(String authId) {
		this.authId = authId;
	}
	public String getAuthUserId() {
		return authUserId;
	}
	public void setAuthUserId(String authUserId) {
		this.authUserId = authUserId;
	}
	public String getAuthUserName() {
		return authUserName;
	}
	public void setAuthUserName(String authUserName) {
		this.authUserName = authUserName;
	}
	public String getAuthType() {
		return authType;
	}
	public void setAuthType(String authType) {
		this.authType = authType;
	}
	public String getFileId() {
		return fileId;
	}
	public void setFileId(String fileId) {
		this.fileId = fileId;
	}
	public String getNodes() {
		return nodes;
	}
	public void setNodes(String nodes) {
		this.nodes = nodes;
	}
	

}
