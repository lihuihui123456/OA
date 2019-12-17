package com.yonyou.aco.onlineview.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springside.modules.utils.PropertiesLoader;

import com.yonyou.cap.common.util.BrowserTypeUntil;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.dict.entity.CodeBean;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.sys.iwebpdf.entity.IWebPdfEntity;
import com.yonyou.cap.tempmgmt.entity.TemplateMgmtEntity;
@Controller
@RequestMapping("/onlineViewController")
public class OnlineViewController {
	/**
	 * 方法: 在线打开Word和Excel
	 * @param request
	 * @return
	 */
	@RequestMapping("/openWordDocument")
	public ModelAndView templateDocumentEdit(HttpServletRequest request){
		ModelAndView mv = new ModelAndView();
		//文档编号
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		String mUserName ="";
		if(user!=null){
			mUserName = user.name;//UserName:操作用户名，痕迹保留需要
		}
		//是否需要解密  0否
		String encryption="0";
		// 自动获取OfficeServer和OCX文件完整URL路径
		String mHttpUrlName = request.getRequestURI();
		String mScriptName = request.getServletPath();
		String mServerName = "OfficeServer";
		
		String  mRecordID = request.getParameter("mRecordID");
		String  mFilePath = request.getParameter("mFilePath")+"/";
		String  mFileName = request.getParameter("mFileName");
		String  fileType  = request.getParameter("fileType");
		 mFileName = mFileName + fileType; 

		if(mRecordID == null || "".equals(mRecordID)){
			java.util.Date dt = new java.util.Date();
			long lg = dt.getTime();
			// 初始化值
			mRecordID = Long.toString(lg);// 保存的是文档的编号，通过该编号，可以在里找到所有属于这条纪录的文档
		}
		// 取得完整的文档名称
		//servlet服务
		String mServerUrl = "http://" + request.getServerName() + ":" + request.getServerPort()
				+ mHttpUrlName.substring(0, mHttpUrlName.lastIndexOf(mScriptName)) + "/" + mServerName+"?encryption="+encryption+"&function=template";// 取得OfficeServer文件的完整URL
		// 设置文档类型初始值
		String mFileType = fileType;
	    mFilePath = mFilePath.replace("\\","/");
		mv.addObject("mFilePath", mFilePath);
		mv.addObject("mRecordID", mRecordID);
		mv.addObject("mFileName", mFileName);
		mv.addObject("mServerUrl", mServerUrl);
		mv.addObject("mUserName", mUserName);
		mv.addObject("mFileType", mFileType);
		mv.addObject("mEditType", "0");
		mv.setViewName("cap/sys/iweboffice/documentView");
		//mv.setViewName("aco/templatemgmt/templateDocumentEdit");
		return mv;
	}
	@RequestMapping("/openPdfDocument")
	public ModelAndView openPdfDocument(HttpServletRequest request) {
		//获取浏览器类型
		String userAgent = request.getHeader("user-agent");
		BrowserTypeUntil browseType = new BrowserTypeUntil();
		String  mRecordID = request.getParameter("mRecordID");
		String  mFilePath = request.getParameter("mFilePath")+"/";
		String  mFileName = request.getParameter("mFileName");
		String  fileType  = request.getParameter("fileType");
		 mFileName = mFileName + fileType; 
		//判断是不是移动端请求
		boolean isMobile = browseType.isMobileDevice(userAgent);
		boolean isChrome = false;
		//判断浏览器是不是谷歌
		if(userAgent.toLowerCase().contains("chrome")){
			isChrome = true;
		}
		ModelAndView mv = new ModelAndView();
		String style = "view";
		String mStatus = null;
		String mFileDate = null;

		String mHTMLPath = "";
		boolean isExsitRId = true;
		String mHttpUrlName = request.getRequestURI();
		String mServletName = request.getServletPath();
		//servlet服务
		String serverUrl = "http://" + request.getServerName() + ":" + request.getServerPort()
				+ mHttpUrlName.substring(0, mHttpUrlName.lastIndexOf(mServletName));
		//servlet服务
		String mServerName = "/iWebServer?pluginType=iwebpdf";
		String mServerUrl = serverUrl + mServerName;
		String fileUrl = serverUrl+"/onlineViewController/loadPDF?mFileName="+mFileName+"&mFilePath="+mFilePath;
			mFileDate = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
			mStatus = "DERF";
			mHTMLPath = "";
		if(isMobile || isChrome) { //如果为移动端或者谷歌浏览器则转发
			String filePath=mFilePath+mFileName+".pdf";
			mv.setViewName("redirect:/views/aco/pdf/web/viewer.jsp?filePath="+filePath);
		}else {
			//mv.addObject("mServerName", mServerName);
			mv.addObject("mServerUrl", mServerUrl);
			mv.addObject("style", style);
			mv.addObject("mRecordID", mRecordID);
			mv.addObject("mfileName", mFileName);
			mv.addObject("isExsitRId", isExsitRId);
			mv.addObject("mFileDate", mFileDate);
			mv.addObject("mStatus", mStatus);
			mv.addObject("fileUrl", fileUrl);
			mv.addObject("mHTMLPath", mHTMLPath);
			mv.addObject("e_pdf", null);
			mv.setViewName("/cap/iweb/iwebpdf/DocumentView");
		}
		return mv;
	}
	/**
	 * 加载PDF文件
	 * @param request
	 * @param response
	 */
	@RequestMapping("/loadPDF")
	public void loadPDF(HttpServletRequest request, HttpServletResponse response) {
		String  mFilePath = request.getParameter("mFilePath");
		String  mFileName = request.getParameter("mFileName");
		String filePath=mFilePath+mFileName;
		FileInputStream fin = null;
		OutputStream out = null;
		response.setHeader("Pragma", "No-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expires", 0L);
		response.setContentType("application/pdf");
		try {
			out = response.getOutputStream();
			File file = new File(filePath);
			if(file.exists()) {
				fin = new FileInputStream(file);
				byte[] b = new byte[1024];
				while (fin.read(b) != -1) {
					out.write(b);
				}
			}else {
				String tempFilePath = request.getSession().getServletContext().getRealPath("")+"/views/cap/iweb/iwebpdf/temp.pdf";
				fin = new FileInputStream(tempFilePath);
				byte[] b = new byte[1024];
				while (fin.read(b) != -1) {
					out.write(b);
				}
			}
			out.flush();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if(fin != null) {
				try {
					fin.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if(out != null) {
				try {
					out.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	/**
	 * 方法: 在线打开图片.
	 * @param request
	 * @return
	 */
	@RequestMapping("/openPhotoDocument")
	public ModelAndView openPhotoDocument(HttpServletRequest request){
		ModelAndView mv = new ModelAndView();	
		String  mFilePath = request.getParameter("mFilePath")+"/";
		String  mFileName = request.getParameter("mFileName");
		String  fileType  = request.getParameter("fileType");
		 mFileName = mFileName + fileType; 
       // 设置文档类型初始值
		String mFileType = fileType;
		//servlet服务
		String mHttpUrlName = request.getRequestURI();
		String mServletName = request.getServletPath();
		String serverUrl = "http://" + request.getServerName() + ":" + request.getServerPort()
				+ mHttpUrlName.substring(0, mHttpUrlName.lastIndexOf(mServletName));
		String fileUrl = serverUrl+"/onlineViewController/loadPhoto?mFileName="+mFileName+"&mFilePath="+mFilePath;
		mv.addObject("mFilePath", mFilePath);
		mv.addObject("mFileName", mFileName);
		mv.addObject("mFileType", mFileType);
		mv.addObject("path", fileUrl);
		mv.setViewName("cap/sys/iweboffice/documentPhoto");

		return mv;
	}
	/**
	 * 加载photo文件
	 * @param request
	 * @param response
	 */
	@RequestMapping("/loadPhoto")
	public void loadPhoto(HttpServletRequest request, HttpServletResponse response) {
		String  mFilePath = request.getParameter("mFilePath");
		String  mFileName = request.getParameter("mFileName");
		String filePath=mFilePath+mFileName;
		FileInputStream fin = null;
		OutputStream out = null;
		response.setHeader("Pragma", "No-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expires", 0L);
		response.setContentType("application/pdf");
		try {
			out = response.getOutputStream();
			File file = new File(filePath);
			if(file.exists()) {
				fin = new FileInputStream(file);
				byte[] b = new byte[1024];
				while (fin.read(b) != -1) {
					out.write(b);
				}
			}else {
				String tempFilePath = request.getSession().getServletContext().getRealPath("")+"/views/cap/iweb/iwebpdf/temp.pdf";
				fin = new FileInputStream(tempFilePath);
				byte[] b = new byte[1024];
				while (fin.read(b) != -1) {
					out.write(b);
				}
			}
			out.flush();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if(fin != null) {
				try {
					fin.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if(out != null) {
				try {
					out.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
