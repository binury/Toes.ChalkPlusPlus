# Chalk++

<img src="https://i.imgur.com/8TRBtmH.jpeg" width=1024 alt="Chalk++ Banner Image">
<a href="https://cara.app/purame"><small>Chalk++ art by Ame</small></a>

<br/>

<img src="https://i.imgur.com/Grs6byr.png" height=128>

## Installation

**_Make sure you don't have an older version of Chalk++ installed at the same time!_**

Manually unzip in your GDWeave directory to install

Or import this zip as a local mod through R2MM etc.

## Usage

`Y` is the default hotkey and is changeable. While using Chalk++,
the trees and benches on canvasses are made invisible and intangible.

### Modes

- Checkerboard (Half) dithering
- Dotted (1/9th) dithering
- Masking (freehand drawing)
- Fill
- Symmetrical Mirroring

### Controls

0. Equip a chalk to activate Chalk++

1. Press `Y` cycle modes, hold down `<shift>` + `Y` to cycle backwards

2. You can hold down `<SHIFT>` **while using checkerboard pattern** to offset the cells targeted by -- It's hard to explain but you'll see what I mean.

3. **you can mask while using dithering brushes, by holding `<CTRL>`**

4. In addition to alpha masking you can select a specific masking color by holding `<ALT>` and scrolling your mouse wheel-- any chalk that you draw outside of this color will be discarded

5. While holding down `<ALT>` click on a canvas cell to select the color of the cell as your masking color

6. To fill, equip the chalk/color you'd like to apply, select `fill` mode from the menu, and click on the color/area you wish to fill

7. You can erase chalk _without ever needing to equip your eraser item_ by pressing the `E` key.
   Any mode transformations will still be respected, while erasing

## Options

Chalk++ options can be changed in-game using the Tacklebox UI in settings
or by manually editing the `GDWeave\configs\Toes.ChalkPlusPlus.json` file.

- `useEraserAsChalk` (Default: `true`): whether or not holding eraser should be considered the same as holding a chalk. I.e., a 'brown chalk'.
  Changing this to `false` will allow you to use the eraser while in any mode.
  Setting this to `true` allows you to use the eraser as a chalk with Chalk++ features.
- `drawingSounds` (Default: `true`): If enabled, immersing sounds will play when drawing with Chalk++

## Project

### [Changelog](https://thunderstore.io/c/webfishing/p/toes/Chalk_PlusPlus/changelog/)

### [Contributing - pull requests welcomed](https://github.com/binury/Toes.ChalkPlusPlus/pulls)

### [Known Issues](https://github.com/binury/Toes.ChalkPlusPlus/issues?q=sort%3Aupdated-desc+is%3Aissue+is%3Aopen)

### [Report an issue / Feedback](https://discord.gg/kjf3FCAMDb)

### [Roadmap and feature requests](https://github.com/binury/Toes.ChalkPlusPlus/issues?q=sort%3Aupdated-desc%20is%3Aissue%20is%3Aopen%20label%3Aenhancement)
