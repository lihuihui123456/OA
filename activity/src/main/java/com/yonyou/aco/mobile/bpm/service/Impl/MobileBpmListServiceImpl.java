package com.yonyou.aco.mobile.bpm.service.Impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.biz.service.IBpmRunService;
import com.yonyou.aco.mobile.bpm.service.IMobileBpmListService;
import com.yonyou.aco.mobile.util.ConstantInterface;
import com.yonyou.aco.mobile.util.MobileUtils;
import com.yonyou.aco.notice.entity.BizNoticeInfoEntity;
import com.yonyou.aco.notice.entity.BizNoticePeopleEntity;
import com.yonyou.aco.notice.service.NoticeService;
import com.yonyou.cap.bpm.entity.BizGwCircularsBean;
import com.yonyou.cap.bpm.entity.BpmReCommentBean;
import com.yonyou.cap.bpm.entity.BpmReNodeCfgEntity;
import com.yonyou.cap.bpm.entity.BpmReNodeUserEntity;
import com.yonyou.cap.bpm.entity.TaskBean;
import com.yonyou.cap.bpm.entity.TaskNodeBean;
import com.yonyou.cap.bpm.service.IBizSolService;
import com.yonyou.cap.bpm.service.IBpmQueryService;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.bpm.service.IBpmService;
import com.yonyou.cap.bpm.service.IBpmTraceService;
import com.yonyou.cap.common.util.ConfigProvider;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.form.entity.FormColumn;
import com.yonyou.cap.form.service.IFormColumnService;
import com.yonyou.cap.form.service.IFormDataService;
import com.yonyou.cap.isc.user.entity.MobileUserBean;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.service.IUserService;
import com.yonyou.cap.sys.iweboffice.entity.IWebDocumentEntity;
import com.yonyou.cap.sys.iweboffice.service.DocumentService;

/**
 * 
 * ClassName: MobileBpmListServiceImpl
 * 
 * @Description: 移动端-获取业务列表信息webService实现类
 * @author hegd
 * @date 2016-8-23
 */
@Repository("mobileBpmListService")
public class MobileBpmListServiceImpl implements IMobileBpmListService {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource
	MobileBpmCountServiceImpl mobileBpmService;

	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;

	@Resource
	IBpmQueryService bpmQueryService;

	@Resource
	private DocumentService documentService;

	@Resource
	private IBizSolService bizSolService;
	@Resource
	private IBpmService bpmService;
	@Resource
	private IBpmRunService bpmRunService;

	@Resource
	private NoticeService noticeService;

	@Resource
	private IUserService userService;

	@Resource
	IBpmTraceService bpmTraceService;
	@Resource
	IFormDataService formDataService;
	@Resource
	IFormColumnService formColumnService;
	

	/** 附件访问地址 **/
	private String href = ConfigProvider.getPropertiesValue(
			"config.properties", "isAttachmentUrl");

	/** 正文访问地址 **/
	private String mobileWeboffice = ConfigProvider.getPropertiesValue(
			"config.properties", "mobileWeboffice");
	/** 正文下载地址 **/
	private String mobileWebofficedownload = ConfigProvider.getPropertiesValue(
			"config.properties", "mobileWebofficedownload");

