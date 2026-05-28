#stage 1

FROM  node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci 

COPY . .

RUN npm run build


#stage 2

FROM nginx:alpine

Copy nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
CMD curl -f http://localhost || exit 1

CMD ["nginx","-g","daemon off;"]
