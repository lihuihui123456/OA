package com.yonyou.jjb.leavemgr.service.Impl;

import java.io.FileOutputStream;
import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Service;

import com.yonyou.cap.common.util.ConfigProvider;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.dataauth.datarule.entity.DataRuleEnum;
import com.yonyou.cap.isc.dataauth.datarule.entity.SqlParam;
import com.yonyou.cap.isc.dataauth.datarule.service.IDataRuleService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.jjb.leavemgr.dao.ILeaveMgrDao;
import com.yonyou.jjb.leavemgr.entity.BizLeaveBean;
import com.yonyou.jjb.leavemgr.entity.BizLeaveDaysEntity;
import com.yonyou.jjb.leavemgr.entity.BizLeaveEntity;
import com.yonyou.jjb.leavemgr.service.ILeaveMgrService;

@Service("leaveMgrService")
public class LeaveMgrServiceImpl implements ILeaveMgrService{
	@Resource
	private ILeaveMgrDao leaveMgrDao;
	@Resource
	IDataRuleService dataRuleService;
	/**
	 * 分页请假信息并排序
	 */
	@Override
	public PageResult<BizLeaveEntity> findAllLeaveInfo(int pageNum, int pageSize,String modCode) {
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		StringBuffer wheresql = new StringBuffer();
	    wheresql.append(" dr='N' ");
	    SqlParam sql = dataRuleService.createSqlParam(modCode,"a",DataRuleEnum.DATA_ORG_ID);
		if(StringUtils.isNotBlank(sql.getParam())&& sql.isHasDataRole()){
				wheresql.append(sql.getParam());
		}else{
			wheresql.append("and (state='0' or data_user_id='"+user.getId()+"')");
		}
		orderby.put("ts", "desc");
		return leaveMgrDao.getPageData(BizLeaveEntity.class, pageNum, pageSize,wheresql.toString(), null,orderby);
	}

	/**
	 * 模糊查询请假信息 实现分页
	 */
	@Override
	public PageResult<BizLeaveEntity> findAllLeaveInfo(int pageNum, int pageSize, String searchInfo,String modCode) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		StringBuffer wheresql = new StringBuffer();
		wheresql.append( " user_name like '%" + searchInfo + "%' and dr='N' ");
		SqlParam sql = dataRuleService.createSqlParam(modCode,"a",DataRuleEnum.DATA_ORG_ID);
		if(StringUtils.isNotBlank(sql.getParam())&& sql.isHasDataRole()){
			wheresql.append(sql.getParam());
	}else{
		wheresql.append("and (state='0' or data_user_id='"+user.getId()+"')");
	}
/*		if (sql.isHasDataRole()) {
			if (!sql.isSql()) {
				wheresql.append(sql.getParam());
			}
		} else {
			wheresql.append(" and 1=1");
		}
		wheresql.append(" and (state='0' or data_user_id='"+user.getId()+"')");*/
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		orderby.put("ts", "desc");

