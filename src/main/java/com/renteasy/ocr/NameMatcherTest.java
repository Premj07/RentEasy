package com.renteasy.ocr;

public class NameMatcherTest {

    public static void main(String[] args) {

        String collegeName = "PREM PANDIT JADHAV";
        String aadhaarName = "Prem Pandit Jadhav";

        boolean match = NameMatcher.isMatch(collegeName, aadhaarName);

        System.out.println("College Name : " + collegeName);
        System.out.println("Aadhaar Name : " + aadhaarName);
        System.out.println("Match : " + match);
    }
}