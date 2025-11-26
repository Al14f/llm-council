FROM node:18-alpine AS frontend-builder

WORKDIR /app-frontend

COPY frontend/package*.json ./

RUN npm install

COPY frontend/ ./

RUN npm run build

FROM python:3.11-slim

WORKDIR /app

RUN mkdir -p /app/static
COPY --from=frontend-builder /app-frontend/dist /app/static

COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ .

ENV STATIC_DIR=/app/static

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
