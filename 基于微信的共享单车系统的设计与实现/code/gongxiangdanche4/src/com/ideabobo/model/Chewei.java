package com.ideabobo.model;

/**
 * User entity. @author MyEclipse Persistence Tools
 */

public class Chewei implements java.io.Serializable {

	// Fields
    private Integer id;
    private String title;
    private String statecn;
    private Integer pid;
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
	public String getStatecn() {
		return statecn;
	}
	public void setStatecn(String statecn) {
		this.statecn = statecn;
	}
	public Integer getPid() {
		return pid;
	}
	public void setPid(Integer pid) {
		this.pid = pid;
	}
    
   
}