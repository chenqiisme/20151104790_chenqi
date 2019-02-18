package com.ideabobo.service;

import java.util.List;
import java.util.Map;

import com.ideabobo.model.Park;
import com.ideabobo.util.Page;

public interface ParkService {
	public void save(Park model);
	public void update(Park model);
	public Park find(String uuid);
	public Park find(Park model);
	public List<Park> list(Park model);
	public void delete(Integer uuid);
	public List<Park> list();
	public Page findByPage(Page page,Map paramsMap);
}
