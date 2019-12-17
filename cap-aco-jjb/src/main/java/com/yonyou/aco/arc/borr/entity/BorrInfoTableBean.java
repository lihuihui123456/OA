package com.yonyou.aco.arc.borr.entity;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

public class BorrInfoTableBean implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	//biz_arc_borr_info
	@JsonProperty("ID")
	private String ID;
	
	@JsonProperty("BOR_NBR")
	private String BOR_NBR;
	
	@JsonProperty("NBR_TIME")
	private String NBR_TIME;
	
	@JsonProperty("BORR_USER")
	private String BORR_USER;//借阅人ID
	
	@JsonProperty("BORR_MOBILE")
	private String BORR_MOBILE;
	
	@JsonProperty("BORR_TIME") 
	private String BORR_TIME;
	
	@JsonProperty("BORR_DEPT") 
	private String BORR_DEPT;//借阅部门
	
	@JsonProperty("ARC_ID") 
	private String ARC_ID;
	
	@JsonProperty("ARC_NAME")  
	private String ARC_NAME;//文件标题
	
	@JsonProperty("BORR_TYPE")
	private String BORR_TYPE;
	
	@JsonProperty("BORR_SHR")
	private String BORR_SHR;
	
	@JsonProperty("IS_RET")
	private String IS_RET;
	
	@JsonProperty("PLAN_TIME")
	private String PLAN_TIME;//计划归还日期
	
	@JsonProperty("ACTL_TIME")
	private String ACTL_TIME;//实际归还日期
	
	@JsonProperty("CRE_USER")
	private String CRE_USER;//
	
	@JsonProperty("CRE_TIMR")
	private String CRE_TIMR;
	
	@JsonProperty("REMARKS")
	private String REMARKS;
	
	@JsonProperty("DATA_ORG_ID")
	private String DATA_ORG_ID;
	
	@JsonProperty("DATA_DEPT_CODE")
	private String DATA_DEPT_CODE;//登记部门
	
	@JsonProperty("DATA_USER_ID")
	private String DATA_USER_ID;//办理人ID
	
	@JsonProperty("TENANT_ID")
	private String TENANT_ID;
	
	@JsonProperty("TS")
	private String TS;
	
	@JsonProperty("DR")
	private String DR;
	
	@JsonProperty("ATT_ID")
	private String ATT_ID;
	
	@JsonProperty("LEADER_OPINION")
	private String LEADER_OPINION;
	
	@JsonProperty("ARC_TYPE")
	private String ARC_TYPE;//档案类型ID
	
	@JsonProperty("IS_BACK")
	private String IS_BACK;//是否归还
	
	@JsonProperty("jiyuebumen")
	private String jiyuebumen;//借阅部门
	
	@JsonProperty("dengjibumen")
	private String dengjibumen;//登记部门
	
	@JsonProperty("blr")
	private String blr;//办理人
	
	@JsonProperty("jiyueren")
	private String jiyueren;//借阅人
	
	@JsonProperty("TYPE_NAME")
	private String TYPE_NAME;//档案名称

	public String getID() {
		return ID;
	}

	public void setID(String iD) {
		ID = iD;
	}

	public String getBOR_NBR() {
		return BOR_NBR;
	}

	public void setBOR_NBR(String bOR_NBR) {
		BOR_NBR = bOR_NBR;
	}

	public String getNBR_TIME() {
		return NBR_TIME;
	}

	public void setNBR_TIME(String nBR_TIME) {
		NBR_TIME = nBR_TIME;
	}

	public String getBORR_USER() {
		return BORR_USER;
	}

	public void setBORR_USER(String bORR_USER) {
		BORR_USER = bORR_USER;
	}

	public String getBORR_MOBILE() {
		return BORR_MOBILE;
	}

	public void setBORR_MOBILE(String bORR_MOBILE) {
		BORR_MOBILE = bORR_MOBILE;
	}

	public String getBORR_TIME() {
		return BORR_TIME;
	}

	public void setBORR_TIME(String bORR_TIME) {
		BORR_TIME = bORR_TIME;
	}

	public String getBORR_DEPT() {
		return BORR_DEPT;
	}

	public void setBORR_DEPT(String bORR_DEPT) {
		BORR_DEPT = bORR_DEPT;
	}

	public String getARC_ID() {
		return ARC_ID;
	}

	public void setARC_ID(String aRC_ID) {
		ARC_ID = aRC_ID;
	}

	public String getARC_NAME() {
		return ARC_NAME;
	}

	public void setARC_NAME(String aRC_NAME) {
		ARC_NAME = aRC_NAME;
	}

	public String getBORR_TYPE() {
		return BORR_TYPE;
	}

	public void setBORR_TYPE(String bORR_TYPE) {
		BORR_TYPE = bORR_TYPE;
	}

	public String getBORR_SHR() {
		return BORR_SHR;
	}

	public void setBORR_SHR(String bORR_SHR) {
		BORR_SHR = bORR_SHR;
	}

	public String getIS_RET() {
		return IS_RET;
	}

	public void setIS_RET(String iS_RET) {
		IS_RET = iS_RET;
	}

	public String getPLAN_TIME() {
		return PLAN_TIME;
	}

	public void setPLAN_TIME(String pLAN_TIME) {
		PLAN_TIME = pLAN_TIME;
	}

	public String getACTL_TIME() {
		return ACTL_TIME;
	}

	public void setACTL_TIME(String aCTL_TIME) {
		ACTL_TIME = aCTL_TIME;
	}

	public String getCRE_USER() {
		return CRE_USER;
	}

	public void setCRE_USER(String cRE_USER) {
		CRE_USER = cRE_USER;
	}

	public String getCRE_TIMR() {
		return CRE_TIMR;
	}

	public void setCRE_TIMR(String cRE_TIMR) {
		CRE_TIMR = cRE_TIMR;
	}

	public String getREMARKS() {
		return REMARKS;
	}

	public void setREMARKS(String rEMARKS) {
		REMARKS = rEMARKS;
	}

	public String getDATA_ORG_ID() {
		return DATA_ORG_ID;
	}

	public void setDATA_ORG_ID(String dATA_ORG_ID) {
		DATA_ORG_ID = dATA_ORG_ID;
	}

	public String getDATA_DEPT_CODE() {
		return DATA_DEPT_CODE;
	}

	public void setDATA_DEPT_CODE(String dATA_DEPT_CODE) {
		DATA_DEPT_CODE = dATA_DEPT_CODE;
	}

	public String getDATA_USER_ID() {
		return DATA_USER_ID;
	}

	public void setDATA_USER_ID(String dATA_USER_ID) {
		DATA_USER_ID = dATA_USER_ID;
	}

	public String getTENANT_ID() {
		return TENANT_ID;
	}

	public void setTENANT_ID(String tENANT_ID) {
		TENANT_ID = tENANT_ID;
	}

	public String getTS() {
		return TS;
	}

	public void setTS(String tS) {
		TS = tS;
	}

	public String getDR() {
		return DR;
	}

	public void setDR(String dR) {
		DR = dR;
	}

	public String getATT_ID() {
		return ATT_ID;
	}

	public void setATT_ID(String aTT_ID) {
		ATT_ID = aTT_ID;
	}

	public String getLEADER_OPINION() {
		return LEADER_OPINION;
	}

	public void setLEADER_OPINION(String lEADER_OPINION) {
		LEADER_OPINION = lEADER_OPINION;
	}

	public String getARC_TYPE() {
		return ARC_TYPE;
	}

	public void setARC_TYPE(String aRC_TYPE) {
		ARC_TYPE = aRC_TYPE;
	}

	public String getIS_BACK() {
		return IS_BACK;
	}

	public void setIS_BACK(String iS_BACK) {
		IS_BACK = iS_BACK;
	}

	public String getJiyuebumen() {
		return jiyuebumen;
	}

	public void setJiyuebumen(String jiyuebumen) {
		this.jiyuebumen = jiyuebumen;
	}

	public String getDengjibumen() {
		return dengjibumen;
	}

	public void setDengjibumen(String dengjibumen) {
		this.dengjibumen = dengjibumen;
	}

	public String getBlr() {
		return blr;
	}

	public void setBlr(String blr) {
		this.blr = blr;
	}

	public String getJiyueren() {
		return jiyueren;
	}

	public void setJiyueren(String jiyueren) {
		this.jiyueren = jiyueren;
	}

	public String getTYPE_NAME() {
		return TYPE_NAME;
	}

	public void setTYPE_NAME(String tYPE_NAME) {
		TYPE_NAME = tYPE_NAME;
	}

	
	
}
