FROM node:21-alpine as dependencies
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install


FROM node:21-alpine as builder
WORKDIR /app

RUN npm install -g @angular/cli

COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

RUN npm run build


FROM node:21-alpine as runner
WORKDIR /app

RUN npm install -g @angular/cli

COPY package.json package-lock.json ./

RUN npm install --production

COPY --from=builder /app/dist ./dist

CMD ["npm", "start"]
