package com.yonyou.aco.cloudydisk.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 文件夹与日志关联表
 * @author 葛鹏
 * 2017-03-21
 **/
@Entity
@Table(name = "cloud_folder_ref_log")
public class CloudFolderRefLogEntity extends IdEntity implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/** LOG_ID */
	private String logId;
	/** FOLDER_ID */
	private String folderId;
	/** DR */
	private String dr;
	/** TS */
	private String ts;
	public String getLogId() {
		return logId;
	}
	public void setLogId(String logId) {
		this.logId = logId;
	}
	public String getFolderId() {
		return folderId;
	}
	public void setFolderId(String folderId) {
		this.folderId = folderId;
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

	
}
