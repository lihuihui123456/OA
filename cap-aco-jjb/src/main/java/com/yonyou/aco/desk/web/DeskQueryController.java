package com.yonyou.aco.desk.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yonyou.aco.circularize.service.CircularizeService;
import com.yonyou.cap.bpm.entity.DeskTaskBean;
import com.yonyou.cap.bpm.entity.TaskBean;
import com.yonyou.cap.bpm.service.IBpmQueryService;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.common.util.AcoConstant;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
/**
 *  工作事项查询
 * @author xuezc
 *
 */
@Controller
@RequestMapping("/deskQuery")
public class DeskQueryController {
	
	@Resource
	IBpmQueryService bpmQueryService;
	@Resource
	TaskService taskService;
	@Resource
	RuntimeService runtimeService;
	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;
	@Resource
	CircularizeService circularizeService;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * 首次加载个人桌面时的操作
	 * 个人桌面工作事项待办信息. 
	 * 急件、平件、阅件、传阅件 填入方法说明
	 * 备注：原方法名（getDeskListAndCountTask）
	 */
	@RequestMapping("/findDeskListAndCountTask")
	public void findDeskListAndCountTask(HttpServletResponse response, HttpServletRequest request) {
		String tasktype = request.getParameter("tasktype");// 业务类型
		String num=request.getParameter("num");
		int count=AcoConstant.DESKCOUNT;
		if(!"".equals(num) && num != null){
			count =Integer.parseInt(request.getParameter("num"));
		}
		StringBuffer lst = new StringBuffer();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		List<DeskTaskBean> urgentlist = new ArrayList<DeskTaskBean>();
		List<DeskTaskBean> flatlist = new ArrayList<DeskTaskBean>();
		List<DeskTaskBean> readlist = new ArrayList<DeskTaskBean>();
		List<DeskTaskBean> circularslist = new ArrayList<DeskTaskBean>();
		int totalcount = 0;// 待办事项总数量
		int urgentcount = 0;// 急件事项结果集数量
		int flatcount = 0;// 平件事项结果集数量
		int readcount = 0;// 阅件事项结果集数量
		int circularscount = 0;// 传阅件事项结果集数量
		try {
			if(user!=null) {
				String userid = user.id;// 当前用户
				if (tasktype.equals("urgent")) {// 急件
					urgentlist = bpmQueryService.findDeskUrgentTaskList(userid);
				}
				flatlist = bpmQueryService.findDeskFlatTaskList(userid);// 平件
				readlist = bpmQueryService.findDeskReadTaskList(userid);// 阅件
				circularslist = circularizeService.findCyLinkList(userid);// 传阅件
				if (urgentlist != null && urgentlist.size() > 0) {
					urgentcount = urgentlist.size();
					if (urgentcount > count) {
						for (int i = 0; i < count; i++) {
							DeskTaskBean entity = urgentlist.get(i);
							String url = "/bpmRunController/deal?bizId="+ entity.getBizid()+"&&taskId="+entity.getTaskId();
							lst.append("<TR><TD style='width:75%;' onclick='opentab(\"" + entity.getTaskname() + "\",\""
									+ entity.getId() + "\",\"" + url + "\")\'>");
							if (i == 0) {
								lst.append("<span></span><span class='count red'>" + (i + 1) + "</span>");// 红色处理
							} else if (i == 1) {
								lst.append("<span></span><span class='count green'>" + (i + 1) + "</span>");// 绿色处理
							} else if (i == 2) {
								lst.append("<span></span><span class='count blue'>" + (i + 1) + "</span>");// 蓝色处理
							} else {
								lst.append("<span></span><span class='count'>" + (i + 1) + "</span>");// 默认的灰色
							}
							if(entity.getTaskname()!=null&&entity.getTaskname().length()>28) {
								lst.append(entity.getTaskname().substring(0,27)+"...." + "</TD>");
							}else {
								lst.append(entity.getTaskname() + "</TD>");
							}
							lst.append("<TD style='width:11%;text-align:center;'>" + entity.getCreateuser() + "</TD></TR>");
							/*if (entity.getCreate_time() != null) {
								lst.append("<TD width='14%'>" + entity.getCreattime()
										+ "</TD></TR>");
							} else if (entity.getCreatetime() != null) {
								lst.append("<TD width='14%' class='time'>" + entity.getCreatetime().substring(0, 10)
										+ "</TD></TR>");
							}*/
						}
					} else {
						for (int i = 0; i < urgentlist.size(); i++) {
							DeskTaskBean entity = urgentlist.get(i);
							String url = "/bpmRunController/deal?bizId="+ entity.getBizid()+"&&taskId="+entity.getTaskId();
							lst.append("<TR><TD style='width:75%;' onclick='opentab(\"" + entity.getTaskname() + "\",\""
									+ entity.getId() + "\",\"" + url + "\")\'>");
							if (i == 0) {
								lst.append("<span></span><span class='count red'>" + (i + 1) + "</span>");// 红色处理
							} else if (i == 1) {
								lst.append("<span></span><span class='count green'>" + (i + 1) + "</span>");// 绿色处理
							} else if (i == 2) {
								lst.append("<span></span><span class='count blue'>" + (i + 1) + "</span>");// 蓝色处理
							} else {
								lst.append("<span></span><span class='count'>" + (i + 1) + "</span>");// 默认的灰色
							}
							if(entity.getTaskname()!=null&&entity.getTaskname().length()>28) {
								lst.append(entity.getTaskname().substring(0,27)+"...." + "</TD>");
							}else {
								lst.append(entity.getTaskname() + "</TD>");
							}
							lst.append("<TD style='width:11%;text-align:center;'>" + entity.getCreateuser() + "</TD>");
							if (entity.getCreate_time() != null) {
								lst.append("<TD width='14%'>" + DateUtil.formatTimestampForDate(entity.getCreate_time())
										+ "</TD></TR>");
							} else if (entity.getCreatetime() != null) {
								lst.append("<TD width='14%'  class='time'>" + entity.getCreatetime().substring(0, 10)
										+ "</TD></TR>");
							}
						}

					}
				}
				if (flatlist != null && flatlist.size() > 0)
					flatcount = flatlist.size();// 平件数量
				if (readlist != null && readlist.size() > 0)
					readcount = readlist.size();// 阅件数量
				if (circularslist != null && circularslist.size() > 0)
					circularscount = circularslist.size();// 传阅件数量
				totalcount = urgentcount + flatcount + readcount + circularscount;// 总数量
			}
			
			JSONObject json = new JSONObject();
			json.put("result", lst.toString());
			json.put("urgentcount", urgentcount);
			json.put("flatcount", flatcount);
			json.put("readcount", readcount);
			json.put("totalcount", totalcount);
			json.put("circularscount", circularscount);
			// System.out.println(json.toString());
			response.getWriter().write(json.toString());
			response.getWriter().flush();
		} catch (IOException e) {
			
			logger.error("error",e);
		}
	}
	