	@Override
	public String findBpmList(String userId, String status, int page,
			int perPageNum) {

		JSONObject json = new JSONObject();
		Map<String, String> map = new HashMap<String, String>();
		String num = "";
		String tableRows = "";

		String type = "";
		/** 待阅列表 */
		PageResult<BizGwCircularsBean> pageRead;
		/** 通知公告列表 */
		PageResult<BizNoticeInfoEntity> pageNotice;
		/** 待办列表 */
		PageResult<TaskBean> pageTask;
		// 待阅
		if ("0".equals(status)) {
			pageRead = mobileBpmService.findMobileReadInfoByUserId(page,
					perPageNum, userId);
			type = "阅件";
			tableRows = ReadListToString(pageRead, type);
			map.put("name", "待办事项");
			map.put("displayName", "待办事项");
			map.put("tableSchema", ConstantInterface.TABLESCH);
			map.put("tableRows", tableRows);
			num = pageRead.getTotalrecord() + "";

		}
		// 通知公告
		if ("1".equals(status)) {
			pageNotice = mobileBpmService.findUneadNoticeNoReadInfoByUserId(page,
					perPageNum, userId);
			type = "通知公告";
			tableRows = NoticeListToString(pageNotice, type);
			map.put("name", "待办事项");
			map.put("displayName", "待办事项");
			map.put("tableSchema", ConstantInterface.TABLESCH);
			map.put("tableRows", tableRows);
			num = pageNotice.getTotalrecord() + "";
		}
		// 已办
		/*if (status.equals("2")) {
			pageTask = bpmQueryService.findMobileTaskHasIssuedList(page, perPageNum,
					userId);
			tableRows = TaskListToString(pageTask, type);
			map.put("name", "已发事项");
			map.put("displayName", "已发事项");
			map.put("tableSchema", ConstantInterface.TABLESCH);
			map.put("tableRows", tableRows);
			num = pageTask.getTotalrecord() + "";
		}*/
		if ("2".equals(status)) {
			pageTask = bpmQueryService.findMobileTaskHasDoneList(page, perPageNum,
					userId);
			tableRows = TaskListToString(pageTask, type);
			map.put("name", "已办事项");
			map.put("displayName", "已办事项");
			map.put("tableSchema", ConstantInterface.TABLESCH);
			map.put("tableRows", tableRows);
			num = pageTask.getTotalrecord() + "";
		}

		// 跟踪事项
		if ("3".equals(status)) {
			pageTask = bpmTraceService.findMobileTaskTraceList(page,
					perPageNum, userId);
			tableRows = TaskListToString(pageTask, type);
			map.put("name", "跟踪事项");
			map.put("displayName", "跟踪事项");
			map.put("tableSchema", ConstantInterface.TABLESCH);
			map.put("tableRows", tableRows);
			num = pageTask.getTotalrecord() + "";
		}
		// 所有事项
		if ("4".equals(status)) {
			pageTask =bpmQueryService.findMobileTaskAllList(page, perPageNum, userId);
			tableRows = TaskListToString(pageTask, type);
			map.put("name", "所有事项");
			map.put("displayName", "所有事项");
			map.put("tableSchema", ConstantInterface.TABLESCH);
			map.put("tableRows", tableRows);
			num = pageTask.getTotalrecord() + "";
		}
		// 待办
		if ("5".equals(status)) {
			pageTask = mobileBpmService.findtTaskInfoByUserId(page, perPageNum,
					userId);
			tableRows = TaskListToString(pageTask, type);
			map.put("name", "待办事项");
			map.put("displayName", "待办事项");
			map.put("tableSchema", ConstantInterface.TABLESCH);
			map.put("tableRows", tableRows);
			num = pageTask.getTotalrecord() + "";
		}

		try {
			if (!"1".equals(tableRows)) {
				json.put("errorCode", "0");
				json.put("errorMessage", "成功");
			} else {
				json.put("errorCode", "1");
				json.put("errorMessage", "失败");
			}
			json.put("requestType", status);
			json.put("totalNums", num);
			json.put("table", map);

		} catch (Exception e) {
			logger.error("error",e);
		}
		return json.toString();
	}

