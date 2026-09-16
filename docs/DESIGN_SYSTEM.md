# Design System Documentation

The Super App UI utilizes a cohesive dark theme that feels premium, modern, and high-tech, while maintaining clear separation between modules using distinct accent colors.

## 1. Color Palette

### Backgrounds & Surfaces
- **Background**: `#0A0E21` (Deep Navy / Almost Black) - Used for app background.
- **Cards/Elevated**: `#141829` (Slightly Lighter Navy) - Used for primary cards.
- **Surface**: `#1C2039` - Used for bottom sheets, dialogs, and active states.

### Accents & Semantic Colors
- **Primary Accent**: `#FF6B35` (Vibrant Orange) - Primary CTAs, buttons, prices, Marketplace highlights.
- **Secondary Accent**: `#00C853` (Vibrant Green) - Success states, online indicators, Food module highlights, ratings.
- **Tertiary Accent**: `#2196F3` (Bright Blue) - Ride module highlights, map routes.

### Typography Colors
- **Primary Text**: `#FFFFFF` (White) - Headings, titles, primary info.
- **Secondary Text**: `#8E8E93` - Subtitles, descriptions.
- **Tertiary/Disabled**: `#6C6C70` - Placeholder text, disabled elements.

## 2. Typography
- **Font Family**: Inter (or system sans-serif like Roboto/San Francisco).
- **Weights**: Regular (400), Medium (500), SemiBold (600), Bold (700).
- **Sizes**:
  - H1: 24px, Bold
  - H2: 20px, SemiBold
  - H3: 18px, SemiBold
  - Body1: 16px, Regular/Medium
  - Body2: 14px, Regular
  - Caption: 12px, Regular
  - Micro: 10px, Medium (badges)

## 3. Spacing Scale
Uses an 8pt grid system.
- `4px`, `8px`, `12px`, `16px` (Standard padding), `20px`, `24px`, `32px`, `40px`, `48px`

## 4. Border Radius
- `8px`: Small elements (chips, small buttons).
- `12px`: Medium elements (inputs, standard buttons).
- `16px`: Standard cards (restaurants, products).
- `24px`: Bottom sheets (top corners).
- `999px`: Fully rounded (pills, circular avatars).

## 5. Component Specifications

### Layout & Navigation
- **AppBar**: Transparent on images, otherwise `#0A0E21`. Contains location selector and user avatar.
- **Bottom Navigation**: `#141829` background. 4 tabs (Home, Food, Rides, Bazaar). Active icon takes module's accent color.
- **Bottom Sheet**: `#1C2039` background, rounded top corners (`24px`).

### Cards
- **Module Cards**: Large touch targets on Home screen.
  - Food: Subtle green gradient overlay.
  - Rides: Subtle blue gradient overlay.
  - Marketplace: Subtle orange gradient overlay.
- **Restaurant Card**: Full-width or horizontal scroll. Image top (120px height), content below. Badges over the image.
- **Food Item Card**: Horizontal layout. Left: Title, price, description. Right: Square image (`96x96`) with a prominent 'ADD+' button overlapping the bottom.
- **Product Card (Bazaar)**: Vertical layout. Square image top, title, price badge overlay, location bottom.
- **Ride Vehicle Card**: Horizontal row. Icon left, name and description middle, price right.

### Inputs & Actions
- **Input Fields**: Background `#1C2039`, border-radius `12px`, search icon left, white text.
- **Buttons**:
  - Primary: `#FF6B35` background, white text, `12px` radius.
  - Secondary: Transparent background, `#FF6B35` outline.
  - Text: No background, primary accent text.
- **Filter Chips**: Rounded pills (`999px`). Default: outline `#6C6C70`. Selected: Background `#1C2039` with accent border.
- **Category Chips**: Rectangular or pill shape with icons and text below.

### Badges & Indicators
- **Status Badge**: Small dot + text (e.g., Green dot + "Preparing").
- **Rating Badge**: `#00C853` background, white text, star icon, small padding (`4px 8px`), radius `8px`.
- **Price Display**: Currency symbol in secondary text, value in primary text. Strikethrough for original price (`#8E8E93`).

## 6. Icons & Animation
- **Icons**: Suggest using Feather Icons, Phosphor Icons, or Material Symbols (Rounded variant). Keep stroke width consistent (1.5px or 2px).
- **Animations**:
  - Screen transitions: Slide left/right.
  - Bottom sheet: Slide up from bottom (ease-out, 300ms).
  - Buttons: Subtle scale down on press (0.95x).
  - Skeletons: Shimmer effect using `#141829` to `#1C2039` for loading states.