	/**
	 * 个人桌面工作事项待办信息. 
	 * 急件、平件、阅件、传阅件
	 * 填入方法说明
	 * 备注：原方法名（getDeskListTask）
	 */
	@RequestMapping("/findDeskListTask")
	public void findDeskListTask(HttpServletResponse response, HttpServletRequest request) {
		String tasktype = request.getParameter("tasktype");// 业务类型
		String num=request.getParameter("num");
		int count=AcoConstant.DESKCOUNT;
		if(!"".equals(num) && num != null){
			count =Integer.parseInt(request.getParameter("num"));
		}
		//int count = Constant.DESKCOUNT;// 个人桌面显示条数
		StringBuffer lst = new StringBuffer();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		List<DeskTaskBean> list = null;
		int lstcount = 0;// 事项结果集数量
		try {
			if(user!=null) {
				String userid = user.id;// 当前用户
				if (tasktype.equals("urgent")) {// 急件
					list = bpmQueryService.findDeskUrgentTaskList(userid);
				} else if (tasktype.equals("flat")) {// 平件
					list = bpmQueryService.findDeskFlatTaskList(userid);
				} else if (tasktype.equals("read")) {// 阅件
					list = bpmQueryService.findDeskReadTaskList(userid);
				} else if (tasktype.equals("circulars")) {// 传阅件
					list = circularizeService.findCyLinkList(userid);
				}
				if (list != null && list.size() > 0) {
					lstcount = list.size();
					if (lstcount > count) {
						for (int i = 0; i < count; i++) {
							DeskTaskBean entity = list.get(i);
							String url = "";
							if (tasktype.equals("circulars")) {
								url = entity.getUrl() + entity.getId();
							} else if (tasktype.equals("read")) {
								url = "/bpmCirculate/findCirculate?bizid=" + entity.getBizid() + "&id=" + entity.getId();
							} else {
								url = "/bpmRunController/deal?bizId="+ entity.getBizid()+"&&taskId="+entity.getTaskId();
							}
							lst.append("<TR><TD style='width:70%;' onclick='opentab(\"" + entity.getTaskname() + "\",\""
									+ entity.getId() + "\",\"" + url + "\")\'>");
							if (i == 0) {
								lst.append("<span></span><span class='count red'>" + (i + 1) + "</span>");// 红色处理
							} else if (i == 1) {
								lst.append("<span></span><span class='count green'>" + (i + 1) + "</span>");// 绿色处理
							} else if (i == 2) {
								lst.append("<span></span><span class='count blue'>" + (i + 1) + "</span>");// 蓝色处理
							} else {
								lst.append("<span></span><span class='count'>" + (i + 1) + "</span>");// 默认的灰色
							}
							if(entity.getTaskname()!=null&&entity.getTaskname().length()>28) {
								lst.append(entity.getTaskname().substring(0,27)+"...." + "</TD>");
							}else {
								lst.append(entity.getTaskname() + "</TD>");
							}
							lst.append("<TD style='width:11%;text-align:center;'>" + entity.getCreateuser() + "</TD>");
							if (entity.getCreate_time() != null) {
								lst.append("<TD width='19%' class='time'>"
										+ DateUtil.formatTimestampForDate(entity.getCreate_time()) + "</TD></TR>");
							} else if (entity.getCreatetime() != null) {
								lst.append("<TD width='19%' class='time'>" + entity.getCreatetime().substring(0, 10)
										+ "</TD></TR>");
							}
						}
					} else {
						for (int i = 0; i < list.size(); i++) {
							DeskTaskBean entity = list.get(i);
							String url = "";
							if (tasktype.equals("circulars")) {
								url = entity.getUrl() + entity.getId();
							} else if (tasktype.equals("read")) {
								url = "/bpmCirculate/findCirculate?bizid=" + entity.getBizid() + "&id=" + entity.getId();
							} else {
								url = "/bpmRunController/deal?bizId="+ entity.getBizid()+"&&taskId="+entity.getTaskId();
							}
							lst.append("<TR><TD style='width:70%;' onclick='opentab(\"" + entity.getTaskname() + "\",\""
									+ entity.getId() + "\",\"" + url + "\")\'>");
							if (i == 0) {
								lst.append("<span class='count red'>" + (i + 1) + "</span>");// 红色处理
							} else if (i == 1) {
								lst.append("<span></span><span class='count green'>" + (i + 1) + "</span>");// 绿色处理
							} else if (i == 2) {
								lst.append("<span></span><span class='count blue'>" + (i + 1) + "</span>");// 蓝色处理
							} else {
								lst.append("<span></span><span class='count'>" + (i + 1) + "</span>");// 默认的灰色
							}
							if(entity.getTaskname()!=null&&entity.getTaskname().length()>28) {
								lst.append(entity.getTaskname().substring(0,27)+"...." + "</TD>");
							}else {
								lst.append(entity.getTaskname() + "</TD>");
							}
							lst.append("<TD style='width:11%;text-align:center;'>" + entity.getCreateuser() + "</TD>");
							if (entity.getCreate_time() != null) {
								lst.append("<TD width='19%' class='time'>"
										+ DateUtil.formatTimestampForDate(entity.getCreate_time()) + "</TD></TR>");
							} else if (entity.getCreatetime() != null) {
								lst.append("<TD width='19%' class='time'>" + entity.getCreatetime().substring(0, 10)
										+ "</TD></TR>");
							}
						}
					}
				}
			}
			JSONObject json = new JSONObject();
			json.put("result", lst.toString());
			json.put("lstcount", lstcount);
			System.out.println(json.toString());
			response.getWriter().write(json.toString());
			response.getWriter().flush();
		} catch (IOException e) {
			
			logger.error("error",e);
		}
	}
	
