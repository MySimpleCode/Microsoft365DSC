﻿# EXOAvailabilityConfig

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **OrgWideAccount** | Key | String | Specify the OrgWideAccount for the AvailabilityConfig. ||
| **Ensure** | Write | String | Specify if the AvailabilityConfig should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. ||

# EXOAvailabilityConfig

### Description

This resource configures the Availability Config in Exchange Online.

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOAvailabilityConfig 'ConfigureAvailabilityConfig'
        {
            OrgWideAccount       = "admin@contoso.onmicrosoft.com"
            Ensure               = "Present"
            Credential           = $credsGlobalAdmin
        }
    }
}
```

