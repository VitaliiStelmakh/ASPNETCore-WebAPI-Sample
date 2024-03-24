# Use the .NET 7 SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app

# Copy csproj and restore any dependencies (via NuGet)
COPY ./SampleWebApiAspNetCore/*.csproj ./SampleWebApiAspNetCore/
RUN dotnet restore ./SampleWebApiAspNetCore/SampleWebApiAspNetCore.csproj

# Copy the project files and build the application
COPY ./SampleWebApiAspNetCore/ ./SampleWebApiAspNetCore/
RUN dotnet publish ./SampleWebApiAspNetCore/SampleWebApiAspNetCore.csproj -c Release -o out

# Use the .NET 7 runtime image to run the application
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose port 80 for the application
EXPOSE 80

# Start the application
ENTRYPOINT ["dotnet", "SampleWebApiAspNetCore.dll"]
