# 🥐 Jagdish Foods — Flutter App
### Vadodara's Taste Since 1945 · Production-Ready D2C Mobile App

## 🚀 Build APK Instantly (GitHub Actions — Zero Setup)

```bash
git init && git add . && git commit -m "Jagdish Foods"
git remote add origin https://github.com/YOUR_USERNAME/jagdish-foods.git
git push -u origin main
# → GitHub → Actions → Build APK → Download Artifact (takes ~8 min)
```

## 🔧 Local Build

```bash
flutter pub get
flutter build apk --debug    # Fast test build
flutter build apk --release  # Optimised release
# APK at: build/app/outputs/flutter-apk/
```

## 📲 Install on Phone

Transfer APK → Settings → Security → Unknown Sources → Tap APK

## 📱 All 17 Screens

Splash · Welcome · Phone+OTP Auth · Home (Banners/Categories/Reorder/BestSellers/Combos) · Search · Category Listing · Product Detail · Cart · Checkout · Order Success · Orders List · Order Tracking · Profile · Edit Profile · Addresses · Wishlist · Offers

## 🏗️ Stack

Provider · GoRouter 14 · SharedPreferences · flutter_animate · Dio · Material 3

## 🎨 Brand Colors

- Primary: #0083BC (Blue)  · Green: #52B52A  · Yellow: #F4A300
- Gold: #D4AF37  · Cream: #FFF5E1  · BG: #F5F7FA

## 🛒 Cart Coupons (Mock)

SAVE10 · WELCOME20 · FREESHIP · DIWALI30

## 🧪 Tests

```bash
flutter test
```

App ID: com.jagdishfoods.app · Min SDK: 21 (Android 5.0+)
