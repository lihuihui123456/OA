package com.yonyou.aco.contacts.entity;


import java.io.Serializable;

import javax.persistence.Entity;

import com.yonyou.cap.common.util.IdEntity;
@Entity
public class ContactsUserInfoBean  extends IdEntity implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2915069044496278816L;
	/**
	 * 用户ID
	 */
	private String userId;
	
	/**
	 * 用户名
	 */
	private String userName;
	
	/**
	 * 座机
	 */
	private String userTelephone;
	
	/**
	 * 手机号
	 */
	private String userMobile;
	
	/**
	 * email
	 */
	private String userEmail;
	
	/**
	 * 部门ID
	 */
	private String deptId;
	
	/**
	 * 部门名称
	 */
	private String deptName;
	
	/**
	 * 图片URL
	 */
	private String picUrl;

	
	/**
	 * 首字母
	 */
	private String firstWord;

	/**
	 * 上级部门
	 */
	private String parentDeptId;
	
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}


	public String getUserTelephone() {
		return userTelephone;
	}

	public void setUserTelephone(String userTelephone) {
		this.userTelephone = userTelephone;
	}

	public String getUserMobile() {
		return userMobile;
	}

	public void setUserMobile(String userMobile) {
		this.userMobile = userMobile;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getDeptId() {
		return deptId;
	}

	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getPicUrl() {
		return picUrl;
	}

	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl;
	}

	public String getFirstWord() {
		return firstWord;
	}

	public void setFirstWord(String firstWord) {
		this.firstWord = firstWord;
	}

	public String getParentDeptId() {
		return parentDeptId;
	}

	public void setParentDeptId(String parentDeptId) {
		this.parentDeptId = parentDeptId;
	}
	
	
	
}

