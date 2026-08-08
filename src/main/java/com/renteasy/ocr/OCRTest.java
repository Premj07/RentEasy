package com.renteasy.ocr;

import java.io.File;

public class OCRTest {

    public static void main(String[] args) {

        String imagePath = "C:\\Users\\HP\\Downloads\\MITADTCOLLAGEID.jpeg";

        // Check if JSON file exists
        System.out.println("JSON exists: " +
        	    new File("C:\\Users\\Hp\\Downloads\\renteasy-503221-b94c5fee63fa.json").exists());
        
        // Check if image exists
        System.out.println("Image exists: " +
                new File(imagePath).exists());

        String text = OCRUtility.extractText(imagePath);

        System.out.println("===== OCR RESULT =====");
        System.out.println(text);
    }
}