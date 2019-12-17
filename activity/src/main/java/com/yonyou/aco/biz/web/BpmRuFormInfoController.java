package com.yonyou.aco.biz.web;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.activiti.engine.TaskService;
import org.activiti.engine.task.Task;
import org.apache.commons.lang.StringUtils;
import org.jbarcode.JBarcode;
import org.jbarcode.encode.Code39Encoder;
import org.jbarcode.paint.BaseLineTextPainter;
import org.jbarcode.paint.WideRatioCodedPainter;
import org.jbarcode.util.ImageUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.biz.service.IBpmRuFormInfoService;
import com.yonyou.cap.bpm.entity.BpmReCommentBean;
import com.yonyou.cap.bpm.entity.BpmReFormNodeBean;
import com.yonyou.cap.bpm.entity.BpmReNodeCfgEntity;
import com.yonyou.cap.bpm.entity.BpmRuBizInfoEntity;
import com.yonyou.cap.bpm.service.IBizSolService;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.bpm.util.BpmConstants;
import com.yonyou.cap.bpm.util.BpmUtils;
import com.yonyou.cap.common.util.DateUtil;

/**
 * <p>概 述：业务表单信息Controller层
 * <p>功 能：实现业务表单信息请求处理
 * <p>作 者：卢昭炜
 * <p>创建时间：2016-08-25
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/bpmRuFormInfoController")
public class BpmRuFormInfoController {
	
	@Resource
	TaskService taskService;
	@Resource
	IBizSolService bizSolService;
	@Resource 
	IBpmRuBizInfoService bpmRuBizInfoService;
	@Resource
	IBpmRuFormInfoService bpmRuFormInfoService;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 跳转到业务表单拟稿页面
	 * @param tableName 业务表单对应的数据表名称
	 * @param viewName  拟稿页面地址
	 * @return
	 */
	@RequestMapping("/toFormDraftPage")
	public ModelAndView toFormDraftPage(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		String bizId = request.getParameter("bizId");
		String tableName = request.getParameter("tableName");
		String symbol_ = request.getParameter("symbol_");
		String viewName = request.getParameter("viewName");
		String commentColumn = request.getParameter("commentColumn");
		if(StringUtils.isNotEmpty(viewName)){
			int endIndex = viewName.indexOf(".");
			if(endIndex != -1){
				viewName = viewName.substring(0,endIndex);
			}
		}
		mv.addObject("bizId",bizId);
		mv.addObject("symbol_", symbol_);
		mv.addObject("tableName", tableName);//表单对应数据表名称
		mv.addObject("commentColumn", commentColumn);//表单对应数据表名称
		mv.addObject("keyValueMap", "{}");//表单页面数据（拟稿时为空）
		mv.addObject("style", "draft");//表单访问标记   draft  表示拟稿操作
		mv.addObject("operate", "draft");//表单访问标记   draft  表示拟稿操作
		mv.setViewName(viewName);
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
		String serialNumber = request.getParameter("serialNumber");//流水号 
		String commentColumn = request.getParameter("commentColumn");
		String symbol_ = request.getParameter("symbol_"); //文号配置Id
		if(StringUtils.isNotEmpty(viewName)){
			int endIndex = viewName.indexOf(".");
			if(endIndex != -1){
				viewName = viewName.substring(0,endIndex);
			}
		}
		mv.addAllObjects(bpmRuFormInfoService.findEditFormData(bizId, tableName));
		mv.addObject("bizId", bizId);
		mv.addObject("tableName", tableName);
		mv.addObject("serialNumber", serialNumber);
		mv.addObject("symbol_", symbol_);
		mv.addObject("commentColumn", commentColumn);//表单对应数据表名称
		mv.addObject("taskId", "");
		mv.addObject("procInstId", "");
		mv.addObject("style", "update");
		mv.setViewName(viewName);
		return mv;
	}

	/**
	 * 跳转业务表单审批页面
	 * @param bizId      业务流程基本信息Id
	 * @param procInstId 流程实例Id
	 * @param tableName  业务表单对应的数据表名称
	 * @param viewName   拟稿页面地址
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/toFormDealPage")
	public ModelAndView toFormDealPage(HttpServletRequest request)throws Exception {
		ModelAndView mv = new ModelAndView();
		String bizId = request.getParameter("bizId");
		String serialNumber = request.getParameter("serialNumber");
		String procInstId = request.getParameter("procInstId");
		String tableName = request.getParameter("tableName");
		String taskId = request.getParameter("taskId");
		String viewName = request.getParameter("viewName");
		if(StringUtils.isNotEmpty(viewName)){
			int endIndex = viewName.indexOf(".");
			if(endIndex != -1){
				viewName = viewName.substring(0,endIndex);
			}
		}
		String commentColumn = request.getParameter("commentColumn");
		String symbol_ = request.getParameter("symbol_");
		mv.addAllObjects(bpmRuFormInfoService.findDealFormData(bizId, tableName,procInstId));
		mv.addObject("tableName", tableName);
		mv.addObject("serialNumber", serialNumber);
		mv.addObject("bizId", bizId);
		mv.addObject("symbol_", symbol_);
		mv.addObject("taskId", taskId);
		mv.addObject("procInstId", procInstId);
		mv.addObject("commentColumn", commentColumn);
		mv.addObject("style", "deal");
		mv.setViewName(viewName);
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
	public ModelAndView toFormViewPage(HttpServletRequest request)throws Exception {
		ModelAndView mv = new ModelAndView();
		String bizId = request.getParameter("bizId");
		String serialNumber = request.getParameter("serialNumber");
		String tableName = request.getParameter("tableName"); 
		String viewName = request.getParameter("viewName");
		if(StringUtils.isNotEmpty(viewName)){
			int endIndex = viewName.indexOf(".");
			if(endIndex != -1){
				viewName = viewName.substring(0,endIndex);
			}
		}
		String taskId = request.getParameter("taskId");
		String procInstId = request.getParameter("procInstId");
		mv.addAllObjects(bpmRuFormInfoService.findViewFormData(bizId, tableName,procInstId));
		mv.addObject("bizId", bizId);
		mv.addObject("taskId", taskId);
		mv.addObject("procInstId", procInstId);
		mv.addObject("tableName", tableName);
		mv.addObject("serialNumber", serialNumber);
		mv.addObject("style", "view");
		mv.setViewName(viewName);
		return mv;
	}
	
	/**
	 * 根据流程实例Id 意见字段查询意见
	 * @param procInstId 流程实例Id
	 * @param fieldName  意见字段
	 * @return
	 */
	@RequestMapping("/findCommentByProcInstIdAndFieldName")
	@ResponseBody
	public List<BpmReCommentBean> findCommentByProcInstIdAndFieldName(
			@RequestParam String procInstId, @RequestParam String fieldName) {
		List<BpmReCommentBean> list = null;
		if(StringUtils.isNotEmpty(procInstId) && StringUtils.isNotEmpty(fieldName)) {
			list = bpmRuBizInfoService.findCommentByProcInstIdAndFieldName(procInstId, fieldName);
		}
		if(list!=null&&list.size()>0){
			for(int i=0;i<list.size();i++){
				BpmReCommentBean brc=list.get(i);
				brc.setDtime(brc.getTime_().toString().substring(0, 19));
			}
		}
		return list;
	}
	
	/**
	 * 根据流程实例Id 意见字段查询意见
	 * @param procInstId 流程实例Id
	 * @param fieldName  意见字段
	 * @return
	 */
	@RequestMapping("/findCommentByTaskIdAndFieldName")
	@ResponseBody
	public List<BpmReCommentBean> findCommentByTaskIdAndFieldName(
			@RequestParam String taskId, @RequestParam String fieldName) {
		List<BpmReCommentBean> list = null;
		Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
		if(task != null) {
			String procInstId = task.getProcessInstanceId();
			if(StringUtils.isNotEmpty(procInstId) && StringUtils.isNotEmpty(fieldName)) {
				list = bpmRuBizInfoService.findCommentByProcInstIdAndFieldName(procInstId, fieldName);
			}
			if(list!=null&&list.size()>0){
				for(int i=0;i<list.size();i++){
					BpmReCommentBean brc=list.get(i);
					brc.setDtime(brc.getTime_().toString().substring(0, 19));
				}
			}
		}
		return list;
	}
	
	/**
	 * 根据流程实例Id查询所有意见
	 * @param procInstId 流程实例Id
	 * @return
	 */
	@RequestMapping("/findCommentByProcInstId")
	@ResponseBody
	public List<BpmReCommentBean> findCommentByProcInstId(@RequestParam String procInstId) {
		List<BpmReCommentBean> list = null;
		if(StringUtils.isNotEmpty(procInstId)) {
			list = bpmRuBizInfoService.findCommentByProcInstId(procInstId);
		}
		if(list!=null&&list.size()>0){
			for(int i=0;i<list.size();i++){
				BpmReCommentBean brc=list.get(i);
				brc.setDtime(brc.getTime_().toString().substring(0, 19));
			}
		}
		return list;
	}
	
	/**
	 * 根据流程实例Id查询所有意见
	 * @param procInstId 流程实例Id
	 * @return
	 */
	@RequestMapping("/findCommentByTaskId")
	@ResponseBody
	public List<BpmReCommentBean> findCommentByTaskId(@RequestParam String taskId) {
		List<BpmReCommentBean> list = null;
		Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
		if(task != null) {
			String procInstId = task.getProcessInstanceId();
			if(StringUtils.isNotEmpty(procInstId )) {
				list = bpmRuBizInfoService.findCommentByProcInstId(procInstId);
			}
			if(list!=null&&list.size()>0){
				for(int i=0;i<list.size();i++){
					BpmReCommentBean brc=list.get(i);
					brc.setDtime(brc.getTime_().toString().substring(0, 19));
				}
			}
		}
		return list;
	}
	
	/**
	 * 业务表单数据保存
	 * @param bizId
	 * @param tableName
	 * @param operate
	 * @return
	 */
	@RequestMapping("/doSaveBizForm")
	public @ResponseBody String doSaveBizForm(
			@RequestParam(value="bizId", defaultValue="") String bizId,
			@RequestParam(value="tableName", required=true) String tableName,
			@RequestParam(value="operate", required=true) String operate, HttpServletRequest request) {
		String msg = "N";
		if(operate.equals(BpmUtils.DRAFT_ACTION)){
			msg = doSaveBpmDuForm(tableName, request);
		}else if(operate.equals(BpmUtils.UPDATE_ACTION)) {
			msg = doUpdateBpmDuForm(bizId, tableName, request);
		}else if(operate.equals(BpmUtils.DEAL_ACTION)) {
			msg = doDealBpmDuForm(bizId, tableName, request);
		}
		return msg;
	}
	
	/**
	 * 业务表单拟稿保存公共方法
	 * @param tableName 业务表单对应数据表名称
	 * @param request   
	 * @return
	 */
	@RequestMapping("/doSaveBpmDuForm/{tableName}")
	@ResponseBody
	public String doSaveBpmDuForm(@PathVariable(value = "tableName") String tableName,HttpServletRequest request) {
		String msg = "N";
		// 将表名转化为实体名称
		String entityName = BpmConstants.FORM_ENTITY_PACKAGE + BpmUtils.getEntityName(tableName);
		try {
			Class<?> c = Class.forName(entityName);
			if (null != c) {
				Object entity = c.newInstance();
			    doSaveFormDate(request, c, entity, BpmUtils.DRAFT_ACTION);
				msg = "Y";
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return msg;
	}
	
	/**
	 * 业务表单修改保存公共方法
	 * @param bizId     业务基本信息Id
	 * @param tableName 业务表单对应数据表名称
	 * @param request   
	 * @return
	 */
	@RequestMapping("/doUpdateBpmDuForm/{bizId}/{tableName}")
	@ResponseBody
	public String doUpdateBpmDuForm(
			@PathVariable(value = "bizId") String bizId,
			@PathVariable(value = "tableName") String tableName,
			HttpServletRequest request) {
		String msg = "N";
		// 将表名转化为实体名称
		String entityName = BpmConstants.FORM_ENTITY_PACKAGE + BpmUtils.getEntityName(tableName);
		Object entity = bpmRuFormInfoService.findEntityByBizId(entityName, bizId);
		try {
			if (null != entity) {
				Class<?> c = entity.getClass();
				doSaveFormDate(request, c, entity, BpmUtils.UPDATE_ACTION);
				msg = "Y";
			} else {
				Class<?> c = Class.forName(entityName);
				if (null != c) {
					entity = c.newInstance();
					doSaveFormDate(request, c, entity, BpmUtils.UPDATE_ACTION);
					msg = "Y";
				}
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return msg;

	}

	
	/**
	 * 业务表单办理保存公共方法
	 * @param bizId     业务流程基本信息Id
	 * @param tableName 业务表单对应数据表名称
	 * @param request
	 * @return
	 */
	@RequestMapping("/doDealBpmDuForm/{bizId}/{tableName}")
	@ResponseBody
	public String doDealBpmDuForm(
			@PathVariable(value = "bizId") String bizId,
			@PathVariable(value = "tableName") String tableName,
			HttpServletRequest request) {
		String msg = "N";
		// 将表名转化为实体名称
		String entityName = BpmConstants.FORM_ENTITY_PACKAGE + BpmUtils.getEntityName(tableName);
		Object entity = bpmRuFormInfoService.findEntityByBizId(entityName, bizId);
		try {
			if (null != entity) {
				Class<?> c = entity.getClass();
				doSaveFormDate(request, c, entity, BpmUtils.DEAL_ACTION);
				msg = "Y";
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return msg;
	}
	
	/**
	 * 保存业务表单数据
	 * @param request
	 * @param c 
	 * @param entity
	 * @param type
	 * @throws Exception
	 */
	private void doSaveFormDate(HttpServletRequest request, Class<?> c, Object entity, String type) throws Exception {
		// 获取object对象中的方法
		Method[] methods = c.getDeclaredMethods();
		// 获得object对象对应的所有已申明的属性，包括public、private、和protected
		Field[] fs = c.getDeclaredFields();
		String name;// 属性名称
		String value;
		String fieldType;// 属性类型
		String fieldSetName; // 属性set方法名称
		Method fieldSetMet; //set方法
		for (Field field : fs) {
			name = field.getName();
			fieldSetName = BpmUtils.parSetName(name);//获取属性set方法名称
			if (BpmUtils.checkSetMet(methods, fieldSetName)) {// 判断是否存在某属性的 set方法
				//获取属性类型
				fieldType = field.getType().getSimpleName();
				//获取set方法
				fieldSetMet = c.getMethod(fieldSetName, field.getType());
				if(name.startsWith("comment")){
					String action = request.getParameter("action");
					if(action == null) {
						action = "";
					}
					if(BpmUtils.DEAL_ACTION.equals(type) && "send".equals(action)) {
						//送交时表单意见清空
						fieldSetMet.invoke(entity, "");
						continue;
					}
				} 
				value = request.getParameter(name);
				if(value != null) {
					BpmUtils.setFormValue(entity, fieldType, fieldSetMet, value);
				}
				value = "";
			}
		}
		bpmRuFormInfoService.doUpdateBpmDuForm(entity);
	}
	
	/**
	 * 条形码
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping(value = "getOneBarcode")
	public void getOneBarcode(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		try {
			String barcodeNum = request.getParameter("barcodeNum");
			if (barcodeNum == null || "".equals(barcodeNum)) {
				return;
			}
			JBarcode localJBarcode = new JBarcode(Code39Encoder.getInstance(),
					WideRatioCodedPainter.getInstance(),
					BaseLineTextPainter.getInstance());
			String str = barcodeNum;
			localJBarcode.setShowCheckDigit(false);
			BufferedImage localBufferedImage = localJBarcode.createBarcode(str);
			response.setHeader("Pragma", "No-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setDateHeader("Expires", 0L);
			String type = "png";
			response.setContentType("image/" + type);
			OutputStream out = response.getOutputStream();
			ImageUtil.encodeAndWrite(localBufferedImage, type, out, 96, 96);
			out.flush();
			out.close();
		} catch (Exception e) {
			logger.error("error",e);
			return;
		}
	}
	
	/**
	 * 条形码
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping(value = "getOneBarcodeByBizId")
	public void getOneBarcodeByBizId(@RequestParam String bizId, HttpServletResponse response) throws IOException {
		try {
			JBarcode localJBarcode = new JBarcode(Code39Encoder.getInstance(),
					WideRatioCodedPainter.getInstance(),
					BaseLineTextPainter.getInstance());
			// 获取业务解决方案开始节点绑定的表单信息
			BpmRuBizInfoEntity entity = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
			if(entity != null) {
				localJBarcode.setShowCheckDigit(false);
				BufferedImage localBufferedImage = localJBarcode.createBarcode(entity.getSerialNumber_());
				response.setHeader("Pragma", "No-cache");
				response.setHeader("Cache-Control", "no-cache");
				response.setDateHeader("Expires", 0L);
				String type = "png";
				response.setContentType("image/" + type);
				OutputStream out = response.getOutputStream();
				ImageUtil.encodeAndWrite(localBufferedImage, type, out, 96, 96);
				out.flush();
				out.close();
			}
		} catch (Exception e) {
			logger.error("error",e);
			return;
		}
	}
	
	@RequestMapping("/showProcessComment")
	public @ResponseBody List<BpmReCommentBean> showProcessComment(
			@RequestParam(value="bizId", required=true) String bizId) {
		BpmRuBizInfoEntity bizInfoEntity = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
		if(bizInfoEntity != null) {
			//查询意见
			List<BpmReCommentBean> list = bpmRuBizInfoService.findCommentByProcInstId(bizInfoEntity.getProcInstId_());
			if(list != null && !list.isEmpty()) {
				List<BpmReCommentBean> comments = new ArrayList<BpmReCommentBean>();
				for (BpmReCommentBean comment: list) {
					/*if("signature".equals(comment.getType_())) {//手写签批
						if(StringUtils.isBlank(comment.getSignature())) {
							continue;
						}
					}else if ("comment".equals(comment.getType_())) {//文字意见
						if(StringUtils.isBlank(comment.getMessage_())) {
							continue;
						}
					}*/
					comment.setDtime(DateUtil.formatDate(comment.getTime_(), "yyyy-MM-dd HH:mm:ss"));
					comments.add(comment);
				}
				return comments;
			}
		}
		return null;
	}
	
	/***************** 方法重构  ***********************/

	/**
	 * 跳转到业务表单拟稿页面
	 * @param tableName 业务表单对应的数据表名称
	 * @param viewName  拟稿页面地址
	 * @return
	 */
	@RequestMapping("/toDraftForm")
	public ModelAndView toDraftForm(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		String bizId = request.getParameter("bizId");
		String solId = request.getParameter("solId");
		String viewName = null;
		String tableName = null;
		String symbol_ = null;
		String commentColumn = null;
		try {
			if(StringUtils.isNotEmpty(solId)){
				BpmReFormNodeBean beginForm = bpmRuBizInfoService.findFormInfo(solId,BpmConstants.FORM_SCOPE_BEGIN);
				BpmReNodeCfgEntity draftNodeCft = null;
				if(beginForm != null){
					tableName = beginForm.getTableName_();
					viewName = beginForm.getFormUrl_();
					if(StringUtils.isNotEmpty(viewName)){
						int endIndex = viewName.indexOf(".");
						if(endIndex != -1){
							viewName = viewName.substring(0,endIndex);
						}
						
					}
					// 获取拟稿节点配置信息
					draftNodeCft = bizSolService.findDraftNodeCfg(solId, beginForm.getProcDefId_());
					if(draftNodeCft != null){
						symbol_ = draftNodeCft.getSymbol_();
						commentColumn = draftNodeCft.getColumnName_();
					}
				}
			}
			mv.addObject("bizId",bizId);
			mv.addObject("symbol_", symbol_);
			mv.addObject("commentColumn", commentColumn);
			mv.addObject("tableName", tableName);//表单对应数据表名称
			mv.addObject("keyValueMap", "{}");//表单页面数据（拟稿时为空）
			mv.addObject("style", "draft");//表单访问标记   draft  表示拟稿操作
			mv.setViewName(viewName);
		} catch (Exception e) {
			logger.error("error",e);
		}
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
	@RequestMapping("/toEditForm")
	public ModelAndView toEditForm(HttpServletRequest request)throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String bizId = request.getParameter("bizId");
		try {
			BpmRuBizInfoEntity bizInfo = null;
			BpmReFormNodeBean beginForm = null;
			BpmReNodeCfgEntity draftNodeCft = null;
			String tableName = null;
			String viewName = null;
			String serialNumber = null;//流水号 
			String symbol_ = null; //文号配置Id
			if(bizId!=null){
				bizInfo = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
				// 获取拟稿节点配置信息
				if(bizInfo != null){
					serialNumber = bizInfo.getSerialNumber_();
					beginForm = bpmRuBizInfoService.findFormInfo(bizInfo.getSolId_(),BpmConstants.FORM_SCOPE_BEGIN);
					if(beginForm != null){
						tableName = beginForm.getTableName_();
						viewName = beginForm.getFormUrl_();
						if(StringUtils.isNotEmpty(viewName)){
							int endIndex = viewName.indexOf(".");
							if(endIndex != -1){
								viewName = viewName.substring(0,endIndex);
							}
							
						}
					}
					draftNodeCft = bizSolService.findDraftNodeCfg(bizInfo.getSolId_(), bizInfo.getProDefId_());
					if(draftNodeCft!=null){
						symbol_ = draftNodeCft.getSymbol_();
					}
					mv.addAllObjects(bpmRuFormInfoService.findEditFormData(bizId, tableName));
					mv.addObject("tableName", tableName);
					mv.addObject("serialNumber", serialNumber);
					mv.addObject("style", "update");
					mv.addObject("bizId", bizId);
					mv.addObject("taskId", "");
					mv.addObject("procInstId", "");
					mv.addObject("symbol_", symbol_);
					mv.setViewName(viewName);
				}
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return mv;
	}
	
	/**
	 * 跳转业务表单审批页面
	 * @param bizId      业务流程基本信息Id
	 * @param procInstId 流程实例Id
	 * @param tableName  业务表单对应的数据表名称
	 * @param viewName   拟稿页面地址
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/toDealForm")
	public ModelAndView toDealForm(HttpServletRequest request){
		ModelAndView mv = new ModelAndView();
		
		String bizId = request.getParameter("bizId");
		String taskId = request.getParameter("taskId");
		try {
			BpmRuBizInfoEntity bizInfo = null;
			BpmReFormNodeBean beginForm = null;
			BpmReNodeCfgEntity taskNodeCft = null;
			String tableName = null;
			String viewName = null;
			String serialNumber = null;//流水号 
			String symbol_ = null; //文号配置Id
			
			String procInstId = null;;
			String commentColumn = null;
			if(StringUtils.isNotEmpty(bizId) && StringUtils.isNotEmpty(taskId)){
				bizInfo = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
				Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
				// 获取拟稿节点配置信息
				if(bizInfo != null && task!=null){
					serialNumber = bizInfo.getSerialNumber_();
					procInstId = task.getProcessInstanceId();
					beginForm = bpmRuBizInfoService.findFormInfo(bizInfo.getSolId_(),BpmConstants.FORM_SCOPE_BEGIN);
					if(beginForm != null){
						tableName = beginForm.getTableName_();
						viewName = beginForm.getFormUrl_();
						if(StringUtils.isNotEmpty(viewName)){
							int endIndex = viewName.indexOf(".");
							if(endIndex != -1){
								viewName = viewName.substring(0,endIndex);
							}
							
						}
					}
					taskNodeCft = bizSolService.findTaskNodeCfg(bizInfo.getSolId_(),
							task.getProcessDefinitionId(), task.getTaskDefinitionKey());
					if(taskNodeCft!=null){
						symbol_ = taskNodeCft.getSymbol_();
						commentColumn = taskNodeCft.getColumnName_();
						commentColumn = BpmUtils.changeColumnName(commentColumn);
					}
					mv.addAllObjects(bpmRuFormInfoService.findDealFormData(bizId, tableName,procInstId));
					mv.addObject("tableName", tableName);
					mv.addObject("serialNumber", serialNumber);
					mv.addObject("bizId", bizId);
					mv.addObject("symbol_", symbol_);
					mv.addObject("taskId", taskId);
					mv.addObject("procInstId", procInstId);
					mv.addObject("commentColumn", commentColumn);
					mv.addObject("style", "deal");
					mv.setViewName(viewName);
				}
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
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
	@RequestMapping("/toViewForm")
	public ModelAndView toViewForm(HttpServletRequest request){
		ModelAndView mv = new ModelAndView();
		String bizId = request.getParameter("bizId");
		String taskId = request.getParameter("taskId");
		
		try {
			BpmRuBizInfoEntity bizInfo = null;
			BpmReFormNodeBean beginForm = null;
			String tableName = null;
			String viewName = null;
			String serialNumber = null;//流水号 
			String procInstId = null;;
			if(StringUtils.isNotEmpty(bizId)){
				bizInfo = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
				if(bizInfo != null){
					procInstId = bizInfo.getProcInstId_();
					if(StringUtils.isNotEmpty(taskId)){
						Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
						if(null != task){
							procInstId = task.getProcessInstanceId();
						}
					}
					serialNumber = bizInfo.getSerialNumber_();
					beginForm = bpmRuBizInfoService.findFormInfo(bizInfo.getSolId_(),BpmConstants.FORM_SCOPE_BEGIN);
					if(beginForm != null){
						tableName = beginForm.getTableName_();
						viewName = beginForm.getFormUrl_();
						if(StringUtils.isNotEmpty(viewName)){
							int endIndex = viewName.indexOf(".");
							if(endIndex != -1){
								viewName = viewName.substring(0,endIndex);
							}
							
						}
					}
					mv.addAllObjects(bpmRuFormInfoService.findViewFormData(bizId, tableName,procInstId));
					mv.addObject("bizId", bizId);
					mv.addObject("taskId", taskId);
					mv.addObject("procInstId", procInstId);
					mv.addObject("tableName", tableName);
					mv.addObject("serialNumber", serialNumber);
					mv.addObject("style", "view");
					mv.setViewName(viewName);
				}
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return mv;
	}
}
