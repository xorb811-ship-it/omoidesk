<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ★ 중요: 이 줄이 없으면 숫자가 절대 안 나옵니다 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Diary Content</title>
    <%-- 폰트 로드 --%>
    <link href="https://fonts.googleapis.com/css2?family=Gaegu&family=Nanum+Pen+Script&display=swap" rel="stylesheet">

    <style>
        /* iframe 전용 스타일 */
        body {
            margin: 0; padding: 0;
            background-color: transparent;
            overflow-x: hidden;
            font-family: 'Gaegu', cursive;
        }

        .diary-container {
            display: flex;
            flex-direction: column;
            padding: 20px 25px 60px 75px; /* 왼쪽 세로줄 여백 확보 */
            gap: 20px;
            box-sizing: border-box;
        }

        /* 상단 년도/월 헤더 (가운데 정렬) */
        .calendar-header {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 40px;
            margin: 10px 0;
        }
        .cal-title {
            font-family: "Nanum Pen Script", cursive;
            font-size: 42px;
            color: #7a6b69;
            font-weight: bold;
        }
        .cal-btn { text-decoration: none; color: #f7cfcd; font-size: 30px; font-weight: bold; }

        /* 하얀색 둥근 카드 스타일 달력 (그림자 추가) */
        .calendar-wrap {
            background: white;
            padding: 25px;
            border-radius: 25px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05);
            border: 1px solid #fdf0ef;
        }

        .calendar-table { width: 100%; border-collapse: collapse; }
        .calendar-table th { padding: 15px 0; color: #9a8a7a; font-size: 14px; font-weight: normal; }
        .calendar-table td { height: 60px; text-align: center; border-top: 1px solid #fdf0ef; }

        .calendar-table td a {
            text-decoration: none;
            color: #5a4a3a;
            display: block;
            width: 100%;
            height: 100%;
            line-height: 60px;
            font-size: 20px;
        }

        /* 일요일/토요일 색상 강조 */
        .sun a { color: #ff8b8b !important; }
        .sat a { color: #8bb9ff !important; }

        /* 하단 일기 게시판 영역 */
        .diary-board {
            background: white;
            padding: 25px;
            border-radius: 25px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05);
            border: 1px dashed #f7cfcd;
            margin-top: 10px;
        }
        .board-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .board-header h3 {
            font-family: "Nanum Pen Script", cursive;
            font-size: 32px;
            color: #7a6b69;
            margin: 0;
        }

        .write-btn {
            padding: 8px 25px;
            background: #f7cfcd;
            border: none;
            border-radius: 25px;
            color: white;
            cursor: pointer;
            font-family: 'Gaegu';
            font-weight: bold;
            font-size: 18px;
        }

        .post-item {
            border: 1px solid #fdf0ef;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 10px;
        }

        /* 스크롤바 디자인 */
        body::-webkit-scrollbar { width: 6px; }
        body::-webkit-scrollbar-thumb { background: #f7cfcd; border-radius: 10px; }
    </style>
</head>
<body>

<div class="diary-container">
    <c:choose>
        <%-- [1] 글쓰기 화면 --%>
        <c:when test="${showMode == 'write'}">
            <div class="diary-board">
                <div class="board-header">
                    <h3>✍️ ${curYear}.${curMonth}.${selectedDay} 일기 쓰기</h3>
                    <button onclick="history.back()" class="write-btn">취소</button>
                </div>
                <form action="diary.write" method="post" style="display: flex; flex-direction: column; gap: 15px;">
                    <input type="hidden" name="d_year" value="${curYear}">
                    <input type="hidden" name="d_month" value="${curMonth}">
                    <input type="hidden" name="d_date" value="${selectedDay}">
                    <input name="d_title" placeholder="제목을 입력하세요" style="width:100%; padding:15px; border:none; border-bottom:2px solid #f7cfcd; font-family:'Gaegu'; font-size:22px; outline:none; box-sizing: border-box;">
                    <textarea name="d_txt" placeholder="내용을 입력하세요..." style="width:100%; height:250px; border:none; padding:15px; font-family:'Gaegu'; font-size:20px; outline:none; resize:none; box-sizing: border-box;"></textarea>
                    <div style="text-align:right;"><button class="write-btn">등록하기</button></div>
                </form>
            </div>
        </c:when>

        <%-- [2] 달력 및 목록 화면 --%>
        <c:otherwise>
            <div class="calendar-header">
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
                            <%-- 1일 시작 전 빈칸 --%>
                        <c:if test="${startDay > 1}">
                            <c:forEach var="i" begin="1" end="${startDay - 1}">
                                <td></td>
                            </c:forEach>
                        </c:if>

                            <%-- 날짜 숫자 반복문 --%>
                        <c:forEach var="d" begin="1" end="${lastDay}">
                        <td class="${(d + startDay - 1) % 7 == 1 ? 'sun' : ((d + startDay - 1) % 7 == 0 ? 'sat' : '')}">
                            <a href="diary?y=${curYear}&m=${curMonth}&d=${d}">${d}</a>
                        </td>
                            <%-- 토요일마다 줄바꿈 --%>
                        <c:if test="${(d + startDay - 1) % 7 == 0 && d < lastDay}">
                    </tr><tr>
                        </c:if>
                        </c:forEach>
                    </tr>
                    </tbody>
                </table>
            </div>

            <%-- 날짜를 눌렀을 때 나오는 일기 목록 --%>
            <c:if test="${showMode == 'list'}">
                <div class="diary-board">
                    <div class="board-header">
                        <h3>📅 ${selectedDay}일의 일기</h3>
                        <button onclick="location.href='diary?y=${curYear}&m=${curMonth}&d=${selectedDay}&mode=write'" class="write-btn">일기쓰기</button>
                    </div>
                    <c:forEach var="p" items="${posts}">
                        <div class="post-item">
                            <div style="display:flex; justify-content:space-between; border-bottom:1px dashed #eee; padding-bottom:10px; margin-bottom:10px;">
                                <span style="font-weight:bold; font-size:22px;">${p}</span>
                                <span style="font-size:14px; color:#bbb;">${curYear}.${curMonth}.${selectedDay}</span>
                            </div>
                            <div style="font-size:18px; color:#666;">오늘의 소중한 일기 내용이 여기에 출력됩니다.</div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>