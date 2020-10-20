## Oauth2 Grant Types!

## What is Grant Type ?
Grant type is a special way to get the access token to the resource.
Each grant type is designed for a different purpose. Whether it is Web app , mobile , desktop or server-server communication. 

### Password
The password grant type is the simplest one. Only requires one step.
Hit the /oauth/token endpoint with post request presented below
	
	POST ${YOUR_AUTH_SERVER}/oauth/token
	Content-type: application/x-www-form-urlencoded
	
	?grant_type=password
	&username=user1
	&password=password1
	&client_id=client1
	&client_secret=secret1

 - **grant_type** - Tells server we are using password grant type
 - **username** - username of a given user
 - **password** - password of a given user
 - **client_id** - The identifier of the application that the developer registered in auth server
 - **client_secret** - The "password" of given application that the developer registered in auth secret. This parameter is optional but In some cases when the client is "confidential" other words speaking not public, we have to include it also.
 - **scope** - (optional) If application is requesting for a token with limited scope

Response from the server looks like:
```
{
	"access_token": "2b658417-223e-4ec8-b18b-d50a95e45f53",
	"token_type": "bearer",
	"refresh_token": "617bdc66-bb44-4900-8985-904f1c1d8c84",
	"expires_in": 43171,
	"scope": "read"
}
```
#### When to use it ?
A common use for this grant type is to enable password logins for your service’s own apps. Users won’t be surprised to log in to the service’s website or native application using their username and password, but third-party apps should never be allowed to ask the user for their password.

### Authorization Code
The most common used grant type.
Code flow is used in web and mobile apps.
It differs from most of the other grant types by first requiring the app launch a browser to begin the flow. That means a user is redirected to auth server and is asked for permission, when everything is correct user is redirected with code which given app is going to exchange with auth server for access_token.

Auth is all about enabling user access to some kind of resource.
To begin the auth flow, first we have to determine the details of permission.

	GET ${YOUR_AUTH_SERVER}/oauth/authorize?response_type=code
		&client_id=client2
		&scope=read
		&state=state
		&redirect_uri=${YOUR_CLIENT}/auth/code

 - **respone_type** - We have to tell the auth server that we want to start the Authorization Code flow
 - **client_id** - The identifier of the application that the developer registered in auth server
 - **scope** - one or more specialised permissions the application is requesting
- **state** - The application generates a random string and includes it in the request. It should then check that the same value is returned after the user authorizes the app. This is used to prevent CSRF attacks
- **redirect_uri** - Special endpoit defined by your app which is going to retrieve the code and check if the state string is correct after they approve the request. 

User is redirected to a place where he need to allow the application to use his permissions. If everything is correct the response should look like this.
		
		${YOUR_REDIRECT_URI}/auth/token?
		code=kYpYwD
		&state=state

 - **code** - This is the code we wanted to now exchange it to access_token
 - **state** - Before anything else we have to check if the state string is the one we have generated.
 
 If anything is correct then we can finally get our access_token!
 	
 	POST ${YOUR_AUTH_SERVER}/oauth/token
	Content-type: application/x-www-form-urlencoded
	
	?grant_type=authorization_code
	&code=kYpYwD
	&client_id=client1
	&client_secret=secret1
	&redirect_uri=${YOUR_APP}/auth/code


 - **grant_type** - Tells server we are using password grant type
 - **client_id** - The identifier of the application that the developer registered in auth server
 - **client_secret** - The "password" of given application that the developer registered in auth secret. 
 - **redirect_uri**-   The same redirect URI that was used when requesting the code. Some APIs don’t require this parameter, so you’ll need to double check the documentation of the particular API you’re accessing.

Response:

	{
		"access_token": "54be0c78-87f4-41b2-917d-6c4370b7ccf8",
		"token_type": "bearer",
		"refresh_token": "bef75bc4-82d9-43fc-b848-d369f5ba1f90",
		"expires_in": 43200,
		"scope": "read"
	}

#### When to use it ?
The authorization code is the best for web and mobile apps.
Hence the Authorization Code grant has the extra step of exchanging the authorization code for the access token, it provides an additional layer of security not present in the Implicit grant type.
So authorization code is a improved version of Impicit grant type. I recommend to read something about it. I did not implement it because it is deprecated, but it is important to know the mechanism. I also found great article about it. 
[Go there](https://oauth.net/2/grant-types/implicit/) to check it out.

### Client Credentials
The Client Credentials grant is used when applications request an access token to access their own resources, not on behalf of a user.

	
	POST ${YOUR_AUTH_SERVER}/oauth/token
	Content-type: application/x-www-form-urlencoded
		
	grant_type=client_credentials
	&client_id=client3
	&client_secret=secret3

Everything goes the same
- **respone_type** - We have to tell the auth server that we want to start the Authorization Code flow
 - **client_id** - The identifier of the application that the developer registered in auth server
 - **client_secret** - The client "password" of the application that the developer registered in auth server

Response
	
	{
		"access_token": "9c4f3f9b-d681-4506-b816-9c295c618c34",
		"token_type": "bearer",
		"expires_in": 43199,
		"scope": "read"
	}

## Refresh Token

As the name suggest the Refresh token is used to refresh the access_token 
the mechanism is the same as always 
	
	POST ${YOUR_AUTH_SERVER}/oauth/token
	Content-type: application/x-www-form-urlencoded
			
		grant_type=refresh_token
		&refresh_token=bef75bc4-82d9-43fc-b848-d369f5ba1f90
		&client_id=client2
		&client_secret=secret2

Response is the same when we were issuing the access_token.

### When to use it ?
The main use of refresh_token is to reduce amount of authorisations by user.
Whenever the access_token is expired we can just call auth server to get a new one without even interrupting a current user.


Feel free to download the Authorization Server and play with it.
You can also start real quick with docker by using this command
	
	docker run -p 8080:8080 marcindev99/spring-security-as:springsecurityas

Few hints:
1. Please, review code before you hit any endpoint
2. Using Authorization Code grant type the redirect endpoint is set to http://localhost:8081/auth/token
