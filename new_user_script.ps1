#Enter a path to your import CSV file
$ADUsers = Import-csv C:\Users\suzan\Desktop\PowerShell\creating_users.csv

# Typo in the domain name!!!!
$Organisation = "DC=ads,DC=company,DC=com"
$Classgroup = "Sales
Marketing
Human Resources
Finance
IT
Customer Service
Research and Development
Operations
Legal
Administration
Procurement
Quality Assurance
Public Relations
Training and Development
Logistics
Engineering
Production
Facilities Management
Compliance
Security
Communications
Sales Operations
Product Management
Supply Chain
Business Development
"

# Add OUs for User and for this specific group
New-ADOrganizationalUnit -Name $Classgroup -Path $Organisation -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Users" -Path "OU=$Classgroup,$Organisation" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Groups" -Path "OU=$Classgroup,$Organisation" -ProtectedFromAccidentalDeletion $false

# Add an OU for domain servers
New-ADOrganizationalUnit -Name "Servers" -Path "OU=$Classgroup,$Organisation" -ProtectedFromAccidentalDeletion $false

# Create a group for these users
New-ADGroup -Name $Classgroup -Description "PGDip Cloud 2022" -GroupCategory Security -GroupScope DomainLocal -Path "OU=Groups, OU=$Classgroup,$Organisation"

foreach ($User in $ADUsers)
{

       $Username    = $User.username
       $Password    = $User.password
       $Firstname   = $User.firstname
       $Lastname    = $User.lastname
       $Department  = $User.department
       $OU          = $User.ou

       #Check if the user account already exists in AD
       if (Get-ADUser -F {SamAccountName -eq $Username})
       {
               #If user does exist, output a warning message
               Write-Warning "A user account $Username has already exist in Active Directory."
       }
       else
       {
            #If a user does not exist then create a new user account
            #Account will be created in the OU listed in the $OU variable in the CSV file     
            New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@ads.solarsubmaines.com" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -DisplayName "$Lastname, $Firstname" `
            -Department $Department `
            -Path $OU `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force)

            # Add or change any other parameters
            Set-ADUser -Identity $Username -Description "PGDip Student" -Organization "ATU"

            # Add the user to a primary group
            Add-ADGroupMember -Identity $Classgroup -Members $Username
             
       }
}