	/**
	 * 领导桌面工作事项待办信息. 
	 * 急件、平件、传阅件
	 * 填入方法说明
	 * 备注：原方法名（getDeskListTask）
	 */
	@RequestMapping("/findLeadDeskListTask")
	public void findLeadDeskListTask(HttpServletResponse response, HttpServletRequest request) {
		String tasktype = request.getParameter("tasktype");// 业务类型
		String num = request.getParameter("num");
		int count = AcoConstant.DESKCOUNT;
		if (!"".equals(num) && num != null) {
			count = Integer.parseInt(request.getParameter("num"));
		}
		StringBuffer lst = new StringBuffer();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		List<DeskTaskBean> reList = new ArrayList<DeskTaskBean>();
		List<DeskTaskBean> list = null;
		List<TaskBean> lists = null;
		int lstcount = 0;// 领导桌面待办事项结果集数量
		int readcount = 0;// 待阅文件结果集数量
		int hasdonecount = 0;// 已办事项结果集数量
		String wheresql = " ";
		int pagesize = 10;
		try {
			if (user != null) {
				String userid = user.id;// 当前用户
				list = bpmQueryService.findDeskUrgentTaskList(userid);// 急件
				reList.addAll(list);
				list = bpmQueryService.findDeskFlatTaskList(userid);// 平件
				reList.addAll(list);
				list = circularizeService.findCyLinkList(userid);// 传阅件
				reList.addAll(list);
				list = null;
				list = bpmQueryService.findDeskReadTaskList(userid);// 阅件
				readcount = list.size();
				PageResult<TaskBean> pags = bpmQueryService
						.findTaskHasDoneList(0, pagesize, wheresql);
				lists = pags.getResults();
				hasdonecount = lists.size();
				if (reList != null && reList.size() > 0) {
					lstcount = reList.size();
					if (lstcount > count) {
						String url = "";
						DeskTaskBean entity;
						for (int i = 0; i < count; i++) {
							entity = reList.get(i);
							if (tasktype.equals("circulars")) {
								url = entity.getUrl() + entity.getId();
							} else if (tasktype.equals("read")) {
								url = "/bpmCirculate/findCirculate?bizid="
										+ entity.getBizid() + "&id="
										+ entity.getId();
							} else {
								url = "/bizRunController/getBizOperate?status=3&solId="
										+ entity.getSolid()
										+ "&taskId="
										+ entity.getTaskId()
										+ "&bizId="
										+ entity.getBizid();
							}
							leadDeskListTask(lst, i, entity, url);
						}
					} else {
						for (int i = 0; i < reList.size(); i++) {
							DeskTaskBean entity = reList.get(i);
							String url = "";
							if (tasktype.equals("circulars")) {
								url = entity.getUrl() + entity.getId();
							} else if (tasktype.equals("read")) {
								url = "/bpmCirculate/findCirculate?bizid="
										+ entity.getBizid() + "&id="
										+ entity.getId();
							} else {
								url = "/bizRunController/getBizOperate?status=3&solId="
										+ entity.getSolid()
										+ "&taskId="
										+ entity.getTaskId()
										+ "&bizId="
										+ entity.getBizid();
							}
							leadDeskListTask(lst, i, entity, url);
						}
					}
				}
			}
			JSONObject json = new JSONObject();
			json.put("result", lst.toString());
			json.put("lstcount", lstcount);
			json.put("readcount", readcount);
			json.put("hasdonecount", hasdonecount);
			response.getWriter().write(json.toString());
			response.getWriter().flush();
		} catch (IOException e) {
			logger.error("error", e);
		}
	}

