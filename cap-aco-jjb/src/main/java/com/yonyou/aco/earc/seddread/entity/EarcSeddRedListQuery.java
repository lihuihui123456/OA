package com.yonyou.aco.earc.seddread.entity;
public class EarcSeddRedListQuery {
	private  String sortName="";
	private  String sortOrder=""; 
	private  String solId="";
	//档案调度高级查询参数
	private  String biz_title_="";
	private  String security_level="";
	private  String receive_user="";
	private  String send_user="";
	private  String startTime="";
	private  String endTime="";
	public String getSortName() {
		return sortName;
	}
	public void setSortName(String sortName) {
		this.sortName = sortName;
	}
	public String getSortOrder() {
		return sortOrder;
	}
	public void setSortOrder(String sortOrder) {
		this.sortOrder = sortOrder;
	}
	public String getSolId() {
		return solId;
	}
	public void setSolId(String solId) {
		this.solId = solId;
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
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

}
