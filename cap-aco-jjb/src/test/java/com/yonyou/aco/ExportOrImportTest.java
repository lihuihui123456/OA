package com.yonyou.aco;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

import javax.annotation.Resource;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamReader;

import org.activiti.bpmn.converter.BpmnXMLConverter;
import org.activiti.bpmn.model.BpmnModel;
import org.activiti.editor.language.json.converter.BpmnJsonConverter;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.yonyou.cap.bpm.dao.IProcDefMgrDao;
import com.yonyou.cap.bpm.entity.ActGeBytearrayEntity;
import com.yonyou.cap.bpm.service.IProcDefMgrService;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:config/spring/spring-context.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = false)
@Transactional
public class ExportOrImportTest {

	@Resource
	RepositoryService repositoryService;
	@Resource
	RuntimeService runtimeService;
	@Resource
	TaskService taskService;
	@Resource
	IProcDefMgrService procDefMgrService;
	@Resource
	IProcDefMgrDao procDefMgrDao;

	@Test
	public void export() {
		String[] ids = {"c51e065c-d7aa-11e6-930b-1002b54e388d","f8c5bfcd-d7aa-11e6-930b-1002b54e388d"};
		byte[] byteBuffer = null;
		String filePath = "";
		ActGeBytearrayEntity temp = null;
		for (String id : ids) {
			temp = procDefMgrDao.findEntityByPK(ActGeBytearrayEntity.class, id);
			if(temp != null){
				byteBuffer = temp.getBytes_();
				if (temp.getName_().equalsIgnoreCase("source")) {
					filePath = "D:/1.bpmn20.xml";
				} else {
					filePath = "D:/1.png";
				}
				export(byteBuffer, filePath);
			}
		}
	}

	public void export(byte[] byteBuffer, String filePath) {
		try {
			File file = new File(filePath);
			if (file.exists()) {
				file.delete();
			}
			FileOutputStream fileout = new FileOutputStream(file);
			fileout.write(byteBuffer, 0, byteBuffer.length);
			fileout.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@SuppressWarnings("unused")
	@Test
	public void test2() throws Exception{  
        InputStream is = this.getClass().getClassLoader().getResourceAsStream("activiti/test.bpmn20.xml");    //获取xml文件流  
        XMLInputFactory xmlFactory  = XMLInputFactory.newInstance(); 
        XMLStreamReader reader = xmlFactory.createXMLStreamReader(is); 
        BpmnXMLConverter bpmnXMLConverter = new BpmnXMLConverter();
		BpmnModel bpmnModel = bpmnXMLConverter.convertToBpmnModel(reader);
	
		BpmnJsonConverter bpmnJsonConverter = new BpmnJsonConverter();
		ObjectNode json = bpmnJsonConverter.convertToJson(bpmnModel);
		byte[] bytes = json.toString().getBytes("utf-8");
		
		//repositoryService.addModelEditorSource("", bytes);
		System.out.println(json.toString());
    }
}
