; Zachary Wileman
; Project 2: Recording Device

#include <reg932.inc>

ORG 0

;Sets ports 0-2 to be Quasi-bidirectional
MOV P0M1, #0
MOV P0M2, #0
MOV P1M1, #0
MOV P1M2, #0
MOV P2M1, #0
MOV P2M2, #0

MOV R0, #33H ;Sets where data will begin being recorded
MOV R5, #0 ;Used for counting the number of notes played

;Sits in this loop and checks for user input
START:
	ACALL CHECKBUTTON1
	ACALL CHECKBUTTON2
	ACALL CHECKBUTTON3
	ACALL CHECKBUTTON4
	ACALL RECORD
	ACALL PLAY
	SJMP START
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

CHECKBUTTON1:
	MOV C, P2.0
	JNC LIGHT1
	RET
LIGHT1:
	CPL P2.4
	MOV R7, #0 ;Resets counter
CB11:
	ACALL NOTE1
	INC R7 ;Counts the number of times the note iterates
	MOV C, P2.0
	JC CB12
	SJMP CB11
CB12:
	ACALL DELAY
	MOV C, P0.4
	JNC REC1 ;Jumps if rec light is on
RETURN1:
	CPL P2.4
	RET
REC1:
	; Adds data
	ACALL DELAY
	INC R5 ;Adds to the number of notes having been recorded
	MOV A, #1 ;1 is for Note 1
	MOV @R0, A
	INC R0
	MOV A, R7
	MOV @R0, A
	INC R0
	SJMP RETURN1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECKBUTTON2:
	MOV C, P0.1
	JNC LIGHT2
	RET
LIGHT2:
	CPL P0.5
	MOV R7, #0 ;Resets counter
CB21:
	ACALL NOTE2
	INC R7 ;Counts the number of times the note iterates
	MOV C, P0.1
	JC CB22
	SJMP CB21
CB22:
	ACALL DELAY
	MOV C, P0.4
	JNC REC2 ;Jumps if rec light is on
RETURN2:
	CPL P0.5
	RET
REC2:
	; Adds data
	ACALL DELAY
	INC R5 ;Adds to the number of notes having been recorded
	MOV A, #2 ;2 is for Note 1
	MOV @R0, A
	INC R0
	MOV A, R7
	MOV @R0, A
	INC R0
	SJMP RETURN2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHECKBUTTON3:
	MOV C, P0.2
	JNC LIGHT3
	RET
LIGHT3:
	CPL P0.6
	MOV R7, #0 ;Resets counter
CB31:
	ACALL NOTE3
	INC R7 ;Counts the number of times the note iterates
	MOV C, P0.2
	JC CB32
	SJMP CB31
CB32:
	ACALL DELAY
	MOV C, P0.4
	JNC REC3 ;Jumps if rec light is on
RETURN3:
	CPL P0.6
	RET
REC3:
	; Adds data
	ACALL DELAY
	INC R5 ;Adds to the number of notes having been recorded
	MOV A, #3 ;3 is for Note 1
	MOV @R0, A
	INC R0
	MOV A, R7
	MOV @R0, A
	INC R0
	SJMP RETURN3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHECKBUTTON4:
	MOV C, P1.4
	JNC LIGHT4
	RET
LIGHT4:
	CPL P1.6
	MOV R7, #0 ;Resets counter
CB41:
	ACALL NOTE4
	INC R7 ;Counts the number of times the note iterates
	MOV C, P1.4
	JC CB42
	SJMP CB41
CB42:
	ACALL DELAY
	MOV C, P0.4
	JNC REC4 ;Jumps if rec light is on
RETURN4:
	CPL P1.6
	RET
