<%@page import="model.member.MemberVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*, model.message.*" errorPage="error.jsp"%>

<% request.setCharacterEncoding("UTF-8"); %>  <%-- 한국어 인코딩 --%>  
<%-- 객체 생성과 setter매핑 --%>
<jsp:useBean id="messageDAO" class="model.message.MessageDAO"/> <%--  messageDAO 객체 생성 --%>    
<jsp:useBean id="messageVO" class="model.message.MessageVO"/>  <%--  messageVO 객체 생성 --%> 
<jsp:setProperty property="*" name="messageVO"/> <!-- messageVO의멤버변수setter 매핑 -->

<%
	String action = request.getParameter("action"); 
	String condition = request.getParameter("condition");
	String content = request.getParameter("content");
	
	System.out.println(action);  
	
	if(action.equals("list")){
		// list페이지에서 DB목록을 보여준다. 
		ArrayList<MessageVO> datas = messageDAO.getMsgList();
		request.setAttribute("datas", datas);
		pageContext.forward("message_list.jsp");
	}else if(action.equals("insert")){
		if(messageDAO.insertMsg(messageVO)){
			response.sendRedirect("message_control.jsp?action=list");
		}else{
			throw new Exception("!!! 데이터 추가 오류 발생 !!!");
		}		
	}else if(action.equals("edit")){
		//여기서 로그인 아이디 정보를 받아온다
		MemberVO mem = (MemberVO)session.getAttribute("mem");
		System.out.println("이거 확인해야함 : " + mem);
		
		if(request.getParameter("writer").equals("root")){ 
			MessageVO data = messageDAO.getMsgData(messageVO);
			request.setAttribute("data", data);
			pageContext.forward("message_edit.jsp");
		}else{
			out.println("<script>alert('해당게시물의 작성자가 아닙니다!');history.go(-1)</script>");
		}
	}else if(action.equals("delete")){
		// 해당 삭제 기능은 edit 페이지에서 일어난다.
		if(messageDAO.deleteMsg(messageVO)){
			response.sendRedirect("message_control.jsp?action=list");
		}else{
			throw new Exception("!!! 데이터 삭제 오류 발생 !!!");
		}
	}else if(action.equals("update")){
		// 해당 수정 기능은 edit 페이지에서 일어난다.
		if(messageDAO.updateMsg(messageVO)){
			response.sendRedirect("message_control.jsp?action=list");
		}else{
			throw new Exception("!!! 데이터 변경 오류 발생 !!!");
		}
	}else if(action.equals("search")){
		System.out.println(request.getParameter("condition"));
		System.out.println(request.getParameter("content"));
		ArrayList<MessageVO> datas = messageDAO.searchTitle(condition, content);
		request.setAttribute("datas", datas);
		pageContext.forward("message_list.jsp");
	}else{
		out.println("<script>alert('파라미터를 확인해주세요 ╯︿╰');history.go(-1)</script>");
	}


%>
 
