package com.renteasy.ocr;

public class NameMatcher {

    public static boolean isMatch(String collegeName, String aadhaarName) {

        if (collegeName == null || aadhaarName == null) {
            return false;
        }

        String name1 = normalize(collegeName);
        String name2 = normalize(aadhaarName);

        return name1.equals(name2);
    }

    private static String normalize(String name) {

        return name.toUpperCase()
                .replaceAll("[^A-Z ]", "")   // Remove punctuation
                .replaceAll("\\s+", " ")     // Remove extra spaces
                .trim();
    }
}