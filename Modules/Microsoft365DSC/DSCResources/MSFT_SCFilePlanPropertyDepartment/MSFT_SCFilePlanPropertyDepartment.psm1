function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Getting configuration of SCFilePlanPropertyDepartment for $Name"
    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion


    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        $property = Get-FilePlanPropertyDepartment -ErrorAction Stop | Where-Object -FilterScript { $_.DisplayName -eq $Name }

        if ($null -eq $property)
        {
            Write-Verbose -Message "SCFilePlanPropertyDepartment $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            Write-Verbose "Found existing SCFilePlanPropertyDepartment $($Name)"

            $result = @{
                Name       = $property.DisplayName
                Credential = $Credential
                Ensure     = 'Present'
            }

            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Setting configuration of SCFilePlanPropertyDepartment for $Name"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

    $Current = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $Current.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove('Credential') | Out-Null
        $CreationParams.Remove('Ensure') | Out-Null

        New-FilePlanPropertyDepartment @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $Current.Ensure))
    {
        # Do Nothing
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $Current.Ensure))
    {
        try
        {
            $property = Get-FilePlanPropertyDepartment | Where-Object -FilterScript { $_.DisplayName -eq $Name }
            if ($property.Mode.ToString() -ne 'PendingDeletion')
            {
                Remove-FilePlanPropertyDepartment -Identity $Name -Confirm:$false -ErrorAction Stop
            }
            else
            {
                Write-Verbose -Message "Property $Name is already in the process of being deleted."
            }
        }
        catch
        {
            New-M365DSCLogEntry  -Message $_ `
                -Exception $_ `
                -Source $MyInvocation.MyCommand.ModuleName
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of SCFilePlanPropertyDEpartment for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$Properties = Get-FilePlanPropertyDepartment -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Properties.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($Property in $Properties)
        {
            Write-Host "    |---[$i/$($Properties.Length)] $($Property.Name)" -NoNewline
            $Params = @{
                Name       = $Property.DisplayName
                Credential = $Credential
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
