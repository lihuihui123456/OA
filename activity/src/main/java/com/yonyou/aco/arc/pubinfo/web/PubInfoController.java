//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// PubInfoController-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.pubinfo.web;

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

import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.aco.arc.pubinfo.entity.ArcPubInfoBean;
import com.yonyou.aco.arc.pubinfo.entity.ArcPubInfoListBean;
import com.yonyou.aco.arc.pubinfo.service.IArcPubInfoService;
import com.yonyou.aco.arc.type.entity.ArcTypeEntity;
import com.yonyou.aco.arc.type.service.IActTypeService;
import com.yonyou.aco.arc.utils.DateUtil;
import com.yonyou.aco.arc.utils.ExcelUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.service.IUserService;

/**
 * <p>
 * 概述：业务模块其它档案Controller层
 * <p>
 * 功能：实现其它档案的业务请求处理
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-1-7
 * <p>
 * 类调用特殊情况：无
 */
@Controller
@RequestMapping("/pubInfo")
public class PubInfoController {
	@Resource
	IArcPubInfoService pubInfoService;
	@Resource
	com.yonyou.aco.arc.otherarc.service.IArcPubInfoService arcPubInfoService;
	@Autowired
	IActTypeService actTypeService;
	@Resource
	IUserService iUserService;
	
