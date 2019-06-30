# 🍻🚰📦 mongodb@3.6 `ephemeralForTest` config Homebrew Tap

## Overview
It's an empty formula. It creates a config file for mongodb test DB which is super useful if you run your tests locally. The only purpose of this formula is to have a service in `brew services` so the test mongodb server can be started in parallel with normal DB and managed as normal mongodb server.

## Requirements

Since this formula doesn't contain mongodb itself it requires mongodb 3.6 to be installed. It specified in the formula requirements so it will be installed automatically if not exists.

## Config

It creates the following config file. By default mongodb uses port `27017`, so the test server will use `27018`
```
systemLog:
  destination: file
  path: "/dev/null"
  logAppend: false
  quiet: true
storage:
  dbPath: #{var}/mongodb-test36
  engine: ephemeralForTest
  journal:
    enabled: false
net:
  bindIp: 127.0.0.1
  port: 27018
```


## Installation
```
brew tap sensorsasha/mongodb-test36
brew install mongodb-test36

# Run
brew services start mongodb-test@3.6
```
