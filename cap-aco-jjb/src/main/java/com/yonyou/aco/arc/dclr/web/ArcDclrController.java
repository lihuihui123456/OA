package com.yonyou.aco.arc.dclr.web;

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

import com.yonyou.aco.arc.dclr.entity.ArcDclrBean;
import com.yonyou.aco.arc.dclr.entity.ArcDclrEntity;
import com.yonyou.aco.arc.dclr.entity.ArcDclrPageBean;
import com.yonyou.aco.arc.dclr.service.IArcDclrService;
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
 * TODO:申报课题档案控制层
 * TODO: 填写Class详细说明 
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年12月28日
 * @author  hegd
 * @since   1.0.0
 */
@Controller
@RequestMapping("/arcDclrController")
public class ArcDclrController {

	@Resource
	IArcDclrService arcDclrService;
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
		mv.setViewName("/aco/arc/arcdclr/list/arcdclr-list");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转招投标新增主页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToIndex")
	public String goToIndex() {
		return "/aco/arc/arcdclr/template/arcdclr-index";
	}

	/**
	 * 
	 * TODO: 跳转招投标表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToForm")
	public String goToForm() {
		return "/aco/arc/arcdclr/template/arcdclr-form";
	}

	
	@RequestMapping("/goToAttr")
	public ModelAndView goToAttr(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "type", defaultValue = "") String type) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("arcId", arcId);
		mv.addObject("type", type);
		mv.setViewName("/aco/arc/arcdclr/dclratt/dclr-att");
		return mv;
	}
	/**
	 * 
	 * TODO: 跳转到
	 * 
	 * @param arcId
	 * @return
	 */
	@RequestMapping("/goToArcDclrAdd")
	public ModelAndView goToArcDclrAdd(@RequestParam(value = "typeId", defaultValue = "0") String typeId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcDclrController/goToForm");
		map.put("attUrl", "arcDclrController/goToAttr?arcId=");
		map.put("type", "add");
		map.put("typeId", typeId);
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/arcdclr/template/arcdclr-index");
		return mv;
	}

