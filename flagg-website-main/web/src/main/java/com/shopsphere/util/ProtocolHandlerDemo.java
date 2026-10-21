package com.shopsphere.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;

/**
 * RTU Syllabus Content and Protocol Handlers Demonstration:
 * Demonstrates URL, URLConnection, HttpURLConnection, content-type inspection, and stream reading.
 */
public class ProtocolHandlerDemo {

    public static String fetchUrlContent(String urlString) {
        StringBuilder result = new StringBuilder();
        try {
            URI uri = URI.create(urlString);
            URL url = uri.toURL();

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);
            conn.setRequestProperty("User-Agent", "ShopSphere-Protocol-Handler/1.0");

            result.append("Response Code: ").append(conn.getResponseCode()).append("\n");
            result.append("Content Type: ").append(conn.getContentType()).append("\n");
            result.append("Content Length: ").append(conn.getContentLengthLong()).append("\n");
            result.append("Protocol: ").append(url.getProtocol()).append("\n");
            result.append("Host: ").append(url.getHost()).append("\n");
            result.append("Port: ").append(url.getPort()).append("\n\n");
            result.append("--- Content Stream Snippet ---\n");

            try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                String line;
                int lineCount = 0;
                while ((line = reader.readLine()) != null && lineCount < 25) {
                    result.append(line).append("\n");
                    lineCount++;
                }
            }
        } catch (Exception e) {
            result.append("Protocol Handler Error: ").append(e.getMessage());
        }
        return result.toString();
    }
}
