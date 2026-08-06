# PSO Quest Editor
## Building
Open the .dproj file in Delphi (tested using Delphi 12 Community Edition) and optionally install (Component -> Install packages -> Add) the Designtime.bpl package file located in the Text editor folder, then build with Shift+F9.
DirectX 9c is required; the specific DLL is included in the source. 

From a Windows command prompt, `build.bat` performs the same Delphi project build while preserving the previous executable if the build fails.

## Map view

The 2D map renderer is selected from **Floor > Map render mode**:

- **Wireframe** is the default and draws the collision triangles using their surface flags.
- **Topographic** groups connected floor triangles into filled contours with outlined boundaries and interior triangulation.
- **Height shading** is available in Topographic mode and colors connected floors from low to high elevation with an on-map legend.

Both render modes follow the active light or dark theme. The arrow button beside **Visual Map** collapses or restores the upper editing controls so the map can use more of the window.

## Validation

Run the map topology regression suite with Node.js before committing renderer changes:

```text
node tests/validate-map-topology.js
```

The validator exercises synthetic containment edge cases and checks every bundled `map/*c.rel` resource for valid indices, closed contours, connected-component isolation, and strict hole containment.

The script text editor utilizes the TTextEditor control by Lasse Markus Rautiainen: https://github.com/TextEditorPro/TTextEditor

## Good to known
In Delphi the memory management for buffer was using a C like command allocmem and freemem, conveniently a string in the old version of Delphi was similar to a binary buffer with auto allocation. This was bad pratice but my young self didnt bother and used it everywhere. String start at 1 for the character array and you can use + to add to it.

The code is a mess and has few comment, i never bothered to improve it and recently only upgraded it to the latess Delphi version and did some bug fix.
