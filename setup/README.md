# LiveKit Server with Caddy L4 Proxy

This setup provides a production-ready LiveKit server configuration with Caddy L4 proxy for TLS termination on port 8448.

## Architecture

- **LiveKit Server**: Real-time communication server
- **Caddy L4 Proxy**: TLS termination and TCP proxy
- **Redis**: Session storage and scaling support

## Key Features

✅ **TLS Security**: Caddy L4 proxy handles TLS termination  
✅ **Port 8448**: External access via secure port 8448  
✅ **WebSocket Support**: Full WebRTC and WebSocket connectivity  
✅ **UDP Media**: Dedicated UDP range for media streaming  
✅ **Production Ready**: Proper logging, restart policies, and networking  

## Configuration

### Ports

- **8448**: External HTTPS/WSS access (mapped to container port 443)
- **7880**: LiveKit HTTP API (internal)
- **7881**: LiveKit TCP for media (internal)
- **5000-6000**: UDP media range
- **6379**: Redis (internal network only)

### Caddy L4 Configuration

The `caddy.yaml` file configures Layer 4 proxy:

```yaml
admin:
  disabled: false

apps:
  layer4:
    servers:
      tls:
        listen: [":443"]
        routes:
          - handle:
              - tls
              - proxy:
                  upstreams:
                    - dial: livekit-server:7881
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

# Check services
docker compose ps

# Test LiveKit API
curl http://localhost:7880  # Should return "OK"

# Test TLS connectivity (once domain is configured)
./healthcheck.sh yourdomain.com 8448
```

### Production Deployment

1. **Update DNS**: Point your domain to the server IP
2. **Configure domain**: Update `caddy.yaml` if needed
3. **Firewall**: Open port 8448 for external access
4. **Deploy**: Run `docker compose up -d`
5. **Validate**: Use `healthcheck.sh` to verify TLS

## Frontend Integration

See `FRONTEND_EXAMPLES.md` for detailed frontend configuration examples.

### Quick Example (React/Next.js)

```javascript
import { connect } from 'livekit-client';

const room = await connect(
  'wss://yourdomain.com:8448', // External port 8448
  token,
  {
    autoSubscribe: true,
  }
);
```

## Files

- `docker-compose.yaml` - Main orchestration file
- `caddy.yaml` - Caddy L4 proxy configuration
- `livekit.yaml` - LiveKit server configuration
- `healthcheck.sh` - TLS validation script
- `FRONTEND_EXAMPLES.md` - Frontend integration examples
- `redis.conf` - Redis configuration (optional)

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `LIVEKIT_CONFIG_FILE` | Path to config file | `/config/livekit.yaml` |
| `LIVEKIT_KEYS` | API key pairs | See docker-compose.yaml |

## Troubleshooting

### Check Service Status
```bash
docker compose ps
docker compose logs livekit-server
docker compose logs caddyl4
docker compose logs redis
```

### Test Connectivity
```bash
# Local HTTP API
curl http://localhost:7880

# TLS validation
./healthcheck.sh yourdomain.com 8448

# Check if port is open
telnet yourdomain.com 8448
```

### Common Issues

1. **Port 8448 blocked**: Check firewall settings
2. **DNS not pointing**: Verify domain DNS configuration
3. **TLS certificate issues**: Check Caddy logs for certificate generation
4. **Container networking**: Ensure all services are on same network

## Production Checklist

- [ ] DNS configured to point to server
- [ ] Port 8448 open in firewall
- [ ] Update API keys in docker-compose.yaml
- [ ] Test with `healthcheck.sh`
- [ ] Frontend configured with correct WSS URL
- [ ] SSL certificate generated successfully
