This is a list of tools used to maintain packages that are provided via the PPAs . 

## Getting the source code 

### create_ap ###
wget https://github.com/oblique/create_ap/archive/v0.4.6.tar.gz
tar -xf v0.4.6.tar.gz
rm v0.4.6.tar.gz
mv create_ap-0.4.6/* createap-0.4.6/
rm -r create_ap-0.4.6


### rtl-ais ###
git clone --depth 1 https://github.com/dgiardini/rtl-ais/

### fb-panel ###
git clone https://github.com/lysmarine/fbpanel

Now every project folder should have the source code ready to be build into a debian package. 


## building a package.  
To build a package you must cd into the desired package (createap in this example)  
```
cd createap-4.0.6/
```

#### Build a complete package for direct use. 
```
debuild -us -uc
```

#### Prepare a source package for launchpad.
```
debuild -S -sa 
```

## Sending a prepared package to launchpad

Useful only if you have access to the PPA repository. 

First sign your changes with your GPG key ID : 
```
https://techoverflow.net/2019/06/08/how-to-fix-dput-error-58-gpgme_op_verify/
debsign -k [YOUR PGP FINGERPRINT] <filename>.changes
```
Then upload
```
dput ppa:lysmarine/upstream-projects
```

