package com.ideabobo.service;

import java.util.List;
import java.util.Map;

import com.ideabobo.model.Chewei;
import com.ideabobo.util.Page;

public interface CheweiService {
	public void save(Chewei model);
	public void update(Chewei model);
	public Chewei find(String uuid);
	public Chewei find(Chewei model);
	public void delete(Integer uuid);
	public List<Chewei> list();
	public List<Chewei> list(Chewei model);
	public List<Chewei> list(String hql);
	public Page findByPage(Page page,Map paramsMap);
}
