How to run locally (quick start)

Clone repo.  git clone ...   clone Flutter SDK

Start server:

cd server

cp .env.example .env and set your keys

npm install

node server.js

Run mobile:

cd mobile

flutter pub get

flutter run (choose iOS simulator or device)


1. 1. Install Flutter

Download the latest Flutter SDK zip from the official site:
https://docs.flutter.dev/get-started/install/windows

Extract it somewhere like C:\src\flutter (avoid spaces in the path).

Do not put it inside C:\Program Files — Windows permissions can cause issues.

