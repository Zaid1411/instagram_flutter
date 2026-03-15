# Instagram Clone - Flagship 2026 UI

A high-fidelity, pixel-perfect Flutter replica of the 2026 Instagram Home Feed. This project prioritizes visual excellence, buttery-smooth interactions, and mirror-precision matching of the official mobile design language.

## 🚀 Key Features

- **Mirror Precision UI**: 1:1 parity with the latest Instagram design, including high-fidelity SVGs, 14px SF NS typography, and specific action bar metrics.
- **Immersive Media**:
    - **Dynamic Carousels**: Multi-image horizontal scrolling with synchronized blue indicator dots.
    - **Flagship Pinch-to-Zoom**: Fluid, zero-clipping liquid zoom with haptic feedback and dynamic backdrop.
    - **Double-Tap Logic**: Immersive heart overlay with precise 800ms lifecycle and transition timing.
- **Mirror Smoothness Suite**:
    - **Repaint Isolation**: Uses `RepaintBoundary` to isolate animated components (Posts, Stories) for jank-free 60+ FPS performance.
    - **Advanced Scroll Mechanics**: Integrated `BouncingScrollPhysics` and high `cacheExtent` for a seamless, native iOS feel.
- **Flagship Loading**: Custom integrated SVG loading indicators and glassmorphic shimmer states.
- **Infinite Scrolling**: Page-based lazy loading with seamless appending.

## 🛠️ Tech Stack & Architecture

### State Management: **Provider**
We chose **Provider** for state management for several architectural reasons:
- **Pragmatic Flow**: It offers a clean, reactive approach to state that aligns perfectly with Flutter's widget-tree philosophy.
- **Performance**: High-frequency updates (like toggling a heart or updating carousel indices) are localized, preventing unnecessary rebuilds of static feed elements.
- **Clean Architecture**: Our repository and service layers are decoupled from the UI, allowing the `FeedProvider` to handle business logic while the widgets focus purely on mirror-precision rendering.

### Dependencies
- `provider`: Reactive state management
- `flutter_svg`: High-fidelity asset rendering
- `cached_network_image`: Optimized media loading
- `shimmer`: Flagship-grade loading states

## 📦 How to Run

Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and configured.

1.  **Clone the project** and navigate to the directory:
    ```bash
    cd instagram_flutter
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    - For **Chrome/Web** (Mirroring your current environment):
      ```bash
      flutter run -d chrome
      ```
    - For **iOS/Android Simulator**:
      ```bash
      flutter run
      ```

