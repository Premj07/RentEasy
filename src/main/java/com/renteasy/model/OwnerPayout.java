package com.renteasy.model;

import java.sql.Timestamp;

public class OwnerPayout {

    // =====================================================
    // PRIMARY DETAILS
    // =====================================================

    private int payoutId;
    private int rentalId;
    private int paymentId;

    // =====================================================
    // USER DETAILS
    // =====================================================

    private int ownerId;
    private int userId;
    private int adminId;

    // =====================================================
    // PAYMENT DETAILS
    // =====================================================

    private double rentAmount;
    private double commissionPercent;
    private double commissionAmount;
    private double ownerAmount;

    // =====================================================
    // PAYOUT DETAILS
    // =====================================================

    private String payoutStatus;
    private Timestamp payoutDate;
    private String transactionReference;
    private String remarks;

    // =====================================================
    // CREATED DATE
    // =====================================================

    private Timestamp createdAt;

    // =====================================================
    // EXTRA DISPLAY FIELDS
    // (Used for JSP Reports)
    // =====================================================

    private String ownerName;
    private String userName;
    private String productName;

    // =====================================================
    // DEFAULT CONSTRUCTOR
    // =====================================================

    public OwnerPayout() {

    }

    // =====================================================
    // GETTERS AND SETTERS
    // =====================================================

    public int getPayoutId() {
        return payoutId;
    }

    public void setPayoutId(int payoutId) {
        this.payoutId = payoutId;
    }

    public int getRentalId() {
        return rentalId;
    }

    public void setRentalId(int rentalId) {
        this.rentalId = rentalId;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public double getRentAmount() {
        return rentAmount;
    }

    public void setRentAmount(double rentAmount) {
        this.rentAmount = rentAmount;
    }

    public double getCommissionPercent() {
        return commissionPercent;
    }

    public void setCommissionPercent(double commissionPercent) {
        this.commissionPercent = commissionPercent;
    }

    public double getCommissionAmount() {
        return commissionAmount;
    }

    public void setCommissionAmount(double commissionAmount) {
        this.commissionAmount = commissionAmount;
    }

    public double getOwnerAmount() {
        return ownerAmount;
    }

    public void setOwnerAmount(double ownerAmount) {
        this.ownerAmount = ownerAmount;
    }

    public String getPayoutStatus() {
        return payoutStatus;
    }

    public void setPayoutStatus(String payoutStatus) {
        this.payoutStatus = payoutStatus;
    }

    public Timestamp getPayoutDate() {
        return payoutDate;
    }

    public void setPayoutDate(Timestamp payoutDate) {
        this.payoutDate = payoutDate;
    }

    public String getTransactionReference() {
        return transactionReference;
    }

    public void setTransactionReference(String transactionReference) {
        this.transactionReference = transactionReference;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

}