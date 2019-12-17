package com.yonyou.aco.docquery.entity;
import java.io.Serializable;
import java.sql.Timestamp;
import org.springframework.format.annotation.DateTimeFormat;
public class SearchEntity implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 8243116288269279319L;
	
	private String id;

	private String bizTitle;

	private String bizType;

	private String createUserId;
	
	@DateTimeFormat(pattern="yyyy-mm-dd hh:mm:ss")
	private Timestamp createTime;

	private String state;

	private String urgency;

	private String createDeptId;

	private String serialNumber;

	private String archiveState;

	private String userName;

	private String deptName;
	
	private Timestamp signTime;
	
	private String orgName;
	
	private String docNo;
	
	private String docNoSw;
	
	private String docUnit;
	
	
	private String assignee;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}


	public String getBizTitle() {
		return bizTitle;
	}

	public void setBizTitle(String bizTitle) {
		this.bizTitle = bizTitle;
	}

	public String getBizType() {
		return bizType;
	}

	public void setBizType(String bizType) {
		this.bizType = bizType;
	}

	public String getCreateUserId() {
		return createUserId;
	}

	public void setCreateUserId(String createUserId) {
		this.createUserId = createUserId;
	}

	public Timestamp getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getUrgency() {
		return urgency;
	}

	public void setUrgency(String urgency) {
		this.urgency = urgency;
	}

	public String getCreateDeptId() {
		return createDeptId;
	}

	public void setCreateDeptId(String createDeptId) {
		this.createDeptId = createDeptId;
	}

	public String getSerialNumber() {
		return serialNumber;
	}

	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}

	public String getArchiveState() {
		return archiveState;
	}

	public void setArchiveState(String archiveState) {
		this.archiveState = archiveState;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	
	public Timestamp getSignTime() {
		return signTime;
	}

	public void setSignTime(Timestamp signTime) {
		this.signTime = signTime;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getDocNo() {
		return docNo;
	}

	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}

	public String getDocNoSw() {
		return docNoSw;
	}

	public void setDocNoSw(String docNoSw) {
		this.docNoSw = docNoSw;
	}

	public String getDocUnit() {
		return docUnit;
	}

	public void setDocUnit(String docUnit) {
		this.docUnit = docUnit;
	}

	public String getAssignee() {
		return assignee;
	}

	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}
	
	
	
}
