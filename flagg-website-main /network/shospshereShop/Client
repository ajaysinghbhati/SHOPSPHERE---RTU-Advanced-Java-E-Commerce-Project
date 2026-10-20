package com.shopsphere.network.client;

import com.shopsphere.model.Product;
import com.shopsphere.network.model.NetworkMessage;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.List;

/**
 * RTU Syllabus java.net Client Demonstration:
 * Connects to ShopSphereInventoryServer over TCP Socket and sends serialized NetworkMessage objects.
 */
public class ShopSphereInventoryClient {

    private static final String HOST = "localhost";
    private static final int PORT = 9090;

    public static NetworkMessage sendRequest(NetworkMessage request) {
        try (Socket socket = new Socket(HOST, PORT);
             ObjectOutputStream out = new ObjectOutputStream(socket.getOutputStream());
             ObjectInputStream in = new ObjectInputStream(socket.getInputStream())) {

            out.writeObject(request);
            out.flush();

            return (NetworkMessage) in.readObject();
        } catch (Exception e) {
            NetworkMessage err = new NetworkMessage();
            err.setSuccess(false);
            err.setMessage("Socket error: " + e.getMessage());
            return err;
        }
    }

    @SuppressWarnings("unchecked")
    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println("ShopSphere java.net Socket Client Testing...");
        System.out.println("Connecting to " + HOST + ":" + PORT);
        System.out.println("=================================================");

        // Test 1: GET_PRODUCT
        System.out.println("\n[1] Testing GET_PRODUCT (ID = 1)...");
        NetworkMessage req1 = new NetworkMessage("GET_PRODUCT", 1);
        NetworkMessage res1 = sendRequest(req1);
        if (res1.isSuccess() && res1.getPayload() instanceof Product) {
            Product p = (Product) res1.getPayload();
            System.out.println("-> Success: " + p.getName() + " | Price: ₹" + p.getPrice() + " | Stock: " + p.getStock());
        } else {
            System.out.println("-> Failed: " + res1.getMessage());
        }

        // Test 2: GET_STOCK
        System.out.println("\n[2] Testing GET_STOCK (ID = 2)...");
        NetworkMessage req2 = new NetworkMessage("GET_STOCK", 2);
        NetworkMessage res2 = sendRequest(req2);
        System.out.println("-> Success: Stock available = " + res2.getPayload());

        // Test 3: SEARCH_PRODUCT
        System.out.println("\n[3] Testing SEARCH_PRODUCT (query = 'Apple')...");
        NetworkMessage req3 = new NetworkMessage("SEARCH_PRODUCT", "Apple");
        NetworkMessage res3 = sendRequest(req3);
        if (res3.isSuccess() && res3.getPayload() instanceof List) {
            List<Product> matches = (List<Product>) res3.getPayload();
            System.out.println("-> Success: Found " + matches.size() + " matches.");
            for (Product p : matches) {
                System.out.println("    - " + p.getName() + " (₹" + p.getPrice() + ")");
            }
        } else {
            System.out.println("-> Search response: " + res3.getMessage());
        }

        System.out.println("\n=================================================");
        System.out.println("java.net Socket Client Demonstration complete!");
        System.out.println("=================================================");
    }
}
