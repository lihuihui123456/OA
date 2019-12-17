//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcMtgSummEntity-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.mtgsumm.entity;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
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
@Entity
@Table(name = "biz_arc_mtg_summ")
public class ArcMtgSummEntity implements Serializable{

	private static final long serialVersionUID = 1L;
	/** 档案ID */
	  @Id
	  @Column(name="arc_id", unique=true, length=64, nullable=false)
	private String arcId;
	  /** 会议名称 */
    private String amsName;  
	/** 会议类型 */
	private String amsType;
	/** 会议时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date amsTime;
	/** 主持人 */
	private String amsEmcee;
	/** 会议地点 */
	private String amsAdd;
	/** 会议议题 */
	private String amsTopic;
	/** 单位ID */
	private String dataOrgId;
	/** 部门CODE */
	private String dataDeptCode;
	/** 用户ID */
	private String dataUserId;
	/** 租户ID */
	private String tenantId;
	/** 召集部门*/
	private String smdDept;
	/** 参与部门*/
	private String iltDept;
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

	public Date getAmsTime() {
		return amsTime;
	}
	public void setAmsTime(Date amsTime) {
		this.amsTime = amsTime;
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
	public String getTs() {
		return ts;
	}
	public void setTs(String ts) {
		this.ts = ts;
	}
	/** 时间戳 */
	private String ts;
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

}
