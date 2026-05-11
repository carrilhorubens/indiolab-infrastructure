# Plano de Implementação Local - WhatsApp AI Agent

## Visão Geral - Desenvolvimento Local

### Ambiente de Desenvolvimento
- **OS**: Windows/Linux/macOS
- **IDE**: Visual Studio 2022 ou VS Code
- **Docker**: Docker Desktop
- **Database**: PostgreSQL via Docker
- **WhatsApp**: Evolution API local via Docker

### Stack Tecnológica (100% Gratuita)
- **Backend**: ASP.NET Core 8
- **Database**: PostgreSQL 16 + Docker
- **WhatsApp**: Evolution API (Docker)
- **Speech-to-Text**: Whisper local (Docker)
- **AI**: Claude API (pay-per-use)
- **Background Jobs**: Hangfire
- **Logs**: Serilog

### Estrutura do Projeto Local
```
C:\Projetos\WhatsAppAgent\
├── src/
│   ├── WhatsAppAgent.Api/
│   ├── WhatsAppAgent.Core/
│   ├── WhatsAppAgent.Infrastructure/
│   └── WhatsAppAgent.Tests/
├── docker/
│   └── docker-compose.yml
├── data/
│   ├── excel/
│   │   └── produtos.xlsx
│   ├── uploads/
│   └── logs/
├── scripts/
│   ├── setup-local.bat
│   ├── start-services.bat
│   └── test-system.bat
└── docs/
    └── README.md
```

## Fase 1: Preparação do Ambiente Local (30 minutos)

### 1.1 Pré-requisitos
```bash
# Verificar se tem tudo instalado
dotnet --version          # Deve ser 8.0+
docker --version          # Qualquer versão recente
code --version           # VS Code (opcional)
```

### 1.2 Setup do Projeto
```bash
# Criar diretório principal
mkdir C:\Projetos\WhatsAppAgent
cd C:\Projetos\WhatsAppAgent

# Estrutura básica
mkdir src docker data\excel data\uploads data\logs scripts docs
```

### 1.3 Docker Compose Local
```yaml
# docker/docker-compose.yml
version: '3.8'

services:
  # PostgreSQL Database
  postgres:
    image: postgres:16-alpine
    container_name: whatsapp_postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: whatsapp_agent
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init-db.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - whatsapp_network

  # Redis for Evolution API
  redis:
    image: redis:7-alpine
    container_name: whatsapp_redis
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - whatsapp_network

  # Evolution API
  evolution-api:
    image: atendai/evolution-api:latest
    container_name: evolution_api
    restart: unless-stopped
    ports:
      - "8080:8080"
    environment:
      # Server
      SERVER_TYPE: http
      SERVER_PORT: 8080
      
      # Database
      REDIS_ENABLED: true
      REDIS_URI: redis://redis:6379
      REDIS_PREFIX_KEY: evolution
      
      # Webhook para nossa aplicação local
      WEBHOOK_GLOBAL_URL: 'http://host.docker.internal:5000/api/webhook/whatsapp'
      WEBHOOK_GLOBAL_ENABLED: true
      WEBHOOK_GLOBAL_WEBHOOK_BY_EVENTS: true
      
      # Auth
      AUTHENTICATION_API_KEY: 'local-dev-key-123'
      AUTHENTICATION_EXPOSE_IN_FETCH_INSTANCES: true
      
      # QR Code
      QRCODE_LIMIT: 10
      QRCODE_COLOR: '#198754'
      
      # Logs
      LOG_LEVEL: debug
      LOG_COLOR: true
      
      # Storage
      STORE_ENABLED: true
      STORE_CLEANUP: false  # Para desenvolvimento
      
    volumes:
      - evolution_instances:/evolution/instances
      - evolution_store:/evolution/store
    depends_on:
      - redis
    networks:
      - whatsapp_network

  # Whisper Speech-to-Text (Local)
  whisper:
    image: onerahmet/openai-whisper-asr-webservice:latest
    container_name: whatsapp_whisper
    restart: unless-stopped
    ports:
      - "9000:9000"
    environment:
      - ASR_MODEL=base
      - ASR_ENGINE=openai_whisper
    volumes:
      - whisper_cache:/root/.cache/whisper
    networks:
      - whatsapp_network

volumes:
  postgres_data:
  redis_data:
  evolution_instances:
  evolution_store:
  whisper_cache:

networks:
  whatsapp_network:
    driver: bridge
```

### 1.4 Script de Inicialização Local
```batch
@echo off
REM scripts/setup-local.bat

echo 🚀 Configurando ambiente local do WhatsApp Agent...

REM Criar arquivo de inicialização do banco
echo CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; > docker\init-db.sql
echo -- Database pronto para desenvolvimento >> docker\init-db.sql

REM Criar planilha de exemplo
if not exist "data\excel\produtos.xlsx" (
    echo 📊 Criando planilha de exemplo...
    REM Será criada automaticamente pela aplicação
)

REM Iniciar serviços Docker
echo 🐳 Iniciando serviços...
cd docker
docker-compose up -d

echo ⏳ Aguardando serviços iniciarem...
timeout /t 30

echo ✅ Serviços iniciados!
echo.
echo 🔗 URLs disponíveis:
echo - Evolution API: http://localhost:8080
echo - PostgreSQL: localhost:5432 (postgres/postgres123)
echo - Redis: localhost:6379
echo - Whisper: http://localhost:9000
echo.
echo 📱 Próximo passo: criar o projeto ASP.NET Core
pause
```

