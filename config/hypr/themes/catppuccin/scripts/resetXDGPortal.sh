#!/usr/bin/env bash
sleep 1
killall xdg-desktop-portal-hyprland
killall xdg-desktop-portal-gnome
killall xdg-desktop-portal-kde
killall xdg-desktop-portal-lxqt
killall xdg-desktop-portal-wlr
killall xdg-desktop-portal
sleep 1

libDir=/usr/lib

$libDir/xdg-desktop-portal-hyprland &
sleep 2
$libDir/xdg-desktop-portal &