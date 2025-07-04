#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
COPY ["MicroHackApp.csproj", "."]
RUN dotnet restore "./MicroHackApp.csproj"
COPY . .
WORKDIR /app
RUN dotnet build "./MicroHackApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MicroHackApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MicroHackApp.dll"]
