﻿# SPOUserProfileProperty

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Key** | Write | String | Name of the User Profile Property. ||
| **Value** | Write | String | Value of the User Profile Property. ||
| **UserName** | Key | String | Username of the user to configure the profile properties for. E.g. John.Smith@contoso.com ||
| **Properties** | Write | InstanceArray[] | Array of MSFT_SPOUserProfilePropertyInstance representing the profile properties to set. ||
| **Ensure** | Write | String | Only accepted value is 'Present'. |Present|
| **Credential** | Write | PSCredential | Credentials of the Global Admin. ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. ||


# SPOUserProfileProperty

### Description

This resource allows users to configure and monitor the profile
properties of a user.

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOUserProfileProperty 'ConfigureUserProfileProperty'
        {
            UserName   = "John.Smith@contoso.com"
            Properties = @(
                MSFT_SPOUserProfilePropertyInstance
                {
                    Key   = "MyProperty"
                    Value = "MyValue"
                }
            )
            Ensure     = "Present"
            Credential = $credsGlobalAdmin
        }
    }
}
```

