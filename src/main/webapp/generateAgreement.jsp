<%@ page import="java.io.*" %>
<%@ page import="com.itextpdf.text.Document" %>
<%@ page import="com.itextpdf.text.Paragraph" %>
<%@ page import="com.itextpdf.text.pdf.PdfWriter" %>
<%@ page import="java.sql.*" %>
<%
out.println("Rental ID = " + request.getParameter("rentalId"));
try{
	String rentalId =
			request.getParameter("rentalId");
			Class.forName("com.mysql.cj.jdbc.Driver");

			Connection con =
			DriverManager.getConnection(
			"jdbc:mysql://localhost:3306/renteasy",
			"root",
			"123456");
			
			PreparedStatement ps =
					con.prepareStatement(

					"SELECT r.*, p.*, " +
					"u.fullname AS renter_name, " +
					"u.username, " +
					"u.email, " +
					"u.phone, " +
					"u.address " +
					"FROM rentals r " +
					"JOIN products p ON r.product_id=p.id " +
					"JOIN users u ON r.user_id=u.id " +
					"WHERE r.rental_id=?");

					ps.setInt(1,
					Integer.parseInt(rentalId));

					ResultSet rs =
					ps.executeQuery();

					if(!rs.next()){

					out.println("Rental not found");
					return;

					}
					String renterName =
							rs.getString("renter_name");

							if(renterName == null || renterName.trim().equals("")){
							    renterName = rs.getString("username");
							}

							String renterEmail =
							rs.getString("email");

							String renterPhone =
							rs.getString("phone");

							String renterAddress =
							rs.getString("address");

							String productName =
							rs.getString("name");

							String category =
							rs.getString("category");

							int actualPrice =
							rs.getInt("actual_price");

							int deposit =
							rs.getInt("deposit");

							String startDate =
							rs.getString("start_date");

							String endDate =
							rs.getString("end_date");

							String ownerName =
							rs.getString("owner");
String folderPath =
application.getRealPath("/") + "agreements";

File folder = new File(folderPath);

if(!folder.exists()){
    folder.mkdirs();
}

String pdfPath =
folderPath + File.separator + "RentalAgreement.pdf";

Document document = new Document();

PdfWriter.getInstance(
document,
new FileOutputStream(pdfPath));

document.open();
String userCode = "";

out.println("Renter Name = " + renterName + "<br>");
out.println("Owner Name = " + ownerName + "<br>");

String[] userParts =
renterName.split(" ");

for(String s : userParts){
    userCode += s.substring(0,1).toUpperCase();
}

String ownerCode = "";

String[] ownerParts =
ownerName.split(" ");

for(String s : ownerParts){
    ownerCode += s.substring(0,1).toUpperCase();
}

String agreementId =
userCode + "-" +
ownerCode + "-" +
startDate.substring(8,10) + "-" +
startDate.substring(5,7) + "-" +
endDate.substring(8,10) + "-" +
endDate.substring(5,7) + "-" +
endDate.substring(0,4);
document.add(new Paragraph("RENTEASY RENTAL AGREEMENT"));
document.add(new Paragraph(" "));

document.add(
new Paragraph(
"Agreement ID : " + agreementId));
document.add(new Paragraph("Date : " + new java.util.Date()));

document.add(new Paragraph(" "));
document.add(new Paragraph("RENTER DETAILS"));
document.add(new Paragraph("Name : " + renterName));
document.add(new Paragraph("Email : " + renterEmail));
document.add(new Paragraph("Mobile : " + renterPhone));
document.add(new Paragraph("Address : " + renterAddress));

document.add(new Paragraph(" "));
document.add(new Paragraph("OWNER DETAILS"));
document.add(new Paragraph("Agreement ID : RA-" + rentalId));

document.add(new Paragraph("Name : " + ownerName));
document.add(new Paragraph("Mobile : Owner Mobile Not Available"));
document.add(new Paragraph("Address : Owner Address Not Available"));

document.add(new Paragraph("Product : " + productName));
document.add(new Paragraph("Category : " + category));
document.add(new Paragraph("Actual Value : Rs." + actualPrice));
document.add(new Paragraph("Security Deposit : Rs." + deposit));

document.add(new Paragraph("Start Date : " + startDate));
document.add(new Paragraph("End Date : " + endDate));
document.add(new Paragraph(" "));
document.add(new Paragraph("TERMS AND CONDITIONS"));

document.add(new Paragraph("1. User agrees to return the product in good condition."));
document.add(new Paragraph("2. Security deposit will be refunded after approval."));
document.add(new Paragraph("3. Owner may claim compensation for damages."));
document.add(new Paragraph("4. E-Cart partner will collect and deliver returned products."));
document.add(new Paragraph("5. Security cheque will be returned after successful verification."));

document.add(new Paragraph(" "));
document.add(new Paragraph("User Signature : ____________________"));

document.add(new Paragraph(" "));
document.add(new Paragraph("Owner Signature : RentEasy"));

document.add(new Paragraph(" "));
document.add(new Paragraph("RentEasy Authorized Representative"));

document.add(new Paragraph("MIT ADT University, Loni Kalbhor, Pune"));

document.add(new Paragraph(" "));
document.add(new Paragraph(
"RentEasy Authorized Representative"));

document.add(new Paragraph(
"MIT ADT University, Loni Kalbhor, Pune"));

document.close();

response.sendRedirect(
request.getContextPath()
+ "/agreements/RentalAgreement.pdf");

}
catch(Exception e){

out.println(e);

}
%>