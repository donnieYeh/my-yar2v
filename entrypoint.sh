#!/bin/sh

# Global variables
DIR_CONFIG="/etc/yar2v"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

# Write yar2v configuration
cat << EOF > ${DIR_TMP}/heroku.json
{
    "inbounds": [{
        "port": ${PORT},
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "${ID}",
                "alterId": ${PWD}
            }]
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "${WSPATH}"
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

# Get yar2v executable release
mv /opt/yar2v.zip ${DIR_TMP}/yar2v.zip
busybox unzip ${DIR_TMP}/yar2v.zip -d ${DIR_TMP}
cat ${DIR_TMP}/heroku.json
chmod 755 ${DIR_TMP}/yar2v ${DIR_TMP}/ltc2v

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
${DIR_TMP}/ltc2v config ${DIR_TMP}/heroku.json > ${DIR_CONFIG}/config.pb

# Install yar2v
install -m 755 ${DIR_TMP}/yar2v ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run yar2v
${DIR_RUNTIME}/yar2v -config=${DIR_CONFIG}/config.pb
