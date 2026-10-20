package com.shopsphere.network.server;

import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.Product;
import com.shopsphere.network.model.NetworkMessage;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.List;

/**
 * RTU Syllabus java.net Networking Module:
 * Multi-threaded ServerSocket inventory server with Object Serialization.
 */
public class ShopSphereInventoryServer {
    private static final int DEFAULT_PORT = 9090;

    public static void startServer(int port) {
        System.out.println("=================================================");
        System.out.println("[Socket Server] ShopSphere TCP Server listening on port: " + port);
        System.out.println("=================================================");

        try (ServerSocket serverSocket = new ServerSocket(port)) {
            while (!Thread.currentThread().isInterrupted()) {
                Socket clientSocket = serverSocket.accept();
                System.out.println("[Socket Server] Accepted connection from: " + clientSocket.getRemoteSocketAddress());
                new Thread(new ClientHandler(clientSocket)).start();
            }
        } catch (Exception e) {
            System.err.println("[Socket Server Error] " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        startServer(DEFAULT_PORT);
    }

    private static class ClientHandler implements Runnable {
        private final Socket socket;
        private final ProductDAO productDAO = new ProductDAO();

        public ClientHandler(Socket socket) {
            this.socket = socket;
        }

        @Override
        public void run() {
            try (ObjectOutputStream out = new ObjectOutputStream(socket.getOutputStream());
                 ObjectInputStream in = new ObjectInputStream(socket.getInputStream())) {

                NetworkMessage request = (NetworkMessage) in.readObject();
                NetworkMessage response = new NetworkMessage();

                String cmd = request.getCommand();
                System.out.println("[Socket Server] Processing command: " + cmd);

                if ("GET_PRODUCT".equalsIgnoreCase(cmd)) {
                    int id = (Integer) request.getPayload();
                    Product p = productDAO.findById(id);
                    response.setSuccess(p != null);
                    response.setPayload(p);
                    response.setMessage(p != null ? "Product retrieved" : "Product not found");
                } else if ("GET_STOCK".equalsIgnoreCase(cmd)) {
                    int id = (Integer) request.getPayload();
                    Product p = productDAO.findById(id);
                    response.setSuccess(p != null);
                    response.setPayload(p != null ? p.getStock() : 0);
                    response.setMessage("Stock level retrieved");
                } else if ("SEARCH_PRODUCT".equalsIgnoreCase(cmd)) {
                    String query = (String) request.getPayload();
                    List<Product> list = productDAO.searchAndFilter(query, null, null, null, null);
                    response.setSuccess(true);
                    response.setPayload(list);
                    response.setMessage("Found " + list.size() + " matches");
                } else {
                    response.setSuccess(false);
                    response.setMessage("Unknown command: " + cmd);
                }

                out.writeObject(response);
                out.flush();
            } catch (Exception e) {
                System.err.println("[Socket Server Handler Error] " + e.getMessage());
            } finally {
                try { socket.close(); } catch (Exception ignored) {}
            }
        }
    }
}
