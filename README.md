# GetHub
An app that fetches users data from GitHub API and display it to the user

:warning:  **For the app work as expected**:

1. Generate a new token from GitHub website by going to:

Settings -> Developer Settings -> Personal access tokens -> Generate new token

2. Replace the token in APIService.swift with your newly generated token both in line 20 and line 42

request.addValue("Bearer YOUR_TOKEN_GOES_HERE", forHTTPHeaderField: "Authorization")

![alt text](https://imgur.com/ip8O5RM)