## Fase 2: Projeto ASP.NET Core (1 hora)

### 2.1 Criação da Solução
```bash
cd src

# Criar solução
dotnet new sln -n WhatsAppAgent

# Criar projetos
dotnet new webapi -n WhatsAppAgent.Api
dotnet new classlib -n WhatsAppAgent.Core
dotnet new classlib -n WhatsAppAgent.Infrastructure
dotnet new xunit -n WhatsAppAgent.Tests

# Adicionar projetos à solução
dotnet sln add WhatsAppAgent.Api
dotnet sln add WhatsAppAgent.Core
dotnet sln add WhatsAppAgent.Infrastructure
dotnet sln add WhatsAppAgent.Tests

# Configurar referências
dotnet add WhatsAppAgent.Api reference WhatsAppAgent.Core
dotnet add WhatsAppAgent.Api reference WhatsAppAgent.Infrastructure
dotnet add WhatsAppAgent.Infrastructure reference WhatsAppAgent.Core
dotnet add WhatsAppAgent.Tests reference WhatsAppAgent.Core
```

### 2.2 Pacotes NuGet
```xml
<!-- WhatsAppAgent.Api/WhatsAppAgent.Api.csproj -->
<Project Sdk="Microsoft.NET.Sdk.Web">

  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Serilog.AspNetCore" Version="8.0.1" />
    <PackageReference Include="Serilog.Sinks.Console" Version="5.0.1" />
    <PackageReference Include="Serilog.Sinks.File" Version="5.0.0" />
    <PackageReference Include="Swashbuckle.AspNetCore" Version="6.5.0" />
    <PackageReference Include="Hangfire.AspNetCore" Version="1.8.6" />
    <PackageReference Include="Hangfire.PostgreSql" Version="1.20.8" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.Design" Version="8.0.3" />
  </ItemGroup>

</Project>
```

```xml
<!-- WhatsAppAgent.Infrastructure/WhatsAppAgent.Infrastructure.csproj -->
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.EntityFrameworkCore" Version="8.0.3" />
    <PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="8.0.2" />
    <PackageReference Include="EPPlus" Version="7.0.5" />
    <PackageReference Include="Microsoft.Extensions.Http" Version="8.0.0" />
    <PackageReference Include="FirebirdSql.Data.FirebirdClient" Version="10.3.1" />
    <PackageReference Include="System.Text.Json" Version="8.0.3" />
  </ItemGroup>

</Project>
```

### 2.3 Configurações Locais
```json
// WhatsAppAgent.Api/appsettings.Development.json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "Microsoft.EntityFrameworkCore": "Information"
    }
  },
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=whatsapp_agent;Username=postgres;Password=postgres123"
  },
  "EvolutionApi": {
    "BaseUrl": "http://localhost:8080",
    "ApiKey": "local-dev-key-123",
    "InstanceName": "main-bot"
  },
  "Claude": {
    "ApiKey": "sua-claude-api-key-aqui"
  },
  "Whisper": {
    "BaseUrl": "http://localhost:9000"
  },
  "Products": {
    "ExcelPath": "..\\..\\data\\excel\\produtos.xlsx"
  },
  "AllowedHosts": "*"
}
```

## Fase 3: Modelos e Entidades (30 minutos)

### 3.1 Core Models
```csharp
// WhatsAppAgent.Core/Models/WhatsApp/WebhookMessage.cs
namespace WhatsAppAgent.Core.Models.WhatsApp;

public class WhatsAppWebhookMessage
{
    public string? Event { get; set; }
    public string? Instance { get; set; }
    public WebhookData? Data { get; set; }
    public string? Destination { get; set; }
    public DateTime DateReceived { get; set; } = DateTime.UtcNow;
}

public class WebhookData
{
    public MessageKey? Key { get; set; }
    public MessageInfo? Message { get; set; }
    public string? MessageType { get; set; }
    public string? Source { get; set; }
}

public class MessageKey
{
    public string? RemoteJid { get; set; }
    public bool FromMe { get; set; }
    public string? Id { get; set; }
}

public class MessageInfo
{
    public string? Conversation { get; set; }
    public AudioMessage? AudioMessage { get; set; }
    public long MessageTimestamp { get; set; }
    public string? MessageType { get; set; }
}

public class AudioMessage
{
    public string? Url { get; set; }
    public string? Mimetype { get; set; }
    public int? Seconds { get; set; }
}
```

```csharp
// WhatsAppAgent.Core/Models/Products/Product.cs
namespace WhatsAppAgent.Core.Models.Products;

public class Product
{
    public int Id { get; set; }
    public string Code { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public decimal Price { get; set; }
    public string? Category { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}
```

```csharp
// WhatsAppAgent.Core/Models/Chat/ChatSession.cs
namespace WhatsAppAgent.Core.Models.Chat;

public class ChatSession
{
    public Guid Id { get; set; }
    public string PhoneNumber { get; set; } = string.Empty;
    public string? UserName { get; set; }
    public DateTime StartedAt { get; set; } = DateTime.UtcNow;
    public DateTime LastMessageAt { get; set; } = DateTime.UtcNow;
    public bool IsActive { get; set; } = true;
    public string? Context { get; set; }
    public List<ChatMessage> Messages { get; set; } = new();
}

public class ChatMessage
{
    public Guid Id { get; set; }
    public Guid SessionId { get; set; }
    public string Content { get; set; } = string.Empty;
    public bool IsFromUser { get; set; }
    public MessageType Type { get; set; } = MessageType.Text;
    public DateTime SentAt { get; set; } = DateTime.UtcNow;
    public string? WhatsAppMessageId { get; set; }
    public ChatSession? Session { get; set; }
}

public enum MessageType
{
    Text,
    Audio,
    Image,
    Document
}
```

