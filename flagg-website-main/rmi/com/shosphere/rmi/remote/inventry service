package com.shopsphere.rmi.remote;

import com.shopsphere.model.Product;
import java.rmi.Remote;
import java.rmi.RemoteException;

/**
 * RTU Syllabus RMI Remote Interface.
 * Defines remote inventory querying and management operations.
 */
public interface InventoryService extends Remote {
    Product getProduct(int id) throws RemoteException;
    int getStock(int productId) throws RemoteException;
    boolean updateStock(int productId, int delta) throws RemoteException;
}
