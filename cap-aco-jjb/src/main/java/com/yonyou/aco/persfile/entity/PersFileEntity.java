package com.yonyou.aco.persfile.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;

import com.fasterxml.jackson.annotation.JsonProperty;

@Entity
@Table(name = "biz_persfile_info")
public class PersFileEntity {

	/**
	 * 主键ID
	 */
	@JsonProperty("ID") 
	private String ID;

	/**
	 * 人事档案业务ID (BizId)
	 */
	@JsonProperty("PERS_FILE_ID") 
	private String PERS_FILE_ID;

	/**
	 * 姓名
	 */
	@JsonProperty("USER_NAME") 
	private String USER_NAME;

	/**
	 * 性别 0:女，1:男，2:未知
	 */
	@JsonProperty("USER_SEX") 
	private String USER_SEX;

	/**
	 * 身份证号
	 */
	@JsonProperty("USER_CERT_CODE") 
	private String USER_CERT_CODE;

	/**
	 * 婚姻状况 0:未婚，1:已婚
	 */
	@JsonProperty("MARITAL_STATUS") 
	private String MARITAL_STATUS;

	/**
	 * 学历 bk:本科，ss:硕士,bs:博士,gz:高中,zk专科,qt其他
	 */
	@JsonProperty("USER_EDUCATION") 
	private String USER_EDUCATION;

	/**
	 * 政治面貌 dy:党员，gqty:共青团员,wdprs:无党派人士
	 */
	@JsonProperty("USER_POLICE_TYPE") 
	private String USER_POLICE_TYPE;

	/**
	 * 业务解决ID
	 */
	@JsonProperty("SOL_ID_")
	private String SOL_ID_;
	
	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	public String getID() {
		return ID;
	}

	public void setID(String iD) {
		ID = iD;
	}

	public String getPERS_FILE_ID() {
		return PERS_FILE_ID;
	}

	public void setPERS_FILE_ID(String pERS_FILE_ID) {
		PERS_FILE_ID = pERS_FILE_ID;
	}

	public String getUSER_NAME() {
		return USER_NAME;
	}

	public void setUSER_NAME(String uSER_NAME) {
		USER_NAME = uSER_NAME;
	}

	public String getUSER_SEX() {
		return USER_SEX;
	}

	public void setUSER_SEX(String uSER_SEX) {
		USER_SEX = uSER_SEX;
	}

	public String getUSER_CERT_CODE() {
		return USER_CERT_CODE;
	}

	public void setUSER_CERT_CODE(String uSER_CERT_CODE) {
		USER_CERT_CODE = uSER_CERT_CODE;
	}

	public String getMARITAL_STATUS() {
		return MARITAL_STATUS;
	}

	public void setMARITAL_STATUS(String mARITAL_STATUS) {
		MARITAL_STATUS = mARITAL_STATUS;
	}

	public String getUSER_EDUCATION() {
		return USER_EDUCATION;
	}

	public void setUSER_EDUCATION(String uSER_EDUCATION) {
		USER_EDUCATION = uSER_EDUCATION;
	}

	public String getUSER_POLICE_TYPE() {
		return USER_POLICE_TYPE;
	}

	public void setUSER_POLICE_TYPE(String uSER_POLICE_TYPE) {
		USER_POLICE_TYPE = uSER_POLICE_TYPE;
	}

	@Transient
	public String getSOL_ID_() {
		return SOL_ID_;
	}

	public void setSOL_ID_(String sOL_ID_) {
		SOL_ID_ = sOL_ID_;
	}
	
	

}