## Fase 4: Services (2 horas)

### 4.1 Product Service (Excel)
```csharp
// WhatsAppAgent.Infrastructure/Services/ProductService.cs
using OfficeOpenXml;
using WhatsAppAgent.Core.Models.Products;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace WhatsAppAgent.Infrastructure.Services;

public class ProductService
{
    private readonly string _excelPath;
    private readonly ILogger<ProductService> _logger;
    private List<Product>? _cachedProducts;
    private DateTime _lastCacheTime = DateTime.MinValue;
    private readonly TimeSpan _cacheTimeout = TimeSpan.FromMinutes(5);

    public ProductService(IConfiguration configuration, ILogger<ProductService> logger)
    {
        _excelPath = configuration["Products:ExcelPath"] ?? "produtos.xlsx";
        _logger = logger;
        ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
    }

    public async Task<List<Product>> GetAllProductsAsync()
    {
        try
        {
            if (_cachedProducts != null && DateTime.UtcNow - _lastCacheTime < _cacheTimeout)
            {
                return _cachedProducts;
            }

            return await LoadProductsFromExcelAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error loading products");
            return new List<Product>();
        }
    }

    public async Task<Product?> FindProductAsync(string searchTerm)
    {
        var products = await GetAllProductsAsync();
        
        return products.FirstOrDefault(p => 
            p.Name.Contains(searchTerm, StringComparison.OrdinalIgnoreCase) ||
            p.Code.Contains(searchTerm, StringComparison.OrdinalIgnoreCase) ||
            (p.Description?.Contains(searchTerm, StringComparison.OrdinalIgnoreCase) ?? false)
        );
    }

    public async Task<List<Product>> SearchProductsAsync(string searchTerm)
    {
        var products = await GetAllProductsAsync();
        
        return products.Where(p => 
            p.Name.Contains(searchTerm, StringComparison.OrdinalIgnoreCase) ||
            p.Code.Contains(searchTerm, StringComparison.OrdinalIgnoreCase) ||
            (p.Description?.Contains(searchTerm, StringComparison.OrdinalIgnoreCase) ?? false)
        ).Take(10).ToList(); // Limitar a 10 resultados
    }

    private async Task<List<Product>> LoadProductsFromExcelAsync()
    {
        var products = new List<Product>();

        try
        {
            // Resolver caminho absoluto
            var fullPath = Path.IsPathRooted(_excelPath) ? _excelPath : Path.Combine(Directory.GetCurrentDirectory(), _excelPath);
            
            if (!File.Exists(fullPath))
            {
                _logger.LogWarning("Excel file not found at {Path}, creating sample file", fullPath);
                await CreateSampleExcelAsync(fullPath);
            }

            using var package = new ExcelPackage(new FileInfo(fullPath));
            var worksheet = package.Workbook.Worksheets.FirstOrDefault();
            
            if (worksheet == null)
            {
                _logger.LogWarning("No worksheet found in Excel file");
                return products;
            }
            
            var rowCount = worksheet.Dimension?.Rows ?? 0;
            _logger.LogInformation("Loading {RowCount} rows from Excel", rowCount);
            
            for (int row = 2; row <= rowCount; row++) // Começar da linha 2
            {
                try
                {
                    var product = new Product
                    {
                        Id = row - 1,
                        Code = worksheet.Cells[row, 1].Text.Trim(),
                        Name = worksheet.Cells[row, 2].Text.Trim(),
                        Description = worksheet.Cells[row, 3].Text.Trim(),
                        Price = decimal.TryParse(worksheet.Cells[row, 4].Text.Replace(",", "."), out var price) ? price : 0,
                        Category = worksheet.Cells[row, 5].Text.Trim(),
                        IsActive = !worksheet.Cells[row, 6].Text.Equals("Não", StringComparison.OrdinalIgnoreCase)
                    };

                    if (!string.IsNullOrEmpty(product.Name))
                    {
                        products.Add(product);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogWarning(ex, "Error processing row {Row}", row);
                }
            }

            _cachedProducts = products;
            _lastCacheTime = DateTime.UtcNow;
            
            _logger.LogInformation("Loaded {ProductCount} products from Excel", products.Count);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error loading products from Excel");
        }

        return products;
    }

    private async Task CreateSampleExcelAsync(string filePath)
    {
        try
        {
            // Criar diretório se não existir
            var directory = Path.GetDirectoryName(filePath);
            if (!string.IsNullOrEmpty(directory) && !Directory.Exists(directory))
            {
                Directory.CreateDirectory(directory);
            }

            using var package = new ExcelPackage();
            var worksheet = package.Workbook.Worksheets.Add("Produtos");
            
            // Headers
            worksheet.Cells[1, 1].Value = "Código";
            worksheet.Cells[1, 2].Value = "Nome";
            worksheet.Cells[1, 3].Value = "Descrição";
            worksheet.Cells[1, 4].Value = "Preço";
            worksheet.Cells[1, 5].Value = "Categoria";
            worksheet.Cells[1, 6].Value = "Ativo";
            
            // Produtos de exemplo
            var sampleProducts = new[]
            {
                new { Code = "EXT001", Name = "Exatic Pro", Desc = "Lente de alto desempenho para óculos esportivos", Price = 299.00, Cat = "Lentes Esportivas", Active = "Sim" },
                new { Code = "CLS002", Name = "Classic Vision", Desc = "Lente clássica para uso diário", Price = 150.00, Cat = "Lentes Básicas", Active = "Sim" },
                new { Code = "ULT003", Name = "Ultra Clear", Desc = "Lente com tecnologia anti-reflexo avançada", Price = 450.00, Cat = "Lentes Premium", Active = "Sim" },
                new { Code = "SPT004", Name = "Sport Max", Desc = "Lente polarizada para esportes aquáticos", Price = 380.00, Cat = "Lentes Esportivas", Active = "Sim" },
                new { Code = "COM005", Name = "Comfort Plus", Desc = "Lente com filtro de luz azul", Price = 220.00, Cat = "Lentes Conforto", Active = "Sim" }
            };

            for (int i = 0; i < sampleProducts.Length; i++)
            {
                var product = sampleProducts[i];
                var row = i + 2;
                
                worksheet.Cells[row, 1].Value = product.Code;
                worksheet.Cells[row, 2].Value = product.Name;
                worksheet.Cells[row, 3].Value = product.Desc;
                worksheet.Cells[row, 4].Value = product.Price;
                worksheet.Cells[row, 5].Value = product.Cat;
                worksheet.Cells[row, 6].Value = product.Active;
            }

            // Formatação
            worksheet.Cells.AutoFitColumns();
            worksheet.Cells[1, 1, 1, 6].Style.Font.Bold = true;

            await package.SaveAsAsync(new FileInfo(filePath));
            _logger.LogInformation("Sample Excel file created at {Path}", filePath);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating sample Excel file");
        }
    }
}
```

