<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 이 파일은 index.jsp의 #notebook-content 안에 삽입될 HTML 조각입니다. --%>
<div class="diary-container">
    <c:choose>
        <%-- [A] 글쓰기 모드 --%>
        <c:when test="${showMode == 'write'}">
            <div class="write-full-container">
                <div class="board-header">
                    <h3>✍️ ${curYear}.${curMonth}.${selectedDay} 일기 쓰기</h3>
                        <%-- 취소 버튼도 비동기 로드로 변경 --%>
                    <button onclick="loadDiary('diary?y=${curYear}&m=${curMonth}&d=${selectedDay}')" class="write-btn">취소</button>
                </div>

                    <%-- 폼 전송도 비동기로 할 수 있지만, 우선은 action 그대로 유지 --%>
                <form action="diary.write" method="post" class="write-form-full">
                    <input type="hidden" name="d_year" value="${curYear}">
                    <input type="hidden" name="d_month" value="${curMonth}">
                    <input type="hidden" name="d_date" value="${selectedDay}">

                    <input name="d_title" placeholder="제목을 입력하세요" class="write-input-title" required>
                    <textarea id="editor" name="d_txt" class="write-input-content" placeholder="내용을 입력하세요..." required></textarea>

                    <div class="write-footer">
                        <button type="submit" class="write-btn">등록하기</button>
                    </div>
                </form>
            </div>
        </c:when>

        <%-- [B] 달력 및 목록 --%>
        <c:otherwise>
            <div class="calendar-header">
                    <%-- href를 유지하되 js에서 가로챔 --%>
                <a href="diary?y=${prevYear}&m=${prevMonth}" class="cal-btn">◀</a>
                <span class="cal-title">${curYear}. ${curMonth < 10 ? '0' : ''}${curMonth}</span>
                <a href="diary?y=${nextYear}&m=${nextMonth}" class="cal-btn">▶</a>
            </div>

            <div class="calendar-wrap">
                <table class="calendar-table">
                    <thead>
                    <tr><th class="sun">SUN</th><th>MON</th><th>TUE</th><th>WED</th><th>THU</th><th>FRI</th><th class="sat">SAT</th></tr>
                    </thead>
                    <tbody>
                    <tr>
                        <c:if test="${startDay > 1}">
                            <c:forEach var="i" begin="1" end="${startDay - 1}"><td></td></c:forEach>
                        </c:if>
                        <c:forEach var="d" begin="1" end="${lastDay}">
                        <td class="${(d + startDay - 1) % 7 == 1 ? 'sun' : ((d + startDay - 1) % 7 == 0 ? 'sat' : '')}">
                            <a href="diary?y=${curYear}&m=${curMonth}&d=${d}">${d}</a>
                        </td>
                        <c:if test="${(d + startDay - 1) % 7 == 0 && d < lastDay}"></tr><tr></c:if>
                        </c:forEach>
                    </tr>
                    </tbody>
                </table>
            </div>

            <c:if test="${showMode == 'list'}">
                <hr class="diary-hr">
                <div class="diary-board">
                    <div class="board-header">
                        <h3>📅 ${selectedDay}일의 일기</h3>
                            <%-- 일기쓰기 버튼도 비동기로 요청 --%>
                        <button onclick="loadDiary('diary?y=${curYear}&m=${curMonth}&d=${selectedDay}&mode=write')" class="write-btn">일기쓰기</button>
                    </div>
                    <div class="posts">
                        <c:forEach var="p" items="${posts}">
                            <div class="post-item">
                                <div class="post-header">
                                    <span class="post-user">${p}</span>
                                    <span class="post-date">${curYear}.${curMonth}.${selectedDay}</span>
                                </div>
                                <div class="post-text">여기에 일기 본문이 들어갑니다.</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>