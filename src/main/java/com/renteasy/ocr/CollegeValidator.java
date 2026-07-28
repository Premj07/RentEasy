package com.renteasy.ocr;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CollegeValidator {

    public static ValidationResult validate(String imagePath) {

        ValidationResult result = new ValidationResult();

        String text = OCRUtility.extractText(imagePath);

        OCRData data = new OCRData();
        data.setRawText(text);

        String upper = text.toUpperCase();

     // Normalize OCR text
     upper = upper.replace("\r", " ");
     upper = upper.replace("\n", " ");
     upper = upper.replaceAll("\\s+", " ").trim();

        // Check University
     if (!(upper.contains("MIT-ADT") && upper.contains("UNIVERSITY"))) {
    	    result.setValid(false);
    	    result.setMessage("Invalid MIT-ADT College ID.");
    	    return result;
    	}

        // Check Pune
        if (!upper.contains("PUNE")) {
            result.setValid(false);
            result.setMessage("PUNE not found.");
            return result;
        }

        // Extract Enrollment Number
        Pattern enrollPattern = Pattern.compile("ADT\\d{2}[A-Z]{3,6}\\d{4}");
        Matcher enrollMatcher = enrollPattern.matcher(upper);

        if (enrollMatcher.find()) {
            data.setEnrollmentNumber(enrollMatcher.group());
        } else {
            result.setValid(false);
            result.setMessage("Invalid Enrollment Number.");
            return result;
        }

        // Extract Batch Year
        Pattern batchPattern =
                Pattern.compile("(20\\d{2})\\s*TO\\s*(20\\d{2})");

        Matcher batchMatcher = batchPattern.matcher(upper);

        if (batchMatcher.find()) {
            data.setBatchYear(
                    batchMatcher.group(1) + " to " + batchMatcher.group(2));
        }

        // Extract School Name
        Pattern schoolPattern =
                Pattern.compile("MIT SCHOOL OF .+");

        Matcher schoolMatcher = schoolPattern.matcher(upper);

        if (schoolMatcher.find()) {
            data.setSchoolName(schoolMatcher.group());
        }

        // Extract Course
        Pattern coursePattern =
                Pattern.compile("B\\.TECH\\.[^\\n]*");

        Matcher courseMatcher = coursePattern.matcher(text.toUpperCase());

        if (courseMatcher.find()) {
            data.setCourse(courseMatcher.group().trim());
        }

     // Extract Student Name
        String[] lines = text.split("\\r?\\n");

        for (int i = 0; i < lines.length; i++) {

            String currentLine = lines[i].trim();

            // Check if this line is the enrollment number
            if (currentLine.matches("ADT\\d{2}[A-Z]{3,6}\\d{4}")) {

                // Previous line should be the course
                // Two lines above should be the student's name
                if (i >= 2) {

                    String possibleName = lines[i - 2].trim();

                    if (possibleName.matches("[A-Za-z ]{5,50}")) {
                        data.setStudentName(possibleName);
                    }
                }

                break;
            }
        }
        
        result.setValid(true);
        result.setMessage("College ID Verified Successfully.");
        result.setData(data);

        return result;
    }
}