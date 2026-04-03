// 다이어리 페이지 로드 함수
function loadDiary(url = '/diary') {
    fetch(url)
        .then(response => response.text()) // HTML 조각을 받아옴
        .then(html => {
            const contentArea = document.getElementById('notebook-content');
            contentArea.innerHTML = html;

            // 로드 후 이벤트 리스너 재연결 (필요 시)
            // 예: 날짜 클릭 시 비동기로 다시 로드하게 만들기
            rebindDiaryEvents();
        })
        .catch(error => console.error("다이어리 로드 실패:", error));
}

// 달력 날짜나 화살표 클릭 시 페이지 이동 없이 비동기로 처리하기 위한 함수
function rebindDiaryEvents() {
    const contentArea = document.getElementById('notebook-content');

    // 모든 링크(화살표, 날짜)를 가로채서 fetch로 처리
    contentArea.querySelectorAll('a').forEach(anchor => {
        anchor.onclick = function(e) {
            const href = this.getAttribute('href');
            // 외부 링크가 아니고 내부 diary 관련 링크라면 비동기 처리
            if (href && href.startsWith('diary')) {
                e.preventDefault();
                loadDiary(href);
            }
        };
    });
}

// 글쓰기 폼 토글 (기존 로직 유지하되 contentArea 내에서 찾도록 수정)
function toggleDiaryWrite() {
    const form = document.querySelector('.write-full-container');
    // 비동기 방식에서는 단순 토글보다 서버에서 mode=write HTML을 받아오는게 깔끔함
}