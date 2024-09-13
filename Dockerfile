# Stage 1: Build the Go application
FROM golang:1.18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy the go.mod and go.sum files first to leverage Docker cache
COPY go.mod go.sum ./

# Copy the entire project
COPY . .

# Build the Go app
RUN go build -o main .

RUN go mod download

# Stage 2: Use a minimal base image for the final container
FROM alpine:latest

# Set the working directory
WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app/main .

# Expose the application on port 8000
EXPOSE 8000

# Run the app
CMD ["./main"]
