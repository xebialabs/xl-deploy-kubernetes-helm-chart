---
sidebar_position: 15
---

:::caution
This is internal documentation. This document can be used only if it was recommended by the Support Team.
:::

#  Manual integration with the Identity Service

## Prerequisites
- There is an account in the platform to connect to the Deploy instance (https://demoaccount.staging.digital.ai)
- There is an admin user (role `account-admin`) in the account that can be used to configure the Deploy client (contact Kraken team)

## 1. Adding the Deploy client
1. Log into the Identity Service account you want to connect to Deploy using an admin user for that account
2. Go to Admin > Clients > Add OIDC Client
3. Give the client a name (e.g. deploy)
4. Scroll down to “Valid Redirect URIs” and add
```text
<deploy url>/login/external-login
```
5. Save the client

## 2. Configuring Deploy
In CR file disable Keycloak and update OIDC properties:
```yaml
  oidc:
    enabled: true
    clientId: "<client_id>"
    clientSecret: "<client secret>"
    external: true
    issuer: "https://identity.staging.digital.ai/auth/realms/demoaccount"
    redirectUri: "<deploy url>/login/external-login"
    postLogoutRedirectUri: "<deploy url>/login/external-login"
    rolesClaimName: "realm_access.roles"
    userNameClaimName: preferred_username
    scopes: ["openid"]
```
To find the client id and secret, edit the Deploy client created above, scroll down to the Credentials section, and copy the values from there.

issuer can be found in the Identity Service Client section, in OIDC config that can be downloaded from there.

To check rolesClaimName value, decode the ID token.
[Here](https://docs.xebialabs.com/v.22.2/deploy/concept/deploy-oidc-with-keycloak/#test-public-rest-apis) you can find how to fetch token.
Use [jwt](https://jwt.io/) to decode ID token. Get the roles path from decoded value - this is rolesClaimName.

## 3. Deploy XLD
1. Deploy XLD and navigate to the Deploy site in the browser. Log in with `admin` user and add the role(s) from the Identity Service user to XLD as a principal. For example, if you are using user with `account-admin` role, this role should be added as principal. 
2. Go to Global permissions in XLD and give needed permissions. For admin it will be `admin` and `login` permissions.
2. Log in to the XLD with user from the Identity Service.
