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
import MuseScore 3.0
import "libs/TuningUtils.js" as TU
import "libs/DateUtils.js" as DU

MuseScore
{
	title: "Harmonic Scale Tuner";
	description: "Retune the selection, or the whole score if nothing is selected, to the harmonic scale.";
	categoryCode: "playback";
	thumbnailName: "HarmonicScaleTunerThumbnail.png";
	version: "0.3.0-alpha";
	
	FileIO
	{
		id: logger;
		source: Qt.resolvedUrl(".").toString().substring(8) + "logs/" + DateUtils.getFileDateTime() + "_log.txt";
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
				logMessages += DateUtils.getRFC3339DateTime() + logLevels[logLevel] + message + "\n";
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
	
	onRun:
	{
		try
		{

		}
		catch (error)
		{
		
		}
		finally
		{
			quit();
		}
	}
}
