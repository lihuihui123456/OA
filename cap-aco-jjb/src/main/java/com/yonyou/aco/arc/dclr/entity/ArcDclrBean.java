package com.yonyou.aco.arc.dclr.entity;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ArcDclrBean {

	private String id;
	/** 档案Id */
	private String arcId;
	/** 项目名称 */
	private String proName;
	/** 申报时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date decTime;
	/** 承担部门 */
	private String bearDept;
	/** 申报人 */
	private String decUser;
	/** 金额 */
	private int decMny;
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
	/** 申报时间 */
	private String decDate;
	/** 归档时间 */
	private String fileDate;
	/** 立项单位 */
	private String proCom;

	/** 档案类型Id */
	private String arcTypeId;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getArcId() {
		return arcId;
	}

	public void setArcId(String arcId) {
		this.arcId = arcId;
	}

	public String getProName() {
		return proName;
	}

	public void setProName(String proName) {
		this.proName = proName;
	}

	public Date getDecTime() {
		return decTime;
	}

	public void setDecTime(Date decTime) {
		this.decTime = decTime;
	}

	public String getBearDept() {
		return bearDept;
	}

	public void setBearDept(String bearDept) {
		this.bearDept = bearDept;
	}

	public String getDecUser() {
		return decUser;
	}

	public void setDecUser(String decUser) {
		this.decUser = decUser;
	}

	public int getDecMny() {
		return decMny;
	}

	public void setDecMny(int decMny) {
		this.decMny = decMny;
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

	public String getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
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

	public String getDecDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if (decTime != null) {
			decDate = sdf.format(decTime);
		}
		return decDate;
	}

	public void setDecDate(String decDate) {
		this.decDate = decDate;
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

	public String getProCom() {
		return proCom;
	}

	public void setProCom(String proCom) {
		this.proCom = proCom;
	}

	public String getArcTypeId() {
		return arcTypeId;
	}

	public void setArcTypeId(String arcTypeId) {
		this.arcTypeId = arcTypeId;
	}

}
