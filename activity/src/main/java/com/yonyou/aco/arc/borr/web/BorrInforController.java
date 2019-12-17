//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：张多一$手机：18701386200#
// SVN版本号                    日   期                 作     者              变更记录
// IBorrInforService-001     2016/12/21   张多一                  新建
//*********************************************************************
package com.yonyou.aco.arc.borr.web;

import java.io.OutputStream;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.time.DateUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.arc.borr.entity.BorrDept;
import com.yonyou.aco.arc.borr.entity.BorrInfoTableBean;
import com.yonyou.aco.arc.borr.entity.BorrInfor;
import com.yonyou.aco.arc.borr.entity.BorrInforWebShow;
import com.yonyou.aco.arc.borr.entity.BorrSHR;
import com.yonyou.aco.arc.borr.entity.BorrType;
import com.yonyou.aco.arc.borr.service.IBorrInforService;
import com.yonyou.aco.arc.type.entity.ArcTypeEntity;
import com.yonyou.aco.arc.type.service.IActTypeService;
import com.yonyou.aco.arc.utils.ExcelUtil;
import com.yonyou.cap.bpm.service.IDocNumMgrService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.sys.iweboffice.entity.IWebDocumentEntity;
import com.yonyou.cap.sys.iweboffice.service.DocumentService;

