package com.yonyou.aco.biz.entity;


public class BizNodeFormBean {
	
	private String solId;//模型Id
	private String scope_;//作用域
	private String formName;//业务表单名称
	private String formUrl;//业务表单URL
	private String formid;//自由表单Id
	private String isProcess_;//是否有流程
	private String isMainBody;//是否有正文
	private String isAttachment;//是否有附件
	private String isEarc;//是否有档案信息
	private String bizCode;//业务代码
	private String tableName;//业务表单对应的表名称
	private String procdefId;//流程定义Id
	private String sfwDictCode_;//收发文类别
	public String getProcdefId() {
		return procdefId;
	}

	public void setProcdefId(String procdefId) {
		this.procdefId = procdefId;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public String getBizCode() {
		return bizCode;
	}

	public void setBizCode(String bizCode) {
		this.bizCode = bizCode;
	}

	public String getIsMainBody() {
		return isMainBody;
	}

	public void setIsMainBody(String isMainBody) {
		this.isMainBody = isMainBody;
	}

	public String getIsAttachment() {
		return isAttachment;
	}

	public void setIsAttachment(String isAttachment) {
		this.isAttachment = isAttachment;
	}
	
	public String getFormName() {
		return formName;
	}

	public void setFormName(String formName) {
		this.formName = formName;
	}

	public String getFormUrl() {
		return formUrl;
	}

	public void setFormUrl(String formUrl) {
		this.formUrl = formUrl;
	}

	public String getSolId() {
		return solId;
	}
	
	public void setSolId(String solId) {
		this.solId = solId;
	}
	
	public String getScope_() {
		return scope_;
	}
	
	public void setScope_(String scope_) {
		this.scope_ = scope_;
	}
	
	public String getIsProcess_() {
		return isProcess_;
	}
	
	public void setIsProcess_(String isProcess_) {
		this.isProcess_ = isProcess_;
	}

	public String getFormid() {
		return formid;
	}

	public void setFormid(String formid) {
		this.formid = formid;
	}

	public String getIsEarc() {
		return isEarc;
	}

	public void setIsEarc(String isEarc) {
		this.isEarc = isEarc;
	}

	public String getSfwDictCode_() {
		return sfwDictCode_;
	}

	public void setSfwDictCode_(String sfwDictCode_) {
		this.sfwDictCode_ = sfwDictCode_;
	}
	
}
