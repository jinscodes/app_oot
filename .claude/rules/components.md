# Flutter Project Component Guidelines

## 1. Reuse Existing Components

- For components that have the same structure, they must be reused unconditionally.
- For reuse, check the `core/widgets` file or `features/*/presentation/widgets`

## 2. New Components

- When creating a new component, place it in a folder that fits its purpose.
- If the component is a small reusable token (e.g., online indicator dots, verified badges), place it in the `core/widgets/components` directory.
- If the component is specific to a feature, place it in the `presentation/widgets/components` directory of that feature.
- Make it versatile, so you can use it in as many places as possible without modification.
  - For example, a `UserCard` component should be designed to display user information in a way that can be used in both the discovery and connections features without needing changes.

## 3. Component Naming

- Name components descriptively based on their function and appearance.
- Use PascalCase for component names (e.g., `UserCard`, `ActionButton`).
- Avoid generic names like `CustomWidget` or `MyComponent`.
- Name the component for its purpose of use
  - For example, if a component is a card that displays user information, name it `UserCard` rather than `InfoCard` or `ProfileCard`.
- If the component is a specific variation of a more general component, include that in the name (e.g., `OnlineIndicatorDot`, `VerifiedBadge`).