	@RequestMapping("/goToArcDclrView")
	public ModelAndView goToArcDclrView(
			@RequestParam(value = "arcId", defaultValue = "") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "") String fileStart,
			@RequestParam(value = "type", defaultValue = "0") String type) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcDclrController/viewArcDclr?arcId=" + arcId+"&fileStart="+fileStart);
		map.put("type", type);
		map.put("attUrl", "arcDclrController/goToAttr?arcId="+arcId+"&type=view");
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/arcdclr/template/arcdclr-index");
		return mv;
	}

	@RequestMapping("/viewArcDclr")
	public ModelAndView viewArcDclr(
			@RequestParam(value = "arcId", defaultValue = "") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "") String fileStart) {
		ArcDclrBean bean = arcDclrService.findArcDclrByArcId(arcId,fileStart);
		ModelAndView mv = new ModelAndView();
		mv.addObject("bean", bean);
		mv.setViewName("/aco/arc/arcdclr/template/arcdclr-view-form");
		return mv;
	}

	
	@RequestMapping("/goToArcDclrUpdate")
	public ModelAndView goToArcDclrUpdate(
			@RequestParam(value = "arcId", defaultValue = "") String arcId,
			@RequestParam(value = "typeId", defaultValue = "") String typeId,
			@RequestParam(value = "type", defaultValue = "") String type,
			@RequestParam(value = "fileStart", defaultValue = "") String fileStart) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcDclrController/updateArcDclr?arcId=" + arcId+"&type="+type+"&fileStart="+fileStart);
		map.put("type", type);
		map.put("typeId", typeId);
		map.put("attUrl", "arcDclrController/goToAttr?arcId="+arcId);
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/arcdclr/template/arcdclr-update");
		return mv;
	}
	@RequestMapping("/updateArcDclr")
	public ModelAndView updateArcDclr(
			@RequestParam(value = "arcId", defaultValue = "") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "") String fileStart) {
		ArcDclrBean bean = arcDclrService.findArcDclrByArcId(arcId,fileStart);
		ModelAndView mv = new ModelAndView();
		mv.addObject("bean", bean);
		mv.setViewName("/aco/arc/arcdclr/template/arcdclr-update-from");
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
	@RequestMapping(value = "/findAllArcDclrData")
	public Map<String, Object> findAllArcDclrData(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "arcName", defaultValue = "") String arcName,
			@RequestParam(value = "proName", defaultValue = "") String proName,
			@RequestParam(value = "startTime", defaultValue = "") String startTime,
			@RequestParam(value = "endTime", defaultValue = "") String endTime,
			@RequestParam(value = "year", defaultValue = "") String year,
			@RequestParam(value = "proCom", defaultValue = "") String proCom,
			@RequestParam(value = "fileStart", defaultValue = "") String fileStart) {
		try {
			arcName = new String(arcName.getBytes("iso-8859-1"), "utf-8");
			proCom = new String(proCom.getBytes("iso-8859-1"), "utf-8");
			proName = new String(proName.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			PageResult<ArcDclrBean> pags;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				pags = arcDclrService.findAllArcDclrData(pageNum, pageSize,
						arcName, proName, startTime, endTime,year,proCom,fileStart,user);
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
	 * TODO: 获取所有招投标档案信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param typeName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findAllArcDclrDataPage")
	public Map<String, Object> findAllArcDclrDataPage(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "arcName", defaultValue = "") String arcName,
			@RequestParam(value = "proName", defaultValue = "") String proName,
			@RequestParam(value = "startTime", defaultValue = "") String startTime,
			@RequestParam(value = "endTime", defaultValue = "") String endTime,
			@RequestParam(value = "year", defaultValue = "") String year,
			@RequestParam(value = "proCom", defaultValue = "") String proCom,
			@RequestParam(value = "fileStart", defaultValue = "") String fileStart,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder) {
		try {
			arcName = new String(arcName.getBytes("iso-8859-1"), "utf-8");
			proCom = new String(proCom.getBytes("iso-8859-1"), "utf-8");
			proName = new String(proName.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			PageResult<ArcDclrPageBean> pags;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				pags = arcDclrService.findAllArcDclrData(pageNum, pageSize,
						arcName, proName, startTime, endTime,year,proCom,fileStart,user,sortName,sortOrder);
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
	@RequestMapping("/doAddArcDclrInfo")
	@ResponseBody
	public String doAddArcDclrInfo(@Valid ArcDclrBean aBean) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user == null){
			return "";
		}
		ArcDclrEntity adEntity = new ArcDclrEntity();
		ArcPubInfoEntity apEntity = new ArcPubInfoEntity();
		BeanUtil.copy(adEntity, aBean);
		BeanUtil.copy(apEntity, aBean);
		adEntity.setDataDeptCode(user.getDeptCode());
		adEntity.setDataOrgId(user.getOrgid());
		adEntity.setDataUserId(user.getUserId());
		arcDclrService.doAddArcDclrInfo(adEntity);
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
	 * @param aBean
	 * @return
	 */
	@RequestMapping("/doUpdateSaveArcDclrInfo")
	@ResponseBody
	public String doUpdateSaveArcDclrInfo(@Valid ArcDclrBean aBean) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user == null){
			return "error";
		}
		ArcDclrEntity adEntity = new ArcDclrEntity();
		ArcPubInfoEntity apEntity = new ArcPubInfoEntity();
		BeanUtil.copy(adEntity, aBean);
		BeanUtil.copy(apEntity, aBean);
		adEntity.setDataDeptCode(user.getDeptCode());
		adEntity.setDataOrgId(user.getOrgid());
		adEntity.setDataUserId(user.getUserId());
		arcDclrService.doUpdateArcIntlInfo(adEntity);
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
	 * @param sbean
	 *            查询条件
	 */
	@RequestMapping("/exportDclrExcel")
	public void exportDclrExcel(HttpServletRequest request,
			HttpServletResponse response, @ModelAttribute SearchBean sbean) {
		
		try {
			List<ArcDclrBean> list = new ArrayList<ArcDclrBean>();
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				if (!StringUtils.isBlank(sbean.getSelectIds())) {
					// 支持单选功能
					  ArcDclrBean findArcDclrByArcId = arcDclrService.findArcDclrByArcId(sbean.getSelectIds(), "");
					list.add(findArcDclrByArcId);
				} else {
			String arcName= "";
			String proCom = "";
			String proName ="";
			if(StringUtils.isNotBlank(sbean.getSarcName())){
				
				arcName = new String(sbean.getSarcName().getBytes("iso-8859-1"), "utf-8");
			}
			if(StringUtils.isNotBlank(sbean.getProCom())){
				proCom = new String(sbean.getProCom().getBytes("iso-8859-1"), "utf-8");
			}
			if(StringUtils.isNotBlank(sbean.getSproName())){
				proName = new String(sbean.getSproName().getBytes("iso-8859-1"), "utf-8");
			}
	
			PageResult<ArcDclrBean> page =arcDclrService.findAllArcDclrData(1,
					Integer.MAX_VALUE, arcName, proName,
					sbean.getStartTime(), sbean.getEndTime(),
					sbean.getSearchregYear(),proCom,sbean.getFileStart(),user);
			list=page.getResults();
				}
				
			OutputStream ops = response.getOutputStream();
			HSSFWorkbook workbook = null;
			// 表头和对象属性
			String[] columnNames = { "文件标题", "项目名称", "申报时间", "承担部门", "项目负责人",
					"资助金额（万元）", "立项单位", "关键字","存放位置","登记日期"};
			String[] columnValues = { "arcName", "proName", "decDate","bearDept","decUser",
					 "decMny", "proCom", "keyWord","depPos","regDate" };
			workbook = ExcelUtil.generateExcelFile(list, columnNames,
					columnValues);
			workbook.write(ops);
			String filename = "申报课题档案信息";
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
