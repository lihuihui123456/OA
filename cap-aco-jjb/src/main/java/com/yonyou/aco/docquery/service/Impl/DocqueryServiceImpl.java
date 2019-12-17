package com.yonyou.aco.docquery.service.Impl;

import java.io.FileOutputStream;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.docquery.dao.IDocqueryDao;
import com.yonyou.aco.docquery.entity.SearchBean;
import com.yonyou.aco.docquery.entity.SearchEntity;
import com.yonyou.aco.docquery.service.IDocqueryService;
import com.yonyou.cap.common.util.ConfigProvider;
import com.yonyou.cap.common.util.PageResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
@Repository("docqueryService")
public class DocqueryServiceImpl implements IDocqueryService{

	@Resource
	IDocqueryDao docqueryDao;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Override
	public PageResult<SearchBean> getAllBasicinfo_fw(int pageNum, int pageSize, String[] params, String title,
			String sortName, String sortOrder) {
		PageResult<SearchBean> pd = null;
		try {
			StringBuffer sb = new StringBuffer();
			String gwbt = params[0];
			String djr = params[1];
			String bwzt = params[2];
			String lwdw = params[3];
			String ywlx_fw = params[4];
			sb.append(
					"select b.ID_,b.SOL_ID_ solId,c.SOL_CTLG_NAME_ BIZ_TYPE_,b.BIZ_TITLE_,u.USER_NAME,u.DEPT_NAME,b.CREATE_TIME_ CREATE_TIME_,b.STATE_ ,'' ASSIGNEE_ ");
			sb.append(
					"from bpm_ru_biz_info b,act_hi_procinst h,isc_user u,bpm_re_sol_ctlg c where b.PROC_INST_ID_=h.PROC_INST_ID_ AND c.`code` = b.BIZ_TYPE_ ");
			sb.append(
					"AND u.USER_ID = b.CREATE_USER_ID_ AND h.END_TIME_ IS NOT NULL AND b.STATE_ IN('1','2') AND b.DR_='N'");
			title = java.net.URLDecoder.decode(title, "UTF-8");
			title = java.net.URLDecoder.decode(title, "UTF-8");
			if (StringUtils.isNotBlank(title)) {
				sb.append(" AND BIZ_TITLE_ like '%" + title.trim() + "%'");
				sb.append(" OR BIZ_TYPE_ like '%" + title.trim() + "%'");
				sb.append(" OR b.BIZ_DOC_NUM like '%" + title.trim() + "%'");
			}
			if (StringUtils.isNotBlank(gwbt)) {
				sb.append(" and b.BIZ_TITLE_ like '%" + gwbt.trim() + "%'");
			}
			if (StringUtils.isNotBlank(bwzt)) {
				sb.append(" and b.STATE_  = '" + bwzt + "'");
			}
			if (StringUtils.isNotBlank(djr)) {
				sb.append(" and u.USER_NAME like '%" + djr.trim() + "%'");
			}
			if (StringUtils.isNotBlank(lwdw)) {
				sb.append(" and u.DEPT_NAME like '%" + lwdw.trim() + "%'");
			}
			if (StringUtils.isNotBlank(ywlx_fw)) {
				sb.append(" and b.BIZ_TYPE_ = '" + ywlx_fw + "'");
			}
			sb.append(" UNION ALL ");
			sb.append(
					"select b.ID_ ID,b.SOL_ID_ solId,c.SOL_CTLG_NAME_ BIZ_TYPE_,b.BIZ_TITLE_,u.USER_NAME,u.DEPT_NAME,");
			sb.append("b.CREATE_TIME_ CREATE_TIME_,b.STATE_,GROUP_CONCAT(i.USER_NAME) ASSIGNEE_ ");
			sb.append("from bpm_ru_biz_info b,act_ru_task t,isc_user u,bpm_re_sol_ctlg c,isc_user i ");
			sb.append("where b.PROC_INST_ID_=t.PROC_INST_ID_ AND u.USER_ID = b.CREATE_USER_ID_ ");
			sb.append("AND c.`code` = b.BIZ_TYPE_  AND i.USER_ID = t.ASSIGNEE_ AND b.STATE_ IN('1','2') ");
			sb.append("AND b.DR_='N' ");

			if (StringUtils.isNotBlank(title)) {
				sb.append(" AND BIZ_TITLE_ like '%" + title.trim() + "%'");
				sb.append(" OR BIZ_TYPE_ like '%" + title.trim() + "%'");
				sb.append(" OR b.BIZ_DOC_NUM like '%" + title.trim() + "%'");
			}
			if (StringUtils.isNotBlank(gwbt)) {
				sb.append(" and b.BIZ_TITLE_ like '%" + gwbt.trim() + "%'");
			}
			if (StringUtils.isNotBlank(bwzt)) {
				sb.append(" and b.STATE_  = '" + bwzt + "'");
			}
			if (StringUtils.isNotBlank(djr)) {
				sb.append(" and u.USER_NAME like '%" + djr.trim() + "%'");
			}
			if (StringUtils.isNotBlank(lwdw)) {
				sb.append(" and u.DEPT_NAME like '%" + lwdw.trim() + "%'");
			}
			if (StringUtils.isNotBlank(ywlx_fw)) {
				sb.append(" and b.BIZ_TYPE_ = '" + ywlx_fw + "'");
			}
			sb.append(" GROUP BY b.ID_  ");
			if (StringUtils.isNotEmpty(sortName)) {
				sb.append(" order by CONVERT( " + sortName + " USING gbk ) " + sortOrder);
			} else {
				sb.append(" order by CREATE_TIME_ desc");
			}

			pd = docqueryDao.getPageData(SearchBean.class, pageNum, pageSize, sb.toString());

		} catch (Exception e) {
			logger.error("error", e);
		}
		return pd;
	}

/*	public PageResult<SearchBean> getAllBasicinfo_fw(int pageNum,int pageSize,String[] params,String title,String sortName,String sortOrder){
		PageResult<SearchBean> pd = null;
		try {
			StringBuffer sb = new StringBuffer();
			String gwbt = params[0];
			String djr = params[1];
			String bwzt = params[2];
			String lwdw = params[3];
			String ywlx_fw = params[4];
			sb.append("SELECT aa.ID_ ID_,aa.SOL_ID_ solId, aa.BIZ_TITLE_ BIZ_TITLE_, ee.SOL_CTLG_NAME_ BIZ_TYPE_, aa.CREATE_USER_ID_ CREATE_USER_ID_,aa.CREATE_TIME_ CREATE_TIME_,");
			sb.append("aa.STATE_ STATE_ ,trim(aa.ARCHIVE_STATE_) ARCHIVE_STATE_,aa.URGENCY_ URGENCY_,aa.CREATE_DEPT_ID_ CREATE_DEPT_ID_,aa.SERIAL_NUMBER_ SERIAL_NUMBER_,");
			sb.append(" bb.USER_NAME USER_NAME, bb.DEPT_NAME DEPT_NAME,bb.ORG_NAME ORG_NAME,u.USER_NAME ASSIGNEE_  FROM BPM_RU_BIZ_INFO aa ");
			sb.append(" LEFT JOIN ISC_USER bb ON aa.CREATE_USER_ID_=bb.USER_ID");
			sb.append(" LEFT JOIN bpm_re_sol_ctlg ee ON aa.BIZ_TYPE_ = ee.`code`");
			sb.append(" LEFT JOIN act_hi_taskinst t ON t.PROC_INST_ID_ = aa.PROC_INST_ID_");
			sb.append(" LEFT JOIN isc_user u ON u.USER_ID = t.ASSIGNEE_");
			sb.append(" WHERE aa.CREATE_USER_ID_=bb.USER_ID ");
			sb.append(" AND aa.DR_ = 'N' ");
			sb.append(" AND aa.STATE_ != '0' AND aa.STATE_ != '3' AND aa.STATE_ != '4'");
			title = java.net.URLDecoder.decode(title,"UTF-8");
			title = java.net.URLDecoder.decode(title,"UTF-8");
			sb.append(" AND aa.BIZ_TITLE_ like '%"+title.trim()+"%'");
			if(StringUtils.isNotBlank(gwbt)){
				sb.append(" and aa.BIZ_TITLE_ like '%"+gwbt.trim()+"%'");
			}
			if(StringUtils.isNotBlank(bwzt)){
				sb.append(" and aa.STATE_  = '"+bwzt+"'");
			}
			if(StringUtils.isNotBlank(djr)){
				sb.append(" and bb.USER_NAME like '%"+djr.trim()+"%'");
			}
			if(StringUtils.isNotBlank(lwdw)){
				sb.append(" and bb.DEPT_NAME like '%"+lwdw.trim()+"%'");
			}
			if(StringUtils.isNotBlank(ywlx_fw)){
				sb.append(" and aa.BIZ_TYPE_ = '"+ywlx_fw+"'");
			}
			sb.append(" group by aa.ID_");
			if(StringUtils.isNotEmpty(sortName)){
				if(sortName.equals("USER_NAME") || sortName.equals("DEPT_NAME")){
					sb.append(" order by CONVERT( bb."+sortName+" USING gbk ) "+sortOrder);
				}else if(sortName.equals("CREATE_TIME_")){
					sb.append(" order by aa.CREATE_TIME_ "+sortOrder);
				}else{
					sb.append(" order by CONVERT( "+sortName+" USING gbk ) "+sortOrder);
				}
			}else{
				sb.append(" order by aa.CREATE_TIME_ desc");
			}
			pd = docqueryDao.getPageData(SearchBean.class, pageNum, pageSize, sb.toString() );
			
		} catch (Exception e) {
			logger.error("error",e);
		}
		return pd;
	}*/

