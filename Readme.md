# GraphicSVG Audio App

This is a simple demo showing how to add sound to GraphicSVG programs. Once started, sounds play until they are
done and cannot be stopped. More than one sound can be played at once.

You must import and use `audioApp` as your top-level application. Each update must return a tuple of
`(`Model, SoundCmd), where `SoundCmd` tells the app whether or not to play a sound:

```
type SoundCmd
    = PlaySound String -- (relative or absolute) url of sound to play
    | NoSound
```

See Main.elm for an example use (live demo [here](https://cschank.github.io/audioApp.html])).

You must include the included `index.html` file in the root of your project, and compile the Elm code from your
project directory with:

```
elm make src/<YourMainFile>.elm --output=app.js
```

Then, open or refresh `index.html` in your browser to see your program.