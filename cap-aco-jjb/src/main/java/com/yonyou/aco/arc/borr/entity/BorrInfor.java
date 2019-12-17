//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：徐真$手机：18611123594#
// SVN版本号                    日   期                 作     者              变更记录
// BorrInfor-001     2016/12/28   张多一                  新建
//*********************************************************************
package com.yonyou.aco.arc.borr.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

/**
 * <p>概述：借阅管理表实体
 * <p>功能：借阅管理表实体
 * <p>作者：张多一
 * <p>创建时间：2016-12-21
 * <p>类调用特殊情况：无
 */
@Entity
@Table(name = "biz_arc_borr_info")
public class BorrInfor implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 9174711733759315180L;
	/** 主键ID */
	private String id;
	/** 借阅单号*/
	private String borNBR;
	/** 单号日期 */
	private String nbrTime;//NBR_TIME;
	/** 借阅人 */
	private String borrUser;//BORR_USER;
	/** 借阅人电话 */
	private String borrMobile;//BORR_MOBILE;
	/**借阅时间 */
	private String borrTime;//BORR_TIME;
	/** 所属部门 */
	private String borrDept;//BORR_DEPT;
	/** 档案ID*/
	private String arcId;//ARC_ID;
	/** 文件名称 */
	private String arcName;//ARC_NAME;
	/** 借阅类型 */
	private String borrType;//BORR_TYPE;
	/** 借阅份数*/
	private String borrSHR;//BORR_SHR;
	/** 是否需要归还  Y：需要归还，N：无需归还*/
	private String isSet;//IS_RET;
	/** 是否已经归还  Y:已经归还，N：未归还*/
	private String isBack;//IS_BACK;
	/** 计划归还时间 */
	private String planTime;//PLAN_TIME;
	/** 实际归还时间 */
	private String actlTime;//ACTL_TIME;
	/** 办理人 */
	private String creUser;//CRE_USER;
	/** 办理时间 */
	private String creTime;//CRE_TIMR;
	/** 备注 */
	private String remarks;//REMARKS;
	/** 单位ID */
	private String dataOrgId;//DATA_ORG_ID;
	/** 部门CODE*/
	private String dataDeptCode;//DATA_DEPT_CODE;
	/** 用户ID */
	private String dataUserId;//DATA_USER_ID;
	/** 附件ID */
	private String attId;//ATT_ID
	/** 附件ID */
	private String leaderOpinion;//LEADER_OPINION
	/** 档案类型 */
	private String arcType;//ARC_TYPE
	/** 时间戳 */
	private String ts;
	/** 删除标记 */
	private String dr;
	
	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	@Column(name = "id", unique = true, nullable = false, length = 64)
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	@Column(name="BOR_NBR")
	public String getBorNBR() {
		return borNBR;
	}
	public void setBorNBR(String borNBR) {
		this.borNBR = borNBR;
	}
	@Column(name="NBR_TIME")
	public String getNbrTime() {
		return nbrTime;
	}
	public void setNbrTime(String nbrTime) {
		this.nbrTime = nbrTime;
	}
	@Column(name="BORR_USER")
	public String getBorrUser() {
		return borrUser;
	}
	public void setBorrUser(String borrUser) {
		this.borrUser = borrUser;
	}
	@Column(name="BORR_MOBILE")
	public String getBorrMobile() {
		return borrMobile;
	}
	public void setBorrMobile(String borrMobile) {
		this.borrMobile = borrMobile;
	}
	@Column(name="BORR_TIME")
	public String getBorrTime() {
		return borrTime;
	}
	public void setBorrTime(String borrTime) {
		this.borrTime = borrTime;
	}
	@Column(name="BORR_DEPT")
	public String getBorrDept() {
		return borrDept;
	}
	public void setBorrDept(String borrDept) {
		this.borrDept = borrDept;
	}
	@Column(name="ARC_ID")
	public String getArcId() {
		return arcId;
	}
	public void setArcId(String arcId) {
		this.arcId = arcId;
	}
	@Column(name="ARC_NAME")
	public String getArcName() {
		return arcName;
	}
	public void setArcName(String arcName) {
		this.arcName = arcName;
	}
	@Column(name="BORR_TYPE")
	public String getBorrType() {
		return borrType;
	}
	public void setBorrType(String borrType) {
		this.borrType = borrType;
	}
	@Column(name="BORR_SHR")
	public String getBorrSHR() {
		return borrSHR;
	}
	public void setBorrSHR(String borrSHR) {
		this.borrSHR = borrSHR;
	}
	@Column(name="IS_RET")
	public String getIsSet() {
		return isSet;
	}
	public void setIsSet(String isSet) {
		this.isSet = isSet;
	}
	@Column(name="PLAN_TIME")
	public String getPlanTime() {
		return planTime;
	}
	public void setPlanTime(String planTime) {
		this.planTime = planTime;
	}
	@Column(name="ACTL_TIME")
	public String getActlTime() {
		return actlTime;
	}
	public void setActlTime(String actlTime) {
		this.actlTime = actlTime;
	}
	@Column(name="CRE_USER")
	public String getCreUser() {
		return creUser;
	}
	public void setCreUser(String creUser) {
		this.creUser = creUser;
	}
	@Column(name="CRE_TIMR")
	public String getCreTime() {
		return creTime;
	}
	public void setCreTime(String creTime) {
		this.creTime = creTime;
	}
	@Column(name="REMARKS")
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	@Column(name="DATA_ORG_ID")
	public String getDataOrgId() {
		return dataOrgId;
	}
	public void setDataOrgId(String dataOrgId) {
		this.dataOrgId = dataOrgId;
	}
	@Column(name="DATA_DEPT_CODE")
	public String getDataDeptCode() {
		return dataDeptCode;
	}
	public void setDataDeptCode(String dataDeptCode) {
		this.dataDeptCode = dataDeptCode;
	}
	@Column(name="DATA_USER_ID")
	public String getDataUserId() {
		return dataUserId;
	}
	public void setDataUserId(String dataUserId) {
		this.dataUserId = dataUserId;
	}
	@Column(name="TS")
	public String getTs() {
		return ts;
	}
	public void setTs(String ts) {
		this.ts = ts;
	}
	@Column(name="DR")
	public String getDr() {
		return dr;
	}
	public void setDr(String dr) {
		this.dr = dr;
	}
	@Column(name="ATT_ID")
	public String getAttId() {
		return attId;
	}
	public void setAttId(String attId) {
		this.attId = attId;
	}
	@Column(name="LEADER_OPINION")
	public String getLeaderOpinion() {
		return leaderOpinion;
	}
	public void setLeaderOpinion(String leaderOpinion) {
		this.leaderOpinion = leaderOpinion;
	}
	
	@Column(name="ARC_TYPE")
	public String getArcType() {
		return arcType;
	}
	public void setArcType(String arcType) {
		this.arcType = arcType;
	}
	@Column(name="IS_BACK")
	public String getIsBack() {
		return isBack;
	}
	public void setIsBack(String isBack) {
		this.isBack = isBack;
	}
	
	

}
