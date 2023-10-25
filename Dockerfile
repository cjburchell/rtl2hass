
FROM python:3.9.18

#
# Define environment variables
# 
# Use this variable when creating a container to specify the MQTT broker host.
ENV MQTT_HOST ""
ENV MQTT_PORT 1883
ENV MQTT_USERNAME ""
ENV MQTT_PASSWORD ""
ENV MQTT_TOPIC rtl_433
ENV DISCOVERY_PREFIX homeassistant
ENV DISCOVERY_INTERVAL 600

RUN apt-get update && apt-get install --no-install-recommends -y \
  libtool \
  libusb-1.0.0-dev \
  librtlsdr-dev \
  rtl-sdr \
  && rm -rf /var/lib/apt/lists/*

#
# Install Paho-MQTT client
#
RUN pip3 install paho-mqtt

#
# Blacklist kernel modules for RTL devices
#
COPY rtl.blacklist.conf /etc/modprobe.d/rtl.blacklist.conf

#
# Copy scripts, make executable
#
COPY rtl_433_mqtt_hass.py /

#
# Execute entry script
#
ENTRYPOINT [ "python3", "rtl_433_mqtt_hass.py" ]