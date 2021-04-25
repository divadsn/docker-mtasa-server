# docker-mtasa-server
Multi Theft Auto server, dockerized with Debian slim.

## Example usage
```
version: '3.3'
services:
  server:
    image: divadsn/mtasa-server:latest
    restart: unless-stopped
    ports:
      - 22003:22003/udp
      - 22005:22005/tcp
      - 22126:22126/udp
    volumes:
      - ./data:/data
      - ./resources:/resources
      - ./resource-cache:/resource-cache
      - ./native-modules:/native-modules:ro
    logging:
      driver: json-file
      options:
        max-size: 10m
```
