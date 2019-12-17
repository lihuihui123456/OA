package com.yonyou.jjb.contractmgr.web;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springside.modules.utils.PropertiesLoader;

import com.yonyou.jjb.contractmgr.entity.BizContractEntity;
import com.yonyou.jjb.contractmgr.entity.BpmRuBizInfoBean;
import com.yonyou.jjb.contractmgr.service.IContractMgrService;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.sys.iweboffice.entity.IWebDocumentEntity;
import com.yonyou.cap.sys.iweboffice.service.DocumentService;

import freemarker.template.Configuration;
import freemarker.template.Template;

/**
 * TODO: 合同管理
 * TODO: 填写Class详细说明 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2017年02月21日
 * @author 申浩
 * @since 1.0.0
 */
@Controller
@RequestMapping("/contractMgr")
public class ContractMgrController {
	@Resource
	private IContractMgrService contractMgrService;
	@Resource
	private DocumentService documentService;
	@Autowired
	private HttpServletRequest request;
	private String modCode="";

	/**
	 * 名称: 跳转到请假管理页 
	 * @return
	 */
	@RequestMapping("/toContractList")
	public String toContractList() {
		modCode= request.getParameter("modCode");
		return "/jjb/contractMgr/contractlist";
	}
	
	
	/**
	 * 获取所有合同
	 * 备注：原方法名称（getAllData）
	 * @param pagen
	 * @param rows
	 * @param roomName
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/getAllData")
	public Map<String, Object> getAllData(@RequestParam(value = "page", defaultValue = "0") int pageNum,
			@RequestParam(value = "rows", defaultValue = "10") int pageSize,
			@RequestParam(value = "searchInfo", defaultValue = "") String searchInfo) {
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			PageResult<BizContractEntity> pags;
			searchInfo = new String(searchInfo.getBytes("iso-8859-1"), "utf-8");
			if ("".equals(searchInfo)) {
				pags = contractMgrService.getAllData(pageNum, pageSize,modCode);
			} else {
				pags = contractMgrService.getAllData(pageNum, pageSize,searchInfo,modCode);
			}
			map.put("total", pags.getTotalrecord());
			map.put("rows", pags.getResults());
			return map;
		} catch (Exception e) {
			return null;
		}
	}


	/**
	 * 合同登记功能
	 * @param 
	 * @return
	 */
	@RequestMapping("/draft")
	public ModelAndView draft() {
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(draftProperty());
		mv.setViewName("/jjb/contractMgr/form_template");
		return mv;
	}
	
    private Map<String, Object> draftProperty() {
		Map<String, Object> map = new HashMap<String, Object>();		
		String tableName = "biz_contract";    //表单所对应的数据表
		String formName = "合同管理";     //表单名称
		String isMainBody = "0";  // 流程是否有正文   0 ： 没有   1： 有
		String mainBodySRC = "iweboffice/toDocumentEdit?fileType=.doc&template=0";  // 正文访问链接
		String attachmentSRC = ""; //附件访问链接
		String isAttachment = "0"; //流程是否有附件  0：没有     1：有
		String bizId=UUID.randomUUID().toString();
		String formUrl="/jjb/contractMgr/contractmgr";
		String formsrc = "contractMgr/toFormDraftPage?tableName="
				+ tableName + "&viewName="
				+ formUrl+ "&bizId="+ bizId;
		map.put("formName", formName);  // 表单名称
		map.put("formsrc", formsrc);// 业务表单请求路径
		map.put("isMainBody", isMainBody);
		map.put("mainBodySRC", mainBodySRC);
		map.put("isAttachment", isAttachment);
		map.put("attachmentSRC", attachmentSRC);
		map.put("bizId", bizId);
		map.put("tableName", tableName);// 实体对应的表名
		map.put("sendState", "0");// 实体对应的表名
		return map;
	}
    