	private void leadDeskListTask(StringBuffer lst, int i, DeskTaskBean entity, String url) {
		lst.append("<TR><TD style='width:4%;'><input id='"+entity.getId()+"' name='deal' type='checkbox' onclick='checkOne(this);' /></TD><TD style='width:63%;' onclick='opentab(\"" + entity.getTaskname() + "\",\""
				+ entity.getId() + "\",\"" + url + "\")\'>");
		if (i == 0) {
			lst.append("<span></span><span class='count red'>" + (i + 1) + "</span>");// 红色处理
		} else if (i == 1) {
			lst.append("<span></span><span class='count green'>" + (i + 1) + "</span>");// 绿色处理
		} else if (i == 2) {
			lst.append("<span></span><span class='count blue'>" + (i + 1) + "</span>");// 蓝色处理
		} else {
			lst.append("<span></span><span class='count'>" + (i + 1) + "</span>");// 默认的灰色
		}
		if(entity.getTaskname()!=null&&entity.getTaskname().length()>28) {
			lst.append(entity.getTaskname().substring(0,27)+"...." + "</TD>");
		}else {
			lst.append(entity.getTaskname() + "</TD>");
		}
		lst.append("<TD style='width:10%;text-align:center;'>" + entity.getCreateuser() + "</TD>");
		lst.append("<TD style='width:10%;text-align:center;' onclick='blxq(\"" + entity.getBizid() + "\")'><span class=\"todo_views\">办理详情</span></TD>");
		if (entity.getCreate_time() != null) {
			lst.append("<TD width='15%' class='time'>"
					+ DateUtil.formatTimestampForDate(entity.getCreate_time()) + "</TD></TR>");
		} else if (entity.getCreatetime() != null) {
			lst.append("<TD width='15%' class='time'>" + entity.getCreatetime().substring(0, 10)
					+ "</TD></TR>");
		}
	}
	