	@Override
	public PageResult<SearchBean> getAllBasicinfo(int pageNum, int pageSize,
			String[] params,String title,String sortName,String sortOrder) {
		PageResult<SearchBean> pd = null;
		try {
			StringBuffer sb = new StringBuffer();
			String gwbt = params[0];
			String djr = params[1];
			String bwzt = params[2];
			String sfgd = params[3]; 
			sb.append("SELECT aa.ID_ ID_,aa.SOL_ID_ solId, aa.BIZ_TITLE_ BIZ_TITLE_, aa.BIZ_TYPE_ BIZ_TYPE_, aa.CREATE_USER_ID_ CREATE_USER_ID_,aa.CREATE_TIME_ CREATE_TIME_, ");
			sb.append("aa.STATE_ STATE_ ,trim(aa.ARCHIVE_STATE_) ARCHIVE_STATE_,aa.URGENCY_ URGENCY_,aa.CREATE_DEPT_ID_ CREATE_DEPT_ID_,aa.SERIAL_NUMBER_ SERIAL_NUMBER_,");
			sb.append(" bb.USER_NAME USER_NAME, bb.DEPT_NAME DEPT_NAME,bb.ORG_NAME ORG_NAME FROM BPM_RU_BIZ_INFO aa ");
			sb.append(" LEFT JOIN ISC_USER bb ON aa.CREATE_USER_ID_=bb.USER_ID");
			sb.append(" LEFT JOIN bpm_re_sol_ctlg ee ON aa.BIZ_TYPE_ = ee.code");
			sb.append(" WHERE aa.CREATE_USER_ID_=bb.USER_ID AND aa.BIZ_TYPE_ LIKE '10010002%'");
			sb.append(" AND aa.DR_ = 'N' ");
			sb.append(" AND aa.STATE_ != '0' AND aa.STATE_ != '3' AND aa.STATE_ != '4'");
			title = java.net.URLDecoder.decode(title,"UTF-8");
			title = java.net.URLDecoder.decode(title,"UTF-8");
			sb.append(" AND aa.BIZ_TITLE_ like '%"+title.trim()+"%'");
			if(StringUtils.isNotBlank(gwbt)){
				sb.append(" and aa.BIZ_TITLE_ like '%"+gwbt.trim()+"%'");
			}
			if(StringUtils.isNotBlank(bwzt)){
				sb.append(" and aa.STATE_  = '"+bwzt+"'");
			}
			if(StringUtils.isNotBlank(sfgd)){
				sb.append(" and aa.ARCHIVE_STATE_ = '"+sfgd+"'");
			}
			if(StringUtils.isNotBlank(djr)){
				sb.append(" and bb.USER_NAME like '%"+djr.trim()+"%'");
			}
			sb.append(" group by aa.ID_");
			if(StringUtils.isNotEmpty(sortName) && !sortName.equals("CREATE_TIME_")){
				sb.append(" order by CONVERT( "+sortName+" USING gbk ) "+sortOrder);
			}else if(sortName.equals("CREATE_TIME_")){
				sb.append(" order by aa.CREATE_TIME_ "+sortOrder);
			}else{
				sb.append(" order by aa.CREATE_TIME_ desc");
			}
			pd = docqueryDao.getPageData(SearchBean.class, pageNum, pageSize, sb.toString() );
		} catch (Exception e) {
			logger.error("error",e);
		}
		return pd;
	}

