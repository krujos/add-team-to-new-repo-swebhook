#Github web hook to add a team on repo create
At [Pivotal](http://pivotal.io) we use this web hook to add teams who are not owners but still need commit rights to our repos every time we create one. This code runs in [Cloud Foundry](http://run.pivotal.io) and uses environment variables to source the teams to add when the web hook is called. 

This is a generic app that should serve the same need for any github org.


##Environment variables

```GITHUB_SECRET``` is the secret you expect to be sent with the web hook. If the secret does not match ``X-Hub-Signature`` in the incoming hook the request is dropped. 