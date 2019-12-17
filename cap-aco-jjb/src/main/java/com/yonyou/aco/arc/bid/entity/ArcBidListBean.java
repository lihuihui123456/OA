package com.yonyou.aco.arc.bid.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ArcBidListBean {
	/** 档案Id */
	private String arc_id;
	/** 档案名称 */
	private String arc_name;
	/** 项目名称 */
	private String bid_name;
	/** 登记日期 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date reg_time;
	/** 招标时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date bid_time;
	/** 中标单位 */
	private String bid_co;
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
	public String getBid_name() {
		return bid_name;
	}
	public void setBid_name(String bid_name) {
		this.bid_name = bid_name;
	}
	public Date getReg_time() {
		return reg_time;
	}
	public void setReg_time(Date reg_time) {
		this.reg_time = reg_time;
	}
	public Date getBid_time() {
		return bid_time;
	}
	public void setBid_time(Date bid_time) {
		this.bid_time = bid_time;
	}
	public String getBid_co() {
		return bid_co;
	}
	public void setBid_co(String bid_co) {
		this.bid_co = bid_co;
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
