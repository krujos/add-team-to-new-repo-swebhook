#Github web hook to add a team on repo create
At [Pivotal](http://pivotal.io) we use this web hook to add teams who are not owners but still need commit rights to our repos every time we create one. This code runs in [Cloud Foundry](http://run.pivotal.io) (although it could run anywhere, it's just a rack app) and uses environment variables to source the teams to add when the web hook is called. 

##Getting started
* Make sure you have an account on [run.pivotal.io](http://run.pivotal.io) or other another Cloud Foundry provider. 
* Target the org and space you want to use 
  * ```cf target -o <your org> -s <your space>``` 
* Create a personal access token on [github](https://github.com/settings/tokens/new) with the admin:org permission 
* Clone this repo, export the needed environment variables, generate a manifest, push the app to [Cloud Foundry](http://run.pivotal.io)

```
➜  git  git clone https://github.com/krujos/add-team-to-new-repo-webhook                                                                                                                                     $
Cloning into 'add-team-to-new-repo-webhook'...
remote: Counting objects: 98, done.
...
➜  git  cd add-team-to-new-repo-webhook
➜  add-team-to-new-repo-webhook git:(master) export GITHUB_SECRET=<your secret>
➜  add-team-to-new-repo-webhook git:(master) export GITHUB_ACCESS_TOKEN=<your token>
➜  add-team-to-new-repo-webhook git:(master) export GITHUB_COLLABORATOR=<your team id>
➜  add-team-to-new-repo-webhook git:(master) export APP_NAME=<your app name>
➜  add-team-to-new-repo-webhook git:(master) export APP_ROUTE=<your app route, defaults to app name>
➜  add-team-to-new-repo-webhook git:(master) ./generate_manifest.sh
➜  add-team-to-new-repo-webhook git:(master) cf push
Using manifest file /Users/jkruck/git/add-team-to-new-repo-webhook/manifest.yml

Updating app my-webhook in org krujos / space development as me@example.com...
OK

Using route my-webhook.cfapps.io
Uploading my-webhook...
Uploading app files from: /Users/jkruck/git/add-team-to-new-repo-webhook
Uploading 27.2K, 13 files
OK
<snip/>
App started

Showing health and status for app my-webhook in org krujos / space development as me@example.com...
OK

requested state: started
instances: 1/1
usage: 128M x 1 instances
urls: mywebhook.cfapps.io

     state     since                    cpu    memory          disk
#0   running   2014-12-24 10:39:32 AM   0.0%   47.8M of 128M   54.1M of 1G
```

* Register your web hook at github for your org.
  * Navigate to your org's webhook settings (https://github.com/organizations/<your org>/settings/hooks)
  * Click "Add webhook"
  * Type in the URL from your push (http://mywebhook.cfapps.io)
  * Make sure "application/json" is selected as the content type. 
  * Type in the same secret that you exported above in ```GITHUB_SECRET```
  * Choose the "Let me select individual events" radio button 
  * Check repository, make sure all other events are unchecked.
  * Make sure the webhook is marked active at the bottom of the form "Add web hook"
  
##Environment variables

```GITHUB_SECRET``` is the secret you expect to be sent (sorta, read the docs and [code](./validator.rb) if you want to know how it really works) with the web hook. If the secret does not line up with what we expect based on the ``X-Hub-Signature`` header the request is dropped. 

```GITHUB_ACCESS_TOKEN``` is the personal access token to use for accessing the repo to add a collaborator. You can create a new token [here](https://github.com/settings/tokens/new). My access token has the ```admin:org``` permission. 

```GITHUB_COLLABORATOR``` is the id of the team you want to add to the new repo. You can obtain that by running ```curl https://<access_token>@api.github.com/orgs/<your_org>/teams``` and looking for the ```id``` attribute of the team you're interested in. 

```APP_NAME``` is the application name to use when pushing to Cloud Foundry. 

```APP_ROUTE``` is the subdomain to name when pushing, e.g. ``<whatever>.cfapps.io``. If this variable is not set it defaults to the app name

The app itself relies on the ```GITHUB_*``` variables and they must be set at runtime. The ``APP_*``` variables are only used to generate the manifest. 

##Manifest generator
There's a manifest generator to help with deploying the webhook consistently. We generate it because hardcoding your access key and checking it in is a bad idea. The permissions granted to this token can cause a fair bit of damage if used maliciously. The token's pretty much a password and should be guarded as such. 

```
➜  add-team-to-new-repo-webhook git:(master) ✗ export GITHUB_SECRET=secret 
➜  add-team-to-new-repo-webhook git:(master) ✗ export GITHUB_ACCESS_TOKEN=token
➜  add-team-to-new-repo-webhook git:(master) ✗ export GITHUB_COLLABORATOR=collab
➜  add-team-to-new-repo-webhook git:(master) ✗ export APP_NAME=my-webhook
➜  add-team-to-new-repo-webhook git:(master) ✗ export APP_ROUTE=webhook
➜  add-team-to-new-repo-webhook git:(master) ✗ ./generate_manifest.sh
➜  add-team-to-new-repo-webhook git:(master) ✗ cat manifest.yml
applications:
- name: my-webhook
  memory: 128M
  host: webhook

  env:
     GITHUB_SECRET: secret
     GITHUB_ACCESS_TOKEN: token
     GITHUB_COLLABORATOR: collab
```