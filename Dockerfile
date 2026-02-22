# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Project .csproj is in the "complexity" subfolder, so we need to copy it first to restore dependencies
COPY complexity/*.csproj ./
RUN dotnet restore

# Copy only the project folder contents into the build context
COPY complexity/. .
RUN dotnet publish -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Expose the port the application will run on
EXPOSE 8080
# Set the entry point for the application
ENTRYPOINT ["dotnet", "complexity.dll"]