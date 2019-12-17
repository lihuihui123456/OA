package com.yonyou.aco.notice.service.Impl;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.lucene.entity.DbsSql;
import com.yonyou.aco.lucene.service.DbsIndexService;
import com.yonyou.aco.notice.dao.NoticeDao;
import com.yonyou.aco.notice.entity.BizNoticeInfoBean;
import com.yonyou.aco.notice.entity.BizNoticeInfoEntity;
import com.yonyou.aco.notice.entity.BizNoticePeopleEntity;
import com.yonyou.aco.notice.service.NoticeService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.adapter.IIscUserAdapter;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

@Repository("noticeService")
public class NoticeServiceImpl implements NoticeService{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource
	NoticeDao dao;
	@Resource
	IIscUserAdapter iiscUserAdapter;
	@Resource
	DbsIndexService dbsIndexService;

	@Override
	public PageResult<BizNoticeInfoBean> findAllNoticeList(int pageNum, int pageSize,String wheresql) {
		
		return dao.getPageData(BizNoticeInfoBean.class, pageNum, pageSize, wheresql);
	}

	@Override
	public String doSaveNoticeInfo(BizNoticeInfoEntity noticeInfo,HttpServletRequest request) {
		if("".equals(noticeInfo.getId())){
			noticeInfo.setId(null);
		}
		String id;
		try {
			if (noticeInfo.getId()==null) {
				dao.save(noticeInfo);
			}else{
				dao.update(noticeInfo);
			}
			id = noticeInfo.getId() + "";
			
			if ("1".equals(noticeInfo.getStatus())) {
				//创建索引
				DbsSql dbsql = new DbsSql();
				dbsql.setLuce_id(id);
				dbsql.setLuce_title(noticeInfo.getTitle());
				dbsql.setLuce_contents(noticeInfo.getTextfield());
				dbsql.setLuce_path("notice/editFindNoticeFsById?id="+id+"&type=open");
				dbsql.setLuce_time(noticeInfo.getCreationtime());
				dbsql.setIndex_type("1");
				dbsql.setLuce_annex(noticeInfo.getTableid());
				dbsql.setLuce_document("table_id");
				
				String ret = dbsIndexService.createDbsIndex(dbsql, request);
				System.out.println(ret);
			}
			
			return id;
		} catch (Exception e) {
			logger.error("error",e);
			return "保存失败";
		}
	}

	@Override
	public BizNoticePeopleEntity findCount(String id) {
		return dao.findCount(id);
	}

	@Override
	public BizNoticeInfoEntity findNoticeInfoById(String id) {
		return dao.findEntityByPK(BizNoticeInfoEntity.class, id);
	}

	@Override
	public BizNoticePeopleEntity queryPeopleById(String id, String uid) {
		return dao.queryPeopleById(id,uid);
	}

	@Override
	public void doSaveNoticePeopleInfo(BizNoticePeopleEntity bean) {
		dao.save(bean);
	}
	
	@Override
	public void doSaveRecePeople(String senderid, String sceneid, String id,ShiroUser user) {
	
		List<BizNoticePeopleEntity> list = new ArrayList<BizNoticePeopleEntity>();
		//BizNoticeInfoEntity bizNoticeInfo=dao.findEntityByPK(BizNoticeInfoEntity.class, id);
		try {
			String[] scene = sceneid.split(",");
			Date now = new Date();
			BizNoticePeopleEntity link ;
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//可以方便地修改日期格式
			String time = dateFormat.format( now ); 
			for (int i = 0; i < scene.length; i++) {
				link = new BizNoticePeopleEntity();
				link.setBid(id);
				link.setReceiveuid(scene[i]);
				link.setSenduid(senderid);
				link.setSendtime(time);
				link.setStatus("0");
				list.add(link);
				/**
				 * 消息提醒
				 */
				
				/**
				 * 创建索引
				 */
				//tzggIndexService.createDBSIndexById(bean);
				
				
				
				/**
				 * 消息推送
				 */
				/*UserAll findToUser = iiscUserAdapter.findUserById("",scene[i]);	*/
//				String senderPicUrl = iiscUserAdapter.findUserById("", user.getId()).getPicUrl();
//				String ofServiceName=PlatformConfigUtil.getString("MS_PUSH_SERVER_NAME");
//				MessageExtendBean ue = new MessageExtendBean();
//				ue.setSystemcodevalue("cap-aco");
//				ue.setSystemnoticeIDvalue(Identities.uuid2());
//				ue.setTypevalue("1");
//				ue.setPriorityvalue("1");
//				ue.setNoticefromvalue(findFromUser.getAcctLogin()+"@"+ofServiceName);
//				ue.setNoticetovalue(findToUser.getAcctLogin()+"@"+ofServiceName);
//				List<String> para = new ArrayList<String>();
//				ue.setPara(para);
//				ue.setOperationaction("send");
//				
//				Notice notice =new Notice();
//				notice.setNoticeId(bean.getId());
//				notice.setSender(bean.getSender());
//				notice.setTitle(bean.getTitle());
//				notice.setType("1");
//				notice.setSendTime(DateUtil.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));				
//				ue.setContentvalue(notice);
//				ue.setSendmodevalue("browser,phone");
//				ue.setSendtimevalue(DateUtil.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));
//	    		String serviceName=PlatformConfigUtil.getString("MS_PUSH_SERVER_NAME");
//	    		String serviceHost=PlatformConfigUtil.getString("MS_PUSH_SERVER_ADDRESS");
//	    		int servicePort=Integer.parseInt(PlatformConfigUtil.getString("MS_PUSH_SERVER_PORT"));
				
				//modify by hegd 20170329
	    		if(null != user){
	    			//SendMessageUtil.sendMessage(user.getLoginName(),"123",serviceName,serviceHost,servicePort,findToUser.getAcctLogin()+"@"+ofServiceName, ue); 
	    			//User receiveUser=dao.findEntityByPK(User.class, scene[i]);
	    			//SendMessageUtil.sendMessage(id, user.getLoginName(),receiveUser.getAcctLogin(),bizNoticeInfo.getTitle(), "1","notice/findJsNoticeById?id="+id+"&type=open","通知公告-查看","通知公告-查看"+id,user.getPicture());
	    		}
			}
			dao.saveEntitys(list);
			
		} catch (Exception e) {
			logger.error("error",e);
		}
	}

