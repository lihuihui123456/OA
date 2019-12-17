//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：徐真$手机：18611123594#
// SVN版本号                    日   期                 作     者              变更记录
// DocType-001     2016/12/23   张多一                  新建
//*********************************************************************
package com.yonyou.aco.arc.doc.entity;

/**
 * <p>概述：公文类型枚举类型
 * <p>功能：建立公文类型中文和值的对应关系
 * <p>作者：张多一
 * <p>创建时间：2016-12-23
 * <p>类调用特殊情况：在类型转换时调用
 */
public enum DocType {
	TONGZHI("通知","1"),QINGSHI("请示","2"),BAOGAO("报告","3"),YIJIAN("意见","4"),TONGBAO("通报","5");
	
	private String chname;
	private String value;
	private DocType(String chname, String value) {
		this.chname = chname;
		this.value = value;
	}
	/**
	 * 根据index获取中文名
	 * @param index 中文名对应的值
	 * @return 如果没有返回null
	 */
	public static String getCHNameByIndex(String index){
		for(DocType temp: DocType.values()){
			if(temp.getValue().equals(index)){
				return temp.getChname();
			}
		}
		return null;
	}
	
	/**根据值获取这个枚举
	 * @param index
	 * @return 如果没有返回null
	 */
	public static DocType getTypeByIndex(String index){
		for(DocType temp: DocType.values()){
			if(temp.getValue().equals(index)){
				return temp;
			}
		}
		return null;
	}
	
	
	/**
	 * 根据中文返回对应的值
	 * @param chname
	 * @return 如果没有返回null
	 */
	public static DocType getTypeByCHName(String chname){
		for(DocType temp: DocType.values()){
			if(temp.getValue().equals(chname)){
				return temp;
			}
		}
		return null;
	}
	
	/**
	 * 根据中文返回对应的值
	 * @param chname
	 * @return 如果没有返回null
	 */
	public static String getTypeValueByCHName(String chname){
		for(DocType temp: DocType.values()){
			if(temp.getValue().equals(chname)){
				return temp.getChname();
			}
		}
		return null;
	}
	
	public String getChname() {
		return chname;
	}
	public void setChname(String chname) {
		this.chname = chname;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	
}
