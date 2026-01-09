# sudz

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Backend endpoint constants

The mobile app consumes the backend contract defined in the Postman collections
(`Sudz_Customer_API.postman_collection.json`, `Sudz_Technician_API.postman_collection.json`
and `Sudz_Custom_Extensions.postman_collection.json`). Run the generator whenever
the backend contract changes:

```bash
CI=true dart run tool/generate_endpoints.dart \
  Sudz_Customer_API.postman_collection.json \
  Sudz_Technician_API.postman_collection.json \
  Sudz_Custom_Extensions.postman_collection.json
```

This produces `lib/core/consts/app_endpoints.dart`, which contains strongly typed
endpoint definitions (method + path) that the repositories/data sources can consume.
