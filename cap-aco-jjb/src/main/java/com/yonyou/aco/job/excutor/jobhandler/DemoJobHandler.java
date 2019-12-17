package com.yonyou.aco.job.excutor.jobhandler;

import com.xxl.job.core.handler.IJobHandler;
import com.xxl.job.core.handler.annotation.JobHander;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.sys.history.entity.SysSoftHist;
import com.yonyou.cap.sys.history.service.ISysSoftHistService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Date;

import javax.annotation.Resource;


/**
 * 任务Handler的一个Demo（Bean模式）
 * 
 * 开发步骤：
 * 1、继承 “IJobHandler” ；
 * 2、装配到Spring，例如加 “@Service” 注解；
 * 3、加 “@JobHander” 注解，注解value值为新增任务生成的JobKey的值;多个JobKey用逗号分割;
 * 
 * @author 王建坤
 * @since  2017-03-04
 */
@JobHander(value="demoJobHandler")
@Service
public class DemoJobHandler extends IJobHandler {
	private static transient Logger logger = LoggerFactory.getLogger(DemoJobHandler.class);
	@Resource
	private ISysSoftHistService histService;
	
	@Override
	public void execute(String... params) throws Exception {
		logger.info("CAP-ACO, Hello World.");
		SysSoftHist hist = new SysSoftHist();
		hist.setHistDate(DateUtil.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));
		hist.setHistDesc("测试任务调度");
		histService.doSaveSysSoftHist(hist);
	}
	
}
