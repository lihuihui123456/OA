package com.yonyou.aco.arc.destry.entity;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ArcDestryBean {
	private String id;
	private String arc_id;
	/** 单号 */
	private String nbr;
	/** 档案类型 */
	private String type_name;
	/** 档案名称 */
	private String arc_name;
	/** 档案类型 */
	private String arc_type;
	/** 登记部门 */
	private String reg_dept;
	/** 归档时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date file_time;
	/** 操作日期 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date oper_time;
	/** 有效期 */
	private String expiry_date;
	/** 档案有效期 */
	private Date expiry_date_time;
	private String closing_date;
	/** 是否作废销毁0：正常1：作废2：销毁 */
	private String is_invalid;
	/** 归档状态 */
	private String file_start;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNbr() {
		return nbr;
	}
	public void setNbr(String nbr) {
		this.nbr = nbr;
	}
	public String getType_name() {
		return type_name;
	}
	public void setType_name(String type_name) {
		this.type_name = type_name;
	}
	public String getArc_name() {
		return arc_name;
	}
	public void setArc_name(String arc_name) {
		this.arc_name = arc_name;
	}
	public String getReg_dept() {
		return reg_dept;
	}
	public void setReg_dept(String reg_dept) {
		this.reg_dept = reg_dept;
	}
	public Date getFile_time() {
		return file_time;
	}
	public void setFile_time(Date file_time) {
		this.file_time = file_time;
	}
	public Date getOper_time() {
		return oper_time;
	}
	public void setOper_time(Date oper_time) {
		this.oper_time = oper_time;
	}
	public String getExpiry_date() {
		return expiry_date;
	}
	public void setExpiry_date(String expiry_date) {
		this.expiry_date = expiry_date;
	}
	public String getIs_invalid() {
		return is_invalid;
	}
	public void setIs_invalid(String is_invalid) {
		this.is_invalid = is_invalid;
	}
	public String getFile_start() {
		return file_start;
	}
	public void setFile_start(String file_start) {
		this.file_start = file_start;
	}


	public Date getExpiry_date_time() {
		return expiry_date_time;
	}
	public void setExpiry_date_time(Date expiry_date_time) {
		this.expiry_date_time = expiry_date_time;
	}
	public String getClosing_date() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if(expiry_date_time!=null){
			closing_date = sdf.format(expiry_date_time);
		}
		return closing_date;
	}
	public void setClosing_date(String closing_date) {
		this.closing_date = closing_date;
	}
	public String getArc_type() {
		return arc_type;
	}
	public void setArc_type(String arc_type) {
		this.arc_type = arc_type;
	}
	public String getArc_id() {
		return arc_id;
	}
	public void setArc_id(String arc_id) {
		this.arc_id = arc_id;
	}


}
