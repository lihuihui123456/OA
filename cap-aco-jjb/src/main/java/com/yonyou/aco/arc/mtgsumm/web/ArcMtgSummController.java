//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcMtgSummController-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.mtgsumm.web;

import java.io.OutputStream;
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

import com.yonyou.aco.arc.mtgsumm.entity.ArcMtgSummAll;
import com.yonyou.aco.arc.mtgsumm.entity.ArcMtgSummBean;
import com.yonyou.aco.arc.mtgsumm.entity.ArcMtgSummEntity;
import com.yonyou.aco.arc.mtgsumm.service.IArcMtgSummService;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.aco.arc.otherarc.service.IArcPubInfoService;
import com.yonyou.aco.arc.type.entity.ArcTypeEntity;
import com.yonyou.aco.arc.type.service.IActTypeService;
import com.yonyou.aco.arc.utils.DateUtil;
import com.yonyou.aco.arc.utils.ExcelUtil;
import com.yonyou.cap.common.util.BeanUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.service.IUserService;

/**
 * <p>
 * 概述：业务模块会议纪要Controller层
 * <p>
 * 功能：实现会议纪要的业务请求处理
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-12-21
 * <p>
 * 类调用特殊情况：无
 */
@Controller
@RequestMapping("/arcMtgSumm")
public class ArcMtgSummController {
	@Resource
	IArcMtgSummService arcMtgSummService;
	@Resource
	IArcPubInfoService arcPubInfoService;
	@Autowired
	IActTypeService actTypeService;
	@Resource
	IUserService iUserService;
	@RequestMapping("/index")
	@ResponseBody
	public ModelAndView index(@RequestParam(value = "id") String typeId,
			@RequestParam(value = "pId") String pId) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/aco/arc/mtgsumm/mtgSummIndex");
		mv.addObject("typeId", typeId);
		mv.addObject("pId", pId);
		return mv;
	}

	/**
	 * 添加会议纪要操作
	 * 
	 * @param arcMtgSummEntity
	 */
	@RequestMapping("/add")
	@ResponseBody
	public void addArcMtgSumm(
			@ModelAttribute ArcMtgSummEntity arcMtgSummEntity,
			@ModelAttribute ArcPubInfoEntity arcPubInfoEntity) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
		arcMtgSummEntity.setDataUserId(user.getId());
		arcMtgSummService.addArcMtgSumm(arcMtgSummEntity);
		arcPubInfoEntity.setArcId(arcMtgSummEntity.getArcId());
		//设置date类型有效期
		Date date=arcPubInfoEntity.getRegTime();
		int  num=Integer.parseInt(arcPubInfoEntity.getExpiryDate());
	   arcPubInfoEntity.setExpiryDateTime(DateUtil.getExpiryDate(num, date));
		arcPubInfoEntity.setDr("N");
		arcPubInfoEntity.setFileStart("0");
		arcPubInfoEntity.setIsInvalid("0");
		arcPubInfoService.addArcPubInfo(arcPubInfoEntity);
		}
	}

	/**
	 * 修改会议纪要
	 * 
	 * @param arcMtgSummEntity
	 */
	@RequestMapping("/update")
	@ResponseBody
	public void updateArcMtgSumm(
			@ModelAttribute ArcMtgSummEntity arcMtgSummEntity,
			@ModelAttribute ArcPubInfoEntity arcPubInfoEntity) {
		arcMtgSummService.updateArcMtgSumm(arcMtgSummEntity);
		//设置date类型有效期
		Date date=arcPubInfoEntity.getRegTime();
		int  num=Integer.parseInt(arcPubInfoEntity.getExpiryDate());
	    arcPubInfoEntity.setExpiryDateTime(DateUtil.getExpiryDate(num, date));
		arcPubInfoService.updatePubInfoSumm(arcPubInfoEntity);

	}

	/**
	 * 作废会议纪要
	 * 
	 * @param arcId
	 */
	@RequestMapping("/destryArcMtgSumm")
	@ResponseBody
	public String destryArcMtgSumm(@RequestParam(value = "arcId") String arcId) {	
		ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService.selectPubInfoEntityById(arcId);
		selectPubInfoEntityById.setIsInvalid("1");
		arcPubInfoService.updatePubInfoSumm(selectPubInfoEntityById);
		return "true";
	}
	/**
	 * 删除会议纪要
	 * 
	 * @param arcId
	 */
	@RequestMapping("/delete")
	@ResponseBody
	public void deleteArcMtgSumm(@RequestParam(value = "arcId") String arcId) {	
		arcMtgSummService.deleteArcMtgSumm(arcId);
	}

	/**
	 * 查询会议纪要进行修改
	 * 
	 * @param arcId
	 */
	@RequestMapping("/updateReady")
	@ResponseBody
	public ModelAndView updateReadyArcMtgSumm(
			@RequestParam(value = "arcId") String arcId) {
		ArcMtgSummAll arcMtgSummAll = new ArcMtgSummAll();
		ArcMtgSummEntity selectArcMtgSummEntityById = arcMtgSummService
				.selectArcMtgSummEntityById(arcId);
		ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
				.selectPubInfoEntityById(selectArcMtgSummEntityById.getArcId());
		BeanUtil.copy(arcMtgSummAll, selectArcMtgSummEntityById);
		BeanUtil.copy(arcMtgSummAll, selectPubInfoEntityById);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/aco/arc/docmgt/folderContentMngPaper");
		mv.addObject("arcMtgSummAll", arcMtgSummAll);
		return mv;
	}

	/**
	 * 分页查询
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcMtgSummAll
	 * @return
	 */
	@RequestMapping("/pageList")
	@ResponseBody
	public TreeGridView<ArcMtgSummBean> pageArcMtgSummEntity(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@ModelAttribute ArcMtgSummAll arcMtgSummAll) {
		try {
			arcMtgSummAll.setAmsName(new String(arcMtgSummAll.getAmsName()
					.getBytes("iso-8859-1"), "utf-8"));
		  ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		  if(user == null){
			  return null;
		  }
		  arcMtgSummAll.setRegUser(user.getId());				 
			TreeGridView<ArcMtgSummBean> plist = new TreeGridView<ArcMtgSummBean>();
			try {
				if (pageNum != 0) {
					pageNum = pageNum / pageSize;
				}
				pageNum++;
				PageResult<ArcMtgSummBean> pags = arcMtgSummService
						.pageArcMtgSummEntityList(pageNum, pageSize,
								arcMtgSummAll);
/*				List<ArcMtgSummAll> list = new ArrayList<ArcMtgSummAll>();
				for (int i = 0; i < pags.getResults().size(); i++) {
					ArcMtgSummBean arcMtgSummBean = pags.getResults()
							.get(i);
					ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
							.selectPubInfoEntityById(arcMtgSummBean
									.getArc_id());
					ArcMtgSummAll arcMtgSummAllResult = new ArcMtgSummAll();
					BeanUtil.copy(arcMtgSummAllResult, arcMtgSummEntity);
					BeanUtil.copy(arcMtgSummAllResult, selectPubInfoEntityById);
					list.add(arcMtgSummAllResult);
				}*/
				plist.setRows(pags.getResults());
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
	@RequestMapping("/goToMtgSummAdd")
	@ResponseBody
	public ModelAndView goToMtgSummAdd(
			@RequestParam(value = "id") String typeId,
			@RequestParam(value = "pId") String pId) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("typeId", typeId);
		mv.addObject("pId", pId);
		mv.setViewName("/aco/arc/mtgsumm/mtgSummAdd");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转会议纪要表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToForm")
	@ResponseBody
	public ModelAndView goToForm(@RequestParam(value = "id") String typeId,
			@RequestParam(value = "pId") String pId) {
		ModelAndView mv = new ModelAndView();
		List<ArcTypeEntity> list = new ArrayList<ArcTypeEntity>();
		List<ArcTypeEntity> listResult = new ArrayList<ArcTypeEntity>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			list = actTypeService.findFolderList(user.id);
			for(ArcTypeEntity arcTypeEntity:list){
				if(pId.equalsIgnoreCase(arcTypeEntity.getPrntId())){
					listResult.add(arcTypeEntity);
				}
			}
			mv.addObject("nowDate",DateFormatUtils.format(new Date(), "yyyy-MM-dd HH:mm:dd"));
			mv.addObject("resultList", listResult);
			mv.addObject("typeId", typeId);
			mv.addObject("pId", pId);
		}
		mv.setViewName("/aco/arc/mtgsumm/mtgSumm_form");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转会议记要修改主页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToMtgSummUpdate")
	@ResponseBody
	public ModelAndView goToMtgSummUpdate(
			@RequestParam(value = "id") String typeId,
			@RequestParam(value = "pId") String pId,
			@RequestParam(value = "arcId") String arcId,
			@RequestParam(value = "addFuJian") String addFuJian
			) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("typeId", typeId);
		mv.addObject("pId", pId);
		mv.addObject("arcId", arcId);
		mv.addObject("addFuJian", addFuJian);
		mv.setViewName("/aco/arc/mtgsumm/mtgSummUpdate");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转会议纪要表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToFormUpdate")
	@ResponseBody
	public ModelAndView goToFormUpdate(
			@RequestParam(value = "id") String typeId,
			@RequestParam(value = "pId") String pId,
			@RequestParam(value = "arcId") String arcId) {
		ModelAndView mv = new ModelAndView();
		ArcMtgSummAll arcMtgSummAll = new ArcMtgSummAll();
		ArcMtgSummEntity selectArcMtgSummEntityById = arcMtgSummService
				.selectArcMtgSummEntityById(arcId);
		ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
				.selectPubInfoEntityById(selectArcMtgSummEntityById.getArcId());
		BeanUtil.copy(arcMtgSummAll, selectArcMtgSummEntityById);
		BeanUtil.copy(arcMtgSummAll, selectPubInfoEntityById);
		arcMtgSummAll.setId(selectPubInfoEntityById.getId());
		List<ArcTypeEntity> list = new ArrayList<ArcTypeEntity>();
		List<ArcTypeEntity> listResult = new ArrayList<ArcTypeEntity>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			list = actTypeService.findFolderList(user.id);
			for(ArcTypeEntity arcTypeEntity:list){
				if(pId.equalsIgnoreCase(arcTypeEntity.getPrntId())){
					listResult.add(arcTypeEntity);
				}
			}
			mv.addObject("resultList", listResult);
			mv.addObject("arcMtgSummAll", arcMtgSummAll);
			mv.addObject("typeId", typeId);
			mv.addObject("pId", pId);
		}
		mv.setViewName("/aco/arc/mtgsumm/mtgSumm_form_update");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转会议记要修改主页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToMtgSummView")
	@ResponseBody
	public ModelAndView goToMtgSummView(
			@RequestParam(value = "id") String typeId,
			@RequestParam(value = "pId") String pId,
			@RequestParam(value = "arcId") String arcId) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("typeId", typeId);
		mv.addObject("pId", pId);
		mv.addObject("type", "view");
		mv.addObject("arcId", arcId);
		mv.setViewName("/aco/arc/mtgsumm/mtgSummView");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转会议纪要表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToFormView")
	@ResponseBody
	public ModelAndView goToFormView(@RequestParam(value = "id") String typeId,
			@RequestParam(value = "pId") String pId,
			@RequestParam(value = "arcId") String arcId) {
		ModelAndView mv = new ModelAndView();
		/*
		 * List<ArcTypeEntity> list = new ArrayList<ArcTypeEntity>();
		 *//*
			 * ShiroUser user = (ShiroUser)
			 * SecurityUtils.getSubject().getPrincipal(); list =
			 * actTypeService.findTypeFolderList(user.id);
			 */
		ArcMtgSummAll arcMtgSummAll = new ArcMtgSummAll();
		ArcMtgSummEntity selectArcMtgSummEntityById = arcMtgSummService
				.selectArcMtgSummEntityById(arcId);
		ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
				.selectPubInfoEntityById(selectArcMtgSummEntityById.getArcId());
		BeanUtil.copy(arcMtgSummAll, selectArcMtgSummEntityById);
		BeanUtil.copy(arcMtgSummAll, selectPubInfoEntityById);
		if(selectPubInfoEntityById.getFileUser()!=null){
			User user=iUserService.findUserById(selectPubInfoEntityById.getFileUser());
			arcMtgSummAll.setFileUserName(user.getUserName());
		}	
		mv.addObject("arcMtgSummAll", arcMtgSummAll);
		mv.addObject("typeId", typeId);
		mv.addObject("pId", pId);
		mv.setViewName("/aco/arc/mtgsumm/mtgSumm_form_view");
		return mv;
	}
	/**
	 * 
	 * TODO: 跳转会议纪要表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToFormViewSelect")
	@ResponseBody
	public ModelAndView goToFormViewSelect(
			@RequestParam(value = "arcId") String arcId,
			@RequestParam(value = "type") String type
			) {
		ModelAndView mv = new ModelAndView();
		ArcMtgSummEntity selectArcMtgSummEntityById = arcMtgSummService
				.selectArcMtgSummEntityById(arcId);
		ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
				.selectPubInfoEntityById(selectArcMtgSummEntityById.getArcId());	
		mv.addObject("typeId", selectArcMtgSummEntityById.getAmsType());
		mv.addObject("pId", selectPubInfoEntityById.getArcType());
		mv.addObject("arcId", arcId);
		mv.addObject("type",type);
		mv.setViewName("/aco/arc/mtgsumm/mtgSummView");
		return mv;
	}
	/**
	 * 
	 * @param arcid
	 */
	@RequestMapping("/restoreMtgSumm")
	@ResponseBody
	public String restoreMtgSumm(@RequestParam(value = "arcId") String arcId) {
		ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
				.selectPubInfoEntityById(arcId);
		selectPubInfoEntityById.setIsInvalid("0");
		arcPubInfoService.updatePubInfoSumm(selectPubInfoEntityById);
		return "true";
	}
	/**
	 * 
	 * @param request
	 * @param response
	 * @param arcMtgSummAll 查询条件
	 */
	@RequestMapping("/exportExcel")
	public void exportExcel(HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute ArcMtgSummAll arcMtgSummAll) {
		try {	  
		  ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		  if(user != null){
			List<ArcMtgSummBean> list=new ArrayList<ArcMtgSummBean>();
			if(!StringUtils.isBlank(arcMtgSummAll.getSelectIds())){
				//支持单选功能
				ArcMtgSummEntity selectArcMtgSummEntityById = arcMtgSummService
						.selectArcMtgSummEntityById(arcMtgSummAll.getSelectIds());
				ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
						.selectPubInfoEntityById(selectArcMtgSummEntityById.getArcId());
				ArcMtgSummBean arcMtgSummBean=new ArcMtgSummBean();
				arcMtgSummBean.setAms_name(selectArcMtgSummEntityById.getAmsName());
				arcMtgSummBean.setAms_time(selectArcMtgSummEntityById.getAmsTime());
				arcMtgSummBean.setAms_emcee(selectArcMtgSummEntityById.getAmsEmcee());
				arcMtgSummBean.setAms_add(selectArcMtgSummEntityById.getAmsAdd());
				arcMtgSummBean.setAms_topic(selectArcMtgSummEntityById.getAmsTopic());
				arcMtgSummBean.setSmd_dept(selectArcMtgSummEntityById.getSmdDept());
				arcMtgSummBean.setIlt_dept(selectArcMtgSummEntityById.getIltDept());
				arcMtgSummBean.setReg_user(selectPubInfoEntityById.getRegUser());
				arcMtgSummBean.setReg_dept(selectPubInfoEntityById.getRegDept());
				arcMtgSummBean.setDep_pos(selectPubInfoEntityById.getDepPos());
			    list.add(arcMtgSummBean);
			}else{
			arcMtgSummAll.setAmsName(new String(arcMtgSummAll.getAmsName().getBytes("iso-8859-1"), "utf-8"));
			  arcMtgSummAll.setRegUser(user.getId());	
			PageResult<ArcMtgSummBean> pags = arcMtgSummService
					.pageArcMtgSummEntityList(1, 1, arcMtgSummAll);
			PageResult<ArcMtgSummBean> pags1 = arcMtgSummService
					.pageArcMtgSummEntityList(1, (int) pags.getTotalrecord(),
							arcMtgSummAll);
			 list = pags1.getResults();
			 }
			OutputStream ops = response.getOutputStream();
			HSSFWorkbook workbook = null;
			// 表头和对象属性
			String[] columnNames = { "会议名称","会议时间","主持人","会议地点","会议议题","召集部门","参与部门","登记人","登记部门","存放位置"};
			String[] columnValues = { "ams_name","ams_time","ams_emcee","ams_add","ams_topic","smd_dept","ilt_dept","reg_user","reg_dept","dep_pos"};
			workbook = ExcelUtil.generateExcelFile(list, columnNames,columnValues);
			workbook.write(ops);
			String filename = "会议纪要";
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
}
