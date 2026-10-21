package com.shopsphere.server;

import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;

/**
 * Embedded Apache Tomcat 11 Server Launcher:
 * Enables 1-click execution of the entire Flagg Jakarta EE Web Application.
 */
public class Main {
    private static final int PORT = 8080;

    public static void main(String[] args) throws Exception {
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(PORT);
        tomcat.getConnector(); // Trigger connector initialization

        String webappDirLocation = new File("web/src/main/webapp").getAbsolutePath();
        StandardContext ctx = (StandardContext) tomcat.addWebapp("", webappDirLocation);
        System.out.println("[Flagg Server] Configuring app with basedir: " + webappDirLocation);

        // Mount compiled classes to /WEB-INF/classes so web servlets and models load cleanly
        File additionWebInfClasses = new File("web/target/classes");
        if (!additionWebInfClasses.exists()) {
            additionWebInfClasses = new File("web/src/main/webapp/WEB-INF/classes");
        }
        WebResourceRoot resources = new StandardRoot(ctx);
        if (additionWebInfClasses.exists()) {
            resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                    additionWebInfClasses.getAbsolutePath(), "/"));
        }
        ctx.setResources(resources);

        tomcat.start();
        System.out.println("==================================================================");
        System.out.println("  SHOPSPHERE E-COMMERCE SYSTEM IS RUNNING ON APACHE TOMCAT 11!    ");
        System.out.println("  Customer Store: http://localhost:" + PORT + "/                      ");
        System.out.println("  Admin Portal:   http://localhost:" + PORT + "/admin/dashboard      ");
        System.out.println("==================================================================");

        tomcat.getServer().await();
    }
}
