package com.renteasy.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.renteasy.model.OwnerPayout;

public class OwnerPayoutDAO {

    // =====================================================
    // DATABASE CONNECTION
    // =====================================================

    private Connection conn;

    public OwnerPayoutDAO() {

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
    // =====================================================
    // GET ALL PENDING PAYOUTS
    // =====================================================

    public List<OwnerPayout> getPendingPayouts() {

        List<OwnerPayout> list = new ArrayList<>();

        try {

            String sql =
                    "SELECT * FROM owner_payouts " +
                    "WHERE payout_status='Pending' " +
                    "ORDER BY created_at DESC";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery();

            while(rs.next()){

                OwnerPayout payout = new OwnerPayout();

                payout.setPayoutId(rs.getInt("payout_id"));
                payout.setRentalId(rs.getInt("rental_id"));
                payout.setPaymentId(rs.getInt("payment_id"));
                payout.setOwnerId(rs.getInt("owner_id"));
                payout.setUserId(rs.getInt("user_id"));

                payout.setRentAmount(rs.getDouble("rent_amount"));
                payout.setCommissionPercent(rs.getDouble("commission_percent"));
                payout.setCommissionAmount(rs.getDouble("commission_amount"));
                payout.setOwnerAmount(rs.getDouble("owner_amount"));

                payout.setPayoutStatus(rs.getString("payout_status"));
                payout.setAdminId(rs.getInt("admin_id"));

                payout.setTransactionReference(
                        rs.getString("transaction_reference"));

                payout.setRemarks(
                        rs.getString("remarks"));

                payout.setCreatedAt(
                        rs.getTimestamp("created_at"));

                payout.setPayoutDate(
                        rs.getTimestamp("payout_date"));

                list.add(payout);

            }

            rs.close();
            ps.close();

        } catch(Exception e){

            e.printStackTrace();

        }

        return list;

    }
 // =====================================================
 // RELEASE OWNER PAYMENT
 // =====================================================

 public boolean releaseOwnerPayment(int payoutId,
                                    int adminId,
                                    String transactionReference,
                                    String remarks) {

     try {

         conn.setAutoCommit(false);

         // Update owner_payouts
         String sql =
                 "UPDATE owner_payouts SET " +
                 "payout_status='Paid', " +
                 "admin_id=?, " +
                 "transaction_reference=?, " +
                 "remarks=?, " +
                 "payout_date=NOW() " +
                 "WHERE payout_id=?";

         PreparedStatement ps =
                 conn.prepareStatement(sql);

         ps.setInt(1, adminId);
         ps.setString(2, transactionReference);
         ps.setString(3, remarks);
         ps.setInt(4, payoutId);

         int rows = ps.executeUpdate();

         ps.close();

         conn.commit();

         return rows > 0;

     } catch (Exception e) {

         try {
             conn.rollback();
         } catch (Exception ex) {
             ex.printStackTrace();
         }

         e.printStackTrace();
     }

     return false;
 }
 // =====================================================
//COMPLETE OWNER PAYMENT
//=====================================================

 public boolean completeOwnerPayment(int paymentId,
         int ownerId,
         int adminId,
         String transactionReference,
         String remarks) {

try {

conn.setAutoCommit(false);

// =====================================================
// GET PAYMENT DETAILS
// =====================================================

String paymentQuery =
"SELECT * FROM payments WHERE payment_id=?";

PreparedStatement ps =
conn.prepareStatement(paymentQuery);

ps.setInt(1, paymentId);

ResultSet rs = ps.executeQuery();

if (!rs.next()) {
return false;
}

int rentalId = rs.getInt("rental_id");
int userId = rs.getInt("user_id");

double rentAmount = rs.getDouble("rent_amount");
double commissionAmount = rs.getDouble("commission_amount");
double ownerAmount = rs.getDouble("owner_amount");

rs.close();
ps.close();

// =====================================================
// CHECK PAYOUT EXISTS
// =====================================================

PreparedStatement check =
conn.prepareStatement(
"SELECT payout_id FROM owner_payouts WHERE payment_id=?");

check.setInt(1, paymentId);

ResultSet checkRs = check.executeQuery();

boolean exists = checkRs.next();

checkRs.close();
check.close();

if (!exists) {

PreparedStatement insert =
conn.prepareStatement(

"INSERT INTO owner_payouts (" +
"rental_id," +
"payment_id," +
"owner_id," +
"user_id," +
"rent_amount," +
"commission_percent," +
"commission_amount," +
"owner_amount," +
"payout_status," +
"admin_id," +
"transaction_reference," +
"remarks," +
"created_at," +
"payout_date" +
") VALUES (?,?,?,?,?,?,?,?,?,?,?, ?,NOW(),NOW())"

);

insert.setInt(1, rentalId);
insert.setInt(2, paymentId);
insert.setInt(3, ownerId);
insert.setInt(4, userId);

insert.setDouble(5, rentAmount);
insert.setDouble(6, 10); // platform commission %
insert.setDouble(7, commissionAmount);
insert.setDouble(8, ownerAmount);

insert.setString(9, "Paid");
insert.setInt(10, adminId);
insert.setString(11, transactionReference);
insert.setString(12, remarks);

insert.executeUpdate();

insert.close();

} else {

PreparedStatement update =
conn.prepareStatement(

"UPDATE owner_payouts SET " +
"payout_status='Paid'," +
"admin_id=?," +
"transaction_reference=?," +
"remarks=?," +
"payout_date=NOW() " +
"WHERE payment_id=?"

);

update.setInt(1, adminId);
update.setString(2, transactionReference);
update.setString(3, remarks);
update.setInt(4, paymentId);

update.executeUpdate();

update.close();
}

// =====================================================
// UPDATE PAYMENT
// =====================================================

PreparedStatement payment =
conn.prepareStatement(

"UPDATE payments SET payment_status='PAID_TO_OWNER' WHERE payment_id=?"

);

payment.setInt(1, paymentId);

payment.executeUpdate();

payment.close();

// =====================================================
// UPDATE RENTAL
// =====================================================

PreparedStatement rental =
conn.prepareStatement(

"UPDATE rentals SET payout_status='Released' WHERE rental_id=?"

);

rental.setInt(1, rentalId);

rental.executeUpdate();

rental.close();

//=====================================================
//GET OWNER EMAIL
//=====================================================

String ownerEmail = null;

PreparedStatement ownerPs =
     conn.prepareStatement(
             "SELECT email FROM users WHERE id=?"
     );

ownerPs.setInt(1, ownerId);

ResultSet ownerRs = ownerPs.executeQuery();

if (ownerRs.next()) {
 ownerEmail = ownerRs.getString("email");
}

ownerRs.close();
ownerPs.close();


//=====================================================
//OWNER NOTIFICATION
//=====================================================

if (ownerEmail != null && !ownerEmail.trim().isEmpty()) {

 PreparedStatement notification =
         conn.prepareStatement(
                 "INSERT INTO notifications " +
                 "(email, message, created_at) " +
                 "VALUES (?, ?, NOW())"
         );

 notification.setString(1, ownerEmail);

 notification.setString(
         2,
         "Payment Released: Your rental payment has been released successfully."
 );

 notification.executeUpdate();
 notification.close();
}

conn.commit();

return true;

} catch (Exception e) {

    try {
        conn.rollback();
    } catch (Exception ex) {
        ex.printStackTrace();
    }

    System.out.println("================================");
    System.out.println("OWNER PAYMENT ERROR");
    System.out.println("paymentId = " + paymentId);
    System.out.println("ownerId = " + ownerId);
    System.out.println("adminId = " + adminId);
    System.out.println("transactionReference = " + transactionReference);
    System.out.println("remarks = " + remarks);
    System.out.println("================================");

    e.printStackTrace();

    return false;
}
}
//=====================================================
//GET OWNER PAYMENT HISTORY
//=====================================================

public List<OwnerPayout> getOwnerPayoutHistory(int ownerId) {

  List<OwnerPayout> list = new ArrayList<>();

  try {

      String sql =
              "SELECT " +
              "op.*, " +
              "pr.name AS product_name, " +
              "CONCAT(u.first_name,' ',u.last_name) AS owner_name " +
              "FROM owner_payouts op " +
              "LEFT JOIN payments pay ON op.payment_id = pay.payment_id " +
              "LEFT JOIN products pr ON pay.product_id = pr.id " +
              "LEFT JOIN users u ON op.owner_id = u.id " +
              "WHERE op.owner_id=? " +
              "ORDER BY op.created_at DESC";

      PreparedStatement ps = conn.prepareStatement(sql);

      ps.setInt(1, ownerId);

      ResultSet rs = ps.executeQuery();

      while (rs.next()) {

          OwnerPayout payout = new OwnerPayout();

          payout.setPayoutId(rs.getInt("payout_id"));
          payout.setRentalId(rs.getInt("rental_id"));
          payout.setPaymentId(rs.getInt("payment_id"));

          payout.setOwnerId(rs.getInt("owner_id"));
          payout.setUserId(rs.getInt("user_id"));

          payout.setRentAmount(rs.getDouble("rent_amount"));
          payout.setCommissionPercent(rs.getDouble("commission_percent"));
          payout.setCommissionAmount(rs.getDouble("commission_amount"));
          payout.setOwnerAmount(rs.getDouble("owner_amount"));

          payout.setPayoutStatus(rs.getString("payout_status"));
          payout.setAdminId(rs.getInt("admin_id"));

          payout.setTransactionReference(rs.getString("transaction_reference"));
          payout.setRemarks(rs.getString("remarks"));

          payout.setCreatedAt(rs.getTimestamp("created_at"));
          payout.setPayoutDate(rs.getTimestamp("payout_date"));

          payout.setProductName(rs.getString("product_name"));
          payout.setOwnerName(rs.getString("owner_name"));

          list.add(payout);
      }

      rs.close();
      ps.close();

  } catch (Exception e) {
      e.printStackTrace();
  }

  return list;
}}