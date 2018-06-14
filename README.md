Simple HTTP server in Alpine using lighttpd (with PHP 7)
========================================================


 ##First check images in Docker. Execute from local dir

```
docker build -t alpine-lighttpd-php-s2i .
docker run -ti -p 8080:8080 --rm --name tmp --entrypoint /bin/bash alpine-lighttpd-php-s2i
```
(we installed bash to help debugging)

Use S2I builder image to build an application image, cloned from:

https://github.com/mcn015/static-web-site
(execute in image folder)

```
s2i build . alpine-lighttpd-php-s2i static-web-site
docker run -ti -p 8080:8080 --rm --name tmp --entrypoint /bin/bash static-web-site
```
if your S2I app executes without errors, then commit your repositories to GitHub and

##Build in OpenShift

login as admin
```
oc login -u system:admin
oc project openshift
```
  build template and edit image stream
```
oc new-build --name alpine-lighttpd-php-s2i --strategy=docker --code https://github.com/mcn015/alpine-lighttpd-php-s2i
```

  correct errors and build from the local directory ->
```
oc start-build alpine-lighttpd-php-s2i --from-dir=.
```

  to add the S2I image builder to the web console catalogue:
```
oc create -f https://raw.githubusercontent.com/mcn015/alpine-lighttpd-php-s2i/master/imagestream.json
```
    or
```
oc edit is/alpine-lighttpd-php-s2i -o json
```
and merge the \utags element in \uspec:
```
{
  "kind": "ImageStream",
  "apiVersion": "v1",
  "metadata": {
    "name": "alpine-lighttpd-php-s2i"
  },
  "spec": {
    "tags": [
      {
        "name": "latest",
        "annotations": {
          "tags": "builder"
        },
        "from": {
          "kind": "DockerImage",
          "name": "mcn015/alpine-lighttpd-php-s2i:latest"
        }
      }
    ]
  }
}
```
 ##Create new application.
 
 Login as your user in your project.

```
oc new-app alpine-lighttpd-php-s2i~https://github.com/mcn015/static-web-site
```

To trim your image, remember to remove 'bash' and any other debug commands
