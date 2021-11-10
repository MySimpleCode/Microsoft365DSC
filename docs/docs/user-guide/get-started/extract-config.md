The moment you install the Microsoft365DSC module onto a machine, a new PowerShell cmdlet, **Export-M365DSCConfiguration** is made available. The Export-M365DSCConfiguration cmdlet exposes several parameters to help you customize the extraction experience. The following table lists all the parameters available:

| Parameter Name     | Type             | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | Description                                                                                                 |
|--------------------|------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| -LaunchWebUI       | Switch           | Launches a new web browser and navigates to the Web based Graphical User Interface.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Export-M365DSCConfiguration -LaunchWebUI                                                                    |
| -Credential        | PSCredential     | Specifies the credentials to use to perform the configuration's extraction. If you omit this parameter, the user will be prompted to provide credentials before executing the extraction.                                                                                                                                                                                                                                                                                                                                                                                           | $creds = Get-Credential Export-M365DSCConfiguration -Credential $creds                                      |
| -Components        | String Array     | The -ComponentsToExtract parameter allows you to specify a granular list of components you wish to extract. The components need to be listed by their associated resource name. For a complete list of all resources supported, please refer to the List of Resources wiki pages on our GitHub repository.                                                                                                                                                                                                                                                                          | Export-M365DSCConfiguration-Components @("EXOMailboxSettings", "TEAMSCallingPolicy", "SCDLPComplianceRule") |
| -Workloads         | String Array     | The -Workloads parameter allows you to specify a list of workloads you wish to extract ALL components from. Accepted valus are: EXO - For Exchange Online O365 - For Office 365 administrative components OD - For OneDrive PP - For Power Platform SC - For Security and Compliance SPO - For SharePoint Online TEAMS - For Teams                                                                                                                                                                                                                                                  | Export-M365DSCConfiguration -Workloads @("TEAMS", "SPO")                                                    |
| -FileName          | String           | Specifies the name of the extracted .ps1 configuration file. If the -Path is not specified along with the -FileName parameter, the file will be created in the current folder where the extraction process was triggered from. If omitted, the default name will be M365TenantConfig.ps1.                                                                                                                                                                                                                                                                                           | Export-M365DSCConfiguration -FileName "MyTenantExtract.ps1"                                                 |
| -Path              | String           | Specifies the location where the extracted .ps1 configuration file will be located. If omitted, the file will be created in the current folder where the extraction process was triggered from.                                                                                                                                                                                                                                                                                                                                                                                     | Export-M365DSCConfiguration -Path "C:\DSCExtracts\"                                                         |
| -ConfigurationName | String           | Specifies the name of the configuration inside the extracted file. If omitted, the dafault value will be M365TenantConfig. This represents the actual name given to the Configuration object inside the .ps1 file extracted, and by default will always be the name of the compiled configuration folder.                                                                                                                                                                                                                                                                           | Export-M365DSCConfiguration -ConfigurationName "MyTenantConfig"                                             |
| -MaxProcesses      | Number (integer) | Certain resources support parallelism to help speed up their extraction processes. Resources such as TEAMSUser, SPOPropertyBag and SPOUserProfileProperty split up the extraction process over multiple parallel threads. By default, Microsoft365DSC will attempt to create up to 16 parallel threads. By specifying this parameter, you can control the maximum number of parallel threads these resources will spin off. Note that,as an example, if you speficy a value of 20 and that there are only 12 instances of a given resources, that only 12 threads will be spun off. | Export-M365DSCConfiguration -MaxProcesses 12                                                                |



**NOTE**: While Microsoft365DSC fully supports Multi Factor Authentication (MFA) when extracting the configuration, it does not support MFA when pushing a configuration to a target tenant (Automate).

To get a full list of all components support by Microsoft365DSC, please refer to our [Resources List](https://github.com/microsoft/Microsoft365DSC/wiki/Resources-List) on our GitHub repository.

Once the extraction completes it will prompt you to enter in a file location where the extractions will be stored. If the path entered does not exist, the tool will create it. The following files with the extracted data will be placed in the file location specified:

**ConfigurationData.psd1** contains information about the tenant, and let's you abstract additional values in your configuration (advanced topic).

**M365TenantConfig.ps1** file that represents the configuration of the tenant. This file has the information that was extracted.


<iframe width="560" height="315" src="https://www.youtube.com/embed/xkfJnyzeEnY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>