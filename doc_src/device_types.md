# Device Types

## What is a Device Type
A Device Type represents the make and model of a brand or class of device existing in your infrastructure. As an example, if you have a number of F5 BIG-IP LTM 7050 load balancers in use, you would create a device type representing this type of infrastructure device. By creating this device type you will be able to create individual devices for each of the 7050s deployed to your infrastructure and you will, further, be able to create templates to use to retrieve information from this device type.

## Device Types Fields

### Device Type

**Name**: A unique name that identifies this device type.

**Steps**: When querying a device, each step executes an HTTP request to the device. Steps are executed in the order they are displayed

### Step

**Step Name**: A name that identifies the step. Note that this is an internal label only.

**Apply template**: When selected, the template is applied during this step. Any settings from the template will be merged with this step's settings. If the same setting is configured in both, the template setting overrides the step setting. The template's transformation will be applied to the response body.

> **Note**: One and only one step must apply the template transformation.

**URL**: The path (relative to the base URL of the device) used when sending the request to the device.

> **Note**: This is a relative path that gets appended to the end of the device Base URL / IP

**HTTP method**: The type of HTTP method to use when sending the request (get or post).

**Body**: If the device needs information in the body of the request, enter it here. (e.g. XML or JSON)

**Basic auth**: When selected, include the basic authentication header using the device credentials.

**Populate Request Headers**: When sending a request you can include headers with it. These are key-value pairs, following the HTTP paradigm

**Set Variables**: Variables allow users to capture values from the response. This data is available to all subsequent Steps

### Header

**Header Name**: The name of the HTTP header.

**Header Value**: The value of the HTTP header.

### Variable

**Variable Name**: A name that identifies the Variable. It can be referenced in subsequent variables and steps to insert the associated value.

**Variable Source**: How the variable is set. For example, if you choose "Header", it will look in the response's headers for the data

**Variable Value**: This depends on the user's choice in "Variable Source" above

- When using **String** source: the text entered here will be the value of the variable
- When using **Header** source: enter the name of the response header that should be captured as the variable value
- When using **XPath** source: enter an XPath expression that will be evaluated against the response body. The result of the expression will be the value of the variable. The response body must be XML. For help with XPath, see the the [W3C specification](https://www.w3.org/TR/xpath/) or [MSDN examples](https://msdn.microsoft.com/en-us/library/ms256086(v=vs.110).aspx).
- When using **JSONPath** source: enter a JSONPath expression that will be evaluated against the response body. The first result of the expression will be the value of the variable. The response body must be JSON. For help with JSONPath, see the [specification](http://goessner.net/articles/JsonPath/) or this [online evaluator](http://jsonpath.com/).

## Creating a Device Type
1. Choose **Device Types** from the left navigation menu
1. Click the **New Device Type** button
1. Enter a unique name to describe the device type
1. Click the **Add New Step** button
1. Provide a step name that describes it
1. Configure the step to make the appropriate HTTP request. Details can be found in [Steps](#step)
1. Click **Add New Step** if another one is needed or click the **Create Device Type** button to save all changes

## Viewing all Device Types
1. Choose **Device Types** from the left navigation menu to view a list of all device types

From this list of device types, you can view, edit, or remove existing device types.

## Changing a Device Type
1. Choose **Device Types** from the left navigation menu
1. Click the **Edit** button matching the device type you wish to change

> **Caution**: changing any steps will affect all devices associated with this device type

## Removing a Device Type
1. Choose **Device Types** from the left navigation menu
1. Click the **Delete** button matching the device type you wish to remove

> **Note**: Device Types associated with one or more devices and/or templates can not be removed. The 'Delete' button will only be available for device types that are not associated with a device and/or template.
