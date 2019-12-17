package com.yonyou.aco.mobile.util;

/**
 * 
 * 手机端常量接口类
 * 
 * @author hegd
 *
 */
public interface ConstantInterface {

	/** 手机端表格属性 **/
	public static final String TABLESCH = "["
			+ "{'name':'taskId','displayName':'流程任务ID','type':'0',"
			+ "'primaryKey':'0'," + "'description':'流程任务ID'},"
			+ "{'name':'bizid','displayName':'业务ID','type':'0',"
			+ "'primaryKey':'1'," + "'description':'业务ID'},{"
			+ "'name':'draft_depart_name'," + "'displayName':'部门名称',"
			+ "'type':'0'," + "'primaryKey':'0'," + "'description':'部门名称'"
			+ "},{" + "'name':'title'," + "'displayName':'标题'," + "'type':'0',"
			+ "'primaryKey':'0'," + "'description':'标题'" + "},{"
			+ "'name':'receiveUser'," + "'displayName':'送办人'," + "'type':'0',"
			+ "'primaryKey':'0'," + "'description':'送办人'" + "},{"
			+ "'name':'start_time'," + "'displayName':'发起时间'," + "'type':'0',"
			+ "'primaryKey':'0'," + "'description':'发起时间'" + "},{"
			+ "'name':'biz_type'," + "'displayName':'发文类型'," + "'type':'0',"
			+ "'primaryKey':'0'," + "'description':'发文类型'" + "}]";
	/** 平件 **/
	public static final String ORDINARY_FILE = "平件";
	/** 急件 **/
	public static final String EMERGENCY_FILE = "急件";
	/** 特急 **/
	public static final String URGENT_FILE = "特急";
	/** 公开 **/
	public static final String PUBLICITY = "公开";
	/** 内部  **/
	public static final String INTERNAL  = "内部";
	/** 未读 **/
	public static final String UNREAD  = "未读";
	/** 已读 **/
	public static final String READ  = "已读";
	/** 默认下载正文名称 **/
	public static final String FILENAME  = "默认模板.doc";
	
	
	

}
