package com.yonyou.aco.cloudydisk.test;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class TableToEntity
{
  public static void main(String[] args) 
  {
    String schema = "cap-aco-test";
    String tableName = "cloud_authority_ref_user";
    try {
		createFields(schema, tableName);
	} catch (Exception e) {
		e.printStackTrace();
	}
  }
  
  public static void createFields(String schema, String tableName) throws Exception
  {
    String url = "jdbc:mysql://127.0.0.1:3306/cap-aco-test?useUnicode=true&characterEncoding=utf-8";
    String username = "root";
    String passwd = "root";
    String classDriver = "com.mysql.jdbc.Driver";
    Class.forName(classDriver);
    Connection connection = DriverManager.getConnection(url, username, 
      passwd);
    Statement statement = connection.createStatement();
    String sql = "select column_name,column_comment,column_key,is_nullable,data_type from information_schema.columns where table_schema =  '" + schema + "' and table_name='" + tableName + "'";
    ResultSet resultSet = statement.executeQuery(sql);
    
    List<java.util.HashMap<String, Object>> list = resultSetToList(resultSet);
    
    for (java.util.HashMap<String, Object> column : list) {
      System.out.println("/** " + column.get("COLUMN_COMMENT").toString() + 
        " */\nprivate String " + 
        getSName(column.get("COLUMN_NAME").toString()) + ";");
    }
  }
  
  private static String getSName(String columnName) {
    if ((columnName.charAt(columnName.length() - 1)+"").equals("_")) {
      return columnName;
    }
    String name = "";
    String[] str = columnName.split("_");
    for (int i = 0; i < str.length; i++) {
      if (i == 0) {
        name = name + str[i].toLowerCase();
      } else {
        name = 
          name + str[i].charAt(0) + str[i].substring(1).toLowerCase();
      }
    }
    return name;
  }
  
  @SuppressWarnings({ "unchecked", "rawtypes" })
private static List<java.util.HashMap<String, Object>> resultSetToList(ResultSet rs)
    throws SQLException
  {
    List<java.util.HashMap<String, Object>> list = new ArrayList();
    ResultSetMetaData md = rs.getMetaData();
    int columnCount = md.getColumnCount();
    while (rs.next()) {
      java.util.HashMap<String, Object> rowData = new java.util.HashMap();
      for (int i = 1; i <= columnCount; i++) {
        rowData.put(md.getColumnName(i), rs.getObject(i));
      }
      list.add(rowData);
    }
    return list;
  }
}

