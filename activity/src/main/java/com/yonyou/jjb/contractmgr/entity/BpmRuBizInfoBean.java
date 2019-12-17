package com.yonyou.jjb.contractmgr.entity;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * 名称: 基本业务信息表  (分页排序). 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 
 * @author 
 * @since 1.0.0
 */
public class BpmRuBizInfoBean implements Serializable {

	private static final long serialVersionUID = 8013553855634227455L;

	@JsonProperty("ID_")
	private String ID_;
	
	@JsonProperty("SOL_ID_")
	private String SOL_ID_;
	
	private String bizid;
	
	/** 标题 **/
	@JsonProperty("BIZ_TITLE_")
	private String BIZ_TITLE_;
	/** 项目名称**/
	@JsonProperty("xmmc")
	private String xmmc;
	@JsonProperty("TABLE_NAME_")
	private String TABLE_NAME_;
	
	@JsonProperty("KEY_")
	private String KEY_;
	
	@JsonProperty("PRO_DEF_ID_")
	private String PRO_DEF_ID_;
	
	@JsonProperty("PROC_INST_ID_")
	private String PROC_INST_ID_;
	
	@JsonProperty("TASK_ID")
	private String TASK_ID;
	
	@JsonProperty("SERIAL_NUMBER_")
	private String SERIAL_NUMBER_;
	
	@JsonProperty("ARCHIVE_ID_")
	private String ARCHIVE_ID_;
	
	@JsonProperty("ARCHIVE_STATE_")
	private String ARCHIVE_STATE_ = "0";
	
	@JsonProperty("CREATE_USER_ID_")
	private String CREATE_USER_ID_;
	
	@JsonProperty("CREATE_DEPT_ID_")
	private String CREATE_DEPT_ID_;
	
	@JsonProperty("UPDATE_TIME_")
	private String UPDATE_TIME_;
	
	@JsonProperty("TS_")
	private String TS_;
	
	@JsonProperty("DR_")
	private String DR_;
	
	@JsonProperty("REMARK_")
	private String REMARK_;
	
	@JsonProperty("TENANT_ID")
	private String TENANT_ID;
	
	@JsonProperty("BIZ_TYPE_")
	private String BIZ_TYPE_;
	
	@JsonProperty("SEND_STATE_")
	private String SEND_STATE_;
	
	@JsonProperty("TIME_LIMIT_")
	private String TIME_LIMIT_;
	
	@JsonProperty("BIZ_DOC_NUM")
	private String BIZ_DOC_NUM;
	
	@JsonProperty("DATA_USER_ID")
	private String DATA_USER_ID;
	
	@JsonProperty("DATA_DEPT_CODE")
	private String DATA_DEPT_CODE;
	
	@JsonProperty("DATA_ORG_ID")
	private String DATA_ORG_ID;
	
	@JsonProperty("DATA_TENANT_ID")
	private String DATA_TENANT_ID;
	
	@JsonProperty("USER_NAME")
	private String USER_NAME;

	/** 紧急程度 **/
	@JsonProperty("URGENCY_")
	private String URGENCY_;
	
	/** 办理状态 **/
	@JsonProperty("STATE_")
	private String STATE_;
	
	/** 拟稿时间 **/
	@JsonProperty("CREATE_TIME_")
	private String CREATE_TIME_;
	
	/** 时间 **/
	@JsonProperty("START_TIME_")
	private String START_TIME_;
	
	/** 时间 **/
	@JsonProperty("END_TIME_")
	private String END_TIME_;
	
	/** 归档时间 **/
	@JsonProperty("PLACE_TIME")
	private String PLACE_TIME;

	public String getBIZ_TITLE_() {
		return BIZ_TITLE_;
	}

	public void setBIZ_TITLE_(String bIZ_TITLE_) {
		BIZ_TITLE_ = bIZ_TITLE_;
	}

	public String getURGENCY_() {
		return URGENCY_;
	}

	public void setURGENCY_(String uRGENCY_) {
		URGENCY_ = uRGENCY_;
	}

	public String getSTATE_() {
		return STATE_;
	}

	public void setSTATE_(String sTATE_) {
		STATE_ = sTATE_;
	}

	public String getCREATE_TIME_() {
		return CREATE_TIME_;
	}

	public void setCREATE_TIME_(String cREATE_TIME_) {
		CREATE_TIME_ = cREATE_TIME_;
	}

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

	public String getTABLE_NAME_() {
		return TABLE_NAME_;
	}
	

	public String getBizid() {
		return bizid;
	}

	public void setBizid(String bizid) {
		this.bizid = bizid;
	}

	public void setTABLE_NAME_(String tABLE_NAME_) {
		TABLE_NAME_ = tABLE_NAME_;
	}

	public String getKEY_() {
		return KEY_;
	}

	public void setKEY_(String kEY_) {
		KEY_ = kEY_;
	}

	public String getPRO_DEF_ID_() {
		return PRO_DEF_ID_;
	}

	public void setPRO_DEF_ID_(String pRO_DEF_ID_) {
		PRO_DEF_ID_ = pRO_DEF_ID_;
	}

	public String getPROC_INST_ID_() {
		return PROC_INST_ID_;
	}

