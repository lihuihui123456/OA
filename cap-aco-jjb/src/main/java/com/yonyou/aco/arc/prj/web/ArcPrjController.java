package com.yonyou.aco.arc.prj.web;

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

import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.aco.arc.otherarc.entity.SearchBean;
import com.yonyou.aco.arc.otherarc.service.IArcPubInfoService;
import com.yonyou.aco.arc.prj.entity.ArcPrjBean;
import com.yonyou.aco.arc.prj.entity.ArcPrjEntity;
import com.yonyou.aco.arc.prj.entity.ArcPrjPageBean;
import com.yonyou.aco.arc.prj.service.IArcPrjService;
import com.yonyou.aco.arc.utils.DateUtil;
import com.yonyou.aco.arc.utils.ExcelUtil;
import com.yonyou.cap.common.util.BeanUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

@Controller
@RequestMapping("/arcPrjController")
public class ArcPrjController {

	@Resource
	IArcPrjService arcPrjService;

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
		mv.setViewName("/aco/arc/prj/list/arcprj-list");
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
		return "/aco/arc/prj/template/arcprj-index";
	}

	/**
	 * 
	 * TODO: 跳转招投标表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToForm")
	public String goToForm() {
		return "/aco/arc/prj/template/arcprj-form";
	}
	
	
	@RequestMapping("/goToAttr")
	public ModelAndView goToAttr(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "type", defaultValue = "") String type) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("arcId", arcId);
		mv.addObject("type", type);
		mv.setViewName("/aco/arc/prj/prjatt/prj-att");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转到
	 * 
	 * @param arcId
	 * @return
	 */
	@RequestMapping("/goToarcprjAdd")
	public ModelAndView goToarcprjAdd(@RequestParam(value = "typeId") String typeId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcPrjController/goToForm");
		map.put("attUrl", "arcPrjController/goToAttr?arcId=");
		map.put("type", "add");
		map.put("typeId", typeId);
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/prj/template/arcprj-index");
		return mv;
	}

	@RequestMapping("/goToarcPrjView")
	public ModelAndView goToarcprjView(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart,
			@RequestParam(value = "type", defaultValue = "0") String type) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcPrjController/viewArcPrj?arcId=" + arcId+"&fileStart="+fileStart);
		map.put("type", type);
		map.put("attUrl", "arcPrjController/goToAttr?arcId="+arcId+"&type=view");
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/prj/template/arcprj-index");
		return mv;
	}

	@RequestMapping("/viewArcPrj")
	public ModelAndView viewarcprj(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart) {
		ArcPrjBean bean = arcPrjService.findArcPrjByArcId(arcId,fileStart);
		ModelAndView mv = new ModelAndView();
		mv.addObject("bean", bean);
		mv.setViewName("/aco/arc/prj/template/arcprj-view-form");
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
	@RequestMapping(value = "/findAllArcPrjData")
	public Map<String, Object> findAllArcPrjData(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "arcName", defaultValue = "") String arcName,
			@RequestParam(value = "prjName", defaultValue = "") String prjName,
			@RequestParam(value = "startTime", defaultValue = "") String startTime,
			@RequestParam(value = "endTime", defaultValue = "") String endTime,
			@RequestParam(value = "year", defaultValue = "") String year,
			@RequestParam(value = "fileStart", defaultValue = "") String fileStart) {
		try {
			arcName = new String(arcName.getBytes("iso-8859-1"), "utf-8");
			prjName = new String(prjName.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			PageResult<ArcPrjBean> pags;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				pags = arcPrjService.findAllArcPrjData(pageNum, pageSize, arcName,
						prjName, startTime, endTime,year,fileStart,user);
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
	@RequestMapping(value = "/findAllArcPrjDataPage")
	public Map<String, Object> findAllArcPrjDataPage(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "arcName", defaultValue = "") String arcName,
			@RequestParam(value = "prjName", defaultValue = "") String prjName,
			@RequestParam(value = "startTime", defaultValue = "") String startTime,
			@RequestParam(value = "endTime", defaultValue = "") String endTime,
			@RequestParam(value = "year", defaultValue = "") String year,
			@RequestParam(value = "fileStart", defaultValue = "") String fileStart,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder) {
		try {
			arcName = new String(arcName.getBytes("iso-8859-1"), "utf-8");
			prjName = new String(prjName.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			PageResult<ArcPrjPageBean> pags;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				pags = arcPrjService.findAllArcPrjData(pageNum, pageSize, arcName,
						prjName, startTime, endTime,year,fileStart,user,sortName,sortOrder);
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
	@RequestMapping("/doAddarcprjInfo")
	@ResponseBody
	public String doAddarcprjInfo(@Valid ArcPrjBean aBean) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user == null){
			return "";
		}
		ArcPrjEntity abEntity = new ArcPrjEntity();
		ArcPubInfoEntity apEntity = new ArcPubInfoEntity();
		BeanUtil.copy(abEntity, aBean);
		BeanUtil.copy(apEntity, aBean);
		abEntity.setDataDeptCode(user.getDeptCode());
		abEntity.setDataOrgId(user.getOrgid());
		abEntity.setDataUserId(user.getUserId());
		arcPrjService.doAddarcprjInfo(abEntity);
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

	
	@RequestMapping("/goToArcPrjUpdate")
	public ModelAndView goToArcPrjUpdate(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "typeId", defaultValue = "0") String typeId,
			@RequestParam(value = "type", defaultValue = "0") String type,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcPrjController/updateArcPrj?arcId=" + arcId+"&fileStart="+fileStart);
		map.put("type", type);
		map.put("typeId", typeId);
		map.put("attUrl", "arcPrjController/goToAttr?arcId="
				+ arcId);
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/prj/template/arcprj-update");
		return mv;
	}
	@RequestMapping("/updateArcPrj")
	public ModelAndView updateArcPrj(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart) {
		ArcPrjBean bean = arcPrjService.findArcPrjByArcId(arcId,fileStart);
		ModelAndView mv = new ModelAndView();
		mv.addObject("bean", bean);
		mv.setViewName("/aco/arc/prj/template/arcprj-update-from");
		return mv;
	}
	
	
	/**
	 * TODO: 修改内部项目信息
	 * 
	 * @param aBean
	 * @return
	 */
	@RequestMapping("/doUpdateSaveArcPrjInfo")
	@ResponseBody
	public String doUpdateSaveArcPrjInfo(@Valid ArcPrjBean aBean) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user == null){
			return "error";
		}
		ArcPrjEntity adEntity = new ArcPrjEntity();
		ArcPubInfoEntity apEntity = new ArcPubInfoEntity();
		BeanUtil.copy(adEntity, aBean);
		BeanUtil.copy(apEntity, aBean);
		adEntity.setDataDeptCode(user.getDeptCode());
		adEntity.setDataOrgId(user.getOrgid());
		adEntity.setDataUserId(user.getUserId());
		arcPrjService.doUpdateArcPrjInfo(adEntity);
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
	@RequestMapping("/exportPrjExcel")
	public void exportPrjExcel(HttpServletRequest request,
			HttpServletResponse response, @ModelAttribute SearchBean sbean) {
		
		try {			
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		List<ArcPrjBean> list = new ArrayList<ArcPrjBean>();			
		if(user != null){
			if (!StringUtils.isBlank(sbean.getSelectIds())) {
				// 支持单选功能
				ArcPrjBean findArcPrjByArcId = arcPrjService.findArcPrjByArcId(sbean.getSelectIds(), "");				
				list.add(findArcPrjByArcId);
			} else {
			String arcName= "";
			String proName ="";
			if(StringUtils.isNotBlank(sbean.getSarcName())){
				
				arcName = new String(sbean.getSarcName().getBytes("iso-8859-1"), "utf-8");
			}
			if(StringUtils.isNotBlank(sbean.getSproName())){
				proName = new String(sbean.getSproName().getBytes("iso-8859-1"), "utf-8");
			}

			PageResult<ArcPrjBean> page =arcPrjService.findAllArcPrjData(1,
					Integer.MAX_VALUE, arcName, proName,
					sbean.getStartTime(), sbean.getEndTime(),
					sbean.getSearchregYear(),sbean.getFileStart(),user);
			list=page.getResults();
			}
			OutputStream ops = response.getOutputStream();
			HSSFWorkbook workbook = null;
			// 表头和对象属性
			String[] columnNames = { "文件标题", "项目名称", "项目地点", "项目编号", "项目联系人",
					"登记人", "关键字","存放位置","登记日期"};
			String[] columnValues = { "arcName", "prjName", "prjAdd","prjNbr","prjUser",
					 "regUser","keyWord","depPos","regDate" };
			workbook = ExcelUtil.generateExcelFile(list, columnNames,
					columnValues);
			workbook.write(ops);
			String filename = "工程基建档案信息";
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
