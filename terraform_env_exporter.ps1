aws sso login;
pause
write-host "Calling s3 ls to generate the cli cache file so we can parse it"
aws s3 ls;
write-host "Now extracting the data from the file and exporting into environment variables"
foreach ($item in get-childitem $env:USERPROFILE\.aws\cli\cache\){
	foreach ($key in get-content $env:USERPROFILE\.aws\cli\cache\$item | convertfrom-json){
		if ($key.Credentials.AccessKeyId){$env:AWS_ACCESS_KEY_ID=$key.Credentials.AccessKeyId}
		if ($key.Credentials.SecretAccessKey){$env:AWS_SECRET_ACCESS_KEY=$key.Credentials.SecretAccessKey}
		if ($key.Credentials.SessionToken){$env:AWS_SESSION_TOKEN=$key.Credentials.SessionToken}
	}
}