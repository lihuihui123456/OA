package com.yonyou.aco.leave.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * 
 * TODO: 请加管理查询列表虚拟bean
 * 
 * @Date 2017年6月6日
 * @author 贺国栋
 * @since 1.0.0
 */
public class LeaveBean {

	/**
	 * 主键ID
	 */
	@JsonProperty("ID")
	private String ID;

	/**
	 * 业务解决ID
	 */
	@JsonProperty("SOL_ID_")
	private String SOL_ID_;

	/**
	 * 业务ID
	 */
	@JsonProperty("LEAVE_ID")
	private String LEAVE_ID;

	/**
	 * 请假事由
	 */
	@JsonProperty("BIZ_TITLE_")
	private String BIZ_TITLE_;

	/**
	 * 姓名
	 */
	@JsonProperty("USER_NAME")
	private String USER_NAME;

	/**
	 * 所属部门名称
	 */
	@JsonProperty("DEPT_NAME")
	private String DEPT_NAME;

	/**
	 * 职务
	 */
	@JsonProperty("POST_NAME")
	private String POST_NAME;

	/**
	 * 请假状态 0：待提交 1：审批中 2：通过 3：未通过
	 */
	@JsonProperty("STATE")
	private String STATE;

	/**
	 * 请假类型
	 */
	@JsonProperty("LEAVE_TYPE")
	private String LEAVE_TYPE;

	/**
	 * 开始时间
	 */
	@JsonProperty("START_TIME")
	private String START_TIME;

	/**
	 * 结束时间
	 */
	@JsonProperty("END_TIME")
	private String END_TIME;

	/**
	 * 请假天数
	 */
	@JsonProperty("LEAVE_DAYS")
	private String LEAVE_DAYS;

	/**
	 * 是否出京
	 */
	@JsonProperty("IS_BJ")
	private String IS_BJ;

	/**
	 * 是否出境
	 */
	@JsonProperty("IS_EXIT")
	private String IS_EXIT;

	/**
	 * 提交时间
	 */
	@JsonProperty("SEND_TIME")
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date SEND_TIME;

	

	public String getID() {
		return ID;
	}

	public void setID(String iD) {
		ID = iD;
	}

	public String getSOL_ID_() {
		return SOL_ID_;
	}

	public void setSOL_ID_(String sOL_ID_) {
		SOL_ID_ = sOL_ID_;
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

	public String getPOST_NAME() {
		return POST_NAME;
	}

	public void setPOST_NAME(String pOST_NAME) {
		POST_NAME = pOST_NAME;
	}

	public String getSTATE() {
		return STATE;
	}

	public void setSTATE(String sTATE) {
		STATE = sTATE;
	}

	public String getLEAVE_TYPE() {
		return LEAVE_TYPE;
	}

	public void setLEAVE_TYPE(String lEAVE_TYPE) {
		LEAVE_TYPE = lEAVE_TYPE;
	}

	public String getSTART_TIME() {
		return START_TIME;
	}

	public void setSTART_TIME(String sTART_TIME) {
		START_TIME = sTART_TIME;
	}

	public String getEND_TIME() {
		return END_TIME;
	}

	public void setEND_TIME(String eND_TIME) {
		END_TIME = eND_TIME;
	}

	public String getLEAVE_DAYS() {
		return LEAVE_DAYS;
	}

	public void setLEAVE_DAYS(String lEAVE_DAYS) {
		LEAVE_DAYS = lEAVE_DAYS;
	}

	public String getIS_BJ() {
		return IS_BJ;
	}

	public void setIS_BJ(String iS_BJ) {
		IS_BJ = iS_BJ;
	}

	public String getIS_EXIT() {
		return IS_EXIT;
	}

	public void setIS_EXIT(String iS_EXIT) {
		IS_EXIT = iS_EXIT;
	}

	public Date getSEND_TIME() {
		return SEND_TIME;
	}

	public void setSEND_TIME(Date sEND_TIME) {
		SEND_TIME = sEND_TIME;
	}

	public String getBIZ_TITLE_() {
		return BIZ_TITLE_;
	}

	public void setBIZ_TITLE_(String bIZ_TITLE_) {
		BIZ_TITLE_ = bIZ_TITLE_;
	}

	public String getLEAVE_ID() {
		return LEAVE_ID;
	}

	public void setLEAVE_ID(String lEAVE_ID) {
		LEAVE_ID = lEAVE_ID;
	}

}
