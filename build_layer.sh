#!/bin/bash

set -e

# Set Chrome and ChromeDriver versions
CHROME_VERSION="134.0.6998.90"
CHROME_DRIVER_VERSION="134.0.6998.90"

# Create layer directories
mkdir -p layer/bin
mkdir -p layer/lib

# Remove any existing Chrome and ChromeDriver files in the layer directory
echo "Cleaning up existing files in layer/bin/ and layer/lib/..."
rm -rf layer/bin/chrome-linux64
rm -rf layer/bin/chromedriver-linux64
rm -rf layer/lib/*

# Download and extract Chrome
echo "Downloading Chrome version $CHROME_VERSION..."
curl -SL "https://storage.googleapis.com/chrome-for-testing-public/$CHROME_VERSION/linux64/chrome-linux64.zip" -o chrome.zip
unzip chrome.zip -d layer/bin/
rm chrome.zip
chmod +x layer/bin/chrome-linux64/chrome

# Download and extract ChromeDriver
echo "Downloading ChromeDriver version $CHROME_DRIVER_VERSION..."
curl -SL "https://storage.googleapis.com/chrome-for-testing-public/$CHROME_DRIVER_VERSION/linux64/chromedriver-linux64.zip" -o chromedriver.zip
unzip chromedriver.zip -d layer/bin/
rm chromedriver.zip
chmod +x layer/bin/chromedriver-linux64/chromedriver

echo "Install missing libraries..."

apt-get update
apt-get install -y libnss3 libnssutil3 libnspr4 libxcb1

echo "Copying required libraries to the layer (force replace)..."
cp -f /usr/lib/x86_64-linux-gnu/libnss3.so layer/lib/
cp -f /usr/lib/x86_64-linux-gnu/libnssutil3.so layer/lib/
cp -f /usr/lib/x86_64-linux-gnu/libnspr4.so layer/lib/
cp -f /usr/lib/x86_64-linux-gnu/libxcb.so.1 layer/lib/

echo "Libraries installed:"
ls -lah layer/lib/

echo "Build complete. Layer is ready."
