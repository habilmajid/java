# Built and tested locally against Boost 1.83 (Ubuntu 24.04).
FROM ubuntu:24.04 AS build
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    g++ cmake make libboost1.83-dev libsqlite3-dev libpq-dev libssl-dev ca-certificates \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY CMakeLists.txt ./
COPY src/ ./src/
RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build -j 2

FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    libsqlite3-0 libpq5 libssl3t64 ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --uid 10001 zss
WORKDIR /app
COPY --from=build /src/build/school_server /app/school_server
COPY public/ /app/public/
USER zss
ENV PORT=10000
EXPOSE 10000
CMD ["/app/school_server"]
