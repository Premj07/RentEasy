package com.renteasy.ocr;

import java.io.File;
import java.io.FileInputStream;
import java.util.Collections;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.vision.v1.AnnotateImageRequest;
import com.google.cloud.vision.v1.AnnotateImageResponse;
import com.google.cloud.vision.v1.BatchAnnotateImagesResponse;
import com.google.cloud.vision.v1.Feature;
import com.google.cloud.vision.v1.Feature.Type;
import com.google.cloud.vision.v1.Image;
import com.google.cloud.vision.v1.ImageAnnotatorClient;
import com.google.cloud.vision.v1.ImageAnnotatorSettings;
import com.google.protobuf.ByteString;

public class OCRUtility {

	private static final String JSON_KEY =
	        "C:\\Users\\Hp\\Downloads\\renteasy-503221-b94c5fee63fa.json";
	
    public static String extractText(String imagePath) {

        try {

            GoogleCredentials credentials =
                    GoogleCredentials.fromStream(new FileInputStream(JSON_KEY));

            ImageAnnotatorSettings settings =
                    ImageAnnotatorSettings.newBuilder()
                            .setCredentialsProvider(() -> credentials)
                            .build();

            try (ImageAnnotatorClient vision =
                    ImageAnnotatorClient.create(settings)) {

                ByteString imgBytes =
                        ByteString.readFrom(new FileInputStream(new File(imagePath)));

                Image image =
                        Image.newBuilder()
                                .setContent(imgBytes)
                                .build();

                Feature feature =
                        Feature.newBuilder()
                                .setType(Type.TEXT_DETECTION)
                                .build();

                AnnotateImageRequest request =
                        AnnotateImageRequest.newBuilder()
                                .addFeatures(feature)
                                .setImage(image)
                                .build();

                BatchAnnotateImagesResponse response =
                        vision.batchAnnotateImages(
                                Collections.singletonList(request));

                AnnotateImageResponse res =
                        response.getResponses(0);

                if (res.hasError()) {
                    return "";
                }

                if (res.getTextAnnotationsCount() > 0) {
                    return res.getTextAnnotations(0).getDescription();
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "";
    }

}