
<#
.SYNOPSIS
Returns all available api definitions for the specified UTM resource

.DESCRIPTION
Returns all available api definitions for the specified UTM resource
.EXAMPLE
>
Get-UTMResourceAPIDefinitionList
Gets a list of APIs available for the specified resource

.OUTPUTS
PSObject

.NOTES

#>
function Get-UTMResourceAPIDefinitionList{
    Param(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$SophosBaseURL,
    [Parameter(Mandatory=$true, Position=2)]
    [string]$ResourceName
    )
    $request = Invoke-SophosRequest -Uri "$SophosBaseURL/api/definitions/$ResourceName" -Method GET

    # create a list that we can add the resources objects to
    $objectList = New-Object System.Collections.Generic.List[string]

    $results = ConvertFrom-Json $request

    # the content returns the objects in an array called paths, the paths array returns as 
    # a psobject instead of an array, so we need to use Get-Member to get a list of all of the
    # keys that should be associated with it. If we don't filter where name is like /* then we
    # will also get methods returned like Equals, GetType, ToString, etc..
    foreach ($object in ($results.paths | Get-Member | Select-Object name | Where-Object {$_.name -like "/*"})){
        # add the 
        $objectList.Add($object.Name)
    }

    return $objectList
}