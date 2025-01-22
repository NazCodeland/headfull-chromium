# Changes from Original Repository

This document tracks the changes made to the original headfull-chromium implementation.

## Original Source

This repository is based on the [headfull-chromium project](https://github.com/piercefreeman/docker/tree/main/headfull-chromium) by Pierce Freeman, which provides package dependencies to run chromium in headfull mode with Playwright.

## Modifications

### January 22, 2025

- Major refactor to create Python-specific base image:
  - Removed Node.js specific components (Node16, npm, yarn)
  - Added Python 3.11 with Poetry package manager
  - Maintained all Playwright and VNC infrastructure
  - Kept essential tools (git, ssh) for development
  - Optimized layer caching and cleanup
  - Reduced image size by removing unnecessary dependencies

### January 20, 2025

- Initial fork created
- Modified Dockerfile:
  - Updated timezone configuration to America/Toronto for Ottawa, Ontario
  - Removed test-app directory
- Updated README.md:
  - Added acknowledgment section with link to original repository
- Added CHANGES.md to track modifications from original project