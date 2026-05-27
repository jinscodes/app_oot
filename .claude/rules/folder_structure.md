```
  lib/
  ├── main.dart                          # App entry point (initializes AWS/Server, local caching)
  ├── app.dart                           # Root widget (manages global themes, localization, root routing)
  │
  ├── core/                              # SHARED CORE LAYER (Global code independent of specific menus)
  │   ├── constants/                     # Global constants (colors, text styles, asset paths, API endpoints)
  │   ├── network/                       # Backend configurations (Dio/Http setups, Token interceptors, WebSockets)
  │   ├── theme/                         # App-wide UI styling configuration (Light/Dark mode)
  │   ├── utils/                         # Global helper functions (Validators, geolocation/distance calculators)
  │   └── widgets/                       # GLOBAL REUSABLE UI (Atomic UI components used across multiple tabs)
  │       ├── buttons/                   # Custom gradient buttons, action buttons
  │       ├── inputs/                    # Custom text inputs, OTP verification layouts
  │       ├── feedback/                  # Custom loading wheels, "It's a Match!" celebration pop-ups
  │       └── components/                # Small reusable tokens (online indicator dots, verified badges)
  │
  └── features/                          # THE 4 MAIN MENUS (Each directory represents a core navigation view)
      │
      ├── navigation/                    # Shell navigation feature (Manages the persistent bottom navigation bar)
      │   └── presentation/
      │       ├── controllers/           # Handles active tab state transitions
      │       └── screens/               # main_navigation_hub_screen.dart (Houses the persistent 4-menu shell)
      │
      ├── auth_onboarding/               # Entry/Setup sequence (Kept separate from the 4 primary menus)
      │   ├── data/                      # Auth remote data sources, JSON models, repository implementations
      │   ├── domain/                    # Auth logic, validation rules, entities, use-cases
      │   └── presentation/              # Screens/widgets for login, phone verification, profile initialization
      │
      │  // ==========================================
      │  // MENU 1: DISCOVERY & SWIPE (Main Home)
      │  // ==========================================
      ├── discovery/                     # Introduces potential partners, filters profiles
      │   ├── data/                      # Fetches profile suggestions based on location/preferences from your DB
      │   ├── domain/                    # Business logic (e.g., matching rules, gesture velocity rules)
      │   └── presentation/
      │       ├── controllers/           # Manages deck indexing, swipe tracking states
      │       ├── screens/               # home_swipe_screen.dart (The primary active view)
      │       └── widgets/
      │           ├── layout/            # card_deck_stack_layout.dart (Handles stacking layers)
      │           ├── common/            # action_control_ribbon.dart (Like, Pass, Superlike button layouts)
      │           └── components/        # user_card_gesture_detector.dart, expandable_bio_panel.dart
      │
      │  // ==========================================
      │  // MENU 2: LIKES & MATCHES
      │  // ==========================================
      ├── connections/                   # Handles Likes Me, My Likes, and established Matches
      │   ├── data/                      # Queries server for relational interactions, likes histories
      │   ├── domain/                    # Logic for filtering incoming likes vs. match queues
      │   └── presentation/
      │       ├── controllers/           # Toggles states between the sub-views (Likes Me / My Likes / Matches)
      │       ├── screens/               # connections_hub_screen.dart (The container holding the tabs)
      │       └── widgets/
      │           ├── layout/            # grid_view_builders/ (Handles layout for 'Likes Me' profile discovery grid)
      │           ├── common/            # match_queue_horizontal_list.dart (Active matches ready to be messaged)
      │           └── components/        # blurred_profile_card.dart (For premium walls), match_thumbnail_card.dart
      │
      │  // ==========================================
      │  // MENU 3: CHAT & MESSAGING
      │  // ==========================================
      ├── chat/                          # Messaging interface and WebSocket communication
      │   ├── data/                      # Interacts with API endpoints for historical payloads, local SQLite caching
      │   ├── domain/                    # Clean logic handling message distribution rules, media encoding
      │   └── presentation/
      │       ├── controllers/           # Direct integration with WebSocket/Socket.io stream flows
      │       ├── screens/               # chat_list_screen.dart (Inbox list), active_chat_room_screen.dart
      │       └── widgets/
      │           ├── layout/            # message_stream_list_view.dart (Constructs active text feeds)
      │           ├── common/            # chat_input_accessory_bar.dart (Text inputs, photo select button layouts)
      │           └── components/        # text_chat_bubble.dart, image_chat_bubble.dart, audio_player_bubble.dart
      │
      │  // ==========================================
      │  // MENU 4: PROFILE & SETTINGS
      │  // ==========================================
      └── profile/                       # Current user account management
          ├── data/                      # Sends updated bio details and uploads media files directly to cloud storage (e.g., AWS S3)
          ├── domain/                    # Image compression parameters, data validation logic
          └── presentation/
              ├── controllers/           # Coordinates account states, premium status updates, and field validations
              ├── screens/               # self_profile_screen.dart, edit_photos_screen.dart, app_settings_screen.dart
              └── widgets/
                  ├── layout/            # photo_grid_reorder_layout.dart (Handles draggable profiles photos)
                  ├── common/            # premium_features_dashboard.dart, settings_option_tile_list.dart
                  └── components/        # profile_image_placeholder.dart, attribute_toggle_chip.dart
```
