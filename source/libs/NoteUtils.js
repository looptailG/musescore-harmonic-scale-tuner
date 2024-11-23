/*
	A collection of functions and constants about notes.
	Copyright (C) 2024 Alessandro Culatti

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

const VERSION = "1.1.0";

const SEMITONE_MAP = {
	"C": 0,
	"D": 2,
	"E": 4,
	"F": 5,
	"G": 7,
	"A": 9,
	"B": 11
};

/**
 * Return the english note name for the input note.
 */
function getNoteLetter(note, tpcMode = "tpc1")
{
	switch (note[tpcMode] % 7)
	{
		case 0:
			return "C";
		
		case 2:
		case -5:
			return "D";
		
		case 4:
		case -3:
			return "E";
		
		case 6:
		case -1:
			return "F";
		
		case 1:
		case -6:
			return "G";
		
		case 3:
		case -4:
			return "A";
		
		case 5:
		case -2:
			return "B";
	}
}

/**
 * Return the octave of the input note.
 */
function getOctave(note)
{
	return Math.floor(note.pitch / 12) - 1;
}

/**
 * Return the note accidental, written with ascii characters only.
 */
function getAsciiAccidental(note, tpcMode = "tpc1")
{
	var tpc = note[tpcMode];
	if ((-1 <= tpc) && (tpc <= 5))
	{
		return "bb";
	}
	else if ((6 <= tpc) && (tpc <= 12))
	{
		return "b"
	}
	else if ((13 <= tpc) && (tpc <= 19))
	{
		return "";
	}
	else if ((20 <= tpc) && (tpc <= 26))
	{
		return "#";
	}
	else if ((27 <= tpc) && (tpc <= 33))
	{
		return "x";
	}
	else
	{
		throw "Invalid tonal pitch class: " + tpc;
	}
}

/**
 * Return the distance in semitones between the input notes.
 */
function getSemitoneDistance(n1, n2)
{
	function getSemitone(note)
	{
		const match = note.match(/^([A-G])(bb|b|#|x)?$/);
		if (!match)
		{
			throw "Invalid note name: " + note;
		}
		
		const noteName = match[1];
		const accidental = match[2] || "";
		let semitone = SEMITONE_MAP[noteName];
		switch (accidental)
		{
			case "bb":
				semitone -= 2;
				break;
			
			case "b":
				semitone -= 1;
				break;
			
			case "":
				break;
			
			case "#":
				semitone += 1;
				break;
			
			case "x":
				semitone += 2;
				break;
			
			default:
				throw "Invalid accidental: " + accidental;
		}
		
		return (semitone + 12) % 12;
	}
	
	const s1 = getSemitone(n1);
	const s2 = getSemitone(n2);
	return s2 - s1;
}
