
# Stage 1: Build the application files
FROM alpine:3.22 AS builder

ARG BUILD_ID
ARG GIT_COMMIT

WORKDIR /app
COPY index.html .

RUN echo "Jenkins Build ID: ${BUILD_ID}" > build-info.txt \
    && echo "Git Commit: ${GIT_COMMIT}" >> build-info.txt

# Stage 2: Create a small final image
FROM nginx:alpine

ARG BUILD_ID
ARG GIT_COMMIT

LABEL build.id="${BUILD_ID}" \
      git.commit="${GIT_COMMIT}"

COPY --from=builder /app/index.html /usr/share/nginx/html/index.html
COPY --from=builder /app/build-info.txt /usr/share/nginx/html/build-info.txt

EXPOSE 80
