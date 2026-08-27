# Changed for DOS

A DOS-era port / remake experiment of **Changed**, written in 16-bit x86 assembly.

> ⚠️ This project is experimental and currently in development. Expect bugs, rough edges, and unfinished systems.

## About

Changed for DOS is an attempt to bring a small playable version of Changed to a DOS-compatible 16-bit environment.

The current implementation uses BIOS/DOS services and the text-mode VGA memory at `0xB800` for the game display. Maps are stored as external binary resources and loaded at runtime.

## Current features

- 16-bit x86 assembly
- DOS executable entry point
- Text-mode rendering through `0xB800`
- Keyboard input through BIOS `INT 16h`
- Multiple rooms/maps
- Room transitions
- Basic wall/collision handling
- Death screen
- External binary map resources

## Project structure

```text
CFD/
├── MAP/          # Map resources
├── SCREEN/       # Screen/resources
├── main.asm      # Main game loop and player movement
├── map.asm       # Map loading and player-position detection
├── screens.asm   # Screen/death-screen routines
├── LICENSE       # MIT license
└── README.md
```

## Technical notes

The project is intentionally low-level. The player position is represented by an offset into text-mode video memory, and movement is performed by changing that offset. Collision checks inspect the character stored at the destination cell.

Maps are loaded through DOS file services and copied into video memory. The current source contains three map resource paths (`map\\map.bin`, `map\\map2.bin`, and `map\\map3.bin`).

## Building

Build instructions are **not documented yet** because the exact local toolchain/build configuration is still being finalized.

If you are interested in the project, the source code is the best reference for the current state.

## Status

🚧 **Early development**

The project is primarily a learning and experimentation project. Architecture, resource formats, rendering, gameplay, and build tooling may change significantly.

## License

This project is released under the MIT License. See [LICENSE](LICENSE).

## Disclaimer

**Changed** and its original characters/assets are the property of their respective creators. This repository is an unofficial fan/technical project and is not affiliated with the original creators.
