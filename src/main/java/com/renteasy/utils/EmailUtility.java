package com.renteasy.utils;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtility {
	public static void sendSignupOTP(String toEmail, String otp) throws Exception {

	    final String fromEmail = "renteasy.project@gmail.com";
	    final String appPassword = "dyjm ceim prds onck";

	    Properties props = new Properties();
	    props.put("mail.smtp.host", "smtp.gmail.com");
	    props.put("mail.smtp.port", "587");
	    props.put("mail.smtp.auth", "true");
	    props.put("mail.smtp.starttls.enable", "true");

	    Session session = Session.getInstance(props,
	        new Authenticator() {
	            protected PasswordAuthentication getPasswordAuthentication() {
	                return new PasswordAuthentication(fromEmail, appPassword);
	            }
	        });

	    Message message = new MimeMessage(session);
	    message.setFrom(new InternetAddress(fromEmail));
	    message.setRecipients(Message.RecipientType.TO,
	            InternetAddress.parse(toEmail));

	    message.setSubject("RentEasy Account Registration OTP");

	    message.setText(
	        "Welcome to RentEasy.\n\n" +
	        "Your Signup OTP is: " + otp +
	        "\n\nUse this OTP to complete registration.");

	    Transport.send(message);
	}
	public static void sendKycOTP(String toEmail, String otp) throws Exception {

	    final String fromEmail = "renteasy.project@gmail.com";
	    final String appPassword = "dyjm ceim prds onck";

	    Properties props = new Properties();
	    props.put("mail.smtp.host", "smtp.gmail.com");
	    props.put("mail.smtp.port", "587");
	    props.put("mail.smtp.auth", "true");
	    props.put("mail.smtp.starttls.enable", "true");

	    Session session = Session.getInstance(props,
	        new Authenticator() {
	            protected PasswordAuthentication getPasswordAuthentication() {
	                return new PasswordAuthentication(fromEmail, appPassword);
	            }
	        });

	    Message message = new MimeMessage(session);
	    message.setFrom(new InternetAddress(fromEmail));
	    message.setRecipients(Message.RecipientType.TO,
	            InternetAddress.parse(toEmail));

	    message.setSubject("RentEasy KYC Verification OTP");

	    message.setText(
	        "RentEasy KYC Verification.\n\n" +
	        "Your KYC OTP is: " + otp +
	        "\n\nUse this OTP to complete KYC.");

	    Transport.send(message);
	}
	public static void sendLoginOTP(String toEmail, String otp) throws Exception {

	    final String fromEmail = "renteasy.project@gmail.com";
	    final String appPassword = "dyjm ceim prds onck";

	    Properties props = new Properties();
	    props.put("mail.smtp.host", "smtp.gmail.com");
	    props.put("mail.smtp.port", "587");
	    props.put("mail.smtp.auth", "true");
	    props.put("mail.smtp.starttls.enable", "true");

	    Session session = Session.getInstance(props,
	        new Authenticator() {
	            protected PasswordAuthentication getPasswordAuthentication() {
	                return new PasswordAuthentication(fromEmail, appPassword);
	            }
	        });

	    Message message = new MimeMessage(session);
	    message.setFrom(new InternetAddress(fromEmail));
	    message.setRecipients(Message.RecipientType.TO,
	            InternetAddress.parse(toEmail));

	    message.setSubject("RentEasy Login Verification OTP");

	    message.setText(
	        "RentEasy Login Verification.\n\n" +
	        "Your Login OTP is: " + otp +
	        "\n\nUse this OTP to login.");

	    Transport.send(message);
	}
//======================================================
//BOOKING CONFIRMATION EMAIL TO USER
//======================================================

public static void sendBookingConfirmation(

     String toEmail,
     String productName,
     String ownerName,
     String ownerPhone,
     String ownerLocation,
     String pickupOtp)

     throws Exception {

 final String fromEmail = "renteasy.project@gmail.com";
 final String appPassword = "dyjm ceim prds onck";

 Properties props = new Properties();

 props.put("mail.smtp.host", "smtp.gmail.com");
 props.put("mail.smtp.port", "587");
 props.put("mail.smtp.auth", "true");
 props.put("mail.smtp.starttls.enable", "true");

 Session session = Session.getInstance(

         props,

         new Authenticator() {

             protected PasswordAuthentication
             getPasswordAuthentication() {

                 return new PasswordAuthentication(
                         fromEmail,
                         appPassword);

             }

         });

 Message message =
         new MimeMessage(session);

 message.setFrom(
         new InternetAddress(fromEmail));

 message.setRecipients(

         Message.RecipientType.TO,

         InternetAddress.parse(toEmail));

 message.setSubject(
         "RentEasy Rental Booking Confirmed");

 String body =

         "Hello,\n\n"

         + "Your rental booking has been confirmed.\n\n"

         + "Product : " + productName + "\n"

         + "Owner : " + ownerName + "\n"

         + "Owner Phone : " + ownerPhone + "\n\n"

         + "Pickup Location\n"

         + ownerLocation + "\n\n"

         + "Pickup OTP : "

         + pickupOtp

         + "\n\n"

         + "Show this OTP only after meeting the owner.\n"

         + "The owner will verify this OTP before handing over the product.\n\n"

         + "Thank you for using RentEasy.";

 message.setText(body);

 Transport.send(message);

} // ======================================================
//OWNER BOOKING EMAIL
//======================================================

public static void sendOwnerBookingNotification(

     String ownerEmail,
     String ownerName,
     String renterName,
     String renterEmail,
     String renterPhone,
     String productName,
     String pickupOtp)

     throws Exception {

 final String fromEmail = "renteasy.project@gmail.com";
 final String appPassword = "dyjm ceim prds onck";

 Properties props = new Properties();

 props.put("mail.smtp.host", "smtp.gmail.com");
 props.put("mail.smtp.port", "587");
 props.put("mail.smtp.auth", "true");
 props.put("mail.smtp.starttls.enable", "true");

 Session session = Session.getInstance(

         props,

         new Authenticator() {

             protected PasswordAuthentication
             getPasswordAuthentication() {

                 return new PasswordAuthentication(
                         fromEmail,
                         appPassword);

             }

         });

 Message message =
         new MimeMessage(session);

 message.setFrom(
         new InternetAddress(fromEmail));

 message.setRecipients(

         Message.RecipientType.TO,

         InternetAddress.parse(ownerEmail));

 message.setSubject(
         "New Rental Booking Received");

 String body =

         "Hello "

         + ownerName

         + ",\n\n"

         + "You have received a new rental booking.\n\n"

         + "Product : "

         + productName

         + "\n\n"

         + "Customer Name : "

         + renterName

         + "\n"

         + "Customer Email : "

         + renterEmail

         + "\n"

         + "Customer Phone : "

         + renterPhone

         + "\n\n"

         + "Before handing over the product,\n"

         + "ask the customer for the Pickup OTP.\n\n"

         + "Expected OTP : "

         + pickupOtp

         + "\n\n"

         + "Do NOT hand over the product if the OTP is incorrect.\n\n"

         + "Thank you,\n"

         + "RentEasy";

 message.setText(body);

 Transport.send(message);

}
//======================================================
//KYC SUCCESS EMAIL
//======================================================

public static void sendKYCSuccessEmail(

     String toEmail,
     String userName)

     throws Exception {

 final String fromEmail = "renteasy.project@gmail.com";
 final String appPassword = "dyjm ceim prds onck";

 Properties props = new Properties();

 props.put("mail.smtp.host", "smtp.gmail.com");
 props.put("mail.smtp.port", "587");
 props.put("mail.smtp.auth", "true");
 props.put("mail.smtp.starttls.enable", "true");

 Session session = Session.getInstance(

         props,

         new Authenticator() {

             protected PasswordAuthentication getPasswordAuthentication() {

                 return new PasswordAuthentication(
                         fromEmail,
                         appPassword);

             }

         });

 Message message = new MimeMessage(session);

 message.setFrom(new InternetAddress(fromEmail));

 message.setRecipients(

         Message.RecipientType.TO,

         InternetAddress.parse(toEmail));

 message.setSubject("🎉 RentEasy KYC Verification Successful");

 String body =

         "Dear " + userName + ",\n\n"

         + "Congratulations!\n\n"

         + "Your RentEasy KYC has been verified successfully.\n\n"

         + "You can now:\n"

         + "• Rent Products\n"

         + "• Upload Your Own Products\n"

         + "• Access Secure Transactions\n"

         + "• Enjoy All RentEasy Features\n\n"

         + "Thank you for choosing RentEasy.\n\n"

         + "Best Regards,\n"

         + "RentEasy Team";

 message.setText(body);

 Transport.send(message);
}
}
	