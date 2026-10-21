@echo off
title ShopSphere - Java RMI Client Test
echo =================================================================
echo Running Java RMI Remote Inventory Client Test (Port 1099)
echo =================================================================
set "CP=web/src/main/webapp/WEB-INF/classes;lib/*"
java -cp "%CP%" com.shopsphere.rmi.client.RmiInventoryClient
pause
