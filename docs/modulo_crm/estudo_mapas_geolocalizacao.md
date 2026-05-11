# Estudo: Mapas, Geolocalização e Visualização Geográfica para CRM

**Data da pesquisa:** 31/03/2026  
**Objetivo:** Levantar soluções técnicas completas para integração de mapas, gestão de territórios, roteirização, geolocalização e visualizações analíticas geográficas no módulo CRM do OpticalCore.

---

## 1. Resumo Executivo

A camada geográfica de um CRM moderno vai muito além de "mostrar pinos no mapa". Ela abrange cinco capacidades fundamentais:

1. **Mapa interativo de clientes** — exibição, clusterização, filtros, popups com resumo do cliente
2. **Gestão de territórios** — definição de áreas por polígonos, CEP, cidade ou estado; atribuição de vendedores
3. **Roteirização e planejamento de visitas** — cálculo de rotas otimizadas para visitas de campo
4. **Geolocalização e geocodificação** — converter endereços em coordenadas, busca por proximidade, geo-fencing
5. **Visualizações analíticas** — heatmaps de faturamento, bubble maps de potencial, cobertura e lacunas

---

## 2. Provedores de Mapas — Comparativo

### 2.1 Google Maps Platform

| Aspecto | Detalhe |
|---------|---------|
| **Biblioteca React** | `@vis.gl/react-google-maps` (v1.8.1, mantida pelo vis.gl/Google) — componentes: `Map`, `AdvancedMarker`, `InfoWindow`, `Polygon`, `Circle`, `Polyline`, `Map3D` |
| **Clusterização** | `@googlemaps/markerclusterer` — agrupa markers automaticamente por zoom, customizável via `renderer` e `algorithm` |
| **Heatmap** | `google.maps.visualization.HeatmapLayer` (DEPRECATED maio 2025, será removido maio 2026). Substituto recomendado: **deck.gl HeatmapLayer** |
| **Desenho de polígonos** | Drawing Library + `google.maps.drawing.DrawingManager` para polígonos, círculos, retângulos |
| **Geocodificação** | Geocoding API v4 — converte endereço para lat/lng e vice-versa |
| **Rotas** | Routes API (`computeRoutes`) — suporta múltiplos waypoints, otimização de ordem, modos de transporte (carro, moto, bicicleta, a pé, transporte público), rotas eco-friendly |
| **Direções client-side** | DirectionsService + DirectionsRenderer (Legacy) — até 25 waypoints, `optimizeWaypoints: true` para reordenamento automático |
| **Matriz de distância** | Routes API `computeRouteMatrix` — calcula tempo/distância entre múltiplas origens e destinos em batch |
| **Geo-fencing** | Geofencing API — notificações quando dispositivo entra/sai de área definida |

**Precificação Google Maps (USD, por 1.000 eventos):**

| SKU | Free Tier | Preço (0-100K) | Preço (100K-500K) |
|-----|-----------|----------------|-------------------|
| Maps JS Dynamic Map | $200/mês crédito | $7.00 | $5.60 |
| Geocoding | $200/mês crédito | $5.00 | $4.00 |
| Directions | $200/mês crédito | $5.00 | $4.00 |
| Routes (Compute Routes) | $200/mês crédito | $5.00-$10.00 | $4.00-$8.00 |
| Routes (Route Matrix) | $200/mês crédito | $5.00-$10.00 | $4.00-$8.00 |
| Distance Matrix | $200/mês crédito | $5.00 | $4.00 |

> **Google oferece $200/mês de crédito gratuito**, o que cobre ~28.500 carregamentos de mapa/mês ou ~40.000 geocodificações/mês.

### 2.2 Mapbox

| Aspecto | Detalhe |
|---------|---------|
| **Biblioteca React** | `react-map-gl` (Uber) ou Mapbox GL JS direto |
| **Motor** | WebGL, mapas vetoriais, altamente customizáveis |
| **Free tier** | 50.000 map loads/mês grátis |
| **Estilo** | Mapbox Studio — editor visual de estilos de mapa |
| **3D** | Suporte nativo a terreno 3D e edificações |

**Precificação Mapbox (USD, por 1.000 eventos):**

| SKU | Free Tier | Preço após free tier |
|-----|-----------|---------------------|
| Map Loads (Web) | 50.000/mês | $5.00 (50K-100K), $4.00 (100K-200K), $3.00 (200K+) |
| Geocoding (Temporary) | 100.000/mês | $0.75 (100K-500K), $0.60 (500K-1M), $0.45 (1M+) |
| Geocoding (Permanent) | 0 | $5.00 (1-500K), $4.00 (500K+) |
| Directions API | 100.000/mês | $0.60 (100K-500K), $0.48 (500K-1M) |
| Vector Tiles | 200.000/mês | $0.25 (200K-2M), $0.20 (2M-4M), $0.15 (4M+) |

> **Mapbox tem free tiers mais generosos para geocodificação e direções** mas cobra por map loads após 50K.

### 2.3 Leaflet + OpenStreetMap

