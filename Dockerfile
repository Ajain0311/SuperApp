# ==============================================================================
# Multi-stage Dockerfile for SuperApp.API (.NET 10 ASP.NET Core)
# ==============================================================================

# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy solution and project files for layer caching
COPY ["SuperApp.sln", "./"]
COPY ["SuperApp.API/SuperApp.API.csproj", "SuperApp.API/"]
COPY ["SuperApp.API.Tests/SuperApp.API.Tests.csproj", "SuperApp.API.Tests/"]

RUN dotnet restore "SuperApp.sln"

# Copy remaining source files
COPY SuperApp.API/ SuperApp.API/
COPY SuperApp.API.Tests/ SuperApp.API.Tests/

# Run automated tests during image build to guarantee test passing before release
RUN dotnet test "SuperApp.API.Tests/SuperApp.API.Tests.csproj" -c Release --no-restore

# Publish API in Release mode
WORKDIR /src/SuperApp.API
RUN dotnet publish "SuperApp.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

# Ensure non-root user for enterprise container security
USER $APP_UID

# Environment defaults
ENV ASPNETCORE_HTTP_PORTS=8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Copy published artifacts and static web assets (Admin & Vendor Portals)
COPY --from=build /app/publish .

# Expose standard container port
EXPOSE 8080

ENTRYPOINT ["dotnet", "SuperApp.API.dll"]
