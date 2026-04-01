<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<form action="visitor" method="post" class="write-row" style="margin-bottom: 25px; border-bottom: 2px dashed #f2c0bd; padding-bottom: 20px;">
    <span style="font-family: 'Nanum Pen Script', cursive; font-size: 20px; color: #8a7a78;">🐾 닉네임: </span>
    <input type="text" name="visitorName" class="write-input" style="flex: 0.3; margin-right: 10px;" required />
    <input type="text" name="visitorMsg" class="write-input" placeholder="남길 메시지를 입력하세요!" required />
    <button type="submit" class="write-btn">기록</button>
</form>

<div class="posts">
    <c:choose>
        <c:when test="${empty visitorList}">
            <div class="post-item" style="text-align: center; color: #aaa09a;">
                아직 다녀간 사람이 없어요. 🐾
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="v" items="${visitorList}">
                <div class="post-item">
                    <div class="post-header">
                        <span class="post-user">${v.name}</span>
                        <span class="post-date">${v.visitTime}</span>
                    </div>
                    <div class="post-text">
                            ${v.message != null ? v.message : "방문했습니다! 😊"}
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>