    /**
	 * @param 跳转到附件页面
	 * 备注：原方法名：touploadView 
	 * view="1"查看
	 * @return
	 */
		@RequestMapping("/toDocMgrAtch")
		public ModelAndView toDocMgrAtch(@RequestParam(required=false) String bizId,
				@RequestParam(required=false) String view) {
			ModelAndView mv = new ModelAndView();
			mv.addObject("bizid", bizId);
			mv.addObject("view", view);
			mv.setViewName("jjb/leavemgr/docmgr-atch");
			return mv;
		}
    	@RequestMapping("/toFormDraftPage")
        public ModelAndView toFormDraftPage(HttpServletRequest request) {
				String tableName = request.getParameter("tableName");
				String viewName = request.getParameter("viewName");
				String bizId = request.getParameter("bizId");
				ModelAndView mv = new ModelAndView();
				if(StringUtils.isNotEmpty(tableName) && StringUtils.isNotEmpty(viewName)){
					mv.addObject("keyValueMap", "{}");//表单页面数据（拟稿时为空）
					mv.addObject("tableName", tableName);//表单对应数据表名称
					mv.addObject("style", "draft");//表单访问标记   draft  表示拟稿操作
					mv.addObject("bizId", bizId);
					mv.setViewName(viewName);
				}
				return mv;
}
    	/**
    	 * 业务表单拟稿保存公共方法
    	 * @param tableName 业务表单对应数据表名称
    	 * @param request   
    	 * @return
    	 */
    	@RequestMapping("/doSaveBpmDuForm")
    	@ResponseBody
    	public String doSaveBpmDuForm(@Valid BizContractEntity contractEntity) {
    		    ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
    		    String msg = "N";
    		    String date = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
    		    contractEntity.setDr("N");
    		    contractEntity.setData_user_id(user.getUserId());
    		    contractEntity.setData_dept_id(user.getDeptId());
    		    contractEntity.setData_org_id(user.getOrgid());
    		    contractEntity.setCreateTime_(date);
                contractMgrService.doUpdateContractInfo(contractEntity);
    			msg = "Y";
    		return msg;
    	}
    	
    	/**
    	 * 业务数据修改公共方法
    	 * @param solId   业务解决方案Id
    	 * @param bizId   业务Id
    	 * @param serialNumber  流水号
    	 * @return
    	 */
    	@RequestMapping("/update")
    	public ModelAndView update(@RequestParam String bizId) {
    		
    		ModelAndView mv = new ModelAndView();
    		String tableName = "biz_contract"; 
    		String viewName="/jjb/contractMgr/contractmgr";
    		String formsrc = "contractMgr/toFormUpdatePage?bizId=" + bizId
					 + "&tableName="
					+ tableName + "&viewName="
					+ viewName;    // 表单访问链接
    		String formName = "合同管理";
    		String isMainBody = "0";  // 流程是否有正文   0 ： 没有   1： 有
    		String mainBodySRC = "iweboffice/toDocumentEdit?fileType=.doc&bizId="+ bizId;  // 正文访问链接
    		String isAttachment = "0"; //流程是否有附件  0：没有     1：有
    		String attachmentSRC = ""; //附件访问链接
    		
    		
    		// 获取审批单配置 及生成审批单链接
    		mv.addObject("bizId", bizId);
    		mv.addObject("formName", formName);// 表单名称
    		mv.addObject("formsrc", formsrc);
    		mv.addObject("isMainBody", isMainBody);
    		mv.addObject("mainBodySRC", mainBodySRC);
    		mv.addObject("isAttachment", isAttachment);
    		mv.addObject("attachmentSRC", attachmentSRC);   		
    		mv.setViewName("/jjb/contractMgr/form_update_template");
    		return mv;
    	}
    	
