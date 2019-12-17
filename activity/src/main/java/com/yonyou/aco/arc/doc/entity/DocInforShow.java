//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：徐真$手机：18611123594#
// SVN版本号                    日   期                 作     者              变更记录
// DocInforShow-001     2016/12/21   张多一                  新建
//*********************************************************************
package com.yonyou.aco.arc.doc.entity;

import java.io.Serializable;

import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
/**
 * <p>概述：前天展示档案文书信息，
 * <p>功能：将档案文书和公共新表整合
 * <p>作者：张多一
 * <p>创建时间：2016-07-11
 * <p>类调用特殊情况：无
 */
public class DocInforShow implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -4362397211316571461L;
	
	/**
	 * docinfor 记录信息
	 */
	public DocInfor docInfor;
	
	/**
	 * arcpubinfor 记录信息
	 */
	public ArcPubInfoEntity arcPubInfor;
	
	public String regUserName;
	
	public String regDeptName;
	
	public String fileUserName;
	
	public String regTime;

	public DocInfor getDocInfor() {
		return docInfor;
	}

	public void setDocInfor(DocInfor docInfor) {
		this.docInfor = docInfor;
	}

	public ArcPubInfoEntity getArcPubInfor() {
		return arcPubInfor;
	}

	public void setArcPubInfor(ArcPubInfoEntity arcPubInfor) {
		this.arcPubInfor = arcPubInfor;
	}

	public String getRegUserName() {
		return regUserName;
	}

	public void setRegUserName(String regUserName) {
		this.regUserName = regUserName;
	}

	public String getRegDeptName() {
		return regDeptName;
	}

	public void setRegDeptName(String regDeptName) {
		this.regDeptName = regDeptName;
	}

	public String getFileUserName() {
		return fileUserName;
	}

	public void setFileUserName(String fileUserName) {
		this.fileUserName = fileUserName;
	}

	public String getRegTime() {
		return regTime;
	}

	public void setRegTime(String regTime) {
		this.regTime = regTime;
	}
	
}
