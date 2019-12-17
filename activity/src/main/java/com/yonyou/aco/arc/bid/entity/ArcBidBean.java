package com.yonyou.aco.arc.bid.entity;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ArcBidBean {

	private String id;
	/** 档案Id */
	private String arcId;
	/** 项目名称 */
	private String bidName;
	/** 项目编号 */
	private String proNbr;
	/** 招标时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date bidTime;
	/** 中标单位 */
	private String bidCo;
	/** 单位联系人 */
	private String unitCntctUser;
	/** 单位联系方式 */
	private String unitCntct;
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
	/** 招标时间 */
	private String bidDate;
	/** 归档时间 */
	private String fileDate;
	/** 档案类型Id*/
	private String arcTypeId;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getArcId() {
		return this.arcId;
	}

	public void setArcId(String arcId) {
		this.arcId = arcId;
	}

	public String getBidName() {
		return this.bidName;
	}

	public void setBidName(String bidName) {
		this.bidName = bidName;
	}

	public String getProNbr() {
		return this.proNbr;
	}

	public void setProNbr(String proNbr) {
		this.proNbr = proNbr;
	}

	public String getBidCo() {
		return this.bidCo;
	}

	public void setBidCo(String bidCo) {
		this.bidCo = bidCo;
	}

	public String getUnitCntctUser() {
		return this.unitCntctUser;
	}

	public void setUnitCntctUser(String unitCntctUser) {
		this.unitCntctUser = unitCntctUser;
	}

	public String getUnitCntct() {
		return this.unitCntct;
	}

	public void setUnitCntct(String unitCntct) {
		this.unitCntct = unitCntct;
	}

	public String getRegUser() {
		return this.regUser;
	}

	public void setRegUser(String regUser) {
		this.regUser = regUser;
	}

	public String getRegDept() {
		return this.regDept;
	}

	public void setRegDept(String regDept) {
		this.regDept = regDept;
	}

	public String getArcType() {
		return this.arcType;
	}

	public void setArcType(String arcType) {
		this.arcType = arcType;
	}

	public String getArcName() {
		return this.arcName;
	}

	public void setArcName(String arcName) {
		this.arcName = arcName;
	}

	public String getKeyWord() {
		return this.keyWord;
	}

	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}

	public String getDepPos() {
		return this.depPos;
	}

	public void setDepPos(String depPos) {
		this.depPos = depPos;
	}

	public String getFileUser() {
		return this.fileUser;
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

	public Date getBidTime() {
		return bidTime;
	}

	public void setBidTime(Date bidTime) {
		this.bidTime = bidTime;
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

	public String getBidDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if (bidTime != null) {
			bidDate = sdf.format(bidTime);
		}
		return bidDate;
	}

	public void setBidDate(String bidDate) {
		this.bidDate = bidDate;
	}

	public String getFileDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if (fileTime != null) {
			bidDate = sdf.format(fileTime);
		}
		return fileDate;
	}

	public void setFileDate(String fileDate) {
		this.fileDate = fileDate;
	}

	public String getArcTypeId() {
		return arcTypeId;
	}

	public void setArcTypeId(String arcTypeId) {
		this.arcTypeId = arcTypeId;
	}
	
	

}