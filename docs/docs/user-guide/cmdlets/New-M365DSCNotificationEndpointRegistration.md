﻿# New-M365DSCNotificationEndPointRegistration

## Description

This function attempts to register a new notification endpoint in registry.

## Output

This function does not generate any output.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| Url | True | String |  |  | Represents the Url of the endpoint to be contacted when events are detected. |
| EventType | True | String |  |  Drift, Error, Warning | Represents the type of events that need to be reported to the endpoint. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`New-M365DSCNotificationEndPointRegistration -Url https://contoso.com/api/ -EventType Drift`


