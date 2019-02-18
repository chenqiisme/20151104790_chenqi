package com.ideabobo.service;

import java.util.List;
import java.util.Map;

import com.ideabobo.model.Car;
import com.ideabobo.util.Page;

public interface CarService {
	public void save(Car model);
	public void update(Car model);
	public Car find(String uuid);
	public Car find(Car model);
	public void delete(Integer uuid);
	public List<Car> list();
	public List<Car> list(Car model);
	public List<Car> list(String hql);
	public Page findByPage(Page page,Map paramsMap);
}