| Aspecto | Detalhe |
|---------|---------|
| **Biblioteca React** | `react-leaflet` v5.0.0 (2.5M downloads/semana no npm) |
| **Custo do mapa** | **GRATUITO** — usa tiles do OpenStreetMap (ou outros provedores de tiles) |
| **Motor** | Rasterizado (DOM-based), mais leve que WebGL |
| **Plugins** | Ecossistema enorme — Leaflet.markercluster, Leaflet.heat, Leaflet.draw, Leaflet.routing |
| **Limitações** | Sem 3D nativo, performance inferior com >10K markers sem clusterização, sem suporte nativo a mapas vetoriais |
| **Licença** | BSD-2 (Leaflet), tiles OSM sob ODbL |

**Precificação:** O mapa base é gratuito. Geocodificação e rotas requerem serviços externos:
- **Nominatim** (OSM): geocodificação gratuita mas com rate-limit (1 req/s)
- **OSRM**: roteamento gratuito e open-source (self-hosted)
- **GraphHopper**: geocodificação e rotas — free tier 500 req/dia, planos pagos a partir de $49/mês

### 2.4 HERE Maps

| Aspecto | Detalhe |
|---------|---------|
| **SDK** | HERE Maps JS API, HERE SDK (mobile) |
| **Free tier** | 250.000 transações/mês (inclui mapa, geocoding, rotas) |
| **Pontos fortes** | Dados de tráfego em tempo real (herança Nokia/Navteq), mapeamento indoor, fleet management |
| **Geocodificação** | API de geocodificação com alta precisão para endereços brasileiros |
| **Rotas** | Routing API com otimização para frota (Vehicle Routing Problem) |
| **React** | Sem biblioteca React oficial — uso via wrapper ou acesso direto ao SDK JS |

### 2.5 Tabela Comparativa Final

| Critério | Google Maps | Mapbox | Leaflet/OSM | HERE Maps |
|----------|-------------|--------|-------------|-----------|
| **Custo mapa** | $200/mês crédito | 50K grátis | Grátis | 250K grátis |
| **Geocoding** | Excelente (BR) | Muito bom | Limitado (Nominatim) | Excelente (BR) |
| **Rotas** | Excelente | Muito bom | Via OSRM/GraphHopper | Excelente + frota |
| **React support** | `@vis.gl/react-google-maps` (oficial) | `react-map-gl` (Uber) | `react-leaflet` (comunidade) | Sem lib React oficial |
| **Heatmaps** | Deprecated (usar deck.gl) | Via deck.gl | Leaflet.heat plugin | Via SDK |
| **Drawing tools** | DrawingManager nativo | mapbox-gl-draw | Leaflet.draw plugin | Sem nativo |
| **Clustering** | `@googlemaps/markerclusterer` | Supercluster | Leaflet.markercluster | Nativo no SDK |
| **Performance** | Boa (WebGL) | Excelente (WebGL) | Média (DOM) | Boa |
| **Customização visual** | Limitada | Excelente (Studio) | Moderada | Limitada |
| **Ecossistema BR** | Melhor (Google Places BR) | Bom | Limitado | Bom |

**Recomendação para OpticalCore:** **Google Maps** como provedor principal (melhor ecossistema Brasil, geocodificação precisa, $200/mês crédito suficiente para uso médio) + **deck.gl** para visualizações avançadas (heatmaps, bubble maps).

---

## 3. Mapa Interativo de Clientes

### 3.1 Exibição de Clientes no Mapa

Cada cliente/conta com endereço geocodificado é exibido como um marker no mapa. A geocodificação deve ocorrer no momento do cadastro/atualização do endereço (backend) e ser armazenada no banco.

**Fluxo de geocodificação:**
```
Cadastro Endereço → Backend: Geocoding API (endereço → lat/lng) → Salva lat/lng no banco
                  → Frontend: Exibe marker na posição lat/lng
```

**Dados por marker:**
- Posição: latitude/longitude do endereço principal
- Ícone: cor/formato conforme tipo (cliente, lead, prospect), status (ativo, inativo, inadimplente), porte
- Popup (InfoWindow): Nome, código, tipo pessoa, telefone, último pedido, valor total, status

### 3.2 Clusterização para Grande Volume

Para 1.000+ markers, a clusterização é obrigatória para performance e legibilidade.

**Estratégias de clusterização:**

| Estratégia | Quando usar | Biblioteca |
|------------|-------------|------------|
| **Client-side clustering** | Até ~10.000 pontos | `@googlemaps/markerclusterer`, Supercluster |
| **Server-side clustering** | >10.000 pontos | PostGIS `ST_ClusterDBSCAN` ou `ST_SnapToGrid` |
| **Viewport-based loading** | >50.000 pontos | Backend retorna apenas pontos no viewport atual (bounding box) |

**Client-side com `@googlemaps/markerclusterer`:**
- Agrupa markers próximos em clusters com contagem
- Clusters se expandem ao dar zoom
- Customizável: ícone do cluster, cores por quantidade, algoritmo de agrupamento
- Algoritmos: `GridAlgorithm` (rápido, grid-based), `SuperClusterAlgorithm` (baseado em Supercluster, melhor para grandes volumes), `NoopAlgorithm` (sem clustering)

**Server-side com PostGIS:**
```sql
-- Clustering por grid no servidor
SELECT 
    ST_SnapToGrid(geom, 0.01) as cluster_center,
    COUNT(*) as point_count,
    array_agg(id) as client_ids
FROM clientes
WHERE ST_Within(geom, ST_MakeEnvelope(lng1, lat1, lng2, lat2, 4326))
GROUP BY ST_SnapToGrid(geom, 0.01);
```

