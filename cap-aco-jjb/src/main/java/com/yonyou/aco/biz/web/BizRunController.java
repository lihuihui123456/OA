package com.yonyou.aco.biz.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.activiti.engine.HistoryService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricTaskInstance;
import org.activiti.engine.task.Task;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springside.modules.utils.Identities;

import com.yonyou.aco.biz.entity.BizNodeFormBean;
import com.yonyou.aco.biz.service.IBizRunService;
import com.yonyou.aco.biz.service.IBpmRunService;
import com.yonyou.cap.bpm.entity.BpmRuParamsBean;
import com.yonyou.cap.bpm.entity.TaskNodeBean;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.bpm.service.IBpmService;
import com.yonyou.cap.bpm.util.BpmConstants;
/**
 * 概 述：       业务运行控制层
 * 功 能：       实现业务运行时请求处理
 * 作 者：       李超
 * 创建时间：2017-04-20
 * 类调用特殊情况：
 */
@Controller
@RequestMapping("/bizRunController")
public class BizRunController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource
	IBizRunService bizRunService;
	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;
	@Resource
	HistoryService historyService;
	@Resource
	TaskService taskService;
	@Resource
	IBpmService bpmService;
	@Resource
	IBpmRunService bpmRunService;
	@Resource
	HttpServletRequest request;
	/**
	 * 根据业务soldId获取业务明细列表信息(有明细列表信息显示,无列表信息直接展示业务操作页面)
	 * 业务模块列表页公共跳转方法
	 * @param  solId  业务解决方案id
	 * @return
	 */
	@RequestMapping("/getBizRunList/{solId}")
	public ModelAndView getBizRunList(@PathVariable String solId) {
		ModelAndView mv = new ModelAndView();
		String modCode = request.getParameter("modCode");
		if(!StringUtils.isEmpty(modCode)){
			mv.addObject("modCode", modCode);	
		}else{
			mv.addObject("modCode", "");
		}
		// 获取业务解决方案绑定的明细表单配置
		try{
			String listUrl = null;//明细url
			String operateUrl = null;//业务操作url
			List<BizNodeFormBean> list = bizRunService.findNodeFormInfo(solId);
			if (list!=null&&list.size()>0) {
				for(int i=0;i<list.size();i++) {
					BizNodeFormBean bean = list.get(i);
					if(bean.getScope_().equals(BpmConstants.FORM_SCOPE_DETAILS)) {
						//设置业务明细列表 
						listUrl = bean.getFormUrl();
					}else if(bean.getScope_().equals(BpmConstants.FORM_SCOPE_TEMPLATE)){
						//执行业务操作页面
						operateUrl = bean.getFormUrl();
					}
				}
				if(StringUtils.isNotEmpty(listUrl)) {
					//如果明细列表存在，直接设置跳转到明细列表，并且设置例如拟稿、起草、登记按钮的跳转URL
					mv.setViewName(listUrl);
					mv.addObject("operateUrl", operateUrl);
				}else {
					//如果明细列表不存在直接跳转到业务操作页面
					mv.setViewName(operateUrl);
				}
			}
			mv.addObject("solId", solId);
		}catch(Exception e) {
			e.printStackTrace();
			logger.info("根据业务模型ID："+solId+ "获取列表--失败!");
		}
		return mv;
	}
	
	/**
	 * @author 李超
	 * @date 2017-04-25
	 * 业务明细列表(业务操作按钮)跳转公共模板页
	 * 业务操作通常定位：拟稿、登记、起草
	 * @param solId   		业务模型Id
	 * @param status   操作状态  1：拟稿 2：修改 3：办理  4：查看
	 * @param operateUrl    业务操作模板URL
	 * @return
	 */
	@RequestMapping("/getBizOperate")
	public ModelAndView getBizOperate(@RequestParam String solId,
									  @RequestParam(value="bizId",defaultValue="") String bizId,
									  @RequestParam(value="status",defaultValue="1") String status,
									  @RequestParam(value="taskId",defaultValue="") String taskId) {
		ModelAndView mv = new ModelAndView();
		try{
			List<BizNodeFormBean> list = bizRunService.findNodeFormInfo(solId);
			//业务模型对应的业务操作模板
			BizNodeFormBean formBean = new BizNodeFormBean();//表单参数属性
			if(list!=null&&list.size()>0) {
				for(BizNodeFormBean bean:list) {
					//此处一个模型对应一个模板，此处只要只有一条数据
					if(bean.getScope_().equals(BpmConstants.FORM_SCOPE_BEGIN)) {
						formBean.setBizCode(bean.getBizCode());
						formBean.setFormid(bean.getFormid());
						formBean.setFormName(bean.getFormName());
						formBean.setIsProcess_(bean.getIsProcess_());
						formBean.setProcdefId(bean.getProcdefId());
						formBean.setScope_(bean.getScope_());
						formBean.setSolId(bean.getSolId());
						formBean.setTableName(bean.getTableName());
						formBean.setFormUrl(bean.getFormUrl());//开始表单(自由表单URL)
					}else if(bean.getScope_().equals(BpmConstants.FORM_SCOPE_TEMPLATE)){
						//设置跳转的返回模板
						formBean.setIsAttachment(bean.getIsAttachment());//是否有关联文档
						formBean.setIsMainBody(bean.getIsMainBody());//是否有正文
						formBean.setIsEarc(bean.getIsEarc());//是否有档案信息
						mv.setViewName(bean.getFormUrl());//模板URL
					}
					formBean.setSfwDictCode_(bean.getSfwDictCode_());
				}
				mv.addObject("bean",formBean);//页面属性实体
				mv.addObject("solId",solId);
				switch (status) {
					case "1"://拟稿操作
						if(StringUtils.isEmpty(bizId)) {
							bizId = Identities.uuid();
						}
						mv.addObject("operateState","draft");
						break;
					case "2"://编辑操作
						mv.addObject("operateState","update");
						break;
					case "3"://办理
						Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
						List<HistoricTaskInstance> historicTaskInstances = historyService.createHistoricTaskInstanceQuery().processInstanceId(task.getProcessInstanceId()).finished().orderByTaskCreateTime().asc().list();
						if(task.getTaskDefinitionKey().equals(historicTaskInstances.get(0).getTaskDefinitionKey())) {
							mv.addObject("firstNode", "Y");
						}
						mv.addObject("operateState", "deal");
						mv.addObject("taskId", taskId);
						//添加节点是否为结束节点start
						List<TaskNodeBean> listTaskNodeBean = bpmRunService.findSendTaskNode(task.getProcessDefinitionId(), "", taskId);
						BpmRuParamsBean params = bpmService.findProcessStartParams(task.getProcessInstanceId(), listTaskNodeBean.get(0).getActId());
						if(params!=null){
						if("endEvent".equals(params.getActType())) {
						mv.addObject("endTask", "Y");}}
						//添加节点是否为结束节点end
						break;
					case "4"://查看
						mv.addObject("operateState","view");
						break;
					default:
						logger.info("请重新输入业务操作状态参数!");
						break;
				}
				mv.addObject("bizId", bizId);
			}else {
				logger.info("尚未配置表单信息");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
}