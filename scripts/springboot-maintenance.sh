#!/bin/bash

# Application Configuration
APP_HOME=$(dirname "$0")
APP_JAR="$APP_HOME/bin/app.jar"
LOG_FILE="$APP_HOME/logs/output.log"
PID_FILE="$APP_HOME/run/app.pid"
ENV_FILE="$APP_HOME/config/app.env"

# Create required directories if they don't exist
mkdir -p "$APP_HOME/run"
mkdir -p "$APP_HOME/logs"
mkdir -p "$APP_HOME/config"

# Load environment variables from file
load_env() {
    if [ -f "$ENV_FILE" ]; then
        echo "Loading environment variables from $ENV_FILE"
        # Export all variables in the env file
        set -a
        source "$ENV_FILE"
        set +a
        return 0
    else
        echo "ERROR: Environment file not found: $ENV_FILE"
        echo "Please create the environment configuration file before starting the application"
        echo "You can create a template with: $0 create-config"
        return 1
    fi
}

# Create a template environment file
create_config() {
    if [ -f "$ENV_FILE" ]; then
        echo "Environment file already exists: $ENV_FILE"
        return 1
    fi
    
    cat > "$ENV_FILE" << EOF
# Spring Boot Application Environment Variables
# Database Configuration
export SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/yourdb
export SPRING_DATASOURCE_USERNAME=yourusername
export SPRING_DATASOURCE_PASSWORD=yourpassword

# Server Configuration
export SERVER_PORT=8080
export SERVER_SERVLET_CONTEXT_PATH=/

# JPA Configuration
export SPRING_JPA_HIBERNATE_DDL_AUTO=update
export SPRING_JPA_SHOW_SQL=false

# Logging Configuration
export LOGGING_LEVEL_COM_YOURAPP=INFO

# Java Options
export JAVA_OPTS="-Xms256m -Xmx512m"

# Application Specific Variables
export APP_ENVIRONMENT=dev
export APP_NAME=your-spring-boot-app
EOF
    
    echo "Environment file created at $ENV_FILE"
    echo "Please edit this file with your actual configuration values"
    chmod 600 "$ENV_FILE"
}

# Set default environment variables if not already set
set_default_env() {
    # Server defaults (if not set in env file)
    : ${SERVER_PORT:=8080}
    : ${SERVER_SERVLET_CONTEXT_PATH:=/}
    
    # Java options defaults
    : ${JAVA_OPTS:="-Xms256m -Xmx512m"}
}

# Validate that required environment variables are set
validate_env() {
    local missing_vars=()
    
    # Check for required variables
    [ -z "$SPRING_DATASOURCE_URL" ] && missing_vars+=("SPRING_DATASOURCE_URL")
    [ -z "$SPRING_DATASOURCE_USERNAME" ] && missing_vars+=("SPRING_DATASOURCE_USERNAME")
    [ -z "$SPRING_DATASOURCE_PASSWORD" ] && missing_vars+=("SPRING_DATASOURCE_PASSWORD")
    
    if [ ${#missing_vars[@]} -ne 0 ]; then
        echo "ERROR: The following required environment variables are not set:"
        for var in "${missing_vars[@]}"; do
            echo "  - $var"
        done
        echo "Please set these variables in $ENV_FILE"
        return 1
    fi
    
    return 0
}

start() {
    if status > /dev/null 2>&1; then
        echo "Application is already running"
        return 1
    fi
    
    # Load environment variables
    if ! load_env; then
        return 1
    fi
    
    # Set defaults for optional variables
    set_default_env
    
    # Validate required environment variables
    if ! validate_env; then
        return 1
    fi
    
    # Validate that JAR file exists
    if [ ! -f "$APP_JAR" ]; then
        echo "Error: Application JAR not found at $APP_JAR"
        return 1
    fi
    
    echo "Starting application on port $SERVER_PORT..."
    echo "Using environment variables from $ENV_FILE"
    
    # Start the application with environment variables
    nohup java $JAVA_OPTS -jar "$APP_JAR" >> "$LOG_FILE" 2>&1 &
    
    echo $! > "$PID_FILE"
    echo "Application started with PID $(cat "$PID_FILE")"
}

stop() {
    if ! status > /dev/null 2>&1; then
        echo "Application is not running"
        return 1
    fi
    
    PID=$(cat "$PID_FILE")
    echo "Stopping application (PID: $PID)..."
    
    # Initial graceful shutdown
    kill -TERM $PID
    
    # Wait for graceful shutdown (up to 180 seconds)
    for i in {1..180}; do
        if ! ps -p $PID > /dev/null; then
            break
        fi
        sleep 1
    done
    
    # Force kill if still running
    if ps -p $PID > /dev/null; then
        echo "Application not responding to TERM signal, forcing shutdown..."
        kill -KILL $PID
        sleep 2
    fi
    
    rm -f "$PID_FILE"
    echo "Application stopped"
}

status() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null; then
            echo "Application is running with PID $PID"
            return 0
        else
            echo "PID file exists but process not found (PID: $PID)"
            rm -f "$PID_FILE"
            return 3
        fi
    else
        echo "Application is not running"
        return 1
    fi
}

restart() {
    stop
    sleep 2
    start
}

# Show environment configuration
show_config() {
    if [ -f "$ENV_FILE" ]; then
        echo "Current environment configuration:"
        cat "$ENV_FILE"
    else
        echo "No environment file found at $ENV_FILE"
        echo "Use '$0 create-config' to create a template"
        return 1
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    restart)
        restart
        ;;
    config)
        show_config
        ;;
    create-config)
        create_config
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart|config|create-config}"
        echo ""
        echo "Commands:"
        echo "  start        - Start the application with configured environment variables"
        echo "  stop         - Stop the application (graceful then forceful)"
        echo "  status       - Check if the application is running"
        echo "  restart      - Restart the application"
        echo "  config       - Show the current environment configuration"
        echo "  create-config - Create a template environment configuration file"
        exit 1
        ;;
esac