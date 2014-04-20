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
		SqlAPI sqlAPI = new SqlAPI();						//instance of the SqlAPI class
		switch(queryType) {
			case "insertUser":
				String user_id = req.getParameter("userid");
				String phone_no = req.getParameter("phone");
				sqlAPI.insertUser(user_id, phone_no);
				break;
			
			case "getBooksOfCourse":
				String course_no = req.getParameter("courseno");
				resp.getWriter().println(sqlAPI.getBooksOfCourse(course_no));
				break;
				
		}
		
		
	}
    
    
    
}
