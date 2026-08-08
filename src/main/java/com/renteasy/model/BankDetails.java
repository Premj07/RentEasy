package com.renteasy.model;

public class BankDetails {

    private int id;
    private int userId;

    private String accountHolder;
    private String bankName;
    private String accountNumber;
    private String ifscCode;

    private String upiId;
    private String method;

    public BankDetails() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAccountHolder() {
        return accountHolder;
    }

    public void setAccountHolder(String accountHolder) {
        this.accountHolder = accountHolder;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getIfscCode() {
        return ifscCode;
    }

    public void setIfscCode(String ifscCode) {
        this.ifscCode = ifscCode;
    }

    public String getUpiId() {
        return upiId;
    }

    public void setUpiId(String upiId) {
        this.upiId = upiId;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    // =============================================
    // MASK ACCOUNT NUMBER FOR DISPLAY
    // =============================================

    public String getMaskedAccountNumber() {

        if (accountNumber == null || accountNumber.isEmpty()) {
            return "";
        }

        if (accountNumber.length() <= 4) {
            return accountNumber;
        }

        String lastFour =
                accountNumber.substring(accountNumber.length() - 4);

        return "••••••••" + lastFour;
    }
}