# Changelog

### v1.5.1

- **New** Added an unlimited distance override for the limit at which players are were able to reach and draw on a canvas with chalk
  - You can now draw on canvasses without having to be directly on top of or touching them
- Fixed accidentally triggering eraser shortcut
- Fixed masking color scroll-selection [inadvertently zooming the camera](https://github.com/binury/Toes.ChalkPlusPlus/issues/13)

### v1.4.0 - QOL Enhancements

- Added new eraser shortcut: You can erase chalk _without ever needing to equip your eraser item_
  by pressing the `E` key.
  - Any mode transformations will still be respected, while erasing!
- Masking in mirror mode **_no longer masks the mirror_** - only whatever you are targeting with your chalk
- Added chalk drawing ambient sounds. You can disable these in the config [options](#options) if you prefer.

### v1.3.0 - Mirror Mode 🪞

- Added new mode: `Symmetrical Mirroring` that replicates your chalk drawings horizontally over the Y-axis!
  - Masking works for this mode and applies to both transformations being applied (This could change potentially later...)
  - We will consider adding X and/or Y symmetry toggling upon request, _if we receive any feedback or requests about this_.
  - We tried out X+Y symmetry and it was neat but not super useful-seeming 🤷
- While holding down `<CTRL>` to enable the masking utility, or using the masking tool, the UI overlay will
  now indicate that masking is active.

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

### _v1.0.0_

- Now requires [Tacklebox](https://thunderstore.io/c/webfishing/p/PuppyGirl/TackleBox/) as a dependency
  to manage hotkeys (since BlueberryWolfi's APIs haven't been updated in nearly a year and are _dysfunctional_-
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

- **_Now requires [Socks 0.4.0](https://thunderstore.io/c/webfishing/p/toes/Socks/versions/) - be sure to update that!_**
- Fixed Alt-tabbing while drawing - will no longer continue drawing as if your mouse is still held-down (Vanilla bug)
- Performance improvements!
- Your mode, masking color, etc. _now consistently reset to default between different lobbies_
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
