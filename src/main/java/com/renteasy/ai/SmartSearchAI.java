package com.renteasy.ai;

import java.util.HashMap;
import java.util.Map;

public class SmartSearchAI {

    public static Map<String,String> parse(String text){

        Map<String,String> map = new HashMap<>();

        text = text.toLowerCase();

        if(text.contains("chair"))
            map.put("product","chair");

        if(text.contains("laptop"))
            map.put("product","laptop");

        if(text.contains("phone"))
            map.put("product","phone");

        if(text.contains("camera"))
            map.put("product","camera");

        if(text.contains("cycle"))
            map.put("product","cycle");

        if(text.contains("table"))
            map.put("product","table");

        if(text.contains("under")){

            String[] words = text.split(" ");

            for(String s : words){

                if(s.matches("\\d+")){

                    map.put("budget", s);

                    break;
                }

            }

        }

        if(text.contains("mit"))
            map.put("location","mit");

        return map;

    }

}