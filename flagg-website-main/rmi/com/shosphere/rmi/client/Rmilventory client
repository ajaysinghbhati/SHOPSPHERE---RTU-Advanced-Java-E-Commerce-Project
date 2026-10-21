package com.shopsphere.rmi.client;

import com.shopsphere.model.Product;
import com.shopsphere.rmi.remote.InventoryService;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

/**
 * RTU Syllabus RMI Client Demonstration:
 * Looks up the remote service in the RMI Registry and executes remote method calls.
 */
public class RmiInventoryClient {

    public static void main(String[] args) {
        try {
            System.out.println("[RMI Client] Connecting to RMI Registry at localhost:1099...");
            Registry registry = LocateRegistry.getRegistry("localhost", 1099);
            InventoryService service = (InventoryService) registry.lookup("ShopSphereInventoryService");

            System.out.println("[RMI Client] Successfully looked up 'ShopSphereInventoryService'!");
            System.out.println("-----------------------------------------------------------------");

            // Test remote method 1: getProduct
            int testProductId = 1;
            Product p = service.getProduct(testProductId);
            System.out.println("[RMI Call] getProduct(" + testProductId + "): " + (p != null ? p.getName() + " (₹" + p.getPrice() + ")" : "Not found"));

            // Test remote method 2: getStock
            int stock = service.getStock(testProductId);
            System.out.println("[RMI Call] getStock(" + testProductId + "): " + stock + " units available.");

            // Test remote method 3: updateStock
            System.out.println("[RMI Call] Adding 2 units to product stock via RMI...");
            boolean updated = service.updateStock(testProductId, 2);
            System.out.println("[RMI Call] Update success: " + updated);

            int updatedStock = service.getStock(testProductId);
            System.out.println("[RMI Call] New Stock after RMI update: " + updatedStock);
            System.out.println("-----------------------------------------------------------------");
            System.out.println("[RMI Client] Demonstration completed successfully!");
        } catch (Exception e) {
            System.err.println("[RMI Client Error] Could not connect to RMI Server: " + e.getMessage());
            System.err.println("Make sure InventoryServiceImpl is running first!");
        }
    }
}
