package com.shopsphere.rmi.server;

import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.Product;
import com.shopsphere.rmi.remote.InventoryService;

import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;

/**
 * RTU Syllabus RMI Server Implementation.
 * Binds the remote object into the RMI Registry.
 */
public class InventoryServiceImpl extends UnicastRemoteObject implements InventoryService {
    private static final long serialVersionUID = 1L;
    private final ProductDAO productDAO = new ProductDAO();

    public InventoryServiceImpl() throws RemoteException {
        super();
    }

    @Override
    public Product getProduct(int id) throws RemoteException {
        try {
            System.out.println("[RMI Server] Remote call: getProduct(" + id + ")");
            return productDAO.findById(id);
        } catch (Exception e) {
            throw new RemoteException("Error querying product: " + e.getMessage(), e);
        }
    }

    @Override
    public int getStock(int productId) throws RemoteException {
        try {
            System.out.println("[RMI Server] Remote call: getStock(" + productId + ")");
            Product p = productDAO.findById(productId);
            return (p != null) ? p.getStock() : -1;
        } catch (Exception e) {
            throw new RemoteException("Error querying stock: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean updateStock(int productId, int delta) throws RemoteException {
        try {
            System.out.println("[RMI Server] Remote call: updateStock(" + productId + ", delta=" + delta + ")");
            return productDAO.updateStock(productId, delta);
        } catch (Exception e) {
            throw new RemoteException("Error updating stock: " + e.getMessage(), e);
        }
    }

    public static void main(String[] args) {
        try {
            int port = 1099;
            Registry registry;
            try {
                registry = LocateRegistry.createRegistry(port);
                System.out.println("[RMI Server] Created RMI Registry on port " + port);
            } catch (Exception e) {
                registry = LocateRegistry.getRegistry(port);
                System.out.println("[RMI Server] Using existing RMI Registry on port " + port);
            }

            InventoryService service = new InventoryServiceImpl();
            registry.rebind("ShopSphereInventoryService", service);

            System.out.println("=================================================");
            System.out.println("ShopSphere RMI Inventory Server is RUNNING!");
            System.out.println("Bound name: 'ShopSphereInventoryService'");
            System.out.println("Waiting for remote client invocations...");
            System.out.println("=================================================");
        } catch (Exception e) {
            System.err.println("[RMI Server Error] " + e.getMessage());
            e.printStackTrace();
        }
    }
}