	@RequestMapping("/index")
	@ResponseBody
	public ModelAndView index(@RequestParam(value = "id") String typeId,
			@RequestParam(value = "pId") String pId) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/aco/arc/pubinfo/pubInfoIndex");
		mv.addObject("typeId", typeId);
		mv.addObject("pId", pId);
		return mv;
	}

	/**
	 * 添加其它档案操作
	 * 
	 * @param arcpubinfoEntity
	 */
	@RequestMapping("/add")
	@ResponseBody
	public void addArcPubInfo(
			@ModelAttribute ArcPubInfoEntity arcPubInfoEntity) {
/*		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
*//*		arcPubInfoEntity.setDataUserId(user.getId());
 * 
*/		
		//设置date类型有效期
		Date date=arcPubInfoEntity.getRegTime();
		int  num=Integer.parseInt(arcPubInfoEntity.getExpiryDate());
/*		arcPubInfoEntity.setArcId(Identities.uuid2());
*/	     arcPubInfoEntity.setExpiryDateTime(DateUtil.getExpiryDate(num, date));
         ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
         if(user != null){
        	 arcPubInfoEntity.setDataDeptCode(user.getDeptCode());
        	 arcPubInfoEntity.setDataDeptId(user.getDeptId());
        	 arcPubInfoEntity.setDataUserId(user.getUserId());
        	 arcPubInfoEntity.setDataOrgId(user.getOrgid());
        	 arcPubInfoEntity.setDr("N");
        	 arcPubInfoEntity.setFileStart("0");
        	 arcPubInfoEntity.setIsInvalid("0");
        	 pubInfoService.addArcPubInfo(arcPubInfoEntity);
         }
	}

	/**
	 * 修改其它档案
	 * 
	 * @param arcpubinfoEntity
	 */
	@RequestMapping("/update")
	@ResponseBody
	public void updateArcPubInfo(
			@ModelAttribute ArcPubInfoEntity arcPubInfoEntity) {
		//设置date类型有效期
		Date date=arcPubInfoEntity.getRegTime();
		int  num=Integer.parseInt(arcPubInfoEntity.getExpiryDate());
	    arcPubInfoEntity.setExpiryDateTime(DateUtil.getExpiryDate(num, date));
		pubInfoService.updateArcPubInfo(arcPubInfoEntity);

	}

	/**
	 * 作废其它档案
	 * 
	 * @param arcId
	 */
	@RequestMapping("/destryArcPubInfo")
	@ResponseBody
	public String destryArcPubInfo(@RequestParam(value = "arcId") String arcId) {	
		ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService.selectPubInfoEntityById(arcId);
		selectPubInfoEntityById.setIsInvalid("1");
		pubInfoService.updateArcPubInfo(selectPubInfoEntityById);
		return "true";
	}
	/**
	 * 删除其它档案
	 * 
	 * @param arcId
	 */
	@RequestMapping("/delete")
	@ResponseBody
	public void deleteArcPubInfo(@RequestParam(value = "arcId") String arcId) {	
		pubInfoService.deleteArcPubInfo(arcId);
	}

	/**
	 * 查询其它档案进行修改
	 * 
	 * @param arcId
	 */
	@RequestMapping("/updateReady")
	@ResponseBody
	public ModelAndView updateReadyArcPubInfo(
			@RequestParam(value = "arcId") String arcId) {
		ArcPubInfoEntity arcpubinfoEntit = arcPubInfoService.selectPubInfoEntityById(arcId);
/*		ArcPubInfoEntity selectPubInfoEntityById = pubInfoService
				.selectPubInfoEntityById(selectArcpubinfoEntityById.getArcId());*/
	/*	BeanUtil.copy(arcpubinfoAll, selectArcpubinfoEntityById);
		BeanUtil.copy(arcpubinfoAll, selectPubInfoEntityById);*/
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/aco/aco/docmgt/folderContentMngPaper");
		mv.addObject("arcpubinfoAll", arcpubinfoEntit);
		return mv;
	}

	/**
	 * 分页查询
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcpubinfoAll
	 * @return
	 */
	@RequestMapping("/pageList")
	@ResponseBody
	public TreeGridView<ArcPubInfoListBean> pageArcPubInfoEntity(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@ModelAttribute ArcPubInfoBean arcPubInfoBean) {
		try {
			arcPubInfoBean.setArcName(new String(arcPubInfoBean.getArcName()
					.getBytes("iso-8859-1"), "utf-8"));
			arcPubInfoBean.setKeyWord(new String(arcPubInfoBean.getKeyWord()
					.getBytes("iso-8859-1"), "utf-8"));
		  ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		  if(user != null){
			  arcPubInfoBean.setRegUser(user.getName());				 
		  }
			
		  TreeGridView<ArcPubInfoListBean> plist = new TreeGridView<ArcPubInfoListBean>();
			try {
				if (pageNum != 0) {
					pageNum = pageNum / pageSize;
				}
				pageNum++;
				PageResult<ArcPubInfoListBean> pags = pubInfoService
						.pageArcPubInfoEntityList(pageNum, pageSize,
								arcPubInfoBean);
				List<ArcPubInfoListBean> list = new ArrayList<ArcPubInfoListBean>();
                list=pags.getResults();
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
	 * TODO: 跳转其它档案新增主页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToPubInfoAdd")
	@ResponseBody
	public ModelAndView goTopubinfoAdd(
			@RequestParam(value = "id") String typeId,
			@RequestParam(value = "pId") String pId) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("typeId", typeId);
		mv.addObject("pId", pId);
		mv.setViewName("/aco/arc/pubinfo/pubInfoAdd");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转其它档案添加表单页. TODO: 填入方法说明
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
		mv.setViewName("/aco/arc/pubinfo/pubInfo_form");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转其它档案修改主页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToPubInfoUpdate")
	@ResponseBody
	public ModelAndView goTopubinfoUpdate(
			@RequestParam(value = "id") String typeId,
			@RequestParam(value = "pId") String pId,
			@RequestParam(value = "arcId") String arcId,
			@RequestParam(value = "addFuJian") String addFuJian) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("typeId", typeId);
		mv.addObject("pId", pId);
		mv.addObject("arcId", arcId);
		mv.addObject("addFuJian", addFuJian);
		mv.setViewName("/aco/arc/pubinfo/pubInfoUpdate");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转其它档案修改表单页. TODO: 填入方法说明
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
		ArcPubInfoEntity arcPubInfoEntity = new ArcPubInfoEntity();
		 arcPubInfoEntity = arcPubInfoService.selectPubInfoEntityById(arcId);
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
			mv.addObject("arcPubInfoEntity", arcPubInfoEntity);
			mv.addObject("typeId", typeId);
			mv.addObject("pId", pId);
		}
		mv.setViewName("/aco/arc/pubinfo/pubInfo_form_update");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转其它档案修改主页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToPubInfoView")
	@ResponseBody
	public ModelAndView goTopubinfoView(
			@RequestParam(value = "id") String typeId,
			@RequestParam(value = "pId") String pId,
			@RequestParam(value = "arcId") String arcId) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("typeId", typeId);
		mv.addObject("pId", pId);
		mv.addObject("arcId", arcId);
		mv.setViewName("/aco/arc/pubinfo/pubInfoView");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转查看其它档案表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToFormView")
	@ResponseBody
	public ModelAndView goToFormView(@RequestParam(value = "id") String typeId,
			@RequestParam(value = "pId") String pId,
			@RequestParam(value = "arcId") String arcId) {
		ModelAndView mv = new ModelAndView();
		ArcPubInfoEntity arcPubInfoEntity = new ArcPubInfoEntity();
		 arcPubInfoEntity = arcPubInfoService.selectPubInfoEntityById(arcId);
			if(arcPubInfoEntity.getFileUser()!=null){
				  User user=iUserService.findUserById(arcPubInfoEntity.getFileUser());
				   arcPubInfoEntity.setFileUser(user.getUserName());
			}
		mv.addObject("arcPubInfoEntity", arcPubInfoEntity);
		mv.addObject("typeId", typeId);
		mv.addObject("pId", pId);
		mv.setViewName("/aco/arc/pubinfo/pubInfo_form_view");
		return mv;
	}
	/**
	 * 
	 * TODO: 跳转查看其它档案表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToFormViewSelect")
	@ResponseBody
	public ModelAndView goToFormViewSelect(
			@RequestParam(value = "arcId") String arcId,
			@RequestParam(value = "type") String type) {
		ModelAndView mv = new ModelAndView();
		ArcPubInfoEntity arcPubInfoEntity = arcPubInfoService
				.selectPubInfoEntityById(arcId);
		mv.addObject("typeId", arcPubInfoEntity.getArcType());
		mv.addObject("pId", arcPubInfoEntity.getArcType());
		mv.addObject("arcId", arcId);
		mv.addObject("type", type);
		mv.setViewName("/aco/arc/pubinfo/pubInfoView");
		return mv;
	}
	/**
	 * 
	 * @param arcid
	 */
	@RequestMapping("/restorePubInfo")
	@ResponseBody
	public String restorePubInfo(@RequestParam(value = "arcId") String arcId) {
		ArcPubInfoEntity selectPubInfoEntityById = arcPubInfoService
				.selectPubInfoEntityById(arcId);
		selectPubInfoEntityById.setIsInvalid("0");
		arcPubInfoService.updatePubInfoSumm(selectPubInfoEntityById);
		return "true";
	}
	/**
	 * 其它档案导出
	 * @param request
	 * @param response
	 * @param arcpubinfoAll 查询条件
	 */
	@RequestMapping("/exportExcel")
	public void exportExcel(HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute ArcPubInfoBean arcPubInfoBean) {
		try {			
			  List<ArcPubInfoListBean> list = new ArrayList<ArcPubInfoListBean>();
			  ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			  if(user != null){
				  arcPubInfoBean.setRegUser(user.getName());
			  }
				if(!StringUtils.isBlank(arcPubInfoBean.getSelectIds())){
					//支持单选功能
					ArcPubInfoListBean arcPubInfoBeanByArcId = pubInfoService.getArcPubInfoBeanByArcId(arcPubInfoBean.getSelectIds());
				    list.add(arcPubInfoBeanByArcId);
				}else{
			arcPubInfoBean.setArcName(new String(arcPubInfoBean.getArcName()
					.getBytes("iso-8859-1"), "utf-8"));
			arcPubInfoBean.setKeyWord(new String(arcPubInfoBean.getKeyWord()
					.getBytes("iso-8859-1"), "utf-8"));
			
			PageResult<ArcPubInfoListBean> pags = pubInfoService
					.pageArcPubInfoEntityList(1, 1, arcPubInfoBean);
			PageResult<ArcPubInfoListBean> pags1 = pubInfoService
					.pageArcPubInfoEntityList(1, (int) pags.getTotalrecord(),
							arcPubInfoBean);
			list=pags1.getResults();
			}
			OutputStream ops = response.getOutputStream();
			HSSFWorkbook workbook = null;
			// 表头和对象属性
			String[] columnNames = { "文件标题","关键字","登记人","登记部门","存放位置"};
			String[] columnValues = { "arc_name","key_word","reg_user","reg_dept","dep_pos"};
			workbook = ExcelUtil.generateExcelFile(list, columnNames,
					columnValues);
			workbook.write(ops);
			String filename = "其它档案";
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
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
