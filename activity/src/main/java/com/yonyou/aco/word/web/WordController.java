package com.yonyou.aco.word.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springside.modules.utils.PropertiesLoader;

import com.yonyou.aco.biz.service.IBpmRuFormInfoService;
import com.yonyou.aco.word.service.IWordService;
import com.yonyou.aco.word.utils.ExportWordUtil;
import com.yonyou.cap.bpm.entity.BpmReCommentBean;
import com.yonyou.cap.bpm.entity.BpmReFormBizBean;
import com.yonyou.cap.bpm.entity.BpmReFormNodeBean;
import com.yonyou.cap.bpm.service.IBizSolService;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.bpm.util.BpmConstants;
import com.yonyou.cap.bpm.util.BpmUtils;
import com.yonyou.cap.bpm.util.PrintUtils;
import com.yonyou.cap.common.dict.service.IDictService;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.form.entity.FormColumn;
import com.yonyou.cap.form.entity.FormTable;
import com.yonyou.cap.form.service.IFormColumnService;
import com.yonyou.cap.form.service.IFormDataService;
import com.yonyou.cap.form.service.IFormTableService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.service.IUserService;
import com.yonyou.upload.entity.SysFileEntity;
import com.yonyou.upload.service.IUploadService;

/**
 * 
 * ClassName: WordController
 * 
 * @Description: 业务功能模块word操作(导出；打印)
 * @author hegd
 * @date 2016-8-24
 */
