#!/usr/bin/env python3
"""
generate_placeholders.py

Generates SVG placeholder images for all ISL signs until real images are added.
These are high-quality visual placeholders that look professional in the app.

Usage:
    python3 generate_placeholders.py

Requirements:
    pip install cairosvg Pillow

Or just open the SVG files directly in any browser.
"""

import os
import json

# Alphabet letters
ALPHABET = list("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

# Word signs from words.json
WORDS = [
    "hello", "thankyou", "sorry", "friend", "water",
    "eat", "drink", "family", "yes", "no", "please",
    "help", "school", "home", "love", "good", "bad",
    "mother", "father", "namaste"
]

# ISL-themed gradient colors per letter/category
LETTER_COLORS = {
    'A': ('#1A6B4A', '#2E9B6E'), 'B': ('#1565C0', '#1976D2'),
    'C': ('#6A1B9A', '#8E24AA'), 'D': ('#C62828', '#E53935'),
    'E': ('#E65100', '#F57C00'), 'F': ('#2E7D32', '#388E3C'),
    'G': ('#00838F', '#00ACC1'), 'H': ('#283593', '#3949AB'),
    'I': ('#AD1457', '#D81B60'), 'J': ('#558B2F', '#689F38'),
    'K': ('#4527A0', '#5E35B1'), 'L': ('#00695C', '#00897B'),
    'M': ('#1A6B4A', '#2E9B6E'), 'N': ('#1565C0', '#1976D2'),
    'O': ('#6A1B9A', '#8E24AA'), 'P': ('#C62828', '#E53935'),
    'Q': ('#E65100', '#F57C00'), 'R': ('#2E7D32', '#388E3C'),
    'S': ('#00838F', '#00ACC1'), 'T': ('#283593', '#3949AB'),
    'U': ('#AD1457', '#D81B60'), 'V': ('#558B2F', '#689F38'),
    'W': ('#4527A0', '#5E35B1'), 'X': ('#00695C', '#00897B'),
    'Y': ('#FF7D26', '#FFA040'), 'Z': ('#1A6B4A', '#2E9B6E'),
}

WORD_COLOR = ('#1A6B4A', '#2E9B6E')  # Default green for words


def make_alphabet_svg(letter: str) -> str:
    c1, c2 = LETTER_COLORS.get(letter, ('#1A6B4A', '#2E9B6E'))
    return f"""<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400" viewBox="0 0 400 400">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:{c1};stop-opacity:1" />
      <stop offset="100%" style="stop-color:{c2};stop-opacity:1" />
    </linearGradient>
    <linearGradient id="circle_bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:rgba(255,255,255,0.25);stop-opacity:1" />
      <stop offset="100%" style="stop-color:rgba(255,255,255,0.10);stop-opacity:1" />
    </linearGradient>
  </defs>
  <!-- Background -->
  <rect width="400" height="400" fill="url(#bg)" rx="24"/>
  <!-- Decorative circles -->
  <circle cx="340" cy="60" r="80" fill="rgba(255,255,255,0.07)"/>
  <circle cx="60" cy="340" r="100" fill="rgba(255,255,255,0.05)"/>
  <circle cx="200" cy="200" r="120" fill="url(#circle_bg)"/>
  <!-- Letter -->
  <text x="200" y="230" font-family="Georgia, serif" font-size="160" font-weight="900"
        fill="white" text-anchor="middle" dominant-baseline="middle"
        style="filter: drop-shadow(0 4px 12px rgba(0,0,0,0.3))">{letter}</text>
  <!-- Label -->
  <rect x="140" y="300" width="120" height="36" rx="18" fill="rgba(255,255,255,0.2)"/>
  <text x="200" y="323" font-family="Arial, sans-serif" font-size="15" font-weight="700"
        fill="white" text-anchor="middle">ISL · Letter {letter}</text>
  <!-- Hand icon hint -->
  <text x="200" y="370" font-family="Arial, sans-serif" font-size="12"
        fill="rgba(255,255,255,0.6)" text-anchor="middle">Add image: assets/alphabet/{letter}.png</text>
</svg>"""


def make_word_svg(word_id: str) -> str:
    word = word_id.replace('_', ' ').title()
    c1, c2 = WORD_COLOR
    # Trim for display
    display = word[:8] if len(word) > 8 else word
    font_size = 72 if len(display) <= 5 else 54 if len(display) <= 8 else 42
    return f"""<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400" viewBox="0 0 400 400">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:{c1};stop-opacity:1" />
      <stop offset="100%" style="stop-color:{c2};stop-opacity:1" />
    </linearGradient>
  </defs>
  <rect width="400" height="400" fill="url(#bg)" rx="24"/>
  <circle cx="350" cy="50" r="90" fill="rgba(255,255,255,0.07)"/>
  <circle cx="50" cy="350" r="110" fill="rgba(255,255,255,0.05)"/>
  <!-- Hand icon -->
  <text x="200" y="160" font-family="Arial" font-size="80" text-anchor="middle"
        dominant-baseline="middle">🤟</text>
  <!-- Word -->
  <text x="200" y="245" font-family="Georgia, serif" font-size="{font_size}" font-weight="900"
        fill="white" text-anchor="middle" dominant-baseline="middle"
        style="filter: drop-shadow(0 3px 8px rgba(0,0,0,0.25))">{display}</text>
  <!-- Label bar -->
  <rect x="100" y="295" width="200" height="34" rx="17" fill="rgba(255,255,255,0.2)"/>
  <text x="200" y="317" font-family="Arial, sans-serif" font-size="13" font-weight="700"
        fill="white" text-anchor="middle">ISL Sign</text>
  <text x="200" y="370" font-family="Arial, sans-serif" font-size="11"
        fill="rgba(255,255,255,0.6)" text-anchor="middle">Add: assets/words/{word_id}.png</text>
</svg>"""


def main():
    # Create output directories
    alpha_dir = os.path.join('assets', 'alphabet')
    words_dir = os.path.join('assets', 'words')
    os.makedirs(alpha_dir, exist_ok=True)
    os.makedirs(words_dir, exist_ok=True)

    # Generate alphabet SVGs
    print("Generating alphabet placeholder SVGs...")
    for letter in ALPHABET:
        svg_content = make_alphabet_svg(letter)
        path = os.path.join(alpha_dir, f"{letter}.svg")
        with open(path, 'w') as f:
            f.write(svg_content)
        print(f"  ✓ {path}")

    # Generate word SVGs
    print("\nGenerating word placeholder SVGs...")
    for word_id in WORDS:
        svg_content = make_word_svg(word_id)
        path = os.path.join(words_dir, f"{word_id}.svg")
        with open(path, 'w') as f:
            f.write(svg_content)
        print(f"  ✓ {path}")

    print(f"\n✅ Generated {len(ALPHABET)} alphabet + {len(WORDS)} word SVGs")
    print("\n📌 Next steps to use PNG images instead:")
    print("  1. Download ISL images from ISLRTC: https://islrtc.nic.in")
    print("  2. Name them matching the JSON (e.g., A.png, hello.png)")
    print("  3. Place in assets/alphabet/ and assets/words/")
    print("  4. Update pubspec.yaml to include PNG files if needed")
    print("\n📌 To convert SVG→PNG (requires cairosvg):")
    print("  pip install cairosvg")
    print("  python3 -c \"import cairosvg; cairosvg.svg2png(url='assets/alphabet/A.svg', write_to='assets/alphabet/A.png', output_width=400, output_height=400)\"")


if __name__ == '__main__':
    main()