### 3.3 Markers Customizados

**Diferenciação visual por atributo:**

| Atributo | Representação Visual |
|----------|---------------------|
| Tipo (cliente, lead, prospect) | Cor do marker (azul, verde, laranja) |
| Status (ativo, inativo) | Opacidade (100% vs 40%) |
| Porte (pequeno, médio, grande) | Tamanho do marker |
| Inadimplência | Borda vermelha |
| Última visita (recente, atrasada) | Ícone diferenciado |
| Com pedido aberto | Badge/ponto no marker |

Com `@vis.gl/react-google-maps`, usa-se `AdvancedMarker` com conteúdo HTML customizado:
```tsx
<AdvancedMarker position={{ lat, lng }}>
  <div className={`marker marker--${tipo} marker--${status}`}>
    <Icon />
    {temPedidoAberto && <span className="badge" />}
  </div>
</AdvancedMarker>
```

### 3.4 InfoWindow / Popup do Cliente

Ao clicar no marker, exibe popup com resumo:

**Campos do popup:**
- Nome/Razão Social
- Código (8 dígitos)
- Tipo pessoa (Física/Jurídica)
- Telefone principal
- E-mail
- Vendedor responsável
- Último pedido: data + valor
- Total de compras (acumulado)
- Status (ativo/inativo)
- Botões: "Ver Detalhes", "Nova Visita", "Novo Pedido"

---

## 4. Gestão de Territórios / Áreas no Mapa

### 4.1 Definição de Territórios

Territórios são áreas geográficas atribuídas a vendedores/consultores. Podem ser definidos de quatro formas:

| Método | Descrição | Complexidade | Uso ideal |
|--------|-----------|-------------|-----------|
| **Polígono desenhado** | Usuário desenha polígono livre no mapa | Alta (drawing tools) | Áreas irregulares, customizadas |
| **CEP / faixa de CEP** | Define território por CEPs ou ranges | Média | Brasil urbano, entrega |
| **Cidade / Município** | Usa limites administrativos IBGE | Média | Cobertura municipal |
| **Estado / UF** | Usa limites estaduais | Baixa | Macro-regiões |

**Implementação com polígonos:**
- Frontend: Drawing Manager do Google Maps ou `mapbox-gl-draw` para desenhar polígonos
- Backend: Armazena polígonos como `GEOMETRY(Polygon, 4326)` no PostGIS
- Consulta: `ST_Contains(territorio.geom, cliente.geom)` para saber quais clientes estão em cada território

**Implementação com CEP/cidade/estado:**
- Tabela `territorio_regras` com tipo (CEP, cidade, estado) + valor
- Join com endereço do cliente para atribuição automática
- Base de CEPs do Brasil: Correios ou dados abertos

### 4.2 Visualização de Territórios

- Cada território renderizado como polígono semi-transparente com cor do vendedor
- Legenda lateral com nome do vendedor + cor + métricas
- Toggle de camada para ligar/desligar visualização

**Detecção de sobreposição:**
```sql
-- Encontrar territórios que se sobrepõem
SELECT a.id, b.id, 
       ST_Area(ST_Intersection(a.geom, b.geom)) / ST_Area(a.geom) * 100 as overlap_pct
FROM territorios a
JOIN territorios b ON ST_Intersects(a.geom, b.geom) AND a.id < b.id;
```

### 4.3 Atribuição de Clientes a Territórios

**Automática:**
```sql
-- Atribuir clientes a territórios via PostGIS
UPDATE clientes c
SET territorio_id = t.id
FROM territorios t
WHERE ST_Contains(t.geom, c.geom);
```

**Manual:** Override via interface — arrastar cliente para outro território ou atribuir via dropdown.

### 4.4 Performance por Território (Choropleth)

Mapa coroplético onde a intensidade da cor do território indica performance:
- Faturamento total
- Número de clientes ativos
- Taxa de conversão
- Valor médio de pedido
- Frequência de visitas

---

## 5. Roteirização e Planejamento de Visitas

### 5.1 Cálculo de Rotas Otimizadas

**Google Routes API — `computeRoutes`:**
- Suporta até 25 waypoints intermediários
- `optimizeWaypointOrder: true` — reordena paradas pela rota mais eficiente (Travelling Salesman Problem heurístico)
- Modos: `DRIVE`, `BICYCLE`, `WALK`, `TWO_WHEELER`, `TRANSIT`
- Retorna: polyline codificada, duração, distância, instruções passo-a-passo
- Suporta: janelas de horário, preferência por rodovias/vias locais, rotas eco-friendly
- Heading e side-of-road para paradas em vias de mão dupla

**Directions Service (client-side, Legacy):**
- `optimizeWaypoints: true` no `DirectionsRequest`
- Retorna `waypoint_order` indicando a ordem otimizada
- Limitação: máximo 25 waypoints (>10 waypoints cobrado a preço premium)

### 5.2 Matriz de Distância / Tempo

**Routes API — `computeRouteMatrix`:**
- Calcula N origens x M destinos simultaneamente
- Retorna matriz com tempo + distância para cada par
- Uso: "qual o cliente mais próximo?", "ordenar visitas por proximidade"

### 5.3 Planejamento Diário/Semanal de Rota

