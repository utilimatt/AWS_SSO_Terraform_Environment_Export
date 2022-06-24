write-host "Checking for already exported credentials"
if ($env:AWS_ACCESS_KEY_ID){
    Write-Host "Found pre-existing access key"
    Write-Host "Destroying AWS environment variables before continuing"
    Remove-Item env:\AWS_ACCESS_KEY_ID
    Remove-Item env:\AWS_SECRET_ACCESS_KEY
    Remove-Item env:\AWS_SESSION_TOKEN
    Write-Host "Destroying the ~/.aws sso & cli cache directories to allow for new creds to write without issue"
    $cli_path= Join-Path $env:USERPROFILE (Join-Path .aws cli)
    $cli_cache_path = Join-Path $cli_path cache
    $sso_path= Join-Path $env:USERPROFILE (Join-Path .aws sso)
    $sso_cache_path = Join-Path $sso_path cache
    Remove-Item $cli_cache_path
    Remove-Item $sso_cache_path
    Write-Host "Continuing with login..."
}
aws sso login;
# Placed a pause in here to make sure the login process is complete before exporting the new creds
pause
write-host "Calling s3 ls to generate the cli cache file so we can parse it"
aws s3 ls;
pause
write-host "Now extracting the data from the file and exporting into environment variables"
foreach ($item in get-childitem $cli_cache_path){
	foreach ($key in get-content (Join-Path $cli_cache_path $item) | convertfrom-json){
		if ($key.Credentials.AccessKeyId){$env:AWS_ACCESS_KEY_ID=$key.Credentials.AccessKeyId}
		if ($key.Credentials.SecretAccessKey){$env:AWS_SECRET_ACCESS_KEY=$key.Credentials.SecretAccessKey}
		if ($key.Credentials.SessionToken){$env:AWS_SESSION_TOKEN=$key.Credentials.SessionToken}
	}
}
