package com.yonyou.aco.docstatistics.entity;

import java.io.Serializable;

/**
 * 公文统计数
 * @author 葛鹏
 * 2017-03-10
 **/
public class DocStatisticsBean  implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 部门ID
	 */
	private String deptId;
	
	/**
	 * code
	 */
	private String deptCode;
	/**
	 * 部门名称
	 */
	private String deptName;
	
	/**
	 * 上级部门ID
	 */
	private String parentDeptId;
	
	/**
	 * 行文数量
	 */
	private String draftDocAmount;
	
	/**
	 * 流转数量
	 */
	private String commDocAmount;
	
	/**
	 * 本周-行文数
	 */
	private String weekDraftDocAmount;
	
	/**
	 * 本周-流转环节数
	 */
	private String weekcommDocAmount;
	
	/**
	 * 本月-行文数
	 */
	private String monthDraftDocAmount;
	
	/**
	 * 本月-流转环节数
	 */
	private String monthcommDocAmount;

	/**
	 * 排序号
	 */
	private int sort;
	public String getDeptId() {
		return deptId;
	}

	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}

	public String getDeptCode() {
		return deptCode;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}


	public String getDraftDocAmount() {
		return draftDocAmount;
	}

	public void setDraftDocAmount(String draftDocAmount) {
		this.draftDocAmount = draftDocAmount;
	}

	public String getCommDocAmount() {
		return commDocAmount;
	}

	public void setCommDocAmount(String commDocAmount) {
		this.commDocAmount = commDocAmount;
	}

	public String getParentDeptId() {
		return parentDeptId;
	}

	public void setParentDeptId(String parentDeptId) {
		this.parentDeptId = parentDeptId;
	}

	public String getWeekDraftDocAmount() {
		return weekDraftDocAmount;
	}

	public void setWeekDraftDocAmount(String weekDraftDocAmount) {
		this.weekDraftDocAmount = weekDraftDocAmount;
	}

	public String getWeekcommDocAmount() {
		return weekcommDocAmount;
	}

	public void setWeekcommDocAmount(String weekcommDocAmount) {
		this.weekcommDocAmount = weekcommDocAmount;
	}

	public String getMonthDraftDocAmount() {
		return monthDraftDocAmount;
	}

	public void setMonthDraftDocAmount(String monthDraftDocAmount) {
		this.monthDraftDocAmount = monthDraftDocAmount;
	}

	public String getMonthcommDocAmount() {
		return monthcommDocAmount;
	}

	public void setMonthcommDocAmount(String monthcommDocAmount) {
		this.monthcommDocAmount = monthcommDocAmount;
	}

	public int getSort() {
		return sort;
	}

	public void setSort(int sort) {
		this.sort = sort;
	}
	
}
