package com.renteasy.ocr;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class AadhaarValidator {

    public static ValidationResult validate(String imagePath) {

        ValidationResult result = new ValidationResult();

        String text = OCRUtility.extractText(imagePath);

        OCRData data = new OCRData();
        data.setRawText(text);

        String upper = text.toUpperCase();

        // Extract Aadhaar Number (XXXX XXXX XXXX)
        Pattern aadhaarPattern = Pattern.compile("\\b\\d{4}\\s\\d{4}\\s\\d{4}\\b");
        Matcher aadhaarMatcher = aadhaarPattern.matcher(text);

        if (aadhaarMatcher.find()) {
            data.setAadhaarNumber(aadhaarMatcher.group());
        }

        // Extract Name
        String[] lines = text.split("\\r?\\n");

        for (String line : lines) {

            line = line.trim();

            if (line.matches("[A-Za-z ]{5,50}")
                    && !line.toUpperCase().contains("GOVERNMENT")
                    && !line.toUpperCase().contains("INDIA")
                    && !line.toUpperCase().contains("DOB")
                    && !line.toUpperCase().contains("MALE")
                    && !line.toUpperCase().contains("FEMALE")) {

                data.setStudentName(line);
                break;
            }
        }

        result.setValid(true);
        result.setMessage("Aadhaar OCR Completed.");
        result.setData(data);

        return result;
    }
}