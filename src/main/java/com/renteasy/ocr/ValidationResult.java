package com.renteasy.ocr;

public class ValidationResult {

    private boolean valid;
    private String message;
    private OCRData data;

    public boolean isValid() {
        return valid;
    }

    public void setValid(boolean valid) {
        this.valid = valid;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public OCRData getData() {
        return data;
    }

    public void setData(OCRData data) {
        this.data = data;
    }
}