//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// SearchBean-001     2016/12/21   hegd                 新建
//*********************************************************************
package com.yonyou.aco.arc.otherarc.entity;

/**
 * 
 * TODO: 搜索虚拟Bean 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2017年1月3日
 * @author hegd
 * @since 1.0.0
 */
public class SearchBean {

	private String sproName;
	private String sarcName;
	private String searchregYear;
	private String startTime;
	private String endTime;
	private String fileStart;
	private String invType;

	private String bidName;

	private String proCom;
    private String  selectIds;
	public String getSproName() {
		return sproName;
	}

	public void setSproName(String sproName) {
		this.sproName = sproName;
	}

	public String getSarcName() {
		return sarcName;
	}

	public void setSarcName(String sarcName) {
		this.sarcName = sarcName;
	}

	public String getSearchregYear() {
		return searchregYear;
	}

	public void setSearchregYear(String searchregYear) {
		this.searchregYear = searchregYear;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getFileStart() {
		return fileStart;
	}

	public void setFileStart(String fileStart) {
		this.fileStart = fileStart;
	}

	public String getProCom() {
		return proCom;
	}

	public void setProCom(String proCom) {
		this.proCom = proCom;
	}

	public String getInvType() {
		return invType;
	}

	public void setInvType(String invType) {
		this.invType = invType;
	}

	public String getBidName() {
		return bidName;
	}

	public void setBidName(String bidName) {
		this.bidName = bidName;
	}

	public String getSelectIds() {
		return selectIds;
	}

	public void setSelectIds(String selectIds) {
		this.selectIds = selectIds;
	}

}