	/**
	 * 领导桌面工作事项待阅文件. 
	 * 阅件
	 * 填入方法说明
	 * 备注：原方法名（findLeadDeskTask）
	 */
	@RequestMapping("/findLeadDeskTask")
	public void findLeadDeskTask(HttpServletResponse response, HttpServletRequest request) {
		String tasktype = request.getParameter("tasktype");// 业务类型
		String num = request.getParameter("num");
		int count = AcoConstant.DESKCOUNT;
		if (!"".equals(num) && num != null) {
			count = Integer.parseInt(request.getParameter("num"));
		}
		StringBuffer lst = new StringBuffer();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		List<DeskTaskBean> reList = new ArrayList<DeskTaskBean>();
		List<DeskTaskBean> list = null;
		int lstcount = 0;// 事项结果集数量
		try {
			if (user != null) {
				String userid = user.id;// 当前用户
				list = bpmQueryService.findDeskReadTaskList(userid);
				reList.addAll(list);
				if (reList != null && reList.size() > 0) {
					lstcount = reList.size();
					if (lstcount > count) {
						for (int i = 0; i < count; i++) {
							DeskTaskBean entity = reList.get(i);
							String url = "";
							if (tasktype.equals("circulars")) {
								url = entity.getUrl() + entity.getId();
							} else if (tasktype.equals("read")) {
								url = "/bpmCirculate/findCirculate?bizid="
										+ entity.getBizid() + "&id="
										+ entity.getId();
							} else {
								url = "/bizRunController/getBizOperate?status=3&solId="
										+ entity.getSolid()
										+ "&taskId="
										+ entity.getTaskId()
										+ "&bizId="
										+ entity.getBizid();
							}
							leadDeskTask(lst, i, entity, url);
						}
					} else {
						for (int i = 0; i < reList.size(); i++) {
							DeskTaskBean entity = reList.get(i);
							String url = "";
							if (tasktype.equals("circulars")) {
								url = entity.getUrl() + entity.getId();
							} else if (tasktype.equals("read")) {
								url = "/bpmCirculate/findCirculate?bizid="
										+ entity.getBizid() + "&id="
										+ entity.getId();
							} else {
								url = "/bizRunController/getBizOperate?status=3&solId="
										+ entity.getSolid()
										+ "&taskId="
										+ entity.getTaskId()
										+ "&bizId="
										+ entity.getBizid();
							}
							leadDeskTask(lst, i, entity, url);
						}
					}
				}
			}
			JSONObject json = new JSONObject();
			json.put("result", lst.toString());
			json.put("lstcount", lstcount);
			response.getWriter().write(json.toString());
			response.getWriter().flush();
		} catch (IOException e) {
			logger.error("error", e);
		}
	}

