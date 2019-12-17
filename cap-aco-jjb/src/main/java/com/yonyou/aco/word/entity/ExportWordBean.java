package com.yonyou.aco.word.entity;

import java.util.Date;

/**
 * 
 * ClassName: ExportWordBean
 * 
 * @Description: 导出Word表单虚拟实体类
 * @author hegd
 * @date 2016-8-24
 */
public class ExportWordBean {

	/** 表单标题 **/
	private String bizTitle;
	/** 流程实例Id **/
	private String procInstId;
	/** 表单缓急程度 **/
	private String ungency;
	/** 表单密级 **/
	private String securityLevel;
	/** 表单主送单位 **/
	private String mainSend;
	/** 表单拟稿部门 **/
	private String draftDeptIdName;
	/** 表单拟稿时间**/
	private Date draftTime;
	/** 表单拟稿人 **/
	private String draftUserIdName;
	/** 表单核稿人 **/
	private String checkUserIdName;
	/** 表单流水号 **/
	private String serialNumber;
	/** 审核意见 **/
	private String idea;

	public String getBizTitle() {
		return bizTitle;
	}

	public void setBizTitle(String bizTitle) {
		this.bizTitle = bizTitle;
	}

	public String getProcInstId() {
		return procInstId;
	}

	public void setProcInstId(String procInstId) {
		this.procInstId = procInstId;
	}

	public String getUngency() {
		return ungency;
	}

	public void setUngency(String ungency) {
		this.ungency = ungency;
	}

	public String getSecurityLevel() {
		return securityLevel;
	}

	public void setSecurityLevel(String securityLevel) {
		this.securityLevel = securityLevel;
	}

	public String getMainSend() {
		return mainSend;
	}

	public void setMainSend(String mainSend) {
		this.mainSend = mainSend;
	}

	public String getDraftDeptIdName() {
		return draftDeptIdName;
	}

	public void setDraftDeptIdName(String draftDeptIdName) {
		this.draftDeptIdName = draftDeptIdName;
	}

	public Date getDraftTime() {
		return draftTime;
	}

	public void setDraftTime(Date draftTime) {
		this.draftTime = draftTime;
	}

	public String getDraftUserIdName() {
		return draftUserIdName;
	}

	public void setDraftUserIdName(String draftUserIdName) {
		this.draftUserIdName = draftUserIdName;
	}

	public String getCheckUserIdName() {
		return checkUserIdName;
	}

	public void setCheckUserIdName(String checkUserIdName) {
		this.checkUserIdName = checkUserIdName;
	}

	public String getSerialNumber() {
		return serialNumber;
	}

	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}

	public String getIdea() {
		return idea;
	}

	public void setIdea(String idea) {
		this.idea = idea;
	}

}
