//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：张多一$手机：18701386200#
// SVN版本号                    日   期                 作     者              变更记录
// DocInforController-001     2016/12/21   张多一                  新建
//*********************************************************************
package com.yonyou.aco.arc.doc.web;

import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.ParseException;
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
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.arc.doc.entity.DocInfor;
import com.yonyou.aco.arc.doc.entity.DocInforShow;
import com.yonyou.aco.arc.doc.entity.DocTableBean;
import com.yonyou.aco.arc.doc.entity.DocType;
import com.yonyou.aco.arc.doc.entity.ExpireTime;
import com.yonyou.aco.arc.doc.entity.FileStart;
import com.yonyou.aco.arc.doc.service.IDocInforService;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.aco.arc.otherarc.service.IArcPubInfoService;
import com.yonyou.aco.arc.type.entity.ArcTypeBean;
import com.yonyou.aco.arc.type.entity.ArcTypeEntity;
import com.yonyou.aco.arc.type.service.IActTypeService;
import com.yonyou.aco.arc.utils.DateUtil;
import com.yonyou.aco.arc.utils.ExcelUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.org.service.IDeptService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.service.IUserService;

/**
 * <p>概述：docinfor的controller
 * <p>功能：根据地址处理前段过来的http请求
 * <p>作者：张多一
 * <p>创建时间：2016-07-11
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/docInforController")
public class DocInforController {
	
	@Autowired
	IDocInforService docInforService;
	@Autowired
	IUserService userService;
	@Autowired
	IArcPubInfoService arcPubInforservice;
	@Autowired
	IActTypeService actTypeService;
	@Autowired
	IDeptService deptService;
	@Autowired
	private HttpServletRequest request;
	
	//private final static String WEIGUIDANG="未归档已归档追加归档";
	
	/**
	 * 跳转到docInforlist jsp页面
	 * @return
	 */
	@RequestMapping("/toDocInforList")
	public ModelAndView toDocInforList(){
		String fileTypeId = request.getParameter("id");
		String arcTypeId = request.getParameter("pId");
		ModelAndView mav = new ModelAndView();
		List<ArcTypeBean> arcTypeList= actTypeService.findArcTypeInfoById(fileTypeId);
		if(arcTypeList!=null&&arcTypeList.size()==1){
			mav.addObject("filestart", FileStart.values());
			mav.addObject("acrTypeId",arcTypeId);
			mav.addObject("fileTypeId", fileTypeId);
			mav.setViewName("/aco/arc/docinfor/docinfor-list");
			return mav;
		}
		return null;
	}
	
	@RequestMapping("/toDocInforform")
	public ModelAndView toDocInforform(){
		ModelAndView mav = new ModelAndView();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		String arcTypeId = request.getParameter("arcTypeId");

		
		mav.addObject("doctype", DocType.values());
		mav.addObject("filestart", FileStart.values());
		mav.addObject("expiretime", ExpireTime.values());
		String arcId = request.getParameter("arcId");
		//如果没有arcId为新增操作，有arcId则是读取和修改操作
		if(arcId!=null&&!"".equals(arcId)){
			DocInforShow show = new DocInforShow();
			//find the record
			show = docInforService.findDocInforById(arcId);
			if(show!=null){
				show.setRegUserName(userService.findUserById(show.getArcPubInfor().getDataUserId()).getUserName());
				//show.setRegDeptName(deptService.findDeptById(show.getArcPubInfor().getRegDept()).getDeptName());
				show.setRegDeptName(show.getArcPubInfor().getRegDept());
				if(show.getArcPubInfor().getFileUser()!=null||"".equals(show.getArcPubInfor().getFileUser())){
					show.setFileUserName(userService.findUserById(show.getArcPubInfor().getFileUser()).getUserName());
				}
				SimpleDateFormat formatter =  new   SimpleDateFormat( "yyyy-MM-dd ");
				String tempTime = formatter.format(show.getArcPubInfor().getRegTime());
				show.setRegTime(tempTime);
//				tempTime = show.getDocInfor().getDptTime().substring(0, 19);
//				show.getDocInfor().setDptTime(tempTime);
//				tempTime = show.getDocInfor().getRecTime().substring(0, 19);
//				show.getDocInfor().setRecTime(tempTime);
//				tempTime = show.getDocInfor().getEndTime().substring(0, 19);
//				show.getDocInfor().setEndTime(tempTime);
				arcTypeId = show.getArcPubInfor().getArcType();
				mav.addObject("show", show);
				mav.addObject("username", show.getRegUserName());
				mav.addObject("userid",show.getArcPubInfor().getRegUser());
				mav.addObject("deptname",show.getRegDeptName());
				mav.addObject("deptid",show.getArcPubInfor().getRegDept());
			}
			
		}else{
			if(user != null){
				mav.addObject("username", user.getName());
				mav.addObject("userid",user.getId());
				mav.addObject("deptname",user.getDeptName());
				mav.addObject("deptid",user.getDeptId());
			}
		}
		//add the file type list
		List<ArcTypeEntity> fileTypeList = actTypeService.findChildrenByPId(arcTypeId);
		mav.addObject("fileType",fileTypeList);
		
		//add “文书档案”
		List<ArcTypeBean> arcType = actTypeService.findArcTypeInfoById(arcTypeId);
		ArcTypeEntity arcTypeNew = new ArcTypeEntity();
		if(arcType!=null&&arcType.size()==1){
			arcTypeNew.setArcType(arcType.get(0).getArcType());
			arcTypeNew.setId(arcType.get(0).getId());
			arcTypeNew.setTypeName(arcType.get(0).getTypeName());
		}
		List<ArcTypeEntity> arcTypeList = new ArrayList<ArcTypeEntity>();
		arcTypeList.add(arcTypeNew);
		mav.addObject("arcType",arcTypeList);
		mav.setViewName("/aco/arc/docinfor/docInforForm");
		return mav;
	}
	
	@RequestMapping("/toDocInforAdd")
	public ModelAndView toDocInforAdd(){
		ModelAndView mav = new ModelAndView();
		String action = request.getParameter("action");//获取操作
		String id = request.getParameter("arcId");
		String fileType = request.getParameter("fileType");
		String arcTypeId = request.getParameter("arcTypeId");
		mav.addObject("action", action);//把操作传到页面上
		if("zhuijiadangan".equalsIgnoreCase(action)){
			//根据arcId获取实体,将实体改为未归档状态，并清空归档人和归档时间
			ArcPubInfoEntity temp = arcPubInforservice.selectPubInfoEntityById(id);
			if(temp!=null){
				temp.setFileStart("0");
				temp.setFileUser(null);
				temp.setFileTime(null);
				arcPubInforservice.updatePubInfoSumm(temp);
			}
		}
		mav.addObject("fileType", fileType);
		if("add".equalsIgnoreCase(action)){
			mav.addObject("resetBtn", "block");
		}else{
			mav.addObject("resetBtn", "none");
		}
		mav.addObject("arcId", id);//把arcId传到页面上
		mav.addObject("arcTypeId",arcTypeId);
		mav.setViewName("/aco/arc/docinfor/docInforAdd");
		return mav;
	}
	
	/**
	 * 根据id获取docinfor实体
	 * @param id
	 * @return
	 */
	@RequestMapping("/findDocInforById")
	@ResponseBody
	public DocInforShow findDocInforById(@RequestParam(value = "id", defaultValue = "0") String id){
		DocInforShow show = new DocInforShow();
		show = docInforService.findDocInforById(id);
		show.setRegUserName(userService.findUserById(show.getArcPubInfor().getRegUser()).getUserName());
		show.setRegDeptName(deptService.findDeptById(show.getArcPubInfor().getRegDept()).getDeptName());
		if(show.getArcPubInfor().getFileUser()!=null||"".equals(show.getArcPubInfor().getFileUser())){
			show.setFileUserName(userService.findUserById(show.getArcPubInfor().getFileUser()).getUserName());
		}
		SimpleDateFormat formatter =  new   SimpleDateFormat( "yyyy-MM-dd ");
		show.setRegTime(formatter.format(show.getArcPubInfor().getRegTime()));
		return show;	
	}
	
	
	/**
	 * 根据id获取docinfor实体
	 * @param id
	 * @return 返回到jsp页面
	 */
	@RequestMapping("/findDocInforViewById")
	@ResponseBody
	public ModelAndView findDocInforViewById(@RequestParam(value = "id", defaultValue = "0") String id){
		ModelAndView mav = new ModelAndView();
		
		DocInforShow show = new DocInforShow();
		show = docInforService.findDocInforById(id);
		show.setRegUserName(userService.findUserById(show.getArcPubInfor().getRegUser()).getUserName());
		show.setRegDeptName(deptService.findDeptById(show.getArcPubInfor().getRegDept()).getDeptName());
		if(show.getArcPubInfor().getFileUser()!=null||"".equals(show.getArcPubInfor().getFileUser())){
			show.setFileUserName(userService.findUserById(show.getArcPubInfor().getFileUser()).getUserName());
		}
		SimpleDateFormat formatter =  new   SimpleDateFormat( "yyyy-MM-dd ");
		show.setRegTime(formatter.format(show.getArcPubInfor().getRegTime()));
		mav.addObject("show", show);
		List<ArcTypeEntity> typeList = actTypeService.findArcTypeInfo();
		mav.addObject("arcType",typeList);
		mav.addObject("doctype", DocType.values());
		mav.addObject("filestart", FileStart.values());
		mav.addObject("expiretime", ExpireTime.values());
		mav.setViewName("/aco/arc/docinfor/docInforRead");
		return mav;
	}

	/**
	 * 根据id获取docinfor实体
	 * @param id
	 * @return 返回到jsp页面
	 */
	@RequestMapping("/findDocInforViewByArcId")
	public ModelAndView findDocInforViewByArcId(@RequestParam(value = "arcId", defaultValue = "0") String arcId){
		ModelAndView mav = new ModelAndView();
		
		DocInforShow show = new DocInforShow();
		//show = docInforService.findDocInforById(id);
		show = docInforService.findDocInforByArcId(arcId);
		show.setRegUserName(userService.findUserById(show.getArcPubInfor().getRegUser()).getUserName());
		show.setRegDeptName(deptService.findDeptById(show.getArcPubInfor().getRegDept()).getDeptName());
		if(show.getArcPubInfor().getFileUser()!=null||"".equals(show.getArcPubInfor().getFileUser())){
			show.setFileUserName(userService.findUserById(show.getArcPubInfor().getFileUser()).getUserName());
		}
		SimpleDateFormat formatter =  new   SimpleDateFormat( "yyyy-MM-dd ");
		show.setRegTime(formatter.format(show.getArcPubInfor().getRegTime()));
		mav.addObject("show", show);
		List<ArcTypeEntity> typeList = actTypeService.findArcTypeInfo();
		mav.addObject("arcType",typeList);
		mav.addObject("doctype", DocType.values());
		mav.addObject("filestart", FileStart.values());
		mav.addObject("expiretime", ExpireTime.values());
		mav.setViewName("/aco/arc/docinfor/docInforRead");
		return mav;
	}	
	
	
	/**
	 * 获取分页的DocInfor列表，采用后台分页
	 * @param pageNum 当前页码
	 * @param pageSize 每页显示条数
	 * @param type 查询条件
	 * @return
	 */
	@RequestMapping("/findAllDocInforList")
	@ResponseBody
	public TreeGridView<DocTableBean> findAllDocInforList(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value = "type") String type){
		
		TreeGridView<DocTableBean> treeGridview = new TreeGridView<DocTableBean>();
		
		//filter with login user
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user == null){
			return null;
		}
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<DocTableBean> pags=null;
			if(type==null||"".equals(type)){
				//pags = docInforService.findAllDocInfor(user.getUserId(),pageNum, pageSize);
			}else{
				pags = docInforService.findAllDocTabInfor(user.getUserId(),pageNum, pageSize, 
						type,sortName,sortOrder);
			}
			treeGridview.setRows(pags.getResults());
			treeGridview.setTotal(pags.getTotalrecord());
			return treeGridview;
		} catch (Exception e) {
			e.printStackTrace();
			return null;

		}
	}
	
	/**
	 * 设置档案归档
	 * @param arcId
	 * @return
	 */
	@RequestMapping("/doGuidang")
	@ResponseBody
	public Map<String,Object> doGuidang(@RequestParam(value="arcId") String arcId){
		Map<String,Object> resultMap = new HashMap<String,Object>();
		try{
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(arcId!=null&&!"".equals(arcId) && user != null){
//				ArcPubInfoEntity pubInfor = arcPubInforservice.selectPubInfoEntityById(arcId);
//				pubInfor.setFileStart(FileStart.getFileStartByChname("已归档").getValue());
//				pubInfor.setFileUser(user.getId());
//				pubInfor.setFileDept(user.getDeptId());
//				SimpleDateFormat  sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//				Date date = new Date();
//				String fileTime = sdf.format(date);
//				pubInfor.setFileTime(fileTime);
//				
//				arcPubInforservice.updatePubInfoSumm(pubInfor);
				arcPubInforservice.doUpdateFileStartByArcId(arcId,user);
			}
			resultMap.put("result", true);
		}catch(Exception e){
			resultMap.put("result", false);
		}
		return resultMap;
	}
	
	/**
	 * 保存docinfor
	 * @return result: true 成功
	 * 			result： false 失败
	 */			
	@RequestMapping("/doSaveDocInfor")
	@ResponseBody
	public Map<String,Object> doSaveDocInfor(){
		Map<String,Object> resultMap = new HashMap<String,Object>();
		DocInfor docinfor = new DocInfor();
		ArcPubInfoEntity pubInfor = new ArcPubInfoEntity();
		//get value from the request
		String arcId = request.getParameter("arcId");
		//arcId = Identities.uuid2();
		//String regUserId = request.getParameter("regUserId");
		//String regDeptId = request.getParameter("regDeptId");
		String regDeptName = request.getParameter("regDeptName");
		String regTime = request.getParameter("regTime");
		String arcType = request.getParameter("arcType");
		String fileType = request.getParameter("fileType");
		String docType = request.getParameter("docType");
		String dptTime = request.getParameter("dptTime");
		String docCo = request.getParameter("docCo");
		String docNBR = request.getParameter("docNBR");
		String arcName = request.getParameter("arcName");
		String pageNum = request.getParameter("pageNum");
		//String regUserId = request.getParameter("regUserId");//发文时间
		String recTime = request.getParameter("recTime");
		String endTime = request.getParameter("endTime");
		String keyWord = request.getParameter("keyWord");
		String depPos = request.getParameter("depPos");
		String expiryDate = request.getParameter("expiryDate");
		String remarks = request.getParameter("remarks");
		String regUser = request.getParameter("regUser");
		//fill the value
		pubInfor.setRegUser(regUser);
		pubInfor.setRegDept(regDeptName);
		Date date = null;
		try{
			date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(regTime); 
		}catch(java.text.ParseException e){
			try {
				date = new SimpleDateFormat("yyyy-MM-dd").parse(regTime);
			} catch (java.text.ParseException e1) {
				e1.printStackTrace();
			} 
		}
		pubInfor.setRegTime(date);
		pubInfor.setArcType(arcType);
		pubInfor.setFileType(fileType);
		docinfor.setDocType(docType);
		docinfor.setDocCo(docCo);
		docinfor.setDocNBR(docNBR);
		pubInfor.setArcName(arcName);
		docinfor.setPageNum(pageNum);
		//check the null situation
		if("".equals(dptTime)||"null".equalsIgnoreCase(dptTime)||dptTime==null){
			docinfor.setDptTime(null);
		}else{
			docinfor.setDptTime(dptTime);
		}
		if("".equals(recTime)||"null".equalsIgnoreCase(recTime)||recTime==null){
			
			docinfor.setRecTime(null);
		}else{
			docinfor.setRecTime(recTime);
		}
		if("".equals(endTime)||"null".equalsIgnoreCase(endTime)||endTime==null){
			
			docinfor.setEndTime(null);
		}else{
			docinfor.setEndTime(endTime);
		}
		pubInfor.setKeyWord(keyWord);
		pubInfor.setDepPos(depPos);
		pubInfor.setExpiryDate(expiryDate);
		try{
			//解析有效期
			int  num=Integer.parseInt(expiryDate);
			pubInfor.setExpiryDateTime(DateUtil.getExpiryDate(num, date));
		}catch(NumberFormatException e){
			e.printStackTrace();
			resultMap.put("result", false);
		}
		pubInfor.setRemarks(remarks);
		
		pubInfor.setArcId(arcId);
		docinfor.setArcId(arcId);
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		//get the login user infor
		if(user != null){
		docinfor.setDataOrgId(user.getOrgid());
		docinfor.setDataDeptCode(user.getDeptCode());
		docinfor.setDataUserId(user.getId());
		//set the data for the authority filter 
		pubInfor.setDataUserId(user.getUserId());
		pubInfor.setDataOrgId(user.getOrgid());
		pubInfor.setDataDeptCode(user.getDeptCode());
		pubInfor.setDataDeptId(user.getDeptId());
		}
		try{
			docInforService.doSaveDocInfor(docinfor,pubInfor);
			resultMap.put("result", true);
		}catch(Exception e){
			resultMap.put("result", false);
		}
		
		return resultMap;
	}
	
	/**
	 * 根据查询条件搜索
	 * @return 
	 */
	@RequestMapping("/searchDocinfor")
	@ResponseBody
	public TreeGridView<DocTableBean> searchDocinfor(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder){
		TreeGridView<DocTableBean> treeGridview = new TreeGridView<DocTableBean>();
		try{
			String searchArcType = request.getParameter("searchArcType");
			String searcharcName = request.getParameter("searcharcName");
			String title = request.getParameter("title");
			if(searcharcName!=null&&!"".equals(searcharcName)){
				searcharcName = new String(searcharcName.getBytes("ISO-8859-1"),"utf-8");
				searcharcName=URLDecoder.decode(searcharcName,"UTF-8");
				searcharcName=URLDecoder.decode(searcharcName,"UTF-8");
			}else if(title!=null&&!"".equals(title)){
				searcharcName = new String(title.getBytes("ISO-8859-1"),"utf-8");
				searcharcName=URLDecoder.decode(searcharcName,"UTF-8");
				searcharcName=URLDecoder.decode(searcharcName,"UTF-8");
				if("请输入标题查询".equals(searcharcName)){
					searcharcName = "";
				}
			}
			
			String searchdocNBR = request.getParameter("searchdocNBR");
			if(searchdocNBR!=null&&!"".equals(searchdocNBR)){
				searchdocNBR = new String(searchdocNBR.getBytes("ISO-8859-1"),"utf-8");
				searchdocNBR=URLDecoder.decode(searchdocNBR,"UTF-8");
				searchdocNBR=URLDecoder.decode(searchdocNBR,"UTF-8");
			}
			String searchfileStart = request.getParameter("searchfileStart");
			String searchregYear = request.getParameter("searchregYear");
			String regTimeBeginn = request.getParameter("regTimeBeginn");
			String regTimeEnd = request.getParameter("regTimeEnd");
			if(regTimeEnd!=null&&!"".equalsIgnoreCase(regTimeEnd)&&!"null".equalsIgnoreCase(regTimeEnd)){
				Date temp = new SimpleDateFormat("yyyy-MM-dd").parse(regTimeEnd);
				temp = DateUtils.addDays(temp, 1);
				regTimeEnd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(temp);
			}
			
			String type = request.getParameter("type");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<DocTableBean> pags=null;
			
			//user 
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user == null){
				return null;
			}
			
			pags = docInforService.findAllDocTabInfor(user.getUserId(),pageNum, pageSize, searchArcType,searcharcName,
					searchdocNBR,searchfileStart,searchregYear,regTimeBeginn,regTimeEnd,type,sortName,sortOrder);
			
			treeGridview.setRows(pags.getResults());
			treeGridview.setTotal(pags.getTotalrecord());
			return treeGridview;			
			
		}catch(UnsupportedEncodingException | ParseException e){
			e.printStackTrace();
			return treeGridview;
		}

	}
	
	/**
	 * 根据id删除实体
	 * @param ids
	 * @return result: true 成功
	 * 			result： false 失败
	 */
	@RequestMapping("/doDeleteDocInfor")
	@ResponseBody
	public Map<String,Object> doDeleteDocInfor(@RequestParam(value = "ids", defaultValue = "0") String ids){
		Map<String,Object> resultMap = new HashMap<String,Object>();
		try {
			if (ids != null && !"".equals(ids)) {
				String[] idsArray = ids.split(",");
				for (int i = 0; i < idsArray.length; i++) {
					//docInforService.doDeleteDocInforById(idsArray[i]);
					arcPubInforservice.doDelArcInfoByArcId(idsArray[i]);
				}
			}
			resultMap.put("result", true);
		}catch(Exception e){
			resultMap.put("result", false);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @param arcMtgSummAll 查询条件
	 */
	@RequestMapping("/doExportExcel")
	public void doExportExcel(HttpServletRequest request,HttpServletResponse response) {
		try {
			String selectionIds = request.getParameter("selectionIds");
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			List<DocInforShow> showlist;
			String globalFileType = request.getParameter("globalFileType");
			String searchArcType = request.getParameter("searchArcType");
			if(user != null){
			if(selectionIds == null||"".equals(selectionIds)){
				String title = request.getParameter("title");
				title = new String(title.getBytes("ISO-8859-1"),"utf-8");
				title=URLDecoder.decode(title,"UTF-8");
				title=URLDecoder.decode(title,"UTF-8");
				if(title!=null&&!"".equals(title)&&!"请输入标题查询".equals(title)){
					if(!StringUtils.isEmpty(globalFileType)){
						showlist = docInforService.findAllDocInforByTitle(user.getName(),searchArcType,globalFileType,title);
					}else{
						showlist = docInforService.findAllDocInforByTitle(user.getUserId(),searchArcType,title);
					}
				}else{
					String searcharcName = request.getParameter("searcharcName");
					if(searcharcName!=null&&!"".equals(searcharcName)){
						searcharcName = new String(searcharcName.getBytes("ISO-8859-1"),"utf-8");
						searcharcName=URLDecoder.decode(searcharcName,"UTF-8");
						searcharcName=URLDecoder.decode(searcharcName,"UTF-8");
					}
					String searchdocNBR = request.getParameter("searchdocNBR");
					if(searchdocNBR!=null&&!"".equals(searchdocNBR)){
						searchdocNBR = new String(searchdocNBR.getBytes("ISO-8859-1"),"utf-8");
						searchdocNBR=URLDecoder.decode(searchdocNBR,"UTF-8");
						searchdocNBR=URLDecoder.decode(searchdocNBR,"UTF-8");
					}
					String searchfileStart = request.getParameter("searchfileStart");
					String searchregYear = request.getParameter("searchregYear");
					String regTimeBeginn = request.getParameter("regTimeBeginn");
					String regTimeEnd = request.getParameter("regTimeEnd");
					if(regTimeEnd!=null&&!"".equalsIgnoreCase(regTimeEnd)&&!"null".equalsIgnoreCase(regTimeEnd)){
						Date temp = new SimpleDateFormat("yyyy-MM-dd").parse(regTimeEnd);
						temp = DateUtils.addDays(temp, 1);
						regTimeEnd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(temp);
					}
					
					
					if(!StringUtils.isEmpty(globalFileType)){
						showlist = docInforService.findAllDocInforByCondition(user.getName(),searchArcType,globalFileType,searcharcName,
								searchdocNBR,searchfileStart,searchregYear,regTimeBeginn,regTimeEnd);
					}else{
						showlist = docInforService.findAllDocInforByCondition(user.getUserId(),searchArcType,searcharcName,
								searchdocNBR,searchfileStart,searchregYear,regTimeBeginn,regTimeEnd);
					}
				}
			}else{
				if(!StringUtils.isEmpty(globalFileType)){
					showlist = docInforService.findAllDocInforByCondition(user.getName(),searchArcType,globalFileType,selectionIds);
				}else{
					showlist = docInforService.findAllDocInforByCondition(user.getUserId(),searchArcType,selectionIds);
				}
			}
			String fileStatus = null;
			String weiGuidangV = FileStart.WEIGUIDANG.getValue();
			String yiGuidangV = FileStart.YIGUIDANG.getValue();
			for(DocInforShow temp: showlist){
				fileStatus = temp.getArcPubInfor().getFileStart();
				//0:未归档1:已归档2：追加归档',
				if(fileStatus!=null&&!"".equals(fileStatus)){
					if(fileStatus.equals(weiGuidangV)){
						temp.getArcPubInfor().setFileStart(FileStart.WEIGUIDANG.getChname());
					}else if(fileStatus.equals(yiGuidangV)){
						temp.getArcPubInfor().setFileStart(FileStart.YIGUIDANG.getChname());
					}
				}
			}
			OutputStream ops = response.getOutputStream();
			HSSFWorkbook workbook = null;
			// 表头和对象属性
			String[] columnNames = { "登记日期","文件标题","来文单位","文号","登记人","归档状态","存放位置"};
			String[] columnValues = { "regTime","arcPubInfor.arcName","docInfor.docCo","docInfor.docNBR","regUserName","arcPubInfor.fileStart","arcPubInfor.depPos"};
			workbook = ExcelUtil.generateExcelFile(showlist, columnNames,columnValues);
			workbook.write(ops);
			String filename = "文书档案查询结果";
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
	 * 更新实体
	 * @return result: true 成功
	 * 			result： false 失败
	 */
	@RequestMapping("/doUpdateDocInfor")
	@ResponseBody
	public Map<String,Object> doUpdateDocInfor(){
		Map<String,Object> resultMap = new HashMap<String,Object>();
		DocInfor docinfor = new DocInfor();
		ArcPubInfoEntity pubInfor = new ArcPubInfoEntity();
		//get value from the request
		String arcId = request.getParameter("arcId");
		//arcId = Identities.uuid2();
		DocInforShow result = docInforService.findDocInforById(arcId);
		if(result!=null){
			docinfor = result.getDocInfor();
			pubInfor = result.getArcPubInfor();
			
			String regUserId = request.getParameter("regUserId");
			//String regDeptId = request.getParameter("regDeptId");
			String regDeptName = request.getParameter("regDeptName");
			String regTime = request.getParameter("regTime");
			String arcType = request.getParameter("arcType");
			String fileType = request.getParameter("fileType");
			String docType = request.getParameter("docType");
			String docCo = request.getParameter("docCo");
			String docNBR = request.getParameter("docNBR");
			String arcName = request.getParameter("arcName");
			String pageNum = request.getParameter("pageNum");
			String dptTime = request.getParameter("dptTime");
			String recTime = request.getParameter("recTime");
			String endTime = request.getParameter("endTime");
			String keyWord = request.getParameter("keyWord");
			String depPos = request.getParameter("depPos");
			String expiryDate = request.getParameter("expiryDate");
			String remarks = request.getParameter("remarks");
			//fill the value
			pubInfor.setRegUser(regUserId);
			//pubInfor.setRegDept(regDeptId);
			pubInfor.setRegDept(regDeptName);
			Date date = null;
			try{
				date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(regTime); 
			}catch(java.text.ParseException e){
				try {
					date = new SimpleDateFormat("yyyy-MM-dd").parse(regTime);
				} catch (java.text.ParseException e1) {
					e1.printStackTrace();
				} 
			}
			pubInfor.setRegTime(date);
			pubInfor.setArcType(arcType);
			pubInfor.setFileType(fileType);
			docinfor.setDocType(docType);
			docinfor.setDocCo(docCo);
			docinfor.setDocNBR(docNBR);
			pubInfor.setArcName(arcName);
			docinfor.setPageNum(pageNum);
			//check the null situation
			if("".equals(dptTime)||"null".equalsIgnoreCase(dptTime)||dptTime==null){
				docinfor.setDptTime(null);
			}else{
				docinfor.setDptTime(dptTime);
			}
			if("".equals(recTime)||"null".equalsIgnoreCase(recTime)||recTime==null){
				
				docinfor.setRecTime(null);
			}else{
				docinfor.setRecTime(recTime);
			}
			if("".equals(endTime)||"null".equalsIgnoreCase(endTime)||endTime==null){
				
				docinfor.setEndTime(null);
			}else{
				docinfor.setEndTime(endTime);
			}
			pubInfor.setKeyWord(keyWord);
			pubInfor.setDepPos(depPos);
			pubInfor.setExpiryDate(expiryDate);
			try{
				//解析有效期
				int  num=Integer.parseInt(expiryDate);
				pubInfor.setExpiryDateTime(DateUtil.getExpiryDate(num, date));
			}catch(NumberFormatException e){
				e.printStackTrace();
				resultMap.put("result", false);
			}
			pubInfor.setRemarks(remarks);
			
			pubInfor.setArcId(arcId);
			docinfor.setArcId(arcId);
			
			//set the data for the authority filter 
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user == null){
				return new HashMap<String,Object>();
			}
			docinfor.setDataOrgId(user.getOrgid());
			docinfor.setDataDeptCode(user.getDeptCode());
			docinfor.setDataUserId(user.getId());
			
			//set the data for the authority filter 
			pubInfor.setDataUserId(user.getUserId());
			pubInfor.setDataOrgId(user.getOrgid());
			pubInfor.setDataDeptCode(user.getDeptCode());
			pubInfor.setDataDeptId(user.getDeptId());
			try{
				docInforService.doUpdate(docinfor,pubInfor);
				resultMap.put("result", true);
			}catch(Exception e){
				resultMap.put("result", false);
			}
		}else{
			resultMap.put("result", false);
		}
		return resultMap;
	}
	
}
