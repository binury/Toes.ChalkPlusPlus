# Chalk++

![Chalk++ Banner Image](https://i.imgur.com/wvQTrR2.png)
<br/>
<a href="https://cara.app/purame"><small>Banner art by Ame</small></a>

<br/>

![Fill tool feedback](https://i.imgur.com/PotVZNc.png)
<br />

## 🎨 Usage

![](https://i.imgur.com/XbRnmAv.png 'UI Screenshot 1')
![](https://i.imgur.com/BE6nrlc.png 'UI Screenshot 2')

- Equip any chalk to start using Chalk++.
- Press `Y` to bring up the overlay UI and again to cycle modes forward.
  - Press `<Shift> + Y` to cycle _backwards_.
- Press on the Chalk++ button in the overlay to select a mode.
- Press on the palette button in the overlay to select a color mask.

---

### Masking

While masking, **chalk drawn outside your chosen masking color is discarded**.

- To use masking simply hold `<Ctrl>` while drawing with Chalk++ tools.
- Or, if you are going to be drawing for awhile, you can select and use the `freehand masking` mode.
- You can pick your masking color by clicking on the Chalk++ button in the UI...
  - OR, by holding `<Alt>` while scrolling up or down...
  - OR, `<Alt>` + clicking a canvas cell to set your mask to the cell's color.

### Modes

1. **Checkerboard (Half) dithering**
1. **Dotted (1/9th) dithering**
1. **Masking** (freehand)
1. **Bucket Fill**
1. **Line Tool**
1. **Symmetrical mirroring**

---

#### Checkerboard (½) dithering

![Checker brush example](https://i.imgur.com/wMdl3RO.png)

Brush pattern that is _half-filled_ with your chosen color

> [!TIP]
> Hold `<Shift>` while drawing to offset the grid pattern by 1x cell

#### Dotted (1/9th) dithering

![Dotting brush example](https://i.imgur.com/U4FiGfb.png)

Brush pattern of a square filled only with a single cell of your chosen color

### Bucket fill

![Fill example](https://i.imgur.com/jRmJKuT.png)

### Line tool

![Line tool example](https://i.imgur.com/n5lLcCS.png)

Press and drag to show a line preview. Release to set your line.

> [!TIP]
> You can mask while using the line tool, too! (Holding `<Control>`)

### Symmetrical Mirroring

![Mirror tool example](https://i.imgur.com/K5ilC4D.png)

## Tips

### Quick erase

![Quick erase screenshot](https://i.imgur.com/jbTFdtp.png)

Press `E` (configurable in settings) to erase without equipping the eraser.
**Mode effects (mirror, brush patterns, etc.) will apply to the eraser pattern!**

### When active, benches and trees on canvases become invisible and intangible

![Removed bench](https://i.imgur.com/qVby4Sb.png)

_If_ you are _using Calico_, you will need to [change a setting](https://github.com/binury/Toes.ChalkPlusPlus/issues/7) for this to work!!! (For now)

> [!TIP]
> Hold `<Shift>` while drawing to offset the grid

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
