package com.yonyou.aco.biz.entity;

import java.io.Serializable;

/**
 * 重构业务逻辑
 * @date 2017-04-25
 * 名称:表单配置信息虚拟实体类
 * Date, Author, Descriptions
 * ---------------------------------------------------------
 * @Date 2016年7月12日
 * @author 卢昭炜
 * @since 1.0.0
 */
public class BizReFormNodeBean implements Serializable {

	private static final long serialVersionUID = -7718791225010878340L;

	/** 表单节点关系表Id */
	private String id;
	/** 节点信息表Id(如果为null或者空字符串，是全局变量) */
	private String nodeInfoId_;
	/** 节点名称 */
	private String nodeInfoName_;
	/** 流程定义id */
	private String procDefId_;
	/** 业务解决方案id */
	private String solId_;
	/** 类别 */
	private String sfwType_;
	/** 业务表单id */
	private String formId_;
	/** 业务表单名称 */
	private String formName_;
	/** 表单对应的数据表名 */
	private String tableName_;
	/** 业务表单标志键 */
	private String formKey_;
	/** 作用域 1：节点表单 :2： 明细表单 3：开始表单 4：全局表单 */
	private String scope_;
	/** 表单类型 1自定义表单 2在线表单 */
	private Character formType_;
	/** 自定义表单URL */
	private String formUrl_;
	/** 自由表单Id */
	private String freeFormId_;

	public Character getFormType_() {
		return formType_;
	}

	public void setFormType_(Character formType_) {
		this.formType_ = formType_;
	}

	public String getFormUrl_() {
		return formUrl_;
	}

	public void setFormUrl_(String formUrl_) {
		this.formUrl_ = formUrl_;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getNodeInfoId_() {
		return nodeInfoId_;
	}

	public void setNodeInfoId_(String nodeInfoId_) {
		this.nodeInfoId_ = nodeInfoId_;
	}

	public String getNodeInfoName_() {
		return nodeInfoName_;
	}

	public void setNodeInfoName_(String nodeInfoName_) {
		this.nodeInfoName_ = nodeInfoName_;
	}

	public String getProcDefId_() {
		return procDefId_;
	}

	public void setProcDefId_(String procDefId_) {
		this.procDefId_ = procDefId_;
	}

	public String getSolId_() {
		return solId_;
	}

	public void setSolId_(String solId_) {
		this.solId_ = solId_;
	}

	public String getFormId_() {
		return formId_;
	}

	public void setFormId_(String formId_) {
		this.formId_ = formId_;
	}

	public String getFormName_() {
		return formName_;
	}

	public void setFormName_(String formName_) {
		this.formName_ = formName_;
	}

	public String getTableName_() {
		return tableName_;
	}

	public void setTableName_(String tableName_) {
		this.tableName_ = tableName_;
	}

	public String getFormKey_() {
		return formKey_;
	}

	public void setFormKey_(String formKey_) {
		this.formKey_ = formKey_;
	}

	public String getScope_() {
		return scope_;
	}

	public void setScope_(String scope_) {
		this.scope_ = scope_;
	}

	public String getFreeFormId_() {
		return freeFormId_;
	}

	public void setFreeFormId_(String freeFormId_) {
		this.freeFormId_ = freeFormId_;
	}

	public String getSfwType_() {
		return sfwType_;
	}

	public void setSfwType_(String sfwType_) {
		this.sfwType_ = sfwType_;
	}
}
