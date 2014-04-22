import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class WorkerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    //private static final Charset UTF_8 = Charset.forName("UTF-8");
    
    @Override
    protected void doPost(final HttpServletRequest request, final HttpServletResponse response) {
    	 
    }

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String queryType = req.getParameter("query");     //takes the query type from the URL
		String user_id = "";
		SqlAPI sqlAPI = new SqlAPI();						//instance of the SqlAPI class
		switch(queryType) {
			case "insertUser":
				user_id = req.getParameter("userid");
				String fname = req.getParameter("fname");
				String lname = req.getParameter("lname");
				String phone_no = req.getParameter("phone");
				sqlAPI.insertUser(user_id, fname, lname, phone_no);
				break;
			
			case "getBooksOfCourse":
				String course_no = req.getParameter("courseno");
				resp.getWriter().println(sqlAPI.getBooksOfCourse(course_no));
				break;
			
			case "getRentAndSellDetails":
				String isbn = req.getParameter("isbn");
				resp.getWriter().println(sqlAPI.getRentAndSellDetails(isbn));
				break;
				
			case "getMyAccount":
				user_id = req.getParameter("userid");
				resp.getWriter().println(sqlAPI.getMyAccount(user_id));
				break;
				
			case "getBooksOfUser":
				user_id = req.getParameter("userid");
				resp.getWriter().println(sqlAPI.getBooksOfUser(user_id));
				break;
		}
		
		
	}
    
    
    
}