	private void leadDeskTask(StringBuffer lst, int i, DeskTaskBean entity, String url) {
		lst.append("<TR><TD style='width:2%;'><input id='"+entity.getId()+"' name='daiyue' type='checkbox' onclick='checkOne(this);' /></TD><TD style='width:63%;' onclick='opentab(\"" + entity.getTaskname() + "\",\""
				+ entity.getId() + "\",\"" + url + "\")\'>");
		if (i == 0) {
			lst.append("<span></span><span class='count red'>" + (i + 1) + "</span>");// 红色处理
		} else if (i == 1) {
			lst.append("<span></span><span class='count green'>" + (i + 1) + "</span>");// 绿色处理
		} else if (i == 2) {
			lst.append("<span></span><span class='count blue'>" + (i + 1) + "</span>");// 蓝色处理
		} else {
			lst.append("<span></span><span class='count'>" + (i + 1) + "</span>");// 默认的灰色
		}
		lst.append(entity.getTaskname() + "</TD>");
		lst.append("<TD style='width:10%;text-align:center;'>" + entity.getCreateuser() + "</TD>");
		lst.append("<TD style='width:10%;text-align:center;' onclick='blxq(\"" + entity.getBizid() + "\")'><span class=\"todo_views\">办理详情</span></TD>");
		if (entity.getCreate_time() != null) {
			lst.append("<TD width='15%' class='time'>"
					+ DateUtil.formatTimestampForDate(entity.getCreate_time()) + "</TD></TR>");
		} else if (entity.getCreatetime() != null) {
			lst.append("<TD width='15%' class='time'>" + entity.getCreatetime().substring(0, 10)
					+ "</TD></TR>");
		}
	}
	
