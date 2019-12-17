package com.yonyou.aco.arc.borr.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springside.modules.utils.PropertiesLoader;

import com.yonyou.aco.arc.borr.service.IBorrInforService;
import com.yonyou.aco.arc.utils.ExportWordUtil;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * ClassName: WordController
 * 
 * @Description: 业务功能模块word操作(导出；打印)
 * @author luzhw
 * @date 2017-01-09
 */
@Controller
@RequestMapping(value = "/arcWordController")
public class ArcWordController {

	@Autowired
	IBorrInforService borrInforService;
	@RequestMapping("exportWord")
	public void exportWord(HttpServletResponse response,
			HttpServletRequest request) throws Exception {
		String id = request.getParameter("id");
		String title = request.getParameter("title");
		String template = request.getParameter("template");
		template = "借阅登记单.ftl";
		try {
			if (StringUtils.isNotEmpty(id) && StringUtils.isNotEmpty(template)) {
				if(StringUtils.isEmpty(title)) {
					title = "借阅登记单"+new Date().getTime();
				}
				String fileName = title+".doc";
				Map<String, Object> map = borrInforService.doPrintByBorrId(id);
				String path = ExportWordUtil.createWord(map, template, title, response);
			if (path != "1") {// 返回 1 失败
				OutputStream o;
				try {
					o = response.getOutputStream();
					byte b[] = new byte[1024];
					// 开始下载文件
					fileName = fileName.replaceAll(" ", "");
					File fileLoad = new File(path);
					response.setContentType("application/msword");
					response.setHeader(
							"Content-Disposition",
							"attachment;filename="
									+ java.net.URLEncoder.encode(fileName,
											"UTF-8"));
					long fileLength = fileLoad.length();
					String length = String.valueOf(fileLength);
					response.setHeader("Content_Length", length);
					// 下载文件
					FileInputStream in = new FileInputStream(fileLoad);
					int n = 0;
					while ((n = in.read(b)) != -1) {
						o.write(b, 0, n);
					}
					in.close();
					o.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			} else {
				response.setContentType("text/xml; charset=utf-8");
				PrintWriter out;

				out = response.getWriter();
				out.print("<script>alert('下载失败！');</script>");
				out.close();

			}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@RequestMapping("printWord")
	public void printWord(HttpServletRequest request,HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		String title = request.getParameter("title");
		String template = request.getParameter("template");
		try {
			if (StringUtils.isNotEmpty(id) && StringUtils.isNotEmpty(template)) {
				if(StringUtils.isEmpty(title)) {
					title = "借阅登记单"+new Date().getTime();
				}
				// 实体信息
				Map<String, Object> map = borrInforService.doPrintByBorrId(id);
				String path = ExportWordUtil.createWord(map, template, title, response);
				System.out.println(path);
				JSONObject json = new JSONObject();
				json.put("filename", title);
				response.setContentType("text/xml;charset=utf-8");

				json.toString().getBytes("utf-8");
				response.getWriter().print(json);
				response.getWriter().flush();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 跳转至文本编辑页面，并初始化一些文本编辑页面所需要的基本数据
	 * fileType：文件类型
	 * UserName：用户名称；editType：文本编辑类型
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/openWord")
	public ModelAndView toDocumentEdit(HttpServletRequest request) {

		String mFileType = request.getParameter("fileType");
		String mFileName = request.getParameter("mFileName");
		String newmFileName = "";
		try {
			newmFileName = new String(mFileName.getBytes("ISO-8859-1"),"UTF-8");
		} catch (UnsupportedEncodingException e) {
			System.out.println("转换编码失败!");
			e.printStackTrace();
		}
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		ModelAndView mv = new ModelAndView();
		// 自动获取OfficeServer和OCX文件完整URL路径
		String mHttpUrlName = request.getRequestURI();
		String mScriptName = request.getServletPath();
		String mServerName = "OfficeServer";
		String mServerUrl = "http://"
				+ request.getServerName() + ":" + request.getServerPort()
				+ mHttpUrlName.substring(0, mHttpUrlName.lastIndexOf(mScriptName)) + "/"
				+ mServerName+"?encryption=0";// 取得OfficeServer文件的完整URL

		// 设置文档类型初始值
		if (mFileType == null || "".equals(mFileType)) {
			mFileType = ".doc";
		}
		String filePath = new PropertiesLoader("config.properties").getProperty("rootPath");
		String mFilePath=filePath+"/word/";
		mv.addObject("mFilePath", mFilePath);
		boolean mIsMax = true;
		mFileName = newmFileName + mFileType; // 取得完整的文档名称
		mv.addObject("mServerUrl", mServerUrl);
		mv.addObject("mFileName", mFileName);
		if(user != null){
			mv.addObject("mUserName", user.name);
		}
		mv.addObject("mFilePath", mFilePath);
		mv.addObject("mEditType", "0");
		mv.addObject("mIsMax", mIsMax);
		mv.addObject("mFileType", mFileType);
		mv.addObject("encryption", "0");
		mv.setViewName("cap/sys/iweboffice/documentEdit");
		return mv;
	}
	
}

