# Chalk++

<img src="https://i.imgur.com/8TRBtmH.jpeg" width=1024 alt="Chalk++ Banner Image">
<br>
<a href="https://cara.app/purame"><small>art by Ame</small></a>

<br/>

<img src="https://i.imgur.com/Grs6byr.png" height=128>

## Installation
***Make sure you don't have an older version of Chalk++ installed at the same time!***

Manually unzip in your GDWeave directory to install

Or import this zip as a local mod through R2MM etc.

## Usage

`Y` is the default hotkey and is changeable. While using Chalk++,
the trees and benches on cavasses are made invisible and intangible. 



### Modes
- Checkerboard (Half) dithering
- Dotted (1/9th) dithering
- Masking (freehand drawing)
- Fill



### Controls
0. Equip a chalk to activate Chalk++

1. Press `Y` cycle modes, hold down `<shift>` + `Y` to cycle backwards

2. You can hold down `<SHIFT>` **while using checkerboard pattern** to offset the cells targeted by  -- It's hard to explain but you'll see what I mean.

3. **you can mask while using dithering brushes, by holding `<CTRL>`**

4. In addition to alpha masking you can select a specific masking color by holding `<ALT>` and scrolling your mouse wheel-- any chalk that you draw outside of this color will be discarded

5.  While holding down `<ALT>`  click on a canvas cell to select the color of the cell as your masking color

6. To fill, equip the chalk/color you'd like to apply, select `fill` mode from the menu, and click on the color/area you wish to fill



## Options

Chalk++ options can be changed in-game using the Tacklebox UI in settings
or by manually editing the `GDWeave\configs\Toes.ChalkPlusPlus.json` file.

- `useEraserAsChalk` (Default: `true`): whether or not holding eraser should be considered the same as holding a chalk. I.e., a 'brown chalk'.
Changing this to `false` will allow you to use the eraser while in any mode.
Setting this to `true` allows you to use the eraser as a chalk with Chalk++ features.

## Project
### [Contributing - pull requests welcomed](https://github.com/binury/Toes.ChalkPlusPlus/pulls)
### [Known Issues](https://github.com/binury/Toes.ChalkPlusPlus/issues?q=sort%3Aupdated-desc+is%3Aissue+is%3Aopen)

### [Report an issue / Feedback](https://discord.gg/kjf3FCAMDb)

### [Roadmap and feature requests](https://github.com/binury/Toes.ChalkPlusPlus/issues?q=sort%3Aupdated-desc%20is%3Aissue%20is%3Aopen%20label%3Aenhancement)


## Changelog

### v1.2.0 - Eraser++
- Eraser now behaves by default _just like a chalk_. See [options](#options)
for more details and how to toggle this feature on/off.
- While using Chalk++, benches and trees on canvasses will be hidden.
    - If using Calico, a [small config change](https://github.com/binury/Toes.ChalkPlusPlus/issues/7) is needed in order for this to work, for now.
- Restored warning when attempting to fill the incompatible aquarium canvas.


### v1.1.0 - Fixes galore
- UI Overlay style refinement
- Fixed eraser being blocked by Chalk++
- Fixed large fills not propagating to peers (and therefore not persisting)
    - This shouldn't happen but please report if you are auto-kicked by an anti-Stamps mod for filling

### v1.0.2
- Hotfixed white chalk not working

### *v1.0.0*
- Now requires [Tacklebox](https://thunderstore.io/c/webfishing/p/PuppyGirl/TackleBox/) as a dependency
to manage hotkeys (since BlueberryWolfi's APIs haven't been updated in nearly a year and are *dysfunctional*-
not actually saving any of the player's keybind changes.
Somebody should make a better Webfishing API ...🤔)
- Minor changes/fixes
- Code overhaul

### v0.2.0 - UI Hotfix, Typeface change
- Hotfixed dangling UI dependency causing issues for some players
- Added cute font typeface for Chalk++ UI

### v0.1.0 - UI
- Added basic UI/HUD overlay for keeping track of mode selection and mask picking

### v0.0.12 - Performance and Quirk Fixes
- ***Now requires [Socks 0.4.0](https://thunderstore.io/c/webfishing/p/toes/Socks/versions/) - be sure to update that!***
- Fixed Alt-tabbing while drawing - will no longer continue drawing as if your mouse is still held-down (Vanilla bug)
- Performance improvements!
- Your mode, masking color, etc. *now consistently reset to default between different lobbies*
- Mostly unseen/internal code refactoring

### v0.0.11 - No-More-Stamps Mod Circumvention/Fix
- Large canvas fills are now batched when larger than 1000 cells in order to prevent tripping Stamp-mod detection (this would be extremely rare)

### v0.0.10 - Minor control enhancements
- You can now pick a masking color from a cell (`<alt>` clicking) while in _any_ mode, not just masking
- If you press `<shift>` in combination with your cycle-mode hotkey, it will cycle backwards instead of forwards

### v0.0.7 - Misc. Fixes and Cleanup
#### NOTE: You may need to rebind your hotkey, once!
- (FIX) Filling a blank canvas should now constrain pretty close to the canvas's circular shape rather than the entire square canvas
- Many misc. UI cleanup changes

### v0.0.6 - Fill feature
- (NEW FEAT) Color filling ("Paint bucket fill")

### v0.0.5 - Masking UX Improvements and fixes

- (NEW FEAT) Masking color picker: While in masking mode, hold down `<ALT>` and click on a canvas cell to select
the color of the sell as the new masking color!
- (FIX) You should no longer make accidental chalk marks unintentionally when using your inventory screen
- (CHANGE) Masking selections _should_ no longer reset when changing chalks