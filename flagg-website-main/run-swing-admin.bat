@echo off
title Flagg - Desktop Admin Management App (Swing MVC)
echo =================================================================
echo Launching Flagg Desktop Administration Portal (Swing MVC)
echo =================================================================
set "CP=web/src/main/webapp/WEB-INF/classes;lib/*"
start javaw -cp "%CP%" com.shopsphere.swing.view.LoginFrame
