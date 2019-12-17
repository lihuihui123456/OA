package com.yonyou.aco.docquery.entity;

import java.io.Serializable;
import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonProperty;

public class SearchBean implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@JsonProperty("ID_") 
	private String ID_;
	
	@JsonProperty("BIZ_TITLE_") 
	private String BIZ_TITLE_;
	
	@JsonProperty("BIZ_TYPE_") 
	private String BIZ_TYPE_;
	
	@JsonProperty("CREATE_USER_ID_") 
	private String CREATE_USER_ID_;
	
	@JsonProperty("CREATE_TIME_") 
	private Timestamp CREATE_TIME_;
	
	@JsonProperty("STATE_") 
	private String STATE_;
	
	@JsonProperty("ARCHIVE_STATE_") 
	private String ARCHIVE_STATE_;
	
	@JsonProperty("URGENCY_") 
	private String URGENCY_;
	
	@JsonProperty("CREATE_DEPT_ID_")
	private String CREATE_DEPT_ID_;
	
	@JsonProperty("SERIAL_NUMBER_")
	private String SERIAL_NUMBER_;
	
	@JsonProperty("USER_NAME")
	private String USER_NAME;
	
	@JsonProperty("DEPT_NAME")
	private String DEPT_NAME;
	
	@JsonProperty("ORG_NAME")
	private String ORG_NAME;
	
	private String solId;
	
	/**
	 * 办理人
	 */
	@JsonProperty("ASSIGNEE_")
	private String ASSIGNEE_;

	public String getID_() {
		return ID_;
	}

	public void setID_(String iD_) {
		ID_ = iD_;
	}

	public String getBIZ_TITLE_() {
		return BIZ_TITLE_;
	}

	public void setBIZ_TITLE_(String bIZ_TITLE_) {
		BIZ_TITLE_ = bIZ_TITLE_;
	}

	public String getBIZ_TYPE_() {
		return BIZ_TYPE_;
	}

	public void setBIZ_TYPE_(String bIZ_TYPE_) {
		BIZ_TYPE_ = bIZ_TYPE_;
	}

	public String getCREATE_USER_ID_() {
		return CREATE_USER_ID_;
	}

	public void setCREATE_USER_ID_(String cREATE_USER_ID_) {
		CREATE_USER_ID_ = cREATE_USER_ID_;
	}

	public Timestamp getCREATE_TIME_() {
		return CREATE_TIME_;
	}

	public void setCREATE_TIME_(Timestamp cREATE_TIME_) {
		CREATE_TIME_ = cREATE_TIME_;
	}

	public String getSTATE_() {
		return STATE_;
	}

	public void setSTATE_(String sTATE_) {
		STATE_ = sTATE_;
	}

	public String getARCHIVE_STATE_() {
		return ARCHIVE_STATE_;
	}

	public void setARCHIVE_STATE_(String aRCHIVE_STATE_) {
		ARCHIVE_STATE_ = aRCHIVE_STATE_;
	}

	public String getURGENCY_() {
		return URGENCY_;
	}

	public void setURGENCY_(String uRGENCY_) {
		URGENCY_ = uRGENCY_;
	}

	public String getCREATE_DEPT_ID_() {
		return CREATE_DEPT_ID_;
	}

	public void setCREATE_DEPT_ID_(String cREATE_DEPT_ID_) {
		CREATE_DEPT_ID_ = cREATE_DEPT_ID_;
	}

	public String getSERIAL_NUMBER_() {
		return SERIAL_NUMBER_;
	}

	public void setSERIAL_NUMBER_(String sERIAL_NUMBER_) {
		SERIAL_NUMBER_ = sERIAL_NUMBER_;
	}

	public String getUSER_NAME() {
		return USER_NAME;
	}

	public void setUSER_NAME(String uSER_NAME) {
		USER_NAME = uSER_NAME;
	}

	public String getDEPT_NAME() {
		return DEPT_NAME;
	}

	public void setDEPT_NAME(String dEPT_NAME) {
		DEPT_NAME = dEPT_NAME;
	}

	public String getORG_NAME() {
		return ORG_NAME;
	}

	public void setORG_NAME(String oRG_NAME) {
		ORG_NAME = oRG_NAME;
	}

	public String getSolId() {
		return solId;
	}

	public void setSolId(String solId) {
		this.solId = solId;
	}
}