### 4.2 Evolution API Service
```csharp
// WhatsAppAgent.Infrastructure/Services/EvolutionApiService.cs
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace WhatsAppAgent.Infrastructure.Services;

public class EvolutionApiService
{
    private readonly HttpClient _httpClient;
    private readonly string _apiKey;
    private readonly string _instanceName;
    private readonly ILogger<EvolutionApiService> _logger;

    public EvolutionApiService(HttpClient httpClient, IConfiguration configuration, ILogger<EvolutionApiService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
        _apiKey = configuration["EvolutionApi:ApiKey"] ?? throw new ArgumentNullException("EvolutionApi:ApiKey");
        _instanceName = configuration["EvolutionApi:InstanceName"] ?? "main-bot";
        
        _httpClient.DefaultRequestHeaders.Add("apikey", _apiKey);
    }

    public async Task<bool> SendTextMessageAsync(string phoneNumber, string message)
    {
        try
        {
            // Garantir que o número está no formato correto
            var formattedNumber = phoneNumber.Replace("@s.whatsapp.net", "");
            
            var payload = new
            {
                number = formattedNumber,
                text = message
            };

            var json = JsonSerializer.Serialize(payload);
            var content = new StringContent(json, Encoding.UTF8, "application/json");
            
            _logger.LogInformation("Sending message to {Phone}: {Message}", formattedNumber, message);
            
            var response = await _httpClient.PostAsync($"/message/sendText/{_instanceName}", content);
            
            if (response.IsSuccessStatusCode)
            {
                _logger.LogInformation("Message sent successfully to {Phone}", formattedNumber);
                return true;
            }
            else
            {
                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning("Failed to send message to {Phone}. Status: {Status}, Content: {Content}", 
                    formattedNumber, response.StatusCode, errorContent);
                return false;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error sending message to {Phone}", phoneNumber);
            return false;
        }
    }

    public async Task<byte[]?> DownloadMediaAsync(string mediaUrl)
    {
        try
        {
            _logger.LogInformation("Downloading media from {Url}", mediaUrl);
            
            var response = await _httpClient.GetAsync(mediaUrl);
            if (response.IsSuccessStatusCode)
            {
                var data = await response.Content.ReadAsByteArrayAsync();
                _logger.LogInformation("Downloaded {Size} bytes from {Url}", data.Length, mediaUrl);
                return data;
            }
            
            _logger.LogWarning("Failed to download media from {Url}. Status: {Status}", mediaUrl, response.StatusCode);
            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error downloading media from {Url}", mediaUrl);
            return null;
        }
    }

    public async Task<bool> CreateInstanceAsync()
    {
        try
        {
            var payload = new
            {
                instanceName = _instanceName,
                token = _instanceName + "-token",
                qrcode = true,
                webhook = "http://host.docker.internal:5000/api/webhook/whatsapp",
                webhookByEvents = true,
                webhookBase64 = false,
                markMessagesRead = true
            };

            var json = JsonSerializer.Serialize(payload);
            var content = new StringContent(json, Encoding.UTF8, "application/json");
            
            _logger.LogInformation("Creating WhatsApp instance: {InstanceName}", _instanceName);
            
            var response = await _httpClient.PostAsync("/instance/create", content);
            
            if (response.IsSuccessStatusCode)
            {
                _logger.LogInformation("Instance created successfully: {InstanceName}", _instanceName);
                return true;
            }
            else
            {
                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning("Failed to create instance. Status: {Status}, Content: {Content}", 
                    response.StatusCode, errorContent);
                return false;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating WhatsApp instance");
            return false;
        }
    }

    public async Task<string?> GetQrCodeAsync()
    {
        try
        {
            var response = await _httpClient.GetAsync($"/instance/qrcode/{_instanceName}");
            
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                return content;
            }
            
            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting QR code");
            return null;
        }
    }
}
```

