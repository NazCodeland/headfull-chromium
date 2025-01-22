# headfull-chromium-poetry

Package dependencies to run chromium in headfull mode with Playwright, optimized for Python/Poetry projects.

## Acknowledgments

This project is a Python/Poetry adaptation of the original [headfull-chromium project](https://github.com/piercefreeman/docker/tree/main/headfull-chromium) by Pierce Freeman. See [CHANGES.md](CHANGES.md) for a detailed list of modifications.

Key environment variables:

- `APP_PATH`: Working directory for the docker container that houses your Python executable
- `NODE_EXEC`: The bash command to execute in order to run your control code. Examples include `python main.py` or `poetry run python src/main.py`.
- `VNC_PASSWORD`: Default password for the VNC server that controls the headfull browser.

## Client Code

This deployment could be used in remote control mode, like with [CDPSessions](https://playwright.dev/python/docs/api/class-browsertype#browser-type-launch-server). However more commonly it's used by bundling playwright and the browser runtime side-by-side. This has some advantages for chatty connections or frequent connections since it decreases network bandwidth latency.

The recommended execution pattern is therefore to build your Python project and leverage the image's entrypoint.sh file for bootup. We recommend:

- Create a Poetry project that houses your browser control code
- Build a custom dockerfile that inherits from this base image:
  ```dockerfile
  FROM nazcodeland/headfull-chromium-poetry:latest
  ```
- Set the `APP_PATH` env variable to wherever your root Python project is copied over
- Export the `NODE_EXEC` environment variable to however you want to launch your Python application

## Running

Launching in docker runs within the host namespace by default. For additional security during webcrawling we recommend launching as a [separate user](https://playwright.dev/python/docs/docker). For convenience we include a copy of the latest seccomp profile here, sourced from the original [repo](https://github.com/microsoft/playwright/blob/main/utils/docker/seccomp_profile.json).

Incorporating this security preference will depend on your method of launching this docker image.

docker CLI:
```
docker run -it --rm --ipc=host --user pwuser --security-opt seccomp=seccomp_profile.json {image} /bin/bash
```

docker-compose.yml:
```yaml
services:
  web:
    image: {image}
    security_opt:
      - seccomp:seccomp_profile.json
    ipc: host
    user: pwuser
```

## Screen Control

We expose a VNC server so you can view and control the Chrome window that Playwright is executing through a regular VNC client. This effectively makes debugging through docker the same as debugging locally. The docker image will expose the VNC server on port `5900`, which can be mounted to any local host port once you launch the container.

Example docker-compose.yml with VNC:
```yaml
services:
  web:
    image: my-python-playwright-app
    build: .
    ports:
      - "5910:5900"  # VNC port
    environment:
      VNC_PASSWORD: "mypassword"  # Default VNC password
```

You can then connect to `localhost:5910` using any VNC client. On macOS, you can use the bundled "Screen Sharing" utility. On Windows, you can use VNC Viewer or similar tools.

## Base Image

The base image is available on Docker Hub as `nazcodeland/headfull-chromium-poetry:latest`. It includes:

- Ubuntu 22.04 base
- Python 3.11
- Poetry for dependency management
- Playwright with Chromium
- VNC server for visual debugging

To use this base image in your project:
```dockerfile
FROM nazcodeland/headfull-chromium-poetry:latest

WORKDIR /app
COPY . .
```
