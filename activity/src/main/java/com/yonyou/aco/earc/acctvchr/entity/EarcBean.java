package com.yonyou.aco.earc.acctvchr.entity;

import com.fasterxml.jackson.annotation.JsonProperty;

public class EarcBean {

	/**
	 * 主键ID
	 */
	@JsonProperty("ID_")  
	private String ID_;
	
	/**
	 * 业务解决ID
	 */
	@JsonProperty("SOL_ID_") 
	private String SOL_ID_;
	
	/**
	 * 标题
	 */
	@JsonProperty("BIZ_TITLE_")  
	private String BIZ_TITLE_;
	/**
	 * 责任人
	 */
	@JsonProperty("CREATE_USER_ID_")  
	private String CREATE_USER_ID_;
	/**
	 * 期限
	 */
	@JsonProperty("TERM")  
	private String TERM;
	/**
	 * 密级
	 */
	@JsonProperty("SECURITY_LEVEL")  
	private String SECURITY_LEVEL;
	/**
	 * 归档日期
	 */
	@JsonProperty("OPER_TIME")  
	private String OPER_TIME;
	
	/**
	 * 档案状态
	 */
	@JsonProperty("EARC_STATE")  
	private String EARC_STATE;

	public String getID_() {
		return ID_;
	}

	public void setID_(String iD_) {
		ID_ = iD_;
	}

	public String getSOL_ID_() {
		return SOL_ID_;
	}

	public void setSOL_ID_(String sOL_ID_) {
		SOL_ID_ = sOL_ID_;
	}

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

	public String getTERM() {
		return TERM;
	}

	public void setTERM(String tERM) {
		TERM = tERM;
	}

	public String getSECURITY_LEVEL() {
		return SECURITY_LEVEL;
	}

	public void setSECURITY_LEVEL(String sECURITY_LEVEL) {
		SECURITY_LEVEL = sECURITY_LEVEL;
	}

	public String getOPER_TIME() {
		return OPER_TIME;
	}

	public void setOPER_TIME(String oPER_TIME) {
		OPER_TIME = oPER_TIME;
	}

	public String getEARC_STATE() {
		return EARC_STATE;
	}

	public void setEARC_STATE(String eARC_STATE) {
		EARC_STATE = eARC_STATE;
	}


}
