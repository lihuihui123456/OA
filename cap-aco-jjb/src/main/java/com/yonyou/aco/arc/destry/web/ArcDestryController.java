//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcDestryController-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.destry.web;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.arc.destry.entity.ArcDestryAll;
import com.yonyou.aco.arc.destry.entity.ArcDestryBean;
import com.yonyou.aco.arc.destry.entity.ArcDestryEntity;
import com.yonyou.aco.arc.destry.service.IArcDestryService;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.aco.arc.otherarc.service.IArcPubInfoService;
import com.yonyou.aco.arc.type.entity.ArcTypeBean;
import com.yonyou.aco.arc.type.entity.ArcTypeEntity;
import com.yonyou.aco.arc.type.service.IActTypeService;
import com.yonyou.aco.arc.utils.ExcelUtil;
import com.yonyou.cap.common.util.BeanUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * <p>
 * 概述：业务模块销毁管理Controller层
 * <p>
 * 功能：实现销毁管理的业务请求处理
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-12-28
 * <p>
 * 类调用特殊情况：无
 */
@Controller
@RequestMapping("/arcDestry")
public class ArcDestryController {
	@Resource
	IArcDestryService arcDestryService;
	@Resource
	IArcPubInfoService arcPubInfoService;
	@Autowired
	IActTypeService actTypeService;

	@RequestMapping("/index")
	@ResponseBody
	public ModelAndView index() {
		ModelAndView mv = new ModelAndView();
		List<ArcTypeEntity> listArcType = new ArrayList<ArcTypeEntity>();
/*		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
*/		listArcType = actTypeService.findParentFolderList();
		mv.addObject("listArcType", listArcType);
		mv.setViewName("/aco/arc/arcdestry/destryIndex");
		return mv;
	}

