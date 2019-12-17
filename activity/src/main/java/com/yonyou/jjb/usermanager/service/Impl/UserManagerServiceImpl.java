package com.yonyou.jjb.usermanager.service.Impl;

import java.io.FileOutputStream;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.stereotype.Service;





import com.yonyou.cap.common.util.ConfigProvider;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.jjb.usermanager.dao.IUserManagerDao;
import com.yonyou.jjb.usermanager.entity.UserInfoEntity;
import com.yonyou.jjb.usermanager.service.IUserManagerService;


@Service("userManagerService")
public class UserManagerServiceImpl implements IUserManagerService{
	@Resource
	private IUserManagerDao userManagerDao;

	/**
	 * 模糊查询人员信息 实现分页
	 */
	@Override
	public PageResult<UserInfoEntity> findAllUserInfo(int pageNum, int pageSize,
			String userName,String userAge,String deptName,String postName,String entryTime,String userSex,String userDutyTyp) {	
		StringBuffer wheresql = new StringBuffer();
		wheresql.append("select a.user_id userId,a.user_name userName,cast(a.user_sex as CHAR) as userSex,a.user_bitrth userBitrth,cast(a.work_time as CHAR) as workTime,cast(a.user_duty_typ as CHAR) as userDutyTyp,");
		wheresql.append("a.user_age userAge,a.user_education userEducation,a.user_police_type userPoliceType,cast(a.join_time as CHAR) as joinTime,a.user_source userSource ");
		wheresql.append(" from (select s.* from isc_user_info s LEFT JOIN isc_dept_ref_user ofu ON s.USER_ID = ofu.USER_ID");
		wheresql.append(" LEFT JOIN isc_dept d ON d.dept_ID = ofu.dept_ID where (s.user_source is null or s.user_source!='1') ");
		if(StringUtils.isNotEmpty(userName)){
			wheresql.append("AND s.user_name LIKE '%" + userName + "%' ");
		}
		if(StringUtils.isNotEmpty(userAge)){
			wheresql.append("AND s.user_age LIKE '%" + userAge + "%' ");
		}
		if(StringUtils.isNotEmpty(entryTime)){
			wheresql.append("AND s.entry_time LIKE '%" + entryTime + "%' ");
		}
		if(StringUtils.isNotEmpty(userSex)){
			wheresql.append("AND s.user_sex LIKE '%" + userSex + "%' ");
		}
		if(StringUtils.isNotEmpty(deptName)){
			wheresql.append("AND s.dept_name = '" + deptName + "' ");
		}
		if(StringUtils.isNotEmpty(postName)){
			wheresql.append("AND s.post_name = '" + postName + "' ");
		}
		if(StringUtils.isNotEmpty(userDutyTyp)){
			wheresql.append("AND s.user_duty_typ LIKE '%" + userDutyTyp + "%' ");
		}
		wheresql.append(" AND s.dr='N' and ofu.dr='N' and s.user_name not like '%admin%' ORDER BY d.sort asc ,ofu.sort asc,ofu.weight desc) a ");
		wheresql.append(" union all ");
		wheresql.append("select b.user_id userId,b.user_name userName,cast(b.user_sex as CHAR) as userSex,b.user_bitrth userBitrth,cast(b.work_time as CHAR) as workTime,cast(b.user_duty_typ as CHAR) as userDutyTyp,");
		wheresql.append("b.user_age userAge,b.user_education userEducation,b.user_police_type userPoliceType,cast(b.join_time as CHAR) as joinTime,b.user_source userSource ");
		wheresql.append(" from (select * from isc_user_info where user_source='1' ");
		if(StringUtils.isNotEmpty(userName)){
			wheresql.append("AND user_name LIKE '%" + userName + "%' ");
		}
		if(StringUtils.isNotEmpty(userAge)){
			wheresql.append("AND user_age LIKE '%" + userAge + "%' ");
		}
		if(StringUtils.isNotEmpty(entryTime)){
			wheresql.append("AND entry_time LIKE '%" + entryTime + "%' ");
		}
		if(StringUtils.isNotEmpty(userSex)){
			wheresql.append("AND user_sex LIKE '%" + userSex + "%' ");
		}
		if(StringUtils.isNotEmpty(deptName)){
			wheresql.append("AND dept_name = '" + deptName + "' ");
		}
		if(StringUtils.isNotEmpty(postName)){
			wheresql.append("AND post_name = '" + postName + "' ");
		}
		if(StringUtils.isNotEmpty(userDutyTyp)){
			wheresql.append("AND user_duty_typ LIKE '%" + userDutyTyp + "%' ");
		}
		wheresql.append(" AND dr='N' and user_name not like '%admin%' order by ts asc) b ");
		
		return userManagerDao.getPageData(UserInfoEntity.class, pageNum, pageSize,
				wheresql.toString());
	}

	/**
	 * 保存方法
	 */
	@Override
	public void doAddUserInfo(UserInfoEntity ui) {
		userManagerDao.save(ui);
	}

