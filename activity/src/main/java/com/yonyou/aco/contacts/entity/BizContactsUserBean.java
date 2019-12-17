package com.yonyou.aco.contacts.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 
 * @ClassName: BizAdrBookUserBean
 * @Description: 通讯录-用户虚拟实体类
 * @author hegd
 * @date 2016-8-11 下午3:00:11
 */
public class BizContactsUserBean implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 278902693053344091L;
	/** 用户ID */
	private String userId;
	/** 用户名称 */
	private String userName;
	/** 性别 */
	private String userSex;
	/** 头像URL */
	private String picUrl;
	/** 用户生日 */
	private Date userBitrth;
	/** 用户E-mail */
	private String userEmail;
	/** 移动电话 */
	private String userMobile;
	/** 单位 */
	private String orgName;
	/** 单位ID */
	private String orgId;
	/** QQ号码 */
	private String qq;
	/** 备注 */
	private String remark;
	/** 部门 */
	private String deptName;
	/** 职位 */
	private String postName;
	/** 登录名称 */
	private String userCode;
	
	/** 座机 */
	private String tel;
	
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

	

	public String getUserSex() {
		
		return userSex;
	}

	public void setUserSex(String userSex) {
		this.userSex = userSex;
	}

	public String getPicUrl() {
		return picUrl;
	}

	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl;
	}

	public Date getUserBitrth() {
		return userBitrth;
	}

	public void setUserBitrth(Date userBitrth) {
		this.userBitrth = userBitrth;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getUserMobile() {
		return userMobile;
	}

	public void setUserMobile(String userMobile) {
		this.userMobile = userMobile;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getQq() {
		return qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getPostName() {
		return postName;
	}

	public void setPostName(String postName) {
		this.postName = postName;
	}

	public String getUserCode() {
		return userCode;
	}

	public void setUserCode(String userCode) {
		this.userCode = userCode;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}
	

}
