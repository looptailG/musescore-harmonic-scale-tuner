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

By default `C` is the fundamental note, but it can be changed by using a `System Text` (for changing it for every instrument) or a `Staff Text` (for changing it for the current instrument only) indicating the new fundamental note.
This text must be formatted as follows:

- Optionally it can have the text `in` at the beginning, followed by a space character.
- The new fundamental note, written either by using the english note names, or the solfege syllables.
- The accidental applied to the fundamental note, if any.  This can be written either by using the proper unicode characters for the musical accidentals, or with the ASCII characters `bb`, `b`, `#` and `x`.

This text is not case sensitive, and can be safely made invisible without affecting the plugin.

This is an example of two changes of fundamental notes, first setting it to `B♭`, and then to `A♭`:

![immagine](https://github.com/user-attachments/assets/0eb1de21-6557-4541-94fc-55b57f4c38b2)


## Usage
- If you want to tune only a portion of the score, select it before running the plugin.  If nothing is selected, the entire score will be tuned.
- Launch the plugin: `Plugins` → `Playback` → `Harmonic Scale Tuner`


## Installing
- Download the file <code>harmonic_scale_tuner_x.y.z.zip</code>, where <code>x.y.z</code> is the version of the plugin.  You can find the latest version [here](https://github.com/looptailG/musescore-harmonic-scale-tuner/releases/latest).
- Extract the folder `harmonic_scale_tuner` and move it to Musescore's plugin folder.
- Follow the steps listed [here](https://musescore.org/en/handbook/4/plugins#enable-disable) to enable the plugin.
