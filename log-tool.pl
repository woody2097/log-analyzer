#!/usr/bin/perl

# Keyword Array Colume Description
#   1. Keyword: 
#		- keyword to print out. 
#		- add back slash ("\") for special characters: ^ $ * . ? + [ ] ( ) \ | { } 
#	2. LineNo: 
#		- How many lines need to be printed followed by this keyword.
#		- e.g, 3: 3 lines print more.  
#		- default: 0 (Only print the line which includes "Keyword")
#	3. Don'tTouch: 
#		- Don't modify log message. 
#		- e.g, 1: Print log messages as an original shape. 
#		- default: 0 (Refine log messages by removing the front of the Keyword)

@keyWordArray = (
		#--------------------------------------------------------
		# Keyword						LineNo  	Don'tTouch 		 
		#								line no  	 
		#--------------------------------------------------------
		[ '\[SD\]', 					'', 		''			], 
		[ '\[BR\]', 					'', 		''			], 
		[ 'test', 	'',			''			],
		[ '', 	'',			''			],
		[ '', 	'',			''			],
		[ '', 	'',			''			],
		[ '', 	'',			''			],
		[ '', 	'',			''			],
		[ '', 	'',			''			],
		[ '', 	'',			''			],
		[ '', 	'',			''			],
		[ '', 	'',			''			],
		[ '', 	'',			''			],
		);




print "\n\n";
print "---------------------------------------------------------------------------------\n";
print "Log analyzer\n";
print "    Author: Woody Lee, woody2097@gmail.com \n";
	
if($#ARGV < 0) 
{ 
	print "    Pls input file name: \n";
	print "    - Print logs to terminal: perl log-tool.pl [log-file-name.txt] \n";
	print "    - Save logs into file:    perl log-tool.pl [log-file-name.txt] > [save-file-name.txt] \n";
	print "---------------------------------------------------------------------------------\n";
	die; 
}

$logFileName = shift(@ARGV);					# Get log file name from argument
my $templetFileName = "keyword.tpl";		

print "    Log File name: $logFileName\n";
print "---------------------------------------------------------------------------------\n";
printf( "%8s | %s\n","Line No", "Logs");
print "---------------------------------------------------------------------------------\n";


# open log file
# 	<: read only
#	>: Write only
open my $fileHandle, "<", $logFileName or die "Cannot open $logFileName. \n";

# print "There are $#keyWordArray arrays in Keyword array.\n";

my $eachLine;
my $refinedString;

$printMoreLines = 0;
$lineNumber = 0;

# read each line one by one
while($eachLine = <$fileHandle> ) {

	$lineNumber++;

	# check keyword in for loop
	for($elem = 0; $elem <= $#keyWordArray; $elem++) {
	
		$keyword = 					$keyWordArray[$elem]->[0];
		$printMoreLinesCnt = 		$keyWordArray[$elem]->[1];
		$conserveOriginalString = 	$keyWordArray[$elem]->[2];

		if ($keyword eq "") {
			next;
		}

		# if eachLine contains KeyWord, then handle it. 
		#    i means: Case insensitive
		if($eachLine =~ /$keyword/i) {

			if($conserveOriginalString  > 0) {
				print "$lineNumber | $eachLine";
			} else {
				# Get refined string: remove the part of string we don't have interest. 
				$myindex = index($eachLine, $keyword);
				# -1 means: No match found. 
				if($myindex >= 0) {
					$refinedString = substr $eachLine, index($eachLine, $keyword);
				} else {
					$refinedString = $eachLine;
				}
				printf( "%8d | %s",$lineNumber, $refinedString);
			}

			# check if there need to print more lines. 
			if($printMoreLinesCnt >= 1 ) {
				$printMoreLines = $printMoreLinesCnt;
			}

			# break: there is no need to check other items. 
			last;
		}
	}

	# print more lines.  read next line from log file. 
	if($printMoreLines > 0) {
		while($printMoreLines > 0) {
			$eachLine = <$fileHandle>;
			$lineNumber++;

			print "               $eachLine";
			$printMoreLines--;
		}
	}
}

close $fileHandle;

