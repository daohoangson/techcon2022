FROM dart:2.18.2 as build

WORKDIR /api
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart pub get --offline
RUN dart compile exe api_server.dart -o server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /api/server /api/

EXPOSE 8080
CMD ["/api/server"]
