package com.yonyou.aco.job.excutor.jobhandler;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xxl.job.core.handler.IJobHandler;
import com.xxl.job.core.handler.annotation.JobHander;
import com.yonyou.cap.sys.lucene.service.ITimerService;


/**
 * 任务Handler的一个Demo（Bean模式）
 * 
 * 开发步骤：
 * 1、继承 “IJobHandler” ；
 * 2、装配到Spring，例如加 “@Service” 注解；
 * 3、加 “@JobHander” 注解，注解value值为新增任务生成的JobKey的值;多个JobKey用逗号分割;
 * 
 * @author xuxueli 2015-12-19 19:43:36
 */
@JobHander(value="jobLuceneIndexHandler")
@Service
public class JobLuceneIndexHandler extends IJobHandler {
	private static transient Logger logger = LoggerFactory.getLogger(JobLuceneIndexHandler.class);
	@Resource
	private ITimerService timerService;
	@Autowired
	private HttpServletRequest request;
	
	@Override
	public void execute(String... params) throws Exception {
		logger.info("*****开始创建数据索引******");
		timerService.jobLuncenIndexHander(request);
		logger.info("*****数据索引创建完成******");
	}
}