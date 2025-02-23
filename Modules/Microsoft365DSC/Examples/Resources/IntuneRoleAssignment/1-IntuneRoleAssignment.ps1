<#
This example creates a new Intune Role Assigment.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        IntuneRoleAssignment "IntuneRoleAssignment"
        {
            Description                = "test2";
            DisplayName                = "test2";
            Ensure                     = "Present";
            Id                         = "20556aad-3d16-465a-890c-cf915ae1cd60";
            Members                    = @("");
            MembersDisplayNames        = @("SecGroup2");
            ResourceScopes             = @("6eb76881-f56f-470f-be0d-672145d3dcb1");
            ResourceScopesDisplayNames = @("");
            ScopeType				   = "resourceScope"
            RoleDefinition             = "2d00d0fd-45e9-4166-904f-b76ac5eed2c7";
            RoleDefinitionDisplayName  = "This is my role";
            Credential                 = $credsGlobalAdmin
        }
    }
}
