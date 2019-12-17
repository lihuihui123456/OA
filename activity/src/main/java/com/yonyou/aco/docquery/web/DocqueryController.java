package com.yonyou.aco.docquery.web;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.docquery.entity.SearchBean;
import com.yonyou.aco.docquery.service.IDocqueryService;
import com.yonyou.cap.bpm.entity.BpmReSolCtlgEntity;
import com.yonyou.cap.bpm.service.IBizSolService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;

@Controller
@RequestMapping("/docquery")
public class DocqueryController {
	@Autowired
	IDocqueryService docqueryService;
	
	@Resource IBizSolService bizSolService; 
	
	PageResult<SearchBean> pags = null;
	
	PageResult<SearchBean> pags_fw = null;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@RequestMapping("/docqueryList")
	public ModelAndView toMyFolder() throws IOException{
		ModelAndView mv = new ModelAndView();
		mv.setViewName("aco/docquery/docquery-list");
		return mv;
	}
	
	@RequestMapping("/signTime")
	@ResponseBody
	public boolean signTime(HttpServletRequest request){
		String bizId = request.getParameter("id");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date = sdf.format(new Date());
		return docqueryService.updateSignTime(bizId,date);
	}
	
	/**
	 * 
	 * TODO: 分页查询列表，模糊搜索标题
	 * @param pageNum
	 * @param pageSize
	 * @param query
	 * @return
	 */
	@RequestMapping("/getAllBasicinfo_fw")
	public @ResponseBody TreeGridView<SearchBean> getAllBasicinfo_fw(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "query") String myArr2,
			@RequestParam(value = "gwbt_fw",defaultValue = "") String title,
			@RequestParam(value = "sortName",defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder",defaultValue = "") String sortOrder){
		TreeGridView<SearchBean> treeGridview = new TreeGridView<SearchBean>();
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			myArr2 = java.net.URLDecoder.decode(myArr2,"UTF-8");
			myArr2 = java.net.URLDecoder.decode(myArr2,"UTF-8");
			String[] arr = myArr2.split("&");
			String[] params = new String[6];
			for (int i = 0; i < arr.length; i++) {
				params[i] = arr[i];
			}
			pags_fw =  docqueryService.getAllBasicinfo_fw(pageNum, pageSize,params,title,sortName,sortOrder);
			treeGridview.setRows(pags_fw.getResults());
			treeGridview.setTotal(pags_fw.getTotalrecord());
			return treeGridview;
		} catch (Exception e) {
			logger.error("error",e);
			return null;
		}
	}
	/**
	 * 
	 * TODO: 分页查询列表，模糊搜索标题
	 * @param pageNum
	 * @param pageSize
	 * @param query
	 * @return
	 */
	@RequestMapping("/getAllBasicinfo")
	public @ResponseBody TreeGridView<SearchBean> getAllBasicinfo(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "query") String myArr,
			@RequestParam(value = "gwbt",defaultValue = "") String title,
			@RequestParam(value = "sortName",defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder",defaultValue = "") String sortOrder){
		TreeGridView<SearchBean> treeGridview = new TreeGridView<SearchBean>();
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			myArr = java.net.URLDecoder.decode(myArr,"UTF-8");
			myArr = java.net.URLDecoder.decode(myArr,"UTF-8");
			String[] arr = myArr.split("&");
			String[] params = new String[4];
			for (int i = 0; i < arr.length; i++) {
				params[i] = arr[i];
			}
			pags =  docqueryService.getAllBasicinfo(pageNum, pageSize,params,title,sortName,sortOrder);
			treeGridview.setRows(pags.getResults());
			treeGridview.setTotal(pags.getTotalrecord());
			return treeGridview;
		} catch (Exception e) {
			logger.error("error",e);
			return null;
		}
	}
	
	@RequestMapping("/exportExcel")
	public void exportExcel(HttpServletResponse response,HttpServletRequest request){
		HSSFWorkbook workbook=null;
		ServletOutputStream sos=null;
		try {
				String selectionIds = request.getParameter("hideSelectionIdssw");
				String[] arr = selectionIds.split(",");
				String InputWordsw = request.getParameter("hideInputWordsw");
				InputWordsw = java.net.URLDecoder.decode(InputWordsw,"UTF-8");
				InputWordsw = java.net.URLDecoder.decode(InputWordsw,"UTF-8");
				String gwbt = request.getParameter("gwbt");
				gwbt = new String(gwbt.getBytes("ISO-8859-1"),"utf-8");
				gwbt = java.net.URLDecoder.decode(gwbt,"UTF-8");
				gwbt = java.net.URLDecoder.decode(gwbt,"UTF-8");
				String regUser = request.getParameter("regUser");
				regUser = new String(regUser.getBytes("ISO-8859-1"),"utf-8");
				regUser = java.net.URLDecoder.decode(regUser,"UTF-8");
				regUser = java.net.URLDecoder.decode(regUser,"UTF-8");
				String sfgd = request.getParameter("sfgd");
				String bwzt = request.getParameter("bwzt");
				
				String filePath = docqueryService.getExcel(arr,InputWordsw,gwbt,regUser,sfgd,bwzt);
				File file = new File(filePath);
				if (!file.exists()) {
					response.sendError(404, "File not found!");
					return;
				}
				BufferedInputStream br = new BufferedInputStream(new FileInputStream(
						filePath));
				String downLoadName = null;
				String agent = request.getHeader("USER-AGENT");
				if(StringUtils.contains(agent, "Chrome") || StringUtils.contains(agent, "Firefox")){	//google,火狐浏览器  
					downLoadName =  new String((file.getName()).getBytes("UTF-8"), "ISO8859-1");
				}else{
					downLoadName = URLEncoder.encode(file.getName(),"UTF8");	//其他浏览器
				}
				byte[] buf = new byte[1024];
				int len = 0;
				response.reset();
				response.setContentType("application/msexcel;charset=UTF-8");
				response.setHeader("Content-Disposition", "attachment; filename="
						+ downLoadName);
				OutputStream out = response.getOutputStream();
				while ((len = br.read(buf)) > 0) {
					out.write(buf, 0, len);
				}
				br.close();
				out.close();
				}catch (Exception e) {
					logger.error("error",e);
					}finally{
						try {
							if (null != workbook) {
								workbook.close();
							}
							if(null!=sos){
								sos.close();
							}
						} catch (IOException e) {
							logger.error("error",e);
						}
					}
	}
	
	
	/**
	 * 方法: 查询所有业务类别.
	 * @return list
	 */
	@RequestMapping("/findAllSolCtlg")
	public @ResponseBody List<BpmReSolCtlgEntity> findAllSolCtlg(){
		List<BpmReSolCtlgEntity> list = bizSolService.getAllSolCtlg();
		return list;
	}
	
	
	@RequestMapping("/exportExcel_fw")
	public void exportExcel_fw(HttpServletResponse response,HttpServletRequest request){
		HSSFWorkbook workbook=null;
		ServletOutputStream sos=null;
	try {
		        request.setCharacterEncoding("utf-8");//必须写在第一位，因为采用这种方式去读取数据，否则数据会出错。
		        response.setContentType("text/html;charset=utf-8");//设置传过去的页面显示的编码
				String selectionIdsFw = request.getParameter("hideSelectionIdsfw");
				String[] arr = selectionIdsFw.split(",");
				String InputWordfw = request.getParameter("hideInputWordfw");
				InputWordfw = java.net.URLDecoder.decode(InputWordfw,"UTF-8");
				InputWordfw = java.net.URLDecoder.decode(InputWordfw,"UTF-8");
				String gwbt_fw = request.getParameter("gwbt_fw");
				String bwzt_fw = request.getParameter("bwzt_fw");
				String regUser = request.getParameter("draftUserIdName_");
				String ywlx_fw = request.getParameter("ywlx_fw");
				String deptName = request.getParameter("draftDeptIdName_");
				String filePath = docqueryService.getExcel_fw(arr,InputWordfw,gwbt_fw,bwzt_fw,regUser,
						deptName,ywlx_fw);
				File file = new File(filePath);
				if (!file.exists()) {
					response.sendError(404, "File not found!");
					return;
				}
				BufferedInputStream br = new BufferedInputStream(new FileInputStream(
						filePath));
				String downLoadName = null;
				String agent = request.getHeader("USER-AGENT");
				if(StringUtils.contains(agent, "Chrome") || StringUtils.contains(agent, "Firefox")){	//google,火狐浏览器  
					downLoadName =  new String((file.getName()).getBytes(), "ISO8859-1");
				}else{
					downLoadName = URLEncoder.encode(file.getName(),"UTF8");	//其他浏览器
				}
				byte[] buf = new byte[1024];
				int len = 0;
				response.reset();
				response.setContentType("application/msexcel;charset=UTF-8");
				response.setHeader("Content-Disposition", "attachment; filename="
						+ downLoadName);
				OutputStream out = response.getOutputStream();
				while ((len = br.read(buf)) > 0) {
					out.write(buf, 0, len);
				}
				br.close();
				out.close();
				}catch (Exception e) {
					logger.error("error",e);
					}finally{
						try {
							if (null != workbook) {
								workbook.close();
							}
							if(null!=sos){
								sos.close();
							}
						} catch (IOException e) {
							logger.error("error",e);
						}
					}
				}
	}


