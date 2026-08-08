package com.renteasy.ocr;

import java.sql.*;

public class StudentDatabaseValidator {

    public static String getStudentName(String enrollment) {

        String sql =
        "SELECT Student_Name FROM student_master WHERE Enrollment_Number=?";

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con =
            DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/renteasy",
            "root",
            "123456");

            PreparedStatement ps =
            con.prepareStatement(sql);

            ps.setString(1,enrollment);

            ResultSet rs=ps.executeQuery();

            if(rs.next()){

                return rs.getString("Student_Name");

            }

            rs.close();
            ps.close();
            con.close();

        }catch(Exception e){
            e.printStackTrace();
        }

        return null;

    }

}