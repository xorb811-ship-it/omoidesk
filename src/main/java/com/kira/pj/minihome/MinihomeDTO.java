package com.kira.pj.minihome;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor


public class MinihomeDTO {
    private int h_id;
    private String u_pk; // u_id 대신 u_pk로 변경
    private String h_title;
    private int h_today;
    private int h_total;
    private String h_bgm;

    public MinihomeDTO() {
    }

    public int getH_id() {
        return h_id;
    }

    public void setH_id(int h_id) {
        this.h_id = h_id;
    }

    public String getU_pk() {
        return u_pk;
    }

    public void setU_pk(String u_pk) {
        this.u_pk = u_pk;
    }

    public String getH_title() {
        return h_title;
    }

    public void setH_title(String h_title) {
        this.h_title = h_title;
    }

    public int getH_today() {
        return h_today;
    }

    public void setH_today(int h_today) {
        this.h_today = h_today;
    }

    public int getH_total() {
        return h_total;
    }

    public void setH_total(int h_total) {
        this.h_total = h_total;
    }

    public String getH_bgm() {
        return h_bgm;
    }

    public void setH_bgm(String h_bgm) {
        this.h_bgm = h_bgm;
    }
}