### 4.3 Whisper Service
```csharp
// WhatsAppAgent.Infrastructure/Services/WhisperService.cs
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace WhatsAppAgent.Infrastructure.Services;

public class WhisperService
{
    private readonly HttpClient _httpClient;
    private readonly string _baseUrl;
    private readonly ILogger<WhisperService> _logger;

    public WhisperService(HttpClient httpClient, IConfiguration configuration, ILogger<WhisperService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
        _baseUrl = configuration["Whisper:BaseUrl"] ?? "http://localhost:9000";
    }

    public async Task<string?> TranscribeAudioAsync(byte[] audioData, string fileName = "audio.ogg")
    {
        try
        {
            _logger.LogInformation("Transcribing audio: {FileName}, Size: {Size} bytes", fileName, audioData.Length);
            
            using var form = new MultipartFormDataContent();
            using var audioContent = new ByteArrayContent(audioData);
            
            audioContent.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("audio/ogg");
            form.Add(audioContent, "audio_file", fileName);
            form.Add(new StringContent("transcribe"), "task");
            form.Add(new StringContent("pt"), "language"); // Português
            
            var response = await _httpClient.PostAsync($"{_baseUrl}/asr", form);
            
            if (response.IsSuccessStatusCode)
            {
                var result = await response.Content.ReadAsStringAsync();
                var transcription = JsonSerializer.Deserialize<WhisperResponse>(result);
                
                _logger.LogInformation("Audio transcribed successfully: {Text}", transcription?.Text);
                return transcription?.Text;
            }
            else
            {
                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning("Failed to transcribe audio. Status: {Status}, Content: {Content}", 
                    response.StatusCode, errorContent);
                return null;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error transcribing audio");
            return null;
        }
    }

    private class WhisperResponse
    {
        public string? Text { get; set; }
    }
}
```

### 4.4 Claude API Service
```csharp
// WhatsAppAgent.Infrastructure/Services/ClaudeService.cs
using System.Text;
using System.Text.Json;
using WhatsAppAgent.Core.Models.Products;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace WhatsAppAgent.Infrastructure.Services;

public class ClaudeService
{
    private readonly HttpClient _httpClient;
    private readonly string _apiKey;
    private readonly ILogger<ClaudeService> _logger;

    public ClaudeService(HttpClient httpClient, IConfiguration configuration, ILogger<ClaudeService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
        _apiKey = configuration["Claude:ApiKey"] ?? throw new ArgumentNullException("Claude:ApiKey");
        
        _httpClient.DefaultRequestHeaders.Add("x-api-key", _apiKey);
        _httpClient.DefaultRequestHeaders.Add("anthropic-version", "2023-06-01");
    }

    public async Task<string> ProcessMessageAsync(string userMessage, string? context = null, List<Product>? products = null)
    {
        try
        {
            var systemPrompt = BuildSystemPrompt(products);
            var fullMessage = BuildFullMessage(userMessage, context);

            var payload = new
            {
                model = "claude-3-sonnet-20240229",
                max_tokens = 1000,
                system = systemPrompt,
                messages = new[]
                {
                    new { role = "user", content = fullMessage }
                }
            };

            var json = JsonSerializer.Serialize(payload);
            var content = new StringContent(json, Encoding.UTF8, "application/json");
            
            _logger.LogInformation("Sending request to Claude API");
            
            var response = await _httpClient.PostAsync("https://api.anthropic.com/v1/messages", content);
            
            if (response.IsSuccessStatusCode)
            {
                var responseJson = await response.Content.ReadAsStringAsync();
                var claudeResponse = JsonSerializer.Deserialize<ClaudeResponse>(responseJson);
                
                var messageText = claudeResponse?.Content?.FirstOrDefault()?.Text ?? 
                    "Desculpe, não consegui processar sua mensagem.";
                
                _logger.LogInformation("Claude response received: {Response}", messageText);
                return messageText;
            }
            else
            {
                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning("Claude API error. Status: {Status}, Content: {Content}", 
                    response.StatusCode, errorContent);
                    
                return "Desculpe, estou temporariamente indisponível. Tente novamente em alguns instantes.";
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing message with Claude API");
            return "Desculpe, ocorreu um erro. Tente novamente em alguns instantes.";
        }
    }

    private string BuildSystemPrompt(List<Product>? products)
    {
        var prompt = new StringBuilder();
        
        prompt.AppendLine("Você é um assistente de vendas especializado em produtos ópticos da empresa Índio Produtos Ópticos.");
        prompt.AppendLine("Seja natural, amigável e prestativo em suas respostas.");
        prompt.AppendLine("Sempre responda em português brasileiro.");
        prompt.AppendLine("Use um tom conversacional, como se fosse um vendedor experiente e simpático.");
        
        if (products?.Any() == true)
        {
            prompt.AppendLine("\n=== PRODUTOS DISPONÍVEIS ===");
            foreach (var product in products)
            {
                prompt.AppendLine($"• {product.Name} (Código: {product.Code}): R$ {product.Price:F2}");
                if (!string.IsNullOrEmpty(product.Description))
                    prompt.AppendLine($"  {product.Description}");
                if (!string.IsNullOrEmpty(product.Category))
                    prompt.AppendLine($"  Categoria: {product.Category}");
                prompt.AppendLine();
            }
        }

        prompt.AppendLine("INSTRUÇÕES:");
        prompt.AppendLine("- Se o cliente perguntar sobre preços, sempre mencione o valor exato encontrado");
        prompt.AppendLine("- Se não encontrar o produto específico, sugira produtos similares");
        prompt.AppendLine("- Seja proativo: ofereça informações adicionais relevantes");
        prompt.AppendLine("- Se não souber alguma informação, seja honesto e ofereça ajuda para buscar a resposta");
        prompt.AppendLine("- Mantenha as respostas concisas mas informativas");
        
        return prompt.ToString();
    }

    private string BuildFullMessage(string userMessage, string? context)
    {
        if (string.IsNullOrEmpty(context))
            return userMessage;

        return $"[Contexto da conversa anterior: {context}]\n\nMensagem atual: {userMessage}";
    }

    private class ClaudeResponse
    {
        public ClaudeContent[]? Content { get; set; }
    }

    private class ClaudeContent
    {
        public string? Text { get; set; }
    }
}
```

