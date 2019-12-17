//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ExcelUtil-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.earc.util;

import java.util.List;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
/**
 * <p>
 * 概述：导出excel公共类
 * <p>
 * 功能：获取excel工具
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-12-21
 * <p>
 * 类调用特殊情况：无
 */
public class ExcelUtil {
	/**
	 * 导出excel数据
	 * @param dataList
	 * @param fieldNames
	 * @param fields
	 * @return
	 * @throws Exception
	 */
	public static HSSFWorkbook generateExcelFile(List<?> dataList, String[] fieldNames, String[] fields
			) throws Exception {
		
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet("sheet1");
		HSSFRow row = sheet.createRow(0); // 创建第1行，也就是输出表头
		HSSFCellStyle headcellstyle = workbook.createCellStyle(); 
		headcellstyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM); //下边框    
		headcellstyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);//左边框    
		headcellstyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM); // 上边边框
		headcellstyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);//右边框   
		headcellstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER); 
		HSSFCell cell;
		//每行添加序号列
		cell = row.createCell(0); // 创建第0列
		cell.setCellStyle(headcellstyle);
		cell.setCellValue(new HSSFRichTextString("序号"));
		for (int i = 0; i < fieldNames.length; i++) {
			cell = row.createCell(i+1); // 创建第i列
			cell.setCellStyle(headcellstyle);
			cell.setCellValue(new HSSFRichTextString(fieldNames[i]));
		}
		
		for (int i = 0; i < dataList.size(); i++) {
			Object obj = dataList.get(i);
			row = sheet.createRow(i + 1);// 创建第i+1行
			//每行添加序号列
			cell = row.createCell(0); // 创建第0列
			cell.setCellValue(i+1);
			cell.setCellStyle(headcellstyle);
			for (int j = 0; j < fields.length; j++) {
				cell = row.createCell(j+1);// 创建第j列	
				cell.setCellStyle(headcellstyle);
				Object result = PropertyUtils.getProperty(obj, fields[j]);
				if (null == result) {
					cell.setCellValue("");
				} else {
					cell.setCellValue(String.valueOf(result));
				}
			}
		}
		return workbook;
	}
	/**
	 * 导出excel数据
	 * @param dataList
	 * @param headList
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public static HSSFWorkbook generateExcelFile(List<Object> dataList,List<String> headList
			) throws Exception {
		
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFCellStyle headcellstyle = workbook.createCellStyle(); 
		headcellstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER); 
		HSSFSheet sheet = workbook.createSheet("sheet1");
		HSSFRow row = sheet.createRow(0); // 创建第1行，也就是输出表头
		row.setRowStyle(headcellstyle);
		HSSFCell cell;
		//每行添加序号列
		cell = row.createCell(0); // 创建第0列
		cell.setCellStyle(headcellstyle);
		cell.setCellValue(new HSSFRichTextString("序号"));
		for (int i = 0; i < headList.size(); i++) {
			cell = row.createCell(i+1); // 创建第i列
			cell.setCellStyle(headcellstyle);
			cell.setCellValue(new HSSFRichTextString(headList.get(i)));
		}
		
		for (int i = 0; i < dataList.size(); i++) {
			List<String> obj = (List<String>) dataList.get(i);
			row = sheet.createRow(i + 1);// 创建第i+1行
			//每行添加序号列
			cell = row.createCell(0); // 创建第0列
			cell.setCellValue(i+1);
			cell.setCellStyle(headcellstyle);
			for (int j = 0; j < obj.size(); j++) {
				cell = row.createCell(j+1);// 创建第j列	
				cell.setCellValue(new HSSFRichTextString(obj.get(j)));
			}
		}
		return workbook;
	}
}

