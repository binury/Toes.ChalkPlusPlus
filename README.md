# Chalk++

<img src="https://i.imgur.com/8TRBtmH.jpeg" width=512 alt="Chalk++ Banner Image">
<br/>
<a href="https://cara.app/purame"><small>Banner art by Ame</small></a>

<br/>
<br/>

<img src="https://i.imgur.com/Grs6byr.png" height=128 alt="Chalk++ Logo">

---

## 🎨 Usage

- Default hotkey: `Y` (changeable in settings).
- When active, benches and trees on canvases become invisible and intangible.

### Modes

- **Checkerboard (Half) dithering**
- **Dotted (1/9th) dithering**
- **Masking** (freehand)
- **Fill**
- **Symmetrical mirroring**

### Controls

1. Equip any chalk to start using Chalk++.
2. Press `Y` to cycle modes forward. Press `<Shift> + Y` to cycle _backwards_.
3. **Checkerboard brush offset:** Hold `<Shift>` while drawing.
4. **Masking:** Hold `<Ctrl>` while using dithering brushes.
   - You can now pick your masking color by clicking on the Chalk++ button in the UI!
   - OR, hold `<Alt>` while scrolling up or down to assign a masking color.
   - OR, `<Alt>` + click a canvas cell to set your mask to its color.
   - Chalk drawn outside your masking color is discarded.
5. **Fill tool:** Equip chalk/color → select _Fill_ mode → click an area to flood-fill.
6. **Quick erase:** Press `E` to erase without equipping the eraser.
   - Mode effects (mirror, brush patterns, etc.) still apply!

---

## ⚙️ Options

Options can be changed in-game via `Settings > Mods > Chalk++`,  
or by editing `GDWeave/configs/Toes.ChalkPlusPlus.json`.

- `useEraserAsChalk` (default: `true`)
  - `true`: Eraser behaves identical to a “brown chalk” with Chalk++ brush features.
  - `false`: Use eraser normally while in any mode.
- `drawingSounds` (default: `true`)
  - Hear immersive sound effects while drawing.
- `useFixedChalkTextures` (default: `true`)
  - "Fixes"/restores the chalk canvasses' original color palette

---


## [Changelog](https://thunderstore.io/c/webfishing/p/toes/Chalk_PlusPlus/changelog/)
## [Contributing (PRs welcomed)](https://github.com/binury/Toes.ChalkPlusPlus/pulls)
## [Known Issues](https://github.com/binury/Toes.ChalkPlusPlus/issues?q=sort%3Aupdated-desc+is%3Aissue+is%3Aopen)
## [Feedback & Bug Reports (Discord)](https://discord.gg/kjf3FCAMDb)
## [Roadmap & Feature Requests](https://github.com/binury/Toes.ChalkPlusPlus/issues?q=sort%3Aupdated-desc%20is%3Aissue%20is%3Aopen%20label%3Aenhancement)

---

## License

- All source code in this repository, except where otherwise noted, is licensed under [GPL-3](./LICENSE).
- Images, logos, and other media files are **not** covered by this license.  
  They are © and may not be used without explicit permission