	/**
	 * 领导桌面工作事项已办文件. 
	 * 已办文件
	 * 填入方法说明
	 * 备注：原方法名（findHasDoneList）
	 */
	@SuppressWarnings("unused")
	@RequestMapping("/findLeadHasDoneList")
	public void findLeadHasDoneList(HttpServletResponse response, HttpServletRequest request) {
		String tasktype = request.getParameter("tasktype");// 业务类型
		String num=request.getParameter("num");
		int count=AcoConstant.DESKCOUNT;
		if(!"".equals(num) && num != null){
			count =Integer.parseInt(request.getParameter("num"));
		}
		//int count = Constant.DESKCOUNT;// 个人桌面显示条数
		StringBuffer lst = new StringBuffer();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		List<TaskBean> reList = new ArrayList<TaskBean>();
		List<TaskBean> list = null;
		String wheresql = " ";
		int lstcount = 0;// 事项结果集数量
		try {
			if(user != null){
				String userid = user.id;// 当前用户
			PageResult<TaskBean> pags = bpmQueryService.findTaskHasDoneList(0, count, wheresql);	
			list = pags.getResults();
			reList.addAll(list);
			if (reList != null && reList.size() > 0) {
				lstcount = reList.size();
				if (lstcount > count) {
					for (int i = 0; i < count; i++) {
						TaskBean entity = reList.get(i);
						String url = "";
						if (tasktype.equals("circulars")) {
							url =  entity.getId_();
						} else if (tasktype.equals("read")) {
							url = "/bpmCirculate/findCirculate?bizid=" + entity.getBizid() + "&id=" + entity.getId_();
						} else {
//							url = "/" + entity.getUrl() + "/" + "to" + entity.getUrl() + "edit?bizid=" + entity.getId();
							url = "/bpmRunController/view?bizId="+ entity.getBizid()+"&&taskId="+entity.getId_();
							//url = "/bpmRuBizInfoController/deal?bizId="+ entity.getBizid()+"&&procInstId="+ entity.getProcinst_id() +"&&solId="+entity.getSolid()+"&&taskId="+entity.getTaskId();
						}
//						lst.append("<TR><TD style='width:70%;' onclick='opentab(\"" + entity.getTaskname() + "\","
//								+ entity.getId() + ",\"" + url + "\")\'>");
						lst.append("<TR><TD style='width:2%;'><input id='"+entity.getId_()+"' name='hasdone' type='checkbox'/></TD><TD style='width:63%;' onclick='opentab(\"" + entity.getName_() + "\",\""
								+ entity.getId_() + "\",\"" + url + "\")\'>");
						if (i == 0) {
							lst.append("<span></span><span class='count red'>" + (i + 1) + "</span>");// 红色处理
						} else if (i == 1) {
							lst.append("<span></span><span class='count green'>" + (i + 1) + "</span>");// 绿色处理
						} else if (i == 2) {
							lst.append("<span></span><span class='count blue'>" + (i + 1) + "</span>");// 蓝色处理
						} else {
							lst.append("<span></span><span class='count'>" + (i + 1) + "</span>");// 默认的灰色
						}
						lst.append(entity.getName_() + "</TD>");
						lst.append("<TD style='width:20%;text-align:center;' onclick='opentab(\"" + entity.getName_() + "\",\""
								+ entity.getId_() + "\",\"" + url + "\")\'><span class=\"todo_views\">查看</span></TD>");
						if (entity.getCreate_time() != null) {
							lst.append("<TD width='15%' class='time'>"
									+ entity.getCreate_time() + "</TD></TR>");
						} else if (entity.getCreate_time() != null) {
							lst.append("<TD width='15%' class='time'>" + entity.getCreate_time().substring(0, 10)
									+ "</TD></TR>");
						}
					}
				} else {
					for (int i = 0; i < reList.size(); i++) {
						TaskBean entity = reList.get(i);
						String url = "";
						if (tasktype.equals("circulars")) {
							url =  entity.getId_();
						} else if (tasktype.equals("read")) {
							url = "/bpmCirculate/findCirculate?bizid=" + entity.getBizid() + "&id=" + entity.getId_();
						} else {
							url = "/bpmRunController/view?bizId="+ entity.getBizid()+"&&taskId="+entity.getId_();
							//url = "/bpmRuBizInfoController/deal?bizId="+ entity.getBizid()+"&&procInstId="+ entity.getProcinst_id() +"&&solId="+entity.getSolid()+"&&taskId="+entity.getTaskId();
						}
						lst.append("<TR><TD style='width:5%;'><input id='"+entity.getId_()+"' name='hasdone' type='checkbox'/></TD><TD style='width:65%;' onclick='opentab(\"" + entity.getName_() + "\",\""
								+ entity.getId_() + "\",\"" + url + "\")\'>");
						if (i == 0) {
							lst.append("<span></span><span class='count red'>" + (i + 1) + "</span>");// 红色处理
						} else if (i == 1) {
							lst.append("<span></span><span class='count green'>" + (i + 1) + "</span>");// 绿色处理
						} else if (i == 2) {
							lst.append("<span></span><span class='count blue'>" + (i + 1) + "</span>");// 蓝色处理
						} else {
							lst.append("<span></span><span class='count'>" + (i + 1) + "</span>");// 默认的灰色
						}
						lst.append(entity.getName_() + "</TD>");
						lst.append("<TD style='width:11%;text-align:center;' onclick='opentab(\"" + entity.getName_() + "\",\""
								+ entity.getId_() + "\",\"" + url + "\")\'><span class=\"todo_views\">查看</span></TD>");
						if (entity.getCreate_time() != null) {
							lst.append("<TD width='19%' class='time'>"
									+ entity.getCreate_time() + "</TD>");
						} else if (entity.getCreate_time() != null) {
							lst.append("<TD width='19%' class='time'>" + entity.getCreate_time().substring(0, 10)
									+ "</TD></TR>");
						}
					}
				}
			}
		}
			JSONObject json = new JSONObject();
			json.put("result", lst.toString());
			json.put("lstcount", lstcount);
			System.out.println(json.toString());
			response.getWriter().write(json.toString());
			response.getWriter().flush();
		} catch (IOException e) {
			
			logger.error("error",e);
		}
	}
}
