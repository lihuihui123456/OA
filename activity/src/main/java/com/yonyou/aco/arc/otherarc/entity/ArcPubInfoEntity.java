//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcPubInfoEntity-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.otherarc.entity;

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
 * 
 * 档案基本信息表,存储所有档案的公共信息
 * 
 * Date, Author, Since ---------------------------------------------------------
 * 
 * @Date 2016-12-21
 * @author lzh
 * @since 2.0.0
 */
@Entity
@Table(name = "biz_arc_pub_info")
public class ArcPubInfoEntity implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "Id", unique = true, length = 64, nullable = false)
	@GeneratedValue(generator = "uuid")
	@GenericGenerator(name = "uuid", strategy = "org.hibernate.id.UUIDGenerator")
	/** 主键ID*/
	private String Id;
	/** 档案ID */
	private String arcId;
	/** 登记人 */
	private String regUser;
	/** 登记部门 */
	private String regDept;
	/** 登记日期 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date regTime;
	/** 档案类型 */
	private String arcType;
	@Transient
	private String arcTypeName;
	/** 档案名称 */
	private String arcName;
	/** 关键字 */
	private String keyWord;
	/** 存放位置 */
	private String depPos;
	/** 文件类型 */
	private String fileType;
	/** 归档人 */
	private String fileUser;
	/** 归档状态 '归档状态0:未归档1:已归档2：追加归档', */
	private String fileStart;
	/** 归档部门ID */
	private String fileDept;

	/** 归档时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date fileTime;
	/** 有效期 */
	private String expiryDate;
	/** 有效期 */
	private Date expiryDateTime;
	/** 是否作废销毁0：正常1：作废2：销毁 */
	private String isInvalid;
	/** 是否删除Y：删除N：未删除 */
	private String dr;
	/** 备注 */
	private String remarks;
	/** 单位Id */
	private String dataOrgId;
	/** 部门Id */
	private String dataDeptId;
	/** 部门CODE */
	private String dataDeptCode;
	/** 用户ID */
	private String dataUserId;
	/** 租户ID */
	private String tenantId;
	/** 时间戳 */
	private String ts;

	public String getId() {
		return Id;
	}

	public void setId(String id) {
		Id = id;
	}

	@Column(name = "ARC_ID")
	public String getArcId() {
		return arcId;
	}

	public void setArcId(String arcId) {
		this.arcId = arcId;
	}

	@Column(name = "REG_USER")
	public String getRegUser() {
		return regUser;
	}

	public void setRegUser(String regUser) {
		this.regUser = regUser;
	}

	@Column(name = "REG_DEPT")
	public String getRegDept() {
		return regDept;
	}

	public void setRegDept(String regDept) {
		this.regDept = regDept;
	}

	@Column(name = "REG_TIME")
	public Date getRegTime() {
		return regTime;
	}

	public void setRegTime(Date regTime) {
		this.regTime = regTime;
	}

	@Column(name = "ARC_TYPE")
	public String getArcType() {
		return arcType;
	}

	public void setArcType(String arcType) {
		this.arcType = arcType;
	}

	@Column(name = "ARC_NAME")
	public String getArcName() {
		return arcName;
	}

	public void setArcName(String arcName) {
		this.arcName = arcName;
	}

	@Column(name = "KEY_WORD")
	public String getKeyWord() {
		return keyWord;
	}

	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}

	@Column(name = "DEP_POS")
	public String getDepPos() {
		return depPos;
	}

	public void setDepPos(String depPos) {
		this.depPos = depPos;
	}

	@Column(name = "FILE_TYPE")
	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	@Column(name = "FILE_USER")
	public String getFileUser() {
		return fileUser;
	}

	public void setFileUser(String fileUser) {
		this.fileUser = fileUser;
	}

	@Column(name = "FILE_START")
	public String getFileStart() {
		return fileStart;
	}

	public void setFileStart(String fileStart) {
		this.fileStart = fileStart;
	}

	@Column(name = "FILE_TIME")
	public Date getFileTime() {
		return fileTime;
	}

	public void setFileTime(Date fileTime) {
		this.fileTime = fileTime;
	}

	@Column(name = "EXPIRY_DATE")
	public String getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}

	@Column(name = "IS_INVALID")
	public String getIsInvalid() {
		return isInvalid;
	}

	public void setIsInvalid(String isInvalid) {
		this.isInvalid = isInvalid;
	}

	@Column(name = "DR")
	public String getDr() {
		return dr;
	}

	public void setDr(String dr) {
		this.dr = dr;
	}

	@Column(name = "REMARKS")
	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Date getExpiryDateTime() {
		return expiryDateTime;
	}

	public void setExpiryDateTime(Date expiryDateTime) {
		this.expiryDateTime = expiryDateTime;
	}

	public String getArcTypeName() {
		return arcTypeName;
	}

	public void setArcTypeName(String arcTypeName) {
		this.arcTypeName = arcTypeName;
	}

	public String getFileDept() {
		return fileDept;
	}

	public void setFileDept(String fileDept) {
		this.fileDept = fileDept;
	}

	public String getDataOrgId() {
		return dataOrgId;
	}

	public void setDataOrgId(String dataOrgId) {
		this.dataOrgId = dataOrgId;
	}

	public String getDataDeptId() {
		return dataDeptId;
	}

	public void setDataDeptId(String dataDeptId) {
		this.dataDeptId = dataDeptId;
	}

	public String getDataDeptCode() {
		return dataDeptCode;
	}

	public void setDataDeptCode(String dataDeptCode) {
		this.dataDeptCode = dataDeptCode;
	}

	public String getDataUserId() {
		return dataUserId;
	}

	public void setDataUserId(String dataUserId) {
		this.dataUserId = dataUserId;
	}

	public String getTenantId() {
		return tenantId;
	}

	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}

	public String getTs() {
		return ts;
	}

	public void setTs(String ts) {
		this.ts = ts;
	}

}
