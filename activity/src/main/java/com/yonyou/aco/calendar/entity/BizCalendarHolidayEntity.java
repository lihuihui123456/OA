package com.yonyou.aco.calendar.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * 
 * TODO: 日程管理-节假日信息实体类 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2017年3月20日
 * @author hegd
 * @since 1.0.0
 */
@Entity
@Table(name = "biz_calendar_holiday_info")
public class BizCalendarHolidayEntity implements Serializable {

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * ID
	 */
	@JsonProperty("ID")
	private String ID;

	/**
	 * 节日名称
	 */
	@JsonProperty("HOLIDAY_NAME")
	private String HOLIDAY_NAME;
	/**
	 * 节日天数
	 */
	@JsonProperty("HOLIDAY_NUM")
	private Integer HOLIDAY_NUM;
	/**
	 * 节日开始日期
	 */
	@JsonProperty("HOLIDAY_START_DATE")
	private String HOLIDAY_START_DATE;

	/**
	 * 节日结束日期
	 */
	@JsonProperty("HOLIDAY_END_DATE")
	private String HOLIDAY_END_DATE;
	/**
	 * 节日备注
	 */
	@JsonProperty("HOLIDAY_REMARK")
	private String HOLIDAY_REMARK;

	/**
	 * 单位Id
	 */
	@JsonProperty("DATA_ORG_ID")
	private String DATA_ORG_ID;

	/**
	 * 部门Id
	 */
	@JsonProperty("DATA_DEPT_ID")
	private String DATA_DEPT_ID;

	/**
	 * 部门CODE
	 */
	@JsonProperty("DATA_DEPT_CODE")
	private String DATA_DEPT_CODE;

	/**
	 * 用户ID
	 */
	@JsonProperty("DATA_USER_ID")
	private String DATA_USER_ID;

	/**
	 * 租户ID
	 */
	@JsonProperty("TENANT_ID")
	private String TENANT_ID;

	/**
	 * 时间戳
	 */
	@JsonProperty("TS")
	private String TS;

	
	
	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	@Column(name = "ID", unique = true, nullable = false, length = 64)
	public String getID() {
		return ID;
	}

	public void setID(String iD) {
		ID = iD;
	}

	public String getHOLIDAY_NAME() {
		return HOLIDAY_NAME;
	}

	public void setHOLIDAY_NAME(String hOLIDAY_NAME) {
		HOLIDAY_NAME = hOLIDAY_NAME;
	}

	public Integer getHOLIDAY_NUM() {
		return HOLIDAY_NUM;
	}

	public void setHOLIDAY_NUM(Integer hOLIDAY_NUM) {
		HOLIDAY_NUM = hOLIDAY_NUM;
	}

	public String getHOLIDAY_START_DATE() {
		return HOLIDAY_START_DATE;
	}

	public void setHOLIDAY_START_DATE(String hOLIDAY_START_DATE) {
		HOLIDAY_START_DATE = hOLIDAY_START_DATE;
	}

	public String getHOLIDAY_END_DATE() {
		return HOLIDAY_END_DATE;
	}

	public void setHOLIDAY_END_DATE(String hOLIDAY_END_DATE) {
		HOLIDAY_END_DATE = hOLIDAY_END_DATE;
	}

	public String getHOLIDAY_REMARK() {
		return HOLIDAY_REMARK;
	}

	public void setHOLIDAY_REMARK(String hOLIDAY_REMARK) {
		HOLIDAY_REMARK = hOLIDAY_REMARK;
	}

	public String getDATA_ORG_ID() {
		return DATA_ORG_ID;
	}

	public void setDATA_ORG_ID(String dATA_ORG_ID) {
		DATA_ORG_ID = dATA_ORG_ID;
	}

	public String getDATA_DEPT_ID() {
		return DATA_DEPT_ID;
	}

	public void setDATA_DEPT_ID(String dATA_DEPT_ID) {
		DATA_DEPT_ID = dATA_DEPT_ID;
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

}
