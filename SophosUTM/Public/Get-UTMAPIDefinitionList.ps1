
<#
.SYNOPSIS
Returns all available api definitions from the root of the Sophos Server

.DESCRIPTION
Returns all available api definitions from the root of the Sophos Server
.EXAMPLE
>
Get-UTMAPIDefinitionList
Gets a list of objects that can be investigated further for 

.OUTPUTS
PSObject

.NOTES

#>
function Get-UTMAPIDefinitionList{
    Param(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$SophosBaseURL
    )
    $request = Invoke-SophosRequest -Uri "$SophosBaseURL/api/definitions" -Method GET

    return $request.name
}