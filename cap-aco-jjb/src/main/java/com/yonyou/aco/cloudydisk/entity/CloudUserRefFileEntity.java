package com.yonyou.aco.cloudydisk.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 文件与用户关联表
 * @author 葛鹏
 * 2017-03-16
 **/
@Entity
@Table(name = "cloud_user_ref_file")
public class CloudUserRefFileEntity extends IdEntity implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -4203649007144513740L;
	
	/** 文件ID */
	private String fileId;
	/** 用户ID */
	private String userId;
	/** 权限ID */
	private String authId;
	/** 0 可编辑 1 不可编辑 */
	private String editable;
	/** N 未删除 Y 已删除 */
	private String dr;
	/** 时间戳 */
	private String ts;
	public String getFileId() {
		return fileId;
	}
	public void setFileId(String fileId) {
		this.fileId = fileId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getAuthId() {
		return authId;
	}
	public void setAuthId(String authId) {
		this.authId = authId;
	}
	public String getEditable() {
		return editable;
	}
	public void setEditable(String editable) {
		this.editable = editable;
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
