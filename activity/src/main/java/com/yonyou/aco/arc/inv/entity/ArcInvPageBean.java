package com.yonyou.aco.arc.inv.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ArcInvPageBean {
	/** 档案Id */
	private String arc_id;
	/** 档案名称 */
	private String arc_name;
	/** 项目名称 */
	private String pro_name;
	/** 投资金额 */
	private String mny;
	/** 投资占比 */
	private String inv_pro;
	/** 投资形式 */
	private String inv_type;
	/** 投资时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date inv_time;
	/** 资金来源 */
	private String bank_src;
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
	public String getPro_name() {
		return pro_name;
	}
	public void setPro_name(String pro_name) {
		this.pro_name = pro_name;
	}
	public String getMny() {
		return mny;
	}
	public void setMny(String mny) {
		this.mny = mny;
	}
	public String getInv_pro() {
		return inv_pro;
	}
	public void setInv_pro(String inv_pro) {
		this.inv_pro = inv_pro;
	}
	public String getInv_type() {
		return inv_type;
	}
	public void setInv_type(String inv_type) {
		this.inv_type = inv_type;
	}
	public Date getInv_time() {
		return inv_time;
	}
	public void setInv_time(Date inv_time) {
		this.inv_time = inv_time;
	}
	public String getBank_src() {
		return bank_src;
	}
	public void setBank_src(String bank_src) {
		this.bank_src = bank_src;
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
