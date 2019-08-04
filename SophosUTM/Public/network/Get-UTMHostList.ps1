
<#
.SYNOPSIS
Returns a list of all network hosts in Sophos

.DESCRIPTION
Returns a list of all network hosts in Sophos

.PARAMETER SophosBaseURL
The https://<ip>:port of your sophos device without a trailing slash

.PARAMETER ApiToken
The API token created for your user account

.EXAMPLE
>
Get-UTMHostList -SohoseBaseURL https://sophos.mydomain.com:4444 -ApiToken $myToken
Returns all network hosts currently defined in sophos

.OUTPUTS
PSObject

.NOTES

#>
function Get-UTMHostList{
    Param(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$SophosBaseURL,
    [Parameter(Mandatory=$true, Position=2)]
    [string]$ApiToken
    )

    $headers = Get-UTMHeadersAccept

    $request = Invoke-SophosRequest -Uri "$SophosBaseURL/api/objects/network/host/" -Headers $headers -Method GET -ApiToken $Apitoken

    return $request
}