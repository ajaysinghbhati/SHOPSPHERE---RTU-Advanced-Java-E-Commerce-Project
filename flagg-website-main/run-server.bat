@echo off
title Flagg - Embedded Apache Tomcat 11 Server
echo =================================================================
echo Starting Flagg E-Commerce System (Tomcat 11 + RMI + Sockets)
echo =================================================================
set "CP=web/src/main/webapp/WEB-INF/classes;lib/*"
java -cp "%CP%" com.shopsphere.server.Main
pause
