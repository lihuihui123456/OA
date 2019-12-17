package com.yonyou.aco.cloudydisk.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.yonyou.cap.common.util.IdEntity;
/**
 * 办公云盘分享表
 * @author 葛鹏
 * 2017-03-10
 **/
@Entity
@Table(name = "cloud_share")
public class CloudShareEntity extends IdEntity implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -4331790038119946919L;
	/** 发起分享人ID */
	private String senderId;
	/** 发起分享人姓名 */
	private String senderName;
	/** 被分享人ID */
	private String receiverId;
	/** 被分享人姓名 */
	private String receiverName;
	/** 文件ID */
	private String fileId;
	/** 分享时间 */
	private String ts;
	/** 删除标志，Y代表已删除 N代表有效 */
	private String dr;
	public String getSenderId() {
		return senderId;
	}
	public void setSenderId(String senderId) {
		this.senderId = senderId;
	}
	public String getSenderName() {
		return senderName;
	}
	public void setSenderName(String senderName) {
		this.senderName = senderName;
	}
	public String getReceiverId() {
		return receiverId;
	}
	public void setReceiverId(String receiverId) {
		this.receiverId = receiverId;
	}
	public String getReceiverName() {
		return receiverName;
	}
	public void setReceiverName(String receiverName) {
		this.receiverName = receiverName;
	}
	public String getFileId() {
		return fileId;
	}
	public void setFileId(String fileId) {
		this.fileId = fileId;
	}
	public String getTs() {
		return ts;
	}
	public void setTs(String ts) {
		this.ts = ts;
	}
	public String getDr() {
		return dr;
	}
	public void setDr(String dr) {
		this.dr = dr;
	}

}
