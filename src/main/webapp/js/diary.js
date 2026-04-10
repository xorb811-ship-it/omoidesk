/**
 * [1] 다이어리 내용을 비동기로 불러오는 핵심 함수
 */
function loadDiary(url = "diary", memberId = "") {
    // 1. URL 객체를 생성해서 파라미터를 정교하게 다룹니다.
    let targetUrl = new URL(url, window.location.origin + window.location.pathname);

    // 2. 만약 인자로 memberId를 직접 받았다면 (일촌 클릭 등) 우선 적용
    if (memberId) {
        targetUrl.searchParams.set("memberId", memberId);
    }
    // 3. 인자가 없다면 현재 화면(hidden input)에서 가져옴
    else {
        const currentOwner = document.getElementById("currentDiaryOwner")?.value;
        if (currentOwner && !targetUrl.searchParams.has("memberId")) {
            targetUrl.searchParams.set("memberId", currentOwner);
        }
    }

    // 4. 비동기/상태유지용 파라미터 추가
    targetUrl.searchParams.set("ajax", "true");

    console.log("📬 최종 요청 주소:", targetUrl.toString());

    fetch(targetUrl.toString())
        .then((response) => response.text())
        .then((html) => {
            const contentArea = document.getElementById("notebook-content");
            if (contentArea) {
                contentArea.innerHTML = html;

                // [성현님 요청] 스크롤 로직 유지
                if (targetUrl.searchParams.has("d")) {
                    setTimeout(() => {
                        const board = document.querySelector(".diary-board");
                        if (board) board.scrollIntoView({ behavior: "smooth", block: "start" });
                    }, 50);
                }
            }
        })
        .catch((error) => console.error("❌ 로드 실패:", error));
}

/**
 * [2] 일기 작성
 */
function submitDiaryForm() {
    const form = document.getElementById('diaryWriteForm');
    if (!form) return;
    const formData = new FormData(form);
    const params = new URLSearchParams(formData);

    fetch('diary-write', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: params
    })
        .then(response => response.text())
        .then(() => {
            loadDiary(`diary?y=${formData.get('d_year')}&m=${formData.get('d_month')}&d=${formData.get('d_date')}`);
        })
        .catch(error => console.error("일기 등록 실패:", error));
}

/**
 * [3] 일기 수정
 */
function updateDiaryForm() {
    const form = document.getElementById('diaryUpdateForm');
    if (!form) return;
    const formData = new FormData(form);
    const params = new URLSearchParams(formData);

    fetch('diary-update', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: params
    })
        .then(response => response.text())
        .then(() => {
            loadDiary(`diary-detail?no=${formData.get('no')}&y=${formData.get('d_year')}&m=${formData.get('d_month')}&d=${formData.get('d_date')}`);
        })
        .catch(error => console.error("일기 수정 실패:", error));
}

/**
 * [4] 댓글 등록
 */
function submitReply(no, y, m, d) {
    const form = document.getElementById('replyWriteForm');
    const input = form.querySelector('input[name="r_txt"]');
    if (!input.value.trim()) { alert("댓글 내용을 입력해주세요! 😊"); input.focus(); return; }
    const formData = new FormData(form);
    const params = new URLSearchParams(formData);

    fetch('diary-reply-write', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: params
    })
        .then(response => response.text())
        .then(() => {
            input.value = "";
            loadDiary(`diary-detail?no=${no}&y=${y}&m=${m}&d=${d}`);
        })
        .catch(error => console.error("댓글 등록 실패:", error));
}

/**
 * [5] 댓글 삭제
 */
function deleteReply(r_no, d_no, y, m, d) {
    if (!confirm("이 댓글을 정말 삭제할까요? 🗑️")) return;
    fetch(`diary-reply-delete?r_no=${r_no}`)
        .then(() => loadDiary(`diary-detail?no=${d_no}&y=${y}&m=${m}&d=${d}`))
        .catch(error => console.error("댓글 삭제 실패:", error));
}

// [보조 캘린더 로직]
let currentPickerYear = new Date().getFullYear();
function openQuickPicker(e) {
    e.stopPropagation();
    const picker = document.getElementById('quickDatePicker');
    if (picker) {
        picker.style.display = 'block';
        currentPickerYear = document.getElementById('quickYearSelect').value;
    }
}
function updateQuickYear(val) { currentPickerYear = val; }
function confirmQuickDate(month) {
    loadDiary(`diary?y=${currentPickerYear}&m=${month}`);
    const picker = document.getElementById('quickDatePicker');
    if (picker) picker.style.display = 'none';
}
window.addEventListener('click', function(e) {
    const picker = document.getElementById('quickDatePicker');
    const title = document.querySelector('.cal-title-click');
    if (picker && picker.style.display === 'block') {
        if (!picker.contains(e.target) && e.target !== title) {
            picker.style.display = 'none';
        }
    }
});