	@Override
	public boolean updateSignTime(String bizId,String date) {
		return docqueryDao.updateSignTime(bizId,date);
	}

	
	@SuppressWarnings({ "resource", "deprecation" })
	@Override
	public String getExcel_fw(String[] params,String inputWordfw,String gwbt_fw,String bwzt_fw,String regUser,
			String deptName,String ywlx_fw) {
		List<SearchEntity> pd = new ArrayList<SearchEntity>();
		StringBuffer sb = new StringBuffer();
		String title = gwbt_fw;
		String gwbt = gwbt_fw;
		String djr = regUser;
		String bwzt = bwzt_fw;
		String lwdw = deptName;
		String ywlx = ywlx_fw;
		sb.append("select b.ID_ id, b.BIZ_TITLE_ bizTitle, c.SOL_CTLG_NAME_ bizType, b.CREATE_USER_ID_ createUserId,b.CREATE_TIME_ createTime,");
		sb.append(" b.STATE_ state ,trim(b.ARCHIVE_STATE_) archiveState,b.URGENCY_ urgency,b.CREATE_DEPT_ID_ createDeptId,b.SERIAL_NUMBER_ serialNumber,");
		sb.append("  u.USER_NAME userName, u.DEPT_NAME deptName,u.ORG_NAME orgName,'' assignee ");		
		sb.append(
				"from bpm_ru_biz_info b,act_hi_procinst h,isc_user u,bpm_re_sol_ctlg c where b.PROC_INST_ID_=h.PROC_INST_ID_ AND c.`code` = b.BIZ_TYPE_ ");
		sb.append(
				"AND u.USER_ID = b.CREATE_USER_ID_ AND h.END_TIME_ IS NOT NULL AND b.STATE_ IN('1','2') AND b.DR_='N'");
		if (StringUtils.isNotBlank(title)) {
			sb.append(" AND BIZ_TITLE_ like '%" + title.trim() + "%'");
			sb.append(" OR BIZ_TYPE_ like '%" + title.trim() + "%'");
			sb.append(" OR b.BIZ_DOC_NUM like '%" + title.trim() + "%'");
		}
		if (StringUtils.isNotBlank(gwbt)) {
			sb.append(" and b.BIZ_TITLE_ like '%" + gwbt.trim() + "%'");
		}
		if (StringUtils.isNotBlank(bwzt)) {
			sb.append(" and b.STATE_  = '" + bwzt + "'");
		}
		if (StringUtils.isNotBlank(djr)) {
			sb.append(" and u.USER_NAME like '%" + djr.trim() + "%'");
		}
		if (StringUtils.isNotBlank(lwdw)) {
			sb.append(" and u.DEPT_NAME like '%" + lwdw.trim() + "%'");
		}
		if (StringUtils.isNotBlank(ywlx)) {
			sb.append(" and b.BIZ_TYPE_ = '" + ywlx + "'");
		}
		sb.append(" UNION ALL ");
		sb.append("select b.ID_ id, b.BIZ_TITLE_ bizTitle, c.SOL_CTLG_NAME_ bizType, b.CREATE_USER_ID_ createUserId,b.CREATE_TIME_ createTime,");
		sb.append(" b.STATE_ state ,trim(b.ARCHIVE_STATE_) archiveState,b.URGENCY_ urgency,b.CREATE_DEPT_ID_ createDeptId,b.SERIAL_NUMBER_ serialNumber,");
		sb.append("  u.USER_NAME userName, u.DEPT_NAME deptName,u.ORG_NAME orgName,GROUP_CONCAT(i.USER_NAME) assignee ");	
		sb.append("from bpm_ru_biz_info b,act_ru_task t,isc_user u,bpm_re_sol_ctlg c,isc_user i ");
		sb.append("where b.PROC_INST_ID_=t.PROC_INST_ID_ AND u.USER_ID = b.CREATE_USER_ID_ ");
		sb.append("AND c.`code` = b.BIZ_TYPE_  AND i.USER_ID = t.ASSIGNEE_ AND b.STATE_ IN('1','2') ");
		sb.append("AND b.DR_='N' ");

		if (StringUtils.isNotBlank(title)) {
			sb.append(" AND BIZ_TITLE_ like '%" + title.trim() + "%'");
			sb.append(" OR BIZ_TYPE_ like '%" + title.trim() + "%'");
			sb.append(" OR b.BIZ_DOC_NUM like '%" + title.trim() + "%'");
		}
		if (StringUtils.isNotBlank(gwbt)) {
			sb.append(" and b.BIZ_TITLE_ like '%" + gwbt.trim() + "%'");
		}
		if (StringUtils.isNotBlank(bwzt)) {
			sb.append(" and b.STATE_  = '" + bwzt + "'");
		}
		if (StringUtils.isNotBlank(djr)) {
			sb.append(" and u.USER_NAME like '%" + djr.trim() + "%'");
		}
		if (StringUtils.isNotBlank(lwdw)) {
			sb.append(" and u.DEPT_NAME like '%" + lwdw.trim() + "%'");
		}
		if (StringUtils.isNotBlank(ywlx_fw)) {
			sb.append(" and b.BIZ_TYPE_ = '" + ywlx_fw + "'");
		}
		
		if(params.length > 0 && !params[0].equals("1")){
			sb.append(" AND aa.ID_ IN (");
			sb.append("'"+params[0]+"'");
			for(int i=1;i<params.length;i++){
				sb.append(",'"+params[i]+"'");
			}
			sb.append(" )");
		}
		sb.append(" GROUP BY b.ID_  ");
		sb.append(" order by  createTime desc");	
		// 第一步，创建一个webbook，对应一个Excel文件
				HSSFWorkbook wb = new HSSFWorkbook();
				// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
				HSSFSheet sheet = wb.createSheet("公文查询");
				// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
				HSSFRow row = sheet.createRow((int) 0);
				// 第四步，创建单元格，并设置值表头 设置表头居中
				HSSFCellStyle style = wb.createCellStyle();
				style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式

				HSSFCell cell = row.createCell((short) 0);
				cell.setCellValue("业务类型");
				cell.setCellStyle(style);
				cell = row.createCell((short) 1);
				cell.setCellValue("公文标题");
				cell.setCellStyle(style);
				cell = row.createCell((short) 2);
				cell.setCellValue("拟稿部门");
				cell.setCellStyle(style);
				cell = row.createCell((short) 3);
				cell.setCellValue("归档状态");
				cell.setCellStyle(style);
				cell = row.createCell((short) 4);
				cell.setCellValue("拟稿人");
				cell.setCellStyle(style);
				cell = row.createCell((short) 5);
				cell.setCellValue("办理人");
				cell.setCellStyle(style);
				cell = row.createCell((short) 6);
				cell.setCellValue("拟稿时间");
				cell.setCellStyle(style);
				cell = row.createCell((short) 7);
				cell.setCellValue("拟稿单位");
				cell.setCellStyle(style);
				cell = row.createCell((short) 8);
				cell.setCellValue("流水号");
				cell.setCellStyle(style);
				cell = row.createCell((short) 9);
				cell.setCellValue("办文状态");
				cell.setCellStyle(style);
				/*cell = row.createCell((short) 8);
				cell.setCellValue("发文编号");
				cell.setCellStyle(style);*/
				// 第五步，写入实体数据 实际应用中这些数据从数据库得到，
				pd = docqueryDao.getExcel_fw(SearchEntity.class,sb.toString() );
				for (int i = 0; i < pd.size(); i++) {
					row = sheet.createRow((int) i + 1);
					SearchEntity gwglList = pd.get(i);
					row.createCell((short) 0).setCellValue(gwglList.getBizType());
					row.createCell((short) 1).setCellValue(gwglList.getBizTitle());
					row.createCell((short) 2).setCellValue(gwglList.getDeptName());
					String state = "";
					if(StringUtils.isNotBlank(gwglList.getArchiveState())){
						if(gwglList.getArchiveState().equals("0")){
							state = "未归";
						}
						if(gwglList.getArchiveState().equals("1")){
							state = "已归";
						}
					}
					row.createCell((short) 3).setCellValue(state);
					row.createCell((short) 4).setCellValue(gwglList.getUserName());
					row.createCell((short) 5).setCellValue(gwglList.getAssignee());
					Timestamp time = gwglList.getCreateTime();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					String date = sdf.format(time);
					row.createCell((short) 6).setCellValue(date);
					row.createCell((short) 7).setCellValue(gwglList.getOrgName());
					row.createCell((short) 8).setCellValue(gwglList.getSerialNumber());
					String temp = "";
					if(StringUtils.isNotBlank(gwglList.getState())){
						if(gwglList.getState().equals("1")){
							temp = "在办";
						}
						if(gwglList.getState().equals("2")){
							temp = "办结";
						}
					}
					row.createCell((short) 9).setCellValue(temp);
					/*row.createCell((short) 8).setCellValue(gwglList.getDocNo());*/
				}

				// 不需要放到服务器上就可以导出下载
				String	fileName="公文查询.xls";
				String filePath = ConfigProvider.getPropertiesValue(
						"config.properties", "ftlPath");
				// 第六步，将文件存到指定位置
				try {
					FileOutputStream fout = new FileOutputStream(filePath + "/"
							+ fileName);
					wb.write(fout);
					fout.close();
				} catch (Exception e) {
					logger.error("error",e);
				}
				return filePath + "/" + fileName;
	}

