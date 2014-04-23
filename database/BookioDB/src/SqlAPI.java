import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

public class SqlAPI {
	private Connection connect = null;
	private Statement statement = null;
	private ResultSet resultSet = null;
	private String DB_END_POINT = "bookio-mysql.cvxkuyzf5ndd.us-east-1.rds.amazonaws.com";
	private final String DB_USER_NAME = "BookioTeam";
	private final String DB_PWD = "cellularproject";
	private final String DB_NAME = "BookioDB";
	private final int DB_PORT = 3306;
	private String query = "";
	
	public SqlAPI() {
		createConnectionAndStatement();
	}
	
	private void createConnectionAndStatement() {
		try{
			// This will load the MySQL driver, each DB has its own driver
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			// Setup the connection with the DB
			connect = DriverManager
					.getConnection("jdbc:mysql://"+DB_END_POINT+":"+DB_PORT+"/"+DB_NAME,DB_USER_NAME,DB_PWD);

			// Statements allow to issue SQL queries to the database
			statement = connect.createStatement();
		} catch (Exception e) {
			e.printStackTrace();
			close();
		}
	}
	
	public void insertUser(String user_id, String fname, String lname, String phone_no) {
		query = "insert into User values (\"" + user_id + "\",\"" + fname + "\",\"" + lname + "\",\"" + phone_no + "\");";
		updateTable(query);
	}
	
	public void insertBook(String user_id, String isbn, String book_name,
			String book_author, String course_no) {
		query = "insert into Books values (" + isbn + ",\"" + book_name + "\",\"" + book_author + "\");";
		updateTable(query);
		query = "insert into CourseBooks values (\"" + course_no + "\"," + isbn + ");";
		updateTable(query);
		query = "insert into UserBooks values (\"" + user_id + "\"," + isbn + ",0,0,0,0);";
		updateTable(query);
		
	}

	public void insertMyBook(String user_id, String isbn) {
		query = "insert into UserBooks values (\"" + user_id + "\"," + isbn + ",0,0,0,0);";
		updateTable(query);
		
	}
	
	public void insertRent(String user_id, String to_user_id, String isbn) {
		query = "insert into Rented values (\"" + user_id + "\",\"" + to_user_id + "\"," + isbn + ");";
		updateTable(query);
	}
	
	public String getBooksOfCourse(String course_no) {
		query = "select ISBN,book_name,book_author from CourseBooks natural join Books where course_no=\"" + course_no + "\";";
		return getResults(query);
	}
	
	public String getRentAndSellDetails(String isbn) {
		query = "select user_id,rent,rent_cost,sell,sell_cost,user_phone from UserBooks natural join User where ISBN=" + isbn + ";";
		return getResults(query);
	}
	
	public String getMyAccount(String user_id) {
		query = "select user_fname,user_lname,user_phone from User where user_id=\"" + user_id + "\";";
		return getResults(query);
	}
	
	public String getBooksOfUser(String user_id) {
		query="select * from (select * from UserBooks where user_id=\"" + user_id + "\") AS temp1 natural join CourseBooks natural join Books natural join Courses;";
		return getResults(query);
	}
	
	public String getRentedFrom(String user_id) {
		query = "select from_user_id,book_name,ISBN from (select from_user_id,ISBN from Rented where to_user_id=\"" + user_id + "\") AS temp1 natural join Books;";
		return getResults(query);
	}
	
	public String getRentedTo(String user_id) {
		query = "select to_user_id,book_name,ISBN from (select to_user_id,ISBN from Rented where from_user_id=\"" + user_id + "\") AS temp1 natural join Books;";
		return getResults(query);
	}
	
	public void updateRent(String user_id, String isbn, String rent, String rent_cost) {
		query = "update UserBooks set rent=" + rent + ",rent_cost=" + rent_cost + " where user_id=\"" + user_id + "\" and ISBN=" + isbn + ";";
		updateTable(query);
	}

	public void updateSell(String user_id, String isbn, String sell, String sell_cost) {
		query = "update UserBooks set sell=" + sell + ",sell_cost=" + sell_cost + " where user_id=\"" + user_id + "\" and ISBN=" + isbn + ";";
		updateTable(query);
	}
	
	public void deleteMyBook(String user_id, String isbn) {
		query = "delete from UserBooks where user_id=\"" + user_id + "\" and ISBN=" + isbn + ";";
		updateTable(query);
	}
	
	public void deleteRent(String user_id, String isbn) {
		query = "delete from Rented where from_user_id=\"" + user_id + "\" and ISBN=" + isbn + ";";
		updateTable(query);
	}
	
	private String getResults(String query) {
		String result = "";
		try {
			resultSet = statement.executeQuery(query);			
			result = toJSON(resultSet);			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		close();
		return result;
		
	}
	
	private void updateTable(String query) {
		try {
			statement.executeUpdate(query);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}
	
	private String toJSON(ResultSet rs) throws SQLException {
		ResultSetMetaData rsmd = rs.getMetaData();
		int numCol = rsmd.getColumnCount();
		JSONObject results = new JSONObject();
		JSONArray result = new JSONArray();
		while(rs.next()) {
			JSONObject obj = new JSONObject();
			for(int i=1;i<=numCol;i++) {
				String column_name = rsmd.getColumnName(i);
				if (rsmd.getColumnType(i) == java.sql.Types.BIGINT) {
	                obj.put(column_name, rs.getLong(column_name));
	            } 
				else if (rsmd.getColumnType(i) == java.sql.Types.VARCHAR) {
	                obj.put(column_name, rs.getString(column_name));
	            }
				else if (rsmd.getColumnType(i) == java.sql.Types.BIT) {
	                obj.put(column_name, rs.getBoolean(column_name));
	            }
				else if (rsmd.getColumnType(i) == java.sql.Types.INTEGER) {
	                obj.put(column_name, rs.getInt(column_name));
	            }
			}
			result.add(obj);
		}
		results.put("results", result);
		return results.toString();
	}
	
	public void close() {
		try {
			if (resultSet != null) {
				resultSet.close();
			}

			if (statement != null) {
				statement.close();
			}

			if (connect != null) {
				connect.close();
			}
		} catch (Exception e) {

		}
	}

	

	

	
	
}
