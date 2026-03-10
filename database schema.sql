-- Run this in Supabase SQL editor

-- Users table
CREATE TABLE IF NOT EXISTS wf_users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    user_data JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Active sessions table
CREATE TABLE IF NOT EXISTS active_sessions (
    id SERIAL PRIMARY KEY,
    user_email VARCHAR(255) NOT NULL REFERENCES wf_users(email) ON DELETE CASCADE,
    session_token VARCHAR(255) UNIQUE NOT NULL,
    device_fingerprint VARCHAR(255),
    ip_address VARCHAR(45),
    user_agent TEXT,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    last_activity TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    remember_me BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    session_data JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User actions tracking
CREATE TABLE IF NOT EXISTS wf_actions (
    id SERIAL PRIMARY KEY,
    user_email VARCHAR(255),
    action VARCHAR(100) NOT NULL,
    data JSONB,
    device_id VARCHAR(255),
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Platform connections log
CREATE TABLE IF NOT EXISTS wf_connections (
    id SERIAL PRIMARY KEY,
    user_email VARCHAR(255),
    platform VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Error logging
CREATE TABLE IF NOT EXISTS wf_errors (
    id SERIAL PRIMARY KEY,
    error_message TEXT,
    context TEXT,
    user_email VARCHAR(255),
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Media storage tracking
CREATE TABLE IF NOT EXISTS wf_media (
    id SERIAL PRIMARY KEY,
    user_email VARCHAR(255) NOT NULL,
    media_type VARCHAR(20) NOT NULL,
    media_url TEXT,
    media_data TEXT,
    store_name VARCHAR(50) NOT NULL,
    item_id VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_email, store_name, item_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_sessions_token ON active_sessions(session_token);
CREATE INDEX IF NOT EXISTS idx_sessions_user ON active_sessions(user_email);
CREATE INDEX IF NOT EXISTS idx_sessions_active ON active_sessions(is_active);
CREATE INDEX IF NOT EXISTS idx_users_email ON wf_users(email);
CREATE INDEX IF NOT EXISTS idx_actions_user ON wf_actions(user_email);
CREATE INDEX IF NOT EXISTS idx_actions_timestamp ON wf_actions(timestamp);