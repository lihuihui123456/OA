package com.yonyou.aco.cloudydisk.entity;

import java.io.Serializable;

import javax.persistence.Entity;

import com.yonyou.cap.common.util.IdEntity;
/**
 * 办公云盘分享表
 * @author 葛鹏
 * 2017-03-10
 **/
@Entity
public class CloudShareBean extends IdEntity implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -4331790038119946919L;
	/** 主键ID */
	private String fileId;
	/** 文件名 */
	private String fileName;
	/** 加密后文件名 */
	private String recordId;
	/** 上级文件ID */
	private String parentFileId;
	/** 文件类型 */
	private String fileType;
	/** 文件属性 */
	private String fileAttr;
	/** 文件路径 */
	private String filePath;
	/** 文件大小 */
	private long fileSize;
	/** 上传用户ID */
	private String fileOwnerId;
	/** 上传用户姓名 */
	private String fileOwnerName;
	/** 上传日期 */
	private String fileDate;
	/** 下载次数 */
	private int fileCount;
	/** 发起分享人ID */
	private String senderId;
	/** 发起分享人姓名 */
	private String senderName;
	/** 被分享人ID */
	private String receiverId;
	/** 被分享人姓名 */
	private String receiverName;
	/** 分享时间 */
	private String shareTime;
	public String getFileId() {
		return fileId;
	}
	public void setFileId(String fileId) {
		this.fileId = fileId;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getRecordId() {
		return recordId;
	}
	public void setRecordId(String recordId) {
		this.recordId = recordId;
	}
	
	public String getParentFileId() {
		return parentFileId;
	}
	public void setParentFileId(String parentFileId) {
		this.parentFileId = parentFileId;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	
	public String getFileAttr() {
		return fileAttr;
	}
	public void setFileAttr(String fileAttr) {
		this.fileAttr = fileAttr;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public long getFileSize() {
		return fileSize;
	}
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}
	public String getFileOwnerId() {
		return fileOwnerId;
	}
	public void setFileOwnerId(String fileOwnerId) {
		this.fileOwnerId = fileOwnerId;
	}
	public String getFileOwnerName() {
		return fileOwnerName;
	}
	public void setFileOwnerName(String fileOwnerName) {
		this.fileOwnerName = fileOwnerName;
	}
	public String getFileDate() {
		return fileDate;
	}
	public void setFileDate(String fileDate) {
		this.fileDate = fileDate;
	}
	public int getFileCount() {
		return fileCount;
	}
	public void setFileCount(int fileCount) {
		this.fileCount = fileCount;
	}
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
	public String getShareTime() {
		return shareTime;
	}
	public void setShareTime(String shareTime) {
		this.shareTime = shareTime;
	}

}