	public void setPROC_INST_ID_(String pROC_INST_ID_) {
		PROC_INST_ID_ = pROC_INST_ID_;
	}

	public String getTASK_ID() {
		return TASK_ID;
	}

	public void setTASK_ID(String tASK_ID) {
		TASK_ID = tASK_ID;
	}

	public String getSERIAL_NUMBER_() {
		return SERIAL_NUMBER_;
	}

	public void setSERIAL_NUMBER_(String sERIAL_NUMBER_) {
		SERIAL_NUMBER_ = sERIAL_NUMBER_;
	}

	public String getARCHIVE_ID_() {
		return ARCHIVE_ID_;
	}

	public void setARCHIVE_ID_(String aRCHIVE_ID_) {
		ARCHIVE_ID_ = aRCHIVE_ID_;
	}

	public String getARCHIVE_STATE_() {
		return ARCHIVE_STATE_;
	}

	public void setARCHIVE_STATE_(String aRCHIVE_STATE_) {
		ARCHIVE_STATE_ = aRCHIVE_STATE_;
	}

	public String getCREATE_USER_ID_() {
		return CREATE_USER_ID_;
	}

	public void setCREATE_USER_ID_(String cREATE_USER_ID_) {
		CREATE_USER_ID_ = cREATE_USER_ID_;
	}

	public String getCREATE_DEPT_ID_() {
		return CREATE_DEPT_ID_;
	}

	public void setCREATE_DEPT_ID_(String cREATE_DEPT_ID_) {
		CREATE_DEPT_ID_ = cREATE_DEPT_ID_;
	}

	public String getUPDATE_TIME_() {
		return UPDATE_TIME_;
	}

	public void setUPDATE_TIME_(String uPDATE_TIME_) {
		UPDATE_TIME_ = uPDATE_TIME_;
	}

	public String getTS_() {
		return TS_;
	}

	public void setTS_(String tS_) {
		TS_ = tS_;
	}

	public String getDR_() {
		return DR_;
	}

	public void setDR_(String dR_) {
		DR_ = dR_;
	}

	public String getREMARK_() {
		return REMARK_;
	}

	public void setREMARK_(String rEMARK_) {
		REMARK_ = rEMARK_;
	}

	public String getTENANT_ID() {
		return TENANT_ID;
	}

	public void setTENANT_ID(String tENANT_ID) {
		TENANT_ID = tENANT_ID;
	}

	public String getBIZ_TYPE_() {
		return BIZ_TYPE_;
	}

	public void setBIZ_TYPE_(String bIZ_TYPE_) {
		BIZ_TYPE_ = bIZ_TYPE_;
	}

	public String getSEND_STATE_() {
		return SEND_STATE_;
	}

	public void setSEND_STATE_(String sEND_STATE_) {
		SEND_STATE_ = sEND_STATE_;
	}

	public String getTIME_LIMIT_() {
		return TIME_LIMIT_;
	}

	public void setTIME_LIMIT_(String tIME_LIMIT_) {
		TIME_LIMIT_ = tIME_LIMIT_;
	}

	public String getBIZ_DOC_NUM() {
		return BIZ_DOC_NUM;
	}

	public void setBIZ_DOC_NUM(String bIZ_DOC_NUM) {
		BIZ_DOC_NUM = bIZ_DOC_NUM;
	}

	public String getDATA_USER_ID() {
		return DATA_USER_ID;
	}

	public void setDATA_USER_ID(String dATA_USER_ID) {
		DATA_USER_ID = dATA_USER_ID;
	}

	public String getDATA_DEPT_CODE() {
		return DATA_DEPT_CODE;
	}

	public void setDATA_DEPT_CODE(String dATA_DEPT_CODE) {
		DATA_DEPT_CODE = dATA_DEPT_CODE;
	}

	public String getDATA_ORG_ID() {
		return DATA_ORG_ID;
	}

	public void setDATA_ORG_ID(String dATA_ORG_ID) {
		DATA_ORG_ID = dATA_ORG_ID;
	}

	public String getDATA_TENANT_ID() {
		return DATA_TENANT_ID;
	}

	public void setDATA_TENANT_ID(String dATA_TENANT_ID) {
		DATA_TENANT_ID = dATA_TENANT_ID;
	}

	public String getUSER_NAME() {
		return USER_NAME;
	}

	public void setUSER_NAME(String uSER_NAME) {
		USER_NAME = uSER_NAME;
	}

	public String getSTART_TIME_() {
		return START_TIME_;
	}

	public void setSTART_TIME_(String sTART_TIME_) {
		START_TIME_ = sTART_TIME_;
	}

	public String getEND_TIME_() {
		return END_TIME_;
	}

	public void setEND_TIME_(String eND_TIME_) {
		END_TIME_ = eND_TIME_;
	}

	public String getPLACE_TIME() {
		return PLACE_TIME;
	}

	public void setPLACE_TIME(String pLACE_TIME) {
		PLACE_TIME = pLACE_TIME;
	}

	public String getXmmc() {
		return xmmc;
	}

	public void setXmmc(String xmmc) {
		this.xmmc = xmmc;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	

	
}