	/**
	 * 删除方法
	 */
	@Override
	public void doDelUserInfo(String userid) {	
		UserInfoEntity ui=new UserInfoEntity();
		ui=userManagerDao.findEntityByPK(UserInfoEntity.class, userid);
		ui.setDr("Y");
		userManagerDao.update(ui);
	}

	/**
	 * 通过id获取一条记录
	 */
	@Override
	public UserInfoEntity findUserInfoByUserId(String userId) {
		return userManagerDao.findEntityByPK(UserInfoEntity.class, userId);
	}

	/**
	 * 更新方法
	 */
	@Override
	public void doUpdateUserInfo(UserInfoEntity userInfoEntity) {
		userManagerDao.update(userInfoEntity);
	}
	
	@SuppressWarnings({ "deprecation", "resource" })
	public String exportUserInfoToExcel(String userName,String userAge,String deptName,String postName,
			String entryTime,String userSex,String userDutyTyp){
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("人员信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		HSSFRow row = sheet.createRow((int) 0);
		// 第四步，创建单元格，并设置值表头 设置表头居中
		HSSFCellStyle style = wb.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式

		HSSFCell cell = row.createCell((short) 0);
		cell.setCellValue("姓名");
		cell.setCellStyle(style);
		cell = row.createCell((short) 1);
		cell.setCellValue("性别");
		cell.setCellStyle(style);
		cell = row.createCell((short) 2);
		cell.setCellValue("年龄");
		cell.setCellStyle(style);
		cell = row.createCell((short) 3);
		cell.setCellValue("身高");
		cell.setCellStyle(style);
		cell = row.createCell((short) 4);
		cell.setCellValue("婚姻状况");
		cell.setCellStyle(style);
		cell = row.createCell((short) 5);
		cell.setCellValue("籍贯");
		cell.setCellStyle(style);
		cell = row.createCell((short) 6);
		cell.setCellValue("政治面貌");
		cell.setCellStyle(style);
		cell = row.createCell((short) 7);
		cell.setCellValue("民族");
		cell.setCellStyle(style);
		cell = row.createCell((short) 8);
		cell.setCellValue("身份证号");
		cell.setCellStyle(style);
		cell = row.createCell((short) 9);
		cell.setCellValue("出生日期");
		cell.setCellStyle(style);
		cell = row.createCell((short) 10);
		cell.setCellValue("学历");
		cell.setCellStyle(style);
		cell = row.createCell((short) 11);
		cell.setCellValue("学位");
		cell.setCellStyle(style);
		cell = row.createCell((short) 12);
		cell.setCellValue("入党时间");
		cell.setCellStyle(style);
		cell = row.createCell((short) 13);
		cell.setCellValue("调入时间");
		cell.setCellStyle(style);
		cell = row.createCell((short) 14);
		cell.setCellValue("参加工作时间");
		cell.setCellStyle(style);
		cell = row.createCell((short) 15);
		cell.setCellValue("办公电话");
		cell.setCellStyle(style);
		cell = row.createCell((short) 16);
		cell.setCellValue("手机号");
		cell.setCellStyle(style);
		cell = row.createCell((short) 17);
		cell.setCellValue("Email");
		cell.setCellStyle(style);
		cell = row.createCell((short) 18);
		cell.setCellValue("现住址");
		cell.setCellStyle(style);
		cell = row.createCell((short) 19);
		cell.setCellValue("工龄");
		cell.setCellStyle(style);
		cell = row.createCell((short) 20);
		cell.setCellValue("人员类型");
		cell.setCellStyle(style);
		cell = row.createCell((short) 21);
		cell.setCellValue("部门");
		cell.setCellStyle(style);
		cell = row.createCell((short) 22);
		cell.setCellValue("职务");
		cell.setCellStyle(style);
		cell = row.createCell((short) 23);
		cell.setCellValue("QQ");
		cell.setCellStyle(style);
		cell = row.createCell((short) 24);
		// 第五步，写入实体数据 实际应用中这些数据从数据库得到，
		List<UserInfoEntity> list=userManagerDao.findAllUser(userName,userAge,deptName,postName,
				 entryTime,userSex,userDutyTyp);
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 1);
			UserInfoEntity userinfo = list.get(i);
			// 第四步，创建单元格，并设置值
			String sex = String.valueOf(userinfo.getUserSex());
			if ("0".equals(sex)) {
				sex = "女";
			} else if("1".equals(sex)){
				sex = "男";
			}else if("2".equals(sex)){
				sex = "未知";
			}
			String userDuty=String.valueOf(userinfo.getUserDutyTyp());
			if ("0".equals(userDuty)){
				userDuty="正式-在职";
			}else if ("1".equals(userDuty)){
				userDuty="借调";
			}else if ("2".equals(userDuty)){
				userDuty="正式-聘用";
			}else if ("5".equals(userDuty)){
				userDuty="实习";
			}
			if(userinfo.getUserName()!=null){
				row.createCell((short) 0).setCellValue(userinfo.getUserName());
			}else{				
				row.createCell((short) 0).setCellValue("");}
			if(sex!=null){
				row.createCell((short) 1).setCellValue(sex);
			}else{				
				row.createCell((short) 1).setCellValue("");}
			if(userinfo.getUserAge()!=null){
				row.createCell((short) 2).setCellValue(userinfo.getUserAge());
			}else{				
				row.createCell((short) 2).setCellValue("");}
			if(userinfo.getUserHeight()!=null){
				row.createCell((short) 3).setCellValue(userinfo.getUserHeight());
			}else{				
				row.createCell((short) 3).setCellValue("");}
			if(userinfo.getMaritalStatus()!=null){
				row.createCell((short) 4).setCellValue(userinfo.getMaritalStatus());
			}else{				
				row.createCell((short) 4).setCellValue("");}
			if(userinfo.getUserNativePlace()!=null){
				row.createCell((short) 5).setCellValue(userinfo.getUserNativePlace());
			}else{				
				row.createCell((short) 5).setCellValue("");}
			
			if(userinfo.getUserPoliceType()!=null){
				row.createCell((short) 6).setCellValue(userinfo.getUserPoliceType());
			}else{				
				row.createCell((short) 6).setCellValue("");}

			if(userinfo.getUserNation()!=null){
				row.createCell((short) 7).setCellValue(userinfo.getUserNation());
			}else{				
				row.createCell((short) 7).setCellValue("");}
			if(userinfo.getUserCertCode()!=null){
				row.createCell((short) 8).setCellValue(userinfo.getUserCertCode());
			}else{				
				row.createCell((short) 8).setCellValue("");}
			if(userinfo.getUserBitrth()!=null){
				row.createCell((short) 9).setCellValue(userinfo.getUserBitrth());
			}else{				
				row.createCell((short) 9).setCellValue("");}
			if(userinfo.getUserEducation()!=null){
				row.createCell((short) 10).setCellValue(userinfo.getUserEducation());
			}else{				
				row.createCell((short) 10).setCellValue("");}
			if(userinfo.getUserDegree()!=null){
				row.createCell((short) 11).setCellValue(userinfo.getUserDegree());
			}else{				
				row.createCell((short) 11).setCellValue("");}
			if(userinfo.getJoinTime()!=null){
				row.createCell((short) 12).setCellValue(userinfo.getJoinTime());
			}else{				
				row.createCell((short) 12).setCellValue("");}
			if(userinfo.getEntryTime()!=null){
				row.createCell((short) 13).setCellValue(userinfo.getEntryTime());
			}else{				
				row.createCell((short) 13).setCellValue("");}
			if(userinfo.getWorkTime()!=null){
				row.createCell((short) 14).setCellValue(userinfo.getWorkTime());
			}else{				
				row.createCell((short) 14).setCellValue("");}
			if(userinfo.getOfficePhone()!=null){
				row.createCell((short) 15).setCellValue(userinfo.getOfficePhone());
			}else{				
				row.createCell((short) 15).setCellValue("");}
			if(userinfo.getUserMobile()!=null){
				row.createCell((short) 16).setCellValue(userinfo.getUserMobile());
			}else{				
				row.createCell((short) 16).setCellValue("");}
			if(userinfo.getUserEmail()!=null){
				row.createCell((short) 17).setCellValue(userinfo.getUserEmail());
			}else{				
				row.createCell((short) 17).setCellValue("");}
			if(userinfo.getUserAddress()!=null){
				row.createCell((short) 18).setCellValue(userinfo.getUserAddress());
			}else{				
				row.createCell((short) 18).setCellValue("");}
			row.createCell((short) 19).setCellValue(userinfo.getUserSeniority());
			if(userDuty!=null){
				row.createCell((short) 20).setCellValue(userDuty);
			}else{				
				row.createCell((short) 20).setCellValue("");}
			if(userinfo.getDeptName()!=null){
				row.createCell((short) 21).setCellValue(userinfo.getDeptName());
			}else{				
				row.createCell((short) 21).setCellValue("");}
			if(userinfo.getPostName()!=null){
				row.createCell((short) 22).setCellValue(userinfo.getPostName());
			}else{				
				row.createCell((short) 22).setCellValue("");}
			if(userinfo.getUserQq()!=null){
				row.createCell((short) 23).setCellValue(userinfo.getUserQq());
			}else{				
				row.createCell((short) 23).setCellValue("");}
		}

		// 不需要放到服务器上就可以导出下载
		String	fileName="人员信息.xls";
		String filePath = ConfigProvider.getPropertiesValue(
				"config.properties", "ftlPath");
		// 第六步，将文件存到指定位置
		try {
			FileOutputStream fout = new FileOutputStream(filePath + "/"
					+ fileName);
			wb.write(fout);
			fout.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return filePath + "/" + fileName;
	}
	public String findDeptCodeById(String deptid){
		return userManagerDao.findDeptCodeById(deptid);
	}
	public String findPostCodeById(String postid){
		return userManagerDao.findPostCodeById(postid);
	}
}
