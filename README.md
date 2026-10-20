# SHOPSPHERE---RTU-Advanced-Java-E-Commerce-Project
SHOPSPHERE - RTU Advanced Java E-Commerce Project
Rajasthan Technical University (RTU) Advanced Java Practical Capstone Project

🌟 Project Overview
ShopSphere is an enterprise-grade Java E-Commerce Management System designed as a comprehensive practical demonstration of the entire RTU Advanced Java syllabus:

Presentation Layer: JSP, Expression Language (${...}), Custom Tag Files (<tags:productCard>, <tags:rating>), JSP Fragments (header, navbar, footer), JSTL Core, XML & Functions.
Controller Layer: Jakarta Servlet 6.1 controllers (LoginServlet, RegisterServlet, ProductServlet, CartServlet, CheckoutServlet, OrderServlet, WishlistServlet, ReviewServlet, AdminServlet).
Service Layer: ProductService, OrderService, CheckoutService with business validations, coupon algorithms, and stock decrements.
Data Access Layer (DAO): UserDAO, ProductDAO, CategoryDAO, CartDAO, OrderDAO, AddressDAO, ReviewDAO, CouponDAO utilizing secure PreparedStatement queries.
Database: MySQL (database/shopsphere.sql) with dual zero-config embedded Apache Derby engine fallback.
Desktop Admin App: Java Swing MVC application (LoginFrame, AdminDashboard) with JFrame, JPanel, JTable, JComboBox, JTextField, JCheckBox, JOptionPane.
Networking Module (java.net): Multi-threaded TCP ServerSocket and Socket inventory server with ObjectSerialization.
Distributed Services (RMI): Remote Inventory Service (InventoryService, InventoryServiceImpl) with RMI Registry binding on port 1099.
Security: SHA-256 password hashing, server-side price computations, AuthenticationFilter, AdminFilter.
Internationalization (I18N): Locale, ResourceBundle supporting English & Hindi.
🚀 Live Access & Quick Start
The system is compiled and running locally:

