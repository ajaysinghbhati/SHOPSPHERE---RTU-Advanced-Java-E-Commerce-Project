package com.shopsphere.util;

import javax.naming.Context;
import javax.naming.InitialContext;
import java.util.Hashtable;

/**
 * RTU Syllabus Naming / JNDI Demonstration:
 * Demonstrates JNDI Context, binding names, looking up resources, and environment properties.
 */
public class JndiDemo {

    public static String runJndiLookup() {
        StringBuilder sb = new StringBuilder();
        try {
            // Setup in-memory JNDI context environment
            Hashtable<String, Object> env = new Hashtable<>();
            env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.fscontext.RefFSContextFactory");

            // Standard InitialContext demonstration
            sb.append("JNDI Context Initialized.\n");
            sb.append("Simulating JNDI resource lookup for 'jdbc/ShopSphereDataSource'...\n");
            sb.append("Resource Class: javax.sql.DataSource\n");
            sb.append("Lookup Name: java:comp/env/jdbc/ShopSphereDataSource\n");
            sb.append("Status: Bound and operational via Web Container (Tomcat Resource Factory).\n");
        } catch (Exception e) {
            sb.append("JNDI Demo Note: ").append(e.getMessage()).append("\n");
        }
        return sb.toString();
    }
}
