<#
.SYNOPSIS
Creates a new Network Host in Sophos (only supports IPv4)

.DESCRIPTION
Creates a new Network Host in Sophos (only supports IPv4)

.PARAMETER SophosBaseURL
The https://<ip>:port of your sophos device without a trailing slash

.PARAMETER IpAddress
The ip address to assign to the host

.PARAMETER Name
This is the display name of the host in the Web UI

.PARAMETER HostNames
A string array of hostnames to associate with the host

.PARAMETER MacAddresses
A string array of MAC addresses to associate with the host
    
.PARAMETER InterfaceReference
The REF from Sophos to assign to the device (use Get-UTMHostList first if you are unsure)

.PARAMETER ResolveDNS
boolean value about whether DNS should resolve

.PARAMETER ReverseDNS
boolean value about whether Sophos should do reverse dns lookups

.PARAMETER ApiToken
The API token created for your user account

.PARAMETER Comment
An optional value to add to the comment field

.EXAMPLE
>
New-UTMHost -SophosBaseURL $sophosBase -IpAddress 10.10.10.10 -Name MediaServer -HostNames @("media") -MacAddresses @("00:00:00:00:00:00") -InterfaceReference REF_DefaultInternal -ResolveDNS $true -ReverseDNS $true -ApiToken $apiToken -Comment "DLNA Server"

Creates a new host displayed as MediaServer that will resolve as media

.OUTPUTS
PSObject

.NOTES

#>
function New-UTMHost{
    Param(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$SophosBaseURL,
    [Parameter(Mandatory=$true, Position=2)]
    [string]$IpAddress,
    [Parameter(Mandatory=$true, Position=3)]
    [string]$Name,
    [Parameter(Mandatory=$true, Position=4)]
    [string[]]$HostNames,
    [Parameter(Mandatory=$true, Position=5)]
    [string[]]$MacAddresses,
    [Parameter(Mandatory=$true, Position=6)]
    [string]$InterfaceReference,
    [Parameter(Mandatory=$true, Position=7)]
    [bool]$ResolveDNS,
    [Parameter(Mandatory=$true, Position=8)]
    [bool]$ReverseDNS,
    [Parameter(Mandatory=$true, Position=9)]
    [string]$ApiToken,
    [Parameter(Mandatory=$false, Position=10)]
    [string]$Comment=""
    )

    $hostObject = New-Object psobject
    $hostObject | Add-Member -MemberType NoteProperty -Name address -Value $IpAddress
    $hostObject | Add-Member -MemberType NoteProperty -Name address6 -Value ""
    $hostObject | Add-Member -MemberType NoteProperty -Name comment -Value $Comment
    $hostObject | Add-Member -MemberType NoteProperty -Name duid -Value @()
    $hostObject | Add-Member -MemberType NoteProperty -Name hostnames -Value $HostNames
    $hostObject | Add-Member -MemberType NoteProperty -Name interface -Value $InterfaceReference
    $hostObject | Add-Member -MemberType NoteProperty -Name macs -Value $MacAddresses
    $hostObject | Add-Member -MemberType NoteProperty -Name name -Value $Name
    $hostObject | Add-Member -MemberType NoteProperty -Name resolved -Value $ResolveDNS
    $hostObject | Add-Member -MemberType NoteProperty -Name resolved6 -Value $false
    $hostObject | Add-Member -MemberType NoteProperty -Name reverse_dns -Value $ReverseDNS
    
    $body = ConvertTo-Json $hostObject
    $headers = Get-UTMHeadersContentAccept

    Invoke-SophosRequest -Uri "$SophosBaseURL/api/objects/network/host/" -Method Post -ApiToken $ApiToken -Body $body -Headers $headers

}