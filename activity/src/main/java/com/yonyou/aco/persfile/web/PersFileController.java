package com.yonyou.aco.persfile.web;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springside.modules.utils.PropertiesLoader;









import com.yonyou.aco.persfile.entity.PersFileEntity;
import com.yonyou.aco.persfile.entity.PersInfoBean;
import com.yonyou.aco.persfile.entity.PersInfoEntity;
import com.yonyou.aco.persfile.service.IPersFileService;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.common.util.BeanUtil;
import com.yonyou.cap.common.util.DataGridView;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.service.IExcelService;

/**
 * @TODO 人事档案控制层
 * @author HeGuoDong
 * @date 2017年6月27日
 */
@Controller
@RequestMapping("/persFileController")
public class PersFileController {

	@Resource
	IPersFileService persFileService;

	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;
	@Resource
	private IExcelService excelService;
	/**
	 * 
	 * TODO: 多条件分页获取人事管理列表信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param solId
	 * @param userName
	 * @param sortName
	 * @param sortOrder
	 * @param queryParams
	 * @return
	 */
	@RequestMapping("/findPersFileDateByQueryParams")
	@ResponseBody
	public DataGridView<PersInfoBean> findPersFileDateByQueryParams(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "solId", defaultValue = "") String solId,
			@RequestParam(value = "userName", defaultValue = "") String userName,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value = "queryParams", defaultValue = "") String queryParams) {
		DataGridView<PersInfoBean> page = new DataGridView<PersInfoBean>();
		try {
			userName = new String(userName.getBytes("iso-8859-1"), "utf-8");
			queryParams = java.net.URLDecoder.decode(queryParams, "UTF-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<PersInfoBean> pags = null;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if (user != null) {
				pags = persFileService.findPersFileDateByQueryParams(pageNum, pageSize, solId, userName, 

sortName,
						sortOrder, user.getUserId(), queryParams);
			}
			if (pags != null) {
				page.setRows(pags.getResults());
				page.setTotal(pags.getTotalrecord());
			}
			return page;
		} catch (Exception e) {
			return null;
		}

	}

	@RequestMapping("/doSavePersFileInfo")
	@ResponseBody
	public String doSavePersFileInfo(@RequestParam(value = "pers_file_id", defaultValue = "") String pers_file_id,
			@RequestParam(value = "user_name", defaultValue = "") String user_name,
			@RequestParam(value = "user_sex", defaultValue = "") String user_sex,
			@RequestParam(value = "user_cert_code", defaultValue = "") String user_cert_code,
			@RequestParam(value = "marital_status", defaultValue = "") String marital_status,
			@RequestParam(value = "user_education", defaultValue = "") String user_education,
			@RequestParam(value = "user_police_type", defaultValue = "") String user_police_type) {

		if (StringUtils.isNoneBlank(pers_file_id)) {
			PersFileEntity pfEntity = new PersFileEntity();
			pfEntity.setID(null);
			pfEntity.setPERS_FILE_ID(pers_file_id);
			pfEntity.setUSER_NAME(user_name);
			pfEntity.setUSER_SEX(user_sex);
			pfEntity.setUSER_CERT_CODE(user_cert_code);
			pfEntity.setMARITAL_STATUS(marital_status);
			pfEntity.setUSER_EDUCATION(user_education);
			pfEntity.setUSER_POLICE_TYPE(user_police_type);
			persFileService.doSavePersFileInfo(pfEntity);
			return "1";
		} else {
			return "0";
		}

	}

	@RequestMapping("/doDelPersFileInfoByPersFileId")
	@ResponseBody
	public String doDelPersFileInfoByPersFileId(@RequestParam(value = "persFileIds[]") String[] persFileIds) {
		String flag = "N";
		try {
			//bpmRuBizInfoService.doDeleteBpmRuBizInfoEntitysByBizIds(persFileIds);
			for(String id:persFileIds){
				PersInfoEntity findPersInfoEntityById = persFileService.findPersInfoEntityById(id);
				findPersInfoEntityById.setDr("Y");
				persFileService.doUpdatePersInfoEntity(findPersInfoEntityById);
			}
			flag = "Y";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}
	
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @param arcDestryAll
	 *            查询条件
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("/exportExcel")
	public void exportExcel(HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value = "selectIds", defaultValue = "") String  selectIds,
			@RequestParam(value = "queryParams", defaultValue = "") String queryParams) {
		try {			
			List<PersInfoBean> list = new ArrayList<PersInfoBean>();
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				if (!StringUtils.isBlank(selectIds)) {
					String[] split = selectIds.split(",");
					for(String id:split){
						PersInfoEntity findPersInfoEntityById =persFileService.findPersInfoEntityById(id);
						PersInfoBean persInfoBean=new PersInfoBean();
						BeanUtil.copy(persInfoBean, findPersInfoEntityById);
						list.add(persInfoBean);
					}
				} else {
					
					queryParams = java.net.URLDecoder.decode(queryParams, "UTF-8");
					PageResult<PersInfoBean> pags = null;
						pags = persFileService.findPersFileDateByQueryParams(1, 1, "", "", "",
								"", user.getUserId(), queryParams);
						pags = persFileService
								.findPersFileDateByQueryParams(1, (int) 

pags.getTotalrecord(), "", "", "","", user.getUserId(), queryParams);
				list=pags.getResults();
				}
				//对象的属性值转换如性别用男女代替1 2
				for(PersInfoBean persInfoBean:list){
					if(StringUtils.isNotBlank(persInfoBean.getUser_sex())){
						if(persInfoBean.getUser_sex().equals("1")){
							persInfoBean.setUser_sex("男");
						}else if(persInfoBean.getUser_sex().equals("0")){
							persInfoBean.setUser_sex("女");
						}else{
							persInfoBean.setUser_sex("未知");
						}
					}
					if(StringUtils.isNotBlank(persInfoBean.getMarital_status())){
						if(persInfoBean.getMarital_status().equals("1")){
							persInfoBean.setMarital_status("已婚");
						}else if(persInfoBean.getMarital_status().equals("0")){
							persInfoBean.setMarital_status("未婚");
						}else{
							persInfoBean.setMarital_status("未知");
						}
					}
					
					if(StringUtils.isNotBlank(persInfoBean.getUser_police_type())){
						if(persInfoBean.getUser_police_type().equals("dy")){
							persInfoBean.setUser_police_type("党员");
						}else if(persInfoBean.getUser_police_type().equals("ybdy")){
							persInfoBean.setUser_police_type("预备党员");
						}else if(persInfoBean.getUser_police_type().equals("gqty")){
							persInfoBean.setUser_police_type("共青团员");
						}else if(persInfoBean.getUser_police_type().equals("wdprs")){
							persInfoBean.setUser_police_type("无党派人士");
						}else if(persInfoBean.getUser_police_type().equals("qz")){
							persInfoBean.setUser_police_type("群众");
						}else{
							persInfoBean.setUser_police_type("未知");
						}
					}
				
					if(StringUtils.isNotBlank(persInfoBean.getUser_nation())){
						if(persInfoBean.getUser_nation().equals("hz")){
							persInfoBean.setUser_nation("汉族");
						}else if(persInfoBean.getUser_nation().equals("mz")){
							persInfoBean.setUser_nation("满族");
						}else if(persInfoBean.getUser_nation().equals("dwez")){
							persInfoBean.setUser_nation("达斡尔族");
						}else if(persInfoBean.getUser_nation().equals("zz")){
							persInfoBean.setUser_nation("壮族");
						}else if(persInfoBean.getUser_nation().equals("huiz")){
							persInfoBean.setUser_nation("回族");
						}else if(persInfoBean.getUser_nation().equals("miaoz")){
							persInfoBean.setUser_nation("苗族");
						}else if(persInfoBean.getUser_nation().equals("wwez")){
							persInfoBean.setUser_nation("维吾尔族");
						}else if(persInfoBean.getUser_nation().equals("mgz")){
							persInfoBean.setUser_nation("蒙古族");
						}else if(persInfoBean.getUser_nation().equals("zhangz")){
							persInfoBean.setUser_nation("藏族");
						}else if(persInfoBean.getUser_nation().equals("qtssmz")){
							persInfoBean.setUser_nation("其他少数民族");
						}else{
							persInfoBean.setUser_nation("未知");
						}
					}
					if(StringUtils.isNotBlank(persInfoBean.getUser_education())){
						if(persInfoBean.getUser_education().equals("bk")){
							persInfoBean.setUser_education("本科");
						}else if(persInfoBean.getUser_education().equals("ss")){
							persInfoBean.setUser_education("硕士研究生");
						}else if(persInfoBean.getUser_education().equals("bs")){
							persInfoBean.setUser_education("博士研究生");
						}else if(persInfoBean.getUser_education().equals("gz")){
							persInfoBean.setUser_education("高中");
						}else if(persInfoBean.getUser_education().equals("zk")){
							persInfoBean.setUser_education("专科");
						}else{
							persInfoBean.setUser_education("其他");
						}
					}
					
					if(StringUtils.isNotBlank(persInfoBean.getUser_duty_type())){
						if(persInfoBean.getUser_duty_type().equals("zsry")){
							persInfoBean.setUser_duty_type("正式人员");
						}else if(persInfoBean.getUser_duty_type().equals("jdry")){
							persInfoBean.setUser_duty_type("借调人员");
						}else if(persInfoBean.getUser_duty_type().equals("sxs")){
							persInfoBean.setUser_duty_type("实习生");
						}else{
							persInfoBean.setUser_duty_type("未知");
						}
					}
				}
				Map map = new HashMap();
				map.put("02", "userName_|姓名");
				map.put("03", "user_sex|性别");
				map.put("04", "user_height|身高");
				map.put("05", "marital_status|婚姻状况");				
				map.put("06", "user_native_place|籍贯");
				map.put("07", "user_police_type|政治面貌");
				map.put("08", "user_nation|民族");
				map.put("09", "user_cert_code|证件号码");
				map.put("10", "user_bitrth|出生日期");
				map.put("11", "user_education|学历");
				map.put("12", "user_degree|学位");
				map.put("13", "join_time|入党时间");
				map.put("14", "entry_time|调入时间");			
				map.put("15", "work_time|工作时间");
				map.put("16", "office_phone|办公电话");
				map.put("17", "telephone|手机号");
				map.put("18", "user_email|Email");
				map.put("19", "user_address|现住址");
				map.put("20", "user_seniority|用户工龄");
				map.put("21", "user_duty_type|人员类型");
				map.put("22", "deptName_|部门");				
				map.put("23", "duty_post|职务");
				map.put("24", "appointment|聘任岗位");
				map.put("25", "user_qq|用户QQ");
				String filePath = new PropertiesLoader("config.properties").getProperty("rootPath")+"\\人事管理.xls";
				String filename = "人事管理("+DateFormatUtils.format(new Date(), "yyyy-MM-dd")+").xls";
				excelService.doExportExcel(list,map,filePath,PersInfoBean.class);
				response.reset();
				response.setContentType("application/vnd.ms-excel");
				//attachment 很重要,用来标识是否在线阅读或者直接保存 "attachment;filename="
				response.setHeader("Content-Disposition", "filename=\"" + new String(filename.replaceAll(" ", "").getBytes("gb2312"),"iso8859-1"));
				//response.setHeader("Connection", "close");
				ServletOutputStream sos = response.getOutputStream();
				InputStream fis  = new FileInputStream(filePath);   
				byte b[] = new byte[1000];
				int j;
				while ((j = fis.read(b)) != -1) {
					try {
						sos.write(b, 0, j);
					} catch (IOException e) {
					}
				}
			    fis.close();
				sos.flush();
				sos.close();}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}