**Fluxo do planejamento:**
```
1. Vendedor seleciona clientes a visitar (manual ou automático)
2. Sistema calcula rota otimizada (Routes API)
3. Exibe rota no mapa com paradas numeradas
4. Mostra tempo total estimado + distância
5. Vendedor ajusta ordem se necessário
6. Exporta rota para Google Maps / Waze (deep link)
```

**Deep links para navegação:**
```
Google Maps: https://www.google.com/maps/dir/?api=1&origin={lat},{lng}&destination={lat},{lng}&waypoints={lat},{lng}|{lat},{lng}&travelmode=driving

Waze: https://waze.com/ul?ll={lat},{lng}&navigate=yes
```

### 5.4 Roteirização Avançada (Vehicle Routing Problem)

Para frota com múltiplos vendedores, o problema é mais complexo (VRP — Vehicle Routing Problem):
- **Google OR-Tools** (open-source, C++/Python) — solver para VRP com janelas de tempo, capacidade, etc.
- **HERE Fleet Telematics** — API comercial para otimização de frota
- **VROOM** (open-source) — solver VRP baseado em OSRM, leve e eficiente
- **OptaPlanner** (Red Hat, Java) — constraint solver open-source

Para o OpticalCore, o cenário mais comum é roteirização para um vendedor por vez (TSP), que o Google Routes API resolve nativamente com `optimizeWaypointOrder`.

---

## 6. Geolocalização e Geocodificação

### 6.1 Geocodificação de Endereços (Address → Lat/Lng)

**Processo recomendado:**
1. No cadastro/atualização de endereço do cliente, backend chama Geocoding API
2. Retorna latitude, longitude, `place_id`, endereço formatado
3. Armazena no banco: colunas `latitude`, `longitude` (ou `GEOGRAPHY(Point, 4326)` com PostGIS)
4. Geocodificação em batch para endereços existentes (migration de dados)

**Google Geocoding API v4:**
- Input: endereço texto (ex: "Rua XV de Novembro, 123, Curitiba, PR")
- Output: lat/lng, formatted_address, place_id, tipos de componentes
- Precisão no Brasil: excelente em áreas urbanas, variável em áreas rurais
- Custo: $5/1000 requests (com $200/mês crédito grátis = ~40K geocodificações/mês)

**Geocodificação reversa (Lat/Lng → Address):**
- Usado para: check-in de vendedor (GPS → endereço), "onde estou?"
- Mesmo endpoint, parâmetro `latlng` em vez de `address`

### 6.2 Validação e Padronização de Endereços

**Address Validation API (Google):**
- Valida se o endereço existe e é entregável
- Retorna versão padronizada (corrige CEP, complemento, abreviações)
- Útil para: garantir qualidade do geocoding, reduzir endereços duplicados
- Disponível no Brasil desde 2024

**Alternativa BR:** API dos Correios (ViaCEP) para validação por CEP + complementação com geocoding.

### 6.3 Busca por Proximidade ("Clientes num raio de X km")

**Com PostGIS:**
```sql
-- Clientes dentro de 10km de um ponto
SELECT id, nome, 
       ST_Distance(geom::geography, ST_SetSRID(ST_MakePoint(-49.27, -25.43), 4326)::geography) as distancia_m
FROM clientes
WHERE ST_DWithin(geom::geography, ST_SetSRID(ST_MakePoint(-49.27, -25.43), 4326)::geography, 10000)
ORDER BY distancia_m;
```

**Com Google Maps JS API (client-side):**
```javascript
// Filtrar markers por raio usando google.maps.geometry.spherical
const center = new google.maps.LatLng(lat, lng);
const filtered = clientes.filter(c => 
  google.maps.geometry.spherical.computeDistanceBetween(
    center, 
    new google.maps.LatLng(c.lat, c.lng)
  ) <= raioMetros
);
```

### 6.4 "Clientes Próximos à Minha Localização"

Usando a Geolocation API do browser:
```
1. navigator.geolocation.getCurrentPosition() → lat/lng do vendedor
2. Enviar lat/lng ao backend
3. Backend: ST_DWithin(geom, ponto_vendedor, raio) com PostGIS
4. Retornar lista ordenada por distância
5. Frontend: exibir no mapa com marcador do vendedor + clientes próximos
```

### 6.5 Geo-fencing para Check-in de Visita

**Conceito:** Vendedor só pode registrar check-in de visita se estiver fisicamente próximo ao endereço do cliente.

**Implementação:**
```
1. Vendedor abre tela de check-in no mobile/PWA
2. Sistema obtém GPS do dispositivo
3. Calcula distância até endereço do cliente
4. Se distância < raio (ex: 200m) → check-in permitido
5. Se distância > raio → alerta + opção de justificativa
6. Registra: horário, coordenadas GPS, distância, flag dentro/fora
```

---

## 7. Visualizações Analíticas Geográficas

### 7.1 Heatmaps (Mapas de Calor)

**Biblioteca recomendada: deck.gl `HeatmapLayer`** (substitui o deprecated Google Heatmap Layer)

| Métrica | Peso (weight) | Uso |
|---------|---------------|-----|
| Faturamento por cliente | Valor total de vendas | Onde está concentrada a receita |
| Frequência de visitas | Número de visitas no período | Onde o vendedor mais atua |
| Número de oportunidades | Contagem de deals | Onde há mais potencial |
| Inadimplência | Valor em atraso | Zonas de risco |

