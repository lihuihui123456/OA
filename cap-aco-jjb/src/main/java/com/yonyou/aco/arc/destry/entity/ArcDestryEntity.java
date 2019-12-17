//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcDestryEntity-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.destry.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;
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
@Entity
@Table(name = "biz_arc_destry_ifno")
public class ArcDestryEntity  implements Serializable{
	private static final long serialVersionUID = 1L;
	/** 主键ID */
	  @Id
	  @Column(name="id", unique=true, length=64, nullable=false)
	  @GeneratedValue(generator="uuid")
	  @GenericGenerator(name="uuid", strategy="org.hibernate.id.UUIDGenerator")
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
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public Date getDestryTime() {
		return destryTime;
	}
	public void setDestryTime(Date destryTime) {
		this.destryTime = destryTime;
	}
	
}
