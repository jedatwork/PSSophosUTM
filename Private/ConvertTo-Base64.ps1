function ConvertTo-Base64{
    Param(
    [Parameter(Mandatory=$true, Position=1)]
    [string]$String
    )

    $bytes = [System.Text.Encoding]::Unicode.GetBytes($string)
    return [System.Convert]::ToBase64String($bytes)
}