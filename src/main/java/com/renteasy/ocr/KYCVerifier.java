package com.renteasy.ocr;


public class KYCVerifier {

    public static ValidationResult verify(String collegeIdPath, String aadhaarPath) {

        // Validate College ID
        ValidationResult collegeResult = CollegeValidator.validate(collegeIdPath);

        if (!collegeResult.isValid()) {
            return collegeResult;
        }
        OCRData collegeData = collegeResult.getData();

        String databaseName =
        StudentDatabaseValidator.getStudentName(
        collegeData.getEnrollmentNumber());
        
        if (databaseName == null) {

            ValidationResult result = new ValidationResult();

            result.setValid(false);

            result.setMessage("Your enrollment number does not exist in our database. Please upload a valid College ID.");

            return result;
        }
        
        boolean dbMatch = NameMatcher.isMatch(
                databaseName,
                collegeData.getStudentName());

        if (!dbMatch) {

            ValidationResult result = new ValidationResult();

            result.setValid(false);

            result.setMessage("The student name on the College ID does not match the official college record. Please upload a valid College ID.");

            return result;
        }

        // Validate Aadhaar
        ValidationResult aadhaarResult = AadhaarValidator.validate(aadhaarPath);

        if (!aadhaarResult.isValid()) {
            return aadhaarResult;
        }

        // Get extracted data
        OCRData aadhaarData = aadhaarResult.getData();

        // Compare Names
        boolean match = NameMatcher.isMatch(
                collegeData.getStudentName(),
                aadhaarData.getStudentName()
        );

        ValidationResult finalResult = new ValidationResult();

        if (!match) {

            finalResult.setValid(false);

            finalResult.setMessage(
                "The name on your Aadhaar card does not match the name on your College ID. Please upload valid documents."
            );

            return finalResult;
        }

        finalResult.setValid(true);
        finalResult.setMessage("KYC VERIFIED SUCCESSFULLY");
        finalResult.setData(collegeData);

        return finalResult;

    }
}