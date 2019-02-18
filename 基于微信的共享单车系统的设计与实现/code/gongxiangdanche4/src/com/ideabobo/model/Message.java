package com.ideabobo.model;

/**
 * User entity. @author MyEclipse Persistence Tools
 */

public class Message implements java.io.Serializable {

	// Fields
    private Integer id;
    private String title;
    private String note;
    private String ndate;
    private String img;
    private String type;
    private String tid;
    private String username;
    private Long ts;
    private String statecn;
    
	public String getStatecn() {
		return statecn;
	}
	public void setStatecn(String statecn) {
		this.statecn = statecn;
	}
	public Long getTs() {
		return ts;
	}
	public void setTs(Long ts) {
		this.ts = ts;
	}
	public String getTid() {
		return tid;
	}
	public void setTid(String tid) {
		this.tid = tid;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getImg() {
		return img;
	}
	public void setImg(String img) {
		this.img = img;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getNdate() {
		return ndate;
	}
	public void setNdate(String ndate) {
		this.ndate = ndate;
	}

   
}