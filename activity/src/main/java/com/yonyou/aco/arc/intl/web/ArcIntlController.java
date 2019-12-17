package com.yonyou.aco.arc.intl.web;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.arc.intl.entity.ArcIntlBean;
import com.yonyou.aco.arc.intl.entity.ArcIntlEntity;
import com.yonyou.aco.arc.intl.entity.ArcIntlPageBean;
import com.yonyou.aco.arc.intl.service.IArcIntlService;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.aco.arc.otherarc.entity.SearchBean;
import com.yonyou.aco.arc.otherarc.service.IArcPubInfoService;
import com.yonyou.aco.arc.utils.DateUtil;
import com.yonyou.aco.arc.utils.ExcelUtil;
import com.yonyou.cap.common.util.BeanUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * TODO: 内部项目档案控制层 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月29日
 * @author hegd
 * @since 1.0.0
 */
@Controller
@RequestMapping("/arcIntlController")
public class ArcIntlController {

	@Resource
	IArcIntlService arcIntlService;

	@Resource
	IArcPubInfoService arcPubInfoService;

	/**
	 * 
	 * TODO:跳转招投标列表主页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToMain")
	public ModelAndView goToMain(@RequestParam(value = "id") String typeId) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("typeId", typeId);
		mv.setViewName("/aco/arc/intl/list/arcintl-list");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转招投标新增主页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToIndex")
	public ModelAndView goToIndex(@RequestParam(value = "id") String typeId) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("typeId", typeId);
		mv.setViewName("/aco/arc/intl/template/arcintl-index");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转招投标表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToForm")
	public String goToForm() {
		return "/aco/arc/intl/template/arcintl-form";
	}

	@RequestMapping("/goToAttr")
	public ModelAndView goToAttr(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "type", defaultValue = "") String type) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("arcId", arcId);
		mv.addObject("type", type);
		mv.setViewName("/aco/arc/intl/intlatt/intl-att");
		return mv;
	}
	
	
	/**
	 * 
	 * TODO: 跳转到
	 * 
	 * @param arcId
	 * @return
	 */
	@RequestMapping("/goToArcIntlAdd")
	public ModelAndView goToArcIntlAdd(@RequestParam(value = "typeId") String typeId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcIntlController/goToForm");
		map.put("type", "add");
		map.put("typeId", typeId);
		map.put("attUrl", "arcIntlController/goToAttr?arcId=");
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/intl/template/arcintl-index");
		return mv;
	}

