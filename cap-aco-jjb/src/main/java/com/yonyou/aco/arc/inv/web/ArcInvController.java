package com.yonyou.aco.arc.inv.web;

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

import com.yonyou.aco.arc.inv.entity.ArcInvBean;
import com.yonyou.aco.arc.inv.entity.ArcInvEntity;
import com.yonyou.aco.arc.inv.entity.ArcInvPageBean;
import com.yonyou.aco.arc.inv.service.IArcInvService;
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
 * TODO: 项目投资档案控制层 
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年12月29日
 * @author  hegd
 * @since   1.0.0
 */
@Controller
@RequestMapping("/arcInvController")
public class ArcInvController {

	
	@Resource IArcInvService arcInvService;
	
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
		mv.setViewName("/aco/arc/inv/list/arcinv-list");
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
		return "/aco/arc/inv/template/arcinv-index";
	}

	/**
	 * 
	 * TODO: 跳转招投标表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToForm")
	public String goToForm() {
		return "/aco/arc/inv/template/arcinv-form";
	}

	@RequestMapping("/goToAttr")
	public ModelAndView goToAttr(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "type", defaultValue = "") String type) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("arcId", arcId);
		mv.addObject("type", type);
		mv.setViewName("/aco/arc/inv/invatt/inv-att");
		return mv;
	}
	
	
	/**
	 * 
	 * TODO: 跳转到
	 * 
	 * @param arcId
	 * @return
	 */
	@RequestMapping("/goToArcInvAdd")
	public ModelAndView goToArcIntlAdd(@RequestParam(value = "typeId", defaultValue = "0") String typeId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcInvController/goToForm");
		map.put("attUrl", "arcInvController/goToAttr?arcId=");
		map.put("type", "add");
		map.put("typeId", typeId);
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/inv/template/arcinv-index");
		return mv;
	}

	@RequestMapping("/goToArcInvView")
	public ModelAndView goToArcIntlView(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart,
			@RequestParam(value = "type", defaultValue = "0") String type) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcInvController/viewArcInv?arcId=" + arcId+"&fileStart="+fileStart);
		map.put("type", type);
		map.put("attUrl", "arcInvController/goToAttr?arcId="+arcId+"&type=view");
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/inv/template/arcinv-index");
		return mv;
	}

	
	@RequestMapping("/goToArcInvUpdate")
	public ModelAndView goToArcInvUpdate(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "typeId", defaultValue = "0") String typeId,
			@RequestParam(value = "type", defaultValue = "0") String type,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcInvController/updateArcInv?arcId=" + arcId+"&fileStart="+fileStart);
		map.put("type", type);
		map.put("typeId", typeId);
		map.put("attUrl", "arcInvController/goToAttr?arcId="
				+ arcId);
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/inv/template/arcinv-update");
		return mv;
	}

	@RequestMapping("/viewArcInv")
	public ModelAndView viewArcIntl(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart) {
		ArcInvBean bean = arcInvService.findArcInvByArcId(arcId,fileStart);
		ModelAndView mv = new ModelAndView();
		mv.addObject("bean", bean);
		mv.setViewName("/aco/arc/inv/template/arcinv-view-form");
		return mv;
	}

	
	@RequestMapping("/updateArcInv")
	public ModelAndView updateArcInv(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart) {
		ArcInvBean bean = arcInvService.findArcInvByArcId(arcId,fileStart);
		ModelAndView mv = new ModelAndView();
		mv.addObject("bean", bean);
		mv.setViewName("/aco/arc/inv/template/arcinv-update-from");
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
	@RequestMapping(value = "/findAllArcInvData")
	public Map<String, Object> findAllArcInvData(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "arcName", defaultValue = "") String arcName,
			@RequestParam(value = "proName", defaultValue = "") String proName,
			@RequestParam(value = "startTime", defaultValue = "") String startTime,
			@RequestParam(value = "endTime", defaultValue = "") String endTime,
			@RequestParam(value = "year", defaultValue = "") String year,
			@RequestParam(value = "invType", defaultValue = "") String invType,
			@RequestParam(value = "fileStart", defaultValue = "") String fileStart) {
		try {
			arcName = new String(arcName.getBytes("iso-8859-1"), "utf-8");
			proName = new String(proName.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			PageResult<ArcInvBean> pags;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				pags = arcInvService.findAllArcInvData(pageNum, pageSize,
						arcName, proName, startTime, endTime,year,invType,fileStart,user);
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
	@RequestMapping(value = "/findAllArcInvDataPage")
	public Map<String, Object> findAllArcInvDataPage(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "arcName", defaultValue = "") String arcName,
			@RequestParam(value = "proName", defaultValue = "") String proName,
			@RequestParam(value = "startTime", defaultValue = "") String startTime,
			@RequestParam(value = "endTime", defaultValue = "") String endTime,
			@RequestParam(value = "year", defaultValue = "") String year,
			@RequestParam(value = "invType", defaultValue = "") String invType,
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
			PageResult<ArcInvPageBean> pags;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				pags = arcInvService.findAllArcInvData(pageNum, pageSize,
						arcName, proName, startTime, endTime,year,invType,fileStart,user,sortName,sortOrder);
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
	@RequestMapping("/doAddArcInvInfo")
	@ResponseBody
	public String doAddArcInvInfo(@Valid ArcInvBean aBean) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user == null){
			return "";
		}
		ArcInvEntity adEntity = new ArcInvEntity();
		ArcPubInfoEntity apEntity = new ArcPubInfoEntity();
		BeanUtil.copy(adEntity, aBean);
		BeanUtil.copy(apEntity, aBean);
		adEntity.setDataDeptCode(user.getDeptCode());
		adEntity.setDataOrgId(user.getOrgid());
		adEntity.setDataUserId(user.getUserId());
		arcInvService.doAddArcInvInfo(adEntity);
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
	@RequestMapping("/doUpdateSaveArcInvInfo")
	@ResponseBody
	public String doUpdateSaveArcInvInfo(@Valid ArcInvBean aBean) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user == null){
			return "error";
		}
		ArcInvEntity adEntity = new ArcInvEntity();
		ArcPubInfoEntity apEntity = new ArcPubInfoEntity();
		BeanUtil.copy(adEntity, aBean);
		BeanUtil.copy(apEntity, aBean);
		adEntity.setDataDeptCode(user.getDeptCode());
		adEntity.setDataOrgId(user.getOrgid());
		adEntity.setDataUserId(user.getUserId());
		arcInvService.doUpdateSaveArcInvInfo(adEntity);
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
	@RequestMapping("/exportInvExcel")
	public void exportInvExcel(HttpServletRequest request,
			HttpServletResponse response, @ModelAttribute SearchBean sbean) {

		try {		
			List<ArcInvBean> list = new ArrayList<ArcInvBean>();			
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				if (!StringUtils.isBlank(sbean.getSelectIds())) {
					// 支持单选功能
					ArcInvBean findArcInvByArcId = arcInvService.findArcInvByArcId(sbean.getSelectIds(), "");
					list.add(findArcInvByArcId);
				} else {
			String arcName= "";
			String proName ="";
			if(StringUtils.isNotBlank(sbean.getSarcName())){
				
				arcName = new String(sbean.getSarcName().getBytes("iso-8859-1"), "utf-8");
			}
			if(StringUtils.isNotBlank(sbean.getSproName())){
				proName = new String(sbean.getSproName().getBytes("iso-8859-1"), "utf-8");
			}
	
			PageResult<ArcInvBean> page =arcInvService.findAllArcInvData(1,
					Integer.MAX_VALUE, arcName, proName,
					sbean.getStartTime(), sbean.getEndTime(),
					sbean.getSearchregYear(),sbean.getInvType(),sbean.getFileStart(),user);
			list=page.getResults();
				}
			OutputStream ops = response.getOutputStream();
			HSSFWorkbook workbook = null;
			// 表头和对象属性
			String[] columnNames = { "文件标题", "投资项目名称", "投资金额", "投资占比", "投资时间",
					"资金来源", "投资收益情况", "投资收益支出","项目来源","项目金额","关键字","存放位置"};
			String[] columnValues = { "arcName", "proName", "mny","invPro","invDate",
					 "bankSrc", "invIncm", "invDeal","proSource","proMny","keyWord","depPos" };
			workbook = ExcelUtil.generateExcelFile(list, columnNames,
					columnValues);
			workbook.write(ops);
			String filename = "投资项目档案信息";
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
