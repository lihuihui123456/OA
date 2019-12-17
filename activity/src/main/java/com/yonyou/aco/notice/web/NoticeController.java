package com.yonyou.aco.notice.web;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.circularize.service.CircularizeService;
import com.yonyou.aco.notice.entity.BizNoticeInfoBean;
import com.yonyou.aco.notice.entity.BizNoticeInfoEntity;
import com.yonyou.aco.notice.entity.BizNoticePeopleEntity;
import com.yonyou.aco.notice.service.NoticeService;
import com.yonyou.cap.common.audit.operatelog.annotation.AroundAspect;
import com.yonyou.cap.common.util.AcoConstant;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.sys.lucene.service.ILuceneService;
/**
 * 名称: 通知公告. 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年8月5日
 * @author 薛志超
 * @since 1.0.0
 */
@Controller
@RequestMapping("/notice")
public class NoticeController {
	
	private final org.slf4j.Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	NoticeService noticeService;
	@Autowired
	ILuceneService luceneService;
	@Autowired
	CircularizeService circularizeService;
	@Autowired
	private HttpServletRequest request;

	/**
	 * 名称: 跳转到发送通知列表页面 备注：原名称（index）
	 * 
	 * @return
	 */
	@RequestMapping("/addToListFSNotice")
	@AroundAspect(description="通知公告发布-跳转到发送通知列表页面")
	public @ResponseBody
	ModelAndView addToListFSNotice() {
		ModelAndView mv = new ModelAndView();
		BizNoticeInfoEntity noticeInfo = new BizNoticeInfoEntity();
		String tableid = UUID.randomUUID().toString();
		noticeInfo.setTableid(tableid);
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user != null) {
			noticeInfo.setSender(user.getName());
			noticeInfo.setSenderid(user.getUserId());
		}
		mv.addObject("noticeInfo", noticeInfo);
		mv.setViewName("aco/notice/noticefs");
		return mv;
	}

	/**
	 * 名称: 跳转到发送通知页面 注释：原方法名称(indexList)
	 * 
	 * @return
	 */
	@AroundAspect(description="通知公告发布-跳转到发送通知列表页面")
	@RequestMapping("/toInexList")
	public String addInexList() {
		return "aco/notice/noticeList";
	}

	@RequestMapping("/searchdatalist")
	public String searchdatalist() throws UnsupportedEncodingException {

		String parm = request.getParameter("parm");
		if (!"".equals(parm) && parm != null) {
			parm = new String(parm.getBytes("iso-8859-1"), "utf-8");
		}
		request.setAttribute("fieldValue", parm);
		return "aco/notice/luceneSearch";
	}

	/**
	 * 名称: 分页查询列表，模糊搜索标题 备注：原方法名称（getAllNoticeinfo）
	 * 
	 * @param page
	 * @param rows
	 * @param query
	 * @return
	 */
	@AroundAspect(description="通知公告发布-分页查询通知公告列表")
	@RequestMapping("/findAllNoticeList")
	public @ResponseBody
	TreeGridView<BizNoticeInfoBean> findAllNoticeList(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "query",defaultValue = "") String query,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value = "queryPams", defaultValue = "") String queryPams) {

		TreeGridView<BizNoticeInfoBean> treeGridview = new TreeGridView<BizNoticeInfoBean>();
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			if(null != user){
			PageResult<BizNoticeInfoBean> pags = noticeService
					.findAllNoticeList(pageNum, pageSize, query,sortName,sortOrder,queryPams,user);
			treeGridview.setRows(pags.getResults());
			treeGridview.setTotal(pags.getTotalrecord());
			}
			return treeGridview;
		} catch (Exception e) {
			logger.error("error",e);
			return null;

		}
	}

	/**
	 * 名称: 保存表单信息操作 备注：原方法名（saveInfo）
	 * 
	 * @param noticeInfo
	 * @return
	 */
	@RequestMapping("/doSaveNoticeInfo")
	@AroundAspect(description="通知公告发布-保存表单")
	public @ResponseBody
	String doSaveNoticeInfo(@Valid BizNoticeInfoEntity noticeInfo) {
		Date now = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");// 可以方便地修改日期格式
		String time = dateFormat.format(now);
		noticeInfo.setCreationtime(time);
		String statusId = noticeService.doSaveNoticeInfo(noticeInfo,request);
		return statusId;
	}

	/**
	 * 名称: 查询发送通知信息 说明: 根据id查询发送通知消息 备注：原方法名（queryInfoById）
	 * 
	 * @param id
	 * @param type
	 * @return
	 */
	@RequestMapping("/editFindNoticeFsById")
	@AroundAspect(description="通知公告发布-查看通知公告")
	public @ResponseBody
	ModelAndView editFindNoticeFsById(@RequestParam(value = "id") String id,
			@RequestParam(value = "type") String type) {
		int[] numbers = { 0, 0, 0 };
		BigInteger con1 ;// 总数
		BigInteger con2 ;// 已处理数
		BigInteger con3 ;// 未处理数
		BizNoticePeopleEntity link = noticeService.findCount(id);
		if (link != null) {
			con1 = link.getCol1();
			con2 = link.getCol2();
			con3 = link.getCol3();
			numbers[0] = con1.intValue();
			numbers[1] = con2.intValue();
			numbers[2] = con3.intValue();
		}
		ModelAndView mv = new ModelAndView();
		mv.addObject("type", type);
		mv.addObject("numbers", numbers);
		mv.addObject("noticeInfo", noticeService.findNoticeInfoById(id));
		mv.setViewName("aco/notice/noticefs");
		return mv;
	}

	/**
	 * 名称: 通知公告 说明: 通知公告查看(首页) 备注： 原方法名称 queryInfoById_js
	 * 
	 * @param id
	 * @param type
	 * @return
	 */
	@RequestMapping("/findJsNoticeById")
	@AroundAspect(description="通知公告栏-通知公告查看")
	public @ResponseBody
	ModelAndView findJsNoticeById(@RequestParam(value = "id") String id,
			@RequestParam(value = "type") String type) {
		ModelAndView mv = new ModelAndView();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(null != user){
			BizNoticePeopleEntity bean = noticeService.queryPeopleById(id,
					user.getId());
			Date now = new Date();
			SimpleDateFormat dateFormat = new SimpleDateFormat(
					"yyyy-MM-dd HH:mm:ss");// 可以方便地修改日期格式
			String time = dateFormat.format(now);
			bean.setStatus("1");
			bean.setFinishtime(time);
			noticeService.doSaveNoticePeopleInfo(bean);
		}
		BizNoticeInfoEntity noticeInfo = noticeService.findNoticeInfoById(id);
		int[] numbers = { 0, 0, 0 };
		BigInteger con1 ;// 总数
		BigInteger con2 ;// 已处理数
		BigInteger con3 ;// 未处理数
		BizNoticePeopleEntity link = noticeService.findCount(id);
		if (link != null) {
			con1 = link.getCol1();
			con2 = link.getCol2();
			con3 = link.getCol3();
			numbers[0] = con1.intValue();
			numbers[1] = con2.intValue();
			numbers[2] = con3.intValue();
		}
		mv.addObject("type", type);
		mv.addObject("numbers", numbers);
		mv.addObject("noticeInfo", noticeInfo);
		mv.setViewName("aco/notice/noticejs");
		return mv;
	}

	/**
	 * 名称: 保存人员信息. 说明: 保存接收人的信息 备注：原名称（sendGTasks）
	 * 
	 * @param senderid
	 * @param sceneid
	 * @param id
	 * @return
	 */
	@RequestMapping("/doSaveRecePer")
	@AroundAspect(description="通知公告发布-保存人员信息")
	public @ResponseBody
	String doSaveRecePer(@RequestParam(value = "senderid") String senderid,
			@RequestParam(value = "sceneid") String sceneid,
			@RequestParam(value = "id") String id) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			noticeService.doSaveRecePeople(senderid, sceneid, id,user);
			return "1";
		}
		return "";
	}

	/**
	 * 名称: 接收通知. 说明: 列出接收通知 注释：原方法名称（inexJslist）
	 * 
	 * @return
	 */
	@RequestMapping("/addToJsNoticeList")
	public String addToJsNoticeList() {
		return "aco/notice/noticeJsList";
	}

	/**
	 * 名称：加载接收通知列表 备注:原名称（getAllNoticeinfoJs）
	 * 
	 * @param page
	 * @param rows
	 * @param query
	 * @return
	 */
	@RequestMapping("/findJsNoticeList")
	@AroundAspect(description="通知公告-分页查询通知列表")
	public @ResponseBody
	TreeGridView<BizNoticeInfoEntity> findJsNoticeList(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "query",defaultValue = "") String query) {
		TreeGridView<BizNoticeInfoEntity> treeGridview = new TreeGridView<BizNoticeInfoEntity>();
		PageResult<BizNoticeInfoEntity> pags = new PageResult<BizNoticeInfoEntity>();
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			if (!"".equals(query) && query != null) {
				query = new String(query.getBytes("iso-8859-1"), "utf-8");
			}
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			String userid = user.getId();
			pags = noticeService.findJsNoticeList(pageNum, pageSize, userid,
					query, "");
			treeGridview.setRows(pags.getResults());
			treeGridview.setTotal(pags.getTotalrecord());
			return treeGridview;
		} catch (Exception e) {
			logger.error("error",e);
			return null;
		}
	}
	
	@RequestMapping("/findJsNoticeListBean")
	public @ResponseBody
	@AroundAspect(description="通知公告栏-分页查询通知列表")
	TreeGridView<BizNoticeInfoBean> findJsNoticeListBean(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "query",defaultValue = "") String query,
			@RequestParam(value = "queryPams", defaultValue = "") String queryPams,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder) {
		TreeGridView<BizNoticeInfoBean> treeGridview = new TreeGridView<BizNoticeInfoBean>();
		PageResult<BizNoticeInfoBean> pags = new PageResult<BizNoticeInfoBean>();
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			if(null != user){
				pags = noticeService.findAllNoticeListBean(pageNum, pageSize, query,sortName,sortOrder,queryPams,user);
				if(null != pags){
					treeGridview.setRows(pags.getResults());
					treeGridview.setTotal(pags.getTotalrecord());
				}
			}
			return treeGridview;
		} catch (Exception e) {
			logger.error("error",e);
			return null;
		}
	}

	/**
	 * 查看阅件信息
	 * 
	 * @param page
	 * @param rows
	 * @param query
	 * @return
	 */
	@RequestMapping("/findNoticeAllPeopleinfo")
	@AroundAspect(description="通知公告发布-查看阅件信息")
	public @ResponseBody
	TreeGridView<BizNoticePeopleEntity> findNoticeAllPeopleinfo(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "id") String id) {
		TreeGridView<BizNoticePeopleEntity> treeGridview = new TreeGridView<BizNoticePeopleEntity>();
		PageResult<BizNoticePeopleEntity> pags = new PageResult<BizNoticePeopleEntity>();
		try {
			pags = noticeService.findNoticeAllPeopleinfo(id);
			treeGridview.setRows(pags.getResults());
			treeGridview.setTotal(pags.getTotalrecord());
			return treeGridview;
		} catch (Exception e) {
			logger.error("error",e);
			return null;
		}
	}

	/**
	 * 删除
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/doDeleteNoticeById")
	@AroundAspect(description="通知公告发布-删除通知公告")
	public @ResponseBody
	String doDeleteNoticeById(@RequestParam(value = "ids") String id) {
		try {
			if (id != null && !"".equals(id)) {
				String[] ids = id.split(",");
				for (int i = 0; i < ids.length; i++) {
					noticeService.doDeleteNoticeById(ids[i]);
				}
			}
			return "true";
		} catch (Exception ex) {
			logger.error("error",ex);
			return "false";
		}
	}

	/**
	 * 桌面获取通知信息 备注：原方法名称（getNoticeData）
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "findNoticeData")
	@AroundAspect(description="桌面获取通知信息 ")
	public @ResponseBody
	List<BizNoticeInfoEntity> getNoticeData(HttpServletRequest request) {
		List<BizNoticeInfoEntity> list = null;
		PageResult<BizNoticeInfoEntity> pags = new PageResult<BizNoticeInfoEntity>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
				.getPrincipal();
		if(user != null){
			try {
				String num = request.getParameter("num");
				int count = AcoConstant.DESKCOUNT;
				if (!"".equals(num) && num != null) {
					count = Integer.parseInt(num);
				}
				String userid = user.getId();
				pags = noticeService.findNoticeData(1, count, userid, "", "");
				list = pags.getResults();
				if (list != null && !list.isEmpty()) {
					for (BizNoticeInfoEntity entity : list) {
						
						if(entity.getTitle() != null && entity.getTitle().length()>24) {
							entity.setTitle(entity.getTitle().substring(0,23)+"...." + "</TD>");
						}
					}
				}
			} catch (Exception e) {
				logger.error("error",e);
				return null;
			}
		}
		return list;
	}

	/**
	 * list页面的送交
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping("/doSaveNoticeAtList")
	@AroundAspect(description="通知公告发布-送交")
	public @ResponseBody
	String doSaveNoticeAtList(@RequestParam(value = "id") String id) {
		BizNoticeInfoEntity bean = noticeService.findNoticeInfoById(id);
		
		String senderid = null;
		String sceneid = null;
		if (bean != null) {
			bean.setStatus("1");
			noticeService.doSaveNoticeInfo(bean,request);
			
			senderid = bean.getSenderid();
			sceneid = bean.getSceneid();
		}
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			noticeService.doSaveRecePeople(senderid, sceneid, String.valueOf(id),user);
			return "1";
		}
		return "";
	}

	/*// 创建通知公告索引
	@RequestMapping("/createNoticeIndex")
	public @ResponseBody
	String createNoticeIndex() throws IOException {
		List<BizNoticeInfoEntity> list = noticeService
				.queryBizNoticeInfoEntity();
		String id = "";// id为唯一标识
		String title = "";
		String content = "";// 内容
		String sender = "";
		String scene = "";
		String lastModify = "";
		Logger logger = Logger.getLogger(this.getClass());
		int count = 1;
		// 通知公告设置为类型为1
		String type = "1";
		IndexWriter indexWriter = getIndexWriter(type);
		try {
			for (BizNoticeInfoEntity notice : list) {
				id = notice.getId();
				title = notice.getTitle();
				content = notice.getTextfield();
				sender = notice.getSender();
				scene = notice.getScene();
				String role = (scene == "" ? "" : scene) + "," + sender;
				logger.info("开始创建通知公告索引：总共 " + list.size() + " 条数据。");
				logger.info("标题：" + title + ",权限：" + role);
				lastModify = notice.getCreationtime();
				Document document = new Document();
				document.add(new StringField("type", type, Store.YES));
				document.add(new StringField("id", id, Store.YES));
				document.add(new StringField("role", role, Store.YES));
				// document.add(new StringField("scene", scene, Store.YES));
				document.add(new TextField("title", title, Store.YES));
				document.add(new TextField("content", content, Store.YES));
				document.add(new StringField("lastModify", lastModify,
						Store.YES));
				Term term = new Term("id", id);
				luceneService.addDocument(term, document, type, indexWriter);
				System.out.println("索引创建成功" + (count++));
			}
		} catch (Exception e) {
			logger.error("error",e);
			System.out.println("索引创建失败");
		} finally {
			indexWriter.close();
		}

		return "通知公告索引创建成功";
	}*/

	/**
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param fieldValue
	 * @return 通知公告检索
	 
	@RequestMapping("/searchNotice")
	public @ResponseBody
	TreeGridView<DocumentEntity> searchNotice(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "fieldValue") String fieldValue) {

		TreeGridView<DocumentEntity> treeGridview = new TreeGridView<DocumentEntity>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			String role = user.getName();
			try {
				fieldValue = new String(fieldValue.getBytes("ISO-8859-1"), "UTF-8");
				String[] fields = { "title", "content" };// 需要检索的字段
				String type = "1";// 通知公告的类型为1（每个模块对应的类型）
				Version version = Version.LUCENE_44;
				Analyzer analyzer = new StandardAnalyzer(version);
				boolean isrole = true;// 是否开启权限
				String[] roleFields = { "sender", "scene" };
				List<DocumentEntity> list = luceneService.searchIndex(fields,
						fieldValue, type, analyzer, isrole, role, roleFields);
				if (pageNum != 0) {
					pageNum = pageNum / pageSize;
				}
				pageNum++;
				treeGridview.setRows(list);
				treeGridview.setTotal(list.size());
			} catch (Exception e) {
				logger.error("error",e);
				return null;
			}
		}
		return treeGridview;
	}

	private IndexWriter getIndexWriter(String type) throws IOException {
		Directory directory = FSDirectory.open(new File(SystemConstant.basedir
				+ "luceneindex\\" + type));
		Version version = Version.LUCENE_44;
		Analyzer analyzer = new StandardAnalyzer(version);
		IndexWriterConfig indexWriterConfig = new IndexWriterConfig(version,
				analyzer);
		indexWriterConfig
				.setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
		IndexWriter indexWriter = new IndexWriter(directory, indexWriterConfig);
		return indexWriter;
	}*/
	/**
	 * 桌面获取通知信息 备注：原方法名称（getNoticeData）
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "findNoticeList")
	@AroundAspect(description="桌面获取通知信息")
	public @ResponseBody
	List<BizNoticeInfoEntity> findNoticeList(HttpServletRequest request) {
		List<BizNoticeInfoEntity> list = null;
		try {
			String num = request.getParameter("num");
			int count = AcoConstant.DESKCOUNT;
			if (!"".equals(num) && num != null) {
				count = Integer.parseInt(num);
			}
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			if(user!=null){
				String userid = user.getId();
				list=noticeService.findNoticeList(count, userid);
				if (list != null && !list.isEmpty()) {
					for (BizNoticeInfoEntity entity : list) {				
						if(entity.getTitle() != null && entity.getTitle().length()>10) {
							/*entity.setTitle(entity.getTitle().substring(0,9)+"..." + "</TD>");*/
							entity.setTitle(entity.getTitle());
						}
					}
				}
			}					
		} catch (Exception e) {
			logger.error("error",e);
			return null;
		}
		return list;
	}
	
	public String getParams(String queryPams) throws UnsupportedEncodingException{
		StringBuilder wheresql = new StringBuilder();
		queryPams = java.net.URLDecoder.decode(queryPams,"UTF-8");
		if(queryPams != null) {
			String[] paramsArr = queryPams.split("&");
			if(paramsArr != null && paramsArr.length > 0) {
				String[] keyValueArr;
				for (String keyValue : paramsArr) {
					keyValueArr = keyValue.split("=");
					if(keyValueArr.length == 2) {
						String key = keyValueArr[0];
						String value = keyValueArr[1];
						if(StringUtils.isNotBlank(key)&&StringUtils.isNotBlank(value)) {
							if("BIZ_TITLE_".equals(key)){
								wheresql.append(" AND title like '%" + value + "%'");
							}else if("URGENCY_".equals(key)){
								wheresql.append(" AND status = '" + value + "'");
							}else if("CREATE_TIME_START_".equals(key)){
								wheresql.append(" AND create_time >= '"+value+"'");
							}else if("CREATE_TIME_END_".equals(key)){
								wheresql.append(" AND create_time <= '"+value+"'");
							}else if("END_TIME_START_".equals(key)){
								wheresql.append(" AND END_TIME_ >= '"+value+"'");
							}else if("END_TIME_END_".equals(key)){
								wheresql.append(" AND END_TIME_ <= '"+value+"'");
							}else if("USER_NAME".equals(key)){
								wheresql.append(" AND sender like '%"+ value + "%'");
							}
						}
					}
				}
			}
		}
		return wheresql.toString();
	}
}