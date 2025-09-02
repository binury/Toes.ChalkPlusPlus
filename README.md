# Chalk++

<img src="https://i.imgur.com/8TRBtmH.jpeg" width=512 alt="Chalk++ Banner Image">
<br/>
<a href="https://cara.app/purame"><small>Banner art by Ame</small></a>

<br/>
<br/>

<img src="https://i.imgur.com/Grs6byr.png" height=128 alt="Chalk++ Logo">

---

## 🎨 Usage

![](https://i.imgur.com/XbRnmAv.png 'UI Screenshot 1')
![](https://i.imgur.com/BE6nrlc.png 'UI Screenshot 2')

- Open Chalk++ Overlay: `Y` (changeable in settings).
- When active, benches and trees on canvases become invisible and intangible!

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

#### Line tool

The default behavior of line tool is to _chain lines_

```
A -> B -> C -> D
```

wherever you click it draws a line from the last click to there. Straightforward literally and figuratively.

**But** there are _two_ other controls for you to know:

**1. To end a chain and start a new line**

```
A->B->C  D->E
```

Hold down `<Ctrl>` to (stop chaining and) forcibly set the starting point a **new **line

**2. To draw a bunch of lines around a single point,**

```
B - A - D
    |
    C
```

- Hold down `<Shift>` when adding a line to retain the current segment as the origin point for your next line

---

## ⚙️ Options

Options can be changed in-game via `Settings > Mods > Chalk++`,  
or by editing `GDWeave/configs/Toes.ChalkPlusPlus.json`.

1. `useEraserAsChalk` (default: `true`)
    - `true`: Eraser behaves identical to a “brown chalk” with Chalk++ brush features.
    - `false`: Use eraser normally while in any mode.
2. `drawingSounds` (default: `true`)
    - Hear immersive sound effects while drawing.

<img src="https://i.imgur.com/cxETH3c.png">
<br/>

3. `useFixedChalkTextures` (default: `true`)
    - Restores the original RGB color palette texture to canvasses
    - Fixes a bug in the canvas tile's material/texture that causes it to _normally_ appear over-saturated (e.g., red looks magenta)

<img src="https://i.imgur.com/sj9jlJt.png" width="650">
<br/>

4. `glowInTheDarkChalk` (default: `true`)
  - Changes chalk to be unaffected by lighting/shadows
  - Primarily for usage with daytime lighting changing mods such as [Daylight](https://thunderstore.io/c/webfishing/p/baltdev/Daylight/)

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
