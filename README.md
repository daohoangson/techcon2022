# Techcon 2022

Full-stack Dart demo project.

## Logs

- This repository was first initialized as a Flutter project with `flutter create` CLI.
- The Flutter app icon has been replaced with the Techcon logo.
- An AWS Amplify project has been initialized with `amplify init`.
- Authentication has been setup with `amplify add auth`.
- Backend API has been setup with `amplify add api`, using AWS Fargate container-based deployment.
- Storage has been setup with `amplify add storage`, using a DynamoDB table to store thumb ups.

# Important files

- [api_client.dart](lib/src/api_client.dart) API client implementation using `Amplify.API`
- [api_server.dart](amplify/backend/api/techcon2022api/src/api_server.dart) API server entrypoint, supported endpoints:
  - `GET` returns total thumbs up
  - `POST` increases counter by 1
- [app_root.dart](lib/src/app_root.dart) Flutter root widget
- [app_screen.dart](lib/src/app_screen.dart) Flutter Home screen
