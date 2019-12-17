package com.yonyou.aco.operatelog.aspect;

import java.lang.reflect.Method;
import java.util.Date;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.SecurityUtils;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

import com.yonyou.cap.common.audit.operatelog.annotation.AfterAspect;
import com.yonyou.cap.common.audit.operatelog.annotation.AroundAspect;
import com.yonyou.cap.common.audit.operatelog.annotation.BeforeAspect;
import com.yonyou.cap.common.audit.opertaudit.entity.OperateLog;
import com.yonyou.cap.common.audit.opertaudit.service.IOperateLogService;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

@Aspect
@Component
public class SystemLogAspect {
	
	public static final String BEFORE_ASPECT = "beforeAspect";
	public static final String AFTER_ASPECT = "afterAspect";
	public static final String AROUND_ASPECT = "aroundAspect";
	
	@Resource
	private IOperateLogService operateLogService;
	@Resource
	private HttpServletRequest request;
	
	/** 
	 * 前置切点  
	 * */
	@Pointcut("@annotation(com.yonyou.cap.common.audit.operatelog.annotation.BeforeAspect)")
	public void beforeAspect(){
		
	}
	
	/** 
	 * 后置切点  
	 * */
	@Pointcut("@annotation(com.yonyou.cap.common.audit.operatelog.annotation.AfterAspect)")
	public void afterAspect(){
		
	}
	
	/** 
	 * 环绕切点  
	 * */
	@Pointcut("@annotation(com.yonyou.cap.common.audit.operatelog.annotation.AroundAspect)")
	public void aroundAspect(){
		
	}
	
	/**
	 * 前置通知（方法执行前执行），拦截用户的操作
	 * 
	 * @author wangjiankun
	 * @since 2017-06-06
	 * @param point 切点
	 * @return 
	 * @throws Exception 
	 * */
	@Before("beforeAspect()")
	public void doBefore(JoinPoint point) throws Exception{
		ShiroUser shiroUser = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		String ip = SecurityUtils.getSubject().getSession().getHost();
		OperateLog log = new OperateLog();
		log.setUserId(shiroUser.getId());
		log.setAcctLogin(shiroUser.getLoginName());
		log.setUserName(shiroUser.getName());
		log.setDeptCode(shiroUser.getDeptCode());
		log.setOrgCode(shiroUser.getOrgid());
		log.setIp(ip);
		log.setUrl(request.getRequestURL().toString());
		log.setOperation(getMethodDescription(point,BEFORE_ASPECT));
		log.setOperateTime(DateUtil.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));
		log.setDr("N");
		operateLogService.doSaveOperateLog(log);
//		System.out.println("======前置通知开始======");
//		System.out.println("请求方法名："+point.getTarget().getClass().getName()+"."+point.getSignature().getName()+"()");
//		System.out.println("请求人："+shiroUser.getName());
//		System.out.println("方法描述："+getMethodDescription(point,BEFORE_ASPECT));
	}
	
	/**
	 * 后置通知（方法执行成功后执行），拦截用户的操作
	 * 
	 * @author wangjiankun
	 * @since 2017-06-08
	 * @param point 切点
	 * @return 
	 * @throws Exception 
	 * */
	@AfterReturning("afterAspect()")
	public void doAfter(JoinPoint point) throws Exception{
		ShiroUser shiroUser = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		String ip = SecurityUtils.getSubject().getSession().getHost();
		OperateLog log = new OperateLog();
		log.setUserId(shiroUser.getId());
		log.setAcctLogin(shiroUser.getLoginName());
		log.setUserName(shiroUser.getName());
		log.setDeptCode(shiroUser.getDeptCode());
		log.setOrgCode(shiroUser.getOrgid());
		log.setIp(ip);
		log.setUrl(request.getRequestURL().toString());
		log.setOperation(getMethodDescription(point,AFTER_ASPECT));
		log.setOperateTime(DateUtil.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));
		log.setDr("N");
		operateLogService.doSaveOperateLog(log);
//		System.out.println("======后置通知开始======");
//		System.out.println("请求方法名："+point.getTarget().getClass().getName()+"."+point.getSignature().getName()+"()");
//		System.out.println("请求人："+shiroUser.getName());
//		System.out.println("方法描述："+getMethodDescription(point,AFTER_ASPECT));
	}
	
	/**
	 * 环绕通知（方法执行前后执行），拦截用户的操作
	 * 
	 * @author wangjiankun
	 * @since 2017-06-08
	 * @param point 切点
	 * @return 
	 * @throws Throwable 
	 * */
	@Around("aroundAspect()")
	public Object doAround(ProceedingJoinPoint point) throws Throwable{
		long startTime = System.currentTimeMillis();
		Object result = point.proceed();
		long endTime = System.currentTimeMillis();
		String timeConsuming = String.valueOf((float)(endTime-startTime)/1000);
		ShiroUser shiroUser = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		String ip = SecurityUtils.getSubject().getSession().getHost();
		OperateLog log = new OperateLog();
		log.setUserId(shiroUser.getId());
		log.setAcctLogin(shiroUser.getLoginName());
		log.setUserName(shiroUser.getName());
		log.setDeptCode(shiroUser.getDeptCode());
		log.setOrgCode(shiroUser.getOrgid());
		log.setIp(ip);
		log.setUrl(request.getRequestURL().toString());
		log.setOperation(getMethodDescription(point,AROUND_ASPECT));
		log.setOperateTime(DateUtil.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));
		log.setTimeConsuming(timeConsuming);
		log.setDr("N");
		operateLogService.doSaveOperateLog(log);
//		System.out.println("请求方法名："+point.getTarget().getClass().getName()+"."+point.getSignature().getName()+"()");
//		System.out.println("请求人："+shiroUser.getName());
//		System.out.println("方法描述："+getMethodDescription(point,AROUND_ASPECT));
		return result;
	}
	
	/**
	 * 获取注解中对方法的描述信息
	 * 
	 * @author wangjiankun
	 * @since 2017-06-06
	 * @param point 切点
	 * @return description 方法描述
	 * @throws Exception
	 * */
	public static String getMethodDescription(JoinPoint point,String aspectName) throws Exception{
		String targetName = point.getTarget().getClass().getName();
		String methodName = point.getSignature().getName();
		Object[] args = point.getArgs();
		Class targetClass = Class.forName(targetName);
		Method[] methods = targetClass.getMethods();
		String description = "";
		for (Method method : methods) {
			if (method.getName().equals(methodName)) {
				Class[] clazzs = method.getParameterTypes();
				if (clazzs.length == args.length) {
					switch (aspectName) {
						case BEFORE_ASPECT:
							description = method.getAnnotation(BeforeAspect.class).description();
							break;
						case AFTER_ASPECT:
							description = method.getAnnotation(AfterAspect.class).description();
							break;
						case AROUND_ASPECT:
							description = method.getAnnotation(AroundAspect.class).description();
							break;
					}
					break;
				}
			}
		}
		return description;
	}
}