	@Override
	public PageResult<BizNoticeInfoEntity> findJsNoticeList(int pageNum, int pageSize,
			String userid, String query,String where) {
		return dao.findJsNoticeList(pageNum, pageSize,userid,query,where);
	}

	@Override
	public PageResult<BizNoticePeopleEntity> findNoticeAllPeopleinfo(String id) {
		return dao.findNoticeAllPeopleinfo(id);
	}

	@Override
	public void doDeleteNoticeById(String id) {
		dao.delete(BizNoticeInfoEntity.class, id);
	}

	@Override
	public List<BizNoticeInfoEntity> queryBizNoticeInfoEntity() {
		return dao.queryBizNoticeInfoEntity();
	}
	
	@Override
	public PageResult<BizNoticeInfoEntity> findUneadNoticeNoReadInfoByUserId(
			int pageNum, int pageSize, String userId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select bb.id_ id,bc.id_ bid,bb.title ,bb.sender,bb.create_time as creationtime,bc.status as status ");
		sb.append("from biz_notice_info bb LEFT JOIN biz_notice_people bc on bb.id_ = bc.bid ");
		sb.append("where bc.receive_uid =  '"+userId+"' and bc.status = '0' ");
		sb.append("order by bb.create_time desc");
		return dao.getPageData(BizNoticeInfoEntity.class, pageNum, pageSize,sb.toString());
	}
	@Override
	public PageResult<BizNoticeInfoEntity> findNoticeData(int pageNum, int pageSize,
			String userid, String query,String where) {
		return dao.findNoticeData(pageNum, pageSize,userid,query,where);
	}
	@Override
	public List<BizNoticeInfoEntity> findNoticeList(int num,String userid) {
		return dao.findNoticeList(num,userid);
	}

	@Override
	public PageResult<BizNoticeInfoBean> findAllNoticeList(int pageNum,
			int pageSize, String query, String sortName, String sortOrder,
			String queryPams, ShiroUser user) {
		StringBuffer sb = new StringBuffer();
		sb.append("select title,sender_id,sender,scene_id,scene,create_time,status,TENANT_ID,id_ from biz_notice_info");
		sb.append(" where 1=1 and sender_id = '" + user.getId() + "'");
		try {
			query = new String(query.getBytes("iso-8859-1"), "utf-8");
			sb.append(" and title like '%" + query.trim() + "%'");
			String wheresql = getParams(queryPams);
			if(wheresql != "" && wheresql != null){
				sb.append(wheresql);
			}
			if(StringUtils.isNotEmpty(sortName)){
				sb.append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
			}else{
				sb.append(" order by create_time desc");
			}
			return dao.getPageData(BizNoticeInfoBean.class, pageNum, pageSize, sb.toString());
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public PageResult<BizNoticeInfoBean> findAllNoticeListBean(int pageNum,
			int pageSize, String query, String sortName, String sortOrder,
			String queryPams, ShiroUser user) {
		try {
			query = new String(query.getBytes("iso-8859-1"), "utf-8");
			StringBuffer sb = new StringBuffer();
			sb.append("select bb.title,bb.sender_id,bb.sender,bb.scene_id,bb.scene,bb.create_time,bc.status,bb.TENANT_ID,bb.id_ from biz_notice_info");
			sb.append(" bb LEFT JOIN biz_notice_people bc on bb.id_ = bc.bid where 1=1 and bc.receive_uid = '" + user.getId() + "'");
			sb.append(" and bb.title like '%" + query.trim() + "%'");
			
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
									wheresql.append(" AND bb.title like '%" + value.trim() + "%'");
								}else if("URGENCY_".equals(key)){
									wheresql.append(" AND bc.status = '" + value + "'");
								}else if("CREATE_TIME_START_".equals(key)){
									wheresql.append(" AND bb.create_time >= '"+value+"'");
								}else if("CREATE_TIME_END_".equals(key)){
									wheresql.append(" AND bb.create_time <= '"+value+"'");
								}else if("USER_NAME".equals(key)){
									wheresql.append(" AND bb.sender like '%"+ value.trim() + "%'");
								}
							}
						}
					}
				}
			}
			sb.append(wheresql);
			if(StringUtils.isNotEmpty(sortName) && !sortName.equals("status")){
				sb.append(" ORDER BY CONVERT("+sortName+" USING gbk) "+sortOrder);
			}else if(StringUtils.isNotEmpty(sortName) && sortName.equals("status")){
				sb.append(" ORDER BY CONVERT( bc."+sortName+" USING gbk) "+sortOrder);
			}else if(StringUtils.isEmpty(sortName)){
				sb.append(" order by create_time desc");
			}
			return dao.getPageData(BizNoticeInfoBean.class, pageNum, pageSize, sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
			return null;
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
								wheresql.append(" AND title like '%" + value.trim() + "%'");
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
								wheresql.append(" AND sender like '%"+ value.trim() + "%'");
							}
						}
					}
				}
			}
		}
		return wheresql.toString();
	}
}