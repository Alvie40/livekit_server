# 🚀 Coolify Deployment Guide - LiveKit Server

## ⚠️ Port Conflict Resolution

The deployment failed because **port 443 was already allocated**. This is expected in Coolify environments where the reverse proxy uses port 443.

## ✅ **FIXED Configuration**

The docker-compose.yaml has been updated to work with Coolify's reverse proxy architecture:

### **Changes Made:**
1. **Removed Caddy L4 proxy** - Coolify handles TLS termination
2. **Changed ports to expose** - No more host port conflicts
3. **Added Coolify labels** - Proper service discovery
4. **UDP ports preserved** - WebRTC still needs host UDP ports

### **Current Architecture:**
```
Internet → Coolify Proxy (443/80) → LiveKit (7880) + Redis (6379)
           Host UDP Ports (10000-10100) → WebRTC Media
```

## 📝 **Coolify Configuration**

### **Step 1: Domain Setup**
In your Coolify service configuration:
- **Domain**: `your-livekit-domain.com`
- **Protocol**: HTTPS (Coolify handles TLS)
- **Port**: 7880 (automatically detected via labels)

### **Step 2: Environment Variables**
Add these environment variables in Coolify:
```env
LIVEKIT_CONFIG_FILE=/config/livekit.yaml
LIVEKIT_KEYS=APIgNxWzk3h8fpH: eTMC1y4k94cOyo1Y1zj5i0eVO6eGoe75CIjebOg4j6bB
```

### **Step 3: Frontend Connection**
Update your frontend code to use the Coolify domain:

```javascript
// React/Vue/JS Frontend
import { connect } from 'livekit-client';

const room = await connect(
  'wss://your-livekit-domain.com', // Your Coolify domain
  token,
  { autoSubscribe: true }
);
```

## 🔧 **WebRTC Considerations**

**UDP Ports**: The configuration still exposes UDP ports 10000-10100 on the host for WebRTC media streams. This is required for real-time media transmission.

**Firewall**: Ensure your Coolify server firewall allows UDP traffic on ports 10000-10100.

## 🧪 **Testing the Deployment**

After successful deployment, test with:

```bash
# Test HTTP API
curl https://your-livekit-domain.com

# Should return: "OK"
```

## 📁 **Files Structure**
```
setup/
├── docker-compose.yaml        # ✅ Coolify-optimized (main)
├── docker-compose.coolify.yaml # ✅ Backup version
├── livekit.yaml              # ✅ Server configuration
├── livekit.coolify.yaml      # ✅ Alternative config
└── README.md                 # ✅ Documentation
```

## 🚀 **Deploy Now**

The configuration is now ready for Coolify deployment without port conflicts!