    	/**
    	 * 跳转到业务表单编辑页面
    	 * @param bizId      业务流程基本信息Id
    	 * @param tableName  业务表单对应的数据表名称
    	 * @param viewName   拟稿页面地址
    	 * @return
    	 * @throws Exception
    	 */
    	@RequestMapping("/toFormUpdatePage")
    	public ModelAndView toFormUpdatePage(HttpServletRequest request)throws Exception {
    		ModelAndView mv = new ModelAndView();
    		
    		String bizId = request.getParameter("bizId");
    		String tableName = request.getParameter("tableName");
    		String viewName = request.getParameter("viewName");
    		BizContractEntity bizContractEntity=new BizContractEntity();
    		bizContractEntity=contractMgrService.findLeaveInfoById(bizId);
    		Map<String, Object> keyValueMap = new HashMap<String, Object>();
    		keyValueMap.put("id", bizId);
    		keyValueMap.put("bizId_", bizId);
    		keyValueMap.put("title_", bizContractEntity.getTitle_());
    		keyValueMap.put("projectName_", bizContractEntity.getProjectName_());
    		keyValueMap.put("contractNum_", bizContractEntity.getContractNum_());
    		keyValueMap.put("contractType_", bizContractEntity.getContractType_());
    		keyValueMap.put("contractTime_", bizContractEntity.getContractTime_());
    		keyValueMap.put("client_", bizContractEntity.getClient_());
    		keyValueMap.put("bearer_", bizContractEntity.getBearer_());
    		keyValueMap.put("third_", bizContractEntity.getThird_());
    		keyValueMap.put("entryTime_", bizContractEntity.getEntryTime_());
    		keyValueMap.put("survivalTime_", bizContractEntity.getSurvivalTime_());
    		keyValueMap.put("money_", bizContractEntity.getMoney_());
    		keyValueMap.put("payType_", bizContractEntity.getPayType_());
    		keyValueMap.put("agent_", bizContractEntity.getAgent_());
    		keyValueMap.put("contact_", bizContractEntity.getContact_());
    		keyValueMap.put("remark_", bizContractEntity.getRemark_());
    		keyValueMap.put("dr", bizContractEntity.getDr());
    		keyValueMap.put("data_user_id", bizContractEntity.getData_user_id());
    		keyValueMap.put("data_dept_id", bizContractEntity.getData_dept_id());
    		keyValueMap.put("data_org_id", bizContractEntity.getData_org_id());
    		keyValueMap.put("createTime_", bizContractEntity.getCreateTime_());
    		JSONObject json = new JSONObject();
    		json.putAll(keyValueMap);
    		mv.addObject("keyValueMap", json);  		
    		mv.addObject("tableName", tableName);
    		mv.addObject("style", "update");
    		mv.addObject("bizId", bizId);
    		mv.setViewName(viewName);
    		return mv;
    	}
    	/**
    	 * 业务表单修改保存公共方法
    	 * @param bizId     业务基本信息Id
    	 * @param tableName 业务表单对应数据表名称
    	 * @param request   
    	 * @return
    	 */
    	@RequestMapping("/doUpdateBpmDuForm")
    	@ResponseBody
    	public String doUpdateBpmDuForm(@Valid BizContractEntity contractEntity) {
		    ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		    String msg = "N";
		    String date = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
		    contractEntity.setDr("N");
		    contractEntity.setData_user_id(user.getUserId());
		    contractEntity.setData_dept_id(user.getDeptId());
		    contractEntity.setData_org_id(user.getOrgid());
		    contractEntity.setCreateTime_(date);
            contractMgrService.doUpdateContractInfo(contractEntity);	    
			msg = "Y";
		return msg;
    	}
	/**
	 * 根据id删除请假信息
	 * 备注：原方法名（）
	 * @param userid
	 *            多个id拼成的字符串以 , 分割
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/doDelLeaveInfo")
	public int doDelLeaveInfo(@RequestParam(value = "ids[]") String[] ids) {
		int count = 0;
		String id="";
		try {
			if (ids != null && ids.length != 0){	
				for (int i = 0; i < ids.length; i++){
					id=ids[i];
					contractMgrService.doDelLeaveInfo(id);	
				}									     
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			count=1;
		}
		return count;
	}
	/**
	 * 跳转到审批单查看页面
	 * 
	 * @param bizId
	 *            业务流程信息Id
	 * @return
	 */
	@RequestMapping("/view")
	public ModelAndView view(@RequestParam String bizId) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("bizId", bizId);
		String tableName = "biz_contract"; 
		String viewName="/jjb/contractMgr/contractmgr";
		String formName = "合同管理";
		String isMainBody = "0";  // 流程是否有正文   0 ： 没有   1： 有
		String mainBodySRC = "iweboffice/toDocumentEdit?fileType=.doc&bizId="+ bizId + "&editType=0";  // 正文访问链接
		String isAttachment = "0"; //流程是否有附件  0：没有     1：有
		String attachmentSRC = ""; //附件访问链接
		String url = "contractMgr/toFormViewPage?bizId="
				+ bizId+ "&tableName=" + tableName+ "&viewName=" + viewName;
		mv.addObject("formsrc", url);
		mv.addObject("formName", formName);// 表单名称
		mv.addObject("isMainBody",isMainBody);
		mv.addObject("mainBodySRC",mainBodySRC);
        mv.addObject("isAttachment",isAttachment);
		mv.addObject("attachmentSRC", attachmentSRC);
	    mv.setViewName("/jjb/contractMgr/form_view_template");
		return mv;
	}
	
	/**
	 * 跳转到表单查看页面
	 * @param bizId     业务流程基本信息Id
	 * @param tableName 业务表单对应的数据表名称
	 * @param viewName  拟稿页面地址
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/toFormViewPage")
	public ModelAndView toFormViewPage(@RequestParam String bizId,
			@RequestParam String tableName, @RequestParam String viewName)throws Exception {
		ModelAndView mv = new ModelAndView();
		BizContractEntity bizContractEntity=new BizContractEntity();
		bizContractEntity=contractMgrService.findLeaveInfoById(bizId);
		Map<String, Object> keyValueMap = new HashMap<String, Object>();
		keyValueMap.put("id", bizId);
		keyValueMap.put("bizId_", bizId);
		keyValueMap.put("title_", bizContractEntity.getTitle_());
		keyValueMap.put("projectName_", bizContractEntity.getProjectName_());
		keyValueMap.put("contractNum_", bizContractEntity.getContractNum_());
		keyValueMap.put("contractType_", bizContractEntity.getContractType_());
		keyValueMap.put("contractTime_", bizContractEntity.getContractTime_());
		keyValueMap.put("client_", bizContractEntity.getClient_());
		keyValueMap.put("bearer_", bizContractEntity.getBearer_());
		keyValueMap.put("third_", bizContractEntity.getThird_());
		keyValueMap.put("entryTime_", bizContractEntity.getEntryTime_());
		keyValueMap.put("survivalTime_", bizContractEntity.getSurvivalTime_());
		keyValueMap.put("money_", bizContractEntity.getMoney_());
		keyValueMap.put("payType_", bizContractEntity.getPayType_());
		keyValueMap.put("agent_", bizContractEntity.getAgent_());
		keyValueMap.put("contact_", bizContractEntity.getContact_());
		keyValueMap.put("remark_", bizContractEntity.getRemark_());
		keyValueMap.put("dr", bizContractEntity.getDr());
		keyValueMap.put("data_user_id", bizContractEntity.getData_user_id());
		keyValueMap.put("data_dept_id", bizContractEntity.getData_dept_id());
		keyValueMap.put("data_org_id", bizContractEntity.getData_org_id());
		keyValueMap.put("createTime_", bizContractEntity.getCreateTime_());
		JSONObject json = new JSONObject();
		json.putAll(keyValueMap);
		mv.addObject("keyValueMap", json);
		mv.addObject("bizId", bizId);
		mv.addObject("view", "1");
		mv.addObject("tableName", tableName);
		mv.addObject("style", "view");
		mv.setViewName(viewName);
		return mv;
	}
	/**
	 * 名称: 附件页面. 
	 * 方法: 引入附件时访问此路径，对附件进行处理
	 * @return
	 */
	@RequestMapping("/accessory")
	public ModelAndView accessory(HttpServletRequest request) {

		String tableId = request.getParameter("tableId");
		ModelAndView mav = new ModelAndView();
		List<IWebDocumentEntity> list = documentService
				.selectBySql("SELECT * from iweb_document where file_status ='0' and enabled = '1' and table_id = '"
						+ tableId + "' order by serial_number");
		mav.setViewName("cap/sys/plupload/accessorys");
		mav.addObject("list", list);
		mav.addObject("tableId", tableId);
		return mav;
	}
	@RequestMapping("exportWord")
	public void exportWord(HttpServletResponse response,
			HttpServletRequest request) throws Exception {
		String bizId = request.getParameter("bizId");
		BizContractEntity bizLeaveEntity=new BizContractEntity();
		try {
			if (StringUtils.isNotEmpty(bizId)) {
				// add by lzw 获取打印配置
				// 打印模板
				String template = "合同管理.ftl";
				String title = "合同管理";
				String fileName=title+".doc";
				// 实体信息
				bizLeaveEntity=contractMgrService.findLeaveInfoById(bizId);
				String path = createWord(bizLeaveEntity, template,title,response);
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
	/**
	 * 
	 * @Description: 在服务器上通过参数生成Word文件
	 * @param @param obj
	 * @param @param template
	 * @param @param idea
	 * @param @param response
	 * @param @return
	 * @return String
	 * @throws Exception 
	 * @author hegd
	 * @date 2016-8-24
	 */
	public static String createWord(Object obj, String template, String fileName,
			HttpServletResponse response) throws Exception {
		Map<String, Object> map = getEntityData(obj);
		Configuration cfg = new Configuration();
		try {
			String ftlPath = new PropertiesLoader("config.properties").getProperty("ftlPath");
			cfg.setDirectoryForTemplateLoading(new File(ftlPath));
			cfg.setDefaultEncoding("utf-8");
			// 获取模板文件
			Template t = cfg.getTemplate(template);
			fileName = fileName + ".doc";
			File outFile = new File(ftlPath + "\\" + fileName); // 导出文件
			String path = ftlPath + "\\" + fileName;
			Writer out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(outFile), "utf-8"));
			t.process(map, out); // 将填充数据填入模板文件并输出到目标文件
			out.flush();
			out.close();
			return path;
		} catch (Exception e) {
			e.printStackTrace();
			return "1";
		}
	}
	/**
	 * 反射机制获取实体属性以及值
	 * @param obj
	 * @return Map<String, Object>
	 * @author luzhw
	 * @data   2016-09-06
	 */
	private static Map<String, Object> getEntityData(Object obj) {
		Map<String, Object> keyValueMap = new HashMap<String, Object>();
		try {
			if (null != obj) {
				// 获得object对象对应的所有已申明的属性，包括public、private、和protected
				Field[] fields = obj.getClass().getDeclaredFields();
				// 获取object对象中的方法
				Method[] methods = obj.getClass().getDeclaredMethods();
				String name = "";// 属性名称
				String fieldGetName = "";// 属性get方法名
				Object value = null;// 属性值
				for (Field field : fields) {
					name = field.getName();
					fieldGetName = parGetName(name);// 获取属性get方法名称
					if (!checkGetMet(methods, fieldGetName)) {// 判断是否存在某属性的 get方法
						continue;
					}
					// 获取get方法
					Method fieldGetMet = obj.getClass().getMethod(fieldGetName);
					// 使用get方法获取该属性的值
					value = fieldGetMet.invoke(obj);
					// 调用getter方法获取属性值
					if (value != null) {
						keyValueMap.put(name, value);
					} else {
						keyValueMap.put(name, "");
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return keyValueMap;

	}
	/**
	 * 拼接某属性的 get方法
	 * 
	 * @param fieldName
	 * @return String
	 */
	private static String parGetName(String fieldName) {
		if (null == fieldName || "".equals(fieldName)) {
			return null;
		}
		return "get" + fieldName.substring(0, 1).toUpperCase()
				+ fieldName.substring(1);
	}
	/**
	 * 判断是否存在某属性的 get方法
	 * 
	 * @param methods
	 * @param fieldGetMet
	 * @return boolean
	 */
	private static boolean checkGetMet(Method[] methods, String fieldGetMet) {
		for (Method met : methods) {
			if (fieldGetMet.equals(met.getName())) {
				return true;
			}
		}
		return false;
	}

	@RequestMapping("printWord")
	public void printWord(HttpServletRequest request,HttpServletResponse response) throws Exception {
		String bizId = request.getParameter("bizId");
		BizContractEntity bizLeaveEntity=new BizContractEntity();
		try {
			if (StringUtils.isNotEmpty(bizId)) {
				// 打印模板
				String template = "合同管理.ftl";
				String title = "合同管理";
				//String fileName=title+".doc";
				// 实体信息
				bizLeaveEntity=contractMgrService.findLeaveInfoById(bizId);
				createWord(bizLeaveEntity, template,title,response);
				JSONObject json = new JSONObject();
				json.put("filename", title);
				response.setContentType("text/xml;charset=utf-8");

				json.toString().getBytes("utf-8");
				response.getWriter().print(json);
				response.getWriter().flush();
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	
	
	
	/**
	 * 查询业务数据公共方法
	 * @param solId    业务解决方案Id
	 * @param pageNum  当前页码数
	 * @param pageSize 每页条目数
	 * @param title    业务标题
	 * @param state    业务办理状态
	 * @return
	 * @throws UnsupportedEncodingException 
	 * Date 2017-8-22合同管理列表与收发文分离
	 */
	@RequestMapping("/findBpmRuBizInfoBySolId")
	@ResponseBody
	public TreeGridView<BpmRuBizInfoBean> findBpmRuBizInfoBySolId(
			@RequestParam String solId,
			@RequestParam(value = "page") int pageNum,
			@RequestParam(value = "rows") int pageSize,
			@RequestParam(required = false, defaultValue = "") String title,
			@RequestParam(required = false, defaultValue = "") String state,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value = "modCode", defaultValue = "") String modCode,
			@RequestParam(value="query", required=false) String queryParams) throws UnsupportedEncodingException {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		TreeGridView<BpmRuBizInfoBean> treeGridView = new TreeGridView<BpmRuBizInfoBean>();
		if (null != user) {
			//处理bootstrap传递的分页参数
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			
			PageResult<BpmRuBizInfoBean> pageResult;
			if (StringUtils.isNotEmpty(title)) {
				title = new String(title.getBytes("iso-8859-1"), "utf-8");
				//以标题为查询条件获取业务数据
				pageResult = contractMgrService.findBpmRuBizInfoBeanBySolId(modCode,pageNum,pageSize, user.getId(), solId, title,sortName,sortOrder);
			}else if(StringUtils.isNotBlank(queryParams)) {
				if (StringUtils.isNotEmpty(state)){
					//已办理状态、标题为查询条件获取业务数据
					state = new String(state.getBytes("iso-8859-1"), "utf-8");
					pageResult = contractMgrService.findBpmRuBizInfoBeanBySolId(modCode,pageNum,pageSize, user.getId(), solId, title, state,sortName,sortOrder);
				}else{
					queryParams = java.net.URLDecoder.decode(queryParams,"UTF-8");
					pageResult = contractMgrService.findBpmRuBizInfoBeanByQueryParams(modCode,pageNum, pageSize, user.getId(), solId, 
							queryParams,sortName,sortOrder);
				}
			}else {
				if (StringUtils.isNotEmpty(state)){
					//已办理状态、标题为查询条件获取业务数据
					state = new String(state.getBytes("iso-8859-1"), "utf-8");
					pageResult = contractMgrService.findBpmRuBizInfoBeanBySolId(modCode,pageNum,pageSize, user.getId(), solId, title, state,sortName,sortOrder);
				} else {
					//分页获取所有的业务数据
					pageResult = contractMgrService.findBpmRuBizInfoBeanBySolId(modCode,pageNum,pageSize, user.getId(), solId,sortName,sortOrder);
				}
			}
			if(pageResult.getResults()!=null) {
				treeGridView.setRows(pageResult.getResults());
			}else {
				treeGridView.setRows(new ArrayList<BpmRuBizInfoBean>());
			}
			treeGridView.setTotal(pageResult.getTotalrecord());
			return treeGridView;
		}else{
			return treeGridView;
		}
	}	
	
	
	
}
