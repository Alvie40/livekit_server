# Exemplo de Configuração Frontend para LiveKit com Caddy L4

## React/Next.js com LiveKit SDK

```javascript
import { connect } from 'livekit-client';

const room = await connect(
  'wss://yourdomain.com:8448', // Porta 8448 externa mapeada no docker
  token,
  {
    autoSubscribe: true,
  }
);
```

## Vue.js com LiveKit SDK

```javascript
import { Room } from 'livekit-client';

const room = new Room();
await room.connect('wss://yourdomain.com:8448', token);
```

## Vanilla JavaScript

```javascript
import { Room } from 'livekit-client';

const room = new Room({
  adaptiveStream: true,
  dynacast: true,
});

room.on('participantConnected', (participant) => {
  console.log('Participant connected:', participant.identity);
});

await room.connect('wss://yourdomain.com:8448', token);
```

## Configuração de Token (Backend)

```javascript
// Node.js backend para gerar tokens
const { AccessToken } = require('livekit-server-sdk');

function generateToken(identity, room) {
  const token = new AccessToken('APIgNxWzk3h8fpH', 'eTMC1y4k94cOyo1Y1zj5i0eVO6eGoe75CIjebOg4j6bB', {
    identity: identity,
  });
  
  token.addGrant({
    room: room,
    roomJoin: true,
    canPublish: true,
    canSubscribe: true,
  });
  
  return token.toJwt();
}
```

## Configurações Importantes

⚠️ **Certifique-se de que:**

1. O DNS `yourdomain.com` aponta para o servidor
2. A porta `8448` está aberta no firewall
3. O certificado TLS está configurado corretamente
4. O token JWT é válido e não expirado

## Teste de Conectividade

```bash
# Testar se a porta está acessível
telnet yourdomain.com 8448

# Testar TLS
./healthcheck.sh yourdomain.com 8448
```