Application / Module	Access URL / Command	Default Demo Credentials
Customer Storefront	http://localhost:8080/	customer@shopsphere.com / user123
Web Admin Console	http://localhost:8080/admin/dashboard	admin@shopsphere.com / admin123
RTU Syllabus Viva Demo	http://localhost:8080/syllabus/syllabus-demo.jsp	Open to all
JSTL Core/XML Demo	http://localhost:8080/syllabus/jstl-demo.jsp	Open to all
Desktop Swing Admin	Run run-swing-admin.bat	admin@shopsphere.com / admin123
TCP Socket Client Test	Run test-socket-client.bat	Port 9090
Java RMI Client Test	Run test-rmi-client.bat	Port 1099
📋 RTU Syllabus-to-Project Mapping
RTU Syllabus Topic	Project Implementation File(s)	Viva Demonstration Point
Swing & Swing MVC	swing-admin/src/.../view/LoginFrame.java, AdminDashboard.java	Show desktop admin login, product CRUD table, order status updates, look-and-feel.
MVC Architecture	web/src/main/java/com/shopsphere/...	Explain separation of JSP views, Servlets, Services, and DAOs.
JDBC / java.sql	DBUtil.java, ProductDAO.java, UserDAO.java, OrderDAO.java	Show PreparedStatement parameter binding preventing SQL injection.
java.net Sockets	network/src/.../ShopSphereInventoryServer.java, ShopSphereInventoryClient.java	Multi-threaded client-server querying inventory over port 9090.
Java RMI & Registry	rmi/src/.../InventoryService.java, InventoryServiceImpl.java	RMI Registry on port 1099 with remote stock lookups and updates.
Object Serialization	Product.java, Order.java, NetworkMessage.java	Objects implementing java.io.Serializable transferred across sockets.
Servlet Lifecycle & Config	LoginServlet.java, AppListener.java	Explain init(), service(), doGet(), doPost(), destroy().
Filters & Listeners	AuthenticationFilter.java, AdminFilter.java, AppListener.java	Route protection on /admin/* and session counting via HttpSessionListener.
JSP Architecture & Elements	web/src/main/webapp/syllabus/syllabus-demo.jsp	Declarations <%! %>, Scriptlets <% %>, Expressions <%= %>, Comments <%-- --%>.
JSP EL & Tag Files	WEB-INF/tags/productCard.tag, rating.tag	${product.name}, reusable component tags with attribute passing.
JSTL Core, XML, Functions	web/src/main/webapp/syllabus/jstl-demo.jsp	<c:forEach>, <c:choose>, <x:parse>, <x:out>, fn:toUpperCase().
Internationalization (I18N)	I18nDemo.java, messages_en.properties, messages_hi.properties	Dynamic language switching between English and Hindi with currency formatting.
JNDI & Protocol Handlers	JndiDemo.java, ProtocolHandlerDemo.java	Demonstrates JNDI Context lookup and URLConnection stream reading.
📁 Project Directory Structure
ShopSphere/
|-- pom.xml                               # Root Maven project descriptor
|-- run-server.bat                        # 1-click launcher for Tomcat 11, RMI, & Sockets
|-- run-swing-admin.bat                   # 1-click launcher for Swing Admin Desktop GUI
|-- test-socket-client.bat                # 1-click test for java.net Socket client
|-- test-rmi-client.bat                   # 1-click test for Java RMI remote client
|-- database/
|   `-- shopsphere.sql                    # MySQL database schema & seed data
|-- swing-admin/                          # Desktop administration module
|   `-- src/com/shopsphere/swing/
|       |-- view/ (LoginFrame, AdminDashboard)
|-- network/                              # java.net client-server module
|   `-- src/com/shopsphere/network/
|       |-- client/ (ShopSphereInventoryClient)
|       |-- server/ (ShopSphereInventoryServer)
|       `-- model/ (NetworkMessage)
|-- rmi/                                  # Distributed RMI module
|   `-- src/com/shopsphere/rmi/
|       |-- remote/ (InventoryService)
|       |-- server/ (InventoryServiceImpl)
|       `-- client/ (RmiInventoryClient)
`-- web/                                  # Jakarta Servlet 6.1 + JSP web app
    `-- src/main/
        |-- java/com/shopsphere/
        |   |-- controller/               # Login, Register, Product, Cart, Checkout, etc.
        |   |-- service/                  # Business logic (Checkout, Order, Product)
        |   |-- dao/                      # JDBC PreparedStatement DAOs
        |   |-- model/                    # Serializable POJOs
        |   |-- filter/                   # Authentication & Admin filters
        |   |-- listener/                 # AppListener (ServletContext & HttpSession)
        |   |-- util/                     # DBUtil, I18nDemo, JndiDemo, ProtocolHandlerDemo
        |   `-- server/                   # Main (Embedded Tomcat 11 launcher)
        |-- resources/
        |   |-- db.properties             # DB configuration
        |   |-- messages_en.properties    # English I18N bundle
        |   `-- messages_hi.properties    # Hindi I18N bundle
        `-- webapp/
            |-- index.jsp                 # Modern landing page
            |-- login.jsp, register.jsp   # Authentication views
            |-- products.jsp              # Catalog with faceted search & filter
            |-- product-details.jsp       # Details, reviews, ratings, wishlist
            |-- cart.jsp, checkout.jsp    # Cart and server-side checkout
            |-- orders.jsp, profile.jsp   # Customer dashboard and history
            |-- admin/                    # Admin portal views (Dashboard, Products, Orders)
            |-- syllabus/                 # Viva demonstration interactive pages
            |-- fragments/                # header.jsp, navbar.jsp, footer.jsp
            `-- WEB-INF/tags/             # productCard.tag, rating.tag
Releases
No releases published
Contributors
1
 (1)
ajaysinghbhati
ajaysinghbhati
Languages
Java
56.1%
HTML
42.5%
Other
1.4%