## Fase 5: Controller Principal (1 hora)

### 5.1 Webhook Controller
```csharp
// WhatsAppAgent.Api/Controllers/WebhookController.cs
using Microsoft.AspNetCore.Mvc;
using WhatsAppAgent.Core.Models.WhatsApp;
using WhatsAppAgent.Infrastructure.Services;
using System.Text.Json;

namespace WhatsAppAgent.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class WebhookController : ControllerBase
{
    private readonly EvolutionApiService _evolutionApi;
    private readonly WhisperService _whisper;
    private readonly ClaudeService _claude;
    private readonly ProductService _productService;
    private readonly ILogger<WebhookController> _logger;

    public WebhookController(
        EvolutionApiService evolutionApi,
        WhisperService whisper,
        ClaudeService claude,
        ProductService productService,
        ILogger<WebhookController> logger)
    {
        _evolutionApi = evolutionApi;
        _whisper = whisper;
        _claude = claude;
        _productService = productService;
        _logger = logger;
    }

    [HttpPost("whatsapp")]
    public async Task<IActionResult> ReceiveWhatsAppMessage([FromBody] JsonElement webhookData)
    {
        try
        {
            var webhookJson = webhookData.GetRawText();
            _logger.LogInformation("Received webhook: {WebhookData}", webhookJson);
            
            var webhook = JsonSerializer.Deserialize<WhatsAppWebhookMessage>(webhookJson);
            
            if (webhook == null)
            {
                _logger.LogWarning("Failed to deserialize webhook data");
                return BadRequest("Invalid webhook data");
            }

            // Ignorar mensagens próprias
            if (webhook.Data?.Key?.FromMe == true)
            {
                _logger.LogDebug("Ignoring message from self");
                return Ok();
            }

            // Processar apenas eventos de mensagem
            if (webhook.Event != "messages.upsert")
            {
                _logger.LogDebug("Ignoring non-message event: {Event}", webhook.Event);
                return Ok();
            }

            var phoneNumber = webhook.Data?.Key?.RemoteJid?.Replace("@s.whatsapp.net", "");
            if (string.IsNullOrEmpty(phoneNumber))
            {
                _logger.LogWarning("Invalid phone number in webhook");
                return BadRequest("Invalid phone number");
            }

            // Processar mensagem em background para resposta rápida
            _ = Task.Run(async () => await ProcessMessageAsync(webhook, phoneNumber));

            return Ok(new { status = "received" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing webhook");
            return StatusCode(500, new { error = "Internal server error" });
        }
    }

    private async Task ProcessMessageAsync(WhatsAppWebhookMessage webhook, string phoneNumber)
    {
        try
        {
            _logger.LogInformation("Processing message from {Phone}", phoneNumber);
            
            string? messageContent = null;

            // Verificar se é mensagem de áudio
            if (webhook.Data?.Message?.AudioMessage != null)
            {
                _logger.LogInformation("Processing audio message from {Phone}", phoneNumber);
                messageContent = await ProcessAudioMessageAsync(webhook.Data.Message.AudioMessage);
                
                if (string.IsNullOrEmpty(messageContent))
                {
                    await _evolutionApi.SendTextMessageAsync(phoneNumber, 
                        "Desculpe, não consegui entender seu áudio. Pode tentar novamente ou escrever sua mensagem?");
                    return;
                }
                
                _logger.LogInformation("Audio transcribed from {Phone}: {Content}", phoneNumber, messageContent);
            }
            // Verificar se é mensagem de texto
            else if (!string.IsNullOrEmpty(webhook.Data?.Message?.Conversation))
            {
                messageContent = webhook.Data.Message.Conversation.Trim();
                _logger.LogInformation("Text message from {Phone}: {Content}", phoneNumber, messageContent);
            }

            if (string.IsNullOrEmpty(messageContent))
            {
                _logger.LogWarning("No valid message content found for {Phone}", phoneNumber);
                return;
            }

            // Buscar produtos relacionados na planilha
            var products = await _productService.SearchProductsAsync(messageContent);
            _logger.LogInformation("Found {ProductCount} related products for query: {Query}", 
                products.Count, messageContent);

            // Processar com Claude API
            var response = await _claude.ProcessMessageAsync(messageContent, null, products);

            // Enviar resposta
            var success = await _evolutionApi.SendTextMessageAsync(phoneNumber, response);
            
            if (success)
            {
                _logger.LogInformation("Response sent successfully to {Phone}: {Response}", phoneNumber, response);
            }
            else
            {
                _logger.LogWarning("Failed to send response to {Phone}", phoneNumber);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing message for {Phone}", phoneNumber);
            
            try
            {
                await _evolutionApi.SendTextMessageAsync(phoneNumber, 
                    "Desculpe, ocorreu um erro técnico. Nossa equipe foi notificada. Tente novamente em alguns instantes.");
            }
            catch (Exception sendEx)
            {
                _logger.LogError(sendEx, "Failed to send error message to {Phone}", phoneNumber);
            }
        }
    }

    private async Task<string?> ProcessAudioMessageAsync(AudioMessage audioMessage)
    {
        try
        {
            if (string.IsNullOrEmpty(audioMessage.Url))
            {
                _logger.LogWarning("Audio message has no URL");
                return null;
            }

            // Baixar áudio
            var audioData = await _evolutionApi.DownloadMediaAsync(audioMessage.Url);
            if (audioData == null || audioData.Length == 0)
            {
                _logger.LogWarning("Failed to download audio from {Url}", audioMessage.Url);
                return null;
            }

            // Transcrever com Whisper
            var transcription = await _whisper.TranscribeAudioAsync(audioData);
            
            if (string.IsNullOrEmpty(transcription))
            {
                _logger.LogWarning("Whisper returned empty transcription");
                return null;
            }

            return transcription.Trim();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing audio message");
            return null;
        }
    }

    // Endpoint para testes durante desenvolvimento
    [HttpGet("test")]
    public async Task<IActionResult> Test()
    {
        try
        {
            var products = await _productService.GetAllProductsAsync();
            
            return Ok(new { 
                status = "ok", 
                productsLoaded = products.Count,
                timestamp = DateTime.UtcNow,
                products = products.Take(3).Select(p => new { p.Name, p.Price }).ToList()
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error in test endpoint");
            return StatusCode(500, new { error = ex.Message });
        }
    }
}
```

