Blazegraph Setup
=================

I installed Blazegraph on an AWS EC2 instance for demo server. You can set it
up on your own machine with:

```sh
java -server -Xmx4g -jar bigdata-1.5.2-bundled.jar
```

You need a JRE for Java 7; if you are on Ubuntu, you can do the following. If
you are running something else, please submit a PR with instructions for your
platform.

```sh
sudo aptitude install openjdk-7-jre
```
