package com.kira.pj.diary;

import java.util.ArrayList;
import java.util.Calendar;
import javax.servlet.http.HttpServletRequest;

public class DiaryM {

    public static void getCalendar(HttpServletRequest req) {
        // 1. 기본값 세팅 (에러 방지용 초기화)
        Calendar cal = Calendar.getInstance();
        int curYear = cal.get(Calendar.YEAR);
        int curMonth = cal.get(Calendar.MONTH); // 0~11
        String showMode = "calendar";
        String selectedDay = "";
        ArrayList<String> posts = new ArrayList<>();

        try {
            // 2. 파라미터 받기
            String y = req.getParameter("y");
            String m = req.getParameter("m");
            String d = req.getParameter("d");
            String mode = req.getParameter("mode");

            // 3. 년/월 계산
            if (y != null && m != null) {
                curYear = Integer.parseInt(y);
                curMonth = Integer.parseInt(m) - 1;
            }
            cal.set(curYear, curMonth, 1);

            // Calendar가 자동 보정한 값을 다시 가져옴
            curYear = cal.get(Calendar.YEAR);
            curMonth = cal.get(Calendar.MONTH);

            int startDay = cal.get(Calendar.DAY_OF_WEEK);
            int lastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

            // 4. 모드 결정
            if ("write".equals(mode)) {
                showMode = "write";
                selectedDay = (d != null) ? d : "";
            } else if (d != null) {
                showMode = "list";
                selectedDay = d;
                posts.add(curYear + "년 " + (curMonth + 1) + "월 " + d + "일의 기록");
            }

            // 5. 모든 값을 request에 담기 (하나라도 빠지면 JSP에서 null 터짐)
            req.setAttribute("startDay", startDay);
            req.setAttribute("lastDay", lastDay);
            req.setAttribute("curYear", curYear);
            req.setAttribute("curMonth", curMonth + 1);
            req.setAttribute("selectedDay", selectedDay);
            req.setAttribute("showMode", showMode);
            req.setAttribute("posts", posts);

            // 화살표 링크용
            req.setAttribute("prevYear", (curMonth == 0) ? curYear - 1 : curYear);
            req.setAttribute("prevMonth", (curMonth == 0) ? 12 : curMonth);
            req.setAttribute("nextYear", (curMonth == 11) ? curYear + 1 : curYear);
            req.setAttribute("nextMonth", (curMonth == 11) ? 1 : curMonth + 2);

        } catch (Exception e) {
            e.printStackTrace();
            // 에러 발생 시 기본값이라도 나오게 세팅
            req.setAttribute("showMode", "calendar");
        }
    }
}