package com.renteasy.payment;

import com.razorpay.RazorpayClient;

public class RazorpayConfig {

    public static RazorpayClient getClient() throws Exception {
        return new RazorpayClient(
                "rzp_test_THRfTDCoXenpH0",
                "6IyH9aojY21uwZhSl2uw2WdB"
        );
    }
}