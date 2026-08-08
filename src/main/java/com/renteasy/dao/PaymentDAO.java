package com.renteasy.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.renteasy.model.PaymentReport;

public class PaymentDAO {

    private Connection conn;

    public PaymentDAO() {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456"
            );

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public List<PaymentReport> getAllPayments() {

        List<PaymentReport> list = new ArrayList<>();

        try {

        	String sql =
        		    "SELECT " +
        		    "p.payment_id, " +
        		    "p.rental_id, " +
        		    "p.product_id, " +
        		    "p.user_id, " +
        		    "p.owner_id, " +
        		    "p.razorpay_payment_id, " +
        		    "p.razorpay_order_id, " +
        		    "p.rent_amount, " +
        		    "p.deposit_amount, " +
        		    "p.total_amount, " +
        		    "p.commission_amount, " +   // <-- FIXED
        		    "p.owner_amount, " +
        		    "p.payment_status, " +
        		    "p.payment_date, " +

        		    "pr.name AS product_name, " +
        		    "CONCAT(u.first_name,' ',u.last_name) AS customer_name, " +
        		    "CONCAT(o.first_name,' ',o.last_name) AS owner_name, " +

        		    "r.refund_status, " +
        		    "r.payout_status, " +

        		    "d.deduction_amount, " +
        		    "d.refund_amount, " +
        		    "d.owner_compensation, " +
        		    "d.inspection_status " +

        		    "FROM payments p " +

        		    "LEFT JOIN products pr ON p.product_id = pr.id " +
        		    "LEFT JOIN users u ON p.user_id = u.id " +
        		    "LEFT JOIN users o ON p.owner_id = o.id " +
        		    "LEFT JOIN rentals r ON p.rental_id = r.rental_id " +
        		    "LEFT JOIN deposit_refunds d ON p.rental_id = d.rental_id " +

        		    "ORDER BY p.payment_date DESC";

            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                PaymentReport report = new PaymentReport();

                report.setPaymentId(rs.getInt("payment_id"));
                report.setRentalId(rs.getInt("rental_id"));
                report.setProductId(rs.getInt("product_id"));

                report.setUserId(rs.getInt("user_id"));
                report.setOwnerId(rs.getInt("owner_id"));

                report.setProductName(rs.getString("product_name"));
                report.setCustomerName(rs.getString("customer_name"));
                report.setOwnerName(rs.getString("owner_name"));

                report.setRazorpayPaymentId(rs.getString("razorpay_payment_id"));
                report.setRazorpayOrderId(rs.getString("razorpay_order_id"));

                report.setRentAmount(rs.getDouble("rent_amount"));
                report.setDepositAmount(rs.getDouble("deposit_amount"));
                report.setTotalAmount(rs.getDouble("total_amount"));

                report.setCommissionAmount(rs.getDouble("commission_amount"));
                report.setOwnerAmount(rs.getDouble("owner_amount"));

                report.setPaymentStatus(rs.getString("payment_status"));
                report.setPaymentDate(rs.getTimestamp("payment_date"));

                report.setRefundStatus(rs.getString("refund_status"));
                report.setPayoutStatus(rs.getString("payout_status"));

                report.setDeductionAmount(rs.getDouble("deduction_amount"));
                report.setRefundAmount(rs.getDouble("refund_amount"));
                report.setOwnerCompensation(rs.getDouble("owner_compensation"));

                report.setInspectionStatus(rs.getString("inspection_status"));

                list.add(report);
            }
            

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public void updateCommissionAndOwnerAmount() {

        try {

            String getCommissionSql =
                    "SELECT commission_percentage FROM platform_settings LIMIT 1";

            PreparedStatement psCommission =
                    conn.prepareStatement(getCommissionSql);

            ResultSet rsCommission =
                    psCommission.executeQuery();

            double commissionPercent = 10.0;

            if (rsCommission.next()) {
                commissionPercent =
                        rsCommission.getDouble("commission_percentage");
            }

            rsCommission.close();
            psCommission.close();


            String sql =
                    "SELECT payment_id, rent_amount " +
                    "FROM payments " +
                    "WHERE payment_status='SUCCESS'";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                int paymentId =
                        rs.getInt("payment_id");

                double rent =
                        rs.getDouble("rent_amount");

                double commission =
                        (rent * commissionPercent) / 100.0;

                double ownerAmount =
                        rent - commission;

                PreparedStatement update =
                        conn.prepareStatement(

                        "UPDATE payments SET " +
                        "commission_amount=?, " +
                        "owner_amount=? " +
                        "WHERE payment_id=?"

                );

                update.setDouble(1, commission);
                update.setDouble(2, ownerAmount);
                update.setInt(3, paymentId);

                update.executeUpdate();

                update.close();

            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            e.printStackTrace();

        }
    }
 // =====================================================
 // GET PAYMENT BY ID
 // =====================================================

 public PaymentReport getPaymentById(int paymentId) {

     PaymentReport payment = null;

     try {

         String sql =
             "SELECT " +
             "p.payment_id, " +
             "p.rental_id, " +
             "p.product_id, " +
             "p.user_id, " +
             "p.owner_id, " +
             "p.razorpay_payment_id, " +
             "p.razorpay_order_id, " +
             "p.rent_amount, " +
             "p.deposit_amount, " +
             "p.total_amount, " +
             "p.commission_amount, " +
             "p.owner_amount, " +
             "p.payment_status, " +
             "p.payment_date, " +

             "pr.name AS product_name, " +
             "CONCAT(u.first_name,' ',u.last_name) AS customer_name, " +
             "CONCAT(o.first_name,' ',o.last_name) AS owner_name, " +

             "r.refund_status, " +
             "r.payout_status, " +

             "IFNULL(d.deduction_amount,0) deduction_amount, " +
             "IFNULL(d.refund_amount,0) refund_amount, " +
             "IFNULL(d.owner_compensation,0) owner_compensation, " +
             "d.inspection_status " +

             "FROM payments p " +

             "LEFT JOIN products pr ON p.product_id = pr.id " +
             "LEFT JOIN users u ON p.user_id = u.id " +
             "LEFT JOIN users o ON p.owner_id = o.id " +
             "LEFT JOIN rentals r ON p.rental_id = r.rental_id " +
             "LEFT JOIN deposit_refunds d ON p.rental_id = d.rental_id " +

             "WHERE p.payment_id=?";

         PreparedStatement ps = conn.prepareStatement(sql);

         ps.setInt(1, paymentId);

         ResultSet rs = ps.executeQuery();

         if (rs.next()) {

             payment = new PaymentReport();

             payment.setPaymentId(rs.getInt("payment_id"));
             payment.setRentalId(rs.getInt("rental_id"));
             payment.setProductId(rs.getInt("product_id"));
             payment.setUserId(rs.getInt("user_id"));
             payment.setOwnerId(rs.getInt("owner_id"));

             payment.setRazorpayPaymentId(
                     rs.getString("razorpay_payment_id"));

             payment.setRazorpayOrderId(
                     rs.getString("razorpay_order_id"));

             payment.setRentAmount(
                     rs.getDouble("rent_amount"));

             payment.setDepositAmount(
                     rs.getDouble("deposit_amount"));

             payment.setTotalAmount(
                     rs.getDouble("total_amount"));

             payment.setCommissionAmount(
                     rs.getDouble("commission_amount"));

             payment.setOwnerAmount(
                     rs.getDouble("owner_amount"));

             payment.setPaymentStatus(
                     rs.getString("payment_status"));

             payment.setPaymentDate(
                     rs.getTimestamp("payment_date"));

             payment.setProductName(
                     rs.getString("product_name"));

             payment.setCustomerName(
                     rs.getString("customer_name"));

             payment.setOwnerName(
                     rs.getString("owner_name"));

             payment.setRefundStatus(
                     rs.getString("refund_status"));

             payment.setPayoutStatus(
                     rs.getString("payout_status"));

             payment.setDeductionAmount(
                     rs.getDouble("deduction_amount"));

             payment.setRefundAmount(
                     rs.getDouble("refund_amount"));

             payment.setOwnerCompensation(
                     rs.getDouble("owner_compensation"));

             payment.setInspectionStatus(
                     rs.getString("inspection_status"));

         }

         rs.close();
         ps.close();

     } catch (Exception e) {

         e.printStackTrace();

     }

     return payment;

 }
}