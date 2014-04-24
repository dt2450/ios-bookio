import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class WorkerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(final HttpServletRequest request, final HttpServletResponse response) {
    	 
    }

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String queryType = req.getParameter("query");     //takes the query type from the URL
		String user_id = "";
		String isbn = "";
		String course_no = "";
		SqlAPI sqlAPI = new SqlAPI();						//instance of the SqlAPI class
		switch(queryType) {
			case "insertUser":
				user_id = req.getParameter("userid");
				String fname = req.getParameter("fname");
				String lname = req.getParameter("lname");
				String phone_no = req.getParameter("phone");
				resp.getWriter().println(sqlAPI.insertUser(user_id, fname, lname, phone_no));
				break;
			
			case "updateUserPhone":
				user_id = req.getParameter("userid");
				String phone = req.getParameter("phone");
				sqlAPI.updateUserPhone(user_id, phone);
				break;
				
			case "getBooksOfCourse":
				course_no = req.getParameter("courseno");
				resp.getWriter().println(sqlAPI.getBooksOfCourse(course_no));
				break;
			
			case "getRentAndSellDetails":
				isbn = req.getParameter("isbn");
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
				
			case "insertBook":
				user_id = req.getParameter("userid");
				isbn = req.getParameter("isbn");
				String book_name = req.getParameter("bookname");
				String book_author = req.getParameter("bookauthor");
				course_no = req.getParameter("courseno");
				resp.getWriter().println(sqlAPI.insertBook(user_id, isbn, book_name, book_author, course_no));
				break;
				
			case "insertMyBook":
				user_id = req.getParameter("userid");
				isbn = req.getParameter("isbn");
				sqlAPI.insertMyBook(user_id, isbn);
				break;
				
			case "updateRent":
				user_id = req.getParameter("userid");
				isbn = req.getParameter("isbn");
				String rent = req.getParameter("rent");
				String rent_cost = "0";
				if(rent.equals("1")) {
					rent_cost = req.getParameter("cost");
				}
				sqlAPI.updateRent(user_id, isbn, rent, rent_cost);
				break;
				
			case "updateSell":
				user_id = req.getParameter("userid");
				isbn = req.getParameter("isbn");
				String sell = req.getParameter("sell");
				String sell_cost = "0";
				if(sell.equals("1")) {
					sell_cost = req.getParameter("cost");
				}				
				sqlAPI.updateSell(user_id, isbn, sell, sell_cost);
				break;
				
			case "deleteMyBook":
				user_id = req.getParameter("userid");
				isbn = req.getParameter("isbn");
				sqlAPI.deleteMyBook(user_id, isbn);
				break;
				
			case "getRentedFrom":
				user_id = req.getParameter("userid");
				resp.getWriter().println(sqlAPI.getRentedFrom(user_id));
				break;
				
			case "getRentedTo":
				user_id = req.getParameter("userid");
				resp.getWriter().println(sqlAPI.getRentedTo(user_id));
				break;
				
			case "deleteRent":
				user_id = req.getParameter("userid");
				isbn = req.getParameter("isbn");
				sqlAPI.deleteRent(user_id, isbn);
				break;
				
			case "insertRent":
				user_id = req.getParameter("userid");
				String to_user_id = req.getParameter("touserid");
				isbn = req.getParameter("isbn");
				sqlAPI.insertRent(user_id, to_user_id, isbn);
				break;
			
		}
		sqlAPI.close();
	}
        
}
