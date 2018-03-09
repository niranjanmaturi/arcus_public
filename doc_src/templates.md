# Managing Templates

## What are templates?

Templates contain instructions specific to the detailed API endpoint you are trying to access. This includes the relative path to the endpoint, any payload that needs to be included with the request, and how to parse the data that is returned from the endpoint.

## Template Fields

**Device type**: The Device Type for this template.

**Name**: The internal name for this template.

**Description**: Internal field used to assist other users to know what this template does and the information it returns.

**URL**: The path (relative to the base URL of the device) used when sending the request to the device.

> **Note**: This is a relative path that gets appended to the end of the device Base URL / IP

**HTTP method**: The type of HTTP method to use when sending the request (get or post).

**Body**: If the device needs information in the body of the request, enter it here. (e.g. XML or JSON)

**Populate Request Headers**: When sending a request you can include headers with it. These are key-value pairs, following the HTTP paradigm

**Transformation**: The XSLT transformation that is to occur when the template gets applied in a device type step.

### Header Fields

**Header Name**: The name of the HTTP header.

**Header Value**: The value of the HTTP header.

## Administering Templates

### Creating a Template

1. Choose **Templates** from the left navigation menu
2. Click the **New Template** button
3. Choose the appropriate device type for the device (If the appropriate device type does not exist for this device, create a new device type for this class of device)
4. Enter a unique name to describe the template
5. Enter a description (optional). This is used to help other users of the system know the purpose of the template.
6. Enter the relative URL of the endpoint to access the data from.
7. Select the HTTP method to use to retrieve the data (get or post)
8. Enter the body that should be passed to the service during the request (mainly used when retrieving data with POST)
9. Add additional headers to pass in the request, if needed.
10. Enter a valid XSLT in the "Transformation" section. For details on how to create a transformation, see the instructions [below](#xslt-template-transformation-language).
11. Click the **Create Template** button.

### Viewing all Templates

1. Choose **Templates** from the left navigation menu to view a list of all templates

### Changing a Template

1. Choose **Templates** from the left navigation menu
1. Click the **Edit** button matching the template you wish to change

You can change all of the information available for a device.

### Removing a Template

1. Choose **Template** from the left navigation menu
1. Click the **Delete** button matching the template you wish to remove

(**Note**: Once removed, the only way to restore the template is to create it by following the instructions for [Creating a Template](#creating-a-template))

## Templates and Device Types

Both Templates and Devices belong to a Device Type. A Template can be used to return data for any Device which shares its Device Type. Thus, it is important to use the appropriate Device Type so that Templates being written will return meaningful data for all Devices belonging to the same Device Type.

## XSLT (template transformation language)

In general, XSLT is a language for transforming XML documents into other XML documents. For Arcus, we use XSLT to retrieve results from various types of endpoints and return them in a common format.

XSLT uses XPath to find the data it requires inside the source XML document.

Our XSLTs typically follow this format:

~~~ xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/root/imdata">
    <data>
      <xsl:for-each select="imdatum">
        <xsl:sort select="fvnsVlanInstP/attributes/name"/>
        <results>
          <name><xsl:value-of select="fvnsVlanInstP/attributes/dn"/></name>
          <displayName><xsl:value-of select="fvnsVlanInstP/attributes/name"/></displayName>
        </results>
      </xsl:for-each>
    </data>
  </xsl:template>
</xsl:stylesheet>
~~~

We'll break down each component of this transformation and indicate which are fixed and which are mutable:

| Line | Explanation |
|------|-------------|
| `<?xml version="1.0" encoding="ISO-8859-1"?>` | This declares the version and encoding for the transform. In most cases, it should be used as seen here. |
| `<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">` | This opens the transform and should always be used as written here. |
| `<xsl:template match="/root/imdata">` | This is the first line of the transform and opens our template. The value of the "match" attribute can be used to dive into the returned data set to reduce repetition, or can simply be "/" to indicate the root of the returned data |
| `<data>` | Arcus uses this tag to identify where the dataset is located in the resulting XML document. Should always be written exactly as shown. |
| `<xsl:for-each select="imdatum">` | This line declares the individual elements to loop over. The XML attribute "select" should be the relative path from "match" above to the individual elements. |
| `<xsl:sort select="fvnsVlanInstP/attributes/name"/>` | By default, Arcus will return data in the same order it was provided by the source system. If you wish to enforce an alternate key to sort by, you should add this line and set the "select" attribute to the key location. |
| `<results>` | Arcus uses this tag to identify the individual results of the data set. Should always be written exactly as shown. |
| `<name><xsl:value-of select="fvnsVlanInstP/attributes/dn"/></name>` | Each "result" should contain both a "name" and a "displayName" element. The "select" attribute should be set the relative location of the attribute to fetch. |
| `<displayName><xsl:value-of select="fvnsVlanInstP/attributes/name"/></displayName>` | As with name, set the "select" attribute to the relative location to find the displayName data. |
| `</results></xsl:for-each></data></xsl:template></xsl:stylesheet>` | Close each of the elements in order. |

* **Note that "name" is the internal name to use (GUID, CIDR Block, etc...) while "displayName" is what should be displayed to the user.**

### Examples

#### Example #1 (XML Data)

With the following returned data (in XML):

~~~ xml
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<dataset>
  <hosts>
    <host>
      <name>Bins-Dicki</name>
      <internal>
        <account-id>e34667de-baad-45f3-b0c3-bcf954af93ba</account-id>
      </internal>
    </host>
    <host>
      <name>Corwin, Runte and Schumm</name>
      <internal>
        <account-id>0b0cefa7-6786-4add-a7e4-21f6b99f1d60</account-id>
      </internal>
    </host>
    <host>
      <name>Braun, Steuber and Kuphal</name>
      <internal>
        <account-id>8e63ec0a-38b6-407c-9652-0fe75dc2329e</account-id>
      </internal>
    </host>
    <host>
      <name>Lind LLC</name>
      <internal>
        <account-id>6f10eddd-b9bc-4347-8258-d1c1c7d539ab</account-id>
      </internal>
    </host>
    <host>
      <name>Ernser Group</name>
      <internal>
        <account-id>f74c899e-6324-4ffb-9241-cdc97cb45884</account-id>
      </internal>
    </host>
  </hosts>
</dataset>
~~~

The following XSLT:

~~~ xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/dataset/hosts">
    <data>
      <xsl:for-each select="host">
        <xsl:sort select="name"/>
        <results>
          <name><xsl:value-of select="internal/account-id"/></name>
          <displayName><xsl:value-of select="name"/></displayName>
        </results>
      </xsl:for-each>
    </data>
  </xsl:template>
</xsl:stylesheet>
~~~

Will return this data:

~~~ json
[
  {"name":"e34667de-baad-45f3-b0c3-bcf954af93ba","displayName":"Bins-Dicki"},
  {"name":"8e63ec0a-38b6-407c-9652-0fe75dc2329e","displayName":"Braun, Steuber and Kuphal"},
  {"name":"0b0cefa7-6786-4add-a7e4-21f6b99f1d60","displayName":"Corwin, Runte and Schumm"},
  {"name":"f74c899e-6324-4ffb-9241-cdc97cb45884","displayName":"Ernser Group"},
  {"name":"6f10eddd-b9bc-4347-8258-d1c1c7d539ab","displayName":"Lind LLC"}
]
~~~

---------

#### Example #2 (JSON Data)

With the following returned data (in JSON):

~~~ json
{
  "accounts": [
    {
      "name":"Langosh, Pfeffer and Kutch",
      "internal":{
        "account_id":"26a44c79-1627-4485-9393-a88e49655481",
        "datacenter":"GB-LDN"
      }
    },
    {
      "name":"Stamm-Zboncak",
      "internal":{
        "account_id":"26a990fb-88db-43f0-b3cf-e89267864072",
        "datacenter":"US-ARL"
      }
    },
    {
      "name":"Hirthe-Braun",
      "internal":{
        "account_id":"cf37947a-f8e9-4c0d-bdfe-50b4f0b04798",
        "datacenter":"GB-LDN"
      }
    },
    {
      "name":"Sanford Group",
      "internal":{
        "account_id":"327e73b6-8ae7-45dc-aa7a-92341d39c55e",
        "datacenter":"GB-LDN"
      }
    },
    {
      "name":"Medhurst-Keebler",
      "internal":{
        "account_id":"94f91032-0f01-49a9-9002-c912ef124605",
        "datacenter":"GB-LDN"
      }
    }
  ]
}
~~~

The following XSLT:

~~~ xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/root/accounts">
    <data>
      <xsl:for-each select="account">
        <xsl:sort select="internal/datacenter"/>
        <xsl:sort select="name" />
        <results>
          <name><xsl:value-of select="internal/account-id"/></name>
          <displayName><xsl:value-of select="internal/datacenter"/> - <xsl:value-of select="name"/></displayName>
        </results>
      </xsl:for-each>
    </data>
  </xsl:template>
</xsl:stylesheet>
~~~

Will return this data:

~~~ json
[
  {"name":"cf37947a-f8e9-4c0d-bdfe-50b4f0b04798","displayName":"GB-LDN - Hirthe-Braun"},
  {"name":"26a44c79-1627-4485-9393-a88e49655481","displayName":"GB-LDN - Langosh, Pfeffer and Kutch"},
  {"name":"94f91032-0f01-49a9-9002-c912ef124605","displayName":"GB-LDN - Medhurst-Keebler"},
  {"name":"327e73b6-8ae7-45dc-aa7a-92341d39c55e","displayName":"GB-LDN - Sanford Group"},
  {"name":"26a990fb-88db-43f0-b3cf-e89267864072","displayName":"US-ARL - Stamm-Zboncak"}
]
~~~

### External resources for learning XSLT

Other than the specific restrictions listed above (the presence of the "data", "results", "name", and "displayName" elements), Arcus supports all other features of XSLT. For more information on XSLT, please consult the following resources:

* [Hands-On XSL (from IBM)](https://www.ibm.com/developerworks/xml/library/x-hands-on-xsl/)
* [W3Schools XSLT](https://www.w3schools.com/xml/xsl_intro.asp)
* [Online XSLT Test Tool](http://xslttest.appspot.com/)

## Consuming an API

Arcus supports receiving structured data in both XML and JSON format. The returned information is parsed and then transformed using the Transformation on the template.

### XML

Data returned as XML is available to be parsed using the existing structure the endpoint returns the data with.

### JSON

Since the JSON spec does not require a top-level key to be valid, we wrap the JSON response in a "root" element before attempting to transform the data. Therefore, an XSLT written to consume JSON data should contain "root" as the first part of the select participle.

Arcus will convert underscores to dashes in keys (so "account_id" becomes "account-id")

Also, when converting arrays to XML, Arcus will make an educated guess of the single form of keys. E.g. -

With returned JSON data of the form:

~~~ json
{
  "data": {
    "items": [
      { "name": "Host 1"},
      { "name": "Host 2"},
      { "name": "Host 3"}
    ]
  }
}
~~~

To loop over the individual names, you would use the for-each string of "root/data/items/item"

However, given this structure:

~~~ json
{
  "data": {
    "host": [
      { "name": "Host 1"},
      { "name": "Host 2"},
      { "name": "Host 3"}
    ]
  }
}
~~~

You would need to use the for-each string of "root/data/host/host" since "host" is already singular.

**Note** that a key ending in "a" is a special case, since Arcus interprets an "a" ending as plural:

~~~ json
{
  "data": {
    "imdata": [
      { "name": "Host 1"},
      { "name": "Host 2"},
      { "name": "Host 3"}
    ]
  }
}
~~~

To loop over the individual names, you would use the for-each string of "root/data/imdata/imdatum"
