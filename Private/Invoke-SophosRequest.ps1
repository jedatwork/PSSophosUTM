function Invoke-SophosRequest{
    Param(
    [Parameter(Mandatory=$true, Position=1)]
    [String]$Uri,
    [Parameter(Mandatory=$true, Position=2)]
    [Microsoft.PowerShell.Commands.WebRequestMethod]$Method,
    [Parameter(Mandatory=$true, Position=3)]
    [string]$ApiToken,
    [Parameter(Mandatory=$false, Position=4)]
    [String]$Body,
    [Parameter(Mandatory=$false, Position=5)]
    $Headers
    )

    # this is a helper function that gets called to make sure we are passing the
    # correct flags along with the request
    function Send-AppropriateRequest{
        $parameters = @{ "Uri" = $Uri; "Method" = $Method; }
        if ($SophosUTMIgnoreCertificate){
            $parameters.Add("SkipCertificateCheck", $true)
        } 
        if ($null -ne $body -and $body -ne ""){
            $parameters.Add("Body", "$Body")
        }
        if ($null -ne $headers -and $headers.count -ne 0){
            Invoke-RestMethod @parameters -Headers $Headers
        } else {
            # use @ to "splat" the parameters so they get passed as flags to the request
            Invoke-RestMethod @parameters
        }
        
    }

    # try to submit the request, if it fails because of an untrusted certificate ask if we should ignore certificate warnings
    try {
        $request = Send-AppropriateRequest
    } catch {
        if ($_.Exception.Message -eq "The request was aborted: Could not create SSL/TLS secure channel." -or `
            $_.Exception.Message -eq "The underlying connection was closed: Could not establish trust relationship for the SSL/TLS secure channel." -or `
            $_.Exception.Message -eq "Peer certificate cannot be authenticated with given CA certificates" -or `
            $_.Exception.Message -like "The SSL connection could not be established*"){
                Write-Host "The certificate is not trusted. Are you using a self signed certificate and would like to ignore the warning for all requests?(y/n)"
                do {
                    $answer = Read-Host
                    if ($answer -ne "y" -and $answer -ne "n"){
                        Write-Host "Invalid input, try again with y or n"
                    }
                } until ($answer -eq "y" -or $answer -eq "n")
                
                if ($answer -eq "y"){
                    $Script:SophosUTMIgnoreCertificate = $true
                    $request = Send-AppropriateRequest
                }
        } else {
            Write-Error $_.Exception.Message
        }
    }
    return $request
}
