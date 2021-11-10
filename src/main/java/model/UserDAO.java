package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
	
	public static final String USER_ALL = "select * from users";
	public static final String DELETE_USER= "delete from users where id= ?";
	public static final String INSERT_USER="insert into users(name,email,country) values (?,?,?)";
	public static final String USER_INFOR = "select * from users where id = ?";
	public static final String UPDATE_USER = "update users set name = ?, email = ?, country = ? where id = ?";
	

	
	public static boolean updateUser(UserBean user) {
		boolean flag = false;
		try {
			Connection conn = DBConnection.getMySQLConnection();
			PreparedStatement stmt = conn.prepareStatement(UPDATE_USER);
			stmt.setString(1, user.getName());
			stmt.setString(2, user.getEmail());
			stmt.setString(3, user.getCountry());
			stmt.setInt(4, user.getId());
			
			flag = stmt.executeUpdate() > 0;
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return flag;

	}
	public static UserBean inforUser(int id) {
		
		UserBean user = null;
		try {
			Connection conn = DBConnection.getMySQLConnection();
			PreparedStatement stmt = conn.prepareStatement(USER_INFOR);
			stmt.setInt(1, id);
			
			ResultSet rs = stmt.executeQuery();
			
			while(rs.next()) {
				String name = rs.getString("name");
				String email = rs.getString("email");
				String country = rs.getString("country");
				
				user = new UserBean(id,name,email,country);
			}
			
			
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return user ;		
	}
	
	public static boolean Delete(int id) {
		boolean flag = false;
		try {
			Connection conn= DBConnection.getMySQLConnection();
			PreparedStatement pstm= conn.prepareStatement(DELETE_USER);
			pstm.setInt(1, id);
			int nrow = pstm.executeUpdate();
			 flag = nrow > 0;
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return flag;
	}
	
	public static boolean insertUser(UserBean user) {
		boolean flag = false;
		
		try {
			Connection conn = DBConnection.getMySQLConnection();
			PreparedStatement prtm = conn.prepareStatement(INSERT_USER);
			prtm.setString(1,user.getName());
			prtm.setString(2, user.getEmail());
			prtm.setString(3, user.getCountry());
			
			flag = prtm.executeUpdate() > 0;
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		return flag;
		
	}
	
	public static List<UserBean> selectAllUser() {
		List<UserBean> users = new ArrayList<>();
		try {
			Connection conn = DBConnection.getMySQLConnection();
			
			PreparedStatement pstm= conn.prepareStatement(USER_ALL);
			ResultSet rs = pstm.executeQuery();
			
			while(rs.next()) {
				int id = rs.getInt("id");
				String name = rs.getString("name");
				String email = rs.getString("email");
				String country = rs.getString("country");
				users.add(new UserBean(id,name,email,country));
			}
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return users;
	}

}