## Fase 6: Program.cs e Startup (30 minutos)

### 6.1 Program.cs Completo
```csharp
// WhatsAppAgent.Api/Program.cs
using WhatsAppAgent.Infrastructure.Services;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Configurar Serilog
builder.Host.UseSerilog((context, config) =>
{
    config
        .ReadFrom.Configuration(context.Configuration)
        .WriteTo.Console()
        .WriteTo.File("../data/logs/whatsapp-agent-.log", 
            rollingInterval: RollingInterval.Day,
            retainedFileCountLimit: 30)
        .Enrich.WithProperty("Application", "WhatsAppAgent");
});

// Add services
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.PropertyNamingPolicy = null; // Manter nomes originais
        options.JsonSerializerOptions.WriteIndented = true;
    });

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new() { Title = "WhatsApp Agent API", Version = "v1" });
});

// HTTP Clients
builder.Services.AddHttpClient<EvolutionApiService>(client =>
{
    var baseUrl = builder.Configuration["EvolutionApi:BaseUrl"] ?? "http://localhost:8080";
    client.BaseAddress = new Uri(baseUrl);
    client.Timeout = TimeSpan.FromSeconds(30);
});

builder.Services.AddHttpClient<WhisperService>(client =>
{
    client.Timeout = TimeSpan.FromMinutes(2); // Áudio pode demorar mais
});

builder.Services.AddHttpClient<ClaudeService>(client =>
{
    client.Timeout = TimeSpan.FromSeconds(30);
});

// Application Services
builder.Services.AddScoped<ProductService>();

// CORS para desenvolvimento
builder.Services.AddCors(options =>
{
    options.AddPolicy("Development", policy =>
    {
        policy
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});

var app = builder.Build();

// Configure pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "WhatsApp Agent API V1");
        c.RoutePrefix = ""; // Swagger na raiz durante desenvolvimento
    });
    
    app.UseCors("Development");
}

app.UseSerilogRequestLogging();
app.UseRouting();
app.MapControllers();

// Endpoint de health check
app.MapGet("/health", () => new { 
    status = "healthy", 
    timestamp = DateTime.UtcNow,
    version = "1.0.0"
});

// Log de inicialização
app.Logger.LogInformation("🚀 WhatsApp Agent starting up...");
app.Logger.LogInformation("Environment: {Environment}", app.Environment.EnvironmentName);
app.Logger.LogInformation("Evolution API: {EvolutionUrl}", builder.Configuration["EvolutionApi:BaseUrl"]);

app.Run();
```

## Fase 7: Scripts de Desenvolvimento (30 minutos)

### 7.1 Script de Start Completo
```batch
@echo off
REM scripts/start-services.bat

echo 🚀 Iniciando WhatsApp Agent (Desenvolvimento Local)
echo.

REM Verificar se Docker está rodando
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker não está rodando! Inicie o Docker Desktop primeiro.
    pause
    exit /b 1
)

echo ✅ Docker está rodando

REM Navegar para diretório docker
cd /d "%~dp0..\docker"

echo 🐳 Iniciando serviços Docker...
docker-compose up -d

echo ⏳ Aguardando serviços iniciarem...
timeout /t 30 >nul

echo 📊 Status dos serviços:
docker-compose ps

echo.
echo 🔗 URLs disponíveis:
echo - Evolution API: http://localhost:8080
echo - PostgreSQL: localhost:5432 (postgres/postgres123)  
echo - Whisper: http://localhost:9000
echo.

REM Voltar para src e iniciar API .NET
cd /d "%~dp0..\src"

echo 🔨 Compilando aplicação .NET...
dotnet build

if errorlevel 1 (
    echo ❌ Erro na compilação!
    pause
    exit /b 1
)

echo ✅ Compilação bem-sucedida

echo 🚀 Iniciando API .NET...
echo Acesse: http://localhost:5000
echo.

cd WhatsAppAgent.Api
dotnet run --environment Development
```

