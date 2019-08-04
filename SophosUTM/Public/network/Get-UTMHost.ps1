<#
.SYNOPSIS
Get the Host Definitiion back for the specific Host reference

.DESCRIPTION
Get the Host Definitiion back for the specific Host reference

.PARAMETER SophosBaseURL
The https://<ip>:port of your sophos device without a trailing slash

.PARAMETER HostRef
The REF applied to the host by Sophos (if you don't know use Get-UTMHostList to see samples)

.PARAMETER ApiToken
The API token created for your user account

.EXAMPLE
>
Get-UTMHost -SohoseBaseURL https://sophos.mydomain.com:4444 -HostRef REF_NetHosFiles -ApiToken $myToken
Return the network host object defined as REF_NetHosFiles

.OUTPUTS
PSObject

.NOTES

#>
function Get-UTMHost{
    Param(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$SophosBaseURL,
    [Parameter(Mandatory=$true, Position=2)]
    [string]$HostRef,
    [Parameter(Mandatory=$true, Position=3)]
    [string]$ApiToken
    )

    $headers = Get-UTMHeadersAccept

    $request = Invoke-SophosRequest -Uri "$SophosBaseURL/api/objects/network/host/$HostRef" -Headers $headers -Method GET -ApiToken $Apitoken

    return $request
}