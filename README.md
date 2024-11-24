# Harmonic Scale Tuner
A Musescore plugin for tuning scores to the [Harmonic Scale](https://en.wikipedia.org/wiki/Harmonic_scale).

## Features
This plugin can be used to tune the whole score, or only a portion of it, to the Harmonic scale.

For example, if the fundamental note is `C`, the tuning offset of the notes is:

| Note | Harmonic | Offset (¢) |
| :--: | -------: | ---------: |
| `C` | 16 | 0 |
| `C♯` `D♭` | 17 | 4.96 |
| `D` | 18 | 3.91 |
| `D♯` `E♭` | 19 | -2.49 |
| `E` | 20 | -13.69 |
| `F` | 21 | -29.22 |
| `F♯` `G♭` | 22 | -48.68 |
| `G` | 24 | 1.96 |
| `G♯` `A♭` | 26 | 40.53 |
| `A` | 27 | 5.87 |
| `A♯` `B♭` | 28 | -31.17 |
| `B` | 30 | -11.73 |

By default `C` is the fundamental note, but can be changed by using a `System Text` (for changing it for every instrument) o a `Staff Text` (for changing it for the current instrument only) indicating the new fundamental note.
This text must be formatted as follows:
- Optionally it can have the text `in` at the beginning, followed by a space character.
- The new fundamental note, written either by using the english note names, or the solfege syllables.
- The accidental applied to the fundamental note, if any.  This can be written either by using the proper unicode characters for the musical accidentals, or with the ASCII characters `bb`, `b`, `#` and `x`.
This text is not case sensitive, and can be safely made invisible without affecting the plugin.
