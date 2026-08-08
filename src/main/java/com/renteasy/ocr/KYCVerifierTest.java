package com.renteasy.ocr;

public class KYCVerifierTest {

    public static void main(String[] args) {

        String collegePath = "C:\\Users\\Hp\\Downloads\\MITADTCOLLAGEID.jpeg";
        String aadhaarPath = "C:\\Users\\Hp\\Downloads\\premaadhar.jpeg";

        ValidationResult result = KYCVerifier.verify(collegePath, aadhaarPath);

        System.out.println("--------------------------------");
        System.out.println("VALID : " + result.isValid());
        System.out.println("MESSAGE : " + result.getMessage());

        if (result.getData() != null) {

            OCRData data = result.getData();

            System.out.println("NAME : " + data.getStudentName());
            System.out.println("ENROLLMENT : " + data.getEnrollmentNumber());
            System.out.println("COURSE : " + data.getCourse());
            System.out.println("BATCH : " + data.getBatchYear());
            System.out.println("SCHOOL : " + data.getSchoolName());
        }
    }
}