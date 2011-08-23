# This script is supposed to go in a folder such as Users/gonzague/Library/Address Book Plug-Ins/
# replace serveur.fr/call.php by the path of your call.php file

using terms from application "Address Book"
	
	on action property
		return "phone"
	end action property
	
	on action title for p with e
		return "Appeler avec OVH - v3"
	end action title
	
	on should enable action for p with e
		if value of e is missing value then
			return false
		else
			return true
		end if
	end should enable action
	
	on perform action for p with e
		
		tell application "GrowlHelperApp"
			set the allNotificationsList to {"Telephonie"}
			set the enabledNotificationsList to {"Telephonie"}
			register as application ¬
				"Telephonie" all notifications allNotificationsList ¬
				default notifications enabledNotificationsList ¬
				icon of application "Telephone"
			notify with name "Telephonie" title "Téléphonie IP" description "Appel en cours" application name "Telephonie" --identifier "New Mail"
		end tell
		
		set Numero to the value of e
		set Numero to replace_chars(Numero, "+", "00")
		set Numero to replace_chars(Numero, " ", "")
		
		
		if ApplicationIsRunning("iTunes") then
			tell application "iTunes"
				set volumeitunes to the sound volume
				if player state is paused then
					""
				else
					
					tell application "GrowlHelperApp"
						notify with name "Telephonie" title "Téléphonie IP" description "Mise en pause de iTunes" application name "Telephonie"
					end tell
					set pauseitunes to true
					repeat
						--Fade down	
						repeat with i from volumeitunes to 0 by -1 --try by -4 on slower Macs
							set the sound volume to i
							delay 0.03 -- Adjust this to change fadeout duration (delete this line on slower Macs)
						end repeat
						pause
						--Restore original volume
						set the sound volume to volumeitunes
						exit repeat
					end repeat
				end if
				
			end tell
		end if
		
		if ApplicationIsRunning("Spotify") then
			
			tell application "Spotify"
				set volumespotify to the sound volume
				if player state is not paused then
					tell application "GrowlHelperApp"
						notify with name "Telephonie" title "Téléphonie IP" description "Mise en pause de Spotify" application name "Telephonie"
					end tell
					set pausespotify to true
					repeat
						--Fade down	
						repeat with i from volumespotify to 0 by -1 --try by -4 on slower Macs
							set the sound volume to i
							delay 0.03 -- Adjust this to change fadeout duration (delete this line on slower Macs)
						end repeat
						pause
						--Restore original volume
						set the sound volume to volumespotify
						exit repeat
					end repeat
					
				end if
			end tell
		end if
		
		tell application "Finder"
			say "telephone: call in progress"
		end tell
		
		tell application "GrowlHelperApp"
			notify with name "Telephonie" title "Téléphonie IP" description "Appel du " & Numero & " en cours" application name "Telephonie"
		end tell
		
		do shell script "curl -d c=\"XXXXXXXXXX\" -d n=\"" & Numero & "\" http://serveur.fr/call.php | textutil -stdin -stdout -format html -convert txt -encoding UTF-8 "
		
		delay 15
		
		repeat
			set question to display dialog "Avez vous terminé votre appel? " buttons {"Oui", "Non"} default button 1
			set answer to button returned of question
			if answer is equal to "Oui" then exit repeat
			if answer is not equal to "Oui" then
				delay 30
			end if
		end repeat
		
		
		if pauseitunes then
			tell application "iTunes"
				play
			end tell
		end if
		
		if pausespotify is true then
			tell application "Spotify"
				play
			end tell
		end if
		
		
		
	end perform action
	
end using terms from

on ApplicationIsRunning(appName)
	tell application "System Events" to set appNameIsRunning to exists (processes where name is appName)
	return appNameIsRunning
end ApplicationIsRunning

to replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars