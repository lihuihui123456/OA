package com.yonyou.aco.arc.doc.entity;

import com.fasterxml.jackson.annotation.JsonProperty;


/**
 * <p>概述：档案文书
 * <p>功能：档案文书
 * <p>作者：王
 * <p>创建时间：2017-3-20
 * <p>类调用特殊情况：无
 */
public class DocTableBean {

	@JsonProperty("ID")
	private String ID;
	
	@JsonProperty("ARC_ID")
	private String ARC_ID;
	
	/** 登记日期  **/
	@JsonProperty("REG_TIME")
	private String REG_TIME;
	
	/** 档案名称  **/
	@JsonProperty("ARC_NAME")
	private String ARC_NAME;
	
	/** 来文单位  **/
	@JsonProperty("DOC_CO")
	private String DOC_CO;
	
	/** 文号**/
	@JsonProperty("DOC_NBR")
	private String DOC_NBR;
	
	/** 登记人  **/
	@JsonProperty("REG_USER")
	private String REG_USER;
	
	/** 档案状态  **/
	@JsonProperty("FILE_START")
	private String FILE_START;
	
	/** 作废状态  **/
	@JsonProperty("IS_INVALID")
	private String IS_INVALID;
	
	/** 存放位置  **/
	@JsonProperty("DEP_POS")
	private String DEP_POS;

	public String getID() {
		return ID;
	}

	public void setID(String iD) {
		ID = iD;
	}

	public String getARC_NAME() {
		return ARC_NAME;
	}

	public void setARC_NAME(String aRC_NAME) {
		ARC_NAME = aRC_NAME;
	}

	public String getREG_TIME() {
		return REG_TIME;
	}

	public void setREG_TIME(String rEG_TIME) {
		REG_TIME = rEG_TIME;
	}

	public String getDOC_CO() {
		return DOC_CO;
	}

	public void setDOC_CO(String dOC_CO) {
		DOC_CO = dOC_CO;
	}

	public String getDOC_NBR() {
		return DOC_NBR;
	}

	public void setDOC_NBR(String dOC_NBR) {
		DOC_NBR = dOC_NBR;
	}

	public String getREG_USER() {
		return REG_USER;
	}

	public void setREG_USER(String rEG_USER) {
		REG_USER = rEG_USER;
	}

	public String getFILE_START() {
		return FILE_START;
	}

	public void setFILE_START(String fILE_START) {
		FILE_START = fILE_START;
	}

	public String getDEP_POS() {
		return DEP_POS;
	}

	public void setDEP_POS(String dEP_POS) {
		DEP_POS = dEP_POS;
	}
}
