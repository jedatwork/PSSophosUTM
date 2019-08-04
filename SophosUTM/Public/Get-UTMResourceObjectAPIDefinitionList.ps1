
<#
.SYNOPSIS
Returns all available api definitions for the specified UTM resource object

.DESCRIPTION
Returns all available api definitions for the specified UTM resource object
.EXAMPLE
>
Get-UTMResourceObjectAPIDefinitionList
Gets a list of APIs available for the specified resource's object

.OUTPUTS
PSObject

.NOTES

#>
function Get-UTMResourceObjectAPIDefinitionList{
    Param(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$SophosBaseURL,
    [Parameter(Mandatory=$true, Position=2)]
    [string]$ResourceName,
    [Parameter(Mandatory=$true, Position=3)]
    [string]$ObjectPath,
    [Parameter(Mandatory=$true, Position=4)]
    [ValidateSet("GET", "PUT", "POST", "ALL")]
    [string]$MethodType
    )
    $request = Invoke-SophosRequest -Uri "$SophosBaseURL/api/definitions/$ResourceName" -Method GET

    if ($MethodType -eq "ALL"){
        return $request.paths.$ObjectPath
    } else {
        return $request.paths.$ObjectPath.$MethodType
    }
}