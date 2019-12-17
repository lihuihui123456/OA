package com.yonyou.aco.arc.otherarc.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ArcPubInfoBean {

	/** 档案Id */
	private String id;
	private String arc_id;
	private String arc_type;
	/** 档案名称 */
	private String arc_name;
	/** 归档人 */
	private String file_user;
	/** 归档部门ID */
	private String file_dept;
	/** 档案类型 */
	private String type_name;
	/** 归档时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date file_time;
	/** 是否作废销毁0：正常1：作废2：销毁 */
	private String is_invalid;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getArc_name() {
		return arc_name;
	}
	public void setArc_name(String arc_name) {
		this.arc_name = arc_name;
	}
	public String getFile_user() {
		return file_user;
	}
	public void setFile_user(String file_user) {
		this.file_user = file_user;
	}
	public String getFile_dept() {
		return file_dept;
	}
	public void setFile_dept(String file_dept) {
		this.file_dept = file_dept;
	}
	public String getType_name() {
		return type_name;
	}
	public void setType_name(String type_name) {
		this.type_name = type_name;
	}
	public Date getFile_time() {
		return file_time;
	}
	public void setFile_time(Date file_time) {
		this.file_time = file_time;
	}
	public String getArc_id() {
		return arc_id;
	}
	public void setArc_id(String arc_id) {
		this.arc_id = arc_id;
	}
	public String getArc_type() {
		return arc_type;
	}
	public void setArc_type(String arc_type) {
		this.arc_type = arc_type;
	}
	public String getIs_invalid() {
		return is_invalid;
	}
	public void setIs_invalid(String is_invalid) {
		this.is_invalid = is_invalid;
	}
	
}
