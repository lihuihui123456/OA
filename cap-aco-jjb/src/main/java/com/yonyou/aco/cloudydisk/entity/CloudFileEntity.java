package com.yonyou.aco.cloudydisk.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;

/**
 * 办公云盘文件表
 * @author 葛鹏
 * 2017-03-10
 **/
@Entity
@Table(name = "cloud_file")
public class CloudFileEntity  implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8624447241365176076L;

	/** 主键ID */
	private String fileId;
	/** 文件名 */
	private String fileName;
	/** 加密后文件名 */
	private String recordId;
	/** 上级文件夹ID,没有则为空 */
	private String parentFileId;
	/** 文件属性 */
	private String fileAttr;
	/** 文件类型 */
	private String fileType;
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
	/** 是否允许下载 */
	private String isDownload;
	/** 是否允许覆盖 */
	private String isCover;
	/** 文件MD5值 */
	private String md5;
	/** 删除标志，Y代表已删除 N代表有效 */
	private String dr;
	/** 时间戳 */
	private String ts;
	
	@Transient
	public String auths; // 备用字段
	
	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
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
	
	public String getParentFileId() {
		return parentFileId;
	}
	public void setParentFileId(String parentFileId) {
		this.parentFileId = parentFileId;
	}
	public String getRecordId() {
		return recordId;
	}
	public void setRecordId(String recordId) {
		this.recordId = recordId;
	}
	public String getFileAttr() {
		return fileAttr;
	}
	public void setFileAttr(String fileAttr) {
		this.fileAttr = fileAttr;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
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
	public String getIsDownload() {
		return isDownload;
	}
	public void setIsDownload(String isDownload) {
		this.isDownload = isDownload;
	}
	public String getIsCover() {
		return isCover;
	}
	public void setIsCover(String isCover) {
		this.isCover = isCover;
	}
	public String getMd5() {
		return md5;
	}
	public void setMd5(String md5) {
		this.md5 = md5;
	}
	public String getDr() {
		return dr;
	}
	public void setDr(String dr) {
		this.dr = dr;
	}
	public String getTs() {
		return ts;
	}
	public void setTs(String ts) {
		this.ts = ts;
	}
	@Transient
	public String getAuths() {
		return auths;
	}
	public void setAuths(String auths) {
		this.auths = auths;
	}

	
}
