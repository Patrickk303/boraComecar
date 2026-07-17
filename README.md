# XequeMate

Painel responsivo para árbitros e portal público de acompanhamento de torneios de xadrez.

## Executar

1. `npm install`
2. `npm run dev` abre a interface em `http://localhost:5173` e a API SQLite em `http://localhost:3001`.
3. Para simular o ambiente de produção local: `npm run build` e depois `npm start`. A aplicação fica em `http://localhost:3001`.

O banco local é criado automaticamente em `data/xequemate.db` na primeira inicialização. O torneio de demonstração usa o código `XAD842`; seu link público local é `http://localhost:3001/?codigo=XAD842` quando iniciado com `npm start`.

Opcionalmente, copie `.env.example` para `.env`, informe as chaves do Supabase e execute a migração em `supabase/schema.sql` pelo SQL Editor do Supabase para usar a infraestrutura hospedada.

O protótipo abre com um torneio demonstrativo. A API local expõe o torneio e persiste resultados em SQLite. O esquema Supabase inclui autenticação por e-mail/senha, isolamento de dados por árbitro via RLS e publicação das tabelas no Realtime.

## Recursos entregues

- Painel de arbitragem com rodada, classificação e partidas.
- Registro de resultado com seleção explícita e atualização imediata local.
- Criação de torneio, código público, link de compartilhamento e QR Code.
- Página pública com classificação responsiva e alternância de ambientes.
- Banco PostgreSQL relacional, tipos de resultado, RLS e Supabase Realtime.
