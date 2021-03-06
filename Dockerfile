FROM mcr.microsoft.com/dotnet/core/sdk:4.5.2 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY MindShift/*.csproj ./MindShift/
RUN dotnet restore

# copy everything else and build app
COPY MindShift/. ./MindShift/
WORKDIR /app/MindShift
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:4.5.2 AS runtime
WORKDIR /app
COPY --from=build /app/MindShift/out ./
ENTRYPOINT ["dotnet", "MindShift.dll"]