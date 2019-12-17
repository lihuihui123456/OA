package com.yonyou.aco.notice.entity;

import java.io.Serializable;
import java.math.BigInteger;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.yonyou.cap.common.util.IdEntity;



@Entity
@Table(name = "biz_notice_people")
public class BizNoticePeopleEntity extends IdEntity implements Serializable{

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;

	public String bid;//主表单ID
	
	@Column(name = "receive_uid")
	public String receiveuid; //接收ID
	
	@Column(name = "send_uid")
	public String senduid; //发送ID
	
	@Column(name = "send_time")
	public String sendtime; //发送时间
	
	@Column(name = "finish_time")
	public String finishtime; //阅读时间
	public String status; //阅读状态
	
	@Transient
	@JsonIgnore
	private BigInteger col1;//总数
	
	@Transient
	@JsonIgnore
	private BigInteger col2;//已处理数
	
	@Transient
	@JsonIgnore
	private BigInteger col3;//未处理数
	
	public String getBid() {
		return bid;
	}
	public void setBid(String bid) {
		this.bid = bid;
	}
	
	@Column(name = "receive_uid")
	public String getReceiveuid() {
		return receiveuid;
	}
	public void setReceiveuid(String receiveuid) {
		this.receiveuid = receiveuid;
	}
	
	@Column(name = "send_uid")
	public String getSenduid() {
		return senduid;
	}
	public void setSenduid(String senduid) {
		this.senduid = senduid;
	}
	
	@Column(name = "finish_time")
	public String getFinishtime() {
		return finishtime;
	}
	public void setFinishtime(String finishtime) {
		this.finishtime = finishtime;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	@Transient
	@JsonIgnore
	public BigInteger getCol1() {
		return col1;
	}
	public void setCol1(BigInteger col1) {
		this.col1 = col1;
	}
	
	@Transient
	@JsonIgnore
	public BigInteger getCol2() {
		return col2;
	}
	public void setCol2(BigInteger col2) {
		this.col2 = col2;
	}
	
	@Transient
	@JsonIgnore
	public BigInteger getCol3() {
		return col3;
	}
	public void setCol3(BigInteger col3) {
		this.col3 = col3;
	}
	
	@Column(name = "send_time")
	public String getSendtime() {
		return sendtime;
	}
	public void setSendtime(String sendtime) {
		this.sendtime = sendtime;
	}
	
}
