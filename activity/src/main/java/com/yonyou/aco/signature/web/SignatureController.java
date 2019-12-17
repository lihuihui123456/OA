package com.yonyou.aco.signature.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.signature.entity.BizSignatureBean;
import com.yonyou.aco.signature.entity.BizSignatureEntity;
import com.yonyou.aco.signature.service.ISignatureService;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

@Controller
@RequestMapping("/signatureController")
public class SignatureController {

	@Resource
	ISignatureService signatureService;
	
	@RequestMapping("/openSignature")
	public ModelAndView index(HttpServletRequest request){
		ModelAndView mv = new ModelAndView();
		String bizId = request.getParameter("bizId");
		String filedName = request.getParameter("filedName");
		String taskId = request.getParameter("taskId");
		String procInstId = request.getParameter("procInstId");
		String height = request.getParameter("height");
		String width = request.getParameter("width");
		mv.addObject("bizId", bizId);
		mv.addObject("filedName", filedName);
		mv.addObject("taskId", taskId);
		mv.addObject("procInstId", procInstId);
		mv.addObject("width", width);
		mv.addObject("height", height);
		mv.setViewName("/aco/jSignature/jSignatureDemo");
		return mv;
	}
	
	@RequestMapping("/doSaveSignature")
	@ResponseBody
	public String doSaveSignature(HttpServletRequest request){
		String id = request.getParameter("id");
		String bizId = request.getParameter("bizId");
		String filedName = request.getParameter("filedName");
		String taskId = request.getParameter("taskId");
		String procInstId = request.getParameter("procInstId");
		String filedHeader = request.getParameter("filedHeader");
		String filedValue = request.getParameter("filedValue");
		if(StringUtils.isNotEmpty(bizId) && StringUtils.isNotEmpty(filedName)){
			BizSignatureEntity entity = new BizSignatureEntity();
			if(StringUtils.isNotEmpty(id)){
				entity.setId(id);
			}
			entity.setBizId_(bizId);
			entity.setFieldName_(filedName);
			entity.setFieldHeader_(filedHeader);
			entity.setFieldValue_(filedValue.getBytes());
			entity.setProcInstId_(procInstId);
			entity.setTaskId_(taskId);
			entity.setDateTime_(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				entity.setUserId_(user.getId());
			}
			return signatureService.doSaveSignature(entity);
		}else{
			return "";
		}
		
	}
	
	@RequestMapping("/findSignature")
	@ResponseBody
	private BizSignatureEntity findSignature(HttpServletRequest request){
		String taskId = request.getParameter("taskId");
		String filedName = request.getParameter("filedName");
		BizSignatureEntity entity = signatureService.findSignature(taskId, filedName);
		if(entity != null){
			String filedValue = new String(entity.getFieldValue_());
			entity.setFieldValue(filedValue);
			return entity;
		}else{
			return null;
		}
	}
	
	@RequestMapping("/loadSignature")
	@ResponseBody
	private List<BizSignatureBean> loadSignature(HttpServletRequest request){
		String bizId = request.getParameter("bizId");
		List<BizSignatureBean> list = null;
		if(StringUtils.isNotEmpty(bizId)) {
			String fieldName = request.getParameter("fieldName");
			if(StringUtils.isNotEmpty(fieldName)) {
				list = signatureService.loadSignature(bizId, fieldName);
			}else{
				list = signatureService.loadSignature(bizId);
			}
		}
		if(list != null) {
			String filedValue = "";
			for (BizSignatureBean entity : list) {
				if(entity.getFieldValue_() != null){
					filedValue = new String(entity.getFieldValue_());
					entity.setFieldValue(filedValue);
				}
			}
		}
		return list;
	}
	
	@RequestMapping("/loadSignatureByTask")
	@ResponseBody
	private List<BizSignatureBean> loadSignatureByTask(HttpServletRequest request){
		String taskId = request.getParameter("taskId");
		List<BizSignatureBean> list = null;
		if(StringUtils.isNotEmpty(taskId)) {
			String fieldName = request.getParameter("fieldName");
			if(StringUtils.isNotEmpty(fieldName)) {
				list = signatureService.loadSignatureByTaskIdAndFildName(taskId, fieldName);
			}else{
				list = signatureService.loadSignatureByTaskId(taskId);
			}
		}
		if(list != null) {
			String filedValue = "";
			for (BizSignatureBean entity : list) {
				if(entity.getFieldValue_() != null){
					filedValue = new String(entity.getFieldValue_());
					entity.setFieldValue(filedValue);
				}
			}
		}
		return list;
	}
}
