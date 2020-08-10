#!/bin/bash
#
# under step 4 (generate CSR) you can also use a static configuration file, an example of which can be found in SelfSignCertGen.conf
#
#
#import vars from ~/.creds
. .creds

KEYLENGTH=4096
#new key name
NODENAME=node1
DOMAIN=mydomain.com
KEYNAME=${NODENAME}.${DOMAIN}
export "SITENAME=${KEYNAME}"
# verify nodename
echo $KEYNAME, $KEYLENGTH, $OUT_PASS

# ${KEYNAME}
# make key
echo "*************Generate Key*************"
openssl genrsa -des3 -passout pass:${OUT_PASS}  -out ${KEYNAME}.key ${KEYLENGTH}

# prepare key for password removal
echo "*************Copy to New Name*************"
mv ${KEYNAME}.key ${KEYNAME}.key.rsa

# create CSR
echo "*************Generate CSR*************"
openssl req -new  -config SelfSignCertGen.conf  -out ${KEYNAME}.csr

# create crt from csr
echo "*************Cert Output From CSR*************"
openssl x509 -req -days 1095 -in ${KEYNAME}.csr -signkey ${KEYNAME}.key.rsa -out ${KEYNAME}.crt   -passin pass:${OUT_PASS}

#
echo "************PFX File***********"
openssl pkcs12 -inkey ${KEYNAME}.key.rsa -in ${KEYNAME}.crt -export -out ${KEYNAME}.pfx  -passin pass:${OUT_PASS} -passout pass:${OUT_PASS}

echo "************PEM File***********"
openssl pkcs12 -in ${KEYNAME}.pfx -out ${KEYNAME}.pem -nodes -passin pass:${OUT_PASS}

echo "********COMPLETE*********"
