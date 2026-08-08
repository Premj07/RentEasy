package test;

import com.razorpay.RazorpayClient;

public class TestRazorpay {

    public static void main(String[] args) {
        try {
            RazorpayClient client = new RazorpayClient(
                    "rzp_test_THRfTDCoXenpH0",
                    "YOUR_TEST_SECRET"
            );

            System.out.println("✅ Razorpay Client Created Successfully");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}