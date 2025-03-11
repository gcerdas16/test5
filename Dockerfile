# Fase de construcción (Builder)
FROM node:21-alpine3.18 as builder

WORKDIR /app

# Habilitar pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate
ENV PNPM_HOME=/usr/local/bin

# Copiar archivos necesarios
COPY . .

# Instalar dependencias necesarias para la compilación
RUN apk add --no-cache --virtual .gyp \
    python3 \
    make \
    g++ \
    && apk add --no-cache git \
    && pnpm install \
    && pnpm add node-fetch mime-types @ffmpeg-installer/ffmpeg fluent-ffmpeg \
    && pnpm run build \
    && apk del .gyp

# Fase de despliegue (Deploy)
FROM node:21-alpine3.18 as deploy

WORKDIR /app

ARG PORT
ENV PORT $PORT
EXPOSE $PORT

# Copiar archivos desde la fase de construcción
COPY --from=builder /app/assets ./assets
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/*.json /app/*-lock.yaml ./ 

# Habilitar pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate
ENV PNPM_HOME=/usr/local/bin

# Instalar solo dependencias de producción
RUN npm cache clean --force && pnpm install --production --ignore-scripts \
    && addgroup -g 1001 -S nodejs && adduser -S -u 1001 nodejs \
    && rm -rf $PNPM_HOME/.npm $PNPM_HOME/.node-gyp

# Comando de inicio
CMD ["npm", "start"]