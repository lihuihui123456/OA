package com.yonyou.aco.earc.earcquery.entity;

import java.io.Serializable;

public class EarcQuery implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String BIZ_TITLE_;
	private String CREATE_USER_ID_;
	private String draftUserIdName_;
	private String EARC_TYPE;
	private String SECURITY_LEVEL;
	private String EARC_STATE;
	private String advStartDate;
	private String advEndDate;
	public String getBIZ_TITLE_() {
		return BIZ_TITLE_;
	}
	public void setBIZ_TITLE_(String bIZ_TITLE_) {
		BIZ_TITLE_ = bIZ_TITLE_;
	}
	public String getCREATE_USER_ID_() {
		return CREATE_USER_ID_;
	}
	public void setCREATE_USER_ID_(String cREATE_USER_ID_) {
		CREATE_USER_ID_ = cREATE_USER_ID_;
	}
	public String getDraftUserIdName_() {
		return draftUserIdName_;
	}
	public void setDraftUserIdName_(String draftUserIdName_) {
		this.draftUserIdName_ = draftUserIdName_;
	}
	public String getEARC_TYPE() {
		return EARC_TYPE;
	}
	public void setEARC_TYPE(String eARC_TYPE) {
		EARC_TYPE = eARC_TYPE;
	}
	public String getSECURITY_LEVEL() {
		return SECURITY_LEVEL;
	}
	public void setSECURITY_LEVEL(String sECURITY_LEVEL) {
		SECURITY_LEVEL = sECURITY_LEVEL;
	}
	public String getEARC_STATE() {
		return EARC_STATE;
	}
	public void setEARC_STATE(String eARC_STATE) {
		EARC_STATE = eARC_STATE;
	}
	public String getAdvStartDate() {
		return advStartDate;
	}
	public void setAdvStartDate(String advStartDate) {
		this.advStartDate = advStartDate;
	}
	public String getAdvEndDate() {
		return advEndDate;
	}
	public void setAdvEndDate(String advEndDate) {
		this.advEndDate = advEndDate;
	}
	
}
