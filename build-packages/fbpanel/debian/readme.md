# Build fbpanel into a debian package

First, make sure you have the required dependencies :
 ```
sudo apt-get install build-essential devscripts lintian
```

Step 2, copy the compiled binary into the package location 
```
debuild -i -us -uc -b # for local package
debuild -S # for source package (required by launchpad)
```
