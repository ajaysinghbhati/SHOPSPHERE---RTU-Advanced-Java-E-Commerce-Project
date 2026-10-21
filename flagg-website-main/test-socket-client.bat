@echo off
title ShopSphere - java.net Socket Client Test
echo =================================================================
echo Running java.net Socket Inventory Client Test (Port 9090)
echo =================================================================
set "CP=web/src/main/webapp/WEB-INF/classes;lib/*"
java -cp "%CP%" com.shopsphere.network.client.ShopSphereInventoryClient
pause
