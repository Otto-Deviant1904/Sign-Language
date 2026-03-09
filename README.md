# 🤟 ISL Pocket Signs

A clean, mobile-first Flutter app for browsing and saving **Indian Sign Language (ISL)** signs — built as a personal reference tool, not a full learning platform.

---

## 📱 App Features

| Feature | Description |
|---|---|
| **Home Screen** | App title, search bar, 3 main action buttons |
| **Browse Alphabets** | A–Z grid, tap to open flashcard with sign image |
| **Browse Words** | 20 common ISL words with categories |
| **Search** | Live filter across all signs, letters, descriptions |
| **My Sign Cart** | Save/bookmark signs, swipe to remove, persists on device |
| **Sign Detail Screen** | Large flashcard, description, "How to sign" guide, Add to Cart |

---

## 🗂️ Project Structure

```
isl_pocket_signs/
├── lib/
│   ├── main.dart                    # App entry, splash screen
│   ├── models/
│   │   └── sign_model.dart          # AlphabetSign, WordSign, CartItem
│   ├── providers/
│   │   └── sign_provider.dart       # State management (ChangeNotifier)
│   ├── data/
│   │   └── app_theme.dart           # Colors, typography, theme
│   ├── screens/
│   │   ├── home_screen.dart         # Home + bottom nav
│   │   ├── alphabet_screen.dart     # A-Z grid
│   │   ├── words_screen.dart        # Word list with categories
│   │   ├── sign_detail_screen.dart  # Flashcard detail view
│   │   ├── cart_screen.dart         # Saved signs collection
│   │   └── search_results_screen.dart
│   └── widgets/
│       ├── sign_image_widget.dart   # Image display + fallback placeholder
│       └── cart_button.dart         # Add/Remove cart button
├── assets/
│   ├── data/
│   │   ├── alphabet.json            # A–Z sign data
│   │   └── words.json               # 20 common word signs
│   ├── alphabet/                    # Add A.png, B.png ... Z.png here
│   └── words/                       # Add hello.png, thankyou.png ... here
└── pubspec.yaml
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0 → [flutter.dev/install](https://flutter.dev/docs/get-started/install)
- Android Studio / VS Code with Flutter plugin
- Android emulator or iOS simulator (or physical device)

### Install & Run

```bash
# 1. Navigate to project
cd isl_pocket_signs

# 2. Get dependencies
flutter pub get

# 3. Run the app
flutter run

# For release APK
flutter build apk --release
```

---

## 🖼️ Adding Real ISL Sign Images (IMPORTANT)

The app works immediately with placeholder visuals. To add real ISL sign images:

### Recommended Free ISL Image Sources

#### 1. ISLRTC (Official Government Source) ✅ Best
- **URL:** https://islrtc.nic.in
- **What:** Indian Sign Language Research & Training Centre — the official body
- **How:** Download the ISL Dictionary from their website (search "ISL dictionary")
- **Format:** PNG/JPEG images + some video demonstrations
- **License:** Government of India public resource

#### 2. INCLUDE Dataset (Research-grade) ✅ High Quality
- **URL:** https://zenodo.org/record/4010759
- **What:** 263 ISL signs, 15,000+ video clips, consistent quality
- **How:** Request dataset access on Zenodo (free for academic use)
- **Format:** MP4 clips → extract frames as PNG

#### 3. IITK ISL Dataset
- **URL:** http://www.iitk.ac.in/iil/isl
- **What:** IIT Kanpur's ISL gesture dataset
- **Format:** Image sequences

#### 4. Spread the Sign (India)
- **URL:** https://www.spreadthesign.com/en.us/search/?q=hello&language=11
- Language code 11 = Indian Sign Language
- **How:** Screenshots of sign videos (non-commercial personal use)

### Image Naming Convention

Place images in the correct folder matching the JSON paths:

```
assets/alphabet/A.png
assets/alphabet/B.png
...
assets/alphabet/Z.png

assets/words/hello.png
assets/words/thankyou.png
assets/words/sorry.png
assets/words/friend.png
assets/words/water.png
assets/words/eat.png
assets/words/drink.png
assets/words/family.png
assets/words/yes.png
assets/words/no.png
assets/words/please.png
assets/words/help.png
assets/words/school.png
assets/words/home.png
assets/words/love.png
assets/words/good.png
assets/words/bad.png
assets/words/mother.png
assets/words/father.png
assets/words/namaste.png
```

### Image Recommendations
- **Format:** PNG (transparent background looks great) or JPG
- **Size:** 400×400px minimum, 800×800px ideal
- **Style:** White/light background, clear hand positioning
- **GIF support:** Rename `.gif` files and update the JSON `image` field to `.gif`

### Using GIFs for Animated Signs

Update any entry in `words.json` or `alphabet.json`:
```json
{ "word": "Hello", "image": "assets/words/hello.gif", ... }
```

The app handles GIFs natively via Flutter's `Image.asset()`.

---

## 🎨 Design System

| Color | Hex | Usage |
|---|---|---|
| Primary Green | `#1A6B4A` | App bar, buttons, accents |
| Saffron Orange | `#FF7D26` | Cart/saved state, accent |
| Surface | `#F7F9F7` | Background |
| Cards | `#FFFFFF` | Card backgrounds |

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `provider` | State management |
| `shared_preferences` | Cart persistence (survives app restart) |
| `cached_network_image` | Future-proof for network image support |
| `lottie` | Optional: animated sign demonstrations |

---

## 🔧 Customization

### Adding New Words
Edit `assets/data/words.json`:
```json
{
  "id": "water",
  "word": "Water",
  "image": "assets/words/water.png",
  "category": "Food & Drink",
  "description": "W handshape tapped on chin twice."
}
```

### Adding New Categories
Just use a new `category` string in `words.json` — the app will auto-detect it and add a filter chip.

### Changing Theme Colors
Edit `lib/data/app_theme.dart`:
```dart
static const Color primary = Color(0xFF1A6B4A); // Change this
static const Color accent = Color(0xFFFF7D26);  // And this
```

---

## 📋 Future Enhancements (Roadmap Ideas)

- [ ] Video playback for animated signs (using `video_player` package)
- [ ] Quiz/flashcard practice mode
- [ ] Categories screen (Greetings, Numbers, Family...)
- [ ] Offline-first with full ISLRTC dictionary (1000+ signs)
- [ ] Text-to-ISL: type a sentence, see each word's sign
- [ ] Favorites sync via Firebase
- [ ] Accessibility: screen reader support, large text mode

---

## 📄 License

App code: MIT License  
ISL Sign content: Based on ISLRTC standards (Government of India)

---

*Made with ❤️ to make Indian Sign Language accessible to all.*
