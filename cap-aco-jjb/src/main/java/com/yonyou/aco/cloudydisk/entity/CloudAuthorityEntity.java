package com.yonyou.aco.cloudydisk.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

/**
 * 办公云盘权限表
 * @author 葛鹏
 * 2017-06-10
 **/
@Entity
@Table(name = "cloud_authority")
public class CloudAuthorityEntity implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1955242154303606960L;
	/**  */
	private String authId;
	
	private String authName;
	/**  */
	private String authValue;
	
	private String authType;
	
	private String fileId;
	private String authUserId;
	private String authUserName;
	private String sort;
	/**  */
	private String dr;
	/**  */
	private String ts;
	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	public String getAuthId() {
		return authId;
	}
	public void setAuthId(String authId) {
		this.authId = authId;
	}
	
	public String getAuthName() {
		return authName;
	}
	public void setAuthName(String authName) {
		this.authName = authName;
	}
	public String getAuthValue() {
		return authValue;
	}
	public void setAuthValue(String authValue) {
		this.authValue = authValue;
	}
	
	public String getAuthType() {
		return authType;
	}
	public void setAuthType(String authType) {
		this.authType = authType;
	}
	public String getFileId() {
		return fileId;
	}
	public void setFileId(String fileId) {
		this.fileId = fileId;
	}
	public String getAuthUserId() {
		return authUserId;
	}
	public void setAuthUserId(String authUserId) {
		this.authUserId = authUserId;
	}
	
	public String getAuthUserName() {
		return authUserName;
	}
	public void setAuthUserName(String authUserName) {
		this.authUserName = authUserName;
	}
	public String getSort() {
		return sort;
	}
	public void setSort(String sort) {
		this.sort = sort;
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
