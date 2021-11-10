<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><tiles:getAsString name="title" /></title>
</head>
<style>




</style>

<body>

		<tiles:insertAttribute name="header" />

		<tiles:insertAttribute name="body" />
</body>

</html>