-- 1. 미니홈피 고유 번호용 시퀀스
CREATE SEQUENCE minihome_seq START WITH 1 INCREMENT BY 1;

-- 2. 미니홈피 테이블 생성 (userReg의 u_pk와 1:1 관계)
CREATE TABLE minihome (
                          h_id        NUMBER PRIMARY KEY,
                          u_pk        VARCHAR2(15 CHAR) NOT NULL UNIQUE,       -- 주인 PK (userReg의 U_PK 참조)
                          h_title     VARCHAR2(100 CHAR) DEFAULT '나만의 미니홈피에 오신 것을 환영합니다.',
                          h_today     NUMBER DEFAULT 0,
                          h_total     NUMBER DEFAULT 0,
                          h_bgm       VARCHAR2(100 CHAR),
                          CONSTRAINT fk_minihome_upk FOREIGN KEY (u_pk) REFERENCES userReg(u_pk) ON DELETE CASCADE
);

select * from minihome;