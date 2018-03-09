# Devices

## What is a Device
A Device represents an individual and uniquely addressable device from your infrastructure. As an example, you could have a F5 BIG-IP LTM 7050 load balancer with the IP address 192.168.1.1 represented by a device in Arcus. In this context, the device contains all of the information necessary to send requests to the device to collect information from the device's APIs, including the username and password for the device's APIs and the base URL or IP address to use when contacting the device's APIs. Through the combination of a unique device and a template for the appropriate device type, you can retrieve information from the device's API.

## Device Fields
**Device type**: The Device Type for this device.

**Name**: The internal name for this device.

**Base URL/ IP**: The root path to the device (i.e. http://example.com or http://192.168.92.1). Note that all other requests are relative to this URL.

**SSL validation**: If set to false, Arcus will not verify the validity of SSL certificate when connecting to this device.

**Username**: The username that should be used to connect to the device. The Device Type determines exactly how this is transmitted to the device for authentication.

**Password**: The password that should be used to connect to the device. The Device Type determines exactly how this is transmitted to the device for authentication.

## Creating a Device
1. Choose **Devices** from the left navigation menu
1. Click the **New Device** button
1. Choose the appropriate device type for the device (If the appropriate device type does not exist for this device, create a new device type for this class of device)
1. Enter a unique name to describe the device
1. Enter the base url or IP address assigned to the device
1. When available and required, enter the username and password necessary to authenticate to the device
1. If the device allows or requires SSL validation, check the 'Ssl validation' box
1. Click the **Create Device** button

## Viewing all Devices
1. Choose **Devices** from the left navigation menu to view a list of all devices

From this list of devices, you can view, edit, or remove existing devices.

## Changing a Device
1. Choose **Devices** from the left navigation menu
1. Click the **Edit** button matching the device you wish to change

You can change all of the information available for a device.

## Removing a Device
1. Choose **Device** from the left navigation menu
1. Click the **Delete** button matching the device you wish to remove

(**Note**: Once removed, the only way to restore the device is to create it by following the instructions for [Creating a Device](#creating-a-device))
