[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
    -ChildPath '..\..\Unit' `
    -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Microsoft365.psm1' `
        -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Generic.psm1' `
        -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource 'TeamsFederationConfiguration' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1)' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'
            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                return 'FakeDSCContent'
            }

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-CsTenantFederationConfiguration -MockWith {
                return @{
                    AllowFederatedUsers       = $True
                    AllowPublicUsers          = $True
                    AllowTeamsConsumer        = $False
                    AllowTeamsConsumerInbound = $False
                    Identity                  = 'Global'
                }
            }

            Mock -CommandName Set-CsTenantFederationConfiguration -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'When settings are correctly set' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowFederatedUsers       = $True
                    AllowPublicUsers          = $True
                    AllowTeamsConsumer        = $False
                    AllowTeamsConsumerInbound = $False
                    Identity                  = 'Global'
                    Credential                = $Credential
                }
            }

            It 'Should return False for the AllowTeamsConsumer property from the Get method' {
                (Get-TargetResource @testParams).AllowTeamsConsumer | Should -Be $false
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When settings are NOT correctly set' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowFederatedUsers       = $True
                    AllowPublicUsers          = $True
                    AllowTeamsConsumer        = $True
                    AllowTeamsConsumerInbound = $True
                    Identity                  = 'Global'
                    Credential                = $Credential
                }
            }

            It 'Should return False for the AllowTeamsConsumer property from the Get method' {
                (Get-TargetResource @testParams).AllowTeamsConsumer | Should -Be $false
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Updates the Teams Federations settings in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTenantFederationConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
