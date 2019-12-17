package com.yonyou.aco.signature.entity;

import java.io.Serializable;

public class BizSignatureBean implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String id_;

	private String bizId_;

	private String fieldName_;

	private String fieldHeader_;

	private byte[] fieldValue_;

	private String userId_;

	private String dateTime_;

	private String taskId_;

	private String procInstId_;

	private String fieldValue;
	
	private String userName_;

	public String getId_() {
		return id_;
	}

	public void setId_(String id_) {
		this.id_ = id_;
	}

	public String getBizId_() {
		return bizId_;
	}

	public void setBizId_(String bizId_) {
		this.bizId_ = bizId_;
	}

	public String getFieldHeader_() {
		return fieldHeader_;
	}

	public void setFieldHeader_(String fieldHeader_) {
		this.fieldHeader_ = fieldHeader_;
	}

	public String getFieldName_() {
		return fieldName_;
	}

	public void setFieldName_(String fieldName_) {
		this.fieldName_ = fieldName_;
	}

	public byte[] getFieldValue_() {
		return fieldValue_;
	}

	public void setFieldValue_(byte[] fieldValue_) {
		this.fieldValue_ = fieldValue_;
	}

	public String getUserId_() {
		return userId_;
	}

	public void setUserId_(String userId_) {
		this.userId_ = userId_;
	}

	public String getDateTime_() {
		return dateTime_;
	}

	public void setDateTime_(String dateTime_) {
		this.dateTime_ = dateTime_;
	}

	public String getTaskId_() {
		return taskId_;
	}

	public void setTaskId_(String taskId_) {
		this.taskId_ = taskId_;
	}

	public String getProcInstId_() {
		return procInstId_;
	}

	public void setProcInstId_(String procInstId_) {
		this.procInstId_ = procInstId_;
	}

	public String getFieldValue() {
		return fieldValue;
	}

	public void setFieldValue(String fieldValue) {
		this.fieldValue = fieldValue;
	}

	public String getUserName_() {
		return userName_;
	}

	public void setUserName_(String userName_) {
		this.userName_ = userName_;
	}

}
