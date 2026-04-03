document.addEventListener("DOMContentLoaded", function () {
    // 1. 처음 켜졌을 때 메인 화면(main.jsp) 로드
    loadPage('main.jsp');

    // 2. 메뉴/탭 버튼 클릭 이벤트 등록
    document.querySelectorAll('.menu-item, .nb-tab').forEach(button => {
        button.addEventListener('click', function() {
            const targetUrl = this.getAttribute('data-src');

            // 클릭한 탭 색상 활성화
            document.querySelectorAll('.menu-item, .nb-tab').forEach(el => el.classList.remove('active'));

            // 왼쪽 메뉴와 상단 탭 모두 동기화 처리 (선택사항)
            const correspondingTabs = document.querySelectorAll(`[data-src="${targetUrl}"]`);
            correspondingTabs.forEach(el => el.classList.add('active'));

            loadPage(targetUrl);
        });
    });
});

// 화면 갈아끼우기 함수
function loadPage(url) {
    if (!url) return;

    fetch(url)
        .then(response => response.text())
        .then(htmlData => {
            // 가져온 jsp 껍데기를 도화지에 넣기
            document.getElementById('notebook-content').innerHTML = htmlData;

            // 방명록 껍데기가 깔렸으면 데이터를 씌우는 함수 실행!
            if (url.includes("board.jsp")) {
                loadGuestBoard();
            }
        })
        .catch(error => console.error("페이지 로드 실패:", error));
}