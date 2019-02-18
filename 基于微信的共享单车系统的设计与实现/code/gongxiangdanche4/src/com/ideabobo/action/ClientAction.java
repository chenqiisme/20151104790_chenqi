package com.ideabobo.action;


import java.util.ArrayList;
import java.util.Date;

import javax.annotation.Resource;
import javax.swing.*;

import org.springframework.stereotype.Controller;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.ideabobo.model.Chewei;
import com.ideabobo.model.Dingzuo;
import com.ideabobo.model.Park;
import com.ideabobo.model.Message;
import com.ideabobo.model.Replay;
import com.ideabobo.model.Type;
import com.ideabobo.model.Type2;
import com.ideabobo.model.User;
import com.ideabobo.service.BaseService;
import com.ideabobo.service.CheweiService;
import com.ideabobo.service.DingzuoService;
import com.ideabobo.service.ParkService;
import com.ideabobo.service.MessageService;
import com.ideabobo.service.ReplayService;
import com.ideabobo.service.TypeService;
import com.ideabobo.service.UserService;
import com.ideabobo.util.GetNowTime;
import com.ideabobo.util.IdeaAction;

@Controller
public class ClientAction extends IdeaAction {

    @Resource
    private ParkService parkService;

    @Resource
    private CheweiService cheweiService;
    @Resource
    private TypeService typeService;
    @Resource
    private DingzuoService dingzuoService;
    @Resource
    private BaseService baseService;
    @Resource
    private UserService userService;

    @Resource
    private ReplayService replayService;
    @Resource
    private MessageService messageService;
    public Gson gson = new Gson();
    private static final long serialVersionUID = -3218238026025256103L;

    public String wehall(){
//		String openid = request.getParameter("openid");
//		session.put("openid", openid);
        return SUCCESS;
    }

    public void login(){
        String username = request.getParameter("username");
        String passwd = request.getParameter("passwd");
        User user = new User();
        user.setPasswd(passwd);
        user.setUsername(encodeGet(username));
        User r = userService.find(user);
        if(r!=null){
            renderJsonpObj(r);
        }else{
            renderJsonpString("fail");
        }
    }

    public void checkUser(){
        User u = new User();
        String username = request.getParameter("username");
        u.setUsername(username);
        User r = userService.find(u);
        if(r!=null){
            renderJsonpString("fail");
        }else{
            renderJsonpString("success");
        }
    }
    
    public void updateMyLocation(){
        String id = request.getParameter("id");
        String address = request.getParameter("address");
        User u = userService.find(id);
        if(u!=null){
            u.setAddress(encodeGet(address));
            userService.update(u);
            renderJsonpString("success");
        }else{
        	renderJsonpString("fail");
        }
    }

    public void updateUser(){
        String tel = request.getParameter("tel");
        String qq = request.getParameter("qq");
        String wechat = request.getParameter("wechat");
        String email = request.getParameter("email");
        String birth = request.getParameter("birth");
        String sex = request.getParameter("sex");
        String id = request.getParameter("id");
        String img = request.getParameter("img");
        

        User user = userService.find(id);
        if(img!=null && !img.equals("")){
        	user.setImg(img);
        }
        user.setId(Integer.parseInt(id));
        user.setTel(tel);
        user.setWechat(encodeGet(wechat));
        user.setQq(qq);
        user.setEmail(email);
        user.setBirth(birth);
        user.setSex(encodeGet(sex));

        userService.update(user);
        renderJsonpString("success");
    }

    public void changePasswd(){
        String passwd = request.getParameter("passwd");
        String id = request.getParameter("id");
        User user = userService.find(id);
        user.setPasswd(passwd);
        userService.update(user);
        renderJsonpString("success");
    }

    public void register(){
    	User user = (User) getByRequest(new User(), true);
        String roletype = "2";
        user.setRoletype(roletype);

        userService.save(user);

        renderJsonpString("success");
    }


    public void listPark(){
        String type = request.getParameter("stype");
        String sid = request.getParameter("sid");
        Park g = new Park();
        if (type != null&& !"".equals(type)) {
            g.setTypeid(type);

        }
        if(sid != null&& !"".equals(sid)){
            g.setSid(sid);
        }
        renderJsonpObj(parkService.list(g));
    }

    public void listType(){
        renderJsonpObj(typeService.list());
    }

    

   

  
    

    public void deletePark(){
        String id = request.getParameter("id");
        parkService.delete(Integer.parseInt(id));
        renderJsonpString("success");
    }

    


    public void listReplay(){
    	String pid = request.getParameter("pid");
    	Replay r = new Replay();
    	r.setPid(pid);
        renderJsonpObj(replayService.list(r));
    }

    public void addReplay(){
    	String uid = request.getParameter("uid");
    	String pid = request.getParameter("pid");
    	String note = encodeGet(request.getParameter("note"));
    	String username = encodeGet(request.getParameter("username"));
    	String ndate = GetNowTime.getNowTimeEn();
    	Replay m = new Replay();
    	m.setUid(uid);
    	m.setPid(pid);
    	m.setUsername(username);
    	m.setNote(note);
    	m.setNdate(ndate);
    	replayService.save(m);
    	renderJsonpString("success");
    }
    