**deck.gl HeatmapLayer:**
- Gaussian Kernel Density Estimation
- Props: `radiusPixels`, `intensity`, `threshold`, `colorRange`, `aggregation` (SUM/MEAN)
- Funciona como overlay sobre Google Maps, Mapbox ou Leaflet
- WebGL-based — excelente performance

### 7.2 Bubble Maps (Mapas de Bolha)

Cada cliente é um círculo cujo tamanho é proporcional a uma métrica:

| Métrica | Representação |
|---------|---------------|
| Faturamento anual | Raio do círculo proporcional ao valor |
| Número de pedidos | Raio do círculo |
| Potencial de compra | Raio do círculo |

**Implementação:** `Circle` component do `@vis.gl/react-google-maps` com `radius` calculado dinamicamente, ou deck.gl `ScatterplotLayer` para melhor performance.

### 7.3 Choropleth Maps (Mapas Coropléticos)

Regiões coloridas por intensidade de uma métrica:

| Nível | Dados necessários | Fonte de limites |
|-------|-------------------|------------------|
| Estado (UF) | Vendas por UF | GeoJSON IBGE |
| Município | Vendas por município | GeoJSON IBGE |
| Bairro | Vendas por bairro | Varia por cidade |
| Território customizado | Vendas por território | Polígonos do banco |

**Fontes de GeoJSON para Brasil:**
- IBGE: Malhas geográficas oficiais (estados, municípios, mesorregiões, microrregiões)
- `@mfreed7/br-atlas` (npm) — topojson do Brasil
- GitHub: repositórios com GeoJSON de estados/municípios BR

### 7.4 Análise de Cobertura e Lacunas

**Coverage Gap Analysis:**
```
1. Plotar todos os clientes ativos no mapa
2. Plotar territórios com vendedores atribuídos
3. Identificar áreas SEM clientes (vazios no heatmap)
4. Cruzar com dados demográficos/econômicos da região
5. Highlight em vermelho: áreas com potencial mas sem cobertura
6. Sugerir: "Esta região tem X óticas e nenhum cliente seu"
```

Para dados demográficos, usar API do IBGE (Sidra) com dados de estabelecimentos comerciais por CNAE (óticas = CNAE 4774-1/00).

### 7.5 Mapa de Desempenho de Vendedores

- Overlay de territórios com métricas de cada vendedor
- Comparação visual: território A (verde/bom) vs território B (vermelho/fraco)
- Métricas: faturamento vs meta, número de visitas, taxa de conversão, ticket médio

---

## 8. Armazenamento de Dados Geográficos

### 8.1 PostGIS — Extensão Geográfica para PostgreSQL

O OpticalCore já usa PostgreSQL. PostGIS adiciona tipos e funções geoespaciais.

**Instalação:**
```sql
CREATE EXTENSION postgis;
```

**Modelagem recomendada:**

```sql
-- Adicionar colunas geográficas na tabela de endereços
ALTER TABLE enderecos ADD COLUMN coordenadas GEOGRAPHY(Point, 4326);

-- Criar índice espacial (GIST)
CREATE INDEX idx_enderecos_coordenadas ON enderecos USING GIST(coordenadas);

-- Tabela de territórios
CREATE TABLE territorios (
    id UUID PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    vendedor_id UUID REFERENCES vendedores(id),
    cor VARCHAR(7) NOT NULL, -- ex: #FF5733
    geometria GEOMETRY(Polygon, 4326) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    company_id UUID NOT NULL -- multi-tenant
);
CREATE INDEX idx_territorios_geometria ON territorios USING GIST(geometria);
```

**Funções PostGIS mais usadas no CRM:**

| Função | Uso |
|--------|-----|
| `ST_SetSRID(ST_MakePoint(lng, lat), 4326)` | Criar ponto a partir de coordenadas |
| `ST_Distance(a, b)` | Distância entre dois pontos (metros com geography) |
| `ST_DWithin(a, b, raio)` | Pontos dentro de um raio |
| `ST_Contains(poligono, ponto)` | Ponto está dentro do polígono? |
| `ST_Intersects(a, b)` | Duas geometrias se interceptam? |
| `ST_Area(geom)` | Área de um polígono |
| `ST_ClusterDBSCAN(geom, eps, minpoints)` | Clustering espacial |
| `ST_SnapToGrid(geom, size)` | Simplificação para clustering por grid |
| `ST_AsGeoJSON(geom)` | Exportar geometria como GeoJSON |
| `ST_GeomFromGeoJSON(json)` | Importar GeoJSON como geometria |
| `ST_MakeEnvelope(x1, y1, x2, y2, srid)` | Criar bounding box para viewport queries |

### 8.2 Alternativa sem PostGIS

Se PostGIS não for viável (complexidade, hosting):

| Campo | Tipo | Uso |
|-------|------|-----|
| `latitude` | `decimal(10,7)` | Coordenada Y |
| `longitude` | `decimal(10,7)` | Coordenada X |

Consultas de proximidade via fórmula de Haversine:
```sql
SELECT *, 
    (6371 * acos(cos(radians(@lat)) * cos(radians(latitude)) * 
    cos(radians(longitude) - radians(@lng)) + 
    sin(radians(@lat)) * sin(radians(latitude)))) AS distancia_km
FROM clientes
HAVING distancia_km < @raio
ORDER BY distancia_km;
```

