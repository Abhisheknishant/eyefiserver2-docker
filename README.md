# EyeFi Server 2 for Docker
![Travis CI badge](https://travis-ci.org/nikkoura/eyefiserver2-docker.svg?branch=master)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

Eye-Fi SD cards are designed to upload pictures and videos from your digital camera to a computer, using wifi.
Initially these cards were supposed to work with the manufacturer's software, both on a local computer and on a cloud 
service.

Unfortunately the cloud service has been discontinued, then the manufacturer shut down; there is no longer an official 
support for the existing hardware.

Several projects filled the gap and allowed the cards to remain partially functional - See [Attribution below](#Attribution).

## EyeFi theory
EyeFi SD cards, when joining a wifi network, will scan computers on this network and connect to the first one listening 
on tcp/59278. This computer will be used as an agent to which the card will attempt to upload its contents.

Several SOAP exchanges will then take place between the card and the agent, over non-encrypted HTTP.

An authentication phase will ensure that the card will not upload its files to an unknown agent; this authentication
implies that the agent know the card's wifi MAC address, and a shared secret known as the upload key.

## Obtaining the EyeFi SD card MAC address and upload key
These values can be either obtained:
- From an existing and configured Windows installation of the EyeFi software (in the `Settings.xml` file under 
`C:\Users\<user>\AppData\Roaming\Eye-FiX2` dir, or similar)
- From an existing and configured MacOS installation of the EyeFi software, using the following command:
```sqlite3 ~/Library/Application\ Support/Eyefi/Eyefi\ Mobi/offline.db 'SELECT o_mac_address, o_upload_key FROM o_devices'```
- From Linux, using the excellent [eyeconfig utility](https://github.com/hansendc/eyefi-config)
- From MacOS, using an [alternate build](https://github.com/btb/eyefi-config/tree/osx2) of the same eyeconfig utility

## Docker image repository
This image is published in the Docker Hub repository: [nikkoura/eyefiserver2](https://hub.docker.com/r/nikkoura/eyefiserver2)

## Using the docker image
### Mandatory variables
This docker image is configured by environment variables.

- `CARD_MAC`: the wifi MAC address of the SD card. Digits can be separated by colons (:), dashes (-) or be specified without separators.
- `CARD_UPLOAD_KEY`: the upload key associated with the card.

### Network
- The image port tcp/59278 must be exposed on the network where the card will connect.

### Storage
- Uploaded pictures and videos are stored in a `/uploads` directory at the root of the docker image. A writable volume
must be provided at this location.

### Sample use with images published in Docker Hub
#### Using docker-compose
```
version: '3.7'

services:
  eyefiserver:
    image: nikkoura/eyefiserver2:1.0
    restart: "no"
    ports:
      - "59278:59278"
    volumes:
      - /mydata/uploads:/uploads:rw
    environment:
      CARD_MAC: "00:11:22:33:44:55"
      CARD_UPLOAD_KEY: "1234567890abcdef1234567890abcdef"
```

#### Using docker
```
docker run --detach -p 59278:59278 -v /mydata/uploads:/uploads:rw \
        -e CARD_MAC="00:11:22:33:44:55" -e CARD_UPLOAD_KEY="1234567890abcdef1234567890abcdef" \
        nikkoura/eyefiserver2:1.0
```

### Sample use, building your own image
#### Using docker-compose
```
version: '3.7'

services:
  eyefiserver:
    build: .
    restart: "no"
    ports:
      - "59278:59278"
    volumes:
      - /mydata/uploads:/uploads:rw
    environment:
      CARD_MAC: "00:11:22:33:44:55"
      CARD_UPLOAD_KEY: "1234567890abcdef1234567890abcdef"
```

#### Using docker
```
docker build -t eyefiserver2 .
docker run --detach -p 59278:59278 -v /mydata/uploads:/uploads:rw \
        -e CARD_MAC="00:11:22:33:44:55" -e CARD_UPLOAD_KEY="1234567890abcdef1234567890abcdef" \
        eyefiserver2
```

## Attribution
This is a fork of [David Grant's EyeFI Server 2](https://github.com/dgrant/eyefiserver2), which is itself based on 
[the work of Jeff Tchang](http://returnbooleantrue.blogspot.nl/2009/01/eye-fi-standalone-server.html).