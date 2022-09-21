FROM klakegg/hugo:0.92.2-alpine

# To avoid "Failed to read Git log: fatal: unsafe repository" issue
RUN apk add git
RUN git config --global --add safe.directory /src

EXPOSE 1313