> **Recomendação:** Usar PostGIS. A extensão é padrão, funciona em todos os hostings PostgreSQL modernos (AWS RDS, Azure, Supabase, self-hosted), e a performance é ordens de magnitude superior à fórmula de Haversine para grandes volumes.

### 8.3 EF Core + NetTopologySuite

Para usar PostGIS com EF Core:

```xml
<!-- NuGet packages -->
<PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL.NetTopologySuite" />
```

```csharp
// DbContext configuration
optionsBuilder.UseNpgsql(connString, o => o.UseNetTopologySuite());

// Entity
public class Endereco 
{
    public Point Coordenadas { get; set; } // NetTopologySuite.Geometries.Point
}

// Query: clientes dentro de 10km
var ponto = new Point(-49.27, -25.43) { SRID = 4326 };
var clientes = await context.Clientes
    .Where(c => c.Endereco.Coordenadas.IsWithinDistance(ponto, 10000))
    .OrderBy(c => c.Endereco.Coordenadas.Distance(ponto))
    .ToListAsync();
```

---

## 9. Referências de CRM Comerciais com Funcionalidade de Mapas

### 9.1 Salesforce Maps (ex-MapAnything)

| Feature | Implementação |
|---------|---------------|
| **Mapa de contas** | Mapa integrado ao CRM com pins por conta/contato/oportunidade |
| **Territórios** | Territory Management com polígonos, regras por CEP/estado, hierarquias |
| **Roteirização** | Route optimization para visitas, integração com calendário |
| **Check-in** | Geo-verified check-ins com GPS |
| **Analytics** | Heat maps, bubble maps por qualquer campo numérico |
| **Preço** | ~$75/user/mês (add-on) |
| **Diferenciais** | Deeply integrated com Salesforce CRM, automações via Flow, Einstein AI para sugestão de rotas |

### 9.2 Badger Maps

| Feature | Implementação |
|---------|---------------|
| **Foco** | Field sales — vendedores externos |
| **Mapa** | Visualização de clientes, leads, oportunidades no mapa |
| **Roteirização** | Lasso tool para selecionar clientes, rota otimizada automática |
| **Check-in** | Check-in/check-out com geo-fence |
| **Integração** | Google Maps, Waze para navegação |
| **CRM sync** | Salesforce, HubSpot, Microsoft Dynamics, Zoho |
| **Preço** | $58/user/mês (Business), $95/user/mês (Enterprise) |

### 9.3 MapMyCustomers

| Feature | Implementação |
|---------|---------------|
| **Foco** | Mobile-first CRM geográfico |
| **Mapa** | Mapa de clientes com filtros por campo customizado |
| **Nearby** | "Clientes próximos" baseado em GPS |
| **Roteirização** | Multi-stop route planning + otimização |
| **Atividades** | Log de visitas, tarefas, notas vinculadas ao mapa |
| **Analytics** | Territory insights, visit analytics |
| **Preço** | $50/user/mês |

### 9.4 Maptive

| Feature | Implementação |
|---------|---------------|
| **Foco** | Business mapping e visualização |
| **Territórios** | Desenho manual, por CEP, por raio, por drive-time |
| **Heat maps** | Densidade de dados, performance regional |
| **Routing** | Otimização de rotas com até 25 paradas |
| **Filtros** | Filtros avançados com visualização instantânea no mapa |
| **Preço** | $110/mês (até 25K locations) |

### 9.5 Geopointe (Salesforce)

| Feature | Implementação |
|---------|---------------|
| **Integração** | Nativa Salesforce AppExchange |
| **Mapa** | Qualquer objeto Salesforce no mapa |
| **Shapes** | Importação de shapefiles, drawing tools |
| **Analytics** | Thematic mapping, clustering, data layers |
| **Routing** | Multi-stop routing |
| **Preço** | ~$55/user/mês |

### 9.6 Zoho CRM — Territory Management

| Feature | Implementação |
|---------|---------------|
| **Territórios** | Regras por campo (país, estado, cidade, CEP, segmento, porte) |
| **Hierarquia** | Árvore de territórios (Brasil > Sul > PR > Curitiba) |
| **Atribuição** | Automática por regras, manual override |
| **Reports** | Performance por território, comparação |
| **Mapa** | Mapa básico de registros com geo-tagging |
| **Preço** | Incluído no Zoho CRM Enterprise ($40/user/mês) |

---

## 10. Padrões de Performance com Grande Volume de Markers

### 10.1 Estratégias por Faixa de Volume

| Volume | Estratégia | Detalhes |
|--------|-----------|----------|
| < 500 markers | Renderização direta | Todos os markers no mapa sem clustering |
| 500 - 5.000 | Client-side clustering | `@googlemaps/markerclusterer` com `SuperClusterAlgorithm` |
| 5.000 - 50.000 | Viewport loading + clustering | Backend retorna apenas markers do viewport (`ST_MakeEnvelope`), cluster client-side |
| > 50.000 | Server-side clustering + viewport | PostGIS `ST_SnapToGrid` para clustering no server, paginação por viewport |

### 10.2 Viewport-based Loading

```
1. Frontend envia bounding box do mapa (SW corner, NE corner) + zoom level
2. Backend: SELECT ... WHERE ST_Within(geom, ST_MakeEnvelope(sw_lng, sw_lat, ne_lng, ne_lat, 4326))
3. Se zoom alto (>14): retorna pontos individuais
4. Se zoom baixo (<14): retorna clusters pré-calculados (server-side)
5. Frontend renderiza resultado
6. Ao mover/zoom: debounce 300ms → nova requisição
```