REC4:
	; Adds data
	ACALL DELAY
	INC R5 ;Adds to the number of notes having been recorded
	MOV A, #4 ;4 is for Note 1
	MOV @R0, A
	INC R0
	MOV A, R7
	MOV @R0, A
	INC R0
	SJMP RETURN4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NOTE1: ;C6 = ~1046Hz
	MOV 30H, #125
	M11: MOV 31H, #7
	M12: MOV 32H, #250
	M13: DJNZ 32H, M13
	DJNZ 31H, M12
	CPL P1.7
	DJNZ 30H, M11
	RET
		
NOTE2: ;F6 = ~1393Hz
	MOV 30H, #125
	M21: MOV 31H, #7
	M22: MOV 32H, #187
	M23: DJNZ 32H, M23
	DJNZ 31H, M22
	CPL P1.7
	DJNZ 30H, M21
	RET
		
NOTE3: ;G6 = ~1567Hz
	MOV 30H, #125
	M31: MOV 31H, #7
	M32: MOV 32H, #166
	M33: DJNZ 32H, M33
	DJNZ 31H, M32
	CPL P1.7
	DJNZ 30H, M31
	RET

NOTE4: ;A6 = ~1755Hz
	MOV 30H, #125
	M41: MOV 31H, #7
	M42: MOV 32H, #148
	M43: DJNZ 32H, M43
	DJNZ 31H, M42
	CPL P1.7
	DJNZ 30H, M41
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RECORD:
	MOV C, P0.0
	JNC RECORD2
	RET
RECORD2:
	MOV C, P0.0
	JC RECLIGHT
	SJMP RECORD2
RECLIGHT:
	ACALL DELAY
	MOV C, P0.4
	JC RL3 ;Jumps if rec light was off
	CPL P2.7
	CPL P0.4
	RET
RL3:
	MOV C, P2.7
	JC RL4 ;Jumps if play light is off
	CPL P2.7
	MOV R0, #33H ;Resets where to write data
RL4:
	CPL P0.4
	MOV R5, #0 ;Resets the number of notes played
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DELAY: ;Delay of about .01777 seconds
	MOV 30H, #255
	DELAYLP1: MOV 31H, #255
	DELAYLP2: DJNZ 31H, DELAYLP2
	DJNZ 30H, DELAYLP1
	RET
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
PLAY:
	MOV C, P2.3
	JNC PLAY2
	RET
PLAY2:
	MOV C, P2.3
	JC PLAY3
	SJMP PLAY2
PLAY3:
	ACALL DELAY
	MOV C, P2.7
	JNC PLAY4 ;Jump if the play light is on
	RET
PLAY4:
	ACALL PLAYSOUND ;Calls to play sound
	RET

PLAYSOUND:
	MOV 6, R5 ;Reads the number of notes played into R6 so that the value
			  ;of R5 can be saved, allowing you to play the sound repeatedly
	
	MOV R0, #33H ;Resets to where the notes are being read from
	CJNE R6, #1, NEXT
	NEXT:
		JC DONE2 ;Jumps if no input was recorded
	LOOP:
		MOV A, @R0
		MOV R1, A ;Gets the note recorded
		INC R0
		MOV A, @R0
		MOV R2, A ;Gets the length of note
		INC R0
		
		LOOP2: ;Checks which note to play
			CJNE R1, #1, NEXT1
			CPL P2.4
			ACALL NOTE1
			CPL P2.4
			SJMP DONE
			NEXT1: CJNE R1, #2, NEXT2
			CPL P0.5
			ACALL NOTE2
			CPL P0.5
			SJMP DONE
			NEXT2: CJNE R1, #3, NEXT3
			CPL P0.6
			ACALL NOTE3
			CPL P0.6
			SJMP DONE
			NEXT3:
			CPL P1.6
			ACALL NOTE4
			CPL P1.6
			DONE:
		DJNZ R2, LOOP2 ;Loops over the period of each note playing
		ACALL DELAY ;Adds a small delay in between each note being played
	DJNZ R6, LOOP ;Loops over the number of notes recorded
	
	DONE2:
	RET

END