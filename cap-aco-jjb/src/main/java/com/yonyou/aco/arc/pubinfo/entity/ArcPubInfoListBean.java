package com.yonyou.aco.arc.pubinfo.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ArcPubInfoListBean {

	/** 档案ID */
	private String arc_id;
	/** 档案名称 */
	private String arc_name;  
    /** 关键字 */
	private String key_word;
	/** 登记人 */
	private String reg_user;
	/** 登记部门 */
	private String reg_dept;
	/** 登记日期 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date reg_time;
	/** 归档状态 */
	private String file_start;
	/** 存放位置 */
	private String dep_pos;
	/** 是否作废销毁0：正常1：作废2：销毁 */
	private String is_invalid;
	public String getArc_id() {
		return arc_id;
	}
	public void setArc_id(String arc_id) {
		this.arc_id = arc_id;
	}

	public String getArc_name() {
		return arc_name;
	}
	public void setArc_name(String arc_name) {
		this.arc_name = arc_name;
	}
	public String getKey_word() {
		return key_word;
	}
	public void setKey_word(String key_word) {
		this.key_word = key_word;
	}
	public String getReg_user() {
		return reg_user;
	}
	public void setReg_user(String reg_user) {
		this.reg_user = reg_user;
	}
	public String getReg_dept() {
		return reg_dept;
	}
	public void setReg_dept(String reg_dept) {
		this.reg_dept = reg_dept;
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
	public String getIs_invalid() {
		return is_invalid;
	}
	public void setIs_invalid(String is_invalid) {
		this.is_invalid = is_invalid;
	}



}