### 10.3 Dicas de Performance

- **Debounce** movimentação do mapa (300ms) para evitar requests excessivos
- **Memoize** markers que já estão renderizados
- **Usar `AdvancedMarker`** (Google) em vez de `Marker` clássico — melhor performance
- **Virtualizar** InfoWindows — renderizar apenas o popup aberto, não todos
- **Tiles vetoriais** (Mapbox/deck.gl) para camadas de dados densos
- **WebWorkers** para cálculos de clustering em thread separada

---

## 11. Bibliotecas React Recomendadas

### 11.1 Stack Principal (Recomendada para OpticalCore)

| Biblioteca | Versão | Uso |
|-----------|--------|-----|
| `@vis.gl/react-google-maps` | 1.8.1 | Componentes React para Google Maps (Map, AdvancedMarker, InfoWindow, Polygon, Circle, Polyline) |
| `@googlemaps/markerclusterer` | 2.x | Clusterização de markers |
| `deck.gl` / `@deck.gl/react` | 9.x | Overlays avançados: HeatmapLayer, ScatterplotLayer, GeoJsonLayer, ArcLayer |
| `@deck.gl/google-maps` | 9.x | Integração deck.gl + Google Maps |
| `supercluster` | 8.x | Algoritmo de clustering (usado internamente pelo markerclusterer) |

### 11.2 Alternativas (se trocar de provedor)

| Biblioteca | Provedor | Downloads/semana |
|-----------|----------|------------------|
| `react-leaflet` | Leaflet/OSM | 2.5M |
| `react-map-gl` | Mapbox | 800K |
| `@react-google-maps/api` | Google Maps | 600K (mais antiga, menos manutenção que vis.gl) |

### 11.3 Utilitários Complementares

| Biblioteca | Uso |
|-----------|-----|
| `@turf/turf` | Análise geoespacial client-side (buffer, intersect, area, centroid, bbox) |
| `geojson` | Tipos TypeScript para GeoJSON |
| `polyline` | Encode/decode polylines do Google Routes API |
| `use-debounce` | Debounce de viewport changes |

---

## 12. Arquitetura Técnica Recomendada para OpticalCore

### 12.1 Backend (C# .NET 8)

```
Infrastructure/
├── Services/
│   ├── GeocodingService.cs         # Integração com Google Geocoding API
│   ├── RoutingService.cs           # Integração com Google Routes API
│   └── GeoSpatialService.cs        # Queries PostGIS (proximidade, território)
│
Domain/
├── Entities/
│   ├── Territorio.cs               # Entidade de território
│   ├── VisitaRota.cs               # Rota planejada de visitas
│   ├── CheckIn.cs                  # Check-in geolocalizado
│   └── EnderecoGeo.cs              # Endereço com coordenadas
│
Application/
├── CRM/
│   ├── Mapas/
│   │   ├── Queries/
│   │   │   ├── GetClientesNoMapaQuery.cs    # Clientes com filtros + viewport
│   │   │   ├── GetClientesProximosQuery.cs  # Busca por raio
│   │   │   ├── GetTerritoriosQuery.cs       # Territórios com geometria
│   │   │   └── GetHeatmapDataQuery.cs       # Dados agregados para heatmap
│   │   └── Commands/
│   │       ├── GeocodificarEnderecoCommand.cs
│   │       ├── CriarTerritorioCommand.cs
│   │       ├── RegistrarCheckInCommand.cs
│   │       └── CalcularRotaCommand.cs
```

### 12.2 Frontend (React + TypeScript)

```
frontend/src/pages/crm/
├── mapas/
│   ├── MapaClientesPage.tsx         # Mapa principal com clientes
│   ├── components/
│   │   ├── ClienteMarker.tsx        # Marker customizado por tipo/status
│   │   ├── ClienteInfoWindow.tsx    # Popup com resumo do cliente
│   │   ├── MapaFilters.tsx          # Sidebar de filtros (tipo, status, vendedor, território)
│   │   ├── TerritorioOverlay.tsx    # Polígonos de território no mapa
│   │   ├── HeatmapOverlay.tsx       # Camada de heatmap (deck.gl)
│   │   ├── BubbleMapOverlay.tsx     # Camada de bubble map
│   │   ├── RotaOverlay.tsx          # Rota de visitas no mapa
│   │   ├── DrawingTools.tsx         # Ferramentas de desenho de território
│   │   └── MapaLegenda.tsx          # Legenda de cores e símbolos
│   ├── hooks/
│   │   ├── useMapaClientes.ts       # Fetch clientes por viewport
│   │   ├── useGeolocation.ts        # GPS do usuário
│   │   ├── useClientesProximos.ts   # Busca por raio
│   │   └── useRotaOtimizada.ts      # Cálculo de rota
│   └── services/
│       └── mapaService.ts           # API calls para endpoints de mapa
│
├── territorios/
│   ├── TerritoriosPage.tsx          # CRUD de territórios
│   ├── TerritorioFormDialog.tsx     # Formulário com mapa para desenhar área
│   └── TerritorioDetailDialog.tsx   # Visualização com mapa + métricas
│
├── roteirizacao/
│   ├── RoteirizacaoPage.tsx         # Planejamento de rotas
│   ├── components/
│   │   ├── SeletorClientes.tsx      # Lista + mapa para selecionar paradas
│   │   ├── RotaTimeline.tsx         # Timeline da rota com horários estimados
│   │   └── RotaResumo.tsx           # Distância total, tempo, custo estimado
│   └── hooks/
│       └── useRoteirizacao.ts       # Lógica de planejamento
```