/**
 * <p>概述：借阅管理controller层接口
 * <p>功能：在controller层提供档借阅管理接口
 * <p>作者：张多一
 * <p>创建时间：2016-12-28
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/borrInforController")
public class BorrInforController {
	
	@Autowired
	IBorrInforService borrInforService;
	@Autowired
	private HttpServletRequest request;
	@Autowired
	IActTypeService actTypeService;
	@Autowired
	DocumentService documentService;
	
	@Autowired
	IDocNumMgrService docNumMgrService;
	
	@RequestMapping("/toBorrInforList")
	public ModelAndView toBorrInforList(){
		ModelAndView mav = new ModelAndView();
		List<ArcTypeEntity> arcTypeList = actTypeService.findAllArcTypeList();
		mav.addObject("arcType",arcTypeList);
		mav.addObject("borrDept", BorrDept.values());
		mav.setViewName("/aco/arc/borrinfor/borrInforList");
		//borrDept
		return mav;
	}
	
	@RequestMapping("/toArcPubInforTable")
	public ModelAndView toArcPubInforTable(){
		ModelAndView mav = new ModelAndView();
		String searchKey= request.getParameter("searchKey");
		mav.addObject("searchKey", searchKey);
		mav.setViewName("/aco/arc/borrinfor/arcPubInforTable");
		return mav;
	}
	
	@RequestMapping("/toBorrInforAdd")
	public ModelAndView toBorrInforAdd(){
		ModelAndView mav = new ModelAndView();
		
		String action = request.getParameter("action");
		String id=null;
		if(action!=null&&!"NULL".equalsIgnoreCase(action)&&!"".equals(action)){
			switch(action){
			case "add": 
				mav.addObject("iframePath", "toBorrInforform");
				mav.addObject("saveButton", "block");//show the save button
				mav.addObject("resetButton", "block");//hide the reset button
				mav.addObject("printButton", "none");//hide the print button
				break;
			case "read":
				mav.addObject("saveButton", "none");//hide the save button
				mav.addObject("resetButton", "none");//hide the reset button
				id = request.getParameter("id");
				if(id!=null&&!"NULL".equalsIgnoreCase(id)&&!"".equals(id)){
					
					mav.addObject("iframePath", "toBorrInforRead");
					mav.addObject("borrInforId", id);
					mav.addObject("printButton", "block");//show the print button
				}
				break;
			case "modify":
				id = request.getParameter("id");
				if(id!=null&&!"NULL".equalsIgnoreCase(id)&&!"".equals(id)){
					mav.addObject("borrInforId", id);
					mav.addObject("iframePath", "toBorrInforModify");
					mav.addObject("saveButton", "block");//show the save button
					mav.addObject("resetButton", "none");//show the reset button
					mav.addObject("printButton", "none");//hide the print button
				}
				break;
			default: 
				return null;
			}
		}
		mav.setViewName("/aco/arc/borrinfor/borrInforAdd");
		return mav;
	}
	@RequestMapping("/toBorrInforform")
	public ModelAndView toBorrInforform(){
		ModelAndView mav = new ModelAndView();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			mav.addObject("borrDept", BorrDept.values());
			mav.addObject("creUserName", user.getName());
			mav.addObject("creUserId", user.getId());
			//load the enums
			mav.addObject("borrType", BorrType.values());
			mav.addObject("borrSHR", BorrSHR.values());
			//TODO find the docNum under "1001"
			//数据库建立的文号是dept字段是“1001”
			Map<String, String> temp = docNumMgrService.findDocNumById("2", "1001");
			//{prefix=借阅[2017], length=4, suffix=号, middle=0001}
			String borNBR = temp.get("prefix")+ temp.get("middle") + temp.get("suffix");
			mav.addObject("borNBR", borNBR);
		}
		mav.setViewName("/aco/arc/borrinfor/borrInforForm");
		return mav;
	}
	
	@RequestMapping("/toBorrInforRead")
	public ModelAndView toBorrInforRead(){
		ModelAndView mav = new ModelAndView();
		String id = request.getParameter("id");
		if(id!=null&&!"NULL".equalsIgnoreCase(id)&&!"".equals(id)){
			BorrInforWebShow webshow = borrInforService.findBorrInforWebShowById(id);
			mav.addObject("show", webshow);
			
			mav.addObject("creUserName", webshow.getCreUserName());
			mav.addObject("creUserId", webshow.getBorrInfor().getCreUser());
			IWebDocumentEntity iwebDoc = documentService.selectByPrimaryKey(webshow.getBorrInfor().getAttId());
			mav.addObject("attName", iwebDoc.getFileName());
		}
		
		//load the enums
		mav.addObject("borrDept", BorrDept.values());
		mav.addObject("borrType", BorrType.values());
		mav.addObject("borrSHR", BorrSHR.values());
		mav.setViewName("/aco/arc/borrinfor/borrInforRead");
		return mav;
	}
	
	@RequestMapping("/toBorrInforModify")
	public ModelAndView toBorrInforModify(){
		ModelAndView mav = new ModelAndView();
		String id = request.getParameter("id");
		if(id!=null&&!"NULL".equalsIgnoreCase(id)&&!"".equals(id)){
			BorrInforWebShow webshow = borrInforService.findBorrInforWebShowById(id);
			mav.addObject("show", webshow);
			mav.addObject("creUserName", webshow.getCreUserName());
			mav.addObject("creUserId", webshow.getBorrInfor().getCreUser());
			IWebDocumentEntity iwebDoc = documentService.selectByPrimaryKey(webshow.getBorrInfor().getAttId());
			mav.addObject("attName", iwebDoc.getFileName());
			mav.addObject("showBorrisSet", webshow.getBorrInfor().getIsSet());
			mav.addObject("showBorrisBack", webshow.getBorrInfor().getIsBack());
		}

		//load the enums
		mav.addObject("borrType", BorrType.values());
		mav.addObject("borrSHR", BorrSHR.values());
		mav.setViewName("/aco/arc/borrinfor/borrInforModify");
		return mav;
	}
	
	@RequestMapping("/doFindAllBorrInforList")
	@ResponseBody
	public TreeGridView<BorrInforWebShow> doFindAllBorrInforList(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize){
		TreeGridView<BorrInforWebShow> treeGridview = new TreeGridView<BorrInforWebShow>();
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<BorrInforWebShow> pags=null;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			pags = borrInforService.findBorrInfor(user.getUserId(),pageNum, pageSize);
//			if(type==null||"".equals(type)){
//				pags = docInforService.findAllDocInfor(pageNum, pageSize);
//			}else{
//				pags = docInforService.findAllDocInfor(pageNum, pageSize, type);
//			}
			treeGridview.setRows(pags.getResults());
			treeGridview.setTotal(pags.getTotalrecord());
			return treeGridview;
		} catch (Exception e) {
			return treeGridview;
		}
	}
	
	@RequestMapping("/doFindAllBorrInforTableBean")
	@ResponseBody
	public TreeGridView<BorrInfoTableBean> doFindAllBorrInforTableBean(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "arcName", defaultValue = "") String arcName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value = "queryPams",defaultValue = "") String queryPams){
		TreeGridView<BorrInfoTableBean> treeGridview = new TreeGridView<BorrInfoTableBean>();
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<BorrInfoTableBean> pags=null;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			arcName = java.net.URLDecoder.decode(arcName,"UTF-8");
			arcName = java.net.URLDecoder.decode(arcName,"UTF-8");
			queryPams = java.net.URLDecoder.decode(queryPams,"UTF-8");
			pags = borrInforService.doFindAllBorrInforTableBean(user.getUserId(),pageNum, pageSize,queryPams,sortName,sortOrder,arcName);
//			if(type==null||"".equals(type)){
//				pags = docInforService.findAllDocInfor(pageNum, pageSize);
//			}else{
//				pags = docInforService.findAllDocInfor(pageNum, pageSize, type);
//			}
			treeGridview.setRows(pags.getResults());
			treeGridview.setTotal(pags.getTotalrecord());
			return treeGridview;
		} catch (Exception e) {
			return treeGridview;
		}
	}
	
	@RequestMapping("/doExportExcel")
	public void doExportExcel(HttpServletRequest request,HttpServletResponse response){
	try{
		String hideSelectionIds = request.getParameter("hideSelectionIds");
		String[] arr = hideSelectionIds.split(",");
		String hideInputWord = request.getParameter("hideInputWord");
		String dengjiBumen_ = request.getParameter("dengjiBumen_");
		String arcType = request.getParameter("arcType");
		String jieyueBumenId_ = request.getParameter("jieyueBumenId_");
		String arcName = request.getParameter("arcName");
		if(arcName!=null&&!"".equals(arcName)){
			arcName = new String(arcName.getBytes("ISO-8859-1"),"utf-8");
			arcName=URLDecoder.decode(arcName,"UTF-8");
			arcName=URLDecoder.decode(arcName,"UTF-8");
		}
		String borrUser = request.getParameter("jieyueUserId_");
		String planTimeBeginn = request.getParameter("planTimeBeginn");
		String planTimeEnd = request.getParameter("planTimeEnd");
		String actlTimeBeginn = request.getParameter("actlTimeBeginn");
		String actlTimeEnd = request.getParameter("actlTimeEnd");
		String isSet = request.getParameter("isSet");
		
		//make the end time add one day
		//make the end time add one day
		if(planTimeEnd!=null&&!"".equals(planTimeEnd)&&!"null".equals(planTimeEnd)){
			Date tempTime1 = new SimpleDateFormat("yyyy-MM-dd").parse(planTimeEnd);
			tempTime1 = DateUtils.addDays(tempTime1, 1);
			planTimeEnd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(tempTime1);
		}
		if(actlTimeEnd!=null&&!"".equals(actlTimeEnd)&&!"null".equals(actlTimeEnd)){
			Date tempTime = new SimpleDateFormat("yyyy-MM-dd").parse(actlTimeEnd);
			tempTime = DateUtils.addDays(tempTime, 1);
			actlTimeEnd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(tempTime);
		}
		
		List<BorrInforWebShow> showList = new ArrayList<BorrInforWebShow>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			showList = borrInforService.findAllDocInforByCondition(user.getUserId(),dengjiBumen_,arcType,jieyueBumenId_,arcName,
					borrUser,planTimeBeginn,planTimeEnd,actlTimeBeginn,actlTimeEnd,isSet,arr,hideInputWord);
		for(BorrInforWebShow item: showList){

			if("N".equals(item.getBorrInfor().getIsSet())){
				// no need to give back
				item.getBorrInfor().setPlanTime("");
				item.getBorrInfor().setActlTime("");
				item.getBorrInfor().setIsBack("无需归还");
			}else{
				//need to give back
				if( "Y".equals(item.getBorrInfor().getIsBack())){
					item.getBorrInfor().setIsBack("已经归还");
				}else if("N".equals(item.getBorrInfor().getIsBack())){
					item.getBorrInfor().setIsBack("未归还");
					item.getBorrInfor().setActlTime("");
				}
			}
		}
		
		OutputStream ops = response.getOutputStream();
		HSSFWorkbook workbook = null;
		// 表头和对象属性
		String[] columnNames = { "文件标题","登记部门","档案类型","借阅人","借阅部门","办理人","计划归还日期","实际归还日期","归还状态"};
		String[] columnValues = { "borrInfor.arcName","dengjiBumen","arcTypeName","borrUserName","jieyueBumen","creUserName","borrInfor.planTime","borrInfor.actlTime","borrInfor.isBack"};
		workbook = ExcelUtil.generateExcelFile(showList, columnNames,columnValues);
		workbook.write(ops);
		String filename = "借阅管理";
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
	
	@RequestMapping("/doExportExcelNew")
	public void doExportExcelNew(HttpServletRequest request,HttpServletResponse response){
	try{
		String selectionIds = request.getParameter("selectionIds");
		String[] arr = selectionIds.split(",");
		List<BorrInfoTableBean> showList = new ArrayList<BorrInfoTableBean>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			showList = borrInforService.findAllDocInfor(user.getUserId(),arr);
		for(BorrInfoTableBean item: showList){

			if("N".equals(item.getIS_RET())){
				// no need to give back
				item.setPLAN_TIME("");
				item.setACTL_TIME("");
				item.setIS_BACK("无需归还");
			}else{
				//need to give back
				if( "Y".equals(item.getIS_BACK())){
					item.setIS_BACK("已经归还");
				}else if("N".equals(item.getIS_BACK())){
					item.setIS_BACK("未归还");
					item.setACTL_TIME("");
				}
			}
		}
		
		OutputStream ops = response.getOutputStream();
		HSSFWorkbook workbook = null;
		// 表头和对象属性
		String[] columnNames = { "文件标题","登记部门","档案类型","借阅人","借阅部门","办理人","计划归还日期","实际归还日期","归还状态"};
		String[] columnValues = { "ARC_NAME","dengjibumen","TYPE_NAME","jiyueren","jiyuebumen","blr","PLAN_TIME","ACTL_TIME","IS_BACK"};
		workbook = ExcelUtil.generateExcelFile(showList, columnNames,columnValues);
		workbook.write(ops);
		String filename = "借阅档案";
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
	
	@RequestMapping("/doSearchBorrInfor")
	@ResponseBody
	public TreeGridView<BorrInforWebShow> doSearchBorrInfor(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize){
		
		TreeGridView<BorrInforWebShow> treeGridview = new TreeGridView<BorrInforWebShow>();
		try {
			String dengjiBumen_ = request.getParameter("dengjiBumen_");
			String arcType = request.getParameter("arcType");
			//String jieyueBumenId_ = request.getParameter("jieyueBumenId_");
			String jieyueBumenId_ = request.getParameter("borrDept");
			String arcName = request.getParameter("arcName");
			if(arcName!=null&&!"".equals(arcName)){
				arcName = new String(arcName.getBytes("ISO-8859-1"),"utf-8");
				arcName=URLDecoder.decode(arcName,"UTF-8");
				arcName=URLDecoder.decode(arcName,"UTF-8");
			}
			String borrUser = request.getParameter("borrUser");
			String planTimeBeginn = request.getParameter("planTimeBeginn");
			String planTimeEnd = request.getParameter("planTimeEnd");

			String actlTimeBeginn = request.getParameter("actlTimeBeginn");
			String actlTimeEnd = request.getParameter("actlTimeEnd");
			
			//make the end time add one day
			if(planTimeEnd!=null&&!"".equals(planTimeEnd)&&!"null".equals(planTimeEnd)){
				Date tempTime1 = new SimpleDateFormat("yyyy-MM-dd").parse(planTimeEnd);
				tempTime1 = DateUtils.addDays(tempTime1, 1);
				planTimeEnd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(tempTime1);
			}
			if(actlTimeEnd!=null&&!"".equals(actlTimeEnd)&&!"null".equals(actlTimeEnd)){
				Date tempTime = new SimpleDateFormat("yyyy-MM-dd").parse(actlTimeEnd);
				tempTime = DateUtils.addDays(tempTime, 1);
				actlTimeEnd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(tempTime);
			}
			
			String isSet = request.getParameter("isSet");
			
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<BorrInforWebShow> pags=null;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user == null){
				return null;
			}
			pags = borrInforService.findAllDocInforByCondition(user.getUserId(),pageNum, pageSize,dengjiBumen_,arcType,jieyueBumenId_,arcName,
					borrUser,planTimeBeginn,planTimeEnd,actlTimeBeginn,actlTimeEnd,isSet);
			treeGridview.setRows(pags.getResults());
			treeGridview.setTotal(pags.getTotalrecord());
			return treeGridview;
		} catch (Exception e) {
			e.printStackTrace();
			return treeGridview;
		}
		
		
	}
	
	@RequestMapping("/doFindBorrInforById")
	@ResponseBody
	public BorrInforWebShow doFindBorrInforById(@RequestParam(value = "id", defaultValue = "0") String id){
		BorrInforWebShow show = borrInforService.findBorrInforWebShowById(id);
		return show;
	}
	
	@RequestMapping("/doDelBorrInforById")
	@ResponseBody
	public Map<String,Object> doDelBorrInforById(@RequestParam(value = "ids", defaultValue = "0") String ids){
		Map<String,Object> resultMap = new HashMap<String,Object>();
		try {
			if (ids != null && !"".equals(ids)) {
				String[] idsArray = ids.split(",");
				for (int i = 0; i < idsArray.length; i++) {
					//docInforService.doDeleteDocInforById(idsArray[i]);
					borrInforService.delBorrInforById(idsArray[i]);
				}
			}
			resultMap.put("result", true);
		}catch(Exception e){
			resultMap.put("result", false);
		}
		return resultMap;
	}
	
	@RequestMapping("/doUpdateBorrInforById")
	@ResponseBody
	public Map<String,Object> doUpdateBorrInforById( BorrInfor borrInfor){
		Map<String,Object> resultMap = new HashMap<String,Object>();
		try {
			//时间如果为空字符串，需要把时间设置为null
			if(borrInfor.getActlTime()==null||"".equals(borrInfor.getActlTime())||"null".equalsIgnoreCase(borrInfor.getActlTime())){
				borrInfor.setActlTime(null);
				borrInfor.setIsBack("N");
			}else{
				borrInfor.setIsBack("Y");
			}
			if(borrInfor.getPlanTime()==null||"".equals(borrInfor.getPlanTime())||"null".equalsIgnoreCase(borrInfor.getPlanTime())){
				borrInfor.setPlanTime(null);
			}
			borrInforService.upDateBorrInfor(borrInfor);
			resultMap.put("result", true);
		}catch(Exception e){
			resultMap.put("result", false);
		}
		return resultMap;
	}
	
	@RequestMapping("/doReturnBorrInfor")
	@ResponseBody
	public Map<String,Object> doReturnBorrInfor(@RequestParam(value = "id", defaultValue = "0") String id){
		Map<String,Object> resultMap = new HashMap<String,Object>();
		try {
			//set the new value;
			BorrInfor temp = borrInforService.findBorrInforById(id);
			temp.setIsBack("Y");
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String ts = (df.format(new Date())).toString();
			temp.setActlTime(ts);
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			temp.setDataUserId(user.getId());
			temp.setDataDeptCode(user.getDeptCode());
			temp.setDataOrgId(user.getOrgid());
			borrInforService.setReturnBorrInfor(temp);;
			resultMap.put("result", true);
		}catch(Exception e){
			resultMap.put("result", false);
		}
		return resultMap;
	}	
	
	
	@RequestMapping("/doSaveBorrInfor")
	@ResponseBody
	public Map<String,Object> doSaveBorrInfor(BorrInfor borrInfor){
		Map<String,Object> resultMap = new HashMap<String,Object>();
		try {
			//set the new value;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user == null){
				return new HashMap<String,Object>();
			}
			borrInfor.setDataUserId(user.getUserId());
			borrInfor.setDataOrgId(user.getOrgid());
			borrInfor.setDataDeptCode(user.getDeptCode());
			
			//时间如果为空字符串，需要把时间设置为null
			if(borrInfor.getActlTime()==null||"".equals(borrInfor.getActlTime())||"null".equalsIgnoreCase(borrInfor.getActlTime())){
				borrInfor.setActlTime(null);
				borrInfor.setIsBack("N");
			}else{
				borrInfor.setIsBack("Y");
			}
			if(borrInfor.getPlanTime()==null||"".equals(borrInfor.getPlanTime())||"null".equalsIgnoreCase(borrInfor.getPlanTime())){
				borrInfor.setPlanTime(null);
			}
			borrInforService.saveBorrInfor(borrInfor);
			resultMap.put("result", true);
		}catch(Exception e){
			resultMap.put("result", false);
		}
		return resultMap;
	}
	
	@RequestMapping("/doPrintByBorrId")
	@ResponseBody
	public Map<String,Object> doPrintByBorrId(@RequestParam(value = "id", defaultValue = "0") String id){
		return borrInforService.doPrintByBorrId(id);
	}
}
