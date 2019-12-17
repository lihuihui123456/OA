package com.yonyou.aco.contacts.service.Impl;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

import javax.annotation.Resource;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.stereotype.Service;

import com.yonyou.aco.contacts.dao.IBizContactsDao;
import com.yonyou.aco.contacts.entity.BizContactsUserBean;
import com.yonyou.aco.contacts.entity.ContactsUserBean;
import com.yonyou.aco.contacts.entity.ContactsUserInfoBean;
import com.yonyou.aco.contacts.service.IBizContactsService;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.ConfigProvider;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.org.dao.IDeptDao;
import com.yonyou.cap.isc.org.dao.IOrgDao;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.service.IUserService;

/**
 * 
 * ClassName: BizContactsServiceImpl
 * 
 * @Description: 通讯录-
 * @author hegd
 * @date 2016-8-17
 */
@Service("iBizContactsService")
public class BizContactsServiceImpl extends BaseDao implements
		IBizContactsService {

	@Resource
	IBizContactsDao iBizContactsDao;

	@Resource
	IUserService iUserService;

	@Resource
	IOrgDao orgDao;
	@Resource
	IDeptDao deptDao;
	@Override
	public List<BizContactsUserBean> findMobileBizContactsUserInfo(String userId) {
		String orgId = iBizContactsDao.findOrgIdByUserId(userId);
		if (orgId != null || !"".equals(userId)) {
			return iBizContactsDao.findMobileBizContactsUserInfo(userId, orgId);
		} else {
			return null;
		}

	}

	@Override
	public List<Dept> findDeptList() {
		
		return iBizContactsDao.findDeptList();
	}


	@Override
	public PageResult<ContactsUserBean> findUserByDept(int pageNum, int pageSize,
			String deptId,String word,String param) {
		return iBizContactsDao.findUserByDept(pageNum,pageSize,deptId,word,param);
	}

	@Override
	public void addAlwaysContactors(String userIds,ShiroUser user) {
		iBizContactsDao.addAlwaysContactors(userIds,user);
	}

	@Override
	public PageResult<ContactsUserBean> findAlwaysContactors(int pageNum,int pageSize,String word,String param,ShiroUser user) {
		return iBizContactsDao.findAlwaysContactors(pageNum,pageSize,word,param,user);
	}

	@Override
	public String exportContactsUserToExcelByPoi(List<ContactsUserBean> list) {
		//创建HSSFWorkbook对象(excel的文档对象)  
		HSSFWorkbook wb = new HSSFWorkbook(); 
		//建立新的sheet对象（excel的表单）  
		HSSFSheet sheet=wb.createSheet("通讯录");  
		//设置缺省列高sheet.setDefaultColumnWidth(20);//设置缺省列宽
		sheet.setDefaultRowHeightInPoints(20);
		//设置指定列的列宽，256 * 50这种写法是因为width参数单位是单个字符的256分之一  
		//在sheet里创建第一行，参数为行索引(excel的行)，可以是0～65535之间的任何一个  
		HSSFRow titleRow=sheet.createRow(0); 
		titleRow.setHeightInPoints(30);
		//创建单元格（excel的单元格，参数为列索引，可以是0～255之间的任何一个  
		HSSFCell cell=titleRow.createCell(0);  
		 //设置单元格内容  
		cell.setCellValue("通讯录");  
		HSSFCellStyle titleStyle=wb.createCellStyle(); 
		//水平居中
		titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);  
		//垂直居中
		titleStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		//设置边框
		setBorder(titleStyle);
		HSSFFont  titleFontStyle=wb.createFont(); 
		//设置字体样式  
		titleFontStyle.setFontName("宋体");    
		//设置字体高度  
		titleFontStyle.setFontHeightInPoints((short)20);    
		//设置字体颜色  
		titleFontStyle.setColor(HSSFColor.BLACK.index);  
		//设置粗体  
		titleFontStyle.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		titleStyle.setFont(titleFontStyle);
		cell.setCellStyle(titleStyle);
		//合并单元格CellRangeAddress构造参数依次表示起始行，截至行，起始列， 截至列  
		String[] titleStr={"序号","姓名","部门","电话","手机","电子邮件"};
		sheet.addMergedRegion(new CellRangeAddress(0,0,0,titleStr.length-1)); 
		sheet.setColumnWidth(0, 10*256);
		for(int i=0;i<titleStr.length;i++){
			sheet.setColumnWidth(i+1, 35*256);
		}
		HSSFRow sectitleRow=sheet.createRow(1); 
		sectitleRow.setHeightInPoints(25);
		HSSFCellStyle secondTitleStyle=wb.createCellStyle(); 
		//水平居中
		secondTitleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);  
		//垂直居中
		secondTitleStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		//设置边框
		setBorder(secondTitleStyle);
		HSSFFont  secTitleFontStyle=wb.createFont(); 
		//设置字体样式  
		secTitleFontStyle.setFontName("微软雅黑");    
		//设置字体高度  
		secTitleFontStyle.setFontHeightInPoints((short)12);    
		//设置字体颜色  
		secTitleFontStyle.setColor(HSSFColor.BLACK.index);  
		//设置粗体  
		secTitleFontStyle.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		
		secondTitleStyle.setFont(secTitleFontStyle);
		for(int i=0;i<titleStr.length;i++){
			Cell cellTitle=sectitleRow.createCell(i);
			cellTitle.setCellValue(titleStr[i]);
			cellTitle.setCellStyle(secondTitleStyle);
		}
		HSSFCellStyle textCenterStyle=wb.createCellStyle(); 
		textCenterStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);  
		textCenterStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		HSSFCellStyle textLeftStyle=wb.createCellStyle(); 
		textLeftStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);  
		textLeftStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		//设置边框
		setBorder(textCenterStyle);
		setBorder(textLeftStyle);
		HSSFFont  textFontStyle=wb.createFont(); 
		//设置字体样式  
		textFontStyle.setFontName("微软雅黑");    
		textCenterStyle.setFont(textFontStyle);
		textLeftStyle.setFont(textFontStyle);
		//sheet.setColumnWidth(0, 10*256);
		for(int i=0;i<list.size();i++){
			//sheet.setColumnWidth(i+1, 35*256);
			HSSFRow perRow=sheet.createRow(i+2); 
			ContactsUserBean bean=list.get(i);
			String[] cellValue={i+1+"",bean.getUserName(),bean.getDeptName(),bean.getUserTelephone(),bean.getUserMobile(),bean.getUserEmail()};
			CellStyle[] textStyle={textCenterStyle,textCenterStyle,textCenterStyle,textCenterStyle,textCenterStyle,textLeftStyle};
			for(int j=0;j<titleStr.length;j++){
				Cell textCell =perRow.createCell(j);
				textCell.setCellStyle(textStyle[j]);
				textCell.setCellValue(cellValue[j]);
			}
		}
		// 不需要放到服务器上就可以导出下载
		String fileName = "通讯录.xls";
		String filePath = ConfigProvider.getPropertiesValue(
				"config.properties", "ftlPath");
		File file=new File(filePath);
		if(!file.exists()){
			file.mkdirs();
		}
		try {
			FileOutputStream fout = new FileOutputStream(filePath + "/"
					+ fileName);
			wb.write(fout);
			fout.close();
			wb.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return filePath + "/" + fileName;
	}
	private void setBorder(HSSFCellStyle cellStyle){
		cellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		cellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		cellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		cellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	}

	@Override
	public void deleteAlwaysContactors(String userIds,ShiroUser user) {
		iBizContactsDao.deleteAlwaysContactors(userIds,user);
		
	}

	@Override
	public PageResult<ContactsUserBean> findUserByDept(int pageNum,
			int pageSize, String userIds,String isSelectorNot) {
		return iBizContactsDao.findUserByDept(pageNum, pageSize, userIds,isSelectorNot);
	}

	@Override
	public ContactsUserBean queryContactor(String userId) {
		
		return iBizContactsDao.queryContactor(userId);
	}

	@Override
	public String valIsInContactors(String thisUserId,String userId) {
		if(!iBizContactsDao.isHasAlwaysContactors(thisUserId, userId)){
			return "1";//已收藏
		}
		return "0";
	}

	@Override
	public List<ContactsUserInfoBean> queryAllUserData() {
		
		
		return iBizContactsDao.queryAllUserData();
	}

	@Override
	public List<ContactsUserInfoBean> queryAllContactors(String userId) {
		return iBizContactsDao.queryAllContactors(userId);
	}

	@Override
	public String getOrgNameByUserId(String userId) {
		return iBizContactsDao.findOrgNameByUserId(userId);
	}
}
