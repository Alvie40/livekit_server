# LiveKit Server with Coolify Integration

This setup provides a production-ready LiveKit server configuration optimized for deployment with Coolify.

## Architecture

- **LiveKit Server**: Real-time communication server
- **Redis**: Session storage and scaling support
- **Coolify Proxy**: Automatic HTTPS termination and domain routing

## Key Features

✅ **Coolify Integration**: Uses labels for automatic proxy configuration  
✅ **HTTPS Support**: Automatic TLS termination via coolify-proxy  
✅ **WebSocket Support**: Full WebRTC and WebSocket connectivity  
✅ **Scalable**: Redis backend for multi-instance deployments  
✅ **Production Ready**: Proper logging, restart policies, and networking  

## Configuration

### Domain & SSL
The setup is configured for `livekit.doctorkit.satmed.net` with automatic TLS via coolify-proxy labels:

```yaml
labels:
  - "caddy=livekit.doctorkit.satmed.net"
  - "caddy.reverse_proxy={{upstreams 7880}}"
  - "caddy.tls=internal"
  - "caddy.encode=gzip"
```

### LiveKit API Keys
API keys are configured via environment variables. Update in `docker-compose.yaml`:

```yaml
environment:
  - "LIVEKIT_KEYS=APIgNxWzk3h8fpH: eTMC1y4k94cOyo1Y1zj5i0eVO6eGoe75CIjebOg4j6bB"
```

## Deployment

### Local Testing
```bash
cd setup/
docker compose up -d
curl http://localhost:7880  # Should return "OK"
```

### Coolify Deployment
1. Create new service in Coolify
2. Set repository to this project
3. Set build context to `setup/`
4. Configure domain in Coolify settings
5. Deploy

## Files

- `docker-compose.yaml` - Main orchestration file
- `livekit.yaml` - LiveKit server configuration
- `redis.conf` - Redis configuration (optional)
- `init_script.sh` - Initialization script

## Ports

- **7880**: HTTP API and WebSocket (exposed)
- **6379**: Redis (internal network only)

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `LIVEKIT_CONFIG_FILE` | Path to config file | `/etc/livekit.yaml` |
| `LIVEKIT_KEYS` | API key pairs | See docker-compose.yaml |

## Troubleshooting

### Check Service Status
```bash
docker compose ps
docker compose logs livekit-server
docker compose logs redis
```

### Test Connectivity
```bash
# Local HTTP
curl http://localhost:7880

# WebSocket test (if deployed)
websocat wss://livekit.doctorkit.satmed.net/rtc
```

### Common Issues

1. **"is a directory" errors**: Ensure file mounting works in your environment
2. **Connection refused**: Check if services are running and ports are exposed
3. **SSL errors**: Verify Coolify proxy configuration and domain settings

## Migration from Legacy Setup

This setup replaces the previous 3-service architecture (LiveKit + Redis + Caddy) with a streamlined 2-service setup that leverages Coolify's built-in proxy capabilities.

**Removed components:**
- Custom Caddy L4 proxy service
- Manual SSL certificate management
- Complex port forwarding configuration
- Separate network bridges for proxy communication
