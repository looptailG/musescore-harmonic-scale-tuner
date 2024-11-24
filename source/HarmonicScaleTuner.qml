/*
	Harmonic Scale Tuner plugin for Musescore.
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

import QtQuick 2.2
import FileIO 3.0
import MuseScore 3.0
import "libs/TuningUtils.js" as TU
import "libs/DateUtils.js" as DU
import "libs/StringUtils.js" as SU
import "libs/NoteUtils.js" as NU

MuseScore
{
	title: "Harmonic Scale Tuner";
	description: "Retune the selection, or the whole score if nothing is selected, to the harmonic scale.";
	categoryCode: "playback";
	thumbnailName: "HarmonicScaleTunerThumbnail.png";
	version: "1.0.0-rc2";
	
	property variant settings: {};
	
	property var referenceNote: "";
	property var referenceNoteRegex: /^\s*((in)?\s+?)?([A-G]|Do|Ut|Re|Mi|Fa|Sol|La|Si|Ti)(x|#|b|bb|\u{1D12B}|\u{266D}|\u{266E}|\u{266F}|\u{1D12A}|)\s*$/iu;
	
	// Amount of notes which were tuned successfully.
	property var tunedNotes: 0;
	// Total amount of notes encountered in the portion of the score to tune.
	property var totalNotes: 0;
	
	FileIO
	{
		id: logger;
		source: Qt.resolvedUrl(".").toString().substring(8) + "logs/" + DU.getFileDateTime() + "_log.txt";
		property var logMessages: "";
		property var currentLogLevel: 2;
		property variant logLevels:
		{
			0: " | TRACE   | ",
			1: " | INFO    | ",
			2: " | WARNING | ",
			3: " | ERROR   | ",
			4: " | FATAL   | ",
		}
		
		function log(message, logLevel)
		{
			if (logLevel === undefined)
			{
				logLevel = 1;
			}
			
			if (logLevel >= currentLogLevel)
			{
				logMessages += DU.getRFC3339DateTime() + logLevels[logLevel] + message + "\n";
				write(logMessages);
			}
		}
		
		function trace(message)
		{
			log(message, 0);
		}
		
		function warning(message)
		{
			log(message, 2);
		}
		
		function error(message)
		{
			log(message, 3);
		}
		
		function fatal(message)
		{
			log(message, 4);
		}
	}
	
	FileIO
	{
		id: settingsReader;
		source: Qt.resolvedUrl(".").toString().substring(8) + "Settings.tsv";
		
		onError:
		{
			logger.error(msg);
		}
	}
	
	onRun:
	{
		try
		{
			// Read settings file.
			settings = {};
			var settingsFileContent = settingsReader.read().split("\n");
			for (var i = 0; i < settingsFileContent.length; i++)
			{
				if (settingsFileContent[i].trim() != "")
				{
					var rowData = SU.parseTsvRow(settingsFileContent[i]);
					settings[rowData[0]] = rowData[1];
				}
			}
			logger.currentLogLevel = parseInt(settings["LogLevel"]);
			
			logger.log("-- Harmonic Scale Tuner -- Version " + version + " --");
			logger.log("Log level set to: " + logger.currentLogLevel);
			
			curScore.startCmd();
			
			// Calculate the portion of the score to tune.
			var cursor = curScore.newCursor();
			var startStaff;
			var endStaff;
			var startTick;
			var endTick;
			cursor.rewind(Cursor.SELECTION_START);
			if (!cursor.segment)
			{
				logger.log("Tuning the entire score.");
				startStaff = 0;
				endStaff = curScore.nstaves - 1;
				startTick = 0;
				endTick = curScore.lastSegment.tick + 1;
			}
			else
			{
				logger.log("Tuning only the current selection.");
				startStaff = cursor.staffIdx;
				startTick = cursor.tick;
				cursor.rewind(Cursor.SELECTION_END);
				endStaff = cursor.staffIdx;
				if (cursor.tick == 0)
				{
					// If the selection includes the last measure of the score,
					// .rewind() overflows and goes back to tick 0.
					endTick = curScore.lastSegment.tick + 1;
				}
				else
				{
					endTick = cursor.tick;
				}
				logger.trace("Tuning only ticks: " + startTick + " - " + endTick);
				logger.trace("Tuning only staffs: " + startStaff + " - " + endStaff);
			}
			
			tunedNotes = 0;
			totalNotes = 0;
			// Loop on the portion of the score to tune.
			for (var staff = startStaff; staff <= endStaff; staff++)
			{
				for (var voice = 0; voice < 4; voice++)
				{
					logger.log("Tuning Staff: " + staff + "; Voice: " + voice);
					
					cursor.voice = voice;
					cursor.staffIdx = staff;
					cursor.rewindToTick(startTick);
					
					referenceNote = settings["DefaultReferenceNote"];
					logger.log("Reference note reset to: " + referenceNote);

					// Loop on elements of a voice.
					while (cursor.segment && (cursor.tick < endTick))
					{
						// Check for reference note change.
						for (var i = 0; i < cursor.segment.annotations.length; i++)
						{
							var annotation = cursor.segment.annotations[i];
							var annotationPart = annotation.staff.part;
							if (
								((annotation.type === Element.STAFF_TEXT) && (4 * staff >= annotationPart.startTrack) && (4 * staff < annotationPart.endTrack))
								|| (annotation.type === Element.SYSTEM_TEXT)
							) {
								var annotationText = annotation.text;
								if (annotationText)
								{
									var match = annotationText.match(referenceNoteRegex);
									if (match)
									{
										var noteName = match[3].toUpperCase();
										if (noteName.length > 1)
										{
											switch (noteName)
											{
												case "DO":
												case "UT":
													noteName = "C";
													break;
												
												case "RE":
													noteName = "D";
													break;
												
												case "MI":
													noteName = "E";
													break;
												
												case "FA":
													noteName = "F";
													break;
												
												case "SOL":
													noteName = "G";
													break;
												
												case "LA":
													noteName = "A";
													break;
												
												case "SI":
												case "TI":
													noteName = "B";
													break;
												
												default:
													throw "Invalid note name: " + noteName;
											}
										}
										
										var accidental = match[4].toLowerCase();
										accidental = accidental = accidental.replace("\u{1D12B}", "bb");
										accidental = accidental.replace("\u{266D}", "b");
										accidental = accidental.replace("\u{266E}", "");
										accidental = accidental.replace("\u{266F}", "#");
										accidental = accidental.replace("\u{1D12A}", "x");
										
										referenceNote = noteName + accidental;
										logger.log("Reference note set to: " + referenceNote);
									}
								}
							}
						}
					
						// Tune notes.
						if (cursor.element && (cursor.element.type == Element.CHORD))
						{
							// Iterate through every grace chord.
							var graceChords = cursor.element.graceNotes;
							for (var i = 0; i < graceChords.length; i++)
							{
								var notes = graceChords[i].notes;
								for (var j = 0; j < notes.length; j++)
								{
									try
									{
										notes[j].tuning = calculateTuningOffset(notes[j]);
									}
									catch (error)
									{
										logger.error(error);
									}
								}
							}
								
							// Iterate through every chord note.
							var notes = cursor.element.notes;
							for (var i = 0; i < notes.length; i++)
							{
								try
								{
									notes[i].tuning = calculateTuningOffset(notes[i]);
								}
								catch (error)
								{
									logger.error(error);
								}
							}
						}

						cursor.next();
					}
				}
			}
			
			logger.log("Notes tuned: " + tunedNotes + " / " + totalNotes);
			
			curScore.endCmd();
		}
		catch (error)
		{
			logger.fatal(error);
		}
		finally
		{
			quit();
		}
	}

	/**
	 * Returns the amount of cents necessary to tune the input note to the
	 * harmonic scale.
	 */
	function calculateTuningOffset(note)
	{
		totalNotes += 1;
		
		try
		{
			var noteName = NU.getNoteLetter(note) + NU.getAsciiAccidental(note);
			logger.trace("Tuning note: " + noteName);
			var scaleDegree = NU.getSemitoneDistance(noteName, referenceNote);
			while (scaleDegree < 0)
			{
				scaleDegree += 12;
			}
			logger.trace("Scale degree: " + scaleDegree);
			var tuningOffset = TU.harmonicScaleOffset(scaleDegree);
			
			tunedNotes += 1;
			logger.trace("Final tuning offset: " + tuningOffset);
			return tuningOffset;
		}
		catch (error)
		{
			logger.error(error);
			// Leave the tuning of the input note unchanged.
			return note.tuning;
		}
	}
}
