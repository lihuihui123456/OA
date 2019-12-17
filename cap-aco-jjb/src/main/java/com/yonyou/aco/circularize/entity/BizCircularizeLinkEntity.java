package com.yonyou.aco.circularize.entity;

import java.io.Serializable;
import java.math.BigInteger;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.yonyou.cap.common.util.IdEntity;



@Entity
@Table(name = "biz_circularize_link")
public class BizCircularizeLinkEntity extends IdEntity implements Serializable{

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;

	public String bid;//主表单ID
	public String receiveuid; //接收ID
	public String senduid; //发送ID
	public String receivetime; //接收时间
	public String sendtime;  //发送时间
	public int circularizestatus; //状态
	public String finishtime; //完成时间
	public String importance; //重要性
	public String status; //阅读状态
	public String opinion; //处理意见
	
	@Transient
	@JsonIgnore
	private BigInteger col1;
	
	@Transient
	@JsonIgnore
	private BigInteger col2;
	
	@Transient
	@JsonIgnore
	private BigInteger col3;
	
	public String getBid() {
		return bid;
	}
	public void setBid(String bid) {
		this.bid = bid;
	}
	public String getReceiveuid() {
		return receiveuid;
	}
	public void setReceiveuid(String receiveuid) {
		this.receiveuid = receiveuid;
	}
	public String getSenduid() {
		return senduid;
	}
	public void setSenduid(String senduid) {
		this.senduid = senduid;
	}
	public String getReceivetime() {
		return receivetime;
	}
	public void setReceivetime(String receivetime) {
		this.receivetime = receivetime;
	}
	public String getSendtime() {
		return sendtime;
	}
	public void setSendtime(String sendtime) {
		this.sendtime = sendtime;
	}
	public int getCircularizestatus() {
		return circularizestatus;
	}
	public void setCircularizestatus(int circularizestatus) {
		this.circularizestatus = circularizestatus;
	}
	public String getFinishtime() {
		return finishtime;
	}
	public void setFinishtime(String finishtime) {
		this.finishtime = finishtime;
	}
	public String getImportance() {
		return importance;
	}
	public void setImportance(String importance) {
		this.importance = importance;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getOpinion() {
		return opinion;
	}
	public void setOpinion(String opinion) {
		this.opinion = opinion;
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
	
}