@Controller
@RequestMapping(value = "/wordController")
public class WordController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource
	IWordService wordService;
	
	@Resource
	IBizSolService bizSolService;
	@Resource
	IBpmRuFormInfoService bpmRuFormInfoService;
	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;
	@Autowired
	IFormColumnService formColumnService;
	@Autowired
	IFormTableService formTableService;
	@Autowired
	IFormDataService formDataService;
	@Resource
	IUploadService service;
	@Resource IDictService dictService;
	@Resource
	private IUserService iUserService;
	@RequestMapping("exportWord")
	public void exportWord(HttpServletResponse response,
			HttpServletRequest request) throws Exception {
		String bizId = request.getParameter("bizId");
		try {
			if (StringUtils.isNotEmpty(bizId)) {
				// add by lzw 获取打印配置
				BpmReFormBizBean bean = bizSolService.findBpmReFormBizBean(bizId, BpmConstants.FORM_SCOPE_BEGIN);
				// 打印模板
				String template = bean.getPrintTemplate();
				//String title =  bean.getBizTitle();
				String fileTitle;
				/*if(StringUtils.isBlank(title)) {
					fileTitle = String.valueOf(new Date().getTime())+"temp";
				}else{
					fileTitle = title.replaceAll(" ", "");
					//fileTitle=fileTitle.substring(0, 10);
				}*/
				fileTitle = bean.getCreatTime().toString().substring(0, 10);
				String fileName = fileTitle+".doc";
				Map<String, Object> map = getEntityInfoByBizId(bizId, bean.getProcInstId(),bean.getTableName());
				String path = ExportWordUtil.createWord(map, template, bean.getSerialNumber(), fileTitle,
						response);
			if (path != "1") {// 返回 1 失败
				OutputStream o;
				try {
					o = response.getOutputStream();
					byte b[] = new byte[1024];
					// 开始下载文件
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
					logger.error("error",e);
				}
			} else {
				response.setContentType("text/html; charset=utf-8");
				PrintWriter writer = response.getWriter();
				writer.print("<script>alert('下载失败,请联系管理员!');</script>");
				writer.print("<script>window.history.back();</script>");
				writer.close();
				writer.flush();

			}
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("printWord")
	public void printWord(HttpServletRequest request,HttpServletResponse response) throws Exception {
		String bizId = request.getParameter("bizId");
		String formType = request.getParameter("formType");
		String solId=request.getParameter("solId");
		try {
			if (StringUtils.isNotEmpty(bizId)) {
				// add by lzw 获取打印配置
				BpmReFormBizBean bean = bizSolService.findBpmReFormBizBean(bizId, BpmConstants.FORM_SCOPE_BEGIN);
				// 打印模板
				String template = "";
				if("1".equals(formType)) {
					template = bean.getPrintTemplate();
				}else {
					System.out.println("***************"+solId);
					// 获取业务解决方案绑定的明细表单配置
					BpmReFormNodeBean solBean = bpmRuBizInfoService.findFormInfo(solId,
							BpmConstants.FORM_SCOPE_BEGIN);
					System.out.println("***************"+solBean);
					template=PrintUtils.getTemplateName(solBean.getFormUrl_())+".ftl";
				}
				//String title =  bean.getBizTitle();
				String fileName;
				/*if(StringUtils.isBlank(title)) {
					fileName = String.valueOf(new Date().getTime())+"temp";
				}else{
					fileName = title.replaceAll(" ", "");
					fileName=fileName.substring(0, 10);
				}*/
				fileName = new Date().getTime()+"";
				Map<String, Object> map = null;
				// 实体信息
				if("1".equals(formType)) {
					map = getEntityInfoByBizId(bizId, bean.getProcInstId(),bean.getTableName());
				}else {
					List<Map>  list = getFormData(bean.getFREE_FORM_ID_(),bizId,bean.getProcInstId());
					if(list != null && list.size()>0){
						map = list.get(0);
						map.put("curTime", PrintUtils.getCurTime());
					}
				}
				ExportWordUtil.createWord(map, template, bean.getSerialNumber(), fileName,
						response);
				JSONObject json = new JSONObject();
				json.put("filename", fileName);
				response.setContentType("text/xml;charset=utf-8");

				json.toString().getBytes("utf-8");
				response.getWriter().print(json);
				response.getWriter().flush();
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("error",e);
		}
	}

	/**
	 * 获取表单数据
	 * @param tableid 数据库表id
	 * @param keyid 主键id
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("/getformdatas")
	public @ResponseBody List<Map> getFormData(
			@RequestParam(value = "formId", defaultValue = "") String formId,
			@RequestParam(value = "keyid", defaultValue = "") String keyid,
			@RequestParam(value = "procInstId", defaultValue = "") String procInstId) {
		if ("".equals(formId)) {
			return null;
		}
		if ("".equals(keyid)) {
			return null;
		}
		FormTable formTable=wordService.getFormTable(formId);
		FormColumn column = formColumnService.findKeyByTableid(formTable.getTableId());
		/*List<FormColumn> comlist = formColumnService
				.findCommentsColByTabId(tableid);*/
		StringBuilder wheresql = new StringBuilder("");
		if (!"".equals(keyid)) {
			wheresql .append(" where ").append(column.getCol_code()).append("='").append(keyid).append("'");
		}
		List<Map> list = formDataService.getDatas(formTable.getTableCode(),wheresql.toString());
		List<Map> notNullList=new ArrayList<Map>();
		for(int i=0;i<list.size();i++){
			Map map = list.get(i);
			Iterator entries = map.entrySet().iterator();  
			Map newMap=new HashMap();
			String dl="";
			while (entries.hasNext()) {  
			    Map.Entry entry = (Map.Entry) entries.next();  
			    Object key = (Object)entry.getKey();  
			    Object value = (Object)entry.getValue(); 
			    //针对外出备案导出,外出类型转换
			    String newVal;
			    if("wcdlb".equals(key)){
			    	dl = entry.getValue().toString();
			    	newVal=dictService.getDictValByQueryParams("yawcdjdlb", dl);
			    	newMap.put(key, newVal);
			    }else if("wcxlb".equals(key)&&"1".equals(dl)){
			    	newVal=dictService.getDictValByQueryParams("gwwczlb", entry.getValue().toString());
			    	newMap.put(key, newVal);
		    	}else if("wcxlb".equals(key)&&"2".equals(dl)) {
		    		newVal=dictService.getDictValByQueryParams("fgwwczlb", entry.getValue().toString());
			    	newMap.put(key, newVal);
		    	}else if(key.toString().contains("yj")){
		    		if(key.toString().contains("ldyj")){
				    	if(value==null||"null".equals(value)){
				    		newMap.put(key, "");
				    	}else{
				    		newMap.put(key, value);
				    	}
		    		}
		    		else if (StringUtils.isNotEmpty(procInstId)) {
						// 获取意见
						List<BpmReCommentBean> comentList = bpmRuBizInfoService.findCommentByProcInstIdAndFieldName(procInstId, key.toString());
						StringBuffer	sb = new StringBuffer();
						String time = null;
						boolean isfirst = false;
						for (BpmReCommentBean bean : comentList) {
							if(bean.getTime_()!=null){
								time = DateUtil.formatDate(bean.getTime_(), "yyyy-MM-dd HH:mm:ss");
							}
							if(isfirst){
								sb.append("<w:br />");
							}
							sb.append(bean.getMessage_());
							sb.append("<w:br />");
							sb.append(" " + bean.getUserName_() + " " + time + "");
							isfirst = true;
						}
						value = sb.toString();
						if(value != null){
							newMap.put(key, value);
						}else{
							newMap.put(key, "");
						}
					}else{
						newMap.put(key, "");
					}
		    		
		    	}else if("qbbmfzr".equals(key)) {
		    		newVal=iUserService.findUserById(value.toString()).getUserName();
			    	newMap.put(key, newVal);
		    	}else if("fj".equals(key)) {
		           List<SysFileEntity> findFilesByReference = service.findFilesByReference(keyid, "fj");
		           newVal="";
		           for (SysFileEntity sysFileEntity : findFilesByReference) {
		        	   newVal=newVal+sysFileEntity.getFileName()+"<w:br />";
					}
		           newMap.put(key, newVal);
		    	}else{
			    	if(value==null||"null".equals(value)){
			    		newMap.put(key, "");
			    	}else{
			    		newMap.put(key, value);
			    	}
			    }
			}
			notNullList.add(newMap);
		}
		//获取表单中属性以及属性值（key-value）
		List<Map> l = getDicColumnsVal(formId,notNullList);
		if(l!=null&&l.size()>0) {
			notNullList = l;
		}
		return notNullList;
	}
	
	public boolean isChinese(String string){
	    int n = 0;
	    for(int i = 0; i < string.length(); i++) {
	        n = (int)string.charAt(i);
	        if(!(19968 <= n && n <40869)) {
	            return false;
	        }
	    }
	    return true;
	}
	
	@SuppressWarnings({ "rawtypes","unchecked" })
	public List<Map> getDicColumnsVal(String formId,List<Map> list) {
		//获取form表单中那些字段是字典表中字段，根据dictype以及code获取对应的中文名称
		List<Map<String,String>> dicList = wordService.getDicColumns(formId);//找出那个表单参数中那些是字典值
		//formData
		for(Map<String,String> mapDic:dicList) {
			String coldocde = mapDic.get("COLCODE");
			String dictype = mapDic.get("DICTYPE");
			String mapVal = null;
			for(Map<String,String> mapFormData:list) {
				for(String key : mapFormData.keySet()) {
					if(key.equals(coldocde)) {
						String val = mapFormData.get(key);
						if(StringUtils.isNotEmpty(dictype)) {
							//后期自由表单支持下拉联动时再优化
							if(!isChinese(val)) {
								mapVal = dictService.getDictValByQueryParams(dictype,val);
								if(mapVal!=null) {
									mapFormData.put(key, mapVal);
								}
							}
						}else {
							logger.info("dictype:为空，请重新配置!");
						}
					}
				}
			}
		}
		return list;
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
			logger.error("error",e);
		}
		String ftlPath = new PropertiesLoader("config.properties").getProperty("ftlPath");
		String mFilePath = ftlPath + "/";
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		ModelAndView mv = new ModelAndView();
		// 自动获取OfficeServer和OCX文件完整URL路径
		String mHttpUrlName = request.getRequestURI();
		String mScriptName = request.getServletPath();
		String mServerName = "OfficeServer";
		String mServerUrl = "http://"
				+ request.getServerName()
				+ ":"
				+ request.getServerPort()
				+ mHttpUrlName.substring(0,
						mHttpUrlName.lastIndexOf(mScriptName)) + "/"
				+ mServerName+"?encryption=0";// 取得OfficeServer文件的完整URL

		// 设置文档类型初始值
		if (StringUtils.isEmpty(mFileType)) {
			mFileType = ".doc";
		}

		boolean mIsMax = true;
		mFileName = newmFileName + mFileType; // 取得完整的文档名称
		mv.addObject("mServerUrl", mServerUrl);
		mv.addObject("mFileName", mFileName);
		if(null != user){
			mv.addObject("mUserName", user.name);
			mv.addObject("mFilePath", mFilePath);
			mv.addObject("mEditType", "0");
			mv.addObject("mIsMax", mIsMax);
			mv.addObject("mFileType", mFileType);
			mv.addObject("encryption", "0");
		}
		mv.setViewName("cap/sys/iweboffice/documentEdit");
		return mv;
	}
	
	
	/**
	 * 获取表单数据
	 * @param bizId     业务Id
	 * @param tableName 业务数据表
	 * @throws Exception
	 * @return
	 */
	public Map<String, Object> getEntityInfoByBizId(String bizId, String procInstId, String tableName)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		Object entity = bpmRuFormInfoService.findEntityByTableNameAndBizId(bizId, tableName);
		if (null != entity) {
			// 获得object对象对应的所有已申明的属性，包括public、private、和protected
			Field[] fields = entity.getClass().getDeclaredFields();
			// 获取object对象中的方法
			Method[] methods = entity.getClass().getDeclaredMethods();
			String name = "";          // 属性名称
			Object value = null;       // 属性值
			String fieldGetName = "";  // 属性get方法名
			String time = "";          // 意见办理时间
			Method fieldGetMet = null; // 属性get方法
			StringBuffer sb = null;
			for (Field field : fields) {
				name = field.getName();
				fieldGetName = BpmUtils.parGetName(name);// 获取属性get方法名称
				if (BpmUtils.checkGetMet(methods, fieldGetName)) {// 判断是否存在某属性的 get方法
					// 用comment开头的为意见字段
					if (name.startsWith("comment")) {
						if (StringUtils.isNotEmpty(procInstId)) {
							// 获取意见
							List<BpmReCommentBean> list = bpmRuBizInfoService.findCommentByProcInstIdAndFieldName(procInstId, name);
							sb = new StringBuffer();
							for (BpmReCommentBean bean : list) {
								if(bean.getTime_()!=null){
									time = DateUtil.formatDate(bean.getTime_(), "yyyy-MM-dd HH:mm:ss");
								}
								sb.append(bean.getMessage_());
								sb.append("<w:br />");
								sb.append(" " + bean.getUserName_() + " " + time + "<w:br />");
							}
							value = sb.toString();
							if(value != null){
								map.put(name, value);
							}else{
								map.put(name, "");
							}
						}else{
							map.put(name, "");
						}
					}else{
						fieldGetMet = entity.getClass().getMethod(fieldGetName);// 获取get方法
						value = fieldGetMet.invoke(entity); // 使用get方法获取该属性的值
						if(value != null){
							if (name.equals("urgencyLevel_")) {
								if (value.equals("1")) {
									value = "平件";
								}
								if (value.equals("2")) {
									value = "急件";
								}
								if (value.equals("3")) {
									value = "特急";
								}
								
							} else if (name.equals("securityLevel_")) {
								if (value.equals("1")) {
									value = "公开";
								}
								if (value.equals("2")) {
									value = "内部";
								}
							}
							map.put(name, value);
						}else{
							map.put(name, "");
						}
					}
				}
			}
		}
		return map;
	}
	
}