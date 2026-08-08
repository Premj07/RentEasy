package com.renteasy.ocr;

public class CollegeValidatorTest {

    public static void main(String[] args) {

    	ValidationResult result =
    	        CollegeValidator.validate(
    	            "C:\\Users\\Hp\\Downloads\\MITADTCOLLAGEID.jpeg"
    	        );

        System.out.println("--------------------------------");
        System.out.println("VALID : " + result.isValid());
        System.out.println("MESSAGE : " + result.getMessage());

        if(result.getData()!=null){

            OCRData data = result.getData();

            System.out.println("NAME : " + data.getStudentName());
            System.out.println("ENROLLMENT : " + data.getEnrollmentNumber());
            System.out.println("COURSE : " + data.getCourse());
            System.out.println("BATCH : " + data.getBatchYear());
            System.out.println("SCHOOL : " + data.getSchoolName());
        }
    }
}