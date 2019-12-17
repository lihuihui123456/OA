//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcMtgSummAll-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.mtgsumm.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;
/**
 * 
 * 会议纪要基本信息表
 * 
 * Date, Author, Since
 * --------------------------------------------------------- 
 * @Date    2016-12-21
 * @author  lzh
 * @since   2.0.0
 */
public class ArcMtgSummAll {

	/** 档案ID */
	private String arcId;
	  /** 会议名称 */
    private String amsName;  
	/** 会议类型 */
	private String amsType;
	/** 会议时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date amsTime;
	private String amsTimeStr;
	/** 主持人 */
	private String amsEmcee;
	/** 会议地点 */
	private String amsAdd;
	/** 会议议题 */
	private String amsTopic;
	/** 召集部门*/
	private String smdDept;
	/** 参与部门*/
	private String iltDept;
	/** 单位ID */
	private String dataOrgId;
	/** 部门CODE */
	private String dataDeptCode;
	/** 用户ID */
	private String dataUserId;
	/** 租户ID */
	private String tenantId;
	/** 登记人id */
	private String regUser;
	/** 登记人名称 */
	private String regUserName;
	/** 登记部门 */
	private String regDept;
	/** 登记日期 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date regTime;
	private String regTimeStr;
	private String startRegTime;
	private String endRegTime;
	/** 年度*/
	private String yearNum;
	/** 公共表主键ID*/
	private String Id;
	/** 档案类型 */
	private String arcType;
	/** 档案名称 */
	private String arcName;
	/** 归档状态 */
	private String fileStart;
	/** 关键字 */
	private String keyWord;
	/** 存放位置 */
	private String depPos;
	/** 归档人 id*/
	private String fileUser;
	/** 归档人姓名 */
	private String fileUserName;
	/** 归档时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date fileTime;
	/** 有效期 */
	private String expiryDate;
	/** 是否作废销毁0：正常1：作废2：销毁 */
	private String isInvalid;
	/** 是否删除Y：删除N：未删除 */
	private String dr;
	/** 备注 */
	private String remarks;
	/**排序字段和排序方式*/
	private String attribute;
	private String orderBy;
	/** 选中的数据 */
	private String selectIds;
	public String getArcId() {
		return arcId;
	}
	public void setArcId(String arcId) {
		this.arcId = arcId;
	}
	
	public String getAmsName() {
		return amsName;
	}
	public void setAmsName(String amsName) {
		this.amsName = amsName;
	}
	public String getAmsType() {
		return amsType;
	}
	public void setAmsType(String amsType) {
		this.amsType = amsType;
	}

	public String getAmsEmcee() {
		return amsEmcee;
	}
	public void setAmsEmcee(String amsEmcee) {
		this.amsEmcee = amsEmcee;
	}
	public String getAmsAdd() {
		return amsAdd;
	}
	public void setAmsAdd(String amsAdd) {
		this.amsAdd = amsAdd;
	}
	public String getAmsTopic() {
		return amsTopic;
	}
	public void setAmsTopic(String amsTopic) {
		this.amsTopic = amsTopic;
	}
	public String getDataOrgId() {
		return dataOrgId;
	}
	public void setDataOrgId(String dataOrgId) {
		this.dataOrgId = dataOrgId;
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
	public String getRegUser() {
		return regUser;
	}
	public void setRegUser(String regUser) {
		this.regUser = regUser;
	}
	public String getRegDept() {
		return regDept;
	}
	public void setRegDept(String regDept) {
		this.regDept = regDept;
	}

	public String getArcType() {
		return arcType;
	}
	public void setArcType(String arcType) {
		this.arcType = arcType;
	}
	public String getArcName() {
		return arcName;
	}
	public void setArcName(String arcName) {
		this.arcName = arcName;
	}
	public String getKeyWord() {
		return keyWord;
	}
	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}
	public String getDepPos() {
		return depPos;
	}
	public void setDepPos(String depPos) {
		this.depPos = depPos;
	}
	public String getFileUser() {
		return fileUser;
	}
	public void setFileUser(String fileUser) {
		this.fileUser = fileUser;
	}

	public Date getAmsTime() {
		return amsTime;
	}
	public void setAmsTime(Date amsTime) {
		this.amsTime = amsTime;
	}
	public Date getRegTime() {
		return regTime;
	}
	public void setRegTime(Date regTime) {
		this.regTime = regTime;
	}
	public Date getFileTime() {
		return fileTime;
	}
	public void setFileTime(Date fileTime) {
		this.fileTime = fileTime;
	}
	public String getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}
	public String getIsInvalid() {
		return isInvalid;
	}
	public void setIsInvalid(String isInvalid) {
		this.isInvalid = isInvalid;
	}
	public String getDr() {
		return dr;
	}
	public void setDr(String dr) {
		this.dr = dr;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getFileStart() {
		return fileStart;
	}
	public void setFileStart(String fileStart) {
		this.fileStart = fileStart;
	}
	public String getStartRegTime() {
		return startRegTime;
	}
	public void setStartRegTime(String startRegTime) {
		this.startRegTime = startRegTime;
	}
	public String getEndRegTime() {
		return endRegTime;
	}
	public void setEndRegTime(String endRegTime) {
		this.endRegTime = endRegTime;
	}
	public String getId() {
		return Id;
	}
	public void setId(String id) {
		Id = id;
	}
	public String getSmdDept() {
		return smdDept;
	}
	public void setSmdDept(String smdDept) {
		this.smdDept = smdDept;
	}
	public String getIltDept() {
		return iltDept;
	}
	public void setIltDept(String iltDept) {
		this.iltDept = iltDept;
	}
	public String getYearNum() {
		return yearNum;
	}
	public void setYearNum(String yearNum) {
		this.yearNum = yearNum;
	}
	public String getRegTimeStr() {
		return regTimeStr;
	}
	public void setRegTimeStr(String regTimeStr) {
		this.regTimeStr = regTimeStr;
	}
	public String getAmsTimeStr() {
		return amsTimeStr;
	}
	public void setAmsTimeStr(String amsTimeStr) {
		this.amsTimeStr = amsTimeStr;
	}
	public String getRegUserName() {
		return regUserName;
	}
	public void setRegUserName(String regUserName) {
		this.regUserName = regUserName;
	}
	public String getFileUserName() {
		return fileUserName;
	}
	public void setFileUserName(String fileUserName) {
		this.fileUserName = fileUserName;
	}
	public String getAttribute() {
		return attribute;
	}
	public void setAttribute(String attribute) {
		this.attribute = attribute;
	}
	public String getOrderBy() {
		return orderBy;
	}
	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}
	public String getSelectIds() {
		return selectIds;
	}
	public void setSelectIds(String selectIds) {
		this.selectIds = selectIds;
	}

}
