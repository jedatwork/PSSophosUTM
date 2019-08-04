# SophosUTMModule

This is a PowerShell module designed to work with PowerShell 6 and Sophos UTM devices (only tested on 9.6) and does not support PowerShell 5.
I built this for use at my home network with the idea being that I can destroy/create/modify my network rapidly in case I want to change my subnets or if I want to start device hopping.

## Table of Contents
- [Requirements](#requirements)
- [Install](#install)
- [Usage](##usage)
- [Maintaners](#maintainers)
- [Contribute](#contribute)
- [License](#license)

## Requirements
 - PowerShell 6+
 - Sophos UTM
 - UTM User with an API Token

 For information on getting setup with PowerShell 6 view their [GitHub page](https://github.com/powershell/powershell).

 For information on configuring your Sophos UTM device see their [API Docs](https://www.sophos.com/en-us/medialibrary/PDFs/documentation/UTMonAWS/Sophos-UTM-RESTful-API.pdf).

## Install
Clone or download this module and place the SophosUTM folder in one of your $env:PSModulePath directories. 
> Future plan to make available via PowerShellGet
## Usage

Import the module and use the available commands
```PowerShell
# Import module that you downloaded and didn't place in a $env:PSModulePath directory
Import-Module ~/Downloads/PSSophosUTM/SophosUTM/SophosUTM.psd1

# Import module that you copied to a folder in your $env:PSModulePath directory
Import-Module SophosUTM

# view commands available in the module
Get-Command -Module SophosUTM
```
### Examples

#### Get information about available APIs

Once the REST API is enabled the Sophos device does make a Swagger UI available for navigation as well at https://yoursophos:4444/api/definitions, but you can also get some quick output about options with the below.

```PowerShell
# get all resources available via API
Get-UTMAPIDefinitionList -SophosBaseURL $SophosBase

# get all objects available to a resource
Get-UTMResourceAPIDefinitionList -SophoseBaseURL $SophosBase -ResourceName dhcp

# get all allowed requests for an object in a resource
Get-UTMResourceObjectAPIDefinitionList -SophoseBaseURL $SophosBase -ResourceName dhcp -ObjectPath "/objects/dhcp/group/" -MethodType ALL
```

#### load records from CSV and create the DNS mappings
```powershell
$sophosBase = "https://192.168.1.1:4444"
$apiToken = "mysecrettoken"
$csv = Import-CSV ~/Downloads/macs.csv

Import-Module ~/Documents/GitHub/PSSophosUTM/SophosUTM.psd1

foreach ($thing in $csv) {                                                                       
    New-UTMHost -SophosBaseURL $sophosBase -IpAddress $thing.ip -Name $thing.dns `
        -HostNames @($thing.dns) -MacAddresses @($thing.mac) -InterfaceReference REF_DefaultInternal `
        -ResolveDNS $true -ReverseDNS $true -ApiToken $apiToken -Comment $thing.device
}
```
Sample CSV file
```csv
device,mac,ip,DNS,Category
Google - Nest Hallway,11:11:11:11:11:11,192.168.1.2,nest,IoT
Treadmill,22:22:22:22:22:22,192.168.1.3,treadmill,IoT
Amazon Fire TV - Shop,33:33:33:33:33:33,192.168.1.4,shopfiretv,Media
Google - Pixel XL,44:44:44:44:44:44,192.168.1.5,pixelxl,Mobile
iPhone - House Person 1,55:55:55:55:55:55,192.168.1.6,person1iphone,Mobile
iPhone - House Person 2,66:66:66:66:66:66,192.168.1.7,person2iphone,Mobile
```

## Maintainers

[Joel DeCou](https://github.com/jedatwork)

## Contribute

## License

[MIT](LICENSE) © Joel DeCou