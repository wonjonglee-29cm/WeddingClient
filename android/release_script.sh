#!/bin/bash

# 릴리스 빌드를 위한 스크립트
echo "====== 시작: 안드로이드 릴리스 빌드 ======"

# Flutter 클린
echo "Flutter 클린 수행 중..."
flutter clean

# Pub Get
echo "Flutter 패키지 가져오는 중..."
flutter pub get

# 릴리스 빌드 (App Bundle)
echo "AAB 파일 빌드 중..."
flutter build appbundle --release

# 빌드 완료 후 위치 표시
echo ""
echo "====== 빌드 완료 ======"
echo "AAB 파일 위치: $(pwd)/build/app/outputs/bundle/release/app-release.aab"
echo ""
echo "이 파일을 Google Play Console에 업로드하세요."
