package com.yonyou.aco.earc.seddread.entity;

import java.io.Serializable;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class EarcSeddRedBean implements Serializable {

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 主键ID
	 */
	private String id_;
	
	/**
	 * 业务解决方案ID
	 */
	private String solId;
	/**
	 * 接收人
	 */
	private String receive_user;
	/**
	 * 发送人
	 */
	private String send_user;
	/**
	 * 调阅开始日期
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date start_date;
	/**
	 * 调阅结束日期
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date end_date;
	/**
	 * 档案ID
	 */
	private String earc_id;
	private String biz_title_;
	private String security_level;

	public String getId_() {
		return id_;
	}
	public void setId_(String id_) {
		this.id_ = id_;
	}
	
	
	public String getSolId() {
		return solId;
	}
	public void setSolId(String solId) {
		this.solId = solId;
	}
	public String getReceive_user() {
		return receive_user;
	}
	public void setReceive_user(String receive_user) {
		this.receive_user = receive_user;
	}
	public String getSend_user() {
		return send_user;
	}
	public void setSend_user(String send_user) {
		this.send_user = send_user;
	}
	public Date getStart_date() {
		return start_date;
	}
	public void setStart_date(Date start_date) {
		this.start_date = start_date;
	}
	public Date getEnd_date() {
		return end_date;
	}
	public void setEnd_date(Date end_date) {
		this.end_date = end_date;
	}
	public String getEarc_id() {
		return earc_id;
	}
	public void setEarc_id(String earc_id) {
		this.earc_id = earc_id;
	}
	public String getBiz_title_() {
		return biz_title_;
	}
	public void setBiz_title_(String biz_title_) {
		this.biz_title_ = biz_title_;
	}
	public String getSecurity_level() {
		return security_level;
	}
	public void setSecurity_level(String security_level) {
		this.security_level = security_level;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	
}
