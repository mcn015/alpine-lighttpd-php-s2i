Simple HTTP server in Alpine using lighttpd (with PHP 7)
========================================================


 First check images in Docker. Execute from local dir

```
docker build -t alpine-lighttpd-php-s2i .
docker run -ti -p 8080:8080 --rm --name tmp --entrypoint /bin/bash alpine-lighttpd-php-s2i
```

Use S2I builder image to build an application image, cloned from:

https://github.com/mcn015/static-web-site
(execute in image folder)

```
s2i build . alpine-lighttpd-php-s2i static-web-site
docker run -ti -p 8080:8080 --rm --name tmp --entrypoint /bin/bash static-web-site
```
if your S2I app executes without errors, then commit your repositories to GitHub and

--------- Build in OpenShift -------------

login as admin
```
oc login -u system:admin
oc project openshift
```
build template and edit image stream
```
oc new-build --name simple-http-server --strategy=docker --code https://github.com/mcn015/alpine-lighttpd-php-s2i
```

```
oc create -f https://raw.githubusercontent.com/mcn015/simple-http-server/master/imagestream.json
```
    or
```
oc edit is/simple-http-server -o json
```
 Create new application.
 Login as your user in your project.

```
oc new-app simple-http-server~https://github.com/mcn015/static-web-site
```
