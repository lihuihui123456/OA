//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：徐真$手机：18611123594#
// SVN版本号                    日   期                 作     者              变更记录
// ISInvalid-001     2016/12/23   张多一                  新建
//*********************************************************************
package com.yonyou.aco.arc.doc.entity;
/**
 * <p>概述：是否作废枚举类型
 * <p>功能：建立是否作废中文和值的对应关系
 * <p>作者：张多一
 * <p>创建时间：2016-12-23
 * <p>类调用特殊情况：在类型转换时调用
 */
public enum ISInvalid {
	ZHENGCHANG("正常","0"),ZUOFEI("作废","1"),XIAOHUI("销毁","2");
	private String chname;
	private String value;
	private ISInvalid(String chname, String value) {
		this.chname = chname;
		this.value = value;
	}
	/**
	 * 根据值获取一个是否作废
	 * @param value
	 * @return 如果没有返回null
	 */
	public static ISInvalid getISInvalidByValue(String value){
		for(ISInvalid temp: ISInvalid.values()){
			if(temp.getValue().equals(value)){
				return temp;
			}
		}
		return null;
	}
	
	/**
	 * 根据中文名获取是否作废
	 * @param chname
	 * @return 如果没有返回null
	 */
	public static ISInvalid getISInvalidByChname(String chname){
		for(ISInvalid temp: ISInvalid.values()){
			if(temp.getChname().equals(chname)){
				return temp;
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
