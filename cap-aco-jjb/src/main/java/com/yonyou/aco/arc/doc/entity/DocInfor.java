//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：徐真$手机：18611123594#
// SVN版本号                    日   期                 作     者              变更记录
// DocInfor-001     2016/12/21   张多一                  新建
//*********************************************************************
package com.yonyou.aco.arc.doc.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * <p>概述：档案文书登记表实体
 * <p>功能：档案文书登记表实体
 * <p>作者：张多一
 * <p>创建时间：2016-12-21
 * <p>类调用特殊情况：无
 */
@Entity
@Table(name = "biz_arc_doc_info")
public class DocInfor implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1614566002974655114L;
	
	/**
	 * 档案ID
	 */
	private String arcId;
	
	/**
	 * 公文类型
	 */
	private String docType;
	
	/**
	 * 来文单位
	 */
	private String docCo;
	
	/**
	 * 文号
	 */
	private String docNBR;
	
	/**
	 * 页数
	 */
	private String pageNum;
	
	/**
	 * 接收时间
	 */
	private String recTime;
	
	/**
	 * 截止日期
	 */
	private String endTime;
	
	/**
	 * 发文时间
	 */
	private String dptTime;
	
	/**
	 * 单位ID
	 */
	private String dataOrgId;
	
	/**
	 * 部门CODE
	 */
	private String dataDeptCode;
	
	/**
	 * 用户ID
	 */
	private String dataUserId;
	
	/** 时间戳 */
	private String ts;
	
	@Id
	public String getArcId() {
		return arcId;
	}
	public void setArcId(String acrId) {
		this.arcId = acrId;
	}
	@Column(name = "DOC_TYPE")
	public String getDocType() {
		return docType;
	}
	public void setDocType(String docType) {
		this.docType = docType;
	}

	@Column(name = "DOC_CO")
	public String getDocCo() {
		return docCo;
	}
	public void setDocCo(String docCo) {
		this.docCo = docCo;
	}
	@Column(name = "DOC_NBR")
	public String getDocNBR() {
		return docNBR;
	}
	public void setDocNBR(String docNBR) {
		this.docNBR = docNBR;
	}
	@Column(name = "PAGE_NUM")
	public String getPageNum() {
		return pageNum;
	}
	public void setPageNum(String pageNum) {
		this.pageNum = pageNum;
	}
	@Column(name = "REC_TIME")
	public String getRecTime() {
		return recTime;
	}
	public void setRecTime(String recTime) {
		this.recTime = recTime;
	}
	@Column(name = "END_TIME")
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	@Column(name = "DATA_ORG_ID")
	public String getDataOrgId() {
		return dataOrgId;
	}
	public void setDataOrgId(String dataOrgId) {
		this.dataOrgId = dataOrgId;
	}
	@Column(name = "DATA_DEPT_CODE")
	public String getDataDeptCode() {
		return dataDeptCode;
	}
	public void setDataDeptCode(String dataOrgCode) {
		this.dataDeptCode = dataOrgCode;
	}
	@Column(name = "DATA_USER_ID")
	public String getDataUserId() {
		return dataUserId;
	}
	public void setDataUserId(String dataUserId) {
		this.dataUserId = dataUserId;
	}
	@Column(name = "TS")
	public String getTs() {
		return ts;
	}
	public void setTs(String ts) {
		this.ts = ts;
	}
	@Column(name ="DTP_TIME")
	public String getDptTime() {
		return dptTime;
	}
	public void setDptTime(String dptTime) {
		this.dptTime = dptTime;
	}
	

}
