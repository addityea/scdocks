FROM ghcr.io/prefix-dev/pixi:latest AS build

RUN mkdir -p /app
# copy source code, pixi.toml and pixi.lock to the container
COPY pixi.toml /app
COPY pixi.lock /app
WORKDIR /app
# run the `install` command (or any other). This will also install the dependencies into `/app/.pixi`
# assumes that you have a `prod` environment defined in your pixi.toml
RUN pixi install
# Create the shell-hook bash script to activate the environment
RUN pixi shell-hook > /shell-hook.sh

# extend the shell-hook script to run the command passed to the container
RUN echo 'exec "$@"' >> /shell-hook.sh

FROM ubuntu:latest AS production
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev

# Remove cached files to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
# only copy the production environment into prod container
# please note that the "prefix" (path) needs to stay the same as in the build container
COPY --from=build /app/.pixi/envs/default /app/.pixi/envs/default
ENV PATH="/app/.pixi/envs/default/bin:${PATH}"
COPY --from=build /shell-hook.sh /shell-hook.sh
WORKDIR /work

# set the entrypoint to the shell-hook script (activate the environment and run the command)
# no more pixi needed in the prod container
ENTRYPOINT ["/bin/bash", "/shell-hook.sh"]