	/**
	 * 添加销毁管理操作
	 * 
	 * @param arcDestryEntity
	 */
	@RequestMapping("/add")
	@ResponseBody
	public String addArcDestry(@ModelAttribute ArcDestryEntity arcDestryEntity) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		arcDestryEntity.setDataUserId(user.getId());
		arcDestryEntity.setDr("N");
		arcDestryService.addArcDestry(arcDestryEntity);
		/*
		 * ArcPubInfoEntity selectPubInfoEntityById =
		 * arcPubInfoService.selectPubInfoEntityById
		 * (arcDestryEntity.getArcId());
		 * selectPubInfoEntityById.setIsInvalid("2");
		 * arcPubInfoService.updatePubInfoSumm(selectPubInfoEntityById);
		 */
		return "true";
	}

	/**
	 * 修改销毁管理
	 * 
	 * @param arcDestryEntity
	 */
	@RequestMapping("/update")
	@ResponseBody
	public void updateArcDestry(@ModelAttribute ArcDestryEntity arcDestryEntity) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		arcDestryEntity.setDataUserId(user.getId());
		arcDestryEntity.setDr("N");
		arcDestryService.updateArcDestry(arcDestryEntity);

	}
	/**
	 * 删除
	 * 
	 * @param arcDestryEntity
	 */
	@RequestMapping("/doDelArcDestry")
	@ResponseBody
	public String doDelArcDestry(@RequestParam(value = "id") String id) {
/*		ArcDestryEntity arcDestryEntity = new ArcDestryEntity();
		arcDestryEntity = arcDestryService.selectArcDestryEntityById(id);
		arcDestryEntity.setDr("Y");
*/		arcDestryService.deleteArcDestry(id);
		return "true";

	}
	/**
	 * 销毁
	 * 
	 * @param arcId
	 */
	@RequestMapping("/addDestry")
	@ResponseBody
	public String addArcDestry(@RequestParam(value = "id") String id) {
		ArcDestryEntity arcDestryEntity = new ArcDestryEntity();
		arcDestryEntity = arcDestryService.selectArcDestryEntityById(id);
		arcDestryEntity.setDestryTime(new Date());
		arcDestryService.updateArcDestry(arcDestryEntity);
		ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
				.selectPubInfoEntityById(arcDestryEntity.getArcId());
		selectPubInfoEntityById.setIsInvalid("2");
		arcPubInfoService.updatePubInfoSumm(selectPubInfoEntityById);
		return "true";
	}

	/**
	 * 查询销毁管理进行修改
	 * 
	 * @param arcId
	 */
	/*
	 * @RequestMapping("/updateReady")
	 * 
	 * @ResponseBody public ModelAndView updateReadyArcDestry(
	 * 
	 * @RequestParam(value = "arcId") String arcId) { ArcDestryAll arcDestryAll
	 * = new ArcDestryAll(); ArcDestryEntity selectArcDestryEntityById =
	 * arcDestryService .selectArcDestryEntityById(arcId); ArcPubInfoEntity
	 * selectPubInfoEntityById = arcPubInfoService
	 * .selectPubInfoEntityById(selectArcDestryEntityById.getArcId());
	 * BeanUtil.copy(arcDestryAll, selectArcDestryEntityById);
	 * BeanUtil.copy(arcDestryAll, selectPubInfoEntityById); ModelAndView mv =
	 * new ModelAndView(); mv.setViewName("/aco/docmgt/folderContentMngPaper");
	 * mv.addObject("arcDestryAll", arcDestryAll); return mv; }
	 */

	/**
	 * 分页查询
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcDestryAll
	 * @return
	 */
	@RequestMapping("/pageList")
	@ResponseBody
	public TreeGridView<ArcDestryAll> pageArcDestryEntity(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@ModelAttribute ArcDestryAll arcDestryAll) {
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			if(user == null){
				return null;
			}
			arcDestryAll.setDataUserId(user.getId());
			arcDestryAll.setArcName(new String(arcDestryAll.getArcName()
					.getBytes("iso-8859-1"), "utf-8"));
			arcDestryAll.setNbr(new String(arcDestryAll.getNbr()
					.getBytes("iso-8859-1"), "utf-8"));
			TreeGridView<ArcDestryAll> plist = new TreeGridView<ArcDestryAll>();
			try {
				if (pageNum != 0) {
					pageNum = pageNum / pageSize;
				}
				pageNum++;
				PageResult<ArcDestryEntity> pags = arcDestryService
						.pageArcDestryEntityList(pageNum, pageSize,
								arcDestryAll,user);
				List<ArcDestryAll> list = new ArrayList<ArcDestryAll>();
				for (int i = 0; i < pags.getResults().size(); i++) {
					ArcDestryEntity arcDestryEntity = pags.getResults().get(i);
					ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
							.selectPubInfoEntityById(arcDestryEntity.getArcId());
					ArcDestryAll arcDestryAllResult = new ArcDestryAll();
					BeanUtil.copy(arcDestryAllResult, selectPubInfoEntityById);
					BeanUtil.copy(arcDestryAllResult, arcDestryEntity);
					List<ArcTypeBean> findArcTypeInfoById = actTypeService
							.findArcTypeInfoById(arcDestryAllResult
									.getArcType());
					arcDestryAllResult.setTypeName(findArcTypeInfoById.get(0)
							.getTypeName());
					list.add(arcDestryAllResult);
				}
				plist.setRows(list);
				plist.setTotal(pags.getTotalrecord());
			} catch (Exception e) {
				e.printStackTrace();
			}
			return plist;
		} catch (Exception e) {
			return null;
		}
	}
	/**
	 * 分页查询
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcDestryAll
	 * @return
	 */
	@RequestMapping("/pageListSort")
	@ResponseBody
	public TreeGridView<ArcDestryBean> pageListSort(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@ModelAttribute ArcDestryAll arcDestryAll) {
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			if(user == null){
				return null;
			}
			arcDestryAll.setDataUserId(user.getId());
			arcDestryAll.setArcName(new String(arcDestryAll.getArcName()
					.getBytes("iso-8859-1"), "utf-8"));
			arcDestryAll.setNbr(new String(arcDestryAll.getNbr()
					.getBytes("iso-8859-1"), "utf-8"));
			TreeGridView<ArcDestryBean> plist = new TreeGridView<ArcDestryBean>();
			try {
				if (pageNum != 0) {
					pageNum = pageNum / pageSize;
				}
				pageNum++;
				PageResult<ArcDestryBean> pags = arcDestryService
						.pageArcDestryBeanList(pageNum, pageSize,
								arcDestryAll,user);
				List<ArcDestryBean> list = new ArrayList<ArcDestryBean>();
				for (int i = 0; i < pags.getResults().size(); i++) {
					ArcDestryBean arcDestryBean = pags.getResults().get(i);
/*					ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
							.selectPubInfoEntityById(arcDestryEntity.getArcId());
					ArcDestryAll arcDestryAllResult = new ArcDestryAll();
					BeanUtil.copy(arcDestryAllResult, selectPubInfoEntityById);
					BeanUtil.copy(arcDestryAllResult, arcDestryEntity);*/
					List<ArcTypeBean> findArcTypeInfoById = actTypeService
							.findArcTypeInfoById(arcDestryBean
									.getArc_type());
					arcDestryBean.setType_name(findArcTypeInfoById.get(0)
							.getTypeName());
					list.add(arcDestryBean);
				}
				plist.setRows(list);
				plist.setTotal(pags.getTotalrecord());
			} catch (Exception e) {
				e.printStackTrace();
			}
			return plist;
		} catch (Exception e) {
			return null;
		}
	}
	/**
	 * 
	 * TODO: 跳转会议记要新增主页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToDestryAdd")
	@ResponseBody
	public ModelAndView goToDestryAdd() {
		ModelAndView mv = new ModelAndView();

		mv.setViewName("/aco/arc/arcdestry/destryAdd");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转销毁管理表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToForm")
	@ResponseBody
	public ModelAndView goToForm() {
		ModelAndView mv = new ModelAndView();
		List<ArcTypeEntity> list = new ArrayList<ArcTypeEntity>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		list = actTypeService.findTypeFolderList(user.id);
		mv.addObject("resultList", list);
		/*
		 * String nbr=Identities.uuid2();
		 */
		Date date = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		String time = formatter.format(date);
		String nbr = "单号" + time;
		mv.addObject("nbr", nbr);
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String timeNow = df.format(date);
		mv.addObject("timeNow", timeNow);
		mv.setViewName("/aco/arc/arcdestry/destryAdd_form");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转会议记要修改主页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToDestryUpdate")
	@ResponseBody
	public ModelAndView goToDestryUpdate(@RequestParam(value = "id") String id) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("id", id);
		mv.setViewName("/aco/arc/arcdestry/destryUpdate");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转销毁管理表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToFormUpdate")
	@ResponseBody
	public ModelAndView goToFormUpdate(@RequestParam(value = "id") String id) {
		ModelAndView mv = new ModelAndView();
		ArcDestryEntity arcDestryEntity = arcDestryService
				.selectArcDestryEntityById(id);
		String arcId = arcDestryEntity.getArcId();
		ArcPubInfoEntity  apiEntity =arcPubInfoService.selectPubInfoEntityById(arcId);
		String arcType = apiEntity.getArcType();
		mv.addObject("arcType", arcType);
		mv.addObject("arcDestryEntity", arcDestryEntity);
		mv.setViewName("/aco/arc/arcdestry/destryUpdate_form");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转会议记要修改主页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToDestryView")
	@ResponseBody
	public ModelAndView goToDestryView(@RequestParam(value = "id") String id) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("id", id);
		mv.setViewName("/aco/arc/arcdestry/destryView");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转销毁管理表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToFormView")
	@ResponseBody
	public ModelAndView goToFormView(@RequestParam(value = "id") String id) {
		ModelAndView mv = new ModelAndView();
		ArcDestryEntity arcDestryEntity = arcDestryService
				.selectArcDestryEntityById(id);
		String arcId = arcDestryEntity.getArcId();
		
		ArcPubInfoEntity  apiEntity =arcPubInfoService.selectPubInfoEntityById(arcId);
		String arcType = apiEntity.getArcType();
		mv.addObject("arcDestryEntity", arcDestryEntity);
		mv.addObject("arcType", arcType);
		mv.setViewName("/aco/arc/arcdestry/destryView_form");
		return mv;
	}

	/**
	 * 
	 * @param request
	 * @param response
	 * @param arcDestryAll
	 *            查询条件
	 */
	@RequestMapping("/exportExcel")
	public void exportExcel(HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute ArcDestryAll arcDestryAll) {
		try {			
		List<ArcDestryAll> list = new ArrayList<ArcDestryAll>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			if (!StringUtils.isBlank(arcDestryAll.getSelectIds())) {
				// 支持单选功能
				ArcDestryEntity selectArcDestryEntityById = arcDestryService.selectArcDestryEntityById(arcDestryAll.getSelectIds());
				ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
						.selectPubInfoEntityById(selectArcDestryEntityById.getArcId());
				if(selectPubInfoEntityById!=null){
					if("0".equals(selectPubInfoEntityById.getExpiryDate())){
						selectPubInfoEntityById.setExpiryDate("永久有效");
					}else if("10".equals(selectPubInfoEntityById.getExpiryDate())){
						selectPubInfoEntityById.setExpiryDate("10年");
					}else if("30".equals(selectPubInfoEntityById.getExpiryDate())){
						selectPubInfoEntityById.setExpiryDate("30年");
					}
				}
				ArcDestryAll arcDestryAllResult = new ArcDestryAll();
				BeanUtil.copy(arcDestryAllResult, selectArcDestryEntityById);
				BeanUtil.copy(arcDestryAllResult, selectPubInfoEntityById);
				if(selectArcDestryEntityById.getOperTime()!=null){
					if("2".equalsIgnoreCase(arcDestryAllResult.getIsInvalid())){
						arcDestryAllResult.setOperTimeStr(DateFormatUtils.format(selectArcDestryEntityById.getOperTime(), "yyyy-MM-dd"));
					}
					else{
						arcDestryAllResult.setOperTimeStr("");
					}
				}
				list.add(arcDestryAllResult);
			} else {
			arcDestryAll.setArcName(new String(arcDestryAll.getArcName()
					.getBytes("iso-8859-1"), "utf-8"));
			arcDestryAll.setNbr(new String(arcDestryAll.getNbr()
					.getBytes("iso-8859-1"), "utf-8"));
			PageResult<ArcDestryEntity> pags = arcDestryService
					.pageArcDestryEntityList(1, 1, arcDestryAll,user);
			PageResult<ArcDestryEntity> pags1 = arcDestryService
					.pageArcDestryEntityList(1, (int) pags.getTotalrecord(),
							arcDestryAll,user);
			for (int i = 0; i < pags1.getResults().size(); i++) {
				ArcDestryEntity arcDestryEntity = pags1.getResults().get(i);
				ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
						.selectPubInfoEntityById(arcDestryEntity.getArcId());
				if(selectPubInfoEntityById!=null){
					if("0".equals(selectPubInfoEntityById.getExpiryDate())){
						selectPubInfoEntityById.setExpiryDate("永久有效");
					}else if("10".equals(selectPubInfoEntityById.getExpiryDate())){
						selectPubInfoEntityById.setExpiryDate("10年");
					}else if("30".equals(selectPubInfoEntityById.getExpiryDate())){
						selectPubInfoEntityById.setExpiryDate("30年");
					}
				}
				ArcDestryAll arcDestryAllResult = new ArcDestryAll();
				BeanUtil.copy(arcDestryAllResult, arcDestryEntity);
				BeanUtil.copy(arcDestryAllResult, selectPubInfoEntityById);
				if(arcDestryEntity.getOperTime()!=null){
					if("2".equalsIgnoreCase(arcDestryAllResult.getIsInvalid())){
						arcDestryAllResult.setOperTimeStr(DateFormatUtils.format(arcDestryEntity.getOperTime(), "yyyy-MM-dd"));
					}
					else{
						arcDestryAllResult.setOperTimeStr("");
					}
				}
				list.add(arcDestryAllResult);
			}}
			OutputStream ops = response.getOutputStream();
			HSSFWorkbook workbook = null;
			// 表头和对象属性
			String[] columnNames = { "销毁单号", "档案名称", "档案有效期", "操作员", "销毁日期" };
			String[] columnValues = { "nbr", "arcName", "expiryDate",
					"oper", "operTimeStr" };
			workbook = ExcelUtil.generateExcelFile(list, columnNames,
					columnValues);
			workbook.write(ops);
			String filename = "销毁管理";
			String agent = request.getHeader("USER-AGENT");
			if (null != agent && -1 != agent.indexOf("MSIE") || null != agent
					&& -1 != agent.indexOf("Trident")) {// ie

				String name = java.net.URLEncoder.encode(filename, "UTF8");

				filename = name;
			} else if (null != agent && -1 != agent.indexOf("Mozilla")) {// 火狐,chrome等
				filename = new String(filename.getBytes("UTF-8"), "iso-8859-1");
			}
			response.setContentType("text/html");
			response.setHeader("Content-Disposition", "attachment;filename="
					+ filename + ".xls");
			ops.close();
		}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * @跳转到选择档案
	 */
	@RequestMapping("/selectArc")
	public ModelAndView enclosureFile(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/aco/arc/arcdestry/arc_list");
		return mv;
	}

	/**
	 * 
	 * @param id
	 */
	@RequestMapping("/restoreDestry")
	@ResponseBody
	public String restoreDestry(@RequestParam(value = "id") String id) {
		ArcDestryEntity arcDestryEntity = new ArcDestryEntity();
		arcDestryEntity = arcDestryService.selectArcDestryEntityById(id);
		/*
		 * arcDestryEntity.setDr("Y");
		 * arcDestryService.updateArcDestry(arcDestryEntity);
		 */
		ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
				.selectPubInfoEntityById(arcDestryEntity.getArcId());
		selectPubInfoEntityById.setIsInvalid("0");
		arcPubInfoService.updatePubInfoSumm(selectPubInfoEntityById);
		return "true";
	}
}
