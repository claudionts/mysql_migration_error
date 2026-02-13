FROM elixir:1.17.3-otp-27

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential git curl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Node for tailwind/esbuild (Phoenix assets)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get update -y && apt-get install -y --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN mix local.hex --force && mix local.rebar --force

EXPOSE 4000
