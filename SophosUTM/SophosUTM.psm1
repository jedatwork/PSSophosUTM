# load the public and private functions into separate arrays so we can
# limit the explicit export to the public functions
$PublicFunctions = @( Get-ChildItem -Path "$PSScriptRoot/Public/" -Recurse -File -Filter "*.ps1" -ErrorAction SilentlyContinue )
$PrivateFunctions = @( Get-ChildItem -Path "$PSScriptRoot/Private/" -Recurse -File -Filter "*.ps1" -ErrorAction SilentlyContinue )

# Dot source the functions
foreach ($file in @($PublicFunctions + $PrivateFunctions)) {
    try {
        . $file.FullName
    }
    catch {
        $errorItem = [System.Management.Automation.ErrorRecord]::new(
            ([System.ArgumentException]"Function not found"),
            'Load.Function',
            [System.Management.Automation.ErrorCategory]::ObjectNotFound,
            $file
        )
        $errorItem.ErrorDetails = "Failed to import function $($file.BaseName)"
        throw $errorItem
    }
}

# Set certificates to not be ignored by default and allow users to override based on certificate error
# certificate warnings will be caught in Invoke-SophosRequest and the user will be prompted to change the preference
$Script:SophosUTMIgnoreCertificate = $false

Export-ModuleMember -Function $PublicFunctions.BaseName
