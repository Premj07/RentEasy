package com.renteasy.payment;

import com.razorpay.RazorpayClient;

public class RazorpayConfig {

    public static RazorpayClient getClient() throws Exception {

        String keyId = "rzp_test_TOwLzxc7cyP6bU";
        String keySecret = "p044eaISi4SAou1XqKrgQl6F";

        return new RazorpayClient(keyId, keySecret);
    }
}