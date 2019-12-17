//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcDestryAll-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.destry.entity;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;
/**
 * 
 * 销毁管理基本信息表
 * 
 * Date, Author, Since
 * --------------------------------------------------------- 
 * @Date    2016-12-28
 * @author  lzh
 * @since   2.0.0
 */
public class ArcDestryAll {
	/** 主键ID */
	private String id;
	/** 单号 */
	private String nbr;
	/** 单号日期 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date nbrTime;
	/**销毁时间**/
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date destryTime;
	/** 档案名称 */
	private String arcName;
	/** 档案ID */
	private String arcId;
	/** 档案有效期 */
	private int arcExpiryDate;
	/** 操作员 */
	private String oper;
	/** 操作日期 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date operTime;
	private String operStartTime;
	private String operEndTime;
	private String operTimeStr;
	/** 备注 */
	private String remarks;
	/** 单位ID */
	private String dataOrgId;
	/** 部门CODE */
	private String dataDeptCode;
	/** 用户ID */
	private String dataUserId;
	/** 租户ID */
	private String tenantId;
	/** 时间戳 */
	private String ts;
	/** 删除 Y已删除 N未删除 */
	private String dr;
	/** 登记人 */
	private String regUser;
	/** 登记部门 */
	private String regDept;
	/** 登记日期 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date regTime;
	/** 档案类型 */
	private String arcType;
	/** 档案类型名称 */
	private String typeName;
	/** 关键字 */
	private String keyWord;
	/** 存放位置 */
	private String depPos;
	/** 文件类型 */
	private String fileType;
	/** 归档人 */
	private String fileUser;
	/** 归档状态 */
	private String fileStart;
	/** 归档时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date fileTime;
	private String fileStartTime;
	private String fileEndTime;
	/** 有效期 */
	private String expiryDate;
	
	/**到期时间*/
	private Date expiryDateTime;
	
	private String closingDate;
	
	/** 是否作废销毁0：正常1：作废2：销毁 */
	private String isInvalid;
	private String sortName;
	private String sortOrder;
	private String selectIds;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNbr() {
		return nbr;
	}
	public void setNbr(String nbr) {
		this.nbr = nbr;
	}
	public Date getNbrTime() {
		return nbrTime;
	}
	public void setNbrTime(Date nbrTime) {
		this.nbrTime = nbrTime;
	}
	public String getArcName() {
		return arcName;
	}
	public void setArcName(String arcName) {
		this.arcName = arcName;
	}
	public String getArcId() {
		return arcId;
	}
	public void setArcId(String arcId) {
		this.arcId = arcId;
	}
	public int getArcExpiryDate() {
		return arcExpiryDate;
	}
	public void setArcExpiryDate(int arcExpiryDate) {
		this.arcExpiryDate = arcExpiryDate;
	}
	public String getOper() {
		return oper;
	}
	public void setOper(String oper) {
		this.oper = oper;
	}
	public Date getOperTime() {
		return operTime;
	}
	public void setOperTime(Date operTime) {
		this.operTime = operTime;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
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
	public Date getRegTime() {
		return regTime;
	}
	public void setRegTime(Date regTime) {
		this.regTime = regTime;
	}
	public String getArcType() {
		return arcType;
	}
	public void setArcType(String arcType) {
		this.arcType = arcType;
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
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getFileUser() {
		return fileUser;
	}
	public void setFileUser(String fileUser) {
		this.fileUser = fileUser;
	}
	public String getFileStart() {
		return fileStart;
	}
	public void setFileStart(String fileStart) {
		this.fileStart = fileStart;
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
	public String getOperStartTime() {
		return operStartTime;
	}
	public void setOperStartTime(String operStartTime) {
		this.operStartTime = operStartTime;
	}
	public String getOperEndTime() {
		return operEndTime;
	}
	public void setOperEndTime(String operEndTime) {
		this.operEndTime = operEndTime;
	}
	public String getFileStartTime() {
		return fileStartTime;
	}
	public void setFileStartTime(String fileStartTime) {
		this.fileStartTime = fileStartTime;
	}
	public String getFileEndTime() {
		return fileEndTime;
	}
	public void setFileEndTime(String fileEndTime) {
		this.fileEndTime = fileEndTime;
	}
	public String getTypeName() {
		return typeName;
	}
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
	public Date getDestryTime() {
		return destryTime;
	}
	public void setDestryTime(Date destryTime) {
		this.destryTime = destryTime;
	}
	public String getOperTimeStr() {
		return operTimeStr;
	}
	public void setOperTimeStr(String operTimeStr) {
		this.operTimeStr = operTimeStr;
	}
	public Date getExpiryDateTime() {
		return expiryDateTime;
	}
	public void setExpiryDateTime(Date expiryDateTime) {
		this.expiryDateTime = expiryDateTime;
	}
	public String getClosingDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if(expiryDateTime!=null){
			closingDate = sdf.format(expiryDateTime);
		}
		return closingDate;
	}
	public void setClosingDate(String closingDate) {
		this.closingDate = closingDate;
	}
	public String getSortName() {
		return sortName;
	}
	public void setSortName(String sortName) {
		this.sortName = sortName;
	}
	public String getSortOrder() {
		return sortOrder;
	}
	public void setSortOrder(String sortOrder) {
		this.sortOrder = sortOrder;
	}
	public String getSelectIds() {
		return selectIds;
	}
	public void setSelectIds(String selectIds) {
		this.selectIds = selectIds;
	}
	


	
}