	@RequestMapping("/goToArcIntlView")
	public ModelAndView goToArcIntlView(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart,
			@RequestParam(value = "type", defaultValue = "0") String type) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcIntlController/viewArcIntl?arcId=" + arcId+"&fileStart="+fileStart);
		map.put("type", type);
		map.put("attUrl", "arcIntlController/goToAttr?arcId="+ arcId+"&type=view");
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/intl/template/arcintl-index");
		return mv;
	}

	@RequestMapping("/goToArcIntlUpdate")
	public ModelAndView goToArcIntlUpdate(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "typeId", defaultValue = "0") String typeId,
			@RequestParam(value = "type", defaultValue = "0") String type,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcIntlController/updateArcIntl?arcId=" + arcId+"&fileStart="+fileStart);
		map.put("type", type);
		map.put("typeId", typeId);
		map.put("attUrl", "arcIntlController/goToAttr?arcId="+ arcId);
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/intl/template/arcintl-update");
		return mv;
	}

	@RequestMapping("/viewArcIntl")
	public ModelAndView viewArcIntl(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart) {
		ArcIntlBean bean = arcIntlService.findArcIntlByArcId(arcId,fileStart);
		ModelAndView mv = new ModelAndView();
		mv.addObject("bean", bean);
		mv.setViewName("/aco/arc/intl/template/arcintl-view-form");
		return mv;
	}

	@RequestMapping("/updateArcIntl")
	public ModelAndView updateArcIntl(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart) {
		ArcIntlBean bean = arcIntlService.findArcIntlByArcId(arcId,fileStart);
		ModelAndView mv = new ModelAndView();
		mv.addObject("bean", bean);
		mv.setViewName("/aco/arc/intl/template/arcintl-update-from");
		return mv;
	}

	/**
	 * 
	 * TODO: 获取所有招投标档案信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param typeName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findAllArcIntlData")
	public Map<String, Object> findAllArcIntlData(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "arcName", defaultValue = "") String arcName,
			@RequestParam(value = "proName", defaultValue = "") String proName,
			@RequestParam(value = "startTime", defaultValue = "") String startTime,
			@RequestParam(value = "endTime", defaultValue = "") String endTime,
			@RequestParam(value = "year", defaultValue = "") String year,
			@RequestParam(value = "fileStart", defaultValue = "") String fileStart) {
		try {
			arcName = new String(arcName.getBytes("iso-8859-1"), "utf-8");
			proName = new String(proName.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			PageResult<ArcIntlBean> pags;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				pags = arcIntlService.findAllArcIntlData(pageNum, pageSize,
						arcName, proName, startTime, endTime, year,fileStart,user);
				map.put("total", pags.getTotalrecord());
				map.put("rows", pags.getResults());
			}
			return map;
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * 
	 * TODO: 获取所有内部项目档案信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param typeName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findAllArcIntlDataPage")
	public Map<String, Object> findAllArcIntlDataPage(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "arcName", defaultValue = "") String arcName,
			@RequestParam(value = "proName", defaultValue = "") String proName,
			@RequestParam(value = "startTime", defaultValue = "") String startTime,
			@RequestParam(value = "endTime", defaultValue = "") String endTime,
			@RequestParam(value = "year", defaultValue = "") String year,
			@RequestParam(value = "fileStart", defaultValue = "") String fileStart,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder) {
		try {
			arcName = new String(arcName.getBytes("iso-8859-1"), "utf-8");
			proName = new String(proName.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			PageResult<ArcIntlPageBean> pags;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				pags = arcIntlService.findAllArcIntlData(pageNum, pageSize,
						arcName, proName, startTime, endTime, year,fileStart,user,sortName,sortOrder);
				map.put("total", pags.getTotalrecord());
				map.put("rows", pags.getResults());
			}
			return map;
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * 
	 * TODO: 添加招投标档案信息 TODO: 填入方法说明
	 * 
	 * @param aBean
	 * @return
	 */
	@RequestMapping("/doAddArcIntlInfo")
	@ResponseBody
	public String doAddArcIntlInfo(@Valid ArcIntlBean aBean) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user == null){
			return "";
		}
		ArcIntlEntity adEntity = new ArcIntlEntity();
		ArcPubInfoEntity apEntity = new ArcPubInfoEntity();
		BeanUtil.copy(adEntity, aBean);
		BeanUtil.copy(apEntity, aBean);
		adEntity.setDataDeptCode(user.getDeptCode());
		adEntity.setDataOrgId(user.getOrgid());
		adEntity.setDataUserId(user.getUserId());
		arcIntlService.doAddArcIntlInfo(adEntity);
		int num = Integer.parseInt(aBean.getExpiryDate());
		Date expiryDate = DateUtil.getExpiryDate(num, aBean.getRegTime());
		apEntity.setExpiryDateTime(expiryDate);
		apEntity.setDr("N");
		apEntity.setIsInvalid("0");
		apEntity.setId(null);
		apEntity.setFileStart("0");
		arcPubInfoService.addArcPubInfo(apEntity);
		return "Y";
	}

	/**
	 * TODO: 修改内部项目信息
	 * 
	 * @param aBean
	 * @return
	 */
	@RequestMapping("/doUpdateSaveArcIntInfo")
	@ResponseBody
	public String doUpdateSaveArcIntInfo(@Valid ArcIntlBean aBean) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user == null){
			return "error";
		}
		ArcIntlEntity adEntity = new ArcIntlEntity();
		ArcPubInfoEntity apEntity = new ArcPubInfoEntity();
		BeanUtil.copy(adEntity, aBean);
		BeanUtil.copy(apEntity, aBean);
		adEntity.setDataDeptCode(user.getDeptCode());
		adEntity.setDataOrgId(user.getOrgid());
		adEntity.setDataUserId(user.getUserId());
		arcIntlService.doUpdateArcIntlInfo(adEntity);
		int num = Integer.parseInt(aBean.getExpiryDate());
		Date expiryDate = DateUtil.getExpiryDate(num, aBean.getRegTime());
		apEntity.setExpiryDateTime(expiryDate);
		apEntity.setDr("N");
		apEntity.setIsInvalid("0");
		apEntity.setFileStart("0");
		apEntity.setDataDeptCode(user.getDeptCode());
		apEntity.setDataDeptId(user.getDeptId());
		apEntity.setDataUserId(user.getUserId());
		apEntity.setDataOrgId(user.getOrgid());
		arcPubInfoService.updatePubInfoSumm(apEntity);
		return "";
	}

	/**
	 * 
	 * @param request
	 * @param response
	 * @param arcMtgSummAll
	 *            查询条件
	 */
	@RequestMapping("/exportIntlExcel")
	public void exportAntlExcel(HttpServletRequest request,
			HttpServletResponse response, @ModelAttribute SearchBean sbean) {

		try {			
		List<ArcIntlBean> list = new ArrayList<ArcIntlBean>();			
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){ 
				if (!StringUtils.isBlank(sbean.getSelectIds())) {
					// 支持单选功能
					ArcIntlBean findArcIntlByArcId = arcIntlService.findArcIntlByArcId(sbean.getSelectIds(), "");
					list.add(findArcIntlByArcId);
				} else {
			String arcName= "";
			String proName ="";
			if(StringUtils.isNotBlank(sbean.getSarcName())){
				
				arcName = new String(sbean.getSarcName().getBytes("iso-8859-1"), "utf-8");
			}
			if(StringUtils.isNotBlank(sbean.getSproName())){
				proName = new String(sbean.getSproName().getBytes("iso-8859-1"), "utf-8");
			}
			PageResult<ArcIntlBean> page = arcIntlService.findAllArcIntlData(1,
					Integer.MAX_VALUE, arcName, proName,
					sbean.getStartTime(), sbean.getEndTime(),
					sbean.getSearchregYear(),sbean.getFileStart(),user);
		            list=page.getResults();
				}
			OutputStream ops = response.getOutputStream();
			HSSFWorkbook workbook = null;
			// 表头和对象属性
			String[] columnNames = { "文件标题", "项目名称", "文号", "登记人", "登记日期",
					"存放位置", "协议编号", "关键字"};
			String[] columnValues = { "arcName", "proName", "docNbr",
					"regUser", "regDate", "depPos", "agrNbr", "keyWord" };
			workbook = ExcelUtil.generateExcelFile(list, columnNames,
					columnValues);
			workbook.write(ops);
			String filename = "内部项目档案信息";
			filename = new String(filename.getBytes("gb2312"), "ISO8859-1");
			response.setContentType("text/html");
			response.setHeader("Content-Disposition", "attachment;filename="
					+ filename + ".xls");
			ops.close();
			}
		} catch (Exception e) {
			 e.printStackTrace();
		}
	}
}
