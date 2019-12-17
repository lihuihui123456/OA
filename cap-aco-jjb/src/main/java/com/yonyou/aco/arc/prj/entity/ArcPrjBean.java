package com.yonyou.aco.arc.prj.entity;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

/**
 * 
 * TODO: 工程基建档案虚拟Bean 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月29日
 * @author hegd
 * @since 1.0.0
 */
public class ArcPrjBean {

	private String id;

	/** 档案ID */
	private String arcId;
	/** 项目名称 */
	private String prjName;
	/** 项目地点 */
	private String prjAdd;
	/** 项目编号 */
	private String prjNbr;
	/** 项目联系人 */
	private String prjUser;
	/** 登记人 */
	private String regUser;
	/** 登记部门 */
	private String regDept;
	/** 登记时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date regTime;
	/** 档案类型 */
	private String arcType;
	/** 档案名称 */
	private String arcName;
	/** 关键字 */
	private String keyWord;
	/** 存放位置 */
	private String depPos;
	/** 归档人 */
	private String fileUser;
	/** 归档状态 */
	private String fileStart;
	/** 归档时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date fileTime;
	/** 有效期 */
	private String expiryDate;
	/** 备注 */
	private String remarks;
	/** 是否作废 */
	private String isInvalid;
	/** 登记日期 */
	private String regDate;
	/** 归档时间 */
	private String fileDate;

	/** 档案类型Id */
	private String arcTypeId;

	public String getArcId() {
		return arcId;
	}

	public void setArcId(String arcId) {
		this.arcId = arcId;
	}

	public String getPrjName() {
		return prjName;
	}

	public void setPrjName(String prjName) {
		this.prjName = prjName;
	}

	public String getPrjAdd() {
		return prjAdd;
	}

	public void setPrjAdd(String prjAdd) {
		this.prjAdd = prjAdd;
	}

	public String getPrjNbr() {
		return prjNbr;
	}

	public void setPrjNbr(String prjNbr) {
		this.prjNbr = prjNbr;
	}

	public String getPrjUser() {
		return prjUser;
	}

	public void setPrjUser(String prjUser) {
		this.prjUser = prjUser;
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

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}

	public String getArcTypeId() {
		return arcTypeId;
	}

	public void setArcTypeId(String arcTypeId) {
		this.arcTypeId = arcTypeId;
	}

	

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getIsInvalid() {
		return isInvalid;
	}

	public void setIsInvalid(String isInvalid) {
		this.isInvalid = isInvalid;
	}

	public String getRegDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if (regTime != null) {
			regDate = sdf.format(regTime);
		}
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getFileDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if (fileTime != null) {
			fileDate = sdf.format(fileTime);
		}
		return fileDate;
	}

	public void setFileDate(String fileDate) {
		this.fileDate = fileDate;
	}

}