	@SuppressWarnings({ "resource", "deprecation" })
	@Override
	public String getExcel(String[] params,String InputWordsw,String gwbt,String regUser,String sfgd,String bwzt) {
		List<SearchEntity> pd = new ArrayList<SearchEntity>();
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT aa.ID_ id, aa.BIZ_TITLE_ bizTitle, aa.BIZ_TYPE_ bizType, aa.CREATE_USER_ID_ createUserId,aa.CREATE_TIME_ createTime,");
		sb.append("aa.STATE_ state ,trim(aa.ARCHIVE_STATE_) archiveState,aa.URGENCY_ urgency,aa.CREATE_DEPT_ID_ createDeptId,aa.SERIAL_NUMBER_ serialNumber,");
		sb.append(" bb.USER_NAME userName, bb.DEPT_NAME deptName,bb.ORG_NAME orgName FROM BPM_RU_BIZ_INFO aa ");
		sb.append(" LEFT JOIN ISC_USER bb ON aa.CREATE_USER_ID_=bb.USER_ID");
		sb.append(" LEFT JOIN bpm_re_sol_ctlg ee ON aa.BIZ_TYPE_ = ee.code");
		sb.append(" WHERE aa.CREATE_USER_ID_=bb.USER_ID  AND aa.BIZ_TYPE_ LIKE '10010002%'");
		sb.append(" AND aa.DR_ = 'N' ");
		sb.append(" AND aa.STATE_ != '0' AND aa.STATE_ != '3' AND aa.STATE_ != '4'");
		sb.append(" AND aa.BIZ_TITLE_ like '%"+InputWordsw.trim()+"%'");
		if(StringUtils.isNotBlank(gwbt)){
			sb.append(" and aa.BIZ_TITLE_ like '%"+gwbt.trim()+"%'");
		}
		if(StringUtils.isNotBlank(bwzt)){
			sb.append(" and aa.STATE_  = '"+bwzt+"'");
		}
		if(StringUtils.isNotBlank(sfgd)){
			sb.append(" and aa.ARCHIVE_STATE_ = '"+sfgd+"'");
		}
		if(StringUtils.isNotBlank(regUser)){
			sb.append(" and bb.USER_NAME like '%"+regUser+"%'");
		}
		if(params.length > 0 && !params[0].equals("1")){
			sb.append(" AND aa.ID_ IN (");
			sb.append("'"+params[0]+"'");
			for(int i=1;i<params.length;i++){
				sb.append(",'"+params[i]+"'");
			}
			sb.append(" )");
		}
		sb.append(" group by aa.ID_");
		sb.append(" order by aa.CREATE_TIME_ desc");
		
		
		
		// 第一步，创建一个webbook，对应一个Excel文件
				HSSFWorkbook wb = new HSSFWorkbook();
				// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
				HSSFSheet sheet = wb.createSheet("公文查询");
				// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
				HSSFRow row = sheet.createRow((int) 0);
				// 第四步，创建单元格，并设置值表头 设置表头居中
				HSSFCellStyle style = wb.createCellStyle();
				style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式

				HSSFCell cell = row.createCell((short) 0);
				cell.setCellValue("公文标题");
				cell.setCellStyle(style);
				cell = row.createCell((short) 1);
				cell.setCellValue("登记部门");
				cell.setCellStyle(style);
				cell = row.createCell((short) 2);
				cell.setCellValue("登记人");
				cell.setCellStyle(style);
				cell = row.createCell((short) 3);
				cell.setCellValue("登记时间");
				cell.setCellStyle(style);
				cell = row.createCell((short) 4);
				cell.setCellValue("来文文号");
				cell.setCellStyle(style);
				cell = row.createCell((short) 5);
				cell.setCellValue("来文单位");
				cell.setCellStyle(style);
				cell = row.createCell((short) 6);
				cell.setCellValue("办文状态");
				cell.setCellStyle(style);
				cell = row.createCell((short) 7);
				cell.setCellValue("归档状态");
				cell.setCellStyle(style);
				// 第五步，写入实体数据 实际应用中这些数据从数据库得到，
				pd = docqueryDao.getExcel_fw(SearchEntity.class,sb.toString() );
				for (int i = 0; i < pd.size(); i++) {
					row = sheet.createRow((int) i + 1);
					SearchEntity gwglList = pd.get(i);
					row.createCell((short) 0).setCellValue(gwglList.getBizTitle());
					row.createCell((short) 1).setCellValue(gwglList.getDeptName());
					row.createCell((short) 2).setCellValue(gwglList.getUserName());
					Timestamp time = gwglList.getCreateTime();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					String date = sdf.format(time);
					row.createCell((short) 3).setCellValue(date);
					row.createCell((short) 4).setCellValue(gwglList.getDocNoSw());
					row.createCell((short) 5).setCellValue(gwglList.getDocUnit());
					String temp = "";
					if(gwglList.getState().equals("1")){
						temp = "在办";
					}
					if(gwglList.getState().equals("2")){
						temp = "办结";
					}
					row.createCell((short) 6).setCellValue(temp);
					String state = "";
					if(StringUtils.isNotBlank(gwglList.getArchiveState())){
						if(gwglList.getArchiveState().equals("0")){
							state = "未归";
						}
						if(gwglList.getArchiveState().equals("1")){
							state = "已归";
						}
					}
					row.createCell((short) 7).setCellValue(state);
				}

				// 不需要放到服务器上就可以导出下载
				String	fileName="公文查询.xls";
				String filePath = ConfigProvider.getPropertiesValue(
						"config.properties", "ftlPath");
				// 第六步，将文件存到指定位置
				try {
					FileOutputStream fout = new FileOutputStream(filePath + "/"
							+ fileName);
					wb.write(fout);
					fout.close();
				} catch (Exception e) {
					logger.error("error",e);
				}
				return filePath + "/" + fileName;
			}

}
