<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
<%@include file="/WEB-INF/assets/css/style.css"%>
</style>
</head>
<body>
	<div class="content">
		<h2 class="content__message"><%= request.getAttribute("msg") != null ? request.getAttribute("msg"): " " %></h2>
		<h2 class="content__title">List of Users</h2>
		<div class="content-list">
			<a href="/UserManagementApp/views/add.jsp" class="content-list__btn">Add new user</a>
			<table>
				<tr>
					<th>id</th>
					<th>Name</th>
					<th>Email</th>
					<th>Country</th>
					<th>Actions</th>
				</tr>
				<c:forEach var="row" items="${listUsers}">
					<tr>
						<td><c:out value="${row.id}" /></td>
						<td><c:out value="${row.name}" /></td>
						<td><c:out value="${row.email}" /></td>
						<td><c:out value="${row.country}" /></td>
						<td>
						<a class="content-list__link"
							href="edit?id=<c:out value="${row.id}" />">edit</a>
						<a class="content-list__link" href="delete?id=<c:out value="${row.id}" />">delete</a></td>
					</tr>

				</c:forEach>
				
			</table>
		</div>
	</div>
</body>
</html>