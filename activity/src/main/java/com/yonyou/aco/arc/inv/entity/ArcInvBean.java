package com.yonyou.aco.arc.inv.entity;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

/**
 * 
 * TODO: 项目投资档案虚拟Bean
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年12月29日
 * @author  hegd
 * @since   1.0.0
 */
public class ArcInvBean {

	private String id;
	
	/** 档案Id */
	private String arcId;
	/** 投资项目名称 */
	private String proName;
	/** 投资金额 */
	private String mny;
	/** 投资占比 */
	private String invPro;
	/** 投资形式 */
	private String invType;
	/** 投资时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date invTime;
	/** 资金来源 */
	private String bankSrc;
	/** 投资收益情况 */
	private String invIncm;
	/** 投资收益处置 */
	private String invDeal;
	/** 项目来源 */
	private String proSource;
	/** 项目金额 */
	private String proMny;
	/** 项目开始时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date startTime;
	/** 项目结束时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date endTime;
	/** 注册资本 */
	private String regCap;
	/** 注册时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date invRegTime;
	/** 法人 */
	private String legalPrsn;
	/** 懂事 */
	private String dir;
	/** 监事 */
	private String spvs;
	/** 注册地 */
	private String regAdd;
	/** 主营业务 */
	private String mainCore;
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
	/** 项目开始时间 */
	private String startDate;
	/** 项目结束时间 */
	private String endDate;
	/** 注册时间 */
	private String invRegDate;
	/** 投资时间 */
	private String invDate;
	/** 档案类型ID */
	private String arcTypeId;
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

	public String getMny() {
		return mny;
	}

	public void setMny(String mny) {
		this.mny = mny;
	}

	public String getInvPro() {
		return invPro;
	}

	public void setInvPro(String invPro) {
		this.invPro = invPro;
	}

	public String getInvType() {
		return invType;
	}

	public void setInvType(String invType) {
		this.invType = invType;
	}

	public Date getInvTime() {
		return invTime;
	}

	public void setInvTime(Date invTime) {
		this.invTime = invTime;
	}

	public String getBankSrc() {
		return bankSrc;
	}

	public void setBankSrc(String bankSrc) {
		this.bankSrc = bankSrc;
	}

	public String getInvIncm() {
		return invIncm;
	}

	public void setInvIncm(String invIncm) {
		this.invIncm = invIncm;
	}

	public String getInvDeal() {
		return invDeal;
	}

	public void setInvDeal(String invDeal) {
		this.invDeal = invDeal;
	}

	public String getProSource() {
		return proSource;
	}

	public void setProSource(String proSource) {
		this.proSource = proSource;
	}

	public String getProMny() {
		return proMny;
	}

	public void setProMny(String proMny) {
		this.proMny = proMny;
	}

	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public String getRegCap() {
		return regCap;
	}

	public void setRegCap(String regCap) {
		this.regCap = regCap;
	}

	public Date getInvRegTime() {
		return invRegTime;
	}

	public void setInvRegTime(Date invRegTime) {
		this.invRegTime = invRegTime;
	}

	public String getLegalPrsn() {
		return legalPrsn;
	}

	public void setLegalPrsn(String legalPrsn) {
		this.legalPrsn = legalPrsn;
	}

	public String getDir() {
		return dir;
	}

	public void setDir(String dir) {
		this.dir = dir;
	}

	public String getSpvs() {
		return spvs;
	}

	public void setSpvs(String spvs) {
		this.spvs = spvs;
	}

	public String getRegAdd() {
		return regAdd;
	}

	public void setRegAdd(String regAdd) {
		this.regAdd = regAdd;
	}

	public String getMainCore() {
		return mainCore;
	}

	public void setMainCore(String mainCore) {
		this.mainCore = mainCore;
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
		if(regTime!=null){
			regDate = sdf.format(regTime);
		}
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getFileDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if(fileTime!=null){
			fileDate =sdf.format(fileTime);
		}
		return fileDate;
	}

	public void setFileDate(String fileDate) {
		this.fileDate = fileDate;
	}

	public String getStartDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if(startTime!=null){
			startDate =sdf.format(startTime);
		}
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if(endTime!=null){
			endDate =sdf.format(endTime);
		}
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getInvRegDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if(invRegTime!=null){
			invRegDate =sdf.format(invRegTime);
		}
		return invRegDate;
	}

	public void setInvRegDate(String invRegDate) {
		this.invRegDate = invRegDate;
	}

	public String getInvDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if(invTime!=null){
			invDate = sdf.format(invTime);
		}
		return invDate;
	}

	public void setInvDate(String invDate) {
		this.invDate = invDate;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getArcTypeId() {
		return arcTypeId;
	}

	public void setArcTypeId(String arcTypeId) {
		this.arcTypeId = arcTypeId;
	}
	

}