### 7.2 Script de Setup WhatsApp
```batch
@echo off
REM scripts/setup-whatsapp.bat

echo 📱 Configurando WhatsApp...

set EVOLUTION_URL=http://localhost:8080
set API_KEY=local-dev-key-123

echo 🔧 Criando instância do WhatsApp...

curl -X POST "%EVOLUTION_URL%/instance/create" ^
  -H "Content-Type: application/json" ^
  -H "apikey: %API_KEY%" ^
  -d "{\"instanceName\": \"main-bot\", \"token\": \"main-bot-token\", \"qrcode\": true, \"webhook\": \"http://host.docker.internal:5000/api/webhook/whatsapp\", \"webhookByEvents\": true, \"webhookBase64\": false}"

echo.
echo 📲 Para ver o QR Code, acesse:
echo %EVOLUTION_URL%/instance/qrcode/main-bot
echo.
echo Ou execute: 
echo curl -H "apikey: %API_KEY%" "%EVOLUTION_URL%/instance/qrcode/main-bot"
echo.
pause
```

### 7.3 Script de Teste
```batch
@echo off
REM scripts/test-system.bat

echo 🧪 Testando sistema WhatsApp Agent...
echo.

REM Testar API .NET
echo 📡 Testando API .NET...
curl -s http://localhost:5000/health
if errorlevel 1 (
    echo ❌ API .NET não está respondendo
    goto :end
)
echo ✅ API .NET funcionando

REM Testar endpoint de produtos
echo 📊 Testando carregamento de produtos...
curl -s http://localhost:5000/api/webhook/test
if errorlevel 1 (
    echo ❌ Endpoint de produtos com erro
) else (
    echo ✅ Produtos carregados com sucesso
)

REM Testar Evolution API
echo 📱 Testando Evolution API...
curl -s -H "apikey: local-dev-key-123" http://localhost:8080/instance/fetchInstances
if errorlevel 1 (
    echo ❌ Evolution API não está respondendo
) else (
    echo ✅ Evolution API funcionando
)

REM Testar Whisper
echo 🎤 Testando Whisper...
curl -s http://localhost:9000/asr
if errorlevel 1 (
    echo ❌ Whisper não está respondendo
) else (
    echo ✅ Whisper funcionando
)

echo.
echo 📋 Resumo dos testes:
echo - Verifique se todos os serviços estão ✅
echo - Caso algum esteja ❌, reinicie com start-services.bat
echo.

:end
pause
```

## Fase 8: Testes e Validação (1 hora)

### 8.1 Sequência de Testes Manuais

```bash
# 1. Testar carregamento de produtos
curl http://localhost:5000/api/webhook/test

# 2. Simular webhook de mensagem de texto
curl -X POST http://localhost:5000/api/webhook/whatsapp \
  -H "Content-Type: application/json" \
  -d '{
    "event": "messages.upsert",
    "instance": "main-bot",
    "data": {
      "key": {
        "remoteJid": "5544999999999@s.whatsapp.net",
        "fromMe": false,
        "id": "test123"
      },
      "message": {
        "conversation": "Qual o preço do Exatic Pro?"
      }
    }
  }'

# 3. Verificar logs
tail -f ../data/logs/whatsapp-agent-*.log
```

## Cronograma de Desenvolvimento Local

### Dia 1 (4 horas)
- ✅ **30min**: Setup ambiente (Docker, .NET)
- ✅ **1h**: Criar projeto ASP.NET Core + estrutura
- ✅ **1h**: Implementar ProductService + planilha
- ✅ **1.5h**: Implementar EvolutionApiService

### Dia 2 (4 horas)  
- ✅ **1h**: Implementar WhisperService
- ✅ **1h**: Implementar ClaudeService
- ✅ **2h**: Implementar WebhookController + testes

### Dia 3 (2 horas)
- ✅ **1h**: Scripts de automação + configuração
- ✅ **1h**: Testes integrados + ajustes

## Checklist de Desenvolvimento

### Preparação
- [ ] Docker Desktop instalado e rodando
- [ ] .NET 8 SDK instalado
- [ ] Claude API Key obtida
- [ ] VS Code ou Visual Studio configurado

### Implementação
- [ ] Projeto ASP.NET Core criado
- [ ] Docker Compose configurado
- [ ] ProductService implementado
- [ ] EvolutionApiService implementado  
- [ ] WhisperService implementado
- [ ] ClaudeService implementado
- [ ] WebhookController implementado
- [ ] Scripts de automação criados

### Testes
- [ ] Planilha de produtos carregando
- [ ] Evolution API conectando
- [ ] Whisper transcrevendo (simulação)
- [ ] Claude respondendo
- [ ] Webhook recebendo mensagens
- [ ] Respostas sendo enviadas

### Deploy (Futuro)
- [ ] VPS configurado
- [ ] Docker Compose produção
- [ ] Variáveis de ambiente
- [ ] QR Code WhatsApp
- [ ] Monitoramento logs
- [ ] Backup configurado

---

## Resumo

Este plano te dá um **ambiente de desenvolvimento local completo** para criar seu agente de WhatsApp, com:

- ✅ **Desenvolvimento totalmente local** 
- ✅ **Todos os serviços via Docker**
- ✅ **Código ASP.NET Core estruturado**
- ✅ **Scripts de automação**
- ✅ **Sistema de testes**

**Custo durante desenvolvimento**: R$ 0 (exceto Claude API ~R$ 5-10 para testes)

**Tempo estimado**: 2-3 dias para ter tudo funcionando

Quer que eu comece implementando alguma parte específica agora?
