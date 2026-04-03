/* 1. 일기 쓰기 폼 토글 (열기/닫기) */
function showWriteForm() {
    const form = document.getElementById('writeForm');
    if (!form) return; // 폼이 없으면 실행 안 함 (에러 방지)

    if (form.style.display === 'none' || form.style.display === '') {
        form.style.display = 'block';
    } else {
        form.style.display = 'none';
    }
}

/* 2. 년도/월 클릭 시 날짜 선택창 토글 */
function toggleDateSelector() {
    const s = document.getElementById('dateSelector');
    if (!s) return;

    if (s.style.display === 'none' || s.style.display === '') {
        s.style.display = 'block';
    } else {
        s.style.display = 'none';
    }
}

/* 3. 외부 클릭 시 열려있는 창 닫기 */
window.onclick = function(event) {
    const selector = document.getElementById('dateSelector');

    // 클릭한 대상이 '년도 제목'도 아니고 '선택창 내부'도 아니면 닫기
    if (selector && !event.target.matches('.cal-title') && !event.target.closest('.date-selector')) {
        selector.style.display = 'none';
    }
}