#  ISL Pocket Signs

A clean, mobile-first Flutter app for browsing and saving **Indian Sign Language (ISL)** signs — built as a personal reference tool, not a full learning platform.

---

## App Features

| Feature | Description |
|---|---|
| **Home Screen** | App title, search bar, 3 main action buttons |
| **Browse Alphabets** | A–Z grid, tap to open flashcard with sign image |
| **Browse Words** | 20 common ISL words with categories |
| **Search** | Live filter across all signs, letters, descriptions |
| **My Sign Cart** | Save/bookmark signs, swipe to remove, persists on device |
| **Sign Detail Screen** | Large flashcard, description, "How to sign" guide, Add to Cart |

---

## Getting Started

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

## Adding Real ISL Sign Images (IMPORTANT)

The app works immediately with placeholder visuals. To add real ISL sign images:

### Recommended Free ISL Image Sources

#### 1. ISLRTC (Official Government Source) Best
- **URL:** https://islrtc.nic.in
- **What:** Indian Sign Language Research & Training Centre — the official body
- **How:** Download the ISL Dictionary from their website (search "ISL dictionary")
- **Format:** PNG/JPEG images + some video demonstrations
- **License:** Government of India public resource

#### 2. INCLUDE Dataset (Research-grade) High Quality
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


## Future Enhancements (Roadmap Ideas)

- [ ] Video playback for animated signs (using `video_player` package)
- [ ] Quiz/flashcard practice mode
- [ ] Categories screen (Greetings, Numbers, Family...)
- [ ] Offline-first with full ISLRTC dictionary (1000+ signs)
- [ ] Text-to-ISL: type a sentence, see each word's sign
- [ ] Favorites sync via Firebase
- [ ] Accessibility: screen reader support, large text mode


---

*Made to make Indian Sign Language accessible to all.*
