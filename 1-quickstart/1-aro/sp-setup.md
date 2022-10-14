# Service Principal Permissions Setup for ARO automated deployment

The service principal needs the following roles assigned
- In the active directory, application and user administrator permissions

  - User Administrator
    1. From the Azure Active Directory page, go to Roles and administrators. 
    1. Find user administrators
    1. Add assignment

  - Application administrator
    1. Select the created service principal and assign role
    1. Find Application administrator
    1. Add assignment
    1. Select the created service principal and assign role

- In the subscription, application and user administrator
  - User Administrator
    1. Go to the subscription page.
    1. Select Access Control (IAM)
    1. Review Role assignments
    1. Add role (+ Add)
    1. Select "Add role assignment"
    1. Search for User Access Administrator
    1. Go to Members
    1. Select Members (+ Select Members)
    1. Choose the service principal
    1. Review and assign

  - Application Administrator
    1. Go to the subscription page.
    1. Select Access Control (IAM)
    1. Review Role assignments
    1. Add role (+ Add)
    1. Select "Add role assignment"
    1. Search for Application Administrator
    1. Go to Members
    1. Select Members (+ Select Members)
    1. Choose the service principal
    1. Review and assign