### 12.3 NuGet Packages (Backend)

```xml
<PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL.NetTopologySuite" Version="8.*" />
<PackageReference Include="NetTopologySuite" Version="2.*" />
<PackageReference Include="NetTopologySuite.IO.GeoJSON" Version="4.*" />
```

---

## 13. Estimativa de Custos Mensais

### Cenário: 500 clientes, 5 vendedores, uso médio

| Serviço | Estimativa de uso | Custo (USD) |
|---------|-------------------|-------------|
| Google Maps JS (carregamentos) | ~3.000/mês | $0 (dentro do crédito) |
| Geocodificação | ~200/mês (novos clientes) | $0 (dentro do crédito) |
| Routes API | ~500/mês (rotas diárias) | $0 (dentro do crédito) |
| PostGIS | Extensão gratuita | $0 |
| **Total estimado** | | **$0** (coberto pelo crédito de $200/mês) |

### Cenário: 5.000 clientes, 20 vendedores, uso intenso

| Serviço | Estimativa de uso | Custo (USD) |
|---------|-------------------|-------------|
| Google Maps JS (carregamentos) | ~15.000/mês | $0 (dentro do crédito) |
| Geocodificação | ~1.000/mês | $0 (dentro do crédito) |
| Routes API | ~3.000/mês | ~$15 |
| Distance Matrix | ~2.000/mês | ~$10 |
| PostGIS | Extensão gratuita | $0 |
| **Total estimado** | | **~$25/mês** (após crédito) |

---

## 14. Roadmap de Implementação Sugerido

### Fase 1 — Fundação (2-3 semanas)
- [ ] Instalar PostGIS no banco
- [ ] Adicionar colunas latitude/longitude nas tabelas de endereço
- [ ] Integrar Google Geocoding API no backend (geocodificar ao salvar endereço)
- [ ] Geocodificação em batch dos endereços existentes
- [ ] Mapa básico com `@vis.gl/react-google-maps` exibindo clientes como markers
- [ ] InfoWindow com resumo do cliente
- [ ] Filtros básicos no mapa (tipo pessoa, status)

### Fase 2 — Clusterização e Markers (1-2 semanas)
- [ ] Implementar `@googlemaps/markerclusterer`
- [ ] Markers customizados por tipo/status/porte
- [ ] Viewport-based loading para performance
- [ ] Busca por proximidade ("clientes em X km")
- [ ] "Clientes próximos a mim" (GPS do browser)

### Fase 3 — Territórios (2-3 semanas)
- [ ] CRUD de territórios com polígonos (PostGIS)
- [ ] Drawing tools para desenhar territórios
- [ ] Atribuição automática cliente → território
- [ ] Visualização de territórios no mapa (cores por vendedor)
- [ ] Detecção de sobreposição

### Fase 4 — Roteirização (2-3 semanas)
- [ ] Planejamento de rota diária
- [ ] Google Routes API para otimização de waypoints
- [ ] Visualização da rota no mapa
- [ ] Estimativa de tempo/distância
- [ ] Deep link para Google Maps/Waze
- [ ] Check-in de visita com geo-fence

### Fase 5 — Visualizações Analíticas (2-3 semanas)
- [ ] Heatmap de faturamento (deck.gl)
- [ ] Bubble map por porte/faturamento
- [ ] Choropleth por estado/município (GeoJSON IBGE)
- [ ] Dashboard geográfico com KPIs por região
- [ ] Análise de cobertura/lacunas

---

## 15. Referências e Fontes

1. Google Maps Platform — Maps JavaScript API: https://developers.google.com/maps/documentation/javascript
2. Google Maps Platform — Geocoding API: https://developers.google.com/maps/documentation/geocoding
3. Google Maps Platform — Routes API: https://developers.google.com/maps/documentation/routes
4. Google Maps Platform — Pricing: https://developers.google.com/maps/billing-and-pricing/pricing
5. @vis.gl/react-google-maps: https://visgl.github.io/react-google-maps/
6. @googlemaps/markerclusterer: https://github.com/googlemaps/js-markerclusterer
7. Mapbox GL JS: https://docs.mapbox.com/mapbox-gl-js/guides/
8. Mapbox Pricing: https://www.mapbox.com/pricing
9. React Leaflet: https://react-leaflet.js.org/
10. deck.gl HeatmapLayer: https://deck.gl/docs/api-reference/aggregation-layers/heatmap-layer
11. PostGIS: https://postgis.net/documentation/
12. HERE Maps Developer: https://developer.here.com/
13. Npgsql.NetTopologySuite: https://www.npgsql.org/efcore/mapping/nts.html
14. Salesforce Maps: https://www.salesforce.com/products/maps/
15. Badger Maps: https://www.badgermapping.com/
16. MapMyCustomers: https://mapmycustomers.com/
17. Maptive: https://www.maptive.com/
18. Geopointe: https://geopointe.com/
19. Turf.js: https://turfjs.org/
20. IBGE Malhas Geográficas: https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais.html
