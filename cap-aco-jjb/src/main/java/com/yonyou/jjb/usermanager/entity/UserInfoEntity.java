package com.yonyou.jjb.usermanager.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;
import org.springframework.format.annotation.DateTimeFormat;


/**
 * 概述：用户基本信息实体类 
 * 功能：用户基本信息实体 
 * 作者：shenhao
 * 创建时间：2016-10-10 
 * 类调用特殊情况：无
 */
@Entity
@Table(name = "isc_user_info")
public class UserInfoEntity implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1457499817397301652L;
	/** 用户ID */
	private String userId;
	/** 用户姓名 */
	private String userName;
	/** 用户性别 0女 1男 2未知 */
	private String userSex;
	/** 用户出生日期 */
	//private String userBitrth;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date userBitrth;
	private String userBitrthStr;
	/** 用户证件类型 0身份证 1护照 2军人证 */
	private String userCertType;
	/** 用户证件号码 */
	private String userCertCode;
	/** 用户政治面貌 0党员 1团员 2群众 */
	private String userPoliceType;
	/** 用户籍贯  */
	private String userNativePlace;
	/** 用户学历  */
	private String userEducation;
	/** 用户学位  */
	private String userDegree;
	/** 用户头像  */
	private String picUrl;
	/** 用户工龄  */
	private int userSeniority;
	/** 用户聘用类型 0正式 1交流借调 2聘用 3临时 4返聘  5实习*/
	private String userDutyTyp;
	/** 用户移动电话 */
	private String userMobile;
	/** 用户Email */
	private String userEmail;
	/** 用户创建时间 */
	private String userCreateTime;
	/** 部门编码 */
	private String deptCode;
	/** 部门ID */
	private String deptId;
	/** 部门名称 */
	private String deptName;
	/** 岗位id */
	private String postId;
	/** 岗位编码 */
	private String postCode;
	/** 岗位名称 */
	private String postName;
	/** 用户来源 */
	private String userSource;
	/** 用户年龄 */
	private String userAge;
	/** 人员变动情况 */
	private String userChange;
	/** 参加工作时间 */
	private String workTime;
	/** 身高 */
	private String userHeight;
	/**户口类别*/
	private String userType;
	/**民族*/
	private String userNation;
	/**家庭电话*/
    private String homePhone;
    /**办公电话*/
    private String officePhone;
    /** 调入时间 */
	private String entryTime;
	/** 入行时间 */
	private String professionTime;
	/** 登录用户名 */
	private String acctLogin;
	/** 血型 */
	private String bloodType;
	/** 婚姻状况 */
	private String maritalStatus;
	/** 户口所在地 */
	private String userSeat;
	/** 宗教信仰 */
	private String userBelief;
	/** 入党时间 */
	private String joinTime;
	/** 现住址 */
	private String userAddress;
	/** 现薪酬*/
	private String userPay;
	/** 备注 */
	private String remark;
	/** 时间戳 */
	private String ts;
	/** 删除行 Y已删除 N未删除 */
	private String dr;
	/** 用户qq */
	private String userQq;
	
	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	@Column(name = "user_id", unique = true, nullable = false, length = 64)
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



	public Date getUserBitrth() {
		return userBitrth;
	}

	public void setUserBitrth(Date userBitrth) {
		this.userBitrth = userBitrth;
	}

	public String getUserCertType() {
		return userCertType;
	}

	public void setUserCertType(String userCertType) {
		this.userCertType = userCertType;
	}

	public String getUserCertCode() {
		return userCertCode;
	}

	public void setUserCertCode(String userCertCode) {
		this.userCertCode = userCertCode;
	}

	public String getUserPoliceType() {
		return userPoliceType;
	}

	public void setUserPoliceType(String userPoliceType) {
		this.userPoliceType = userPoliceType;
	}

	public String getUserNativePlace() {
		return userNativePlace;
	}

	public void setUserNativePlace(String userNativePlace) {
		this.userNativePlace = userNativePlace;
	}

	public String getUserEducation() {
		return userEducation;
	}

	public void setUserEducation(String userEducation) {
		this.userEducation = userEducation;
	}

	public String getUserDegree() {
		return userDegree;
	}

	public void setUserDegree(String userDegree) {
		this.userDegree = userDegree;
	}

	public String getPicUrl() {
		return picUrl;
	}

	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl;
	}



	public int getUserSeniority() {
		return userSeniority;
	}

	public void setUserSeniority(int userSeniority) {
		this.userSeniority = userSeniority;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getUserDutyTyp() {
		return userDutyTyp;
	}

	public void setUserDutyTyp(String userDutyTyp) {
		this.userDutyTyp = userDutyTyp;
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

	public String getUserCreateTime() {
		return userCreateTime;
	}

	public void setUserCreateTime(String userCreateTime) {
		this.userCreateTime = userCreateTime;
	}

	public String getDeptCode() {
		return deptCode;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
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

	public String getPostId() {
		return postId;
	}

	public void setPostId(String postId) {
		this.postId = postId;
	}

	public String getPostCode() {
		return postCode;
	}

	public void setPostCode(String postCode) {
		this.postCode = postCode;
	}

	public String getPostName() {
		return postName;
	}

	public void setPostName(String postName) {
		this.postName = postName;
	}

	public String getUserSource() {
		return userSource;
	}

	public void setUserSource(String userSource) {
		this.userSource = userSource;
	}

	public String getUserAge() {
		return userAge;
	}

	public void setUserAge(String userAge) {
		this.userAge = userAge;
	}

	public String getUserChange() {
		return userChange;
	}

	public void setUserChange(String userChange) {
		this.userChange = userChange;
	}

	public String getWorkTime() {
		return workTime;
	}

	public void setWorkTime(String workTime) {
		this.workTime = workTime;
	}

	public String getUserHeight() {
		return userHeight;
	}

	public void setUserHeight(String userHeight) {
		this.userHeight = userHeight;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

	public String getUserNation() {
		return userNation;
	}

	public void setUserNation(String userNation) {
		this.userNation = userNation;
	}

	public String getHomePhone() {
		return homePhone;
	}

	public void setHomePhone(String homePhone) {
		this.homePhone = homePhone;
	}

	public String getOfficePhone() {
		return officePhone;
	}

	public void setOfficePhone(String officePhone) {
		this.officePhone = officePhone;
	}

	public String getEntryTime() {
		return entryTime;
	}

	public void setEntryTime(String entryTime) {
		this.entryTime = entryTime;
	}

	public String getProfessionTime() {
		return professionTime;
	}

	public void setProfessionTime(String professionTime) {
		this.professionTime = professionTime;
	}

	public String getAcctLogin() {
		return acctLogin;
	}

	public void setAcctLogin(String acctLogin) {
		this.acctLogin = acctLogin;
	}

	public String getBloodType() {
		return bloodType;
	}

	public void setBloodType(String bloodType) {
		this.bloodType = bloodType;
	}

	public String getMaritalStatus() {
		return maritalStatus;
	}

	public void setMaritalStatus(String maritalStatus) {
		this.maritalStatus = maritalStatus;
	}

	public String getUserSeat() {
		return userSeat;
	}

	public void setUserSeat(String userSeat) {
		this.userSeat = userSeat;
	}

	public String getUserBelief() {
		return userBelief;
	}

	public void setUserBelief(String userBelief) {
		this.userBelief = userBelief;
	}

	public String getJoinTime() {
		return joinTime;
	}

	public void setJoinTime(String joinTime) {
		this.joinTime = joinTime;
	}

	public String getUserAddress() {
		return userAddress;
	}

	public void setUserAddress(String userAddress) {
		this.userAddress = userAddress;
	}

	public String getUserPay() {
		return userPay;
	}

	public void setUserPay(String userPay) {
		this.userPay = userPay;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
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

	public String getUserQq() {
		return userQq;
	}

	public void setUserQq(String userQq) {
		this.userQq = userQq;
	}
	@Transient
	public String getUserBitrthStr() {
		return userBitrthStr;
	}

	public void setUserBitrthStr(String userBitrthStr) {
		this.userBitrthStr = userBitrthStr;
	}
	
}
