package com.renteasy.ocr;

public class AadhaarValidatorTest {

    public static void main(String[] args) {

    	ValidationResult result =
    		    AadhaarValidator.validate(
    		        "C:\\Users\\Hp\\OneDrive - MITADTU\\Desktop\\WhatsApp Image 2026-01-19 at 3.58.53 PM.jpeg"
    		    );

        System.out.println("-------------------------");
        System.out.println("VALID : " + result.isValid());
        System.out.println("MESSAGE : " + result.getMessage());

        OCRData data = result.getData();

        System.out.println("NAME : " + data.getStudentName());
        System.out.println("AADHAAR : " + data.getAadhaarNumber());
    }
}