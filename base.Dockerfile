FROM debian:stable-slim

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends ca-certificates sqlite3 \
    && apt-get clean
