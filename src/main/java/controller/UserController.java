package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.UserBean;
import model.UserDAO;

@WebServlet(urlPatterns = {"/"})
public class UserController extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req,resp);
	}
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		String path= req.getServletPath();

		switch(path) {
		case "/edit":
			edit(req,resp);
			break;
		case "/delete":
			deleteUser(req,resp);
			break;
		case "/insert":
			insertUser(req,resp);
			break;
		case "/update":
			updateUser(req,resp);
			break;
		default:
			listUser(req, resp);
			break;
		}
	}

	private void updateUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub

		int id = Integer.valueOf(req.getParameter("id")) ;
		String name = req.getParameter("name");
		String email = req.getParameter("email");
		String country = req.getParameter("country");

		UserBean us = new UserBean(id, name, email, country);

		boolean boolUpdate = UserDAO.updateUser(us);


		String msg = "";

		RequestDispatcher rd;
		if(boolUpdate) {
			msg = "Cập nhật thành công";
			req.setAttribute("msg", msg);
			rd = req.getRequestDispatcher("/");
			rd.forward(req, resp);
		}else {
			msg = "Không cập nhật được";
			req.setAttribute("msg", msg);
			rd = req.getRequestDispatcher("/views/add.jsp");
			rd.forward(req, resp);
		}

	}
	private void edit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int id = Integer.valueOf(req.getParameter("id"));

		UserBean user = UserDAO.inforUser(id);

		RequestDispatcher rd;
		String msg = "";
		if(user == null) {
			msg = "Không tìm thấy";
			req.setAttribute("msg", msg);
			rd = req.getRequestDispatcher("/");
			rd.forward(req, resp);
		}else {

			req.setAttribute("inforUser", user);
			rd = req.getRequestDispatcher("/views/add.jsp");
			rd.forward(req, resp);
		}



	}
	private void insertUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub


		String name = req.getParameter("name");
		String email = req.getParameter("email");
		String country = req.getParameter("country");

		UserBean user = new UserBean();

		user.setName(name);
		user.setEmail(email);
		user.setCountry(country);

		boolean boolInsert = UserDAO.insertUser(user);

		String msg = "";

		RequestDispatcher rd;
		if(boolInsert) {
			msg = "Thêm thành công";
			req.setAttribute("msg", msg);
			rd = req.getRequestDispatcher("/");
			rd.forward(req, resp);
		}else {
			msg = "Không thêm được";
			req.setAttribute("msg", msg);
			rd = req.getRequestDispatcher("/views/add.jsp");
			rd.forward(req, resp);
		}


	}

	private void deleteUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int id = Integer.valueOf(req.getParameter("id"));
		UserBean us = new UserBean();
		us.setId(id);

		boolean boolDelete = UserDAO.Delete(us.getId());

		String msg = "";
		if(boolDelete) {
			msg= "Xóa thành công";
		}else {
			msg = "Không xóa được";
		}

		req.setAttribute("msg", msg);
		RequestDispatcher rd = req.getRequestDispatcher("/");
		rd.forward(req, resp);

	}

	private void listUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		List<UserBean> users = UserDAO.selectAllUser();

		req.setAttribute("listUsers", users);

		RequestDispatcher rd = req.getRequestDispatcher("/views/listUser.jsp");
		rd.forward(req, resp);

	}
}