    public void getMessage(){
    	String startTime = request.getParameter("startTime");
    	Date date = new Date();       
		long time = date.getTime();
		long st = time-86400000;
		String hql = "from Message";
    	if(startTime!=null && !startTime.equals("")){
    		long tst = Long.parseLong(startTime);
    		long cha = time-tst;
    		if(cha<86400000){
    			st = Long.parseLong(startTime);
    		}  
    	}
    	hql="from Message m where m.ts>"+st;	
    	ArrayList<Message> list = (ArrayList<Message>) messageService.list(hql+" order by ts desc");
    	renderJsonpObj(list);
    }
    
    public void yuyue(){
    	Dingzuo d = new Dingzuo();
    	d.setUsername(encodeGet(request.getParameter("username")));
    	d.setTodate(GetNowTime.getNowTimeEn());
    	d.setShijian(request.getParameter("shijian"));
    	d.setShouji(request.getParameter("tel"));
    	d.setShopname(encodeGet(request.getParameter("gname")));
    	d.setBeizhu("已预约");
    	String chewei = request.getParameter("chewei");
    	Chewei cw = (Chewei) baseService.find(Integer.parseInt(chewei), Chewei.class);
    	cw.setStatecn("已占用");
    	baseService.update(cw);
    	dingzuoService.save(d);
    	jianqian();
    	renderJsonpString(d.getId()+"");
    }
    
    public void jianqian(){
    	String idstr = request.getParameter("uid");
    	User user = userService.find(idstr);
    	if(user!=null){
    		if(user.getMoney()!=null){
    			int money = user.getMoney()-5;
    			user.setMoney(money);
    			userService.update(user);
    		}
    	}
    }
    
    public void daoda(){
    	String timeshift = request.getParameter("arrivetime");
    	String id = request.getParameter("id");
    	Dingzuo d = dingzuoService.find(id);
    	d.setBeizhu("已到达");
    	d.setRenshu(timeshift);
    	dingzuoService.update(d);
    	renderJsonpString("success");
    }
    
    public void left(){
    	String id = request.getParameter("id");
    	Dingzuo d = dingzuoService.find(id);
    	d.setBeizhu("已离开");
    	d.setOpenid("15");
    	dingzuoService.update(d);
    	renderJsonpString("success");
    }
    
    public void listChewei(){
    	String pid = request.getParameter("pid");
    	renderJsonpObj(baseService.list("from Chewei t where t.pid="+pid+" and t.statecn='空闲中'"));
    }
    
    public void payBillMoney(){
    	String money = request.getParameter("money");
    	String uid = request.getParameter("uid");
    	User u = userService.find(uid);
    	if(u!=null){
    		Integer mm = u.getMoney();
    		Integer moneyi = Integer.parseInt(money);
    		if(mm==null || mm<moneyi){
    			renderJsonpString("-1");
    		}else{
    			mm = mm-moneyi;
        		u.setMoney(mm);
        		userService.update(u);
        		renderJsonpObj(u);
    		}
    		
    	}else{
    		renderJsonpString("-1");
    	}
    	
    }
    
    public void jiaoyajin(){
    	
    	String uid = request.getParameter("uid");
    	User u = userService.find(uid);
    	if(u!=null){
    		Integer mm = u.getMoney();
    		Integer moneyi = 299;
    		if(mm==null || mm<moneyi){
    			renderJsonpString("-1");
    		}else{
    			mm = mm-moneyi;
        		u.setMoney(mm);
        		u.setIsyajin("是");
        		userService.update(u);
        		renderJsonpObj(u);
    		}
    		
    	}else{
    		renderJsonpString("-1");
    	}
    }
    
    public void cheweiState(){
    	String id = request.getParameter("id");
    	Chewei chewei = cheweiService.find(id);
    	chewei.setStatecn(encodeGet(request.getParameter("statecn")));
    	cheweiService.update(chewei);
    	renderJsonpString("success");
    }
    
    public void savePark(){
    	Park p = (Park) getByRequest(new Park(), true);
    	baseService.save(p);
    	Chewei cw = new Chewei();
    	cw.setPid(p.getId());
    	cw.setStatecn("空闲中");
    	cw.setTitle("001");
    	baseService.save(cw);
    	renderJsonpString("0");
    }
    
    
    public void zan(){
    	String id = request.getParameter("id");
    	Type g = (Type) baseService.find(Integer.parseInt(id), Type.class);
    	Integer zan = g.getZan();
    	if(zan!=null){
    		zan++;
    	}else{
    		zan = 1;
    	}
    	g.setZan(zan);
    	baseService.update(g);
    	renderJsonpString(zan+"");
    }
    
    public void zan2(){
    	String id = request.getParameter("id");
    	Type2 g = (Type2) baseService.find(Integer.parseInt(id), Type2.class);
    	Integer zan = g.getZan();
    	if(zan!=null){
    		zan++;
    	}else{
    		zan = 1;
    	}
    	g.setZan(zan);
    	baseService.update(g);
    	renderJsonpString(zan+"");
    }
    
    public void listType2(){
    	renderJsonpObj(baseService.list("from Type2"));
    }
    
    public void listNotice(){
    	renderJsonpObj(baseService.list("from Notice"));
    }
    
    public void getPark(){
    	String id = request.getParameter("id");
    	Park p = (Park) baseService.find(Integer.parseInt(id), Park.class);
    	renderJsonpObj(p);
    }
    
    public void charge(){
		String idstr = request.getParameter("id");
		User user = userService.find(idstr);
		Integer money = user.getMoney();
		String mo = request.getParameter("money");
		if(money!=null){
			money = money+Integer.parseInt(mo);
			user.setMoney(money);
		}else{
			user.setMoney(Integer.parseInt(mo));
		}
		userService.update(user);
		renderJsonpObj(user);
	}
}
