package com.yonyou.aco.arc.mtgsumm.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ArcMtgSummBean {
	/** 档案ID */
	private String arc_id;
	/** 档案名称 */
	private String arc_name;
	 /** 会议名称 */
    private String ams_name; 
	/** 会议时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date ams_time;
	/** 主持人 */
	private String ams_emcee;
	/** 会议地点 */
	private String ams_add;
	/** 会议议题 */
	private String ams_topic;
	/** 召集部门*/
	private String smd_dept;
	/** 参与部门*/
	private String ilt_dept;
	/** 单位ID */
	private String data_org_id;
	/** 部门CODE */
	private String data_dept_code;
	/** 用户ID */
	private String data_user_id;
	/** 租户ID */
	private String tenant_id;
	/** 登记人id */
	private String reg_user;
	/** 登记部门 */
	private String reg_dept;
	/** 登记日期 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date reg_time;
	/** 归档状态 */
	private String file_start;
	/** 归档时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date file_time;
	/** 存放位置 */
	private String dep_pos;
	/** 是否作废销毁0：正常1：作废2：销毁 */
	private String is_invalid;
	public String getArc_name() {
		return arc_name;
	}
	public void setArc_name(String arc_name) {
		this.arc_name = arc_name;
	}
	public String getAms_name() {
		return ams_name;
	}
	public void setAms_name(String ams_name) {
		this.ams_name = ams_name;
	}
	public Date getAms_time() {
		return ams_time;
	}
	public void setAms_time(Date ams_time) {
		this.ams_time = ams_time;
	}
	public String getAms_emcee() {
		return ams_emcee;
	}
	public void setAms_emcee(String ams_emcee) {
		this.ams_emcee = ams_emcee;
	}
	public String getReg_user() {
		return reg_user;
	}
	public void setReg_user(String reg_user) {
		this.reg_user = reg_user;
	}
	public Date getReg_time() {
		return reg_time;
	}
	public void setReg_time(Date reg_time) {
		this.reg_time = reg_time;
	}
	public String getFile_start() {
		return file_start;
	}
	public void setFile_start(String file_start) {
		this.file_start = file_start;
	}
	public String getDep_pos() {
		return dep_pos;
	}
	public void setDep_pos(String dep_pos) {
		this.dep_pos = dep_pos;
	}
	public String getArc_id() {
		return arc_id;
	}
	public void setArc_id(String arc_id) {
		this.arc_id = arc_id;
	}
	public String getAms_add() {
		return ams_add;
	}
	public void setAms_add(String ams_add) {
		this.ams_add = ams_add;
	}
	public String getAms_topic() {
		return ams_topic;
	}
	public void setAms_topic(String ams_topic) {
		this.ams_topic = ams_topic;
	}
	public String getSmd_dept() {
		return smd_dept;
	}
	public void setSmd_dept(String smd_dept) {
		this.smd_dept = smd_dept;
	}
	public String getIlt_dept() {
		return ilt_dept;
	}
	public void setIlt_dept(String ilt_dept) {
		this.ilt_dept = ilt_dept;
	}
	public String getData_org_id() {
		return data_org_id;
	}
	public void setData_org_id(String data_org_id) {
		this.data_org_id = data_org_id;
	}
	public String getData_dept_code() {
		return data_dept_code;
	}
	public void setData_dept_code(String data_dept_code) {
		this.data_dept_code = data_dept_code;
	}
	public String getData_user_id() {
		return data_user_id;
	}
	public void setData_user_id(String data_user_id) {
		this.data_user_id = data_user_id;
	}
	public String getTenant_id() {
		return tenant_id;
	}
	public void setTenant_id(String tenant_id) {
		this.tenant_id = tenant_id;
	}


	public Date getFile_time() {
		return file_time;
	}
	public void setFile_time(Date file_time) {
		this.file_time = file_time;
	}
	public String getIs_invalid() {
		return is_invalid;
	}
	public void setIs_invalid(String is_invalid) {
		this.is_invalid = is_invalid;
	}
	public String getReg_dept() {
		return reg_dept;
	}
	public void setReg_dept(String reg_dept) {
		this.reg_dept = reg_dept;
	}

}
