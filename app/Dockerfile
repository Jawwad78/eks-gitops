FROM alpine:3.23.3 AS build
WORKDIR /app
COPY src ./src

FROM nginx:1.28.2-alpine AS production
# change to non root user
RUN chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /etc/nginx && \
    chown -R nginx:nginx /var/log/nginx

RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

COPY --from=build /app/src ./usr/share/nginx/html
USER nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]