		return leaveMgrDao.getPageData(BizLeaveEntity.class, pageNum, pageSize, wheresql.toString(), null, orderby);
	}

	/**
	 * 保存方法
	 */
	@Override
	public void doAddLeaveInfo(BizLeaveEntity li) {
		leaveMgrDao.save(li);
	}

	/**
	 * 删除方法
	 */
	@Override
	public void doDelLeaveInfo(String userid) {	
		BizLeaveEntity leaveInfoEntity=leaveMgrDao.findEntityByPK(BizLeaveEntity.class, userid);
		leaveInfoEntity.setDr("Y");
		leaveMgrDao.update(leaveInfoEntity);
	}

	/**
	 * 通过id获取一条记录
	 */
	@Override
	public BizLeaveEntity findLeaveInfoById(String id) {
		return leaveMgrDao.findEntityByPK(BizLeaveEntity.class, id);
	}

	/**
	 * 通过id获取总休假天数
	 */
	@Override
	public BizLeaveDaysEntity findLeaveDaysById(String id) {
		return leaveMgrDao.findEntityByPK(BizLeaveDaysEntity.class, id);
	}
	
	/**
	 * 更新方法
	 */
	@Override
	public void doUpdateLeaveInfo(BizLeaveEntity leaveInfoEntity) {
		leaveMgrDao.update(leaveInfoEntity);
	}
	
	/**
	 * 更新已休假总天数方法
	 */
	public void doUpdateLeaveDays(BizLeaveDaysEntity leaveDaysEntity) {
		leaveMgrDao.update(leaveDaysEntity);
	}
	
	/**
	 * 提交方法
	 */
	@Override
	public void doSendLeaveInfo(String userid) {	
		BizLeaveEntity leaveInfoEntity=leaveMgrDao.findEntityByPK(BizLeaveEntity.class, userid);

    		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
    		BizLeaveDaysEntity blde = leaveMgrDao.findEntityByPK(BizLeaveDaysEntity.class, user.id);
    		if(StringUtils.isNotEmpty(leaveInfoEntity.getXiujia_days())){
    			int i = Integer.parseInt(blde.getTotalDays_())+Integer.parseInt(leaveInfoEntity.getXiujia_days());
        		blde.setTotalDays_(String.valueOf(i));
    		}
    		if(StringUtils.isNotEmpty(leaveInfoEntity.getQingjia_days())){
    			int j = Integer.parseInt(blde.getLeaveDays_())+Integer.parseInt(leaveInfoEntity.getQingjia_days());
        		blde.setLeaveDays_(String.valueOf(j));
    		}  			
    	leaveMgrDao.update(blde);    	
		String date = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
		leaveInfoEntity.setSendTime(date);
		leaveInfoEntity.setState("0");
		leaveMgrDao.update(leaveInfoEntity);
	}
	@SuppressWarnings("deprecation")
	public String exportLeaveInfoToExcel(String sql,String modCode){
		// 第一步，创建一个webbook，对应一个Excel文件
		@SuppressWarnings("resource")
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("请假信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		HSSFRow row = sheet.createRow((int) 0);
		// 第四步，创建单元格，并设置值表头 设置表头居中
		HSSFCellStyle style = wb.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式

		HSSFCell cell = row.createCell((short) 0);
		cell.setCellValue("姓名");
		cell.setCellStyle(style);
		cell = row.createCell((short) 1);
		cell.setCellValue("所在部门");
		cell.setCellStyle(style);
		cell = row.createCell((short) 2);
		cell.setCellValue("职务");
		cell.setCellStyle(style);
		cell = row.createCell((short) 3);
		cell.setCellValue("状态");
		cell.setCellStyle(style);
		cell = row.createCell((short) 4);
		cell.setCellValue("请假类型");
		cell.setCellStyle(style);
		cell = row.createCell((short) 5);
		cell.setCellValue("开始时间");
		cell.setCellStyle(style);
		cell = row.createCell((short) 6);
		cell.setCellValue("结束时间");
		cell.setCellStyle(style);
		cell = row.createCell((short) 7);
		cell.setCellValue("本次请假天数");
		cell.setCellStyle(style);
		cell = row.createCell((short) 8);
		cell.setCellValue("是否出京");
		cell.setCellStyle(style);
		cell = row.createCell((short) 9);
		cell.setCellValue("是否出境");
		cell.setCellStyle(style);
		cell = row.createCell((short) 10);
		cell.setCellValue("提交时间");
		cell.setCellStyle(style);
		cell = row.createCell((short) 11);
		// 第五步，写入实体数据 实际应用中这些数据从数据库得到，
		List<BizLeaveEntity> list=leaveMgrDao.findAllLeaveInfo(sql,modCode);
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 1);
			BizLeaveEntity leaveEntity = list.get(i);
			String state=leaveEntity.getState();
			if("0".equals(state)){
				state="已提交";
			}else{
				state="未提交";
			}
			// 第四步，创建单元格，并设置值
			row.createCell((short) 0).setCellValue(leaveEntity.getUser_name());
			row.createCell((short) 1).setCellValue(leaveEntity.getDept_name());
			row.createCell((short) 2).setCellValue(leaveEntity.getPost_name());
			row.createCell((short) 3).setCellValue(state);
			row.createCell((short) 4).setCellValue(leaveEntity.getLeave_type());
			row.createCell((short) 5).setCellValue(leaveEntity.getStartTime());
			row.createCell((short) 6).setCellValue(leaveEntity.getEndTime());
			row.createCell((short) 7).setCellValue(leaveEntity.getQingjia_days());
			row.createCell((short) 8).setCellValue(leaveEntity.getLeave_capital());
			row.createCell((short) 9).setCellValue(leaveEntity.getLeave_country());
			row.createCell((short) 10).setCellValue(leaveEntity.getSendTime());
		}

		// 不需要放到服务器上就可以导出下载
		String	fileName="请假信息.xls";
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

	@Override
	public PageResult<BizLeaveBean> findAllLeaveBeanInfo(int pageNum,
			int pageSize, String modCode) {
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		StringBuffer wheresql = new StringBuffer();
	    wheresql.append(" dr='N' ");
	    SqlParam sql = dataRuleService.createSqlParam(modCode,"a",DataRuleEnum.DATA_ORG_ID);
		if(StringUtils.isNotBlank(sql.getParam())&& sql.isHasDataRole()){
			wheresql.append(sql.getParam());
	}else{
		wheresql.append("and (state='0' or data_user_id='"+user.getId()+"')");
	}
/*		if(sql.isHasDataRole()){
			if(!sql.isSql()){
				wheresql.append(sql.getParam());
			}
		}else{
			wheresql.append(" and 1=1 ");
		}
		wheresql.append("and (state='0' or data_user_id='"+user.getId()+"')");*/
		orderby.put("ts", "desc");
		return leaveMgrDao.getPageData(BizLeaveBean.class, pageNum, pageSize,wheresql.toString(), null,orderby);
	
	}

	@Override
	public PageResult<BizLeaveBean> findAllLeaveBeanInfo(int pageNum,
			int pageSize, String searchInfo, String modCode) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		StringBuffer wheresql = new StringBuffer();
		wheresql.append( " user_name like '%" + searchInfo + "%' and dr='N' ");
		SqlParam sql = dataRuleService.createSqlParam(modCode,"a",DataRuleEnum.DATA_ORG_ID);
		if (sql.isHasDataRole()) {
			if (!sql.isSql()) {
				wheresql.append(sql.getParam());
			}
		} else {
			wheresql.append(" and 1=1");
		}
		wheresql.append("and (state='0' or data_user_id='"+user.getId()+"')");
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		orderby.put("ts", "desc");

		return leaveMgrDao.getPageData(BizLeaveBean.class, pageNum, pageSize, wheresql.toString(), null, orderby);
	
	}

	@Override
	public BizLeaveBean getSolId(String bizId) {
		StringBuilder sb = new StringBuilder();
	sb.append("SELECT  b.sol_id_ ,b.proc_inst_id_ ,b.state_  from bpm_ru_biz_info b where  b.dr_ = 'N' and b.id_ ='"+bizId+"'");
     PageResult<BizLeaveBean> pageData = leaveMgrDao.getPageData(BizLeaveBean.class, 1, 1, sb.toString());
	if(pageData.getTotalrecord()>0){
		return  pageData.getResults().get(0);
	}
	else{
		return null;
	}
 }
}