	/**
	 * 
	 * @Description: 通知公告List转换成String
	 * @param @param pageList
	 * @param @return
	 * @return String
	 * @throws
	 * @author hegd
	 * @date 2016-8-24
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String NoticeListToString(PageResult<BizNoticeInfoEntity> pageList,
			String type) {
		/** 需要转换的list **/
		List<List> list = new ArrayList<List>();
		if (pageList != null) {
			for (int i = 0; i < pageList.getResults().size(); i++) {
				/** 业务ID map **/
				Map<String, String> mapBizid = new HashMap<String, String>();
				/** 拟稿部门 map **/
				Map<String, String> mapDept = new HashMap<String, String>();
				/** 标题 map **/
				Map<String, String> mapTitle = new HashMap<String, String>();
				/** 发起时间 map **/
				Map<String, String> mapTime = new HashMap<String, String>();
				/** 发文类型 map **/
				Map<String, String> mapType = new HashMap<String, String>();
				/** 发文人 map **/
				Map<String, String> mapReceiveUser = new HashMap<String, String>();
				/** tableIdmap **/
				Map<String, String> tableIdmap = new HashMap<String, String>();
				BizNoticeInfoEntity task = pageList.getResults().get(i);
				// modify by hegd 2016年10月26日
				tableIdmap.put("name", "tableId");
				tableIdmap.put("value", task.getTableid());
				mapReceiveUser.put("name", "receiveUser");
				mapReceiveUser.put("value", task.getSender());
				mapBizid.put("name", "bizid");
				mapBizid.put("value", task.getId());
				mapDept.put("name", "draft_depart_name");
				mapDept.put("value", "");
				mapTitle.put("name", "title");
				mapTitle.put("value", task.getTitle());
				mapTime.put("name", "start_time");
				mapTime.put("value", task.getMobileCreateTime());
				mapType.put("name", "biz_type");
				mapType.put("value", type);
				List listmap = new ArrayList<>();
				listmap.add(tableIdmap);
				listmap.add(mapReceiveUser);
				listmap.add(mapBizid);
				listmap.add(mapDept);
				listmap.add(mapTitle);
				listmap.add(mapTime);
				listmap.add(mapType);
				list.add(listmap);
			}
		} else {
			return "1";
		}
		return JSONArray.fromObject(list).toString();
	}

	/**
	 * 
	 * @Description: 待办List转换成String
	 * @param @param pageList
	 * @param @return
	 * @return String
	 * @throws
	 * @author hegd
	 * @date 2016-8-24
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String TaskListToString(PageResult<TaskBean> pageList, String type) {
		/** 需要转换的list **/
		List<List> list = new ArrayList<List>();
		if (pageList != null) {
			for (int i = 0; i < pageList.getResults().size(); i++) {
				/** 业务ID map **/
				Map<String, String> mapBizid = new HashMap<String, String>();
				/** 流程任务Id map **/
				Map<String, String> mapTaskId = new HashMap<String, String>();
				/** 拟稿部门 map **/
				Map<String, String> mapDept = new HashMap<String, String>();
				/** 标题 map **/
				Map<String, String> mapTitle = new HashMap<String, String>();
				/** 发起时间 map **/
				Map<String, String> mapTime = new HashMap<String, String>();
				/** 发文类型 map **/
				Map<String, String> mapType = new HashMap<String, String>();
				/** 发文人 map **/
				Map<String, String> mapReceiveUser = new HashMap<String, String>();
				TaskBean task = pageList.getResults().get(i);
				String receiveUser = task.getPostman();
				if (StringUtils.isEmpty(receiveUser)) {
					receiveUser = findUserNamebyUserId(task.getUser_name());
				}
				mapReceiveUser.put("name", "receiveUser");
				mapReceiveUser.put("value", receiveUser);
				mapBizid.put("name", "bizid");
				mapBizid.put("value", task.getBizid());
				mapDept.put("name", "draft_depart_name");
				mapDept.put("value", task.getDraft_department());
				mapTitle.put("name", "title");
				mapTitle.put("value", task.getName_());
				mapTime.put("name", "start_time");
				mapTime.put("value", task.getMobileCreateTime());
				mapType.put("name", "biz_type");
				mapType.put("value", task.getTableName());
				mapTaskId.put("name", "taskId");
				mapTaskId.put("value", task.getTaskid());
				List listmap = new ArrayList<>();
				listmap.add(mapReceiveUser);
				listmap.add(mapBizid);
				listmap.add(mapTaskId);
				listmap.add(mapDept);
				listmap.add(mapTitle);
				listmap.add(mapTime);
				listmap.add(mapType);
				list.add(listmap);
			}
		} else {
			return "1";
		}
		return JSONArray.fromObject(list).toString();
	}

	/**
	 * 
	 * @Description: 待阅List转换成String
	 * @param @param pageList
	 * @param @return
	 * @return String
	 * @throws
	 * @author hegd
	 * @date 2016-8-24
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String ReadListToString(PageResult<BizGwCircularsBean> pageList,
			String type) {
		/** 需要转换的list **/
		List<List> list = new ArrayList<List>();
		if (pageList != null) {
			for (int i = 0; i < pageList.getResults().size(); i++) {
				/** 业务ID map **/
				Map<String, String> mapBizid = new HashMap<String, String>();
				/** 拟稿部门 map **/
				Map<String, String> mapDept = new HashMap<String, String>();
				/** 标题 map **/
				Map<String, String> mapTitle = new HashMap<String, String>();
				/** 发起时间 map **/
				Map<String, String> mapTime = new HashMap<String, String>();
				/** 发文类型 map **/
				Map<String, String> mapType = new HashMap<String, String>();
				/** 发文人 map **/
				Map<String, String> mapReceiveUser = new HashMap<String, String>();
				/** 阅件Id map **/
				Map<String, String> mapId = new HashMap<String, String>();
				/** 阅件Id map **/
				Map<String, String> mapTaskId = new HashMap<String, String>();
				BizGwCircularsBean task = pageList.getResults().get(i);
				// modify by hegd 2016年10月26日
				mapId.put("name", "Id");
				mapId.put("value", task.getId());
				mapReceiveUser.put("name", "receiveUser");
				mapReceiveUser.put("value", task.getCirculation_man());
				mapBizid.put("name", "bizid");
				mapBizid.put("value", task.getBizid());
				mapTitle.put("name", "title");
				mapTitle.put("value", task.getBiz_title());
				mapTime.put("name", "start_time");
				mapTime.put("value", task.getMobileCreateTime());
				mapType.put("name", "biz_type");
				mapType.put("value", task.getBiz_type());
				mapTaskId.put("name", "taskId");
				mapTaskId.put("value", task.getTaskId());
				List listmap = new ArrayList<>();
				listmap.add(mapId);
				listmap.add(mapReceiveUser);
				listmap.add(mapBizid);
				listmap.add(mapDept);
				listmap.add(mapTitle);
				listmap.add(mapTime);
				listmap.add(mapType);
				listmap.add(mapTaskId);
				list.add(listmap);
			}
		} else {
			return "1";
		}
		return JSONArray.fromObject(list).toString();
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String findMobileTaskInfoByTaskIdAndBizInfoId(String taskId,
			String bizId, String terminal, String valueType) {
		try {
			MobileUtils mu = new MobileUtils();
			/** 附件List **/
			List<IWebDocumentEntity> list;
			/** 返回结果 **/
			JSONObject sendJsonObj = new JSONObject();
			/** 附件返回结果字符串 **/
			String res;
			/** 收发文表单数据 **/
			if ("1".equals(valueType)) {
				Map<String, Object> map = bpmRunService.getMobileDealData(
						bizId, taskId);
				if (map != null && !map.isEmpty()) {
					/** 表单基本数据 **/
					/*Map<String, Object> formData = (Map<String, Object>) map
							.get("formData");*/
					List<Map> data = formDataService.getFormData(map.get("freeFormId").toString(), bizId);
					List<FormColumn> commentCols = formColumnService.findCommentsColByFormId(map.get("freeFormId").toString());
					String procInstId = map.get("procInstId").toString();
					if(null != data && !data.isEmpty()) {
						for (Map<String, Object> formData : data) {
							String formKeyString;
							Object formValue;
							Iterator it = formData.entrySet().iterator();
							while (it.hasNext()) {
								Entry entry = (Entry) it.next();
								formKeyString = entry.getKey().toString(); // 返回与此项对应的键
								formValue = entry.getValue(); // 返回与此项对应的值
								StringBuffer comment;
								if ("securityLevel_".equals(formKeyString)) {
									formValue = mu.numberToStrgin(formValue.toString(),
											"2");
								}
								if ("urgencyLevel_".equals(formKeyString)) {
									formValue = mu.numberToStrgin(formValue.toString(),
											"1");
								}
								if(null != commentCols && !commentCols.isEmpty()) {
									for (FormColumn formColumn : commentCols) {
										if(null != formColumn.getCol_code() && formColumn.getCol_code().equals(formKeyString)) {
											if (StringUtils.isNotEmpty(procInstId)) {
												// 查询意见
												List<BpmReCommentBean> commentBeans = bpmRuBizInfoService.findCommentByProcInstIdAndFieldName(
														procInstId, formKeyString);
												// 拼意见
												comment = new StringBuffer();
												String time;
												if(commentBeans != null && commentBeans.size()>0){
													for (int i = 0; i < commentBeans.size(); i++) {
														time = DateUtil.formatDate(commentBeans.get(i).getTime_(), "yyyy-MM-dd HH:mm:ss");
														if(i == commentBeans.size()-1){
															comment.append("{\"message\":\""+commentBeans.get(i).getMessage_().trim()+"\",\"userName\":\""+commentBeans.get(i).getUserName_()+"\",\"time\":\""+time+"\"}");
														}else{
															comment.append("{\"message\":\""+commentBeans.get(i).getMessage_().trim()+"\",\"userName\":\""+commentBeans.get(i).getUserName_()+"\",\"time\":\""+time+"\"},");
														}
													}
												}else{
													comment.append("{}");
												}
												formValue = "["+comment.toString()+"]";
												
											}
										}
									}
								}
								if ("commentBm_".equals(formKeyString)
										|| "commentJld_".equals(formKeyString)
										|| "commentYld_".equals(formKeyString)
										|| "commentDwld_".equals(formKeyString)
										|| "commentCbc_".equals(formKeyString)) {
									if ("[[{}]]".equals(formValue)){
										formValue = "";
									}
									sendJsonObj.put(formKeyString, formValue);
								} else {
									if ("dr_".equals(formKeyString)) {
									} else {
										if (formValue != null) {
											sendJsonObj.put(formKeyString,
													formValue.toString());
										} else {
											sendJsonObj.put(formKeyString, "");
										}
									}
								}
							}
						}
					}
					sendJsonObj.put("errorCode", "0");
					sendJsonObj.put("errorMessage", "0");
					sendJsonObj.put("bizId_", bizId);
					sendJsonObj.put("solId",
							mu.isNull(map.get("solId").toString()));
					sendJsonObj.put("taskId",
							mu.isNull(map.get("taskId").toString()));
					sendJsonObj.put("procdefId",
							mu.isNull(map.get("procdefId").toString()));
					sendJsonObj.put("isFreeSelect",
							mu.isNull(map.get("isFreeSelect").toString()));
					sendJsonObj.put("commentColumn",
							mu.isNull(map.get("commentColumn").toString()));
					sendJsonObj.put("tableName",
							mu.isNull(map.get("tableName").toString()));
					return sendJsonObj.toString();

				} else {
					sendJsonObj.put("errorCode", "1");
					sendJsonObj.put("errorMessage", "获取数据失败!");
					return sendJsonObj.toString();
				}

			}
			/** 收发文附件 **/
			if ("2".equals(valueType)) {
				// 附件个数
				list = findAttachmentInfoByBizId(bizId, "1");
				res = attachmentToString(list, "1");
				return res;
			}
			/** 通知公告表单数据 **/
			if ("3".equals(valueType)) {
				JSONArray arry = new JSONArray();
				BizNoticeInfoEntity bninEntity = noticeService
						.findNoticeInfoById(bizId);
				PageResult<BizNoticePeopleEntity> page = noticeService
						.findNoticeAllPeopleinfo(bizId);
				String bid = "";
				List<BizNoticePeopleEntity> listBnpe = page.getResults();
				if (listBnpe!=null && !listBnpe.isEmpty()) {
					JSONObject bnpeopleObj;
					BizNoticePeopleEntity bnpeople;
					for (int i = 0; i < listBnpe.size(); i++) {
						bnpeopleObj = new JSONObject();
						bnpeople = listBnpe.get(i);
						bid = bnpeople.getBid();
						/** 主表单ID **/
						bnpeopleObj.put("bid", bnpeople.getBid());
						/** 接收ID **/
						bnpeopleObj.put("receiveuid", bnpeople.getReceiveuid());
						/** 发送ID **/
						bnpeopleObj.put("senduid", bnpeople.getSenduid());
						/** 发送时间 **/
						bnpeopleObj.put("sendtime", bnpeople.getSendtime());
						/** 阅读时间 **/
						bnpeopleObj.put("finishtime", bnpeople.getFinishtime());
						/** 阅读状态 **/
						bnpeopleObj.put("status",
								mu.numberToStrgin(bnpeople.getStatus(), "3"));
						arry.add(bnpeopleObj);
					}
					String total;// 总数
					String readNum;// 已处理数
					String unread;// 未处理数
					BizNoticePeopleEntity link = noticeService.findCount(bid);
					if (link != null) {
						total = link.getCol1().toString();
						readNum = link.getCol2().toString();
						unread = link.getCol3().toString();
						sendJsonObj.put("total", total);
						sendJsonObj.put("readNum", readNum);
						sendJsonObj.put("unread", unread);
					} else {
						sendJsonObj.put("total", "");
						sendJsonObj.put("readNum", "");
						sendJsonObj.put("unread", "");
					}
				} else {
					arry.add("");
				}
				if (bninEntity != null) {
					sendJsonObj.put("errorCode", "0");
					sendJsonObj.put("errorMessage", "获取数据成功!");
					sendJsonObj.put("title_", bninEntity.getTitle());// 标题
					sendJsonObj.put("sender", bninEntity.getSender());// 发送人
					sendJsonObj.put("textfield", bninEntity.getTextfield());// 正文/描述
					sendJsonObj.put("noticeReadPeoples", arry);// 阅读人员
				} else {
					sendJsonObj.put("errorCode", "1");
					sendJsonObj.put("errorMessage", "获取数据失败!");
				}
				return sendJsonObj.toString();

			}
			/** 通知公告附件个数 **/
			if ("4".equals(valueType)) {
				JSONObject attrObj = new JSONObject();
				BizNoticeInfoEntity bninEntity = noticeService
						.findNoticeInfoById(bizId);
				String tableId = bninEntity.getTableid();
				if (!StringUtils.isEmpty(tableId)) {
					list = findAttachmentInfoByBizId(tableId, "1");
					res = attachmentToString(list, "1");
					return res;
				} else {
					attrObj.put("attachment", "");
					return sendJsonObj.toString();
				}
			}
			/** 正文访问地址和下载地址 **/
			if ("5".equals(valueType)) {
				// 拼接正文打开下载地址
				list = findAttachmentInfoByBizId(bizId, "2");
				res = attachmentToString(list, "2");
				return res;
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return "";
	}

	/**
	 * 通过bizId获取附件
	 * 
	 * @param bizId
	 * @return
	 */
	public List<IWebDocumentEntity> findAttachmentInfoByBizId(String bizId,
			String type) {
		List<IWebDocumentEntity> list = new ArrayList<IWebDocumentEntity>();
		if ("1".equals(type)) {
			list = documentService
					.selectBySql("SELECT * from iweb_document where file_status ='0' and enabled = '1' and table_id = '"
							+ bizId + "' order by serial_number");
		}
		if ("2".equals(type)) {
			IWebDocumentEntity iweb = documentService
					.findDocumentByBizid(bizId);
			if(iweb != null){
				list.add(iweb);
			}
		}
		return list;
	}

	@Override
	public String findMobileSendUser(String procdefId, String nodeId,
			String bizId, String solId) {
		JSONObject object = new JSONObject();
		JSONArray array = new JSONArray();
		List<MobileUserBean> list = new ArrayList<MobileUserBean>();
		List<BpmReNodeUserEntity> listNode = bizSolService.findNodeUser(
				procdefId, nodeId, solId, "0");
		for (BpmReNodeUserEntity node : listNode) {
			/**
			 * 用户类型 1、发起人 2、用户 3、用户组 4、用户或组来自流程变量 5、用户或组来自表单数据 6、用户或组来自脚本运算结果
			 * 7、用户来自用户关系运算结果 8、用户组来自用户与组关系运算结果 9、用户来自用户与组关系运算结果
			 */
			if ("1".equals(node.getUser_type_())) {
				MobileUserBean u = bizSolService.findUserByBizId(bizId);
				list.add(u);
			} else if ("2".equals(node.getUser_type_())) {
				MobileUserBean u = bizSolService.findUserByUserId(node
						.getUser_value_());
				list.add(u);
			} else if ("3".equals(node.getUser_type_())) {
				List<MobileUserBean> userlist = bizSolService
						.findUserGroup(node.getUser_value_());
				list.addAll(userlist);
			} else {
				continue;
			}
		}
		List<MobileUserBean> lastlist = new ArrayList<MobileUserBean>();
		if (list != null && !list.isEmpty()) {
			for (MobileUserBean ll : list) {
				if (lastlist != null && !lastlist.isEmpty()) {
					boolean bl = false;
					for (int i = 0; i < lastlist.size(); i++) {
						if ((ll.getUSER_ID()).equals(lastlist.get(i)
								.getUSER_ID())) {
							bl = true;
							break;
						}
					}
					if (!bl) {
						lastlist.add(ll);
					}
				} else {
					lastlist.add(ll);
				}
			}

		}
		String picUrl = "/uploader/uploadfile?pic=";
		if (lastlist != null && !lastlist.isEmpty()) {
			for (int i = 0; i < lastlist.size(); i++) {
				MobileUserBean muBean = lastlist.get(i);
				object.put("id", muBean.getUSER_ID());
				object.put("userName", muBean.getUSER_NAME());
				object.put("departmentName", muBean.getDEPT_NAME());
				object.put("company", muBean.getORG_NAME());
				object.put("userCode", muBean.getUSER_CODE());
				object.put("phone", muBean.getPHONE());
				object.put("tel", muBean.getTEL());
				object.put("email", muBean.getEMAIL());
				object.put("ImgUrl", picUrl + muBean.getIMGURL());
				array.add(object);
			}
			object.put("errorCode", "0");
			object.put("errorMessage", "获取人员成功!");
			object.put("items", array);

		} else {
			object.put("errorCode", "1");
			object.put("errorMessage", "获取人员失败!");
			object.put("items", "");
		}
		return object.toString();
	}

	@Override
	public String findSendTaskNode(String procdefId, String taskId,
			String isFreeSelect, String solId) {
		JSONArray array = new JSONArray();
		JSONObject object1 = new JSONObject();
		List<TaskNodeBean> list = bpmRunService.findNextTaskNodes(isFreeSelect,
				taskId);
		if (list != null && !list.isEmpty()) {
			for (int i = 0; i < list.size(); i++) {
				JSONObject object = new JSONObject();
				TaskNodeBean taskBean = list.get(i);
				String actId = taskBean.getActId();// 任务节点Id
				String actName = taskBean.getActName();// 任务节点名称
				// 任务节点类别 userTask ：任务节点 endEcent : 结束节点
				String actType = taskBean.getActType();
				object.put("errorCode", "0");
				object.put("errorMessage", "获取数据成功!");
				object.put("actId", actId);
				object.put("actName", actName);
				object.put("actType", actType);
				BpmReNodeCfgEntity nodeEntity = bizSolService.findTaskNodeCfg(
						solId, procdefId, actId);
				if (nodeEntity != null) {
					// 1：为可以选人
					// 其他：不可以选
					object.put("exeUser", nodeEntity.getExeUser_());
					// 1:为会签
					// 其他：不是会签
					if (nodeEntity.getIsHqNode_() == null) {
						object.put("isHqNode", "");
					} else {
						object.put("isHqNode", nodeEntity.getIsHqNode_());
					}
				} else {
					// 1：为可以选人
					// 其他：不可以选
					object.put("exeUser", "");
					// 1:为会签
					// 其他：不是会签
					object.put("isHqNode", "");

				}
				array.add(object);
			}
		} else {
			object1.put("errorCode", "1");
			object1.put("errorMessage", "获取数据失败!");
			array.add(object1);
		}
		return array.toString();
	}

	/**
	 * 附件List转换为JSON字符串
	 * 
	 * @param list
	 * @return
	 */
	public String attachmentToString(List<IWebDocumentEntity> list,
			String isWebOffice) {
		MobileUtils mu = new MobileUtils();
		JSONObject sendJsonObj = new JSONObject();
		String message = "获取成功";
		String recordId;
		if (list !=null && !list.isEmpty()) {
			// 附件array数组
			JSONArray attArray = new JSONArray();
			for (int i = 0; i < list.size(); i++) {
				IWebDocumentEntity ide = list.get(i);
				recordId = ide.getRecordId();
				String path = ide.getHtmlPath();
				File file = new File(path + "/" + recordId);
				double fileLength = file.length();
				/** 附件大小 **/
				String size = mu.getFormatSize(fileLength);
				String fileName = mu.isNull(ide.getFileName());
				String documentId = ide.getId();
				String type = mu.isNull(ide.getFileType());
				type = type.substring(1, type.length());
				JSONObject attObject = new JSONObject();
				if (StringUtils.isEmpty(fileName)) {
					fileName = "默认模板.doc";
				}
				if ("2".equals(isWebOffice)) {
					sendJsonObj.put("mainBodySRC", mobileWeboffice + recordId);
					attObject.put("href", mobileWebofficedownload + documentId);
				} else {
					attObject.put("href", href + documentId);
				}
				attObject.put("fileName", fileName);
				attObject.put("size", size);
				attObject.put("documentId", documentId + "");
				attObject.put("type", type);
				attArray.add(attObject);
			}
			sendJsonObj.put("attachment", attArray);
			sendJsonObj.put("errorMessage", message);
			sendJsonObj.put("erroCode", 0);
			return sendJsonObj.toString();
		} else {
			sendJsonObj.put("attachment", "");
			sendJsonObj.put("mainBodySRC", "");
			return sendJsonObj.toString();
		}
	}

	/**
	 * 获取用户名称
	 * 
	 * @param userId
	 * @return
	 */
	public String findUserNamebyUserId(String userId) {

		if (StringUtils.isEmpty(userId)) {
			return "";
		} else {
			User user = userService.findUserById(userId);
			return user.getUserName();
		}
	}
}
