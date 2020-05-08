Set-ExecutionPolicy Unrestricted -Force;
wmic useraccount where "name='vagrant'" set PasswordExpires=FALSE
