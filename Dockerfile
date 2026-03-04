# Utiliza la imagen base de .NET SDK 9.0 para compilar la aplicación
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copia los archivos de proyecto y restaura las dependencias
COPY *.sln ./
COPY MyMinimalApi/*.csproj ./MyMinimalApi/
COPY MyMinimalApi.Tests/*.csproj ./MyMinimalApi.Tests/
RUN dotnet restore

# Copia el resto del código fuente y compila la aplicación
COPY . ./
WORKDIR /app/MyMinimalApi
RUN dotnet publish -c Release -o /out

# Utiliza la imagen base de .NET Runtime 9.0 para ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /out .

ENV ASPNETCORE_URLS=http://0.0.0.0:8080
# Expone el puerto en el que la aplicación escuchará
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["dotnet", "MyMinimalApi.dll"]
