package com.shopsphere.listener;

import com.shopsphere.network.server.ShopSphereInventoryServer;
import com.shopsphere.rmi.server.InventoryServiceImpl;
import com.shopsphere.util.DBUtil;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * RTU Syllabus Master Lifecycle Listener:
 * Initializes DB, launches the multi-threaded java.net Socket server and RMI Registry services
 * in harmonious background threads within the application container.
 */
@WebListener
public class AppListener implements ServletContextListener, HttpSessionListener {

    private final AtomicInteger activeSessions = new AtomicInteger(0);
    private Thread socketServerThread;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        context.setAttribute("appName", "Flagg");
        context.setAttribute("appTagline", "Premium Online E-Commerce Platform");
        context.setAttribute("activeUserCount", activeSessions);

        System.out.println("=================================================");
        System.out.println("[AppListener] Flagg Context Initialized!");
        System.out.println("[AppListener] Application: " + context.getAttribute("appName"));

        // 1. Initialize database tables & seed data
        DBUtil.initDatabase();
        System.out.println("[AppListener] Active DB: " + DBUtil.getActiveDatabaseType());

        // 2. Launch RMI Registry & Service (Port 1099)
        try {
            Registry registry;
            try {
                registry = LocateRegistry.createRegistry(1099);
                System.out.println("[RMI] Created RMI Registry on port 1099");
            } catch (Exception e) {
                registry = LocateRegistry.getRegistry(1099);
            }
            InventoryServiceImpl rmiService = new InventoryServiceImpl();
            registry.rebind("FlaggInventoryService", rmiService);
            System.out.println("[RMI] Bound 'FlaggInventoryService' to RMI Registry!");
        } catch (Exception e) {
            System.err.println("[RMI Startup Note] " + e.getMessage());
        }

        // 3. Launch java.net Socket Server (Port 9090) in daemon background thread
        socketServerThread = new Thread(() -> {
            ShopSphereInventoryServer.startServer(9090);
        }, "Flagg-SocketServer");
        socketServerThread.setDaemon(true);
        socketServerThread.start();

        System.out.println("=================================================");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[AppListener] Flagg Context Destroyed cleanly.");
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        activeSessions.incrementAndGet();
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        activeSessions.decrementAndGet();
    }
}
