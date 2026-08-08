package com.renteasy.model;

import java.sql.Date;

public class OwnerRental {

    private int rentalId;

    private String productName;
    private String productImage;

    private String customerName;
    private String customerEmail;
    private String customerPhone;

    private Date startDate;
    private Date endDate;

    private double rentAmount;

    // Pickup
    private String pickupOtp;
    private String pickupStatus;

    // Return / Refund
    private String refundStatus;
    private String inspectionStatus;

    // Default Constructor
    public OwnerRental() {
    }


    // ==========================================
    // RENTAL
    // ==========================================

    public int getRentalId() {
        return rentalId;
    }

    public void setRentalId(int rentalId) {
        this.rentalId = rentalId;
    }


    // ==========================================
    // PRODUCT
    // ==========================================

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }


    // ==========================================
    // CUSTOMER
    // ==========================================

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }


    // ==========================================
    // RENTAL DATES
    // ==========================================

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }


    // ==========================================
    // RENT AMOUNT
    // ==========================================

    public double getRentAmount() {
        return rentAmount;
    }

    public void setRentAmount(double rentAmount) {
        this.rentAmount = rentAmount;
    }


    // ==========================================
    // PICKUP
    // ==========================================

    public String getPickupOtp() {
        return pickupOtp;
    }

    public void setPickupOtp(String pickupOtp) {
        this.pickupOtp = pickupOtp;
    }

    public String getPickupStatus() {
        return pickupStatus;
    }

    public void setPickupStatus(String pickupStatus) {
        this.pickupStatus = pickupStatus;
    }


    // ==========================================
    // RETURN / REFUND
    // ==========================================

    public String getRefundStatus() {
        return refundStatus;
    }

    public void setRefundStatus(String refundStatus) {
        this.refundStatus = refundStatus;
    }

    public String getInspectionStatus() {
        return inspectionStatus;
    }

    public void setInspectionStatus(String inspectionStatus) {
        this.inspectionStatus = inspectionStatus;
    }
    private String rentalStatus;

    public String getRentalStatus() {
        return rentalStatus;
    }

    public void setRentalStatus(String rentalStatus) {
        this.rentalStatus = rentalStatus;
    }
}