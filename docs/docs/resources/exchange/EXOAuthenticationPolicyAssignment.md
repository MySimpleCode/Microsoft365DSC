﻿# EXOAuthenticationPolicyAssignment

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **UserName** | Key | String | Name of the user assigned to the authentication policy. ||
| **AuthenticationPolicyName** | Write | String | Name of the authentication policy. ||
| **Ensure** | Write | String | Specify if the authentication Policy should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. ||

# EXOAuthenticationPolicyAssignment

### Description

This resource assigns Exchange Online Authentication Policies to users.

## Examples

### Example 1


```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $EXOAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOAuthenticationPolicyAssignment 'ConfigureAuthenticationPolicyAssignment'
        {
            UserName                 = "John.Smith"
            AuthenticationPolicyName = "Test Policy"
            Ensure                   = "Present"
            Credential               = $EXOAdmin
        }
    }
}
```

