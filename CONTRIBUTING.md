# 🤝 Contributing to Wallom

Thank you for your interest in contributing to **Wallom** 🎮  
This project is an open-source terminal-based game built using PowerShell, and contributions are welcome!

---

## 📌 Code of Conduct

By participating in this project, you agree to:

- Be respectful and constructive
- Avoid offensive or harmful content
- Focus on improving the project
- Keep discussions technical and helpful

---

## 🧠 Project Philosophy

Wallom is designed as a **modular terminal game engine**, not just a script.

Key principles:

- Keep modules isolated (engine, UI, AI, DB)
- Avoid tightly coupled logic
- Maintain readability over complexity
- Preserve terminal performance
- Do not break existing gameplay flow

---

## 🧩 Project Structure

Before contributing, understand the architecture:

```

bin/
├── engine.ps1      # Core game loop (DO NOT MODIFY CARELESSLY)
├── grid.ps1        # Rendering system
├── enemy.ps1       # AI logic
├── bomb.ps1        # Game mechanics
├── db.ps1          # Persistence layer
├── colors.ps1      # UI theme system
├── splash.ps1      # Main menu controller
└── ui_*.ps1        # UI screens (help, credits, logo)

````

---

## 🚨 Rules for Contributions

### ✔ Allowed
- Bug fixes
- Performance improvements
- UI enhancements
- AI improvements
- New gameplay features (with discussion)
- Documentation improvements

### ❌ Not Allowed
- Breaking existing game loop without discussion
- Removing core mechanics (bombs, AI, grid)
- Adding external heavy dependencies
- Changing project structure without approval

---

## 🛠 Development Setup

1. Clone the repository
```bash id="setup1"
git clone https://github.com/KishanPujari/wallom.git
````

2. Run the game

```bash id="setup2"
Wallom.bat
```

---

## 🧪 Testing Guidelines

Before submitting a PR:

* Run full game cycle (start → play → exit)
* Ensure no runtime errors in PowerShell
* Check database.json integrity
* Verify UI rendering in terminal
* Test enemy movement + bomb logic

---

## 📦 Commit Guidelines

Use clear and meaningful commit messages:

### ✔ Good Examples

```
fix: resolve enemy movement edge bug
feat: add mine limit system
ui: improve help screen readability
refactor: optimize grid rendering loop
```

### ❌ Avoid

```
update
fix stuff
changes
```

---

## 🧩 Adding New Features

If you're adding a feature:

1. Discuss it first (optional but recommended)
2. Keep logic inside appropriate module
3. Avoid modifying engine.ps1 unless necessary
4. Update UI/help/credits if needed
5. Update README.md if gameplay changes

---

## 🎮 Feature Ideas (Open for Contribution)

* Smart enemy AI (A* pathfinding)
* Multiplayer hotseat mode
* Sound effects (beep-based)
* Level system
* Power-ups system
* Animated UI transitions
* Replay system

---

## 🧾 Pull Request Process

1. Fork the repository
2. Create a feature branch:

   ```
   feature/my-new-feature
   ```
3. Commit changes clearly
4. Push and open PR
5. Describe changes properly

---

## 👨‍💻 Maintainer

**Kishan Pujari**
📧 [kishanpujari.dev@gmail.com](mailto:kishanpujari.dev@gmail.com)

---

## ⭐ Final Note

This project is built for learning, experimentation, and fun.

Keep it:

* clean
* modular
* enjoyable 🎮

---

> “Build small. Think big. Play terminal.”